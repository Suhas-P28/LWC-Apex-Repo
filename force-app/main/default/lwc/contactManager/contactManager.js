import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import createContact from '@salesforce/apex/ContactController.createContact';
import updateContact from '@salesforce/apex/ContactController.updateContact';
import deleteContact from '@salesforce/apex/ContactController.deleteContact';

export default class ContactManager extends LightningElement {
    @track contacts = [];
    @track isModalOpen = false;
    @track isEditMode = false;
    @track selectedContactId = null;
    @track searchKey = '';
    
    // Form fields
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';
    @track accountId = '';

    wiredContactsResult;

    // Columns for data table
    columns = [
        { label: 'First Name', fieldName: 'FirstName', type: 'text', sortable: true },
        { label: 'Last Name', fieldName: 'LastName', type: 'text', sortable: true },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        {
            type: 'action',
            typeAttributes: {
                rowActions: [
                    { label: 'Edit', name: 'edit' },
                    { label: 'Delete', name: 'delete' }
                ]
            }
        }
    ];

    @wire(getContacts, { searchKey: '$searchKey' })
    wiredContacts(result) {
        this.wiredContactsResult = result;
        if (result.data) {
            this.contacts = result.data;
        } else if (result.error) {
            this.showToast('Error', 'Error loading contacts', 'error');
        }
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleNewContact() {
        this.isEditMode = false;
        this.resetForm();
        this.isModalOpen = true;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch (actionName) {
            case 'edit':
                this.handleEdit(row);
                break;
            case 'delete':
                this.handleDelete(row.Id);
                break;
            default:
                break;
        }
    }

    handleEdit(contact) {
        this.isEditMode = true;
        this.selectedContactId = contact.Id;
        this.firstName = contact.FirstName || '';
        this.lastName = contact.LastName || '';
        this.email = contact.Email || '';
        this.phone = contact.Phone || '';
        this.accountId = contact.AccountId || '';
        this.isModalOpen = true;
    }

    handleDelete(contactId) {
        if (confirm('Are you sure you want to delete this contact?')) {
            deleteContact({ contactId })
                .then(() => {
                    this.showToast('Success', 'Contact deleted successfully', 'success');
                    return refreshApex(this.wiredContactsResult);
                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                });
        }
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;
    }

    handleSave() {
        // Validation
        if (!this.lastName) {
            this.showToast('Error', 'Last Name is required', 'error');
            return;
        }

        const contact = {
            FirstName: this.firstName,
            LastName: this.lastName,
            Email: this.email,
            Phone: this.phone,
            AccountId: this.accountId
        };

        if (this.isEditMode) {
            contact.Id = this.selectedContactId;
            updateContact({ contact })
                .then(() => {
                    this.showToast('Success', 'Contact updated successfully', 'success');
                    this.closeModal();
                    return refreshApex(this.wiredContactsResult);
                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                });
        } else {
            createContact({ contact })
                .then(() => {
                    this.showToast('Success', 'Contact created successfully', 'success');
                    this.closeModal();
                    return refreshApex(this.wiredContactsResult);
                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                });
        }
    }

    closeModal() {
        this.isModalOpen = false;
        this.resetForm();
    }

    resetForm() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.phone = '';
        this.accountId = '';
        this.selectedContactId = null;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }

    get modalTitle() {
        return this.isEditMode ? 'Edit Contact' : 'New Contact';
    }
}

// Made with Bob
