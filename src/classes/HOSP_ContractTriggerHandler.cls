public with sharing class HOSP_ContractTriggerHandler extends HOSP_TriggerHandler {
    private List<Contract__c> newList;
    private List<Contract__c> oldList;
    private Map<Id, Contract__c> newMap;
    private Map<Id, Contract__c> oldMap;

    public HOSP_ContractTriggerHandler() {
        this.oldList = (List<Contract__c>) Trigger.Old;
        this.newList = (List<Contract__c>) Trigger.New;
        this.oldMap = (Map<Id, Contract__c>) Trigger.oldMap;
        this.newMap = (Map<Id, Contract__c>) Trigger.newMap;
    }
    
    protected override void beforeInsert() {
        HOSP_ContractOverlappingService.checkIfContractDatesOverlap(this.newList);
    }

    protected override void beforeUpdate() {
        HOSP_ContractOverlappingService.checkIfContractDatesOverlap(this.newList);
    }
}