//
//  Error+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 17..
//  Copyright © 2018년 Goodoc. All rights reserved.
//

import Foundation

extension Error {
    public func showAlertWithActionTitle(_ title: String!) {
        guard let viewController = UIViewController.topMostViewController() else { return }
        let alertController = UIAlertController(title: nil, message: localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: title, style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
