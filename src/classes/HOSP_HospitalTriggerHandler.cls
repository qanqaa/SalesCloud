public with sharing class HOSP_HospitalTriggerHandler extends HOSP_TriggerHandler{
    private List<Hospital__c> newList;
    private List<Hospital__c> oldList;
    private Map<Id, Hospital__c> newMap;
    private Map<Id, Hospital__c> oldMap;

    public HOSP_HospitalTriggerHandler() {
        this.oldList = (List<Hospital__c>) Trigger.Old;
        this.newList = (List<Hospital__c>) Trigger.New;
        this.oldMap = (Map<Id, Hospital__c>) Trigger.oldMap;
        this.newMap = (Map<Id, Hospital__c>) Trigger.newMap;
    }

    protected override void afterInsert() {

    }

    protected override void afterUpdate() {

    }

    protected override void afterDelete() {

    }
}