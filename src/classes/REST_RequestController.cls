@RestResource(urlMapping = '/Hospital__c/*')
global class REST_RequestController {

    @HttpPost
    global static List<REST_SyncRequest> insertHospitals() {
        String body = RestContext.request.requestBody.toString();
        return REST_RequestService.insertHospitals(body);
    }

    @HttpGet
    global static List<REST_HospitalDTO> readHospitalsByParameters() {
        String body = RestContext.request.requestBody.toString();
        RestRequest hospitalRequest = RestContext.request;
        Map<String,String> hospitalRequestParams = hospitalRequest.params;
        String hospitalName = hospitalRequestParams.get('name');
        String hospitalAddress = hospitalRequestParams.get('address');
        return REST_RequestService.readHospitalsByParameters(hospitalName, hospitalAddress);
    }

    @HttpPatch
    global static List<REST_SyncRequest> updateHospitals() {
        String body = RestContext.request.requestBody.toString();
        return REST_RequestService.updateHospitals(body);
    }

    @HttpDelete
    global static List<REST_SyncRequest> deleteHospitals() {
        String body = RestContext.request.requestBody.toString();
        return REST_RequestService.deleteHospitals(body);
    }
}