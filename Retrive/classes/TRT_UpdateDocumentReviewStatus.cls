/**************************************************************************************************
* Name               : TRT_UpdateDocumentReviewStatus                                             *
* Description        : This class performs following functionality: It is invoked by the flow and 
                       it fetches all the  Plan-document related to Transaction meeting the condition
                       as specifed in requirement R-1767 and Update 'IQR review Status' of all 
                       associated documents.                                                      *
*                      
* Created Date       : 21/01/2017                                                                 *
* Created By         : Sushant Kumar Dhingra                                                      *
* Last Modified Date : 23/01/2017                                                                 *
* Last Modified By   : Sushant Kumar Dhingra                                                      *
* ----------------------------------------------------------------------------------------------- *
* VERSION         AUTHOR              DATE                                                        *
*   1.0 -  Sushant Kumar Dhingra   21/01/2017                                                     *
**************************************************************************************************/
public with sharing class TRT_UpdateDocumentReviewStatus{

 
   /*********************************************************************************************
    *@Description : getDocumentList                                                                  *
    *@Params      :                                                                                  *
    *@Return      :  void                                                                            *    
    *********************************************************************************************/
 
 @InvocableMethod(label='Get Document Record' description='Returns the list of document corresponding to the specified Transaction IDs.')
  public static List<string> getDocumentList(List<Transaction__c> transacList) {  
    List<string> outputToFlowList = new List<string>();
    Map<string,TRT_IQR_Document_Type__c> CSdataMap = new Map<string,TRT_IQR_Document_Type__c>();
    List<Document__c> docToUpdateList = new List<Document__c>();
    Set<Id> planDocIdSet = new Set<Id>();
    for (Plan_Document__c plndoc : [SELECT id,Name,Document_Name__c,Transaction__c FROM Plan_Document__c WHERE Transaction__c=:transacList[0].id AND 
                                    Ready_for_IQR__c = True]) {
      planDocIdSet.add(plndoc.Document_Name__c);
    }
    system.debug('planDocIdSet>>>>'+planDocIdSet.size());
    if(planDocIdSet!=null && !planDocIdSet.isEmpty())
    {
       //Get the custom setting data
        List<TRT_IQR_Document_Type__c> docTypeCS = TRT_IQR_Document_Type__c.getall().values();
        For(TRT_IQR_Document_Type__c CSdata : docTypeCS){
        CSdataMap.put(CSdata.Document_Type__c,CSdata);
        }
        system.debug('docTypeCS >>>>'+docTypeCS.size());
        //Get Document list from Plan_document
        for (Document__c doc : [SELECT id,Name,Document_Type__c,IQR_Review_Status__c,TRT_Document_Status__c,TRT_IQR_Exempt__c,Trainee__c
                               FROM Document__c WHERE Id IN :planDocIdSet]) 
        {
          
                 If(CSdataMap.containsKey(doc.Document_Type__c))
                 {
                   doc.IQR_Review_Status__c ='Ready for IQR';
                   docToUpdateList.add(doc);
                 }
          
        }//Document Loop
        
    }
    if(docToUpdateList !=null && !docToUpdateList.isEmpty()){
   // system.debug('docToUpdateList>>>>'+docToUpdateList.size());
    update docToUpdateList;
    outputToFlowList.add('Update is done');
    }
    return outputToFlowList;

  }
  

 
}