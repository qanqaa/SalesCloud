public with sharing class HOSP_SoapEditDoctorController {
    public Doctor__c doctor { get; set; }


    public HOSP_SoapEditDoctorController() {
        this.doctor = new Doctor__c();
    }

    public void saveDoctor() {
        HOSP_SOAPCommunicator communicator = new HOSP_SOAPCommunicator();
        communicator.addNewDoctor(doctor);
    }

    public void clearDoctor(){
        doctor = new Doctor__c();
    }

}