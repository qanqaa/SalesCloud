global class sendContactToExternalSystem
{
set<id> id1=new set<id>();

public void sendcontact(string fname,string lname,string title,id id1)
{

senddatatosalesforce2(id1);

}

@future (callout=true)
public static void senddatatosalesforce2(id id2)
{
contact condata=[select firstname,lastname,title,email from contact where id =:id2];
string nametest;
string nametest2;
string titletest;
string emailtest1;
nametest=condata.firstname;
nametest2=condata.lastname;
titletest=condata.title;
emailtest1=condata.email;

partnerSoapSforceCom.Soap mypartnersoap=new partnerSoapSforceCom.Soap();  // Main class:partnerSoapSforceCom  Sublcass:Soap which contains login method

partnerSoapSforceCom.LoginResult  partnerloginresult=mypartnersoap.login('kinga.ambroszkiewicz0@gmail.com','kURWAICHUJ2pNOVo2wAdVUAr3eaQO3qdu25');  
// Return type of login method is "partnerSoapSforceCom.LoginResult"

system.debug('Generated session id is'+partnerloginresult.sessionId);  // Generating session id 

string sessionidfetch=partnerloginresult.sessionId; // Storing session id

soapSforceComSchemasClassReceivepar.SessionHeader_element webservicesessionheader=new soapSforceComSchemasClassReceivepar.SessionHeader_element();

webservicesessionheader.sessionId=sessionidfetch;  // Passing session id to session header element

soapSforceComSchemasClassReceivepar.receiveparameterorg2 objA=new soapSforceComSchemasClassReceivepar.receiveparameterorg2();
objA.SessionHeader=webservicesessionheader;  // Passing session header
string status=objA.createcontactinorganisationsecond(nametest,nametest2,titletest,emailtest1);
system.debug('status of task is'+status );


}


}