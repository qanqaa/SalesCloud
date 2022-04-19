global class REST_SyncRequest {

    public String operationType;
    public REST_HospitalDTO hospitalDTO;
    public String status;

    global REST_SyncRequest(String operationType, REST_HospitalDTO hospitalDTO, String status){
        this.operationType = operationType;
        this.hospitalDTO = hospitalDTO;
        this.status = status;
    }
}