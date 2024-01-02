//
//  UINavigationController.swift
//

import UIKit


extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = nil
    }
}

