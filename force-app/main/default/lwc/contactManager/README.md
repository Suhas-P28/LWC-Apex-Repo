# Contact Manager LWC Component

## Overview
A comprehensive Lightning Web Component for managing Salesforce Contact records with full CRUD (Create, Read, Update, Delete) operations.

## Features
- ✅ **Search Functionality**: Real-time search across contact fields (Name, Email, Phone)
- ✅ **Data Table Display**: Interactive table with sortable columns
- ✅ **Create Contacts**: Modal form for creating new contacts
- ✅ **Edit Contacts**: Inline editing with modal form
- ✅ **Delete Contacts**: Confirmation dialog before deletion
- ✅ **Responsive Design**: Works on desktop and mobile devices
- ✅ **Toast Notifications**: User feedback for all operations
- ✅ **Security**: WITH SECURITY_ENFORCED in SOQL queries

## Component Structure

### Files
```
contactManager/
├── contactManager.js          # JavaScript controller
├── contactManager.html        # HTML template
├── contactManager.css         # Component styles
├── contactManager.js-meta.xml # Component metadata
└── README.md                  # This file
```

### Apex Controller
```
classes/
├── ContactController.cls           # Apex controller with @AuraEnabled methods
├── ContactController.cls-meta.xml  # Apex class metadata
├── ContactControllerTest.cls       # Test class (100% coverage)
└── ContactControllerTest.cls-meta.xml
```

## Installation

1. **Deploy to Salesforce**
   ```bash
   sfdx force:source:deploy -p force-app/main/default/lwc/contactManager
   sfdx force:source:deploy -p force-app/main/default/classes
   ```

2. **Run Tests**
   ```bash
   sfdx force:apex:test:run -n ContactControllerTest -r human
   ```

## Usage

### Add to Lightning Page
1. Navigate to any Lightning App Builder page
2. Drag the **Contact Manager** component onto the page
3. Save and activate the page

### Supported Targets
- Lightning App Page
- Lightning Record Page
- Lightning Home Page
- Experience Cloud Pages

## Component Properties

### Public Properties
- None (component is self-contained)

### Private Properties
- `contacts` - Array of contact records
- `isModalOpen` - Controls modal visibility
- `isEditMode` - Determines create vs edit mode
- `searchKey` - Current search filter value

## Apex Methods

### `getContacts(String searchKey)`
- **Type**: @AuraEnabled(cacheable=true)
- **Description**: Retrieves contacts with optional search filter
- **Parameters**: 
  - `searchKey` - Search string (optional)
- **Returns**: List<Contact>

### `createContact(Contact contact)`
- **Type**: @AuraEnabled
- **Description**: Creates a new contact record
- **Parameters**: 
  - `contact` - Contact object to create
- **Returns**: Id of created contact

### `updateContact(Contact contact)`
- **Type**: @AuraEnabled
- **Description**: Updates an existing contact
- **Parameters**: 
  - `contact` - Contact object with updates
- **Returns**: Id of updated contact

### `deleteContact(Id contactId)`
- **Type**: @AuraEnabled
- **Description**: Deletes a contact record
- **Parameters**: 
  - `contactId` - Id of contact to delete
- **Returns**: void

## User Interface

### Main View
- Search bar for filtering contacts
- "New Contact" button
- Data table with columns:
  - First Name
  - Last Name
  - Email
  - Phone
  - Actions (Edit/Delete)

### Modal Form
- First Name (optional)
- Last Name (required)
- Email (optional)
- Phone (optional)
- Account ID (optional)
- Cancel and Save buttons

## Error Handling
- Validation for required fields
- User-friendly error messages via toast notifications
- Confirmation dialog for delete operations
- Exception handling in Apex controller

## Security
- Uses `with sharing` in Apex controller
- `WITH SECURITY_ENFORCED` in SOQL queries
- Field-level security respected
- Input validation on all operations

## Testing
The component includes comprehensive test coverage:
- ✅ Search functionality tests
- ✅ Create operation tests
- ✅ Update operation tests
- ✅ Delete operation tests
- ✅ Error handling tests
- ✅ Validation tests

**Test Coverage**: 100%

## Customization

### Modify Displayed Fields
Edit the `columns` array in `contactManager.js`:
```javascript
columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    // Add more columns here
];
```

### Change Search Behavior
Modify the SOQL query in `ContactController.getContacts()`:
```apex
WHERE FirstName LIKE :searchPattern
   OR LastName LIKE :searchPattern
   // Add more search fields
```

### Styling
Customize appearance in `contactManager.css`

## Best Practices Implemented
- ✅ Separation of concerns (LWC + Apex)
- ✅ Cacheable wire service for better performance
- ✅ Proper error handling
- ✅ User feedback via toast notifications
- ✅ Confirmation dialogs for destructive actions
- ✅ Comprehensive test coverage
- ✅ Security-first approach
- ✅ Responsive design
- ✅ Accessibility considerations

## Browser Support
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Version History
- **v1.0.0** (2026-05-12) - Initial release
  - Full CRUD operations
  - Search functionality
  - Responsive design
  - Complete test coverage

## Support
For issues or questions, please contact your Salesforce administrator.

## License
This component is provided as-is for use in Salesforce environments.