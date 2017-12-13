/*Purpose: Apex Class for Waiver Of Deductibe                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Richa                 08/05/2014       Apex Class for inserting records in Waiver Of Deductible
   2.0      Amit                  26/05/2015       Modified to implement the Formulary Plus Logic for WOD, request 5755
   3.0      Vikram                24/11/2015       Modified to implement request 06211
======================================================================== */

public with sharing class VFP_WaiverOfDeductible {
    public CRD__c crd {get;set;}
    public string groupMember{get;set;}
    public String editMode{get;set;}
    
    public string crdId {get;set;}
    public list<WaiverDeductible> listWrapCustomWOD {get;set;}    
    public List<StandardWaiver> lstStndrdWaiver {get;set;}
    public List<SelectOption> stdDugClassNames {get;set;}
    public set<String> setOfStdDrugClassNames {get;set;}
    public List<Waiver_Of_Deductible__c> wavDedcList {get;set;}
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING ACCUMPAGE = '/apex/VF_AccumulationsStep2?crdid=';
    PRIVATE STATIC FINAL STRING RETAIL = 'Retail';
    PRIVATE STATIC FINAL STRING MAIL = 'Mail';
    PRIVATE STATIC FINAL STRING BOTH = 'Both';
    PRIVATE STATIC FINAL STRING DCPAGE = '/apex/VF_CRDDrugCoverageStep2?crdid=';
    PRIVATE STATIC FINAL STRING V1 = 'SG Value Plus';
    PRIVATE STATIC FINAL STRING V2 = 'SG Value';
    PRIVATE STATIC FINAL STRING V3 = 'LG Value Plus';
    PRIVATE STATIC FINAL STRING V4 = 'LG Value';
    PRIVATE STATIC FINAL STRING V5 = 'LG Premier Plus';
    PRIVATE STATIC FINAL STRING V6 = 'LG Premier';
    PRIVATE STATIC FINAL STRING ALLOWOVERRIDE = 'Allow Rule to be overridden';
    PRIVATE STATIC FINAL STRING WAIVEROFDEDUCTIBLE= 'Waiver of Deductible';
    PRIVATE STATIC FINAL STRING COLON = ';';
    public boolean formularyErr = false;// Added By Nitish for ST#2515
    public boolean stopErrorForCustom = false;// Added By Nitish for ST#2515 for stop error for Custom WOD As per Obs#20
    public boolean inLoop = false;// Added By Nitish for ST#2515
    /*Constructor for WOD Screen Controller Class*/
    public VFP_WaiverOfDeductible(ApexPages.StandardController controller) {
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        this.crd = [Select Name, Y_Schd__c, Plan_Type_Paper__c, Insured_Type__c from crd__c where id = :crdId LIMIT 80000];
        this.init();
    }
/**
     *Method :- init
     *Description :- Method to initialize all set of drug classes/drug groups
**/ 
    private void init(){
        try{
        listWrapCustomWOD = new list<WaiverDeductible>();
        wavDedcList = new List<Waiver_Of_Deductible__c>();
        stdDugClassNames = new List<SelectOption>();
        lstStndrdWaiver = new List<StandardWaiver>();
        stdDugClassNames.add(new SelectOption('', ''));
        // initialize "stdDugClassNames" , this will have all the avialable drugclassName from Waiver Of Deductible Drug Class object
        for(Schema.PicklistEntry pickval : Waiver_Of_Deductible_Drug_Class__c.Drug_Class__c.getDescribe().getPicklistValues()){
            stdDugClassNames.add(new SelectOption(pickval.getValue(), pickval.getLabel()));
        }
        // Create a set of drug classname => setOdStdDrugClasses =>
        // Create a set of drug classname => setOdStdDrugClasses =>
       set<String> setOfStdDrugClassNames = new Set<String>();
        for(Waiver_Of_Deductible__c wd : [Select id, Drug_Class__c, Delivery_System__c, Standard__c, Drug_Class_Desc__c,Drug_Group__c, Drug_List__c, M__c, N__c, O__c, Y__c, crd_id__c 
                                            from Waiver_Of_Deductible__c where crd_id__c =:crdId AND Standard__c=true LIMIT 80000]){
               setOfStdDrugClassNames.add(wd.Drug_Class__c);
            
        }
        for(String drugClassName : setOfStdDrugClassNames){
            lstStndrdWaiver.add(new StandardWaiver(drugClassName, false));
        }
        
        /*for (Waiver_Of_Deductible__c wodRecord : [Select id, Drug_Class__c, Delivery_System__c, Standard__c, Drug_Class_Desc__c,Drug_Group__c, Drug_List__c, M__c, N__c, O__c, Y__c, crd_id__c 
                                                    from Waiver_Of_Deductible__c where crd_id__c =:crdId AND Standard__c=false  LIMIT 80000]){
             listWrapCustomWOD.add(new WaiverDeductible(false,wodRecord));
        }*/
        // Added by Toshi..
        //Query Modified - Added Network__c by Nitish 6911
        wavDedcList = [Select id,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc),Drug_Class__c, Delivery_System__c, Standard__c, Drug_Class_Desc__c,Drug_Group__c, Drug_Group__r.name, Drug_List__r.name,Drug_List__c, M__c, N__c, O__c, Y__c, crd_id__c,Network__c 
                                                    from Waiver_Of_Deductible__c where crd_id__c =:crdId LIMIT 80000];
        for (Waiver_Of_Deductible__c wodRecord :wavDedcList){
            if(wodRecord.Standard__c == FALSE)
                 listWrapCustomWOD.add(new WaiverDeductible(false,wodRecord));
                 
             /* if(wodRecord.Standard__c == TRUE)
                lstStndrdWaiver.add(new StandardWaiver(wodRecord.Drug_Class__c, false));
                system.debug('lstStndrdWaiver+++ ' + lstStndrdWaiver);*/
        }
        }catch(exception e){
                Apexpages.addMessages(e);
    }
     
    }
