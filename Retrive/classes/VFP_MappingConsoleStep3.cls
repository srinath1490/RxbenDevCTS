/*Purpose: Apex Class to implement Mapping Console (Request 5467) functionality
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR              DATE                DETAIL                                 
   1.0      Sushant Sethi      1/29/2015           Implementation of Mapping Console (Request 5467) functionality
   2.0      Ankur Aggarwal     2/17/2015           Implementation of Mapping Console validations (Request 5550) functionality
   3.0      Joognu Rao         2/24/2015           Implementation of request 05551(Mapping console Approval process)
   4.0      Abhishek goel      7/6/2015            Implementation of Mapping Console validations (Request 05864) functionality
======================================================================== */

public with sharing class VFP_MappingConsoleStep3 {
    public list<mappingValueWrapper> mvWList{get;set;}
    public boolean savemappingdisable{get;set;}
    public boolean addmappingdisable{get;set;}
    public list<string> lstProvisions{get;set;}
    public list<Mapping_Template__c> mappingTemplateList = new list<Mapping_Template__c>();
    public list<Mapping_Template__c> globalMappingTemplateList = new list<Mapping_Template__c>();
    public list<Mapping_Template__c> allMappingTemplatesToShowList = new list<Mapping_Template__c>();   
    public list<Mapping_Template__c> allMappingTemplateList = new list<Mapping_Template__c>(); 
    public list<recordtype> recordtypeList = new list<recordtype>();
    public void setprovisionList(){}
    public boolean showLineValueSection{get;set;}
    public LineValue__c lineValue{get;set;}
    public integer selectedProvision{get;set;}
    public Mapping_Template__c mappingTemplate{get;set;}
    public list<SelectOption> mappingTemplateOptionList{get;set;}
    public list<integer> customSettingList{get;set;}
    public list<SelectOption> recordTypeOptionList{get;set;}
    public string mappingTemplateSelected{get;set;}
    public string recordTypeSelected{get;set;}
    public list<LineValue__c> lineValueCheck{get;set;}
    public list<Mapping_Values__c> mappingValueTable{get;set;}
    public list<Mapping__c> mvInsertList{get;set;}
    public set<string> globalRecordsSet = new set<string>{'crd__c','drug_coverage__c','accumulations__c','network_junction__c'}; // Global Create Records
    public set<string> allRecordSet = new set<string>();
    public map<string,string> recordMap = new map<string,string>();
    public boolean showMappingFieldValue{get;set;}
    public boolean bRequest{get;set;}    
    public id requestId{get;set;}
    public Map<String,Schema.sObjectField> fieldMap = new Map<String,Schema.sObjectField>();
    public Schema.SObjectField tempSobject;
    public List<selectoption> VarPickList{get;set;}
    
    /**
    * Method :- VFP_MappingConsoleStep3
    * Description :- Constructor for VFP_MappingConsoleStep3
    **/
    public VFP_MappingConsoleStep3()
        { 

            showLineValueSection=false;
            lineValue = new LineValue__c();
            mappingTemplate = new Mapping_Template__c();
        bRequest = false;
         }
        
    /**
    * Method :- getprovisionList
    * Description :- This method collects the Provisions to be displayed from the Whitelist
                     stored in a Custom Setting and displays the same
    **/ 
    /*
   public list<SelectOption> getprovisionList(){
                   List<SelectOption> provisionOptions = new list<SelectOption>();
                   list<integer> customSettingList = new list<integer>(); 
                   
                   for(Provisions__c item : Provisions__c.getall().values())
                    {
                        customSettingList.add(integer.valueof(Item.Name)); 
                    }
                    
                    customSettingList.sort();
                    
                    for(integer p : customSettingList)
                           {
                               provisionOptions.add(new SelectOption(string.valueof(p),string.valueof(p))); 
                           }
                   return provisionOptions;
             }
         */
        //Added by JR
        
        public list<SelectOption> getprovisionList(){
                   List<SelectOption> provisionOptions = new list<SelectOption>();
                   
                   // Find all the provisions in the custom setting        
                    Map<Integer, Provisions__c> provisions = new Map<Integer, Provisions__c>();
                   list<integer> customSettingList = new list<integer>(); 
                   
                   for(Provisions__c item : Provisions__c.getall().values())
                    {
                        provisions.put(Integer.valueOf(item.name),item);
                        customSettingList.add(integer.valueof(Item.Name)); 
                    }
                    // Sort them by name    
                    customSettingList.sort();
                    
                     // Create the Select Options.
                    for(integer p : customSettingList)
                           {
                               provisionOptions.add(new SelectOption(string.valueof(p),provisions.get(p).Provision_Name__c)); 
                           }
                   return provisionOptions;
             }
             
             
    /**
    * Method :- addLine
    * Description :- This method drives the functionality of the Add Line button
                     
    **/ 
    public void addLine(){
            savemappingdisable = true;
            addmappingdisable = false;    
            showLineValueSection = true;
            mvWList = new list<mappingValueWrapper>();
            Provision__c selectedprovisionrecord = new Provision__c();            
            selectedprovisionrecord  = [select id from Provision__c where ProvisionNumber__c =: selectedProvision ];    // collects the value of the Provision Number Selected
            linevalue = new linevalue__c();         
            linevalue.Line_value__c = null;
            lineValue.Line_value_text__c = null;
            linevalue.Provision_ID__c = selectedprovisionrecord.id;    
            mappingTemplateOptionList= new list<SelectOption>();
            
             // List to collect the Mapping Templates with Create Record --> True and Provision --> Selected Provision 
            mappingTemplateList = [SELECT Field_API__c,id,name,MappingColumnID__r.Object_Label__c,MappingColumnID__c,Object_API__c,Provisionid__c,Provision_No__c,Provision_Text__c from Mapping_Template__c where MappingColumnID__r.Create__c = TRUE AND Provision_No__c =: selectedProvision];
             
            // List to display the Mapping Templates from the selected Provision and global Templates            
            globalMappingTemplateList = [SELECT Field_API__c,id,name,MappingColumnID__r.Object_Label__c,MappingColumnID__r.Object__c,MappingColumnID__c,Object_API__c,Provisionid__c,Provision_No__c,Provision_Text__c from Mapping_Template__c where Provision_No__c =: selectedProvision AND MappingColumnID__r.Object__c IN : globalRecordsSet];
            
            
                                    for(Mapping_Template__c gt : globalMappingTemplateList)
                                        {
                                            recordMap.put(gt.Object_API__c,gt.MappingColumnID__r.Object_Label__c);
                                        }
                                    for(string objectapi :recordMap.keyset())
                                        {
                                            mappingTemplateOptionList.add(new SelectOption(objectapi ,recordMap.get(objectapi )));                                        
                                        }
                                    for(Mapping_Template__c mt : mappingTemplateList )
                                        {
                                            mappingTemplateOptionList.add(new SelectOption(string.valueof(mt.Object_API__c),string.valueof(mt.MappingColumnID__r.Object_Label__c)));
                                        }
                                    if(mappingTemplateList .size() > 0)
                                        {
                                            mappingTemplateSelected = mappingTemplateList [0].Object_API__c;
                                        }
                findRecordType();
            //mappingValueTable = [SELECT name,Field_API__c,Object_API__c,Field_Type__c,FieldValue__c,RecordTypeId__c,Provision__c,Parent_Field_Value__c from Mapping_Values__c where Object_API__c =:mappingTemplateSelected AND RecordTypeId__c=:recordTypeSelected AND Provision__c=:selectedProvision LIMIT 10];
                            }
                            
                            
    /**
    * Method :- addMappingValue
    * Description :- This method drives the functionality of the Add Mapping value button
                     
    **/                           
    public void addMappingValue(){
                        savemappingdisable = false;
                        showMappingFieldValue = false;
                        mvWList = new list<mappingValueWrapper>();
                        
                         //Collecting the Drug Coverage Mapping Values 
                        mapping_values__C drugcoverageMappingValue;
                        if(mappingTemplateSelected  == 'DC_Drug_List_Group__c')    
                            {
                                drugcoverageMappingValue = [select id from mapping_values__C where object_api__c = 'drug_coverage__c' and creates_record__c = true and RecordTypeId__c =: recordTypeSelected];
                            }
                            
                       //Collecting the CRD Global Mapping Values
                       mapping_values__C crdmapingvalue;
                        if(recordMap.containskey(mappingTemplateSelected) )
                        {
                            crdmapingvalue = [select id from mapping_values__C where object_api__c = :mappingTemplateSelected and creates_record__c = true and RecordTypeId__c =: recordTypeSelected];                        
                        }
                            else
                                {
                                    crdmapingvalue = [select id from mapping_values__C where object_api__c = 'CRD__c' and creates_record__c = true];
                                }
                        // Collect all Mapping Templates with Create Record--> True, Provison --> Selected Provision
                        allMappingTemplateList = [SELECT Field_API__c,id,name,MappingColumnID__c,MappingColumnID__r.Field_API__c,MappingColumnID__r.Object__c,MappingColumnID__r.Field_Type__c,Object_API__c,MappingColumnID__r.Create__c,Provisionid__c,Provision_No__c,Provision_Text__c from Mapping_Template__c where Object_API__c =:mappingTemplateSelected AND Provision_No__c =: selectedProvision ORDER BY MappingColumnID__r.Create__c DESC];
                              
                              mappingValueTable = new list<mapping_values__C>();
                                for(Mapping_Template__c MT : allMappingTemplateList)
                                    {
                                         Mapping_Values__c tempMV = new Mapping_Values__c(); 
                                         tempMV.MappingColumnID__c = MT.MappingColumnID__c;
                                         tempMV.MappingColumnID__r = MT.MappingColumnID__r;
                                         if(recordTypeSelected!=NULL && MT.MappingColumnID__r.Create__c == TRUE)
                                            {
                                                tempMV.RecordTypeId__c = recordTypeSelected;
                                            }
                                         if(recordMap.containskey(mappingTemplateSelected))
                                            {
                                                tempMV.ParentMappingValue__C = crdmapingvalue .id;
                                            }
                                         if(MT.MappingColumnID__r.Field_Type__c== 'Lookup')
                                            {
                                                if(mappingTemplateSelected == 'dc_drug_list_group__c'){
                                                tempMV.Parent_Field_Value__c = drugcoverageMappingValue.id;
                                            }
                                             else
                                             {
                                                tempMV.Parent_Field_Value__c = crdmapingvalue .id;
                                             }
                                             }
                                          
                                          if(MT.MappingColumnID__r.Create__c == TRUE && MT.MappingColumnID__r.Field_Type__c == 'Lookup')
                                                {
                                                    showMappingFieldValue = TRUE;
                                                }
                                        // Request No 05979                      
                                        String[] types = new String[]{mappingTemplateSelected};
                                        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
                                        for(Schema.DescribeSobjectResult res : results){
                                            fieldMap = res.fields.getmap();
                                            VarPickList = new List<SelectOption>();
                                            if(MT.MappingColumnID__r.Field_Type__c == 'Picklist' || MT.MappingColumnID__r.Field_Type__c == 'String'){
                                                tempSobject = fieldMap.get(MT.MappingColumnID__r.Field_API__c);
                                                if(tempSobject != null){
                                                    Schema.DisplayType FldType = tempSobject.getDescribe().getType();
                                                    List<Schema.PicklistEntry> PickListValues = tempSobject.getDescribe().getPicklistValues();
                                                    if(FldType == Schema.DisplayType.Picklist){
                                                     VarPickList.add(new SelectOption('', 'None'));
                                                     }
                                                    for(Schema.PicklistEntry pick : PickListValues){
                                                        if(pick.isActive()){
                                                            VarPickList.add(new SelectOption(pick.getLabel(), pick.getValue()));
                                                         }
                                                     }
                                                     
                                                 }
                                              }                        
                                        mappingValueTable.add(tempMV);
                                        mappingValueWrapper mvwInstance = new mappingValueWrapper(tempMV);
                                        mvwInstance.WrapPicklist = VarPickList;
                                        mvWList.add(mvwInstance);
                                       // new mappingValueWrapper(MT);
                                       }
                                    }
                                 }


     /**
    * Method :- saveMappingValue
    * Description :- This method drives the functionality of the Save Mapping value button
                     
    **/ 
    public pagereference saveMappingValue(){
    
        decimal nonFormularyDollarAmount;
        decimal nonFormularyPercent ;
        string nonFormularyCopayCalculation ;
        decimal nonFormularyMinimumDollar;
        decimal nonFormularyMaximumDollar;
        decimal drugSpecificDollarAmount;
        decimal drugSpecificPercent;
        string  drugSpecificCopayCalculation ;  
        string  drugSpecificDrugListId;
        string  drugSpecificDrugGroupId;
        String  Ycode;
                                        //Implementation of Mapping Console validations (Request 5550) functionality - Start
    Mapping_Values__c crdmapingvalue = [select id from mapping_values__C where object_api__c = 'CRD__c' and creates_record__c = true];
                                        boolean validatemappingvalue = true;
                                        boolean nonformulary = false;
                                         for(  mappingValueWrapper mvwInstance : mvWList )
                                        {
                                            boolean currentlinevalidation = true;
                                            if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.mvInstance.FieldValue__c  != '')
                                                currentlinevalidation = validateMappingValue(mvwInstance.fieldType,mvwInstance.mvInstance);
                                            if(!currentlinevalidation)
                                            {
                                                mvwInstance.mvInstance.FieldValue__c.adderror('Data Type Not correct');
                                                validatemappingvalue = validatemappingvalue && currentlinevalidation;
                                            }
                                            // Add Drug Specific Copay from the mail generic copay to the mapping console for provision 13
                                            if(mvwInstance.objectAPI == 'Drug_Specific_Copay__c'){
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Dollar_Amount__c' && mvwInstance.mvInstance.FieldValue__c != ''){
                                                drugSpecificDollarAmount = integer.valueof(mvwInstance.mvInstance.FieldValue__c);
                                                system.debug('drugSpecificDollarAmount'+drugSpecificDollarAmount);
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Percent__c' && mvwInstance.mvInstance.FieldValue__c != ''){
                                                    drugSpecificPercent = integer.valueof(mvwInstance.mvInstance.FieldValue__c);
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Copay_Calculation__c' && mvwInstance.mvInstance.FieldValue__c != ''){
                                                    drugSpecificCopayCalculation = mvwInstance.mvInstance.FieldValue__c;
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Drug_List__c' && mvwInstance.mvInstance.FieldValue__c != ''){
                                                    drugSpecificDrugListId = mvwInstance.mvInstance.FieldValue__c;
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Drug_Group__c' && mvwInstance.mvInstance.FieldValue__c != ''){
                                                    drugSpecificDrugGroupId = mvwInstance.mvInstance.FieldValue__c;
                                                } 
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Y__c' && mvwInstance.mvInstance.FieldValue__c != ''){
                                                    YCode = mvwInstance.mvInstance.FieldValue__c.toLowercase();
                                                    string Ycompare = 'false';
                                                    system.debug('ycode'+YCode);
                                                    if(YCode == Ycompare){
                                                       system.debug('inside'+YCode);
                                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00297);
                                                        ApexPages.addMessage(myMsg);
                                                        validatemappingvalue = false;
                                                    }
                                                    
                                                }           
                                                //validation for drug specific copay logic for Reqest #05864
                                                if(drugSpecificDollarAmount!=null && drugSpecificPercent!=null && drugSpecificCopayCalculation==null){
                                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00293);
                                                    ApexPages.addMessage(myMsg);
                                                    validatemappingvalue = false;
                                                 }
                                                 if(drugSpecificDollarAmount==null && drugSpecificPercent==null && drugSpecificCopayCalculation!=null ){
                                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00294);
                                                    ApexPages.addMessage(myMsg);
                                                    validatemappingvalue = false;
                                                 }
                                                 if(drugSpecificDrugListId!=null && drugSpecificDrugGroupId!=null ){
                                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00295);
                                                    ApexPages.addMessage(myMsg);
                                                    validatemappingvalue = false;
                                                 }
                                                 if((mvwInstance.mvInstance.FieldValue__c == null || mvwInstance.mvInstance.FieldValue__c == '') && mvwInstance.fieldAPI == 'Y__c'){         
                                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00297);
                                                    ApexPages.addMessage(myMsg);
                                                    validatemappingvalue = false;
                                                 
                                                }               
                                            }   
                                            
                                                                                    
                                        }
                                        
                                        // Check for the Non Formulary Logic
                                        system.debug(mvWList);
                                         for(mappingValueWrapper mvwInstance : mvWList)
                                         {
                                             if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'CRDB_Copay_Logic__c' && mvwInstance.mvInstance.FieldValue__c == 'Non-Formulary'){
                                                nonformulary = true;
                                                system.debug('Formulary Value =  true');
                                                
                                             }
                                         }
                                        
                                        // Fetch Values entered by User for the Non Formulary Fields
                                        if(nonformulary){
                                            Mapping_Values__c tempVar = new Mapping_Values__c();
                                            string nonformularyData = '';
                                            for(mappingValueWrapper mvwInstance : mvWList){
                                                
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Non_Formulary_Dollar_Amount__c' && mvwInstance.mvInstance.FieldValue__c != '')
                                                {
                                                    nonFormularyDollarAmount = integer.valueof(mvwInstance.mvInstance.FieldValue__c);
                                                    //nonformularyData = nonformularyData+mvwInstance.mvInstance.FieldValue__c ;
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Non_Formulary_Percent__c' && mvwInstance.mvInstance.FieldValue__c != '')
                                                {
                                                    nonFormularyPercent = integer.valueof( mvwInstance.mvInstance.FieldValue__c);
                                                    //nonformularyData = nonformularyData+','+mvwInstance.mvInstance.FieldValue__c ;
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Non_Formulary_CoPay_Calculation__c' && mvwInstance.mvInstance.FieldValue__c != '')
                                                {
                                                    nonFormularyCopayCalculation = mvwInstance.mvInstance.FieldValue__c;
                                                    //nonformularyData = nonformularyData+','+mvwInstance.mvInstance.FieldValue__c;
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Non_Formulary_Minimum_Dollar__c' && mvwInstance.mvInstance.FieldValue__c != '')
                                                {
                                                    nonFormularyMinimumDollar = integer.valueof(mvwInstance.mvInstance.FieldValue__c);
                                                    //nonformularyData = nonformularyData+','+mvwInstance.mvInstance.FieldValue__c ;
                                                }
                                                if(mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.fieldAPI == 'Non_Formulary_Maximum_Dollar__c' && mvwInstance.mvInstance.FieldValue__c != '')
                                                {
                                                    nonFormularyMaximumDollar = integer.valueof(mvwInstance.mvInstance.FieldValue__c);
                                                    //nonformularyData = nonformularyData+','+mvwInstance.mvInstance.FieldValue__c ;
                                                } 
                                                if(mvwInstance.fieldAPI == 'Non_Formulary_String__c'){
                                                    tempVar = mvwInstance.mvInstance;
                                                }
                                                
                                                nonformularyData =  ( nonFormularyDollarAmount==null ? '': String.valueof(nonFormularyDollarAmount) ) +','+( nonFormularyPercent==null ? '':  String.valueof(nonFormularyPercent) )+','+( nonFormularyCopayCalculation==null ? '': nonFormularyCopayCalculation)+','+( nonFormularyMinimumDollar==null ? '': String.valueof(nonFormularyMinimumDollar) )+','+( nonFormularyMaximumDollar==null ? '':  String.valueof(nonFormularyMaximumDollar) );
                                                tempVar.FieldValue__c  = nonformularyData;
                                            }
                                            system.debug('%%%%'+nonFormularyDollarAmount+'---'+nonFormularyPercent+'----'+nonFormularyCopayCalculation+'-----'+nonFormularyMaximumDollar+'----'+nonFormularyMinimumDollar);
                                        }

                                            
                                            
                                             
                                             // Validations before Non Formulary Logic Mapping values are inserted
                                             if(nonFormularyDollarAmount != NULL && nonFormularyPercent != NULL && nonFormularyCopayCalculation == NULL)
                                             {
                                                    
                                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00285);
                                                  ApexPages.addMessage(myMsg);
                                                  validatemappingvalue = false;
                                             }
                                              system.debug('dollarPercent'+nonFormularyDollarAmount+'--'+nonFormularyPercent+'--'+nonFormularyCopayCalculation);
                                             if((nonFormularyDollarAmount == NULL && nonFormularyPercent != NULL && nonFormularyCopayCalculation != NULL)||(nonFormularyDollarAmount != NULL && nonFormularyPercent == NULL && nonFormularyCopayCalculation != NULL))
                                             {
                                                system.debug('dollarPercent');
                                                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00286);
                                                 ApexPages.addMessage(myMsg);
                                                 validatemappingvalue = false;
                                             } 
                                             if((nonFormularyMinimumDollar != NULL && nonFormularyMaximumDollar !=NULL) && (nonFormularyMaximumDollar < nonFormularyMinimumDollar))
                                             {
                                                system.debug('minmaxDollar');
                                                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.ERR00287);
                                                 ApexPages.addMessage(myMsg);
                                                 validatemappingvalue = false;
                                             }
                                             
                                         
                                        
                                        if(validatemappingvalue == false){
                                            return null;
                                        }
                                        //Implementation of Mapping Console validations (Request 5550) functionality    - End
                                       
                                        try
                                        {
                                        
                                        system.debug('------Inside try');
                                            
                                        //LineValue__c linevalueInstance = new LineValue__c();    
                                            if(linevalue.id == null)
                                            {
                                                list<LineValue__c> lineValueCheck = new list<LineValue__c>();
                                                lineValueCheck = [SELECT Line_value__c,Provision_ID__r.ProvisionNumber__c from LineValue__c where Provision_ID__r.ProvisionNumber__c =: selectedProvision AND Line_value__c =: linevalue.Line_value__c];
                                                if (lineValueCheck.size() > 0)
                                                    {
                                                        linevalue.Line_value__c.adderror(system.label.ERR00255);
                                                        return null;                    
                                                    }
                                            
                                             Mapping_Request__c objMR= new Mapping_Request__c();
                                        objMR.Status__c= 'new';
                                        objMR.Valid__c= false;
                                        objMR.Approved__c= false;
                                        //Added by JR for Approval process
                                        objMR.Line_Value_State__c = 'New Line Value added';
                                            insert objMR;
                                            //Added by JR
                                            requestId = objMR.id;
                                            bRequest = true;
                                         // Set the Line value fields of the inserted Line Value
                                        linevalue.name = 'P' + selectedProvision + 'L' + linevalue.Line_value__c;
                                        linevalue.Active__c = false;
                                        linevalue.Mapping_Request__c = objMR.id;
                                        linevalue.Key__c = 'Copy P' + selectedProvision + ' - L' + linevalue.Line_value__c;
                                        linevalue.RequestID__c = String.valueOf(linevalue.Line_value__c);
                                   
                                            insert linevalue;
                                            }
                                        
                                         list<mapping_Values__C> mvInsertListparent = new list<mapping_Values__C>();
                                         list<mapping_Values__C> mvInsertListchild = new list<mapping_Values__C>();                                         
                                            for(  mappingValueWrapper mvwInstance : mvWList )
                                            {
                                                mvwInstance.mvInstance.Line_ValueID__c = linevalue.id;                                                        
                                                if(mvwInstance.mvInstance.MappingColumnID__r.Create__c == TRUE)
                                                {
                                                  mvInsertListparent .add(mvwInstance.mvInstance);          
                                                }
                                            } 
                                            system.debug('******InsideParent '+mvInsertListparent );      
                                            insert  mvInsertListparent ;            
                                            system.debug('***MVWList' + mvwList);    
                                            //string 
                                            for(  mappingValueWrapper mvwInstance : mvWList )
                                                {
                                                    mvwInstance.mvInstance.Line_ValueID__c = linevalue.id;
                                                        if(mvInsertListparent.size() > 0)
                                                        {
                                                        mvwInstance.mvInstance.ParentMappingValue__C = mvInsertListparent[0].id;
                                                        }
                                                        if((mvwInstance.mvInstance.MappingColumnID__r.Create__c== false && mvwInstance.mvInstance.FieldValue__c != null && mvwInstance.mvInstance.FieldValue__c!= '') || (mvwInstance.fieldType == 'Lookup'))
                                                        {
                                                        if(mvwInstance.fieldType == 'Lookup' && mvwInstance.objectAPI == 'Network_Junction__c')
                                                                mvwInstance.mvInstance.Parent_Field_Value__c = crdmapingvalue.id;
                                                            
                                                            if((mvwInstance.fieldAPI !='Non_Formulary_Dollar_Amount__c')&&(mvwInstance.fieldAPI !='Non_Formulary_Percent__c')&&(mvwInstance.fieldAPI !='Non_Formulary_CoPay_Calculation__c')&&(mvwInstance.fieldAPI!='Non_Formulary_Minimum_Dollar__c')&&(mvwInstance.fieldAPI!='Non_Formulary_Maximum_Dollar__c')){
                                                                
                                                                
                                                                system.debug('Inside formulary if&&&&&');
                                                                mvInsertListchild .add(mvwInstance.mvInstance); 
                                                            }
                                                        }
                                                        //set the value 'False' for fields 'M', 'N',' O', 'Y'
                                                        if(mvwInstance.objectAPI == 'Drug_Specific_Copay__c'){
                                                            if((mvwInstance.mvInstance.FieldValue__c == null || mvwInstance.mvInstance.FieldValue__c == '') && mvwInstance.fieldAPI == 'Y__c'){      
                                                                
                                                               // mvwInstance.mvInstance.FieldValue__c = 'false';
                                                               // mvInsertListchild.add(mvwInstance.mvInstance);
                                                            }else if((mvwInstance.mvInstance.FieldValue__c == null || mvwInstance.mvInstance.FieldValue__c == '') && mvwInstance.fieldAPI == 'M__c'){
                                                                mvwInstance.mvInstance.FieldValue__c = 'false';
                                                                mvInsertListchild.add(mvwInstance.mvInstance);
                                                            }else if((mvwInstance.mvInstance.FieldValue__c == null || mvwInstance.mvInstance.FieldValue__c == '') && mvwInstance.fieldAPI == 'N__c'){
                                                                mvwInstance.mvInstance.FieldValue__c = 'false';
                                                                mvInsertListchild.add(mvwInstance.mvInstance);
                                                            }else if((mvwInstance.mvInstance.FieldValue__c == null || mvwInstance.mvInstance.FieldValue__c == '') && mvwInstance.fieldAPI == 'O__c'){
                                                                mvwInstance.mvInstance.FieldValue__c = 'false';
                                                                mvInsertListchild.add(mvwInstance.mvInstance);
                                                            }else if((mvwInstance.mvInstance.FieldValue__c == null || mvwInstance.mvInstance.FieldValue__c == '') && mvwInstance.fieldAPI == 'Stepped_Copay__c'){
                                                                mvwInstance.mvInstance.FieldValue__c = '';
                                                                mvInsertListchild.add(mvwInstance.mvInstance);
                                                            }
                                                            
                                                        }
                                                        
                                                        system.debug('******InsideChild '+mvInsertListchild);
                                            }           
                                            if(mvInsertListchild.size() > 0)
                                            insert  mvInsertListchild ;   
                                        
                                             savemappingdisable= true;
                                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Line Value Inserted');
                                             ApexPages.addMessage(myMsg);
                                             
                                             }
                                             catch(exception e){
                                             system.debug('------Inside catch');
                                              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error while inserting Line Value');
                                             ApexPages.addMessage(myMsg);
                                                                 
                                              }
                                             return null;
                                             
                                           }                                  
                                 
    /**
    * Method :- findRecordType
    * Description :- This method fetches all the record types of the Selected Object
                     
    **/                          
    public pagereference findRecordType(){
            String objectapirecordtype = mappingTemplateSelected;
            system.debug(mappingTemplateSelected);
            if(objectapirecordtype == 'DC_Drug_List_Group__c'){
               objectapirecordtype = 'Drug_Coverage__c'; 
            }
            recordTypeList = [SELECT id,name,SobjectType from recordtype where SobjectType =: objectapirecordtype ];
            recordTypeOptionList = new list<selectOption>();
                    for(recordtype rt : recordTypeList )
                        {
                                recordTypeOptionList.add(new SelectOption(string.valueof(rt.id),string.valueof(rt.name)));
                        }
                         return null;
                               }
    //Implementation of Mapping Console validations (Request 5550) functionality   - Start                                  
    public boolean validateMappingValue(string fieldtype,Mapping_Values__c validatemappingval){
        Pattern isnumbers = Pattern.Compile('^[0-9]*[.]?[0-9]+$');
        Pattern isdecimal = Pattern.Compile('^[0-9]*[.]?[0-9]+$');
        Pattern isid = Pattern.compile('[A-Za-z0-9]{15}');
        if(fieldtype == 'Boolean'){ 
            if(validatemappingval.FieldValue__c.tolowercase() == 'true' || validatemappingval.FieldValue__c.tolowercase() == 'false')
                return true;
        }
        if(fieldtype == 'Number'){
            return isnumbers.matcher(validatemappingval.FieldValue__c).Matches() || isdecimal.matcher(validatemappingval.FieldValue__c).Matches();
        }
        if(fieldtype == 'ID'){
            return isid.matcher(validatemappingval.FieldValue__c).Matches();
        }
        if(fieldtype == 'String' || fieldtype == 'Picklist'){
            return true;
        }
        if(fieldtype == 'Date'){
            try{
                Date.parse(validatemappingval.FieldValue__c);
                return true;
            }
            catch(exception ex){
                return false;
            }
        }
        return false;

    }
    //Implementation of Mapping Console validations (Request 5550) functionality   - end
    
    /**
    * Class:- mappingValueWrapper
    * Description :- This class Creates an Instance of the Mapping Values which need to be inserted into the System
                     
    **/
    public class mappingValueWrapper
    {
        public Mapping_Values__c mvInstance{get;set;}
        public string Name{get;set;}
        public string fieldAPI{get;set;}
        public string objectAPI{get;set;}
        public string fieldType{get;set;}
        public string fieldValue{get;set;}
        public string parentFieldValue{get;set;}
        public boolean selected{get;set;}
        public List<SelectOption> WrapPicklist{get;set;}
        public mappingValueWrapper(Mapping_Values__c passedmv){
                                        mvInstance = passedmv ; 
                                        fieldAPI = passedmv.MappingColumnID__r.Field_API__c ; 
                                        objectAPI = passedmv.MappingColumnID__r.Object__c ;  
                                        fieldType = passedmv.MappingColumnID__r.Field_Type__c ; 
                                        //smvInstanceelected = false;
                    }
    }                                                            
    
}