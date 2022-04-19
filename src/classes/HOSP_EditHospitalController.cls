public with sharing class HOSP_EditHospitalController {

    ApexPages.StandardController controller { get; set; }

    public HOSP_EditHospitalController(ApexPages.StandardController controller) {
        this.controller = controller;
    }

    public PageReference saveNew(){
        SObject recentHospital = controller.getRecord();
        upsert recentHospital;
        return new PageReference('/' + ('' + recentHospital.get('Id')).subString(0, 3) + '/e?');
    }
}