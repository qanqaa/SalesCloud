public class HOSP_DoctorController {

    public Doctor__c doctor { get; set; }
    public String searchQuery { get; set; }
    public Integer size { get; set; }
    public List<SelectOption> paginationSizeOptions { get; set; }
    public String FileBodyString { get; set; }
    public List<Doctor__c> allDoctors { get; set; }
    private final String recordDelimiter = ',';
    private final String lineDelimiter = '\n';

    public HOSP_DoctorController() {
        doctor = new Doctor__c();
        size = 5;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5', '5'));
        paginationSizeOptions.add(new SelectOption('10', '10'));
        paginationSizeOptions.add(new SelectOption('20', '20'));
        paginationSizeOptions.add(new SelectOption('50', '50'));
        paginationSizeOptions.add(new SelectOption('100', '100'));
    }

    public ApexPages.StandardSetController setCon {
        get {
            if (setCon == null) {
                setCon = new ApexPages.StandardSetController(new List<Doctor__c>());
                setCon.setPageSize(size);
            }
            return setCon;
        }
        set;
    }

    public PageReference refreshPageSize() {
        setCon.setPageSize(size);
        return null;
    }

    public List<Doctor__c> getDoctors() {
        return (List<Doctor__c>) setCon.getRecords();
    }

    public void searchDoctors() {
        setCon = new ApexPages.StandardSetController(Database.query(createQuery()));
        setCon.setPageSize(size);
        allDoctors = Database.query(createQuery()); 
        if (setCon.getRecords().isEmpty()) {
            displayInfoMessage (Label.NoDoctorsFound);
        }
    }

    public String createQuery() {
        searchQuery = 'SELECT Name, First_Name__c, Email__c, Country__c, Specialty__c, Licence_Number__c, Phone__c FROM Doctor__c';
        if (string.isNotBlank(doctor.Country__c)) {
            searchQuery += ' WHERE Country__c LIKE \'%' + doctor.Country__c + '%\'';
            if (string.isNotBlank(doctor.First_Name__c)) {
                return searchQuery += ' AND First_Name__c LIKE \'%' + doctor.First_Name__c + '%\'';
            }
            if (string.isNotBlank(doctor.Name)) {
                return searchQuery += ' AND Name LIKE \'%' + doctor.Name + '%\'';
            }
            if (string.isNotBlank(doctor.Email__c)) {
                return searchQuery += ' AND Email__c LIKE \'%' + doctor.Email__c + '%\'';
            }
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
            setCon = new ApexPages.StandardSetController(new List<Doctor__c>());
            doctor.Country__c = null;
        } catch (Exception e) {
            displayInfoMessage(e.getMessage());
        }
    }

    public void generateDoctorsFile() {
        FileBodyString =
                'First_Name__c' + recordDelimiter +
                'Name' + recordDelimiter +
                'Email__c' + recordDelimiter +
                'Specialty__c' + recordDelimiter +
                'Licence_Number__c' + recordDelimiter +
                'Country__c' + recordDelimiter +
                'Phone__c' + lineDelimiter;
        Integer i = 1;
        for (Doctor__c doctor : allDoctors) {
            String doctorRecord =
                    doctor.First_Name__c + recordDelimiter +
                    doctor.Name + recordDelimiter +
                    doctor.Email__c + recordDelimiter +
                    doctor.Specialty__c + recordDelimiter +
                    doctor.Licence_Number__c + recordDelimiter +
                    doctor.Country__c + recordDelimiter +
                    doctor.Phone__c;
            if (i != allDoctors.size()) {
                doctorRecord += lineDelimiter;
            }
            FileBodyString += doctorRecord;
            i++;
        }
    }

    public PageReference pageCSV() {
        generateDoctorsFile();
        PageReference CSVPage = new PageReference('/apex/HOSP_ExportDoctorsToCSV');
        CSVPage.setRedirect(false);
        return CSVPage;
    }

    public PageReference pageXLS() {
        generateDoctorsFile();
        PageReference XLSPage = new PageReference('/apex/HOSP_ExportDoctorsToXLS');
        XLSPage.setRedirect(false);
        return XLSPage;
    }
}