/**
     *Method :- addStndrdDC
     *Description :- Method to add new Standard Drug Class
**/     
   public void addStndrdDC() {
     try{
         lstStndrdWaiver.add(new StandardWaiver(null,false));
    }catch(exception e){
            Apexpages.addMessages(e);
        }
   }
/**
     *Method :- addCustomDC
     *Description :- Method to add new Custom Drug Lists/Groups
**/    
    public void addCustomDC() {
try
        {
            stopErrorForCustom = TRUE;//Added Nitish for ST#2515
            listWrapCustomWOD.add(new WaiverDeductible(false,new Waiver_Of_Deductible__c()));            
    }catch(exception e){
            Apexpages.addMessages(e);
        }
    }
/**
     *Method :- deleteStndrdDC
     *Description :- Method to add delete Standard Drug Classes
**/
    public void deleteStndrdDC(){
        try{
            stopErrorForCustom = TRUE;//Added Nitish for ST#2515
            for(Integer i=0; i<lstStndrdWaiver.size() ; i++){
            if(lstStndrdWaiver[i].isSelected){
                lstStndrdWaiver.remove(i);
                i=i-1;
            }
        }
    }catch(exception e){
            Apexpages.addMessages(e);
        }
    }
/**
     *Method :- deleteCustomDC
     *Description :- Method to add custom Standard Drug Lists/Groups
**/
    public void deleteCustomDC(){
        try{
            stopErrorForCustom = TRUE;//Added Nitish for ST#2515
            for(Integer i=0; i<listWrapCustomWOD.size() ; i++){
            if(listWrapCustomWOD[i].selected){
                listWrapCustomWOD.remove(i);
                i=i-1;
            }
        }
    }catch(exception e){
            Apexpages.addMessages(e);
        }
    }
