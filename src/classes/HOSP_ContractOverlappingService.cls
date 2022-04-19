public with sharing class HOSP_ContractOverlappingService {

    public static void checkIfContractDatesOverlap(List<Contract__c> newContracts) {
        Set<Id> doctorsIds = new Set<Id>();
        Set<Id> hospitalsIds = new Set<Id>();
        getIdsOfDoctorsAndHospitalsFromNewContracts(newContracts, doctorsIds, hospitalsIds);
        List<Contract__c> existingContracts = getAllExistingContractsForDoctorsAndHospitalsSigningNewContracts(doctorsIds, hospitalsIds);
        checkOverlap(newContracts, getDoctorContractsInHospitals(newContracts));
        checkOverlap(newContracts, getDoctorContractsInHospitals(existingContracts));
    }

    private static void checkOverlap(List<Contract__c> newContracts, Map <Id, Map<Id, List<Contract__c>>> doctorsContractsInHospitals) {
        List<Contract__c> allOverlappingContracts = new List<Contract__c>();
        for (Contract__c newContract : newContracts) {
            List<Contract__c> overlappingContracts = new List<Contract__c>();
            if (doctorsContractsInHospitals.containsKey(newContract.Hospital__c) &&
                    doctorsContractsInHospitals.get(newContract.Hospital__c).containsKey(newContract.Doctor__c)) {
                for (Contract__c existingContract : doctorsContractsInHospitals.get(newContract.Hospital__c).get(newContract.Doctor__c)) {
                    if (newContract !== existingContract && isDateOverlapping(newContract, existingContract)) {
                        overlappingContracts.add(existingContract);
                        allOverlappingContracts.add(existingContract);
                    }
                }
                if (!overlappingContracts.isEmpty()) {
                    newContract.addError(buildErrorMessage('<br/>' + '\r\n' + System.Label.DateOverlappingError + '<br/>' + '\r\n', overlappingContracts), false);
                }
            }
        }
    }

    private static void getIdsOfDoctorsAndHospitalsFromNewContracts(List<Contract__c> newContracts, Set<Id> doctorsIds, Set<Id> hospitalsIds) {
        for (Contract__c contract : newContracts) {
            doctorsIds.add(contract.Doctor__c);
            hospitalsIds.add(contract.Hospital__c);
        }
    }

    private static List<Contract__c> getAllExistingContractsForDoctorsAndHospitalsSigningNewContracts(Set<Id> doctorsIds, Set<Id> hospitalsIds) {
        return [
                SELECT Id, Hospital__c, Doctor__c, Start_Date__c, End_Date__c
                FROM Contract__c
                WHERE Doctor__c IN :doctorsIds
                AND Hospital__c IN :hospitalsIds
                ORDER BY Start_Date__c ASC
        ];
    }

    private static Boolean isDateOverlapping(Contract__c newContract, Contract__c oldContract) {
        return ((newContract.Start_Date__c >= oldContract.Start_Date__c && newContract.Start_Date__c <= oldContract.End_Date__c) ||
                (newContract.End_Date__c >= oldContract.Start_Date__c && newContract.End_Date__c <= oldContract.End_Date__c) ||
                (newContract.Start_Date__c <= oldContract.Start_Date__c && newContract.End_Date__c >= oldContract.End_Date__c));
    }

    private static String buildErrorMessage(String msg, List<Contract__c> overlappingContracts) {
        for (Contract__c c : overlappingContracts) {
            msg = msg + c.Start_Date__c.format() + ' - ' + c.End_Date__c.format() + '<br/>' + '\r\n';
        }
        msg += System.Label.Correct_dates;
        return msg;
    }

    private static Map <Id, Map<Id, List<Contract__c>>> getDoctorContractsInHospitals(List<Contract__c> existingContracts) {
        Map <Id, Map<Id, List<Contract__c>>> doctorsContractsInHospitals = new Map<Id, Map<Id, List<Contract__c>>>();
        for (Contract__c existingContract : existingContracts) {
            if (!doctorsContractsInHospitals.containsKey(existingContract.Hospital__c)) {
                doctorsContractsInHospitals.put(existingContract.Hospital__c, new Map<Id, List<Contract__c>>());
            }
            Map<Id, List<Contract__c>> doctorContracts = doctorsContractsInHospitals.get(existingContract.Hospital__c);
            if (!doctorContracts.containsKey(existingContract.Doctor__c)) {
                doctorContracts.put(existingContract.Doctor__c, new List<Contract__c>());
            }
            List<Contract__c> contracts = doctorContracts.get(existingContract.Doctor__c);
            contracts.add(existingContract);
        }
        return doctorsContractsInHospitals;
    }
}