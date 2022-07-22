//
//  StringValidationExtensions.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 18/07/2022.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        // One or more characters followed by an "@",
        // then one or more characters followed by a ".",
        // and finishing with one or more characters
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        // Matching Examples
        // user@domain.com
        // firstname.lastname-work@domain.com
        
        // "test@test.com" matches emailPattern,
        // so result is a Range<String.Index>
        let result = self.range(
            of: emailPattern,
            options: .regularExpression
        )
        
        let validEmail = (result != nil)
        return validEmail
    }
    
    /// - A valid password should contains:
    /// - at least one uppercase letter,
    /// - at least one digit,
    /// - at least one lowercase letter,
    /// - at least 7 characters total.
    func isValidPassword() -> Bool {
        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{7,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
}
