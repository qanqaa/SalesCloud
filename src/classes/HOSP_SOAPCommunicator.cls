global class HOSP_SOAPCommunicator {
    Doctor__c doctor { get; set; }
    Doctor__c doctorToUpdate { get; set; }
    soapSforceComSchemasClassNewDoctor.DoctorDTO doctorDTO { get; set; }
    soapSforceComSchemasClassNewDoctor.DoctorDTO doctorToUpdateDTO { get; set; }
    public static soapSforceComSchemasClassNewDoctor.HospitalWebService webSrv { get; set; }
    public String searchQuery { get; set; }
    public Boolean shouldCloseAddDoctorModal {get; set;}
    public Boolean shouldCloseUpdateDoctorModal {get; set;}

    public Boolean addNewDoctor(Doctor__c doctor) {
        this.doctorDTO = new soapSforceComSchemasClassNewDoctor.DoctorDTO();
        this.doctorDTO.lastName = doctor.Name;
        this.doctorDTO.firstName = doctor.First_Name__c;
        this.doctorDTO.specialty = doctor.Specialty__c;
        this.doctorDTO.licenceNumber = doctor.Licence_Number__c;
        this.doctorDTO.country = doctor.Country__c;
        this.doctorDTO.phone = doctor.Phone__c;
        this.doctorDTO.emailAdr = doctor.Email__c;
        return createDoctor(doctorDTO);
    }

    public Boolean updateExistingDoctor(Doctor__c doctor) {
        this.doctorToUpdateDTO = new soapSforceComSchemasClassNewDoctor.DoctorDTO();
        this.doctorToUpdateDTO.drID = doctor.ExternalId__c;
        this.doctorToUpdateDTO.lastName = doctor.Name;
        this.doctorToUpdateDTO.firstName = doctor.First_Name__c;
        this.doctorToUpdateDTO.specialty = doctor.Specialty__c;
        this.doctorToUpdateDTO.licenceNumber = doctor.Licence_Number__c;
        this.doctorToUpdateDTO.country = doctor.Country__c;
        this.doctorToUpdateDTO.phone = doctor.Phone__c;
        this.doctorToUpdateDTO.emailAdr = doctor.Email__c;
        return updateDoctor(doctorToUpdateDTO);
    }

    public static void loginToSalesforce() {
        partnerSoapSforceCom.Soap IIOrgSoap = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult IIOrgLoginResult =
                IIOrgSoap.login('kinga.ambroszkiewicz0@gmail.com', 'BardzoMocneHaslo1YmUVbPt0W9TrFSNFEhv6Aemn');
        String sessionId = IIOrgLoginResult.sessionId;
        soapSforceComSchemasClassNewDoctor.SessionHeader_element WebServiceSessionHeader =
                new soapSforceComSchemasClassNewDoctor.SessionHeader_element();

        WebServiceSessionHeader.sessionId = sessionId;
        webSrv = new soapSforceComSchemasClassNewDoctor.HospitalWebService();
        webSrv.SessionHeader = WebServiceSessionHeader;
    }

    public Boolean updateDoctor(soapSforceComSchemasClassNewDoctor.DoctorDTO doctorToUpdateDTO) {
        loginToSalesforce();
        shouldCloseUpdateDoctorModal = webSrv.updateDoctor(doctorToUpdateDTO);
        return shouldCloseUpdateDoctorModal;
    }

    public void deleteDoctor(String id) {
        loginToSalesforce();
        webSrv.deleteDoctor(id);
    }

    public Boolean createDoctor(soapSforceComSchemasClassNewDoctor.DoctorDTO doctorDTO) {
        loginToSalesforce();
        shouldCloseAddDoctorModal = webSrv.createNewDoctor(doctorDTO);
        return shouldCloseAddDoctorModal;
    }

    public List<Doctor__c> searchDoctors(String query) {
        this.searchQuery = query;
        loginToSalesforce();
        List<soapSforceComSchemasClassNewDoctor.DoctorDTO> doctorsDTO = webSrv.searchDoctors(query);
        if (!doctorsDTO.isEmpty()) {
            List<Doctor__c> doctors = new List<Doctor__c>();
            for (soapSforceComSchemasClassNewDoctor.DoctorDTO doctorDTO : doctorsDTO) {
                try {
                    Doctor__c newDoctor = new Doctor__c(
                            ExternalId__c = doctorDTO.drID,
                            Name = doctorDTO.lastName,
                            First_Name__c = doctorDTO.firstName,
                            Email__c = doctorDTO.emailAdr,
                            Country__c = doctorDTO.country,
                            Specialty__c = doctorDTO.specialty,
                            Licence_Number__c = doctorDTO.licenceNumber,
                            Phone__c = doctorDTO.phone);
                    doctors.add(newDoctor);
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Error));
                }
            }
            return doctors;
        }
        return null;
    }

    global class DoctorDTO {
        webService String drID;
        webService String lastName;
        webService String firstName;
        webService String specialty;
        webService String licenceNumber;
        webService String country;
        webService String phone;
        webService String emailAdr;

        global DoctorDTO(Doctor__c doctor) {
            this.drID = doctor.Id;
            this.lastName = doctor.Name;
            this.firstName = doctor.First_Name__c;
            this.specialty = doctor.Specialty__c;
            this.licenceNumber = doctor.Licence_Number__c;
            this.country = doctor.Country__c;
            this.phone = doctor.Phone__c;
            this.emailAdr = doctor.Email__c;
        }
    }
}