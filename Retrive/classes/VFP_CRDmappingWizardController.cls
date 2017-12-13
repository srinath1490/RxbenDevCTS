/*Purpose: Apex Class to implement Mapping Console (Request 5467) functionality
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Joognu Rao      1/29/2015           Implementation of Mapping Console (Request 5467) functionality
   
======================================================================== */


public with sharing class VFP_CRDmappingWizardController{

   
    public string selectedProvision{get;set;}
    public string selectedLineValue{get;set;}
    public List<Mapping_Values__c> mvalues{get;set;}
    public boolean bShowTable{get;set;}
    public boolean bDisableView{get;set;}
    public boolean bRequest{get;set;}
    public id requestId{get;set;}
    
    public VFP_CRDmappingWizardController(){
        
        selectedProvision = string.valueof(Provisions__c.getall().values()[0].name);
        bShowTable =false;
        bDisableView = false;
        bRequest = false;
    }
    
    public void setlstProvisions(){}
    public void setlstLineValues(){}
    
    /*
    public List<SelectOption> getlstProvisions() {
        List<SelectOption> options = new List<SelectOption>(); 
        
        
       for(Provisions__c p : Provisions__c.getall().values()){
                              
            options.add(new SelectOption(string.valueof(p.name) , string.valueof(p.name))); 
        }
        return options; 
    }*/
    
    
    public List<SelectOption> getlstProvisions() {
    
        List<SelectOption> options = new List<SelectOption>(); 
        
        // Find all the provisions in the custom setting        
        Map<Integer, Provisions__c> provisions = new Map<Integer, Provisions__c>();
        List<Integer> provisionNames = new List<Integer>();
        
        for(Provisions__c p : Provisions__c.getAll().values()){
            provisions.put(Integer.valueOf(p.name),p);
            provisionNames.add(Integer.valueOf(p.name));
        }       
        // Sort them by name       
        provisionNames.sort();
        
        // Create the Select Options.
        for (Integer provisionName : provisionNames) {
           
            options.add(new SelectOption(string.valueOf(provisionName) , provisions.get(provisionName).Provision_Name__c));
        }
      
        return options; 
    } 
    
    public List<SelectOption> getlstLineValues() {
        List<SelectOption> options = new List<SelectOption>(); 
        
        Id selectedProvId = [select id from Provision__c where ProvisionNumber__c=:Integer.valueOf(selectedProvision)].id;
        
        for(LineValue__c l : [Select
                                Provision_ID__c, id,Line_value__c,Active__c 
                            From
                                LineValue__c
                            Where 
                               Provision_ID__c =:selectedProvId AND Active__c = true
                            order By
                                Line_value__c desc ]){
             system.debug('JMK'+l);                 
            options.add(new SelectOption(string.valueof(l.Line_value__c) , string.valueof(l.Line_value__c))); 
        }
        system.debug('options'+options);                 
        return options; 
    }
    
    public void loadLinevalues(){
     getlstLineValues();       
    }
    
    
     /**
    * Method :- loadMappingFiles
    * Description :- Method to load Selected Line Value 
                    fields and its associated Parent Mapping 
                    value onclick of "view" button
    **/
    
    public void loadMappingFiles(){
        bShowTable = true;
        system.debug('entered line value');    
        //TODO:- display mapping based on provnumber and line number
        Provision__c prov = [select id from Provision__c where ProvisionNumber__c =:Integer.valueof(selectedProvision)];
        List<LineValue__c> lstLineValues = new List<LineValue__c>();
        lstLineValues = [select Provision_ID__c, id,Line_value__c,Active__c from LineValue__c where Provision_ID__c =:prov.id AND Line_value__c =:Integer.valueof(selectedLineValue) AND Active__c=true] ;                      
        mvalues = new List<Mapping_Values__c>();
        mvalues = [Select
                    Id, name,Provision__c,Line_value__c,ParentMappingValue__c,MappingColumnID__r.Tab_Label__c, MappingColumnID__r.Field_Label__c, FieldValue__c
                From
                    Mapping_Values__c 
                Where
                    Provision__c =:Integer.valueof(selectedProvision) AND Line_ValueID__c IN:lstLineValues 
                Order By MappingColumnID__r.Tab_Label__c asc Nulls last,ParentMappingValue__c desc];
                
       system.debug('hiiiiiiiiiii'+prov +'----'+lstLineValues +'00000000'+mvalues);
    }
    /**
    * Method :- newLinevalue
    * Description :- Method to create new line value
                     onclick of "New Line Value" button
    **/
    public PageReference newLinevalue(){
        Pagereference pageRef = new Pagereference('/apex/VF_MappingConsoleStep3');
        return pageRef;
    }
    /**
    * Method :- editFieldValue
    * Description :- Method to edit field value of Selected 
                    Line Value fields and its associated Parent 
                    Mapping value onclick of "edit" button
    **/
    public void editFieldValue(){
        bDisableView = true;
    }
    
    /**
    * Method :- saveFieldValue
    * Description :- Method to create a "Mapping Request" record. 
                     Status=New, RecordType=Update Line value, Valid=False, Approved=False
                    Create linevalue, set as inactive and attach to Mapping Request.Create 
                    mapping values and set as inactive and attach it to the mapping request and line value.
                    field value of Selected Line Value fields and its associated Parent Mapping value. 
    **/
    public void saveFieldValue(){
        bDisableView = false;
        Provision__c prov = [select id from Provision__c where ProvisionNumber__c =:Integer.valueof(selectedProvision)];
        
        
        
         List<LineValue__c> objLV = [select name,id,Active__c,Mapping_Request__c,Mapping_Request__r.status__c,Key__c,Line_value__c,Line_value_text__c,Provision_ID__c,Salesforce_External_DEV_Id__c from LineValue__c where Line_value__c =:Integer.valueof(selectedLineValue) AND Provision_ID__c =:prov.id AND Ready_To_Archive__c=false]; 
        
        system.debug('***'+objLV.size());
        if(objLV.size()>1){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, 'Mapping request already created for this Line value.You cannot edit it again.');
            ApexPages.addMessage(myMsg);
            bDisableView = true;
        }
        
        else{
            
            //Create Mapping Request Object
            Mapping_Request__c objMR= new Mapping_Request__c();
            objMR.Status__c= 'new';
            objMR.Valid__c= false;
            objMR.Approved__c= false;
            objMR.Line_Value_State__c ='Modified Existing Line Value';
            
            insert objMR;
            requestId = objMR.id;
            bRequest = true;
            system.debug('Mapping Req'+objMR+''+objMR.id);
            
            LineValue__c copyLV = objLV[0].clone(false,true,false,false);
            copyLV.Active__c = false;
            copyLV.Mapping_Request__c = objMR.id;
            copyLV.Key__c = objMR.id + copyLV.Key__c ;
            //copyLV.Provision_ID__c+objLV.id;
            //copyLV.name='ClonedLV'+objLV.Line_value__c;
            insert copyLV;
            system.debug('Line Value'+copyLV+''+copyLV.id);
            
            List<Mapping_Values__c>lstClonedMV = new List<Mapping_Values__c>();
            for(Mapping_Values__c MV :mvalues){
                Mapping_Values__c objMvalues = MV.clone(false,true,false,false);       
                //objMvalues.name = 'ClonedMV'+MV.name;
                objMvalues.Line_ValueID__c = copyLV.id;
                lstClonedMV.add(objMvalues);        
            }
            insert lstClonedMV;
             loadMappingFiles();
            system.debug('Mapping Values'+lstClonedMV+'');
        }
    }
    
    /**
    * Method :- cancelFieldValue
    * Description :- Method to cancel the editing of field 
                     value onclick of "cancel" button
    **/
    public Pagereference cancelFieldValue(){
       bDisableView = false;
       loadMappingFiles();
        return null;
    }
}