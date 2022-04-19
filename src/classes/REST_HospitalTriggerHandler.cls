public with sharing class REST_HospitalTriggerHandler extends HOSP_TriggerHandler {
    private List<Hospital__c> newList;
    private List<Hospital__c> oldList;
    private Map<Id, Hospital__c> newMap;
    private Map<Id, Hospital__c> oldMap;

    public REST_HospitalTriggerHandler() {
        this.oldList = (List<Hospital__c>) Trigger.Old;
        this.newList = (List<Hospital__c>) Trigger.New;
        this.oldMap = (Map<Id, Hospital__c>) Trigger.oldMap;
        this.newMap = (Map<Id, Hospital__c>) Trigger.newMap;
    }

    protected override void afterInsert() {
        if(Hospital_Trigger__c.getInstance().Is_Active__c){
            System.enqueueJob(new REST_CalloutExecutor(REST_OperationType.INSERT_RECORD.name(), this.newList));
        }
    }

    protected override void beforeUpdate() {
        for (Hospital__c hosp : newList) {
            Hospital__c oldHospital = oldMap.get(hosp.Id);
            if (hosp.Name == oldHospital.Name && hosp.Address__c == oldHospital.Address__c) {
                HOSP_TriggerUtilities.runTrigger = false;
            } else {
                HOSP_TriggerUtilities.runTrigger = true;
                break;
            }
        }
    }

    protected override void afterUpdate() {
        if(Hospital_Trigger__c.getInstance().Is_Active__c){
            System.debug('wchodzi w after update');
            System.enqueueJob(new REST_CalloutExecutor(REST_OperationType.UPDATE_RECORD.name(), this.newList));
        }
    }

    protected override void afterDelete() {
        if(Hospital_Trigger__c.getInstance().Is_Active__c){
            System.enqueueJob(new REST_CalloutExecutor(REST_OperationType.DELETE_RECORD.name(), this.oldList));
        }
    }
}