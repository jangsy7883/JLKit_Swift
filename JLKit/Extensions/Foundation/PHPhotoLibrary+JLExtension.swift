//
//  PHPhotoLibrary+Extension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2020/06/29.
//  Copyright © 2020 Woody. All rights reserved.
//

import Foundation
import Photos

extension PHPhotoLibrary {
    public static func authorizationStatus(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    handler(status)
                }
            }
        } else {
            handler(status)
        }
    }
}
