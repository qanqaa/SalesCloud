public with sharing class HOSP_SoapDoctorManagerController {
    public Doctor__c doctor { get; set; }
    public String searchQuery { get; set; }
    public Integer size { get; set; }
    public List<SelectOption> paginationSizeOptions { get; set; }
    public String FileBodyString { get; set; }
    private final String recordDelimiter = ',';
    private final String lineDelimiter = '\n';
    public List<Doctor__c> doctors { get; set; }
    public String doctorIdToDelete { get; set; }
    public Doctor__c newDoctor { get; set; }
    public Doctor__c updateDoctor { get; set; }
    public String doctorToUpdate { get; set; }
    public Boolean shouldCloseAddDoctorModal {get; set;}
    public Boolean shouldCloseUpdateDoctorModal {get; set;}
    public String emailAddress {get; set;}

    public HOSP_SoapDoctorManagerController() {
        this.doctor = new Doctor__c();
        this.newDoctor = new Doctor__c();
        this.updateDoctor = new Doctor__c();
        this.shouldCloseAddDoctorModal = false;
        this.shouldCloseUpdateDoctorModal = false;
    }

    public void saveDoctor() {
        HOSP_SOAPCommunicator communicator = new HOSP_SOAPCommunicator();
        shouldCloseAddDoctorModal = communicator.addNewDoctor(newDoctor);
    }

    public void searchDoctors() {
        HOSP_SOAPCommunicator communicator = new HOSP_SOAPCommunicator();
        try {
            this.doctors = communicator.searchDoctors(createQuery());
        } catch (Exception e) {
            clearResults();
            displayInfoMessage(Label.NoDoctorsFound);
        }
    }

    public void readDoctorRecord() {
        shouldCloseUpdateDoctorModal = false;
        for (Doctor__c doctorFromList : doctors) {
            if (doctorFromList.ExternalId__c == doctorToUpdate) {
                updateDoctor = doctorFromList;
            }
        }
    }

    public void updateDoctors() {
        HOSP_SOAPCommunicator communicator = new HOSP_SOAPCommunicator();
        shouldCloseUpdateDoctorModal = communicator.updateExistingDoctor(updateDoctor);
        searchDoctors();
    }

    public void deleteDoctor() {
        HOSP_SOAPCommunicator communicator = new HOSP_SOAPCommunicator();
        communicator.deleteDoctor(doctorIdToDelete); 
        searchDoctors();
    }

    public String createQuery() {
        searchQuery = 'SELECT Id, Name, First_Name__c, Email__c, Country__c, Specialty__c, Licence_Number__c, Phone__c FROM Doctor__c';
        if (string.isNotBlank(doctor.Country__c)) {
            searchQuery += ' WHERE Country__c LIKE \'%' + doctor.Country__c + '%\'';
            if (string.isNotBlank(doctor.First_Name__c)) {
                return searchQuery += ' AND First_Name__c LIKE \'%' + doctor.First_Name__c + '%\'';
            }
            if (string.isNotBlank(doctor.Name)) {
                return searchQuery += ' AND Name LIKE \'%' + doctor.Name + '%\'';
            }
            if (string.isNotEmpty(emailAddress)) {
                return searchQuery += ' AND Email__c LIKE \'%' + emailAddress + '%\'';
            }
            System.debug(searchQuery);
            return searchQuery;
        } else {
            return null;
        }
    }

    public void displayInfoMessage(String message) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, message));
    }

    public void clearResults() {
        try {
            if(doctor != null){
                doctor.clear();
                doctor.Country__c = null;
            }
            if(doctors != null){
                doctors.clear();
                doctors = null;
            }
        } catch (Exception e) {
            displayInfoMessage(e.getMessage());
        }
    }

    public void clearDoctor() {
        try {
            shouldCloseAddDoctorModal = false;
            newDoctor.clear();
            newDoctor.Country__c = null;
        } catch (Exception e) {
            displayInfoMessage(e.getMessage());
        }
    }
}