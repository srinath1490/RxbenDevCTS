/*
*   Author      :   Joognu Rao
*   Date        :   05/28/2014
*   Description :   Generic class to create case for CRD Build Process
*   VERSION     AUTHOR          DATE                DETAIL 
*   1.1         Amit            2nd Dec, 2014       Modified for request 5305. Change to case status from 'New' to 'Send for Assignment'
*/
public with sharing class CB_CaseLogger { 
    //Internal CRD/GMF Process Case Record Type Id
    private static String recordTypeId;
    //Queue Id for Case
    private static String caseQueueId;
    private static string bctSupervisorQueueId;//CaseBCTSupervisorUnassignedCases
    private static string bctApprovalQueueId;//CaseBCTSupervisorCasesforApproval
    
    
    /*
    * Static method to inialize this class for Record type and queue
    */
    static{
        //Get queue Id
        for(QueueSobject queue : [Select
                                    Id,QueueId ,Queue.developerName
                                  From 
                                    QueueSobject
                                  Where
                                    SobjectType='Case'                                   
                                  ]){
            if(queue.Queue.developerName == 'CaseBCTSupervisorUnassignedCases'){                        
                bctSupervisorQueueId = queue.QueueId ;
            }else if(queue.Queue.developerName == 'CaseBCTSupervisorCasesforApproval'){                         
                bctApprovalQueueId = queue.QueueId ;
            }
        }
        //Get Record Type Id
        for(RecordType rt : [Select
                                Id
                              From 
                                RecordType
                              Where
                                SobjectType='Case' AND name='Internal CRD/GMF Process'
                              limit 1]){
            recordTypeId = rt.id;
        }
    }
    
    /*
    *   Create a case instance and return reference
    *   Params :    @subject        - case subject
    *               @description    - Case Description
    *               @parentId       - parentId of this case
    *               @crdId          - CRD Id                
    */
    public static Case logCase(String subject, String description,string parentId, String crdId, String ControlPlanEffective ){
        return new Case(
                        Subject = Subject
                        ,Description    = description
                        ,ParentId = parentId
                        ,OwnerId    = bctSupervisorQueueId
                        ,RecordTypeId = recordTypeId
                        ,Status = 'Send for Assignment'
                        ,ControlPlanEffective__c = ControlPlanEffective//Richa added on 17/07
                        //,Accountid = accountId//Richa added for 5083
                    );
    }
    
    /*
    *   Create a case instance and return reference
    *   Params :    @subject        - case subject
    *               @description    - Case Description
                                  
    */   
    public static Case CreateCaseBuilder(String subject, String description,string reason,DateTime persCreatedDate, String ControlPlanEffective, ID accountName, Date benefitEffDate, ID crdName){
        return new Case(
                        Subject = Subject
                        ,Description    = description
                        ,Fallout_Reason__c = reason 
                        ,PERS_timestamp__c = persCreatedDate                      
                        ,OwnerId    = bctSupervisorQueueId
                        ,RecordTypeId = recordTypeId
                        ,Status = 'Send for Assignment'
                        ,ControlPlanEffective__c = ControlPlanEffective
                        ,AccountId = accountName
                        ,Benefit_Effective_Date__c = benefitEffDate
                        ,CaseAutomationReason__c = 'CRDB' // Added by Sushant Req 5320
                        ,CRD_Name__c = crdName
                    );
    }
    /*
    *   Create a case instance and return reference
    *   Params :    @subject        - case subject
    *               @description    - Case Description
                                  
    */    
    public static Case CreateCaseBuilder(string existingCaseId, String subject, String description,string reason,DateTime persCreatedDate, String ControlPlanEffective, ID accountName, Date benefitEffDate, ID crdName){
        return new Case(
                        Subject = Subject
                        , id = existingCaseId
                        ,Description    = description
                        ,Fallout_Reason__c = reason 
                        ,PERS_timestamp__c = persCreatedDate                      
                        ,OwnerId    = bctSupervisorQueueId
                        ,RecordTypeId = recordTypeId
                        ,Status = 'Send for Assignment'
                        ,ControlPlanEffective__c = ControlPlanEffective
                        ,AccountId = accountName
                        ,Benefit_Effective_Date__c = benefitEffDate
                        ,CRD_Name__c = crdName
                    );
    }
    
}