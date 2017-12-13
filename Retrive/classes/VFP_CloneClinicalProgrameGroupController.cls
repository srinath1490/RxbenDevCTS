/*Purpose: Apex Class for Cloning the Clinical Programe Group                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 02/22/2012       Apex Class for Cloning the Clinical Programe Group
======================================================================== */
public class VFP_CloneClinicalProgrameGroupController {
    
    Public Clinical_Program_Group__c originalGroup{get;set;} 
    Public string groupId;  
    Clinical_Program_Group__c cloneGroup;   
    List<Clinical_Program_Junction__c> junctionList = new List<Clinical_Program_Junction__c>();
    
    public VFP_CloneClinicalProgrameGroupController(ApexPages.StandardController controller) {
        this.originalGroup =(Clinical_Program_Group__c)controller.getRecord();
        groupId = originalGroup.Id;
        //Hix field added as per Request 01100, By Rahul Nasa
        originalGroup=[select c.id,c.Name,c.recordtypeId,c.Clinical_Program_Group_Description__c,c.Clinical_Program_Group_Name__c,c.Effective_Date__c,Hix__c,
                       c.Funding__c,c.Inactive__c,c.RecordTypeName__c,c.Termination_Date__c,(select Id,Name,Clinical_Program__c,Clinical_Programe_RecordType__c,
                       Clinical_Program_Group__c,Clinical_Program_Group_RecordType__c from Clinical_Program_Junction__r) from Clinical_Program_Group__c c where Id =:groupId];
       
       cloneGroup  = new Clinical_Program_Group__c ();
            cloneGroup =  originalGroup.clone(false); 
            junctionList = originalGroup.Clinical_Program_Junction__r;           
    }
    
     public Pagereference redirect(){
        Savepoint sp = Database.setSavepoint();
        system.debug('Size**'+junctionList.size());  
        try{
            insert cloneGroup;
            List<Clinical_Program_Junction__c> cloneJunctionList = new List<Clinical_Program_Junction__c>();
            if(junctionList.size() >0){
                for(Clinical_Program_Junction__c junction :junctionList){
                     Clinical_Program_Junction__c cloneJunction = new Clinical_Program_Junction__c();
                         cloneJunction =  junction.clone(false);
                         cloneJunction.Clinical_Program_Group__c= cloneGroup.Id;
                     cloneJunctionList.add(cloneJunction);
                }
              insert cloneJunctionList;
            }
            
           Pagereference pageref= new Pagereference('/'+cloneGroup.Id+'/e?retURL='+cloneGroup.Id);
           return pageref ;           
       }catch(exception e){
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
            ApexPages.addMessage(myMsg);  
            return null;        
       }
      }
      
     public Pagereference previouspage(){
           Pagereference pageref= new Pagereference('/'+originalGroup.Id+'/d?retURL='+originalGroup.Id);
           return pageref; 
    }   
}