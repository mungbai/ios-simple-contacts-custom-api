//
//  ContactsTableViewCell.swift
//  WA6_BAI_9976
//
//  Created by Mengxiong on 10/19/24.
//

import UIKit

/// `ContactsTableViewCell` is a custom UITableViewCell subclass designed to display contact information in a table view.
/// It features a wrapper view with shadow effects and a label for the contact's name.
class ContactsTableViewCell: UITableViewCell {

    // MARK: - Properties

    /// The wrapper view that contains the cell's content and provides visual styling
    var wrapperCellView: UIView!

    /// The label used to display the contact's name
    var labelName: UILabel!

    // MARK: - Initialization

    /// Initializes a new instance of ContactsTableViewCell
    /// - Parameters:
    ///   - style: The cell style (unused in this custom implementation)
    ///   - reuseIdentifier: A string used to identify the cell object if it is to be reused
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupWrapperCellView()
        setupLabelName()
        initConstraints()
    }

    /// Required initializer for using ContactsTableViewCell with Interface Builder
    /// Not implemented as this cell is created programmatically
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    /// Sets up the wrapper cell view with visual styling
    func setupWrapperCellView() {
        wrapperCellView = UIView()

        // Configure the wrapper view's appearance
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false

        // Add the wrapper view to the cell's content view
        self.contentView.addSubview(wrapperCellView)
    }

    /// Sets up the label for displaying the contact's name
    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 16)
        labelName.translatesAutoresizingMaskIntoConstraints = false

        // Add the label to the wrapper view
        wrapperCellView.addSubview(labelName)
    }

    // MARK: - Constraints

    /// Sets up the auto layout constraints for the cell's subviews
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Wrapper view constraints
            wrapperCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),

            // Name label constraints
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelName.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            labelName.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
        ])
    }

    // MARK: - Potential Enhancements

    // TODO: Consider adding the following enhancements:
    // 1. Implement a configure(with:) method to set up the cell with a Contact object
    // 2. Add more UI elements to display additional contact information (e.g., email, phone)
    // 3. Implement accessibility labels and hints for better VoiceOver support
    // 4. Add a method to update the cell's appearance when selected
}
