//
//  ContactDetailView.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import UIKit

/// `ContactDetailView` is a custom UIView subclass that displays detailed information about a contact.
/// It includes labels for the contact's name, email, and phone number, as well as buttons for editing, deleting, and navigating back.
class ContactDetailView: UIView {

    // MARK: - UI Elements

    // Labels for displaying contact details
    /// Title label for the contact's name
    private let nameTitleLabel = UILabel()
    /// Value label displaying the contact's name
    private let nameValueLabel = UILabel()

    /// Title label for the contact's email
    private let emailTitleLabel = UILabel()
    /// Value label displaying the contact's email
    private let emailValueLabel = UILabel()

    /// Title label for the contact's phone number
    private let phoneTitleLabel = UILabel()
    /// Value label displaying the contact's phone number
    private let phoneValueLabel = UILabel()

    // Buttons
    /// Button for editing the contact's information
    let editButton = UIButton(type: .system)
    /// Button for deleting the contact
    let deleteButton = UIButton(type: .system)
    /// Button for navigating back to the previous screen
    let backButton = UIButton(type: .system)

    // Stack views
    /// Stack view containing the contact details (name, email, phone)
    private let detailsStackView = UIStackView()
    /// Stack view containing the edit and delete buttons
    private let buttonsStackView = UIStackView()

    // Scroll view to make the screen scrollable
    /// Scroll view that contains all the UI elements, allowing for scrolling if content exceeds screen size
    private let scrollView = UIScrollView()
    /// Content view within the scroll view that holds all the UI elements
    private let contentView = UIView()

    // MARK: - Initializer

    /// Initializes the ContactDetailView with a given frame
    /// - Parameter frame: The frame rectangle for the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    /// Required initializer for NSCoder, not implemented for this custom view
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    /// Sets up the entire view, including all UI elements and their properties
    private func setupView() {
        backgroundColor = .white

        // Setup title labels
        setupTitleLabel(nameTitleLabel, text: "Name:")
        setupTitleLabel(emailTitleLabel, text: "Email:")
        setupTitleLabel(phoneTitleLabel, text: "Phone:")

        // Setup value labels
        setupValueLabel(nameValueLabel)
        setupValueLabel(emailValueLabel)
        setupValueLabel(phoneValueLabel)

        // Setup buttons
        setupButton(editButton, title: "Edit", color: UIColor.systemBlue)
        setupButton(deleteButton, title: "Delete", color: UIColor.systemRed)
        setupButton(backButton, title: "Back", color: UIColor.gray)

        // Setup stack views
        setupStackViews()

        // Setup scroll view
        setupScrollView()

        // Add subviews to content view
        addSubviewsToContentView()
    }

    /// Sets up a title label with given text
    /// - Parameters:
    ///   - label: The UILabel to set up
    ///   - text: The text to display in the label
    private func setupTitleLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Sets up a value label with default properties
    /// - Parameter label: The UILabel to set up
    private func setupValueLabel(_ label: UILabel) {
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Sets up a button with given title and color
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

    /// Creates a vertical stack view for a detail item (title and value)
    /// - Parameters:
    ///   - titleLabel: The title label for the detail item
    ///   - valueLabel: The value label for the detail item
    /// - Returns: A configured UIStackView
    private func createDetailStack(titleLabel: UILabel, valueLabel: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
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
        detailsStackView.addArrangedSubview(createDetailStack(titleLabel: nameTitleLabel, valueLabel: nameValueLabel))
        detailsStackView.addArrangedSubview(createDetailStack(titleLabel: emailTitleLabel, valueLabel: emailValueLabel))
        detailsStackView.addArrangedSubview(createDetailStack(titleLabel: phoneTitleLabel, valueLabel: phoneValueLabel))

        buttonsStackView.addArrangedSubview(editButton)
        buttonsStackView.addArrangedSubview(deleteButton)
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
        contentView.addSubview(backButton)
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

            // Back button constraints
            backButton.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 60),
            backButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Public Methods

    /// Configures the view with contact information
    /// - Parameter contact: The Contact object containing the information to display
    func configure(with contact: Contact) {
        nameValueLabel.text = contact.name
        emailValueLabel.text = contact.email
        phoneValueLabel.text = "\(contact.phone)"
    }
}
