//
//  ContactEditViewController.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import UIKit
import Alamofire

/// `ContactEditViewController` is responsible for managing the editing of a contact's information.
/// It handles user interactions, data validation, and communicates with the server to update contact information.
class ContactEditViewController: UIViewController {

    // MARK: - Properties

    /// The main view for editing contact details
    let editView = ContactEditView()

    /// The contact object to be edited
    var contact: Contact!

    // MARK: - Lifecycle Methods

    /// Overrides the loadView method to set the editView as the main view of the controller
    override func loadView() {
        view = editView
    }

    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Contact"

        // Configure the UI with contact data
        populateFields()

        // Add target actions for buttons
        setupButtonActions()
    }

    // MARK: - Setup Methods

    /// Populates the text fields with the current contact's information
    private func populateFields() {
        editView.nameTextField.text = contact.name
        editView.emailTextField.text = contact.email
        editView.phoneTextField.text = "\(contact.phone)"
    }

    /// Sets up target actions for the buttons in the edit view
    private func setupButtonActions() {
        editView.saveButton.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
        editView.cancelButton.addTarget(self, action: #selector(cancelEdit), for: .touchUpInside)
    }

    // MARK: - Action Methods

    /// Handles the save button tap action
    /// Validates input and initiates the process of updating the contact on the server
    @objc func saveContact() {
        // Validate inputs
        guard let name = editView.nameTextField.text, !name.isEmpty,
              let email = editView.emailTextField.text, !email.isEmpty,
              let phoneText = editView.phoneTextField.text, !phoneText.isEmpty,
              isValidEmail(email),
              let phone = Int(phoneText) else {
            // Show validation error
            showAlert(title: "Invalid Input", message: "Please enter valid details.")
            return
        }

        let updatedContact = Contact(name: name, email: email, phone: phone)

        // First, delete the old contact
        deleteContactFromServer(oldContact: self.contact) { success in
            if success {
                // Then, add the updated contact
                self.addContactToServer(contact: updatedContact) { success in
                    if success {
                        // Notify main screen and detail screen
                        NotificationCenter.default.post(name: NSNotification.Name("ContactListUpdated"), object: nil)
                        // Pop back to the detail screen
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showAlert(title: "Error", message: "Failed to save contact.")
                    }
                }
            } else {
                self.showAlert(title: "Error", message: "Failed to save contact.")
            }
        }
    }

    /// Deletes the old contact from the server
    /// - Parameters:
    ///   - oldContact: The contact to be deleted
    ///   - completion: A closure to be executed upon completion, with a boolean indicating success
    func deleteContactFromServer(oldContact: Contact, completion: @escaping (Bool) -> Void) {
        if let url = URL(string: APIConfigs.baseURL + "delete") {
            let parameters: [String: String] = ["name": oldContact.name]

            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .responseString { response in
                    let statusCode = response.response?.statusCode

                    switch response.result {
                    case .success(let data):
                        if let code = statusCode, 200...299 ~= code {
                            // Deletion successful
                            completion(true)
                        } else {
                            // Deletion failed
                            print("Deletion failed: \(data)")
                            completion(false)
                        }
                    case .failure(let error):
                        // Network error
                        print("Deletion network error: \(error)")
                        completion(false)
                    }
                }
        } else {
            completion(false)
        }
    }

    /// Adds the updated contact to the server
    /// - Parameters:
    ///   - contact: The contact to be added
    ///   - completion: A closure to be executed upon completion, with a boolean indicating success
    func addContactToServer(contact: Contact, completion: @escaping (Bool) -> Void) {
        if let url = URL(string: APIConfigs.baseURL + "add") {
            let parameters: [String: Any] = [
                "name": contact.name,
                "email": contact.email,
                "phone": contact.phone
            ]

            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .responseString { response in
                    let statusCode = response.response?.statusCode

                    switch response.result {
                    case .success(let data):
                        if let code = statusCode, 200...299 ~= code {
                            // Addition successful
                            completion(true)
                        } else {
                            // Addition failed
                            print("Addition failed: \(data)")
                            completion(false)
                        }
                    case .failure(let error):
                        // Network error
                        print("Addition network error: \(error)")
                        completion(false)
                    }
                }
        } else {
            completion(false)
        }
    }

    /// Handles the cancel button tap action
    /// Dismisses the edit view and returns to the previous screen
    @objc func cancelEdit() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper Methods

    /// Validates an email address using a simple regex pattern
    /// - Parameter email: The email address to validate
    /// - Returns: A boolean indicating whether the email is valid
    func isValidEmail(_ email: String) -> Bool {
        // Simple regex for email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    /// Shows an alert with the given title and message
    /// - Parameters:
    ///   - title: The title of the alert
    ///   - message: The message body of the alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
