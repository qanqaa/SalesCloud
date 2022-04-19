public with sharing class Test2 {

    private void createTenContacts() {
        List<Contact> contactsList = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            Contact contact = new Contact(
                    FirstName = 'FirstName' + i,
                    LastName = 'LastName' + i);
            contactsList.add(contact);
        }
        insert contactsList;
    }

    private void updateLastTenContacts() {
        List<Contact> contactsList = [
                SELECT FirstName, LastName
                FROM Contact
                ORDER BY CreatedDate DESC
                LIMIT 10
        ];
        for (Integer i = 0; i < contactsList.size(); i++) {
            contactsList[i].FirstName = 'FirstNameUpdated' + i;
            contactsList[i].LastName = 'LastNameUpdated' + i;
        }
        update contactsList;
    }

    private void deleteLastTenContacts() {
        delete [
                SELECT FirstName, LastName
                FROM Contact
                ORDER BY CreatedDate DESC
                LIMIT 10
        ];
    }
}