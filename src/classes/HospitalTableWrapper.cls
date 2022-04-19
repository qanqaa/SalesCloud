global class HospitalTableWrapper {
    public String hospitalId;
    public String name;
    public String address;
    public String externalId;
    public Boolean IOrg;
    public Boolean IIOrg;

    global HospitalTableWrapper(Hospital__c hospital) {
        this.hospitalId = hospital.Id;
        this.name = hospital.Name;
        this.address = hospital.Address__c;
        this.externalId = hospital.ExternalId__c;
        if(hospital.Id != null){
            this.IOrg = true;
        }
        else{
            this.IOrg = false;
        }
        if(hospital.ExternalId__c != null){
            this.IIOrg = true;
        }
        else{
            this.IIOrg = false;
        }
    }
}