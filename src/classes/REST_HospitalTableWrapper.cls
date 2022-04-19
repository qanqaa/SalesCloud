public class REST_HospitalTableWrapper {
    public String hospitalId {get; set;}
    public String name {get; set;}
    public String address {get; set;}
    public String externalId {get; set;}
    public Boolean IOrg {get; set;}
    public Boolean IIOrg {get; set;}

    public REST_HospitalTableWrapper(Hospital__c hospital) {
        this.hospitalId = hospital.Id;
        this.name = hospital.Name;
        this.address = hospital.Address__c;
        this.externalId = hospital.ExternalId__c;
        this.IOrg = hospital.Id != null ?  true : false;
        this.IIOrg = hospital.ExternalId__c != null ?  true : false;
    }
}