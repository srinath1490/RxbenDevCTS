/**
*   Author:- Richa Gupta      
*   Created:- 08/04/2014
*   Description:- CaseTriggerHandler - Trigger implemention on Case Object
**/
public class CaseTriggerHandler {
    private Static String STATUS_TEXT = 'Status';
    private Static String CVS_STATUS_TEXT = 'CVS Status';
    private Static String EXTERNAL_STATUS_TEXT = 'Externally Shared Case Status';
    
    /**
    *   Author:- Richa Gupta      
    *   Created:- 08/04/2014
    *   Description:- Implmentation of After Update Trigger on Case object
    **/
    public void onAfterUpdate(Map<Id,Case> oldCaseMap, Map<Id,Case> newCaseMap){
        Map<Id,Set<String>> mapCaseIDsWithStatus = new Map<Id,Set<String>>();
        List<CaseStatusHistory__c> historyList = new List<CaseStatusHistory__c>(); 
        
        for(Case cs:newCaseMap.values()){
            if(cs.Status!= oldCaseMap.get(cs.Id).Status){
                historyList.add(createCaseHistory(cs.Id,STATUS_TEXT,string.valueof(newCaseMap.get(cs.Id).Status)));
                this.addToStatusMap(mapCaseIDsWithStatus, STATUS_TEXT, cs.id);
            }
            if(cs.CVS_Status__c!= oldCaseMap.get(cs.Id).CVS_Status__c){   
                historyList.add(createCaseHistory(cs.Id,CVS_STATUS_TEXT,string.valueof(newCaseMap.get(cs.Id).CVS_Status__c)));
                this.addToStatusMap(mapCaseIDsWithStatus, CVS_STATUS_TEXT, cs.id);
            }
            if(cs.CRD_GMF_Case_Status__c!= oldCaseMap.get(cs.Id).CRD_GMF_Case_Status__c){   
                historyList.add(createCaseHistory(cs.Id,EXTERNAL_STATUS_TEXT,string.valueof(newCaseMap.get(cs.Id).CRD_GMF_Case_Status__c)));
                this.addToStatusMap(mapCaseIDsWithStatus, EXTERNAL_STATUS_TEXT, cs.id);
            }
        }
        
        if(! mapCaseIDsWithStatus.isEmpty()){
            //Get the default business hours (we might need it)
             //BusinessHours defaultHours = [select Id from BusinessHours where IsDefault=true limit 1];//Commented by Amit
            for(CaseStatusHistory__c csh : [Select 
                                                id,to__c,from__c,Elapsed_Business_Hours__c,Field__c,Case__c 
                                            from 
                                                CaseStatusHistory__c 
                                            where 
                                                Case__c IN :mapCaseIDsWithStatus.keyset() and To__c = null]){
                if( mapCaseIDsWithStatus.get(csh.Case__c).contains(csh.Field__c)){
                    csh.to__c = system.now();
                     //The diff method comes back in milliseconds, so we divide by 1000 to get seconds.
                    csh.Elapsed_Business_Hours__c = BusinessHours.diff(System.label.CL0000070, csh.from__c, csh.to__c)/1000.0;
                    historyList.add(csh);
                }
            }
            upsert historyList;
        }
    }
    
    /**
    *   Author:- Richa Gupta      
    *   Created:- 08/04/2014
    *   Description:- Implmentation of After Insert Trigger on Case object
    **/
    public void onAfterInsert(Map<Id,Case> oldCaseMap,List<Case> newList){
        List<CaseStatusHistory__c> historyList = new List<CaseStatusHistory__c>(); 
        for(Case cs:newList){
            historyList.add(createCaseHistory(cs.Id,STATUS_TEXT,cs.Status));
            if(cs.CVS_Status__c != null){
                historyList.add(createCaseHistory(cs.Id,CVS_STATUS_TEXT,cs.CVS_Status__c));
            }
            if(cs.CRD_GMF_Case_Status__c != null){   
                historyList.add(createCaseHistory(cs.Id,EXTERNAL_STATUS_TEXT,cs.CRD_GMF_Case_Status__c));
            }
        }
        system.debug(historyList);
        insert historyList;
    }
    
    /**
    *   Author:- Richa Gupta      
    *   Created:- 08/04/2014
    *   Description:- add Case Id and Status type for Map
    **/
    private void addToStatusMap(Map<Id,Set<String>> mapCaseIDsWithStatus, String statusType, String caseId){
        if(mapCaseIDsWithStatus.containsKey(caseId)){
            mapCaseIDsWithStatus.get(caseId).add(statusType);
        }else{
            mapCaseIDsWithStatus.put(caseId, new Set<String>{statusType});
        }
    }
    
    /**
    *   Author:- Richa Gupta      
    *   Created:- 08/04/2014
    *   Description:- create Case Status History record 
    **/
    private CaseStatusHistory__c createCaseHistory(Id caseId, string field, string value){ 
        CaseStatusHistory__c history = new  CaseStatusHistory__c();            
        history.Case__c = caseId;
        history.Field__c = field;
        history.Value__c = Value;                       
        history.From__c = system.now();
        history.ChangedBy__c = Userinfo.getUserId(); 
        return history;
    }
}