/**
     *Method :- nextbutton
     *Description :- Method to add record in Waiver Of Deductible object on next click button in readonly mode
**/
    public pagereference nextButton2(){
        try{
            Pagereference pageref;
            pageRef = new Pagereference(ACCUMPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
    }catch(exception e){
            Apexpages.addMessages(e);
            return null;
        }
    }
/**
     *Method :- nextbutton
     *Description :- Method to add record in Waiver Of Deductible object on next click button
**/ 
    public pagereference nextbutton(){
        Savepoint sp = Database.setSavepoint();
        Pagereference pageRef;
        try{
            
            GC_Validation_Methods validationmethod = new GC_Validation_Methods();   
            boolean IsValidMNOY = true;
            List <Waiver_Of_Deductible__c> junctionRecords = new List <Waiver_Of_Deductible__c> ();
            
            // added by Vikram for request 06211
            set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }
            System.debug('restrictedProfiles' +restrictedProfiles);
            // 06211 ends    
            
            Set<String> stdDrugClassAdded = new Set<String>();
            Set<String> stdDrugClassAlreadyExisting = new Set<String>();
            for(StandardWaiver std : lstStndrdWaiver){
                if(std.drugClassName == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0247));
                    return null;
                }
                else{
                    stdDrugClassAdded.add(std.drugClassName);
                }
            }
            
    if(lstStndrdWaiver.size() != stdDrugClassAdded.size()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR00133));
                    return null;
            }
            
            //Remove std Drug class that are not the part of current set
            List<Waiver_Of_Deductible__c> stdWaiversToDelete = new List<Waiver_Of_Deductible__c>();
           for(Waiver_Of_Deductible__c waiver : [Select id, Drug_Class__c from Waiver_Of_Deductible__c where crd_id__c =:crdId and Standard__c = true LIMIT 80000]){
         
                    if(! stdDrugClassAdded.contains(waiver.drug_Class__c)){
                        stdWaiversToDelete.add(waiver);
                        
                    }else{
                         If(!Test.isRunningTest()){
                            stdDrugClassAlreadyExisting.add(waiver.drug_Class__c);
                        }
                    }
                    
            }
            
           database.delete(stdWaiversToDelete);
            //Added By Amit
            String formularyGroup='';
            
             for(Drug_Coverage__c dcRecord : [Select Id,name, Formulary__c,Formulary__r.name,Formulary__r.Group__c from Drug_Coverage__c where CRD_ID__c = : crd.Id LIMIT 80000]){   
            if(dcRecord.Formulary__r.Group__c!= Null && dcRecord.Formulary__r.Group__c!= ''){
                    formularyGroup = dcRecord.Formulary__r.Group__c;
                }
                if(dcRecord.Formulary__c == null){
                    formularyErr = True;
                }
            }
    
        if(formularyGroup!= '' && formularyGroup!= Null){
                for(Waiver_Of_Deductible_Drug_Class__c tempWODdrugClass : [select 
                                                                            id,name,Delivery_System__c,Drug_Class__c,Drug_Class_Desc__c,Drug_Group__c,Drug_List__c,Formulary_Group__c
                                                                            ,M__c,N__c,O__c,Y__c,Drug_List__r.name,Network__c
                                                                          From 
                                                                            Waiver_Of_Deductible_Drug_Class__c 
                                                                          where 
                                                                            Drug_Class__c in :stdDrugClassAdded AND Drug_Class__c NOT in :stdDrugClassAlreadyExisting LIMIT 80000]){
                    System.debug('########Step0');                   
                    
                    list<string> druglistnameformulary = new list<string>();
                    //Added code by Raj for R#6565 Start
                    system.debug('%%%%% ' + tempWODdrugClass.Formulary_Group__c + ' ' + formularyGroup +'  ' +  tempWODdrugClass.Drug_List__c);
                    if(tempWODdrugClass.Formulary_Group__c!= Null 
                              && formularyGroup.equalsignorecase(tempWODdrugClass.Formulary_Group__c) && tempWODdrugClass.Drug_List__c !=null){
                        druglistnameformulary.add(tempWODdrugClass.Drug_List__r.name);
                    }
                    //Added code by Raj for R# 6565 End
                    //Comments code by Raj Start
                                                                                
                    /*if(formularyGroup.equalsignorecase(V1) && tempWODdrugClass.SG_Value_Plus__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.SG_Value_Plus__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V2)  && tempWODdrugClass.SG_Value__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.SG_Value__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V3)  && tempWODdrugClass.LG_Value_Plus__c !=null)
                    {   Druglistnameformulary.addall(tempWODdrugClass.LG_Value_Plus__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V4)  && tempWODdrugClass.LG_Value__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.LG_Value__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V5)  && tempWODdrugClass.LG_Premier_Plus__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.LG_Premier_Plus__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V6)  && tempWODdrugClass.LG_Premier__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.LG_Premier__c.split(COLON));}
                    */
                    //Comments code by Raj End
                    
                    
                        for(drug_list__c druglistRecord : [select id,name from drug_list__c where name in : Druglistnameformulary LIMIT 80000]){
                            System.debug('########Step1');
                            junctionRecords.add(new Waiver_Of_Deductible__c(
                                                crd_id__c = crd.Id
                                                ,Drug_Class__c = tempWODdrugClass.Drug_Class__c
                                                ,Drug_Class_Desc__c = tempWODdrugClass.Drug_Class_Desc__c
                                                , Delivery_System__c = tempWODdrugClass.Delivery_System__c
                                                , Standard__c = true
                                                , Drug_Group__c = tempWODdrugClass.Drug_Group__c
                                                , Drug_List__c = druglistRecord.id
                                                , M__c = tempWODdrugClass.M__c
                                                , N__c = tempWODdrugClass.N__c
                                                , O__c = tempWODdrugClass.O__c
                                                , Y__c = tempWODdrugClass.Y__c
                                                , Network__c = tempWODdrugClass.Network__c ));    //Added By Nitish 6911              
                        }
                        
            Druglistnameformulary.clear();
            inLoop = true;
                }
            
                    //Added By Nitish ST#2515
                    if((junctionRecords.size()== 0 || formularyErr) && inLoop && !stopErrorForCustom){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                        return null;
                    }
        }
            else{                         
                //Add new Std Drug Class added
                boolean formularyGroupError = false;
                for(Waiver_Of_Deductible_Drug_Class__c wddc : [Select id, Drug_Class__c, Delivery_System__c, Drug_Group__c, Drug_List__c, Drug_Class_Desc__c,M__c, N__c, O__c, Y__c,Drug_List__r.Allowable_Actions__c
                                                                , Drug_Group__r.Allowable_Actions__c,Formulary_Group__c,Network__c
                                                                from Waiver_Of_Deductible_Drug_Class__c
                                                                Where Drug_Class__c in :stdDrugClassAdded AND Drug_Class__c NOT in :stdDrugClassAlreadyExisting and Formulary_Group__c = Null LIMIT 80000]){
                                                                System.debug('########Step2');  
                                                                // added by Vikram for request 06211
                                                                system.debug('^^^^ ' + wddc.Drug_Group__c +' ' + wddc);
                                                                if(wddc.Drug_Group__c!=null){
                                                                    String alact = wddc.Drug_Group__r.Allowable_Actions__c;
                                                                    if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wddc.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)
                                                                        ){
                                                                        System.debug('########Step3');
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c 
                                                                        ,Network__c = wddc.Network__c)); 
                                                                        
                                                                }else{    
                                                                        System.debug('########Step4');
                                                                        if (String.isBlank(wddc.Drug_Group__r.Allowable_Actions__c) || !alact.contains(WAIVEROFDEDUCTIBLE)){
                                                                            System.debug('########Step5');
                                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0298));
                                                                        return null;
                                                                        }else{
                                                                            System.debug('########Step6');
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c 
                                                                        ,Network__c = wddc.Network__c)); //Added By Nitish 6911
                                                                        }
                                                                     }
                                                                } else if(wddc.Drug_List__c!=null){
                                                                    System.debug('########Step7');
                                                                    String alact1 = wddc.Drug_List__r.Allowable_Actions__c;
                                                                    if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wddc.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)
                                                                        ){
                                                                        System.debug('########Step8');
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c 
                                                                        ,Network__c = wddc.Network__c)); //Added By Nitish 6911
                                                                        
                                                                    }else{ 
                                                                        System.debug('########Step9');   
                                                                        if (String.isBlank(wddc.Drug_List__r.Allowable_Actions__c) || !alact1.contains(WAIVEROFDEDUCTIBLE)){
                                                                        System.debug('########Step10');     
                                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0298));
                                                                        return null;
                                                                        }else{
                                                                        System.debug('########Step11');     
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c 
                                                                        ,Network__c = wddc.Network__c));//Added By Nitish 6911 
                                                                        }
                                                                     }
                                                                  }
                                                                else{
                                                                System.debug('########Step12');     
                                                                // 06211 ends 
                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                        crd_id__c = crdId
                                        ,Drug_Class__c = wddc.Drug_Class__c
                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                        , Delivery_System__c = wddc.Delivery_System__c
                                        , Standard__c = true
                                        , Drug_Group__c = wddc.Drug_Group__c
                                        , Drug_List__c = wddc.Drug_List__c
                                        , M__c = wddc.M__c
                                        , N__c = wddc.N__c
                                        , O__c = wddc.O__c
                                        , Y__c = wddc.Y__c
                                        ,Network__c = wddc.Network__c ));  //Added By Nitish 6911
                    }
                    //Added By Nitish for 2515
                    if(junctionRecords.size()>0){
                        formularyGroupError = true;
                    }
                    //Added By Nitish ST#2515
                    if((!formularyGroupError || formularyErr)  && !stopErrorForCustom ){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                        return null;
                    }
                    inLoop = True;
                }
                if(!inLoop && !stopErrorForCustom && lstStndrdWaiver.size()>0){
                    if(formularyErr  && !stopErrorForCustom ){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                        return null;
                    }
                    else{
                        List<Waiver_Of_Deductible_Drug_Class__c>  wddcList = [Select id, Drug_Class__c,Drug_Group__r.Allowable_Actions__c,Formulary_Group__c,Network__c
                                                                from Waiver_Of_Deductible_Drug_Class__c
                                                                Where Drug_Class__c in :stdDrugClassAdded  and Formulary_Group__c = Null LIMIT 80000];
                                                
                        if(wddcList.size()==0){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                            return null;
                        }
                    }
                    
                }
                
            }
            //Ends
            //checking all the validations
            if(listWrapCustomWOD != null && listWrapCustomWOD.size() > 0){
                IsValidMNOY = validationmethod.validateWaiverOfDeductible(listWrapCustomWOD);
            }
            
            Map<Id,String> addedDLs = new Map<Id,String>();    // added by Vikram for request 06211
            Map<Id,String> addedDLs1 = new Map<Id,String>();   // added by Vikram for request 06211
            
            Set<Id> druglistGroupIds = new Set<Id>();
            Set<Id> existingCustomWaivers = new Set<Id>();
            for(WaiverDeductible customDCList: listWrapCustomWOD) {
                druglistGroupIds.add(customDCList.waiverDeductibleobj.Drug_List__c);
                druglistGroupIds.add(customDCList.waiverDeductibleobj.Drug_Group__c);
            }
            Map<String,String> mapdrugListGroupDescription  = new Map<String,String>();
            for(Drug_List__c drugList : [Select 
                                            Id, Description__c, Allowable_Actions__c
                                         From 
                                            Drug_List__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                mapdrugListGroupDescription.put(druglist.id, drugList.Description__c);
                addedDLs.put(drugList.id,drugList.Allowable_Actions__c);
            }
            
            for(Drug_Group__c drugGroup : [Select 
                                            Id, Description__c, Allowable_Actions__c
                                         From 
                                            Drug_Group__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                mapdrugListGroupDescription.put(drugGroup.id, drugGroup.Description__c);
                addedDLs1.put(drugGroup.id,drugGroup.Allowable_Actions__c);
            }
            
            for(WaiverDeductible customDCList: listWrapCustomWOD) {
                if(customDCList.waiverDeductibleobj != null){
                    if(customDCList.waiverDeductibleobj.Drug_List__c!=null && customDCList.waiverDeductibleobj.Drug_Group__c!=null){
                        customDCList.waiverDeductibleobj.addError(system.Label.ERR00069);
                        IsValidMNOY = false;
                    }
                    //Added by Nitish ST#1220
                    if(customDCList.waiverDeductibleobj.Network__c == null){
                        customDCList.waiverDeductibleobj.addError(system.Label.ERR305);
                        IsValidMNOY = false;
                    }
                    if(customDCList.waiverDeductibleobj.Delivery_System__c == null){
                        customDCList.waiverDeductibleobj.addError(system.Label.ERR306);
                        IsValidMNOY = false;
                    }
                    // added by Vikram for request 06211
                    else if (customDCList.waiverDeductibleobj.Drug_List__c!=null){
                              if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c)) && addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c).contains(ALLOWOVERRIDE)){   
                              }else{ 
                                  if(String.isBlank(addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c)) || !addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c).contains(WAIVEROFDEDUCTIBLE)){
                                      customDCList.waiverDeductibleobj.addError(system.Label.ERR0298);
                                      IsValidMNOY = false;
                                  }
                              }
                          }else if(customDCList.waiverDeductibleobj.Drug_Group__c!=null){
                                    if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c)) && addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c).contains(ALLOWOVERRIDE)){
                                    }else{    
                                        if (String.isBlank(addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c)) || !addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c).contains(WAIVEROFDEDUCTIBLE)){
                                        customDCList.waiverDeductibleobj.addError(system.Label.ERR0298);
                                        IsValidMNOY = false;
                                        }
                                    }
                                }// 06211 ends 
                    else{
                        if(customDCList.waiverDeductibleobj.Delivery_System__c.equalsignorecase(BOTH)){
                            for(Integer i=0; i<listWrapCustomWOD.size() ; i++){
                                if( listWrapCustomWOD[i].waiverDeductibleobj.Drug_List__c == customDCList.waiverDeductibleobj.Drug_List__c  
                                            && 
                                    listWrapCustomWOD[i].waiverDeductibleobj.Drug_List__c != null   
                                            &&      
                                        (   listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(RETAIL)  
                                                || listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(MAIL)
                                        )
                                  ){
                                    customDCList.waiverDeductibleobj.addError(system.Label.ERR0245);
                                    IsValidMNOY = false;
                                }else if( listWrapCustomWOD[i].waiverDeductibleobj.Drug_Group__c == customDCList.waiverDeductibleobj.Drug_Group__c  
                                            && 
                                        listWrapCustomWOD[i].waiverDeductibleobj.Drug_Group__c != null      
                                            &&  
                                        (   listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(RETAIL)
                                                || listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(MAIL)
                                        )
                                  ){ 
                                    customDCList.waiverDeductibleobj.addError(system.Label.ERR0245);
                                    IsValidMNOY = false;
                                }
                            }
                        }
                   }    
                    //return null if some validation fails
                    if(!IsValidMNOY){
                         return null;
                    }
                    //insert the record if all validations are satisfied
                    else{ 
                        String description = mapdrugListGroupDescription.containsKey(customDCList.waiverDeductibleobj.Drug_Group__c) ?  mapdrugListGroupDescription.get(customDCList.waiverDeductibleobj.Drug_Group__c)   : '';
                        description = mapdrugListGroupDescription.containsKey(customDCList.waiverDeductibleobj.Drug_List__c) ?  mapdrugListGroupDescription.get(customDCList.waiverDeductibleobj.Drug_List__c)   : description; 
                        System.debug('########Step13');        
                        junctionRecords.add(new Waiver_Of_Deductible__c(crd_id__c = crdid
                                , id= customDCList.waiverDeductibleobj.id
                                , Delivery_System__c = customDCList.waiverDeductibleobj.Delivery_System__c
                                , Standard__c = false
                                , Drug_Group__c = customDCList.waiverDeductibleobj.Drug_Group__c
                                , Drug_List__c = customDCList.waiverDeductibleobj.Drug_List__c
                                , M__c = customDCList.waiverDeductibleobj.M__c
                                , N__c = customDCList.waiverDeductibleobj.N__c
                                , Drug_Class_Desc__c = description
                                , O__c = customDCList.waiverDeductibleobj.O__c
                                , Y__c = customDCList.waiverDeductibleobj.Y__c
                                ,Network__c = customDCList.waiverDeductibleobj.Network__c));//Added By Nitish 6911
                                if(customDCList.waiverDeductibleobj.id != null){
                                    existingCustomWaivers.add(customDCList.waiverDeductibleobj.id);
                                }
                    }
                }           
            }
            System.debug('########Step14' +existingCustomWaivers);
            // Delete existing from custom drug class 
            database.delete([Select id from Waiver_Of_Deductible__c where crd_id__c =:crdId and standard__c = false and id not in: existingCustomWaivers LIMIT 80000] );
            
            if(junctionRecords != null && junctionRecords.size() > 0){
               
                database.upsert(junctionRecords);
                }
            
            database.update(crd);
            pageRef = new Pagereference(ACCUMPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        }catch(exception e){
            System.debug('####################' +e.getmessage());
            Apexpages.addMessages(e);
            database.rollback(sp);
        }
        return pageRef;
    }
