public with sharing class HOSP_ViewHospitalController {
    public Hospital__c hospital { get; set; }

    public HOSP_ViewHospitalController(ApexPages.StandardController controller) {
        hospital = new Hospital__c();

        Id id = ApexPages.currentPage().getParameters().get('id');
        hospital = [
                SELECT Name, Active_Contracts__c, Address__c
                FROM Hospital__c
                WHERE Id = :id
                LIMIT 1
        ];
    }
}