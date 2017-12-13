/*Purpose: Apex Class for selecting the recordtype of the Accumalation Specific Drugs                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ABHAY                08/05/2011       Apex Class for selecting the recordtype of the Accumalation Specific Drugs  
======================================================================== */


public with sharing class VFP_AccumulationRecordTypeController {
    public list<SelectOption> recordTypeOptions{get;set;}
    public list<Accumulations__c> selectedAccumualtion{get;set;}
    
    public string accumulationId{get;set;}
    public string accumulationName{get;set;}
    public String recordTypeName{get;set;}
    public string recordTypeValue{get;set;}
    
    public VFP_AccumulationRecordTypeController(ApexPages.StandardController controller) {
        List<Schema.RecordTypeInfo> objListrecType = AccumulationSpecificDrug__c.sObjectType.getDescribe().getRecordTypeInfos(); 
        recordTypeOptions= new List<SelectOption>();  
        accumulationId = ApexPages.CurrentPage().getParameters().get('accumId');
        if(accumulationId !=null){             
            selectedAccumualtion=[select id,Name ,recordType.Name from Accumulations__c where id =:accumulationId];
        }
        if(selectedAccumualtion!=null && selectedAccumualtion.size()>0){
            recordTypeName=selectedAccumualtion[0].recordType.Name;
            accumulationName=selectedAccumualtion[0].name;
        }
        for(Schema.RecordTypeInfo recType : objListrecType){                                 
            if(recordTypeName!=null){
                if(recType.name !='Master'){
	                if(recordTypeName.contains('Family')){
	                    if(recType.name.contains('Family')){
	                    recordTypeOptions.add(new Selectoption(recType.getRecordTypeId(),recType.name));
	                    }
	                }
                }
                if(recordTypeName.contains('Individual')){
                    if(recType.name !='Master'){
                        if(recType.name.contains('Individual')){
                        recordTypeOptions.add(new Selectoption(recType.getRecordTypeId(),recType.name));
                        }
                    }
                }
            }
        }              
    }
    
    public pagereference createNewRecord(){
      PageReference pageRef = new PageReference(system.label.CL0000022+recordTypeValue+system.label.CL0000023+accumulationId+system.label.CL0000024+accumulationName+system.label.CL0000025+accumulationId);     
      pageRef.setRedirect(true);   
      return pageRef ;
    }

}