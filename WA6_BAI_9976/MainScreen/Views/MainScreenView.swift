//
//  MainScreenView.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import UIKit

/// `MainScreenView` is a custom UIView subclass that represents the main screen of the application.
/// It contains a table view for displaying contacts and a form for adding new contacts.
class MainScreenView: UIView {
    // MARK: - Properties

    /// Table view for displaying the list of contacts
    var tableViewContacts: UITableView!

    /// Container view for the "Add Contact" form
    var bottomAddView: UIView!

    /// Text field for entering the name of a new contact
    var textFieldAddName: UITextField!

    /// Text field for entering the email of a new contact
    var textFieldAddEmail: UITextField!

    /// Text field for entering the phone number of a new contact
    var textFieldAddPhone: UITextField!

    /// Button to submit the new contact information
    var buttonAdd: UIButton!

    // MARK: - Initialization

    /// Initializes a new instance of MainScreenView
    /// - Parameter frame: The frame rectangle for the view, used by the superclass
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupTableViewContacts()
        setupBottomAddView()
        setupTextFieldAddName()
        setupTextFieldAddEmail()
        setupTextFieldAddPhone()
        setupButtonAdd()

        initConstraints()
    }

    /// Required initializer for using MainScreenView with Interface Builder
    /// Not implemented as this view is created programmatically
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    /// Sets up the table view for displaying contacts
    func setupTableViewContacts() {
        tableViewContacts = UITableView()
        tableViewContacts.register(ContactsTableViewCell.self, forCellReuseIdentifier: "names")
        tableViewContacts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewContacts)
    }

    /// Sets up the container view for the "Add Contact" form
    func setupBottomAddView() {
        bottomAddView = UIView()
        bottomAddView.backgroundColor = .white
        bottomAddView.layer.cornerRadius = 6
        bottomAddView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomAddView.layer.shadowOffset = .zero
        bottomAddView.layer.shadowRadius = 4.0
        bottomAddView.layer.shadowOpacity = 0.7
        bottomAddView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomAddView)
    }

    /// Sets up the text field for entering a new contact's name
    func setupTextFieldAddName() {
        textFieldAddName = UITextField()
        textFieldAddName.placeholder = "Name"
        textFieldAddName.borderStyle = .roundedRect
        textFieldAddName.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textFieldAddName)
    }

    /// Sets up the text field for entering a new contact's email
    func setupTextFieldAddEmail() {
        textFieldAddEmail = UITextField()
        textFieldAddEmail.placeholder = "Email"
        textFieldAddEmail.borderStyle = .roundedRect
        textFieldAddEmail.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textFieldAddEmail)
    }

    /// Sets up the text field for entering a new contact's phone number
    func setupTextFieldAddPhone() {
        textFieldAddPhone = UITextField()
        textFieldAddPhone.placeholder = "Phone"
        textFieldAddPhone.borderStyle = .roundedRect
        textFieldAddPhone.keyboardType = .numberPad
        textFieldAddPhone.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textFieldAddPhone)
    }

    /// Sets up the button for adding a new contact
    func setupButtonAdd() {
        buttonAdd = UIButton(type: .system)
        buttonAdd.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonAdd.setTitle("Add Contact", for: .normal)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(buttonAdd)
    }

    // MARK: - Constraints

    /// Sets up the auto layout constraints for all subviews
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Bottom add view constraints
            bottomAddView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            bottomAddView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomAddView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),

            // Add button constraints
            buttonAdd.bottomAnchor.constraint(equalTo: bottomAddView.bottomAnchor, constant: -8),
            buttonAdd.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 4),
            buttonAdd.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -4),
            buttonAdd.heightAnchor.constraint(equalToConstant: 44),

            // Phone text field constraints
            textFieldAddPhone.bottomAnchor.constraint(equalTo: buttonAdd.topAnchor, constant: -8),
            textFieldAddPhone.leadingAnchor.constraint(equalTo: buttonAdd.leadingAnchor, constant: 4),
            textFieldAddPhone.trailingAnchor.constraint(equalTo: buttonAdd.trailingAnchor, constant: -4),
            textFieldAddPhone.heightAnchor.constraint(equalToConstant: 44),

            // Email text field constraints
            textFieldAddEmail.bottomAnchor.constraint(equalTo: textFieldAddPhone.topAnchor, constant: -8),
            textFieldAddEmail.leadingAnchor.constraint(equalTo: textFieldAddPhone.leadingAnchor),
            textFieldAddEmail.trailingAnchor.constraint(equalTo: textFieldAddPhone.trailingAnchor),
            textFieldAddEmail.heightAnchor.constraint(equalToConstant: 44),

            // Name text field constraints
            textFieldAddName.bottomAnchor.constraint(equalTo: textFieldAddEmail.topAnchor, constant: -8),
            textFieldAddName.leadingAnchor.constraint(equalTo: textFieldAddEmail.leadingAnchor),
            textFieldAddName.trailingAnchor.constraint(equalTo: textFieldAddEmail.trailingAnchor),
            textFieldAddName.heightAnchor.constraint(equalToConstant: 44),

            bottomAddView.topAnchor.constraint(equalTo: textFieldAddName.topAnchor, constant: -8),

            // Table view constraints
            tableViewContacts.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewContacts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewContacts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewContacts.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: -8),
        ])
    }

    // MARK: - Potential Enhancements

    // TODO: Consider adding the following enhancements:
    // 1. Implement a method to clear the text fields after adding a contact
    // 2. Add input validation for the text fields (e.g., email format, phone number format)
    // 3. Implement a loading indicator for when contacts are being fetched or added
    // 4. Add accessibility labels and hints for better VoiceOver support
    // 5. Implement a search bar for filtering contacts in the table view
}