/**
     *Method :- backbutton2
     *Description :- Method to add record in Waiver Of Deductible object on back button click in readonly mode
**/ 
    public pagereference backbutton2(){
        try{
            Pagereference pageRef;
            pageRef = new Pagereference(DCPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }catch(exception e){
            Apexpages.addMessages(e);
            return null;
        }
    }
/**
     *Method :- backbutton
     *Description :- Method to add record in Waiver Of Deductible object on back button click
**/ 
    
    public pagereference backbutton(){
        Savepoint sp = Database.setSavepoint();
        Pagereference pageRef;
        try{            
    GC_Validation_Methods validationmethod = new GC_Validation_Methods();
    boolean IsValidMNOY = true;
            List <Waiver_Of_Deductible__c> junctionRecords = new List <Waiver_Of_Deductible__c> ();
            
            // added by Vikram for request 06211
            set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }
            // 06211 ends 
            
            Set<String> stdDrugClassAdded = new Set<String>();
            Set<String> stdDrugClassAlreadyExisting = new Set<String>();
            for(StandardWaiver std : lstStndrdWaiver){
                if(std.drugClassName == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0247));
                    return null;
                }
                else{
                    stdDrugClassAdded.add(std.drugClassName);
                }
            }
            if(lstStndrdWaiver.size() != stdDrugClassAdded.size()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR00133));
                    return null;
            }
            
            //Remove std Drug class that are not the part of current set
            List<Waiver_Of_Deductible__c> stdWaiversToDelete = new List<Waiver_Of_Deductible__c>();
            for(Waiver_Of_Deductible__c waiver : [Select id, Drug_Class__c from Waiver_Of_Deductible__c where crd_id__c =:crdId and Standard__c = true LIMIT 80000]){
                    if(! stdDrugClassAdded.contains(waiver.drug_Class__c)){
                        stdWaiversToDelete.add(waiver);
                    }else{
                        If(!Test.isRunningTest()){
                            stdDrugClassAlreadyExisting.add(waiver.drug_Class__c);
                        }
                    }
            }
            database.delete(stdWaiversToDelete);
    //Added By Amit
            String formularyGroup='';
            
             for(Drug_Coverage__c dcRecord : [Select Id,name, Formulary__c,Formulary__r.name,Formulary__r.Group__c from Drug_Coverage__c where CRD_ID__c = : crd.Id LIMIT 80000]){   
            if(dcRecord.Formulary__r.Group__c!= Null && dcRecord.Formulary__r.Group__c!= ''){
                    formularyGroup = dcRecord.Formulary__r.Group__c;
                }
                if(dcRecord.Formulary__c == null){
                    formularyErr = True;
                }
            }
    
        if(formularyGroup!= '' && formularyGroup!= Null){
                for(Waiver_Of_Deductible_Drug_Class__c tempWODdrugClass : [select 
                                                                            id,name,Delivery_System__c,Drug_Class__c,Drug_Class_Desc__c,Drug_Group__c,Drug_List__c,Formulary_Group__c
                                                                            ,M__c,N__c,O__c,Y__c,Drug_List__r.name,Network__c
                                                                          From 
                                                                            Waiver_Of_Deductible_Drug_Class__c 
                                                                          where 
                                                                            Drug_Class__c in :stdDrugClassAdded AND Drug_Class__c NOT in :stdDrugClassAlreadyExisting LIMIT 80000]){
                    System.debug('########Step0');                   
                    
                    list<string> druglistnameformulary = new list<string>();
                    //Added code by Raj for R#6565 Start
                    system.debug('%%%%% ' + tempWODdrugClass.Formulary_Group__c + ' ' + formularyGroup +'  ' +  tempWODdrugClass.Drug_List__c);
                    if(tempWODdrugClass.Formulary_Group__c!= Null 
                              && formularyGroup.equalsignorecase(tempWODdrugClass.Formulary_Group__c) && tempWODdrugClass.Drug_List__c !=null){
                        druglistnameformulary.add(tempWODdrugClass.Drug_List__r.name);
                    }
                    //Added code by Raj for R# 6565 End
                    //Comments code by Raj Start
                                                                                
                    /*if(formularyGroup.equalsignorecase(V1) && tempWODdrugClass.SG_Value_Plus__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.SG_Value_Plus__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V2)  && tempWODdrugClass.SG_Value__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.SG_Value__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V3)  && tempWODdrugClass.LG_Value_Plus__c !=null)
                    {   Druglistnameformulary.addall(tempWODdrugClass.LG_Value_Plus__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V4)  && tempWODdrugClass.LG_Value__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.LG_Value__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V5)  && tempWODdrugClass.LG_Premier_Plus__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.LG_Premier_Plus__c.split(COLON));}
                    if(formularyGroup.equalsignorecase(V6)  && tempWODdrugClass.LG_Premier__c !=null)
                    {Druglistnameformulary.addall(tempWODdrugClass.LG_Premier__c.split(COLON));}
                    */
                    //Comments code by Raj End
                    
                    
                        for(drug_list__c druglistRecord : [select id,name from drug_list__c where name in : Druglistnameformulary LIMIT 80000]){
                            System.debug('########Step1');
                            junctionRecords.add(new Waiver_Of_Deductible__c(
                                                crd_id__c = crd.Id
                                                ,Drug_Class__c = tempWODdrugClass.Drug_Class__c
                                                ,Drug_Class_Desc__c = tempWODdrugClass.Drug_Class_Desc__c
                                                , Delivery_System__c = tempWODdrugClass.Delivery_System__c
                                                , Standard__c = true
                                                , Drug_Group__c = tempWODdrugClass.Drug_Group__c
                                                , Drug_List__c = druglistRecord.id
                                                , M__c = tempWODdrugClass.M__c
                                                , N__c = tempWODdrugClass.N__c
                                                , O__c = tempWODdrugClass.O__c
                                                , Y__c = tempWODdrugClass.Y__c
                                                , Network__c = tempWODdrugClass.Network__c ));    //Added By Nitish 6911              
                        }
            inLoop = true;      
            Druglistnameformulary.clear();
                }
            
                    //Added By Nitish ST#2515
                    if((junctionRecords.size()== 0 || formularyErr) && inLoop && !stopErrorForCustom){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                        return null;
                    }
        }
