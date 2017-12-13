/*
History
----------------------------------------------------------------------------------------------------------------------------------------
Version    Owner                             Date             Description
1.0         Vineeth Muppalaneni        11/07/2016    Populate 'Document Names' field on the Transaction object with all related Document names (through the Plan-Document junction object).
2.0         Simon Esguerra             01/04/2017    Refactor the query to address exception of aggregate queries


Test Class: Test_PlanDocumentTrigger    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

public class TRT_Documenthandler{ 

    public static void updateDocumentName(List <Plan_Document__c> planDocList) { 
        Set<Id> TransactionIds = new Set<Id>();
        Map<Id,List<Plan_Document__c>> PlanDocumentMap = new Map<Id, List<Plan_Document__c>>();
        List<Transaction__c> TransactionList = new List<Transaction__c>();
        List<Plan_Document__c> PlanDocumentList = new List<Plan_Document__c>();
        List<Transaction__c> finalTransactionList= new List<Transaction__c>(); 

        for (Plan_Document__c  plandoc : planDocList ){
            if(plandoc.TRT_Document_Name__c!=null){
                TransactionIds.add(plandoc.Transaction__c);
            }
        }

        if(!TransactionIds.isEmpty()){
            //Query for Transactions to be updated, to be used later on
            TransactionList = [select id, Document_Names__c from Transaction__c where id in :TransactionIds]; 
        
            //Query Plan Document List based on the transaction ID list
            PlanDocumentList =  [select id,TRT_Document_Name__c, Transaction__c from Plan_Document__c where Transaction__c in: TransactionIds];
            
            //populate map of lists (transaction ID to plan document)
            if(!PlanDocumentList.isEmpty()){
                for(Plan_Document__c pd : PlanDocumentList){
                    if(PlanDocumentMap.containsKey(pd.Transaction__c)){
                        List<Plan_Document__c> PlanDocsList = PlanDocumentMap.get(pd.Transaction__c);
                        PlanDocsList.add(pd);
                        PlanDocumentMap.put(pd.Transaction__c, planDocsList);
                    }else{
                        PlanDocumentMap.put(pd.Transaction__c, new List<Plan_Document__c>{pd});
                    }
                }
            }

            //Formulate the Document Name field on the transaction object by parsing the related lists
            if(!PlanDocumentMap.isEmpty()){
                for(Transaction__c trans: TransactionList){
                    //If the transaction has plan documents, process it to formulate the name
                    if(PlanDocumentMap.containsKey(trans.Id)){
                       List<Plan_Document__c> PlanList = PlanDocumentMap.get(trans.Id);
                       String name = '';
                       for(Plan_Document__c planDoc: PlanList){
                            String val = string.valueOf(planDoc.TRT_Document_Name__c == null ? '' : planDoc.TRT_Document_Name__c); 
                            if(val != ''){
                                name += val + '; ';  
                            } 
                        }
                        trans.Document_Names__c = name; 
                    }else{
                        //There is no plan document associate to the transaction
                        trans.Document_Names__c = null; 
                    }
                    finalTransactionList.add(trans);
                }
            }
        }
        //make sure that there are records to update
        if(!finalTransactionList.isEmpty()){
            update finalTransactionList;
        } 
    }
}