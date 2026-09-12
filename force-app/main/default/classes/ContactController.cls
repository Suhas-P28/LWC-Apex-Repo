/**
Author : Suhas P
 * @description Controller class for Contact Manager LWC component
 * @author Bob AI Assistant
 * @date 2026-05-12
 */
public with sharing class ContactController {
    
    /**
     * @description Retrieves contacts based on search criteria
     * @param searchKey Search string to filter contacts
     * @return List of Contact records
     */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String searchKey) {
        try {
            String searchPattern = '%' + searchKey + '%';
            
            return [
                SELECT Id, FirstName, LastName, Email, Phone, AccountId, Account.Name
                FROM Contact
                WHERE FirstName LIKE :searchPattern
                   OR LastName LIKE :searchPattern
                   OR Email LIKE :searchPattern
                   OR Phone LIKE :searchPattern
                WITH SECURITY_ENFORCED
                ORDER BY LastName, FirstName
                LIMIT 100
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving contacts: ' + e.getMessage());
        }
    }
    
    /**
     * @description Creates a new contact record
     * @param contact Contact object to create
     * @return Id of the created contact
     */
    @AuraEnabled
    public static Id createContact(Contact contact) {
        try {
            // Validate required fields
            if (String.isBlank(contact.LastName)) {
                throw new AuraHandledException('Last Name is required');
            }
            
            // Insert contact
            insert contact;
            return contact.Id;
        } catch (DmlException e) {
            throw new AuraHandledException('Error creating contact: ' + e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }
    
    /**
     * @description Updates an existing contact record
     * @param contact Contact object with updated values
     * @return Id of the updated contact
     */
    @AuraEnabled
    public static Id updateContact(Contact contact) {
        try {
            // Validate required fields
            if (contact.Id == null) {
                throw new AuraHandledException('Contact Id is required for update');
            }
            
            if (String.isBlank(contact.LastName)) {
                throw new AuraHandledException('Last Name is required');
            }
            
            // Update contact
            update contact;
            return contact.Id;
        } catch (DmlException e) {
            throw new AuraHandledException('Error updating contact: ' + e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException('Error updating contact: ' + e.getMessage());
        }
    }
    
    /**
     * @description Deletes a contact record
     * @param contactId Id of the contact to delete
     */
    @AuraEnabled
    public static void deleteContact(Id contactId) {
        try {
            if (contactId == null) {
                throw new AuraHandledException('Contact Id is required for deletion');
            }
            
            Contact contactToDelete = [
                SELECT Id 
                FROM Contact 
                WHERE Id = :contactId 
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];
            
            delete contactToDelete;
        } catch (DmlException e) {
            throw new AuraHandledException('Error deleting contact: ' + e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting contact: ' + e.getMessage());
        }
    }
}

% Made with Bob
