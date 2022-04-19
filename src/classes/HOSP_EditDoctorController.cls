public with sharing class HOSP_EditDoctorController {

    ApexPages.StandardController controller { get; set; }

    public HOSP_EditDoctorController(ApexPages.StandardController controller) {
        this.controller = controller;
    }

    public PageReference saveNew(){
        SObject recentDoctor = controller.getRecord();
        upsert recentDoctor;
        return new PageReference('/' + ('' + recentDoctor.get('Id')).subString(0, 3) + '/e?');
    }
}