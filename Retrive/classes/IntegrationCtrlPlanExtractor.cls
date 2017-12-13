public class IntegrationCtrlPlanExtractor {
  
  public static string getString(Id sourceCrdId){
   List<Partial_Control_Group__c> pcgList=new List<Partial_Control_Group__c>();
   String s='';
   //getting Control and PlanSummary values from the partial_control_group record connected to the current CRD via CSAP_CGLP_Junction__c records.
   pcgList=[SELECT Id,Name,CSAP_Control_ID__c,CSAP_Plan_ID__c FROM Partial_Control_Group__c WHERE Id IN (SELECT Partial_Control_Group__c FROM CSAP_CGLP_Junction__c WHERE CRD__c=:sourceCrdId) ORDER BY Name]; 
    /*for(Partial_Control_Group__c pcg:pcgList){
        s=s+pcg.get('CSAP_Control_ID__c')+','+pcg.get('CSAP_Plan_ID__c')+',';
    } */
    for(Partial_Control_Group__c pcg:pcgList){
    
    String ControlPlanId=string.valueof(pcg.get('CSAP_Plan_ID__c'));
        if(ControlPlanId!= NULL && ControlPlanId.length()>1){
            s=s+pcg.get('CSAP_Control_ID__c')+','+pcg.get('CSAP_Plan_ID__c')+',';
        
        }else{
            s=s+pcg.get('CSAP_Control_ID__c')+','+' '+pcg.get('CSAP_Plan_ID__c')+',';
        } 
     }
    integer i=s.length()-1; 
    if(i<0)//there were no control and plansummary values
     return ''; //returning blank space.
    else //valid values were found.
     return s.substring(0,i);
  }


static testMethod void runtest(){
  CRD__c rec=new CRD__c();
  insert rec;
  Account ac = new Account();
  ac.Name = 'test1';
  insert ac;
  Partial_Control_Group__c pcgrec=new Partial_Control_Group__c();
  pcgrec.CSAP_Control_ID__c='sample';
  pcgrec.CSAP_Plan_ID__c='AB';
  pcgrec.Account__c = ac.id;
  insert pcgrec;
  CSAP_CGLP_Junction__c recjunction=new CSAP_CGLP_Junction__c();
  recjunction.CRD__c=rec.Id;
  recjunction.Partial_Control_Group__c=pcgrec.Id;
  insert recjunction;
  string s=IntegrationCtrlPlanExtractor.getString(rec.Id);
  system.debug('>>>>>>>>'+s);
  system.assertEquals(s,'sample,AB');
    
}

//no partial control group records present. Note: if there is a partial control group record it should always have control and plansummary values
static testMethod void runnegativetest(){
  CRD__c rec=new CRD__c();
  insert rec;
  string s=IntegrationCtrlPlanExtractor.getString(rec.Id);
  system.debug('>>>>>>>>'+s);
  system.assertEquals(s,'');
    
}

}