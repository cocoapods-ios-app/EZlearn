//
//  FieldExtension.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/13/22.
//

import Foundation
import UIKit

/**
 Extension is from https://stackoverflow.com/questions/37873119/how-to-toggle-a-uitextfield-secure-text-entry-hide-password-in-swift
 */
extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
