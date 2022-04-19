public with sharing class REST_HospitalSearcherController {
    public Hospital__c hospital { get; set; }
    public String searchQuery { get; set; }
    public Integer size { get; set; }
    public List<REST_HospitalTableWrapper> hospitalsTableWrapper { get; set; }
    public Hospital__c newHospital { get; set; }
    public Hospital__c updateHospital { get; set; }
    public Hospital__c deleteHospital { get; set; }
    public REST_HospitalDTO deleteHospitalDTO { get; set; }
    public String hospitalIdToUpdate { get; set; }
    public String hospitalIdToUpdateExternal { get; set; }
    public String hospitalIdToDelete { get; set; }
    public String hospitalIdToDeleteExternal { get; set; }
    public Boolean shouldCloseAddHospitalModal { get; set; }
    public Boolean shouldCloseUpdateHospitalModal { get; set; }
    public REST_HospitalDTO hospitalDTO { get; set; }
    public Boolean shouldDisplayToastMsg { get; set; }

    public REST_HospitalSearcherController() {
        this.hospital = new Hospital__c();
        this.newHospital = new Hospital__c();
        this.updateHospital = new Hospital__c();
        this.deleteHospital = new Hospital__c();
        this.shouldCloseAddHospitalModal = false;
        this.shouldCloseUpdateHospitalModal = false;
        this.shouldDisplayToastMsg = false;
    }

    public void saveHospital() {
        Hospital__c hospitalToSave = new Hospital__c(
                Name = newHospital.Name,
                Address__c = newHospital.Address__c
        );
        Database.SaveResult saveResult = Database.insert(hospitalToSave);
        if (saveResult.isSuccess()) {
            shouldCloseAddHospitalModal = true;
            shouldDisplayToastMsg = true;
        } else {
            for (Database.Error err : saveResult.getErrors()) {
                displayInfoMessage(err.getStatusCode() + ': ' + err.getMessage());
            }
        }
    }

    public void searchHospitals() {
        try {
            List<Hospital__c> hospitalsFromOrg = Database.query(createQuery());
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:IIORG/apexrest/Hospital__c?' + createEndpointQuery(hospital.Name, hospital.Address__c));
            request.setMethod('GET');
            Http http = new Http();
            HTTPResponse response = http.send(request);
            List<REST_HospitalDTO> hospitalsDTOFrom2ndOrg = (List<REST_HospitalDTO>) JSON.deserialize(response.getBody(),
                    List<REST_HospitalDTO>.class);
            List<Hospital__c> hospitalsFrom2ndOrg = REST_ObjectMapper.mapToHospitalsFrom2Org(hospitalsDTOFrom2ndOrg);
            List<Hospital__c> allHospitals = new List<Hospital__c>();
            allHospitals.addAll(hospitalsFromOrg);
            for (Hospital__c hospitalFrom2ndOrg : hospitalsFrom2ndOrg) {
                if (!allHospitals.contains(hospitalFrom2ndOrg)) {
                    allHospitals.add(hospitalFrom2ndOrg);
                }
            }
            createHospitalTableWrapperList(allHospitals);
            LogBuilder.createLog('Outbound', request, response);
        } catch (Exception e) {
            clearResults();
            displayInfoMessage(e.getMessage());
        }
    }

    public void readHospitalRecord() {
        shouldCloseUpdateHospitalModal = false;
        shouldDisplayToastMsg = false;
        if (hospitalIdToUpdate.length() > 0) {
            for (REST_HospitalTableWrapper hospitalTableWrapper : hospitalsTableWrapper) {
                if (hospitalTableWrapper.hospitalId == hospitalIdToUpdate) {
                    updateHospital = REST_ObjectMapper.mapFromHospitalTableWrapperToHospital(hospitalTableWrapper);
                }
            }
        } else {
            for (REST_HospitalTableWrapper hospitalTableWrapper : hospitalsTableWrapper) {
                if (hospitalTableWrapper.externalId == hospitalIdToUpdateExternal) {
                    updateHospital = REST_ObjectMapper.mapFromHospitalTableWrapperToHospital(hospitalTableWrapper);
                }
            }
        }
    }

    public void updateHospitals() {
        if (hospitalIdToUpdate.length() > 0) {
            Database.SaveResult saveResult = Database.update(updateHospital);
//            HOSP_TriggerUtilities.runTrigger = false;

            if (saveResult.isSuccess()) {
                shouldCloseUpdateHospitalModal = true;
                shouldDisplayToastMsg = true;

            } else {
                for (Database.Error err : saveResult.getErrors()) {
                    displayInfoMessage(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        } else {
            List<Hospital__c> tmpListToUpdate = new List<Hospital__c>();
            tmpListToUpdate.add(updateHospital);
            System.enqueueJob(new REST_CalloutExecutor(REST_OperationType.UPDATE_RECORD.name(), tmpListToUpdate));
//            HOSP_TriggerUtilities.runTrigger = false;
            shouldCloseUpdateHospitalModal = true;
            shouldDisplayToastMsg = true;
        }
    }

    public void deleteHospitals() {
        if (hospitalIdToDelete.length() > 0) {
            for (REST_HospitalTableWrapper hospitalTableWrapper : hospitalsTableWrapper) {
                if (hospitalTableWrapper.hospitalId == hospitalIdToDelete) {
                    deleteHospital.Id = hospitalTableWrapper.hospitalId;
                    break;
                }
            }
            try {
                Database.DeleteResult dr = Database.delete(deleteHospital);
            } catch (Exception e) {
                displayInfoMessage(e.getMessage());
            }
        } else {
            for (REST_HospitalTableWrapper hospitalTableWrapper : hospitalsTableWrapper) {
                if (hospitalTableWrapper.externalId == hospitalIdToDeleteExternal) {
                    deleteHospital.ExternalId__c = hospitalTableWrapper.externalId;
                    break;
                }
            }
            deleteHospitalDTO = new REST_HospitalDTO(deleteHospital);
            List<REST_HospitalDTO> hospitalsToDeleteDTO = new List<REST_HospitalDTO>();
            hospitalsToDeleteDTO.add(deleteHospitalDTO);
            System.enqueueJob(new REST_CalloutExecutor(REST_OperationType.DELETE_RECORD.name(), hospitalsToDeleteDTO));
        }
    }

    public String createQuery() {
        searchQuery = 'SELECT Id, Name, Address__c, ExternalId__c FROM Hospital__c';
        if (string.isNotEmpty(hospital.Name) || string.isNotEmpty(hospital.Address__c)) {
            searchQuery += ' WHERE ';
        }
        if (string.isNotEmpty(hospital.Name)) {
            searchQuery += 'Name LIKE \'%' + hospital.Name + '%\'';
        }
        if (string.isNotEmpty(hospital.Name) && string.isNotEmpty(hospital.Address__c)) {
            searchQuery += ' AND ';
        }
        if (string.isNotEmpty(hospital.Address__c)) {
            return searchQuery += 'Address__c LIKE \'%' + hospital.Address__c + '%\'';
        } else {
            return searchQuery;
        }
    }

    public String createEndpointQuery(String hospitalName, String hospitalAddress) {
        String queryInfo = '';
        if (hospitalName != null) {
            hospitalName = hospitalName.replace(' ', '%20');
            queryInfo += 'name=' + hospitalName;

        }
        if (hospitalAddress != null) {
            hospitalAddress = hospitalAddress.replace(' ', '%20');
            queryInfo += '&address=' + hospitalAddress;

        }
        return queryInfo;
    }

    public void createHospitalTableWrapperList(List<Hospital__c> allHospitals) {
        hospitalsTableWrapper = new List<REST_HospitalTableWrapper>();
        for (Hospital__c hospital : allHospitals) {
            REST_HospitalTableWrapper hospitalTableWrapper = new REST_HospitalTableWrapper(hospital);
            hospitalsTableWrapper.add(hospitalTableWrapper);
        }
    }

    public void displayInfoMessage(String message) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, message));
    }

    public void clearResults() {
        try {
            if (hospital != null) {
                hospital.clear();
            }
            if (hospitalsTableWrapper != null) {
                hospitalsTableWrapper.clear();
                hospitalsTableWrapper = null;
            }
        } catch (Exception e) {
            displayInfoMessage(e.getMessage());
        }
    }

    public void clearHospital() {
        try {
            newHospital.clear();
            shouldCloseAddHospitalModal = false;
            shouldDisplayToastMsg = false;
        } catch (Exception e) {
            displayInfoMessage(e.getMessage());
        }
    }
}