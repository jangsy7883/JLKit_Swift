//
//  Error+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 1. 17..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Error {
    #if os(iOS)
    public func showAlertWithActionTitle(_ title: String!) {
        guard let viewController = UIViewController.topMost() else { return }
        let alertController = UIAlertController(title: nil, message: localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: title, style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    #endif
}
