public with sharing class HOSP_ImportDoctorsController {

    private final String recordDelimiter = ',';
    private final String lineDelimiter = '\n';
    public Blob csvFileBody { get; set; }
    public string csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctors { get; set; }
    public List<DoctorWrapper> wrappedDoctors { get; set; }
    public Boolean shouldCloseAddDoctorModal {get; set;}
    public Boolean shouldCloseUpdateDoctorModal {get; set;}

    public HOSP_ImportDoctorsController() {
        csvFileLines = new String[]{};
        doctors = new List<Doctor__c>();
        wrappedDoctors = new List<DoctorWrapper>();
    }

    public void importCSVFile() {
        doctors.clear();
        wrappedDoctors.clear();
        try {
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split(lineDelimiter);
            String[] headerNames = csvFileLines[0].split(recordDelimiter);
            for (Integer i = 1; i < csvFileLines.size(); i++) {
                Doctor__c doctor = new Doctor__c();
                String[] csvRecordData = csvFileLines[i].split(recordDelimiter);
                for (Integer j = 0; j < csvRecordData.size() - 1; j++) {
                    if (isFieldExists(headerNames[j])) {
                        doctor.put(headerNames[j], csvRecordData[j]);
                    }
                }
                doctors.add(doctor);
            }
            getWrappedDoctors();
        }
        catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, System.Label.ErrorCSV);
            ApexPages.addMessage(errorMessage);
        }
    }

    private Boolean isFieldExists(String fieldName) {
        return Doctor__c.getSObjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }

    public void getWrappedDoctors() {
        for (Doctor__c doctor : doctors) {
            wrappedDoctors.add(new DoctorWrapper(doctor));
        }
    }

    public void importSelectedDoctors() {
        List<Doctor__c> doctorsToImport = new List<Doctor__c>();
        for (DoctorWrapper wrappedDoctor : wrappedDoctors) {
            wrappedDoctor.status = '';
            if (wrappedDoctor.isSelected) {
                doctorsToImport.add(wrappedDoctor.doctor);
            }
        }
        try {
            Database.SaveResult[] updateResults = Database.insert(doctorsToImport, false);
            Integer i = 0;
            for (DoctorWrapper wrappedDoctor : wrappedDoctors) {
                if (wrappedDoctor.isSelected) {
                    if (updateResults[i].isSuccess()) {
                        wrappedDoctor.status = System.Label.Success;
                    }
                    else {
                        for (Database.Error err : updateResults[i].getErrors()) {
                            wrappedDoctor.status = System.Label.Error + err.getMessage();
                        }
                    }
                    i++;
                }
            }
        }
        catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMessage);
        }
    }

    public void selectAllDoctors() {
        for (DoctorWrapper wrappedDoctor : wrappedDoctors) {
            wrappedDoctor.isSelected = true;
        }
    }

    public void unSelectAllDoctors() {
        for (DoctorWrapper wrappedDoctor : wrappedDoctors) {
            wrappedDoctor.isSelected = false;
        }
    }

    public void reverseSelectAllDoctors() {
        for (DoctorWrapper wrappedDoctor : wrappedDoctors) {
            if (wrappedDoctor.isSelected) {
                wrappedDoctor.isSelected = false;
            } else {
                wrappedDoctor.isSelected = true;
            }
        }
    }

    public class DoctorWrapper {
        public Boolean isSelected {
            get;
            set;
        }
        public Doctor__c doctor { get; set; }
        public String status {
            get;
            set;
        }

        public DoctorWrapper(Doctor__c doctor) {
            this.isSelected = true;
            this.doctor = doctor;
            this.status = status;
        }
    }
}