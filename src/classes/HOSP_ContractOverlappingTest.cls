@IsTest
private class HOSP_ContractOverlappingTest {
    @TestSetup
    private static void setup() {
        insert new Doctor__c(
                Name = 'Test',
                First_Name__c = 'Test',
                Specialty__c = 'Test',
                Licence_Number__c = '000',
                Country__c = 'Poland',
                Phone__c = '000000000'
        );
        insert new Hospital__c(
                Name = 'Test',
                Address__c = 'Test'
        );
    }

    @isTest
    private static void shouldInsertContracts() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c];
        Hospital__c hospital = [SELECT Id FROM Hospital__c];
        List<Contract__c> contractsToAdd = testContracts(5, 5, hospital, doctor);

        Test.startTest();
        try {
            insert contractsToAdd;
        } catch (Exception e) {
            System.assert(false);
        }
        Test.stopTest();

        List<Contract__c> contracts = [SELECT Id FROM Contract__c];
        System.assertEquals(5, contracts.size());
    }

    @isTest
    private static void shouldNotInsertContracts() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c];
        Hospital__c hospital = [SELECT Id FROM Hospital__c];
        List<Contract__c> contractsToAdd = testContracts(5, 0, hospital, doctor);

        Test.startTest();
        try {
            insert contractsToAdd;
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
        Test.stopTest();

        List<Contract__c> contracts = [SELECT Id FROM Contract__c];
        System.assertNotEquals(5, contracts.size());
    }

    private static List<Contract__c> testContracts(Integer contractNumber, Integer daysDelay, Hospital__c hospital, Doctor__c doctor) {
        List<Contract__c> contractsToAdd = new List<Contract__c>();
        for (Integer i = 0; i < contractNumber; i++) {
            Contract__c contract = new Contract__c(
                    Hospital__c = hospital.Id,
                    Doctor__c = doctor.Id,
                    Start_Date__c = Date.today().addDays(i * daysDelay * 10),
                    End_Date__c = Date.today().addDays((i * daysDelay * 10) + 7)
            );
            System.debug(contract);
            contractsToAdd.add(contract);
        }
        return contractsToAdd;
    }
}