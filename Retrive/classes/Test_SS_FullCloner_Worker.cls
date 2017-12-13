//=============================
   // Meta Information
   //=============================  
   // Namespace or Enhancement:SS_FullCloner. Test for generic class that can be used to clone record and all child records.
   // Description: Class is called by controller or another facade class. Clone parent record and all related child records.
   // Called by:Another class
  
   /*==================================================================================
   Version                                  Author     Date                     Reason
   1.0                                      Saraag     July 11,13               Created 
   ====================================================================================*/
@isTest
public class Test_SS_FullCloner_Worker  {
    
    /*public static Account a;
    public static Contact c;

    private static testMethod void Positive_cloneAllRecord() {
        SS_FullCloner_Worker cloner=new SS_FullCloner_Worker();
        dataGenerator();
        Account cloneda=(Account)cloner.getClone(a.Id);
        cloneda.Name='thisiscloned';
        cloner.save();
        system.debug('contacts:'+cloneda.Id);
        system.assert([select Id from contact where accountId=:a.Id][0].Id!=null);
        
        system.assert([select Id from contact where accountId=:cloneda.Id][0].Id!=null);
        
        
    }
    
    private static testMethod void Positive_clonewithExceptions() {
        SS_FullCloner_Worker cloner=new SS_FullCloner_Worker(new List<String>{'Contact'});
        dataGenerator();
        Account cloneda=(Account)cloner.getClone(a.Id);
        cloneda.Name='thisiscloned';
        cloner.save();
        system.assert([select Id from contact where accountId=:cloneda.Id].size()==0);
        
    }
        
    private static testMethod void Negative_noRecId() {
        SS_FullCloner_Worker cloner=new SS_FullCloner_Worker();
        system.assertEquals(cloner.getClone(null),NULL);
    }
    
    private static testMethod void Negative_DMLErrors() {
        SS_FullCloner_Worker cloner=new SS_FullCloner_Worker(NULL);
    }
    
    
    private static testMethod void Negative_runasUser() {
        // TO DO: implement unit test
    }
    
    public static void  dataGenerator(){
        a=new Account(Name='sampleSS');
        insert a;
        c=new Contact(AccountId=a.Id,LastName='Optimus');
        Insert c;
    }*/
    
}