else{
            //Add new Std Drug Class added
        boolean formularyGroupError = false;
        boolean inLoop = false;
            for(Waiver_Of_Deductible_Drug_Class__c wddc : [Select id, Drug_Class__c, Delivery_System__c, Drug_Group__c, Drug_List__c, Drug_Class_Desc__c,M__c, N__c, O__c, Y__c,Drug_List__r.Allowable_Actions__c
                                                                , Drug_Group__r.Allowable_Actions__c,Formulary_Group__c,Network__c
                                                            from Waiver_Of_Deductible_Drug_Class__c
                                                            Where Drug_Class__c in :stdDrugClassAdded AND Drug_Class__c NOT in :stdDrugClassAlreadyExisting and Formulary_Group__c = Null LIMIT 80000]){
                                                            // added by Vikram for request 06211
                                                                if(wddc.Drug_Group__c!=null){
                                                                    String alact = wddc.Drug_Group__r.Allowable_Actions__c;
                                                                    if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wddc.Drug_Group__r.Allowable_Actions__c) && alact.contains(ALLOWOVERRIDE)
                                    ){
                                                                        
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c
                                                                        ,Network__c = wddc.Network__c )); //Added By Nitish 6911
                                                                        
                                                                }else{    
                                                                        
                                                                        if (String.isBlank(wddc.Drug_Group__r.Allowable_Actions__c) || !alact.contains(WAIVEROFDEDUCTIBLE)){
                                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0298));
                                                                        return null;
                                                                        }else{
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c 
                                                                        ,Network__c = wddc.Network__c));//Added By Nitish 6911 
                                                                        }
                                                                     }
                                                                } else if(wddc.Drug_List__c!=null){
                                                                    String alact1 = wddc.Drug_List__r.Allowable_Actions__c;
                                                                    if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(wddc.Drug_List__r.Allowable_Actions__c) && alact1.contains(ALLOWOVERRIDE)
                                    ){
                                                                        
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c 
                                                                        ,Network__c = wddc.Network__c)); //Added By Nitish 6911
                                                                        
                                                                    }else{    
                                                                        if (String.isBlank(wddc.Drug_List__r.Allowable_Actions__c) || !alact1.contains(WAIVEROFDEDUCTIBLE)){
                                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0298));
                                                                        return null;
                                                                        }else{
                                                                        junctionRecords.add(new Waiver_Of_Deductible__c(
                                                                        crd_id__c = crdId
                                                                        ,Drug_Class__c = wddc.Drug_Class__c
                                                                        ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                                                        , Delivery_System__c = wddc.Delivery_System__c
                                                                        , Standard__c = true
                                                                        , Drug_Group__c = wddc.Drug_Group__c
                                                                        , Drug_List__c = wddc.Drug_List__c
                                                                        , M__c = wddc.M__c
                                                                        , N__c = wddc.N__c
                                                                        , O__c = wddc.O__c
                                                                        , Y__c = wddc.Y__c 
                                                                        ,Network__c = wddc.Network__c)); //Added By Nitish 6911
                                                                        }
                                                                     }
                                                                  }
                                                                else{
                                                                // 06211 ends 
                    junctionRecords.add(new Waiver_Of_Deductible__c(
                                    crd_id__c = crdId
                                    ,Drug_Class__c = wddc.Drug_Class__c
                                    ,Drug_Class_Desc__c = wddc.Drug_Class_Desc__c
                                    , Delivery_System__c = wddc.Delivery_System__c
                                    , Standard__c = true
                                    , Drug_Group__c = wddc.Drug_Group__c
                                    , Drug_List__c = wddc.Drug_List__c
                                    , M__c = wddc.M__c
                                    , N__c = wddc.N__c
                                    , O__c = wddc.O__c
                                    , Y__c = wddc.Y__c 
                                    ,Network__c = wddc.Network__c));  //Added By Nitish 6911
                }
            //Added By Nitish for 2515
                    if(junctionRecords.size()>0){
                        formularyGroupError = true;
                    }
                    //Added By Nitish ST#2515
                    if((!formularyGroupError|| formularyErr) && !stopErrorForCustom ){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                        return null;
                    }
                    inLoop = true;
                }
                // Added By Nitish for ST#2515
                    if(!inLoop && !stopErrorForCustom && lstStndrdWaiver.size()>0){
                        if(formularyErr  && !stopErrorForCustom ){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                            return null;
                        }
                        else{
                            List<Waiver_Of_Deductible_Drug_Class__c>  wddcList = [Select id, Drug_Class__c,Drug_Group__r.Allowable_Actions__c,Formulary_Group__c,Network__c
                                                                    from Waiver_Of_Deductible_Drug_Class__c
                                                                    Where Drug_Class__c in :stdDrugClassAdded  and Formulary_Group__c = Null LIMIT 80000];
                                                    
                            if(wddcList.size()==0){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR307));
                                return null;
                            }
                        }
                    
                    }
                
    }
        //Ends
            //checking all the validations
            if(listWrapCustomWOD != null && listWrapCustomWOD.size() > 0){
                IsValidMNOY = validationmethod.validateWaiverOfDeductible(listWrapCustomWOD);
            }
            
            Map<Id,String> addedDLs = new Map<Id,String>();    // added by Vikram for request 06211
            Map<Id,String> addedDLs1 = new Map<Id,String>();   // added by Vikram for request 06211
            
            Set<Id> druglistGroupIds = new Set<Id>();
            Set<Id> existingCustomWaivers = new Set<Id>();
            for(WaiverDeductible customDCList: listWrapCustomWOD) {
                druglistGroupIds.add(customDCList.waiverDeductibleobj.Drug_List__c);
                druglistGroupIds.add(customDCList.waiverDeductibleobj.Drug_Group__c);
            }
            Map<String,String> mapdrugListGroupDescription  = new Map<String,String>();
            for(Drug_List__c drugList : [Select 
                                            Id, Description__c, Allowable_Actions__c
                                         From 
                                            Drug_List__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                mapdrugListGroupDescription.put(druglist.id, drugList.Description__c);
                addedDLs.put(drugList.id,drugList.Allowable_Actions__c);
            }
            
            for(Drug_Group__c drugGroup : [Select 
                                            Id, Description__c, Allowable_Actions__c
                                         From 
                                            Drug_Group__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                mapdrugListGroupDescription.put(drugGroup.id, drugGroup.Description__c);
                addedDLs1.put(drugGroup.id,drugGroup.Allowable_Actions__c);
            }
            
            for(WaiverDeductible customDCList: listWrapCustomWOD) {
                if(customDCList.waiverDeductibleobj != null){
                    if(customDCList.waiverDeductibleobj.Drug_List__c!=null && customDCList.waiverDeductibleobj.Drug_Group__c!=null){
                        customDCList.waiverDeductibleobj.addError(system.Label.ERR00069);
                        IsValidMNOY = false;
                    }
                     //Added by Nitish ST#1220
                    if(customDCList.waiverDeductibleobj.Network__c == null){
                        customDCList.waiverDeductibleobj.addError(system.Label.ERR305);
                        IsValidMNOY = false;
                    }
                    if(customDCList.waiverDeductibleobj.Delivery_System__c == null){
                        customDCList.waiverDeductibleobj.addError(system.Label.ERR306);
                        IsValidMNOY = false;
                    }
                    // added by Vikram for request 06211
                    else if (customDCList.waiverDeductibleobj.Drug_List__c!=null){
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c)) && addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c).contains(ALLOWOVERRIDE)){   
                              }else{ 
                                  if(String.isBlank(addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c)) || !addedDLs.get(customDCList.waiverDeductibleobj.Drug_List__c).contains(WAIVEROFDEDUCTIBLE)){
                                      customDCList.waiverDeductibleobj.addError(system.Label.ERR0298);
                                      IsValidMNOY = false;
                                  }
                              }
                        }else if(customDCList.waiverDeductibleobj.Drug_Group__c!=null){
                                    if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c)) && addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c).contains(ALLOWOVERRIDE)){
                                    }else{    
                                        if (String.isBlank(addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c)) || !addedDLs1.get(customDCList.waiverDeductibleobj.Drug_Group__c).contains(WAIVEROFDEDUCTIBLE)){
                                        customDCList.waiverDeductibleobj.addError(system.Label.ERR0298);
                                        IsValidMNOY = false;
                                        }
                                    }
                                }
                                // 06211 ends 
                    
                    /*else{
                        if(customDCList.waiverDeductibleobj.Delivery_System__c.equalsignorecase(BOTH)){
                            for(Integer i=0; i<listWrapCustomWOD.size() ; i++){
                                if( listWrapCustomWOD[i].waiverDeductibleobj.Drug_List__c == customDCList.waiverDeductibleobj.Drug_List__c  
                                            && 
                                    listWrapCustomWOD[i].waiverDeductibleobj.Drug_List__c != null   
                                            &&      
                                        (   listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(RETAIL) 
                                                || listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(MAIL)
                                        )
                                  ){
                                    customDCList.waiverDeductibleobj.addError(system.Label.ERR0245);
                                    IsValidMNOY = false;
                                }else if( listWrapCustomWOD[i].waiverDeductibleobj.Drug_Group__c == customDCList.waiverDeductibleobj.Drug_Group__c  
                                            && 
                                        listWrapCustomWOD[i].waiverDeductibleobj.Drug_Group__c != null      
                                            &&  
                                        (   listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(RETAIL)  
                                                || listWrapCustomWOD[i].waiverDeductibleobj.Delivery_System__c.equalsignorecase(MAIL)
                                        )
                                  ){ 
                                    customDCList.waiverDeductibleobj.addError(system.Label.ERR0245);
                                    IsValidMNOY = false;
                                }
                            }
                        }
                   }*/  
                    //return null if some validation fails
                    if(!IsValidMNOY){
                         return null;
                    }
                    //insert the record if all validations are satisfied
                    else{ 
                        String description = mapdrugListGroupDescription.containsKey(customDCList.waiverDeductibleobj.Drug_Group__c) ?  mapdrugListGroupDescription.get(customDCList.waiverDeductibleobj.Drug_Group__c)   : '';
                        description = mapdrugListGroupDescription.containsKey(customDCList.waiverDeductibleobj.Drug_List__c) ?  mapdrugListGroupDescription.get(customDCList.waiverDeductibleobj.Drug_List__c)   : description;         
                        junctionRecords.add(new Waiver_Of_Deductible__c(crd_id__c = crdid
                                , id= customDCList.waiverDeductibleobj.id
                                , Delivery_System__c = customDCList.waiverDeductibleobj.Delivery_System__c
                                , Standard__c = false
                                , Drug_Group__c = customDCList.waiverDeductibleobj.Drug_Group__c
                                , Drug_List__c = customDCList.waiverDeductibleobj.Drug_List__c
                                , M__c = customDCList.waiverDeductibleobj.M__c
                                , N__c = customDCList.waiverDeductibleobj.N__c
                                , Drug_Class_Desc__c = description
                                , O__c = customDCList.waiverDeductibleobj.O__c
                                , Y__c = customDCList.waiverDeductibleobj.Y__c
                                ,Network__c = customDCList.waiverDeductibleobj.Network__c));
                                if(customDCList.waiverDeductibleobj.id != null){
                                    existingCustomWaivers.add(customDCList.waiverDeductibleobj.id);
                                }
                    }
                }           
            }
            
            // Delete existing from custom drug class 
            database.delete([Select id from Waiver_Of_Deductible__c where crd_id__c =:crdId and standard__c = false and id not in: existingCustomWaivers LIMIT 80000] );
            
            if(junctionRecords != null && junctionRecords.size() > 0){
                
                database.upsert(junctionRecords);
                }
            
            database.update(crd);
            pageRef = new Pagereference(DCPAGE + crdId);
         pageRef.getParameters().put(EDITMODEPARAM,editMode);
             pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        }catch(exception e){
            System.debug('####################' +e.getmessage());
            Apexpages.addMessages(e);
            database.rollback(sp);
        }
        return pageRef;
    }
/**
     *WrapperClass :- WaiverDeductible
     *Description :- Wrapper class to bind Waiver Of Deductible Object with select option to insert Custom records
**/
    public class WaiverDeductible {
            public Waiver_Of_Deductible__c waiverDeductibleobj {get;set;}
            public boolean selected {get;set;}
            
            public WaiverDeductible(boolean selected, Waiver_Of_Deductible__c wodObj){
                this.selected = selected;
                this.waiverDeductibleobj = wodObj;
            }   
    }
/**
     *WrapperClass :- StandardWaiver
     *Description :- Wrapper class to bind Drug Class with select option to insert Standard records
**/
    public class StandardWaiver{
        public string drugClassName {get;set;}
        public boolean isSelected {get;set;}
         /*Method for holding boolean variables to select DC records*/
        public StandardWaiver(string drugClassName, boolean isSelected){
                this.isSelected = isSelected;
                this.drugClassName = drugClassName;
            }
    }
}