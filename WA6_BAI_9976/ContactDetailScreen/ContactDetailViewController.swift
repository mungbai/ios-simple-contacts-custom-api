//
//  ContactDetailViewController.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import UIKit
import Alamofire

/// `ContactDetailViewController` is responsible for displaying and managing the detailed view of a contact.
/// It handles user interactions such as editing and deleting contacts, and communicates with the server for these operations.
class ContactDetailViewController: UIViewController {

    // MARK: - Properties

    /// The main view for displaying contact details
    let detailView = ContactDetailView()

    /// The contact object to be displayed and managed
    var contact: Contact!

    // MARK: - Lifecycle Methods

    /// Overrides the loadView method to set the detailView as the main view of the controller
    override func loadView() {
        view = detailView
    }

    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contact Details"

        // Configure the UI with contact data
        detailView.configure(with: contact)

        // Set up button actions
        setupButtonActions()

        // Set up notification observer
        setupNotificationObserver()
    }

    // MARK: - Setup Methods

    /// Sets up target actions for the buttons in the detail view
    private func setupButtonActions() {
        detailView.editButton.addTarget(self, action: #selector(editContact), for: .touchUpInside)
        detailView.deleteButton.addTarget(self, action: #selector(deleteContact), for: .touchUpInside)
        detailView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }

    /// Sets up an observer for contact list update notifications
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contactListUpdated),
                                               name: NSNotification.Name("ContactListUpdated"),
                                               object: nil)
    }

    // MARK: - Button Actions

    /// Handles the edit button tap action
    /// Pushes a new ContactEditViewController onto the navigation stack
    @objc func editContact() {
        let editVC = ContactEditViewController()
        editVC.contact = self.contact
        self.navigationController?.pushViewController(editVC, animated: true)
    }

    /// Handles the delete button tap action
    /// Shows an alert to confirm deletion before proceeding
    @objc func deleteContact() {
        // Show AlertController to confirm deletion
        let alertController = UIAlertController(title: "Delete Contact",
                                                message: "Are you sure you want to delete this contact?",
                                                preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteContactFromServer()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }

    /// Sends a request to the server to delete the contact
    func deleteContactFromServer() {
        if let url = URL(string: APIConfigs.baseURL + "delete") {
            let parameters: [String: String] = ["name": self.contact.name]

            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .responseString { response in
                    let statusCode = response.response?.statusCode

                    switch response.result {
                    case .success(let data):
                        if let code = statusCode, 200...299 ~= code {
                            // Deletion successful
                            // Notify main screen
                            NotificationCenter.default.post(name: NSNotification.Name("ContactListUpdated"), object: nil)
                            // Pop back to main screen
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            // Show error message
                            self.showAlert(title: "Error", message: "Failed to delete contact. \(data)")
                        }
                    case .failure(let error):
                        // Network error
                        self.showAlert(title: "Error", message: "Network error: \(error.localizedDescription)")
                    }
                }
        } else {
            self.showAlert(title: "Error", message: "Invalid URL.")
        }
    }

    /// Handles the back button tap action
    /// Pops the current view controller from the navigation stack
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    /// Handles the notification when the contact list is updated
    /// This method is called when a "ContactListUpdated" notification is received
    @objc func contactListUpdated() {
        // Update the contact details if necessary
        // In this example, we assume the contact has been updated or deleted
        // Pop back if the contact was deleted
        // Or refresh the details if updated
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper Methods

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
