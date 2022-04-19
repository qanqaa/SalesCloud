public with sharing class HOSP_SoapUpdateDoctorController {
    public Doctor__c doctorToUpdate { get; set; }

    public HOSP_SoapUpdateDoctorController() {

    }

    public HOSP_SoapUpdateDoctorController(Doctor__c doctor) {
        this.doctorToUpdate = doctor;
        System.debug('TOOO' + doctor);
    }

    public void saveDoctor() {
        HOSP_SOAPCommunicator communicator = new HOSP_SOAPCommunicator();
        communicator.addNewDoctor(doctorToUpdate);
    }

    public void clearDoctor(){

    }
}