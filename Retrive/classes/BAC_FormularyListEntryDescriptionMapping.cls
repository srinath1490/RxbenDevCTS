/*Purpose: Apex Batch Class for populating the Formulary List Entry Description    
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj               1/10/2012      Apex Batch Class for populating the Formulary List Entry Description   
======================================================================== */

global class BAC_FormularyListEntryDescriptionMapping implements database.Batchable<SOBJECT>,schedulable{
 
    global String query;

    //constructor of class    
    global BAC_FormularyListEntryDescriptionMapping(){
        Query='SELECT Description_of_Formulary_List_Entry__c,NDC__c FROM Formulary_List_Entry__c where Description_of_Formulary_List_Entry__c = null';
    }
    
    //Batch start method    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
 
     //Batch execute method   
    global void execute(Database.BatchableContext BC,List<SOBJECT> Scope){
    TRG_DrugDescriptionMapping  drugDescription = new TRG_DrugDescriptionMapping();
    List<Formulary_List_Entry__c> criteriaList = new List<Formulary_List_Entry__c>();   
        for(SOBJECT s :Scope){
            string ndcDescription = '';
            
            Formulary_List_Entry__c criteria = (Formulary_List_Entry__c)s;
            if(criteria.NDC__c != null && criteria.NDC__c !=''){
                ndcDescription = drugDescription.drugNDC(criteria.NDC__c);
            }
            
            criteria.Description_of_Formulary_List_Entry__c = ndcDescription; 
            criteriaList.add(criteria);
        }
        try{
           update criteriaList;
        }catch(exception e){
        }
	} 

     //Batch finsh method
	global void finish(Database.BatchableContext BC){
	        
	} 

    // Batch schedule method    
	global void execute(schedulableContext MC){
	    database.executeBatch(new BAC_FormularyListEntryDescriptionMapping(), 80);
	}     
}