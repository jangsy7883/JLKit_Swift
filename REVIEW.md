# JLKit 전체 검토 — 2026-09-09

현재 작업 트리의 Swift 구현, Objective-C 선택형 구현, Package.swift, podspec, 데모 테스트를 검토했다. 기존 String+JLExtension.swift 미커밋 변경도 검토 대상에 포함했으며 소스는 수정하지 않았다.

## 우선 수정할 문제

### [P1] 배열 safe 범위 접근이 안전하지 않음
[JLKit/Extensions/SwiftStdlib/Array+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/SwiftStdlib/Array+JLExtension.swift:26)

[10,20,30][safe: 0...1]이 [10]만 반환한다. ClosedRange의 마지막 원소가 누락된다. [safe: 5..<8]은 lowerBound > upperBound인 범위를 만들어 실제로 종료됐다. 양 끝을 배열 경계 안으로 제한하고, 닫힌 범위의 포함 규칙과 교집합이 없는 경우를 처리해야 한다.

### [P1] 셀을 찾지 못하면 무한 반복
[JLKit/Extensions/UIKit/UITableView+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/UIKit/UITableView+JLExtension.swift:21)

indexPath(forCellContainingView:)에 셀에 속하지 않는 UIView를 전달하면 최상위 뷰에서 superview가 nil이 되어 view가 갱신되지 않는다. 메인 스레드에서 호출하면 화면이 멈춘다. UICollectionView+JLExtension.swift:29에도 동일한 구현이 있다. 매 반복마다 view = view?.superview로 진행해야 한다. 정적 분석으로 확인했다.

### [P1] 정상적인 음수 난수 범위에서 종료
[JLKit/Extensions/SwiftStdlib/Int+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/SwiftStdlib/Int+JLExtension.swift:12)

Int.random(min: -2, max: 2)는 UInt32(min)에서 실제로 종료됐다. UInt32 범위를 넘는 양수나 큰 범위도 변환·덧셈 오버플로가 발생한다. Swift.random(in:)에 위임하면 유효한 Int 범위를 지원할 수 있다.

### [P1] 이전 원소 탐색이 시작 인덱스 이전에 접근
[JLKit/Extensions/Foundation/CaseIterable+Extension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/Foundation/CaseIterable+Extension.swift:44)

"abc".element(before: "a", wrapping: true)가 실제로 종료됐다. 경계 검사 전에 index(before:)를 호출하기 때문이다. wrapping이 false여도 같다. CaseIterable.previous():15도 같은 순서라 사용자 정의 AllCases 컬렉션에서 문제가 된다. 먼저 startIndex와 비교해야 한다.

### [P2] 상대 날짜의 기준 인자를 무시
[JLKit/Extensions/Foundation/Date+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/Foundation/Date+JLExtension.swift:67)

toLocalizedRelative(to:)가 date 대신 Date()를 전달한다. 1970년 날짜를 자기 자신과 비교했는데 실행 결과가 “56년 전”이었다. relativeTo: date로 수정해야 한다.

### [P2] 딕셔너리 경로가 끝까지 일치하지 않아도 성공
[JLKit/Extensions/SwiftStdlib/Dictionary+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/SwiftStdlib/Dictionary+JLExtension.swift:17)

["a": 1][keyPath: "a.b"]가 nil 대신 1을 반환하는 것을 실행 확인했다. 남은 경로가 있으면 반드시 하위 딕셔너리를 요구해야 한다. 같은 파일 valueForKeys([1])도 [1: "one"]에서 nil을 반환한다. Key 전체를 받으면서 String 키만 처리하므로 직접 키 조회와 문자열 경로 조회를 구분해야 한다.

### [P2] 빈 섹션에서 존재하지 않는 마지막 항목 반환
[JLKit/Extensions/UIKit/UICollectionView+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/UIKit/UICollectionView+JLExtension.swift:49)

항목 수가 0인데 IndexPath(item: 0, section: section)을 반환한다. 반환값을 일반 scrollToItem 등에 쓰면 유효하지 않은 항목에 접근한다. 빈 섹션에서는 nil을 반환해야 한다.

### [P2] 테이블 인덱스 검사에서 음수를 누락
[JLKit/Extensions/UIKit/UITableView+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/UIKit/UITableView+JLExtension.swift:12)

