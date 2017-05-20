//
//  UITetField+AccessoryDone.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    final func addAccessoryDone() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        doneBarButton.tintColor = Colors.APP_BLUE_COLOR
        self.inputAccessoryView = keyboardToolbar
    }
    
    final func dismissKeyboard() {
        self.resignFirstResponder()
    }
    
}
