public with sharing class HOSP_ViewDoctorController {

    public Doctor__c doctor { get; set; }

    public HOSP_ViewDoctorController(ApexPages.StandardController controller) {
        doctor = new Doctor__c();

        Id id = ApexPages.currentPage().getParameters().get('id');
        doctor = [
                SELECT Name, First_Name__c, Specialty__c, Licence_Number__c, Country__c, Phone__c, Email__c, Birthdate_Date__c
                FROM Doctor__c
                WHERE Id = :id
                LIMIT 1
        ];
    }
}