row와 section의 상한만 검사한다. 유효한 섹션의 row = -1을 true로 판정하고, 음수 section은 UIKit 조회로 전달한다. UICollectionView 쪽과 같이 두 값의 하한을 먼저 검사해야 한다.

### [P2] 회전된 이미지의 표시 좌표와 원본 픽셀 좌표 혼동
[JLKit/Extensions/UIKit/UIImage+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/UIKit/UIImage+JLExtension.swift:128)

crop(bounds:)는 표시용 포인트 좌표에 scale만 곱해 cgImage를 자른다. imageOrientation이 left/right 또는 mirrored인 사진은 좌표 변환이 추가로 필요하다. 표시 방향을 정규화한 뒤 자르거나 원본 좌표로 변환해야 한다. cropToSquare()에도 영향을 준다. 정적 분석이며 기기 이미지 검증은 수행하지 않았다.

### [P2] 빈 속성으로 문자열을 붙이면 텍스트가 사라짐
[JLKit/Extensions/Foundation/NSAttributedString+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/Foundation/NSAttributedString+JLExtension.swift:82)

appendString("hello", attributes: [:])가 아무것도 붙이지 않는다. 빈 속성은 서식 없는 유효한 텍스트이므로 attributes.isEmpty 조건을 제거하는 것이 자연스럽다.

### [P2] 바이트 표시 옵션 무시
[JLKit/Extensions/Foundation/Data+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/Foundation/Data+JLExtension.swift:12)

byteString(countStyle:)는 전달값 대신 항상 .file을 설정한다. .binary를 전달해도 같은 설정을 사용한다. bcf.countStyle = countStyle로 변경해야 한다.

### [P2] 유효하지 않은 좌표 요청이 완료되지 않음
[JLKit/Extensions/Foundation/CLGeocoder+JLExtension.swift](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Extensions/Foundation/CLGeocoder+JLExtension.swift:14)

좌표가 유효하지 않으면 completion을 호출하지 않고 반환한다. 호출부의 로딩 종료 또는 continuation 재개가 콜백에 의존하면 계속 대기한다. 오류를 전달하고 완료시키는 것이 필요하다.

### [P2] Objective-C 나이 계산에서 생일을 비교하지 못함
[JLKit/Objcs/Foundation/NSDate+JLAge.m](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Objcs/Foundation/NSDate+JLAge.m:13)

연도만 추출하고 components.date를 비교한다. 월·일과 캘린더가 없는 구성요소로 생일 경과 여부를 판단할 수 없다. 올해 생일이 아직 오지 않은 경우도 연도 차이를 반환한다. Calendar의 두 날짜 사이 완성된 연도 차이를 사용해야 한다. 선택형 Objcs 배포에 해당한다.

### [P2] Objective-C HEX 알파를 255로 나누지 않음
[JLKit/Objcs/UIKit/UIColor+JLKit.m](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Objcs/UIKit/UIColor+JLKit.m:36)

4자리·8자리 HEX는 0...255인 알파 정수를 RGBA 매크로에 전달하지만 매크로는 알파를 정규화하지 않는다. #80FF0000 같은 반투명 색이 잘못 생성된다. 알파도 255.0으로 나눠야 한다. 또한 isValidHex는 길이만 검사하고, scanHexInt 실패 시 초기화되지 않은 값을 사용한다.

### [P2] Objective-C 이미지 방향 인자 무시
[JLKit/Objcs/UIKit/UIImage+JLKit.m](/Users/jangsy/Library/CloudStorage/Dropbox/5_Developer/JangLOng/Open/JLKit_Swift/JLKit/Objcs/UIKit/UIImage+JLKit.m:25)

imageNamed:orientation:은 전달한 orientation과 관계없이 UIImageOrientationLeft를 사용한다. 또한 원본 image.scale 대신 화면 배율을 사용한다. 전달한 방향과 원본 배율을 보존해야 한다.

## 중복과 정리 후보

