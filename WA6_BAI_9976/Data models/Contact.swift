//
//  Contact.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import Foundation

/// `Contact` is a struct that represents a single contact in the application.
/// It encapsulates the basic information needed for a contact: name, email, and phone number.
struct Contact {
    // MARK: - Properties
    
    /// The name of the contact
    var name: String
    
    /// The email address of the contact
    var email: String
    
    /// The phone number of the contact
    /// Note: This is stored as an Int, which might not be suitable for all phone number formats
    /// Consider using String for more flexibility in phone number representation
    var phone: Int
    
    // MARK: - Initializer
    
    /// Initializes a new Contact instance
    /// - Parameters:
    ///   - name: The name of the contact
    ///   - email: The email address of the contact
    ///   - phone: The phone number of the contact
    init(name: String, email: String, phone: Int) {
        self.name = name
        self.email = email
        self.phone = phone
    }
    
    // MARK: - Potential Enhancements
    
    // TODO: Consider adding the following enhancements:
    // 1. Implement Codable protocol for easy encoding/decoding
    // 2. Add validation logic for email and phone number
    // 3. Provide a custom string representation (implement CustomStringConvertible)
    // 4. Add computed properties for formatted phone number or initials
}
