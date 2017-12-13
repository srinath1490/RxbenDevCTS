@isTest
public class CSAdminControllerTest {
static testmethod void TestCSAdminController() {
CSAdminController obj = new CSAdminController();
CSAdminController.getGenre();
CSAdminController.getPlatform();
CSAdminController.getPlatformValue();
CSAdminController.getGenreValue();
obj.save();
}

static testmethod void TestCSAdminSave() {
Profile p = [select id, name from profile  limit 1]; 
User u2 = new User(alias = 'newUser', email='newuser@testorg.com', 
           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
           localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='newuser@inforte.com');
         
        insert u2;
system.runAs(u2){
	gamepref__c myPref = new gamepref__c(setupOwnerId =  u2.Id);
	CSAdminController obj = new CSAdminController();
	obj.myPref = myPref ;
	obj.save();
}
}
}