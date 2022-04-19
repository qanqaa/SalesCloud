public class REST_CalloutExecutor implements Queueable, Database.AllowsCallouts {
    public String operationType { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public Hospital__c hospital { get; set; }
    public List<REST_HospitalDTO> hospitalsDTO { get; set; }
    public REST_HospitalDTO hospitalDTO { get; set; }
    public static String responseBody;
    public static Integer responseStatusCode;
    HttpRequest request;
    HttpResponse response;

    public REST_CalloutExecutor(String operationType, List<Hospital__c> hospitals) {
        this.operationType = operationType;
        this.hospitals = hospitals;
        hospitalsDTO = REST_ObjectMapper.mapToHospitalsDTO(hospitals);
    }

    public REST_CalloutExecutor(String operationType, List<REST_HospitalDTO> hospitalsDTO) {
        this.operationType = operationType;
        this.hospitals = hospitals;
        this.hospitalsDTO = hospitalsDTO;
    }

    public void execute(QueueableContext context) {
        try{
            if (operationType == REST_OperationType.INSERT_RECORD.name()) {
                Http http = new Http();
                request = REST_Callouts.preparePostHospitalsRequest(hospitalsDTO);
                response = http.send(request);
                List<REST_SyncRequest> syncRequests = (List<REST_SyncRequest>) JSON.deserialize(response.getBody(),
                        List<REST_SyncRequest>.class);
                List<Hospital__c> syncedHospitals = REST_ObjectMapper.mapFromSyncRequestsToHospitals(syncRequests);
                LogBuilder.createLog('Outbound', request, response);
                HOSP_TriggerUtilities.runTrigger = false;
                update syncedHospitals;

            } else if (operationType == REST_OperationType.UPDATE_RECORD.name()) {
                Http http = new Http();
                request = REST_Callouts.preparePatchHospitalsRequest(hospitalsDTO);
                response = http.send(request);
                List<REST_SyncRequest> syncRequests = (List<REST_SyncRequest>) JSON.deserialize(response.getBody(),
                        List<REST_SyncRequest>.class);
                LogBuilder.createLog('Outbound', request, response);

            } else if (operationType == REST_OperationType.DELETE_RECORD.name()) {
                Http http = new Http();
                request = REST_Callouts.prepareDeleteHospitalsRequest(hospitalsDTO);
                response = http.send(request);
                List<REST_SyncRequest> syncRequests = (List<REST_SyncRequest>) JSON.deserialize(response.getBody(),
                        List<REST_SyncRequest>.class);
                LogBuilder.createLog('Outbound', request, response);
            }
        }
        catch(Exception e){
            responseStatusCode = 500;
            LogBuilder.createLog('Outbound', request, responseStatusCode, e.getStackTraceString() + ' - ' + e.getMessage());
        }
    }
}