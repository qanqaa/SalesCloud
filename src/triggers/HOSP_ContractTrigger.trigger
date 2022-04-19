trigger HOSP_ContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Overlapping_Settings__c.getInstance().Is_Active__c) {
        new  HOSP_ContractTriggerHandler().run();
    }
}