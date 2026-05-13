/**
 * @description Test class for ContactController
 * @author Bob AI Assistant
 * @date 2026-05-12
 */
@isTest
private class ContactControllerTest {
    
    /**
     * @description Setup test data
     */
    @TestSetup
    static void setupTestData() {
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        
        testContacts.add(new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Phone = '555-0001'
        ));
        
        testContacts.add(new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            Email = 'jane.smith@example.com',
            Phone = '555-0002'
        ));
        
        testContacts.add(new Contact(
            FirstName = 'Bob',
            LastName = 'Johnson',
            Email = 'bob.johnson@example.com',
            Phone = '555-0003'
        ));
        
        insert testContacts;
    }
    
    /**
     * @description Test getContacts with empty search key
     */
    @isTest
    static void testGetContactsEmptySearch() {
        Test.startTest();
        List<Contact> contacts = ContactController.getContacts('');
        Test.stopTest();
        
        System.assertEquals(3, contacts.size(), 'Should return all 3 test contacts');
    }
    
    /**
     * @description Test getContacts with specific search key
     */
    @isTest
    static void testGetContactsWithSearch() {
        Test.startTest();
        List<Contact> contacts = ContactController.getContacts('John');
        Test.stopTest();
        
        System.assertEquals(1, contacts.size(), 'Should return 1 contact matching John');
        System.assertEquals('Doe', contacts[0].LastName, 'Should return John Doe');
    }
    
    /**
     * @description Test getContacts with email search
     */
    @isTest
    static void testGetContactsEmailSearch() {
        Test.startTest();
        List<Contact> contacts = ContactController.getContacts('jane.smith@example.com');
        Test.stopTest();
        
        System.assertEquals(1, contacts.size(), 'Should return 1 contact matching email');
        System.assertEquals('Jane', contacts[0].FirstName, 'Should return Jane Smith');
    }
    
    /**
     * @description Test createContact with valid data
     */
    @isTest
    static void testCreateContactSuccess() {
        Contact newContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test.user@example.com',
            Phone = '555-9999'
        );
        
        Test.startTest();
        Id contactId = ContactController.createContact(newContact);
        Test.stopTest();
        
        System.assertNotEquals(null, contactId, 'Contact Id should not be null');
        
        Contact createdContact = [SELECT FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
        System.assertEquals('Test', createdContact.FirstName, 'First name should match');
        System.assertEquals('User', createdContact.LastName, 'Last name should match');
    }
    
    /**
     * @description Test createContact with missing required field
     */
    @isTest
    static void testCreateContactMissingLastName() {
        Contact newContact = new Contact(
            FirstName = 'Test',
            Email = 'test@example.com'
        );
        
        Test.startTest();
        try {
            ContactController.createContact(newContact);
            System.assert(false, 'Should have thrown an exception');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Last Name is required'), 
                         'Exception message should mention Last Name');
        }
        Test.stopTest();
    }
    
    /**
     * @description Test updateContact with valid data
     */
    @isTest
    static void testUpdateContactSuccess() {
        Contact existingContact = [SELECT Id, FirstName, LastName, Email 
                                   FROM Contact 
                                   WHERE LastName = 'Doe' 
                                   LIMIT 1];
        
        existingContact.Email = 'updated.email@example.com';
        existingContact.Phone = '555-1111';
        
        Test.startTest();
        Id contactId = ContactController.updateContact(existingContact);
        Test.stopTest();
        
        System.assertEquals(existingContact.Id, contactId, 'Contact Id should match');
        
        Contact updatedContact = [SELECT Email, Phone FROM Contact WHERE Id = :contactId];
        System.assertEquals('updated.email@example.com', updatedContact.Email, 'Email should be updated');
        System.assertEquals('555-1111', updatedContact.Phone, 'Phone should be updated');
    }
    
    /**
     * @description Test updateContact with missing Id
     */
    @isTest
    static void testUpdateContactMissingId() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'User'
        );
        
        Test.startTest();
        try {
            ContactController.updateContact(contact);
            System.assert(false, 'Should have thrown an exception');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Contact Id is required'), 
                         'Exception message should mention Contact Id');
        }
        Test.stopTest();
    }
    
    /**
     * @description Test updateContact with missing LastName
     */
    @isTest
    static void testUpdateContactMissingLastName() {
        Contact existingContact = [SELECT Id FROM Contact WHERE LastName = 'Doe' LIMIT 1];
        
        Contact contact = new Contact(
            Id = existingContact.Id,
            FirstName = 'Test',
            LastName = null
        );
        
        Test.startTest();
        try {
            ContactController.updateContact(contact);
            System.assert(false, 'Should have thrown an exception');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Last Name is required'), 
                         'Exception message should mention Last Name');
        }
        Test.stopTest();
    }
    
    /**
     * @description Test deleteContact with valid Id
     */
    @isTest
    static void testDeleteContactSuccess() {
        Contact contactToDelete = [SELECT Id FROM Contact WHERE LastName = 'Johnson' LIMIT 1];
        
        Test.startTest();
        ContactController.deleteContact(contactToDelete.Id);
        Test.stopTest();
        
        List<Contact> remainingContacts = [SELECT Id FROM Contact WHERE Id = :contactToDelete.Id];
        System.assertEquals(0, remainingContacts.size(), 'Contact should be deleted');
    }
    
    /**
     * @description Test deleteContact with null Id
     */
    @isTest
    static void testDeleteContactNullId() {
        Test.startTest();
        try {
            ContactController.deleteContact(null);
            System.assert(false, 'Should have thrown an exception');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Contact Id is required'), 
                         'Exception message should mention Contact Id');
        }
        Test.stopTest();
    }
    
    /**
     * @description Test deleteContact with invalid Id
     */
    @isTest
    static void testDeleteContactInvalidId() {
        // Create a fake Id that doesn't exist
        Id fakeId = '003000000000000AAA';
        
        Test.startTest();
        try {
            ContactController.deleteContact(fakeId);
            System.assert(false, 'Should have thrown an exception');
        } catch (AuraHandledException e) {
            System.assertNotEquals(null, e.getMessage(), 'Should have error message');
        }
        Test.stopTest();
    }
}

% Made with Bob
