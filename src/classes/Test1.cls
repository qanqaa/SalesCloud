public with sharing class Test1 {

    List<Contact> allContacts = [
            SELECT Name, Title, Email, MobilePhone
            FROM Contact
    ];

    List<Contact> allAccountsAndContacts = [
            SELECT Id, Account.Id
            FROM Contact
    ];

    List<Account> allAccountsWithLetterAInName = [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE '%a%'
    ];
}