global class HOSP_EmailNotification implements Database.Batchable<sObject>, Database.Stateful{
    List<Contract__c> allContracts = new List<Contract__c>();
    Set<Id> doctorsId = new Set<Id>();
    List<Doctor__c> doctors = new List<Doctor__c>();
    List<Doctor__c> startingDoctors = new List<Doctor__c>();
    List<Doctor__c> endingDoctors = new List<Doctor__c>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        String onboardingQuery = 'SELECT Doctor__c, Doctor__r.Name, Hospital__c, Start_Date__c, End_Date__c ' +
                'FROM Contract__c WHERE Start_Date__c = :today OR End_Date__c = :today';
        return Database.getQueryLocator(onboardingQuery);
    }

    global void execute(Database.BatchableContext bc, List<Contract__c> contracts) {
        for(Contract__c contract : contracts){
            if(contract.Start_Date__c == Date.today()){
                startingDoctors.add(contract.Doctor__r);
            }
            else{
                endingDoctors.add(contract.Doctor__r);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
        Map<String, Object> startingContracts = new Map<String, Object>();
        for(Doctor__c doctor : startingDoctors){
            startingContracts.put('Doctor', doctor);
            Flow.Interview.Send_Doctors_List_For_Onboarding sendEmailFlow = new Flow.Interview.Send_Doctors_List_For_Onboarding(startingContracts);
            sendEmailFlow.start();
        }

        Map<String, Object> endingContracts = new Map<String, Object>();
        for(Doctor__c doctor : endingDoctors){
            endingContracts.put('Doctor', doctor);
            Flow.Interview.Send_Doctors_List_For_Offboarding sendEmailFlow = new Flow.Interview.Send_Doctors_List_For_Offboarding(endingContracts);
            sendEmailFlow.start();
        }
    }
}