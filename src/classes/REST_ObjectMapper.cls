public class REST_ObjectMapper {

    Hospital__c hospital { get; set; }
    REST_HospitalDTO hospitalDTO { get; set; }

    public static List<Hospital__c> mapToHospitals(List<REST_HospitalDTO> hospitalsDTO) {
        List<Hospital__c> hospitals = new List<Hospital__c>();
        try {
            for (REST_HospitalDTO hospitalDTO : hospitalsDTO) {
                Hospital__c hospital = new Hospital__c(
                        Id = hospitalDTO.hospitalId,
                        Name = hospitalDTO.name,
                        Address__c = hospitalDTO.address,
                        ExternalId__c = hospitalDTO.externalId);
                hospitals.add(hospital);
            }
        } catch (Exception e) {
            return null;
        }
        return hospitals;
    }

    public static List<Hospital__c> mapToHospitalsFrom2Org(List<REST_HospitalDTO> hospitalsDTO) {
        List<Hospital__c> hospitals = new List<Hospital__c>();
        try {
            for (REST_HospitalDTO hospitalDTO : hospitalsDTO) {
                Hospital__c hospital = new Hospital__c();
                if(hospitalDTO.externalId != null){
                    hospital.Id = hospitalDTO.externalId;
                }
                hospital.Name = hospitalDTO.name;
                hospital.Address__c = hospitalDTO.address;
                hospital.ExternalId__c = hospitalDTO.hospitalID;
                hospitals.add(hospital);
            }
        } catch (Exception e) {
            return null;
        }
        return hospitals;
    }

    public static List<REST_HospitalDTO> mapToHospitalsDTO(List<Hospital__c> hospitals) {
        List<REST_HospitalDTO> hospitalsDTO = new List<REST_HospitalDTO>();
        try {
            for (Hospital__c hospital : hospitals) {
                REST_HospitalDTO hospitalDTO = new REST_HospitalDTO(hospital);
                hospitalsDTO.add(hospitalDTO);
            }

        } catch (Exception e) {
            return null;
        }
        return hospitalsDTO;
    }

    public static List<REST_SyncRequest> mapToSyncRequests(String operationType, List<REST_HospitalDTO> hospitalsDTO, String status) {
        List<REST_SyncRequest> recordsToSync = new List<REST_SyncRequest>();
        try {
            for (REST_HospitalDTO hospitalDTO : hospitalsDTO) {
                REST_SyncRequest syncRequest = new REST_SyncRequest(operationType, hospitalDTO, status);
                recordsToSync.add(syncRequest);
            }
        } catch (Exception e) {
            return null;
        }
        return recordsToSync;
    }

    public static List<Hospital__c> mapFromSyncRequestsToHospitals(List<REST_SyncRequest> syncRequests) {
        List<Hospital__c> hospitals = new List<Hospital__c>();
        List<REST_HospitalDTO> hospitalsDTO = new List<REST_HospitalDTO>();
        try {
            for (REST_SyncRequest syncRequest : syncRequests) {
                hospitalsDTO.add(syncRequest.hospitalDTO);
            }
            for (REST_HospitalDTO hospitalDTO : hospitalsDTO) {
                Hospital__c hospital = new Hospital__c(
                        Id = hospitalDTO.externalId,
                        Name = hospitalDTO.name,
                        Address__c = hospitalDTO.address,
                        ExternalId__c = hospitalDTO.hospitalId);
                hospitals.add(hospital);
            }
        } catch (Exception e) {
            return null;
        }
        return hospitals;
    }

    public static Hospital__c mapFromHospitalTableWrapperToHospital(REST_HospitalTableWrapper hospitalTableWrapper) {
        try {
            Hospital__c hospital = new Hospital__c(
                    Id = hospitalTableWrapper.hospitalId,
                    Name = hospitalTableWrapper.name,
                    Address__c = hospitalTableWrapper.address,
                    ExternalId__c = hospitalTableWrapper.externalId);
            return hospital;
        } catch (Exception e) {
            return null;
        }
    }
}