//
//  ContactEditView.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import UIKit

/// `ContactEditView` is a custom UIView subclass that provides an interface for editing contact information.
/// It includes text fields for name, email, and phone number, as well as save and cancel buttons.
class ContactEditView: UIView {

    // MARK: - UI Elements

    // Labels for text fields
    /// Label for the name field
    private let nameLabel = UILabel()
    /// Label for the email field
    private let emailLabel = UILabel()
    /// Label for the phone field
    private let phoneLabel = UILabel()

    // Editable text fields
    /// Text field for editing the contact's name
    let nameTextField = UITextField()
    /// Text field for editing the contact's email
    let emailTextField = UITextField()
    /// Text field for editing the contact's phone number
    let phoneTextField = UITextField()

    // Buttons
    /// Button to save the edited contact information
    let saveButton = UIButton(type: .system)
    /// Button to cancel the editing process
    let cancelButton = UIButton(type: .system)

    // Stack views
    /// Stack view for organizing the contact detail fields
    private let detailsStackView = UIStackView()
    /// Stack view for organizing the action buttons
    private let buttonsStackView = UIStackView()

    // Scroll view to make the screen scrollable
    /// Scroll view that contains all UI elements
    private let scrollView = UIScrollView()
    /// Content view within the scroll view
    private let contentView = UIView()

    // MARK: - Initializer

    /// Initializes the ContactEditView
    /// - Parameter frame: The frame rectangle for the view, used by the superclass
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    /// Required initializer for use with Interface Builder, not implemented for this custom view
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    /// Sets up the entire view, including all UI elements and their properties
    private func setupView() {
        backgroundColor = .white

        // Setup labels
        setupLabel(nameLabel, text: "Name:")
        setupLabel(emailLabel, text: "Email:")
        setupLabel(phoneLabel, text: "Phone:")

        // Setup text fields
        setupTextField(nameTextField)
        setupTextField(emailTextField)
        setupTextField(phoneTextField)
        phoneTextField.keyboardType = .numberPad

        // Distinct visual treatment for editable fields
        nameTextField.borderStyle = .roundedRect
        emailTextField.borderStyle = .roundedRect
        phoneTextField.borderStyle = .roundedRect

        // Setup buttons
        setupButton(saveButton, title: "Save", color: UIColor.systemBlue)
        setupButton(cancelButton, title: "Cancel", color: UIColor.gray)

        // Setup stack views
        setupStackViews()

        // Setup scroll view
        setupScrollView()

        // Add subviews to content view
        addSubviewsToContentView()
    }

    /// Sets up a label with the given text
    /// - Parameters:
    ///   - label: The UILabel to set up
    ///   - text: The text to display in the label
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Sets up a text field with common properties
    /// - Parameter textField: The UITextField to set up
    private func setupTextField(_ textField: UITextField) {
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.masksToBounds = true
        textField.setLeftPaddingPoints(8)
    }

    /// Sets up a button with the given title and color
    /// - Parameters:
    ///   - button: The UIButton to set up
    ///   - title: The title text for the button
    ///   - color: The color for the button's title
    private func setupButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Creates a vertical stack view for a field (label and text field)
    /// - Parameters:
    ///   - label: The label for the field
    ///   - textField: The text field for the field
    /// - Returns: A configured UIStackView
    private func createFieldStack(label: UILabel, textField: UITextField) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, textField])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    /// Sets up the main stack views (details and buttons)
    private func setupStackViews() {
        detailsStackView.axis = .vertical
        detailsStackView.spacing = 16
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false

        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add elements to stack views
        detailsStackView.addArrangedSubview(createFieldStack(label: nameLabel, textField: nameTextField))
        detailsStackView.addArrangedSubview(createFieldStack(label: emailLabel, textField: emailTextField))
        detailsStackView.addArrangedSubview(createFieldStack(label: phoneLabel, textField: phoneTextField))

        buttonsStackView.addArrangedSubview(saveButton)
        buttonsStackView.addArrangedSubview(cancelButton)
    }

    /// Sets up the scroll view and its content view
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    /// Adds all subviews to the content view
    private func addSubviewsToContentView() {
        contentView.addSubview(detailsStackView)
        contentView.addSubview(buttonsStackView)
    }

    // MARK: - Layout Setup

    /// Sets up the layout constraints for all UI elements
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Details stack view constraints
            detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Buttons stack view constraints
            buttonsStackView.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: detailsStackView.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: detailsStackView.trailingAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44),

            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITextField Extension for Padding

/// Extension to UITextField to add left padding
extension UITextField {
    /// Adds left padding to the text field
    /// - Parameter amount: The amount of padding to add
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
