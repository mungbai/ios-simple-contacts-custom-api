//
//  ViewController.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import UIKit
import Alamofire

/// `ViewController` is the main view controller of the application.
/// It manages the contacts list, handles user interactions, and communicates with the server.
class ViewController: UIViewController {

    /// The main view of the application
    let mainScreen = MainScreenView()

    /// Array to store Contact objects
    var contacts = [Contact]()

    // MARK: - Lifecycle Methods

    override func loadView() {
        view = mainScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"

        setupTableView()
        getAllContacts()
        setupAddButton()
        setupNotificationObserver()
    }

    // MARK: - Setup Methods

    /// Sets up the table view delegate and data source
    private func setupTableView() {
        mainScreen.tableViewContacts.delegate = self
        mainScreen.tableViewContacts.dataSource = self
    }

    /// Sets up the action for the Add Contact button
    private func setupAddButton() {
        mainScreen.buttonAdd.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
    }

    /// Sets up the notification observer for contact list updates
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(contactListUpdated), name: NSNotification.Name("ContactListUpdated"), object: nil)
    }

    // MARK: - Notification Handlers

    /// Handles the notification when the contact list is updated
    @objc func contactListUpdated() {
        getAllContacts()
    }

    // MARK: - API Calls

    /// Fetches all contacts from the server
    func getAllContacts() {
        if let url = URL(string: APIConfigs.baseURL + "getall") {
            AF.request(url, method: .get)
                .responseString { [weak self] response in
                    guard let self = self else { return }
                    
                    let status = response.response?.statusCode

                    switch response.result {
                    case .success(let data):
                        if let statusCode = status {
                            switch statusCode {
                            case 200...299:
                                self.handleSuccessfulGetAllContacts(data: data)
                            case 400...499:
                                print("Client error: \(data)")
                            default:
                                print("Server error: \(data)")
                            }
                        }
                    case .failure(let error):
                        print("Network error: \(error)")
                    }
                }
        }
    }

    /// Handles the successful response from getAllContacts
    /// - Parameter data: The response data containing contact names
    private func handleSuccessfulGetAllContacts(data: String) {
        var names = data.components(separatedBy: "\n")
        names = names.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        self.contacts = []
        let group = DispatchGroup()
        for name in names {
            group.enter()
            self.getContactDetails(name: name) { contact in
                if let contact = contact {
                    self.contacts.append(contact)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.mainScreen.tableViewContacts.reloadData()
        }
    }

    /// Adds a new contact to the server
    /// - Parameter contact: The Contact object to be added
    func addANewContact(contact: Contact) {
        if let url = URL(string: APIConfigs.baseURL + "add") {
            let parameters: [String: Any] = [
                "name": contact.name,
                "email": contact.email,
                "phone": contact.phone
            ]

            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .responseString { [weak self] response in
                    guard let self = self else { return }
                    
                    let status = response.response?.statusCode

                    switch response.result {
                    case .success(let data):
                        if let statusCode = status {
                            switch statusCode {
                            case 200...299:
                                self.getAllContacts()
                                self.clearAddViewFields()
                            case 400...499:
                                print("Client error: \(data)")
                            default:
                                print("Server error: \(data)")
                            }
                        }
                    case .failure(let error):
                        print("Network error: \(error)")
                    }
                }
        }
    }

    /// Fetches details of a specific contact from the server
    /// - Parameters:
    ///   - name: The name of the contact
    ///   - completion: A closure to be called with the fetched Contact object or nil if unsuccessful
    func getContactDetails(name: String, completion: @escaping (Contact?) -> Void) {
        if let url = URL(string: APIConfigs.baseURL + "details") {
            AF.request(url, method: .get, parameters: ["name": name], encoding: URLEncoding.queryString)
                .responseString { response in
                    let status = response.response?.statusCode

                    switch response.result {
                    case .success(let data):
                        if let statusCode = status {
                            switch statusCode {
                            case 200...299:
                                self.parseContactDetails(data: data, completion: completion)
                            case 400...499:
                                print("Client error: \(data)")
                                completion(nil)
                            default:
                                print("Server error: \(data)")
                                completion(nil)
                            }
                        } else {
                            completion(nil)
                        }
                    case .failure(let error):
                        print("Network error: \(error)")
                        completion(nil)
                    }
                }
        } else {
            completion(nil)
        }
    }

    /// Parses the contact details from the server response
    /// - Parameters:
    ///   - data: The response data containing contact details
    ///   - completion: A closure to be called with the parsed Contact object or nil if parsing fails
    private func parseContactDetails(data: String, completion: (Contact?) -> Void) {
        let parts = data.components(separatedBy: ",")
        if parts.count == 3 {
            let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let email = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            if let phone = Int(parts[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
                let contact = Contact(name: name, email: email, phone: phone)
                completion(contact)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }

    // MARK: - User Interaction Handlers

    /// Handles the tap action on the Add Contact button
    @objc func onButtonAddTapped() {
        if let name = mainScreen.textFieldAddName.text,
           let email = mainScreen.textFieldAddEmail.text,
           let phoneText = mainScreen.textFieldAddPhone.text,
           !name.isEmpty, !email.isEmpty, !phoneText.isEmpty,
           isValidEmail(email),
           let phone = Int(phoneText) {

            let contact = Contact(name: name, email: email, phone: phone)
            addANewContact(contact: contact)
        } else {
            showAlert(title: "Invalid Input", message: "Please enter valid details.")
        }
    }

    // MARK: - Helper Methods

    /// Clears the input fields in the Add Contact view
    func clearAddViewFields() {
        mainScreen.textFieldAddName.text = ""
        mainScreen.textFieldAddEmail.text = ""
        mainScreen.textFieldAddPhone.text = ""
    }

    /// Validates an email address using a simple regex pattern
    /// - Parameter email: The email address to validate
    /// - Returns: A boolean indicating whether the email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    /// Shows an alert with the given title and message
    /// - Parameters:
    ///   - title: The title of the alert
    ///   - message: The message body of the alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - TableView Delegate and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainScreen.tableViewContacts.dequeueReusableCell(withIdentifier: "names", for: indexPath) as! ContactsTableViewCell
        cell.labelName.text = contacts[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = self.contacts[indexPath.row]
        let detailVC = ContactDetailViewController()
        detailVC.contact = selectedContact
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Potential Enhancements

// TODO: Consider adding the following enhancements:
// 1. Implement error handling and user feedback for network errors
// 2. Add pull-to-refresh functionality for the contacts list
// 3. Implement local caching of contacts for offline access
// 4. Add search functionality for contacts
// 5. Implement pagination for large contact lists
// 6. Add sorting options for the contacts list
