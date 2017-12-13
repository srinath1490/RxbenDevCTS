public without sharing class provLineAdvViewCNTRL {
         //=============================
   // Meta Information
   //=============================      
   // Namespace or Enhancement: 8533b case automation- March 15,2014
   // Description: check error on nonpackage compelx cases. A prov+lv should apply to all plans for a CRD.
   // Called by:
  
   /*==================================================================================
   Version              Author                  Date                    Reason
   1.0          Saraag                  3/15/2014               Created 
   ====================================================================================*/
    //============================
   // Constructor
   //============================
        //constructor
        public provlineAdvViewCNTRL(Apexpages.standardcontroller std){
                controller=std;
                iscomplex=false;
                CaseQueueId=[Select queueId from QueueSobject q where q.Queue.Name ='Case – Complex Changes' AND q.SobjectType='Case'][0].queueId;

        }
        
   
   //============================
   // Member variabels   
   //============================
   public apexpages.standardcontroller                                             controller;                                                             //to store standard controller
   public  Map<string,boolean>                                                      provlvErrorMap {get;private set;}                               //provline+is there an error. if empty=no change
   public  Map<string,set<string>>                                                  provLvMissingPlansMap {get;private set;}                //plans under CRD are not on the changes
   public  Map<string,set<string>>                                                  proLvPlansnotonCRDMap {get;private set;}                //plans under changes are not on CRD
   public  transient Boolean                                                        isComplex{public get;private set;}              //it the case complex?
   public  transient Boolean                                          				errorChecked{get;private set;}
   public  Map<string,Provisional_Lines__c>                                         provlv_to_Prov;
   private Id																		CaseQueueId;
   //=============================
   // Member Methods  
   //=============================
   
   // Method Name:
   // Arguments:
   // Return:
   // Description:
   public pagereference checkerror(){
                //question: do we need to also consider controls?
                //what happens if I get a change for a plan not attached to the CRD? If yes, change 66 section
                isComplex=false;
                Map<string,set<string>> provLinePlanMap=new Map<string,set<string>>();
                provlvErrorMap=new Map<string,boolean>();
                provLvMissingPlansMap=new Map<string,set<string>>();
                proLvPlansnotonCRDMap=new Map<string,set<string>>();
                set<string> csap_planSet=new set<string>(); 
                provlv_to_Prov=new Map<string,Provisional_Lines__c>();
                //get data
                case caserec=[select id,crd_name__c,ControlEffective__c,OwnerId,PERSComplexCase__c,Status from case where id=:controller.getId()][0];
                Id crdid=caserec.crd_name__c;
                if(crdid==null||caserec.controleffective__c==null){
	                if(crdid==null)
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'CRD Name value on Case is missing.'));
	                if(caserec.ControlEffective__c==null)
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Control Effective value on Case is missing.'));
	                
	               return NULL;
                }
                //build <prov+lv,set<plan>> map
                for(Provisional_Lines__c pl:[select Id,NEW_PROV_LNG_NAME__c,NEW_LINE_VAL_TXT__c,NEW_PROV_NUM__c,NEW_LINE_VAL_NO__c,PLSM_CD__c from Provisional_Lines__c where case__c=:caserec.Id]){
                        string LocalKey=string.valueOf(pl.NEW_PROV_NUM__c)+string.valueof(pl.NEW_LINE_VAL_NO__c);
                        set<string> localset=new set<string>();
                        if(provLinePlanMap.containsKey(LocalKey)){
                                localset=provLinePlanMap.get(LocalKey);
                                localset.add(pl.PLSM_CD__c);
                        }
                        else
                                localset.add(pl.PLSM_CD__c);
                                
                        provLinePlanMap.put(LocalKey,localset);
                        provlv_to_Prov.put(LocalKey,pl);
                }
                
                //build plan set from pcgList for the control
                string control=LPAD(caserec.ControlEffective__c.substring(0,caserec.ControlEffective__c.length()-10),7,'0');
                for(CSAP_CGLP_Junction__c csap:[select Id,Partial_Control_Group__r.CSAP_Plan_ID__c from CSAP_CGLP_Junction__c where crd__c=:crdid and Partial_Control_Group__c!=null and Partial_Control_Group__r.CSAP_Control_ID__c=:control]){
                        csap_planSet.add(csap.Partial_Control_Group__r.CSAP_Plan_ID__c);
                }
                system.debug(csap_planSet);
                system.debug(provLinePlanMap);
                //for each key in provlinemap->do containsall on pcgList
                        //If false, find which doesn't exist 
                 //=>both cases, build 
                 for(string provLv:provLinePlanMap.keyset()){ //set 1 contains set2 and set2 contains set1=>set1 should be equal to set2.
                        Boolean a=provLinePlanMap.get(provLv).containsAll(csap_planSet);
                        if(!a){//there were Plans under CRD that were not part of the change
                                set<string> provLinePlanLocalset=new set<string>();
                                provLinePlanLocalset.addAll(csap_planSet);
                                provLinePlanLocalset.removeAll(provLinePlanMap.get(provLv));
                                isComplex=true;
                                provLvMissingPlansMap.put(provLv,provLinePlanLocalset);
                        }
                        Boolean b=csap_planSet.containsAll(provLinePlanMap.get(provLv));
                        if(!b){//there are plans under the case as casecontrolplans that are not under the CRD. This should have created a new CPE case, but the lookup table
                                   //could have had incorrect entries.                                          
                                set<string> csap_plansetLocalset=new set<string>();
                                csap_plansetLocalset.addAll(provLinePlanMap.get(provLv));
                                csap_plansetLocalset.removeAll(csap_planset);                            
                                
                                proLvPlansnotonCRDMap.put(provLv,csap_plansetLocalset);//these plans on prov+lv are not on CRD. 
                        }
                        provlvErrorMap.put(provLv,a&&b);
                 }
                 errorChecked=true;
                 if(errorchecked&&isComplex&&!caserec.PERSComplexCase__c){//complex case which wasn't previously marked as complex.
                 	caserec.OwnerId=CaseQueueId;
                 	caserec.Status='Additional Research Needed';
                 	caserec.PERScomplexcase__c=true;
                 	update caserec;
                 }   
                 return NULL;
        }
        
   //=============================
   // Member Class  
   //=============================
   public class provlineAdvException extends exception{}
   
   public class ErrorData{
        public string prov{get;set;}
        public string provName{get;set;}
        public string lv{get;set;}
        public string lvName{get;set;}
        public string missingplans{get;set;}
        public ErrorData(Decimal pval,string ptxt,Decimal lval,string lname,string plans){
                prov=string.valueof(pval);
                provName=ptxt;
                lv=string.valueof(lval);
                lvName=lname;
                missingplans=plans;
        }
   
   }
   public List<ErrorData> getErrorData(){
         if(isComplex){
                List<ErrorData> errorList=new List<ErrorData>();
                for(string pl:provLvMissingPlansMap.keyset()){
                        string planlist='';
                        for(string plan:provLvMissingPlansMap.get(pl)){
                                planlist+=plan+',';
                                system.debug(logginglevel.finest,'plan:'+plan);
                        }
                        system.debug(logginglevel.finest,'planlist:'+planlist);
                  errorList.add(new ErrorData(provlv_to_Prov.get(pl).NEW_PROV_NUM__c,provlv_to_Prov.get(pl).NEW_PROV_LNG_NAME__c,provlv_to_Prov.get(pl).NEW_LINE_VAL_NO__c,provlv_to_Prov.get(pl).NEW_LINE_VAL_TXT__c,planlist.substring(0,planlist.length()-1)));
                }
                return errorList;
         }
         else
                return NULL;
   }
  
   public static string LPAD(string s,Integer requiredLength,string padChar){
   	if(s.Length()<requiredLength){
   		s=padChar+s;
   		return LPAD(s,requiredLength,padChar);
   	}
   	else
   		return s;
   }
                
}//End class provLineAdvViewCNTRL