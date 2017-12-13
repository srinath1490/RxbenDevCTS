public without sharing class ProvLineDomain_ALT {
	//=============================
   // Meta Information
   //=============================	
   // Namespace or Enhancement:Domain class called PERSprocessors.
   // Description:ALTERNATE CODE TO HANDLE PERS DATA LOADED ON DAY OTHER THAN CREATEDDATE. USE WITH CAUTION.
   // Called by:BAT_PERSNonPkgProcessor_ALT only!
  
   /*==================================================================================
   Version							Author				Date					Reason
   1.0								Saraag				2/27/2014				Created	
   ====================================================================================*/

  
 public static void handleProvLineDML(Map<string,Provisional_Lines__c> upsertMap_pvl){
   if(upsertMap_pvl!=null&&!upsertMap_pvl.isEmpty()){	
   	//FILTER OUT existing provlines based on timestamps.
   	for(Provisional_Lines__c pvLineRecord:[SELECT PersreportTimestamp__c,key__c FROM  Provisional_Lines__c WHERE Key__c IN:upsertMap_pvl.keyset() AND PersreportTimestamp__c!=NULL]){
   		if(upsertMap_pvl.get(pvLineRecord.key__c).PersreportTimestamp__c<=pvLineRecord.PersreportTimestamp__c){//newer values
   			upsertMap_pvl.remove(pvLineRecord.key__c); //no need to update.
   		}
   	}
   if(upsertMap_pvl!=NULL&&!upsertMap_pvl.isEmpty()){	
   	if(!System.Label.PerformanceMode.equalsIgnoreCase('False')){    //performance mode true
           Try{
           		upsert upsertMap_pvl.values() key__c;
           }Catch(Exception e){
           	   If(e.getTypeName()=='DmlException')
           	     system.debug(logginglevel.error,'FATAL DML Exception: PERSpkgProcessing with PerformanceMode enabled.Msg:'+e.getMessage());
           	   else
           	      insert ErrorLogger.getRecord('Error inserting into provline.PERFORMANCE','5','BCTCaseAutomation','Performance=true. Exception object:'+JSON.serializePretty(e),NULL,true,UserInfo.getUserId(),'Batch','BAT_TradStdPkgProcessor', 322,'solipurams@aetna.com');
           	      
           }
    }
    Else{ //panic mode.
	   	list<id> successIds=new List<Id>();
	   	set<string> uniqueErrorMessages=new set<string>();
	   	Database.UpsertResult[] saveres=Database.upsert(upsertMap_pvl.values(),Provisional_Lines__c.Fields.key__c,false);//allowing partial inserts.
	   	 for(Database.UpsertResult sr:saveres){
				    	if(sr.isSuccess()){
				    		successIds.add(sr.getId());
				    	}
				    	else{
				    		for(Database.Error err : sr.getErrors()) {
					           uniqueErrorMessages.add(err.getMessage());
				            }
				    	}
	     }
	     
	     	//-----Find records that did not succeed.
		    for(Provisional_Lines__c c4:[SELECT Key__c FROM Provisional_Lines__c WHERE Id IN:successIds]){
		    //insert errorrecord with all the unique error messages.
		    //Now we have both success inserts and unique error messages.
		        upsertMap_pvl.remove(c4.key__c); //at the end argupmap will only have failed ones.
		    }
		    Integer j=0;
		    List<Error_Log__c> errorList=new List<Error_Log__c>();
		    for(Provisional_Lines__c c5:upsertMap_pvl.values()){
		    	//insert records errorlog records
		    	j++;
		    	if(j==1)//only for error
		    		errorList.add(ErrorLogger.getRecord('Error inserting into Provlines.PANIC','5','BCTCaseAutomation','Failed to insert ProvLine:'+JSON.serialize(c5),NULL,true,UserInfo.getUserId(),'Batch','BAT_PersPkgProcessor', 192,'solipurams@aetna.com'));
		    	else
		    		errorList.add(ErrorLogger.getRecord('Error inserting into Provlines.PANIC','5','BCTCaseAutomation','Failed to insert ProvLine:'+JSON.serialize(c5),NULL,false,UserInfo.getUserId(),'Batch','BAT_PersPkgProcessor', 192));
		    }
		    
		    insert errorlist; //inserting errors.
   	 }
    }
   }
  }
  
   public static Provisional_Lines__c getRecord(PERS_report__c persrec,Id caseId,string plan){ //called for PERS non package CRD-Y,Case-N scenario. Key is different. Cases are created for control+eff under a CRD, all provline records are under this case they also need Plan
         Provisional_Lines__c pl=getRecord(persrec,caseId);
         if(plan!=null&&plan!=''&&plan.length()<3&&plan.length()>0) //valid plan       
            pl.key__c=pl.key__c+plan;
         return pl;
   }
  
   
   //Returns ProvisionalLine record following mapping
   public static Provisional_Lines__c getRecord(PERS_report__c persrec,Id caseId){
   	     if(persrec!=NULL&&caseId!=NULL)
   		 	return (new Provisional_Lines__c(
	   	  								PersreportTimestamp__c=persrec.EDITimestamp__c,
	   	  								NEW_LINE_VAL_NO__c=persrec.NEW_LINE_VAL_NO__c,
	   	  								NEW_PROV_NUM__c=persrec.NEW_PROV_NUM__c,
	   	  								Case__c=caseId,
	   	  								key__c=caseId+String.valueof(persrec.NEW_PROV_NUM__c),
	   	  								BNFT_STATUS_CD__c=persrec.BNFT_STATUS_CD__c,
	   	  								CONTRACT_STATE__c=persrec.CONTRACT_STATE__c,
	   	  								CONTROL_NAME__c=persrec.CONTROL_NAME__c,
	   	  								CONTROL_NO__c=persrec.CONTROL_NO__c,
	   	  								ControlPlanEffective__c=persrec.ControlPlanEffective__c,
	   	  								CTL_RSPN_BSNS_CD__c=persrec.CTL_RSPN_BSNS_CD__c,
	   	  								CTRL_STATUS_CD__c=persrec.CTRL_STATUS_CD__c,
	   	  								DEL_REMARK__c=persrec.DEL_REMARK__c,
	   	  								NEW_ID_TYPE__c=persrec.NEW_ID_TYPE__c,
	   	  								NEW_INFRC_EFF_DATE__c=persrec.NEW_INFRC_EFF_DATE__c,
	   	  								NEW_LINE_VAL_TXT__c=persrec.NEW_LINE_VAL_TXT__c,
	   	  								NEW_PROV_LNG_NAME__c=persrec.NEW_PROV_LNG_NAME__c,
	   	  								NEW_REMARK__c=persrec.NEW_REMARK__c,
	   	  								NEW_RXPLAN_VAL__c=persrec.NEW_RXPLAN_VAL__c,
	   	  								PLSM_BNFT_EFFDT__c=persrec.PLSM_BNFT_EFFDT__c,
	   	  								PLSM_CD__c=persrec.PLSM_CD__c,
	   	  								PLSM_STATUS_CD__c=persrec.PLSM_STATUS_CD__c,
	   	  								PREV_INFRC_EFF_DATE__c=persrec.PREV_INFRC_EFF_DATE__c,
	   	  								PREV_LINE_VAL_NO__c=persrec.PREV_LINE_VAL_NO__c,
	   	  								PREV_LINE_VAL_TXT__c=persrec.PREV_LINE_VAL_TXT__c,
	   	  								PREV_PROV_NUM__c=persrec.PREV_PROV_NUM__c,
	   	  								PREV_REMARK__c=persrec.PREV_REMARK__c,
	   	  								PREV_RXPLAN_VAL__c=persrec.PREV_RXPLAN_VAL__c,
	   	  								PREV_PROV_LNG_NAME__c=persrec.PREV_PROV_LNG_NAME__c,
	   	  								SITUS_ST__c=persrec.SITUS_ST__c,
	   	  								Created_using_EDI_timestamp__c=true
	   	  								)
   	  			  						
   	  		  );
   	  	
   	  	  else
   	  	  	return NULL;
   }
   
   
}//End class ProvLineDomain