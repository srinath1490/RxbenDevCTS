global class CRDB_BoomiLoadAlert implements schedulable{
    
    global void execute(SchedulableContext sc) {
        this.verifyLoad();
    }
		
     public void verifyLoad(){
        Decimal CBONcount = (Decimal) [SELECT Count(Id) CBONc FROM CRDBuildOrder__c where createddate=today][0].get('CBONc');
        if(CBONcount==0){
            sendEmail('Error. No file loaded','No records were loaded in PERS full report today.');
         }
        else if (CBONcount<100){
            sendEmail('Warning. Low pers volume','Only '+string.valueof(CBONcount)+' plans were loaded.' );
        }
        else if(CBONcount>2000)
            sendEmail('Warning. High pers volume','High volume of '+string.valueof(CBONcount)+' plans loaded today.');
     
    }
    private void sendEmail(string msubject,string mbody){

   	       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		   String[] toAddresses = System.Label.CRDB_boomi_alert_distribution_list.split(',',0);
           toAddresses.add('saraagreddy@gmail.com');
           toAddresses.add('3202916872@txt.att.net');
		   mail.setToAddresses(toAddresses);
		   mail.setSubject('CRDB Alert-'+msubject);
		   mail.setPlainTextBody(mbody);
		   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

   }
    
    
}