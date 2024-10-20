# iOS Simple Contacts App with Custom API

This is a simple iOS contact management application that interacts with a custom API. It allows users to view, add, edit, and delete contacts.

## Features

- View a list of contacts
- Add new contacts
- View details of a selected contact
- Interacts with a custom API for data persistence

## Technologies Used

- Swift
- UIKit
- Alamofire for network requests
- CocoaPods for dependency management

## Setup

1. Clone the repository
2. Run `pod install` to install dependencies
3. Open the `.xcworkspace` file in Xcode
4. Build and run the project

## API Details

The app interacts with a custom API with the following endpoints:

- Base URL: http://apis.sakibnm.work:8888/contacts/text/
- Get all contacts: `getall` (GET)
- Get contact details: `details` (GET)
- Add a contact: `add` (POST)
- Delete a contact: `delete` (GET)

## Project Structure

- `MainScreenView`: Main view of the app
- `ContactsTableViewCell`: Custom cell for the contacts table view
- `ViewController`: Main view controller handling user interactions and API calls
- `Contact`: Model struct for contact data

## Notes

This project was developed as part of a learning exercise focusing on:
- Notification Center
- UIScrollView
- CocoaPods
- Network calls using Alamofire

Note: This app uses HTTP connections for demo purposes. In a production environment, always use HTTPS for secure communications.