- Float.pixel / CGFloat.pixel: 완전히 같은 계산이며 반환형도 CGFloat다. CGFloat 쪽을 공통 구현으로 삼을 수 있다.
- UIApplication.version/buildNumber와 Bundle.appVersion/buildVersion: 같은 Info.plist 값을 읽는다. Bundle 구현에 위임하면 유지보수 지점을 줄일 수 있다.
- FileManager.directoryURL/directoryPath, containerURL/groupDirectoryPath: 경로 생성 역할이 겹치지만 디렉터리 생성 여부와 오류 처리 방식이 다르다. 대표 API로 통합하고 기존 API는 위임하는 편이 안전하다.
- CaseIterable.previous/next와 Collection.element(before/after): 경계 처리 구현을 공유하면 이번 오류도 한 곳에서 수정할 수 있다.
- UITextField/UITextView.maxLength: 조합 중인 텍스트 판정과 잘라내기 구현이 거의 같다. 공통 판단 로직으로 추출하고 한글 입력·중간 삽입·붙여넣기를 함께 검증할 수 있다.
- UIEdgeInsets 두 파일은 기능이 서로 달라 중복 선언은 아니다. 파일만 합치는 정리 대상이다.
- UIStoryboard.Name.viewController, UIStoryboard.viewController, UIViewController.instantiate: 생성 방식과 반환 타입이 겹친다. bundle 지정까지 포함한 대표 구현을 둘 수 있다.
- Swift/Objective-C의 색상·이미지·문자열·배열 도우미는 역할이 중복된다. Objective-C 소비자가 있다면 유지할 이유가 있지만, 현재 HEX 처리처럼 동작이 달라질 수 있으므로 같은 입력의 결과를 비교해야 한다.
- Int.random(min:max:), UISearchBar.textField, DiffableDataSource의 단순 위임 메서드는 각각 표준 random(in:), searchTextField, 원래 apply API를 직접 사용할 수 있어 추가 가치가 작다. 공개 API이므로 제거 전 사용처와 호환성을 확인해야 한다.
- Foundation/Range+JLExtension.swift는 주석 처리된 코드만 있다. Date의 미사용 초 상수와 주석 처리된 과거 구현도 정리할 수 있다.

## 추가 경계 조건 및 설계 확인

- Array.division(length: 0), String.random(length: 음수), UITextField/UITextView.maxLength < 0, Task.sleep(seconds: 음수/NaN/무한대), randomElements(UInt.max)는 현재 입력 검증이 없다. 허용 범위를 문서화하고 오류·빈 결과·값 제한 중 정책을 결정해야 한다.
- Date.interval은 기본적으로 여러 단위를 동시에 요청해 “총 일수/시간”이 아닌 분해된 성분을 반환한다. 총량이 목적이면 요청한 단위 하나만 사용해야 한다. 현재 의도가 명시되지 않아 확정 버그로 분류하지 않았다.
- FileManager의 디렉터리 생성 메서드는 try?로 실패를 숨긴 채 URL을 반환한다. URL.createDirectory도 같은 이름의 일반 파일이 존재하면 성공처럼 반환한다. 경로 반환과 생성 성공 보장을 분리하는 것이 좋다.
- UIFont.bold/italic은 optional descriptor를 강제 해제한다. 이미 안전하게 구현된 withTraits에 위임하면 실패 시 원본 반환 정책을 공유할 수 있다.
- UICollectionView.performBatchUpdates(animated:)는 전역 애니메이션 설정을 비동기 completion까지 유지한다. 겹치는 호출은 복원 순서에 따라 전역 상태가 달라질 수 있다. 변경 범위를 동기 업데이트 블록에 한정하는 방식을 검토해야 한다.

## 검증 결과와 한계

- Swift 전체 파일: iOS Simulator, arm64, 최소 iOS 16, Swift 5 모드 타입 검사 통과.
- Swift 전체 파일: watchOS Simulator, arm64, 최소 watchOS 9, Swift 5 모드 타입 검사 통과.
- iOS 검사에서는 UIFont feature 키와 UIButton inset API 사용 중단 경고가 나왔다.
- macOS에서 관련 원본 Foundation/표준 라이브러리 파일들을 임시 실행 파일로 묶어 배열 결과 누락·범위 종료, 음수 난수 종료, String 이전 원소 종료, 딕셔너리 결과 오류, 상대 날짜 인자 무시를 확인했다.
- UIKit 동작과 Objective-C 항목은 소스 검토 결과다. 시뮬레이터 앱 실행, CocoaPods 통합 빌드, 이미지·한글 입력 실기기 검증은 수행하지 않았다.
- Package.swift에 testTarget이 없고 기존 UI 테스트 testExample은 비어 있다. 이번에 확인한 경계 조건을 자동 회귀 테스트로 추가하는 것이 우선이다.
