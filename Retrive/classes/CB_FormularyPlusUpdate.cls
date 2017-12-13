/*Purpose: Apex Class to check Formulary Plus logic and updates CRD and Drug Coverage Records, ST/PA/QL Junction Records
========================================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE                          DETAIL                                 
   1.0      Amit Jain        13 April, 2015      Apex Class to check Formulary Plus logic and updates CRD and Drug Coverage Records, ST/PA/QL Junction Records
   2.0      Amit jain        18 May, 2015         Added formulary Extension logic for request 5755
   2.1      Richa            20 May, 2015        Implemented Req 5768
   2.2      Sushant Sethi    21 May,2015         Implemented Req 05756
   2.3      Amit Jain        27 May, 2015        Code commented as per Req 5755
   2.4      Richa            29 Jun, 2015        Implemented Req 5866
   2.5      Amit             16 Sep, 2015       Modified condition to delete and create precert junction records as per Request 6037, ST# 312
   2.6      Amit             29 Sep, 2015       Modified ST/PA/QL junction record deletion based on FormularyXERD Table for ST# 373
   2.7      Richa            06 Jan, 2016       Modified PA/QL record creation based on FormularyXERD Table for ST#513
   2.8      Ayushi           08 Jan, 2016       Incorporated the logic for deletetion of NPL Juction records when Formulary is changed for ST#778
   2.9      Nitish           13 June, 2016      Req 6452 - ST 1057 Modify Formulary Logic for Premier Plus for Specialty   
======================================================================== */

public with sharing class CB_FormularyPlusUpdate {
    private static final string DLNAME = 'DL-0000848';
    private static final string PRREQUIRED = 'Prior Authorization required';
    private static final string RETAIL = 'Retail';
    private static final string SEMICOLON = ';';
    private static final string NOLABEL = 'No';
    private static final string YESLABEL = 'Yes';
    private static final string DOESNOTAPPLY = 'Does not Apply (Insured/not state filed)';
    private static final string LGPREMIER = 'LG Premier';
    private static final string PADRUGLIST = 'PA Drug List(s)';
    private static final string QLDRUGLIST = 'QL Drug List(s)';
    private static final string QUANTITYLIMIT = 'Quantity Limit';
    private static final string STDRUGLIST = 'ST Drug List(s)';
    private static final string LGPREMIERPLUS = 'LG Premier Plus';
    private static final string SHPREMIERPLUS = 'Student Health Premier Plus';
    private static final string PRECERT = 'Precert';
    private static final string STEPTHERAPY = 'Step Therapy';
    private static final string NULLLABEL = '';
    private static final string PRECERTTOCDL = 'DL-0076037';
    private set<string> lstToAvoidSamePC = new set<string>();
    private set<string> lstToAvoidSameQL = new set<string>();

/**
* Method :- formularyPlusUpdates
* Description :- Logic to Cleanup junction records and create new ST/PA/QL junctions    
**/         
    public void formularyPlusUpdates(Map<Id,ID> mapDC2Formulary, Drug_Coverage__c currentRecord, 
                                            CRD__c crdRecord, Map<ID,String> DCwithRecordType){
                                                
        try{
            system.debug('YYYYY ' + currentRecord.Aetna_Specialty_Care_Rx__c);
            Boolean processJunctionRecords = False;
            //set<String> setformularyName = new set<String>();
            List<CRD_PriorAuth_Junction__c> paJuncDel = new  List<CRD_PriorAuth_Junction__c>();
            List<CRD_Quantity_Limit_Junction__c> qlJuncDel = new  List<CRD_Quantity_Limit_Junction__c>();
            List<CRD_Step_Therapy_Junction__c> stJuncDel = new  List<CRD_Step_Therapy_Junction__c>();
            Set<String> dlPrecert = new Set<String>();
            Set<String> dlQuantityLimit = new Set<String>();
            Set<String> dlStepTherapy = new Set<String>();
            //Set<ID> drugCwithDL0000848 = new Set<ID>();
            //map<Id,Id> mapDc2CRDID = new map<Id,Id>();
            //set<Id> setCRDID = new set<Id>();
            Set<String> prSafetyEdit = new Set<String>();
            Set<String> qlSafetyEdit = new Set<String>();
            CRD__c crdPLQAST = new CRD__c();
            /*Select the Formularies from Drug Coverage
            for(DC_Drug_List_Group__c dcdlRecord: [Select Id,Name,Drug_List_Name__c,Related_Drug_Coverage__c,Inclusion_Exclusion__c,Drug_List__r.name 
                                                        From 
                                                      DC_Drug_List_Group__c 
                                                        where 
                                                      Drug_List__r.name = :DLNAME and Related_Drug_Coverage__c =: mapDC2Formulary.keyset() LIMIT 10000]){ 
                    if(!PRREQUIRED.equalsIgnoreCase(dcdlRecord.Inclusion_Exclusion__c)){
                        drugCwithDL0000848.add(dcdlRecord.Related_Drug_Coverage__c);
                    }
            }*/
            //Query on FormularyXCustomDL (ERD) Object and find the matching record with the inserted formulary
            //Step 1 – Formulary added on Drug Coverage searches for a match in FormularyX table, in case no match is found, then no action isi taken on ST/PA/QL screen
            //Map<Id,Drug_Coverage__c> mapid2DrugCoverage = new Map<Id,Drug_Coverage__c>();
            //map<Id,List<String>> mapFormulary2Precert = new map<Id,List<String>>();
            Boolean deletePrecertList = False;
            Boolean deleteQuantityList = False;
            Boolean deleteSTList = False;
            
            //ST#778 Starts
            //Delete all NPL Juction records when blank or commercial Formulary is changed to Non-commercial Formulary
            List<CRD_NPL_Junction__c> listdeleteNPL = [SELECT CRD_ID__c,CreatedById,CreatedDate,Drug_List_Description__c,
                                                       Drug_List_Name__c,Drug_List__c,Id,IsDeleted,IsStandard__c,
                                                       LastModifiedById,LastModifiedDate,LastSent__c,Name,Select__c 
                                                       FROM CRD_NPL_Junction__c
                                                       where CRD_ID__c=:crdRecord.id limit 10000];
            database.delete(listdeleteNPL);  
            crdRecord.NPL_Drug_List__c = null;
            //crdRecord.NPL_Applies__c = NOLABEL;
            //ST#778 ends
            
            for(FormularyXCustomDL_ERD__c formulayCustom: [Select Id, name,Aetna_Specialty_Care_Rx__c, Formulary__c, 
                                                            Override_Refill_Too_Soon__c, Precert__c, Quantity_Limit__c,
                                                            Secondary_of_fills_before_Force_to_SPN__c, Secondary_Aetna_Specialty_Care_Rx__c 
                                                            , Secondary_Specialty_Drug_List__c,Specialty_Drug_List__c
                                                            , Step_Therapy__c,Secondary_Specialty_Drug_List_ID__c
                                                            , NPL_List__c,Refill_Too_Soon__c, PR_Safety_Edits__r.name
                                                            , QL_Safety_Edits__r.name,Formulary__r.Name,QL_Safety_Edits__c,PR_Safety_Edits__c
                                                           From 
                                                            FormularyXCustomDL_ERD__c
                                                           Where Formulary__c In: mapDC2Formulary.values() 
                                                           limit 10000]){
                //Step 2 – If match is found, and PA/QL fields of matching record are not null then make a list of those DLs that are there in the FormularyX table in the corresponding column.
                if(formulayCustom.Precert__c != Null  && !(LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c)) && !(SHPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c))
                                                      && YESLABEL.equalsIgnoreCase(crdRecord.Do_you_want_to_do_Precert__c)){ 
                    deletePrecertList = True; //deleting the existing precert record to insert new from FormularyX table
                    String[] precertDrugLists = formulayCustom.Precert__c.split(SEMICOLON);//spliting all the DLs in Precert field and add them is a set
                    //for(String drugListprecert : precertDrugLists){
                        dlPrecert.addAll(precertDrugLists); //set of new DLs to be added on Precert screen
                    //}
                }
                //PR Safety Edit record should always get created irrespective to Precert yes or no
                if(formulayCustom.PR_Safety_Edits__r.name != Null){
                    prSafetyEdit.add(formulayCustom.PR_Safety_Edits__r.name);
                }
                if(formulayCustom.Quantity_Limit__c != Null){
                    deleteQuantityList = True;//deleting the existing quantity limit record to insert new from FormularyX table
                    String[] qlDrugLists = formulayCustom.Quantity_Limit__c.split(SEMICOLON);
                    //for(String drugListQL : qlDrugLists){
                        dlQuantityLimit.addAll(qlDrugLists); 
                    //}
                }
                //QL Safety Edit record should always get created irrespective to Precert yes or no
                if(formulayCustom.QL_Safety_Edits__r.name != Null){
                    qlSafetyEdit.add(formulayCustom.QL_Safety_Edits__r.name);
                }
                if(formulayCustom.Step_Therapy__c != Null){
                    deleteSTList = True;
                    String[] stDrugLists = formulayCustom.Step_Therapy__c.split(SEMICOLON);
                    //for(String drugListST : stDrugLists){
                        dlStepTherapy.addAll(stDrugLists);
                    //}
                }
                    if(RETAIL.equalsIgnoreCase(DCwithRecordType.get(currentRecord.Id)) && 
                        currentRecord.Formulary__c == formulayCustom.Formulary__c){
                        if(cb_BuildStep.FormularyFlag && !crdRecord.CRD_Automated__c){//Added not automated part for story 6958 by Nitish
                            //commented by Amit for request 5755, so that manual change for Aetna Specialty Care Rx is not overridden, 27 may 2015
                                currentRecord.Aetna_Specialty_Care_Rx__c = formulayCustom.Aetna_Specialty_Care_Rx__c; 
                        }
                          system.debug('RRRRR ' + currentRecord.Aetna_Specialty_Care_Rx__c);  
                            if(formulayCustom.Secondary_of_fills_before_Force_to_SPN__c != Null){
                                if(!LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c) && !SHPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c)){
                                currentRecord.Secondary_of_fills_before_force_to_SPN__c = 
                                                Integer.ValueOF(formulayCustom.Secondary_of_fills_before_Force_to_SPN__c);
                            }
                            }
                            //Richa added below if for Req 5768
                            /*if(currentRecord.Aetna_Specialty_Care_Rx__c == Null 
                                || DOESNOTAPPLY.equalsIgnoreCase(currentRecord.Aetna_Specialty_Care_Rx__c)
                                || LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c)){//Richa added this condition for Req 6452
                                currentRecord.Do_you_have_Specialty__c = NOLABEL;
                                currentRecord.Force_to_Specialty__c = NOLABEL;
                                currentRecord.of_fills_before_force_to_specialty__c = null;
                                currentRecord.Speciality_Drug_List__c = null;
                            }*/
                            if(!LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c) && !SHPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c)){
                                currentRecord.Secondary_Aetna_Specialty_Care_Rx__c = formulayCustom.Secondary_Aetna_Specialty_Care_Rx__c;
                                currentRecord.Secondary_Speciality_Drug_List__c = formulayCustom.Secondary_Specialty_Drug_List_ID__c;
                            }
                            if(currentRecord.Secondary_Aetna_Specialty_Care_Rx__c!= Null && 
                                            currentRecord.Secondary_Aetna_Specialty_Care_Rx__c!= NULLLABEL){
                                if(!LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c) && !SHPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c)){
                                    currentRecord.Secondary_Force_to_Specialty__c = YESLABEL;
                                }
                            }
                            
                            //Check for DL and update Aetna Specialty Care Rx
                             /*Commented by Amit for request 5755, so that manual change for Aetna Specialty Care Rx is not overridden, 27 may 2015
                            if(DrugCwithDL0000848.contains(currentRecord.id)){
                                if(currentRecord.Aetna_Specialty_Care_Rx__c == 'Applies-SG Value with Fertility'){
                                     currentRecord.Aetna_Specialty_Care_Rx__c = 'Applies-SG Value no Fertility';
                                }else if( currentRecord.Aetna_Specialty_Care_Rx__c == 'Applies-SG Value Plus with Fertility'){
                                    currentRecord.Aetna_Specialty_Care_Rx__c =  'Applies-SG Value Plus no Fertility';
                                }else if(currentRecord.Aetna_Specialty_Care_Rx__c == 'Applies-LG Value with Fertility'){
                                    currentRecord.Aetna_Specialty_Care_Rx__c = 'Applies-LG Value no Fertility';
                                }else if(currentRecord.Aetna_Specialty_Care_Rx__c == 'Applies-LG Value Plus with Fertility'){
                                    currentRecord.Aetna_Specialty_Care_Rx__c = 'Applies-LG Value Plus no Fertility';
                                }else if(currentRecord.Aetna_Specialty_Care_Rx__c == 'Applies-LG Premier with Fertility'){
                                    currentRecord.Aetna_Specialty_Care_Rx__c = 'Applies-LG Premier no Fertility';
                                }else if(currentRecord.Aetna_Specialty_Care_Rx__c == 'Applies-LG Premier Plus with Fertility'){
                                    currentRecord.Aetna_Specialty_Care_Rx__c = 'Applies-LG Premier Plus no Fertility';
                                }
                            }*/
                            
                    }
                    if(formulayCustom.NPL_List__c!= Null){
                                crdRecord.NPL_Drug_List__c = formulayCustom.NPL_List__c;
                                crdRecord.NPL_Applies__c = YESLABEL;
                            }
                if(DCwithRecordType.get(currentRecord.Id) != null && currentRecord.Formulary__c == formulayCustom.Formulary__c){
                        currentRecord.Standard_Refill_too_Soon__c = formulayCustom.Override_Refill_Too_Soon__c;//Richa added for Req 5866                        
                        currentRecord.Custom_Refill_too_Soon__c = formulayCustom.Refill_Too_Soon__c;//Richa added for Req 5866
                }
                //Set flag to Process junction records
                processJunctionRecords = True;
            }
            //Step 3 – Delete the ST/PA/QL records which got created from Mapping if Step 2 is executed OR Formulary is commercial.    
            //Delete all the ST/PA/QL junction records with related CRD
            if(processJunctionRecords || currentRecord.Formulary_Group__c==NULLLABEL ||  currentRecord.Formulary_Group__c==Null){
                crdPLQAST = [select id,Precert_TOC_days__c, (Select id,Precert_class__c from CRD_PriorAuth_Junction__r limit 10000)
                                        ,(Select id,QL_Class__c from CRD_Quantity_Limit_Jucntion__r limit 10000)
                                        ,(Select id from CRD_Step_Therapy_Junction__r limit 10000)
                                    From crd__C where id = :crdRecord.ID limit 10000];
                paJuncDel = crdPLQAST.CRD_PriorAuth_Junction__r;
                if((paJuncDel!= Null && paJuncDel.size()>0 && deletePrecertList) || currentRecord.Formulary_Group__c==NULLLABEL ||  
                                                                currentRecord.Formulary_Group__c==Null){
                    Database.delete (paJuncDel,false);
                } else {
                    for(CRD_PriorAuth_Junction__c temp : crdPLQAST.CRD_PriorAuth_Junction__r){
                        lstToAvoidSamePC.add(temp.Precert_class__c);
                    }
                }
                qlJuncDel = crdPLQAST.CRD_Quantity_Limit_Jucntion__r;
                if((qlJuncDel!= Null && qlJuncDel.size()>0 && deleteQuantityList) || currentRecord.Formulary_Group__c==NULLLABEL || 
                                                                 currentRecord.Formulary_Group__c==Null){             
                    Database.delete (qlJuncDel,false);
                } else {
                    for(CRD_Quantity_Limit_Junction__c temp : crdPLQAST.CRD_Quantity_Limit_Jucntion__r){
                        lstToAvoidSameQL.add(temp.QL_Class__c);
                    }
                }
                
                 //Below If condition by Sushant for Formulary Logic for 'LG Premier Plus' --> Commented again
                //if(currentrecord.Formulary_Group__c != 'LG Premier Plus'){
                    stJuncDel = crdPLQAST.CRD_Step_Therapy_Junction__r ;
                    if((stJuncDel!= Null && stJuncDel.size()>0 && deleteSTList) || currentRecord.Formulary_Group__c==NULLLABEL ||
                                                                  currentRecord.Formulary_Group__c==Null){             
                        Database.delete (stJuncDel,false);
                    }
                 // }
            }
            //Logic to create New Junction Records for ST/PA/QL
            Map<String,ID> mapdlName2Id = new map<String,ID>();
            CRD_PriorAuth_Junction__c newPriorAuthRecord = new CRD_PriorAuth_Junction__c();
            CRD_Quantity_Limit_Junction__c newQuantityLimitRecord = new CRD_Quantity_Limit_Junction__c();
            CRD_Step_Therapy_Junction__c newStepTherapyRecord = new CRD_Step_Therapy_Junction__c();
            List<CRD_PriorAuth_Junction__c> createPrecertRecords = new List<CRD_PriorAuth_Junction__c>();
            List<CRD_Quantity_Limit_Junction__c> createQLRecords = new List<CRD_Quantity_Limit_Junction__c>();
            List<CRD_Step_Therapy_Junction__c> createSTRecords = new List<CRD_Step_Therapy_Junction__c>();
            if(processJunctionRecords){
            //Added by Amit for Request 6037, ST# 312 on 16 Sep, 2015
            if(LGPREMIER.equalsIgnoreCase(currentRecord.Formulary_Group__c) && crdPLQAST.Precert_TOC_days__c > 1 ){            
                    dlPrecert.add(PRECERTTOCDL);
            }   
            for(Drug_List__c dlrecord: [Select Id,Name 
                                            from Drug_List__c 
                                            where Name =: dlPrecert OR Name =: dlStepTherapy 
                                                    OR Name =: dlQuantityLimit OR Name =:prSafetyEdit 
                                                    OR Name = :qlSafetyEdit limit 10000]){
                mapdlName2Id.put(dlrecord.Name, dlrecord.id );
            }
            //Step 4 – If Step 2 is executed then create new ST/PA/QL records with DLs added in Step 2 ONLY IF “Do you want to do Precert” is Yes.
            //Create PriorAuth Records only if Is There Precert is 'Yes'
                if(YESLABEL.equalsIgnoreCase(crdRecord.Do_you_want_to_do_Precert__c) 
                        && (!LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c) && !SHPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c))){
                    for(String PrecertRecord : dlPrecert){
                        newPriorAuthRecord = new CRD_PriorAuth_Junction__c();
                        newPriorAuthRecord.CRD_ID__c = currentRecord.CRD_ID__c;
                        newPriorAuthRecord.IsAutoPopulated__c = True;
                        newPriorAuthRecord.Precert_Class__c = mapdlName2Id.get(PrecertRecord);
                        if(!lstToAvoidSamePC.contains(mapdlName2Id.get(PrecertRecord))){
                            createPrecertRecords.add(newPriorAuthRecord);
                            lstToAvoidSamePC.add(mapdlName2Id.get(PrecertRecord));
                        }
                        crdRecord.Standard_Precert_List_or_Select_Classes__c = PADRUGLIST;
                    }
                }   
                for(String PrecertRecord : prSafetyEdit){
                    newPriorAuthRecord = new CRD_PriorAuth_Junction__c();
                    newPriorAuthRecord.CRD_ID__c = currentRecord.CRD_ID__c;
                    newPriorAuthRecord.IsAutoPopulated__c = True;
                    newPriorAuthRecord.Precert_Class__c = mapdlName2Id.get(PrecertRecord);
                    if(!lstToAvoidSamePC.contains(mapdlName2Id.get(PrecertRecord))){
                        createPrecertRecords.add(newPriorAuthRecord);
                        lstToAvoidSamePC.add(mapdlName2Id.get(PrecertRecord));
                    }
                    crdRecord.Standard_Precert_List_or_Select_Classes__c = PADRUGLIST;
                }
                //Richa added below code which deletes all the standard safety edit junction records if it enters the FormularyX logic - ST#513
                list<CRD_Standard_Safety_Edit_Junction__c> deleteStndSafetyJunc = new list <CRD_Standard_Safety_Edit_Junction__c>();
                for(CRD_Standard_Safety_Edit_Junction__c tempStndSafety : [Select id,Select__c 
                                                                            from 
                                                                                CRD_Standard_Safety_Edit_Junction__c 
                                                                            where Drug_Group__c != null and Select__c = true 
                                                                                    and CRDID__c = :currentRecord.CRD_ID__c limit 1000]){
                    tempStndSafety.select__c = False;
                    deleteStndSafetyJunc.add(tempStndSafety);
                }
                if(deleteStndSafetyJunc.size() > 0){
                    Database.update(deleteStndSafetyJunc,false);
                }
                //Create QuantityLimit Records only if Is There Precert is 'Yes' and not checking Are there quanity Limits?. This is as per the design template provided
                if(YESLABEL.equalsIgnoreCase(crdRecord.Do_you_want_to_do_Precert__c) 
                        && (!LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c) && !SHPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c))){
                    for(String QLRecord : dlQuantityLimit){
                        newQuantityLimitRecord = new CRD_Quantity_Limit_Junction__c();
                        newQuantityLimitRecord.CRD_ID__c = currentRecord.CRD_ID__c;
                        newQuantityLimitRecord.IsAutoPopulated__c = True;
                        newQuantityLimitRecord.QL_Class__c = mapdlName2Id.get(QLRecord);
                        if(!lstToAvoidSameQL.contains(mapdlName2Id.get(QLRecord))){
                            createQLRecords.add(newQuantityLimitRecord);
                            lstToAvoidSameQL.add(mapdlName2Id.get(QLRecord));
                        }
                        
                        crdRecord.Standard_QL_List_or_Select_Classes__c = QLDRUGLIST;
                    }
                }
                if(!(LGPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c) && !SHPREMIERPLUS.equalsIgnoreCase(currentRecord.Formulary_Group__c)
                        && YESLABEL.equalsIgnoreCase(crdRecord.Do_you_want_to_do_Precert__c))){
                    for(String QLRecord : qlSafetyEdit){
                        newQuantityLimitRecord = new CRD_Quantity_Limit_Junction__c();
                        newQuantityLimitRecord.CRD_ID__c = currentRecord.CRD_ID__c;
                        newQuantityLimitRecord.IsAutoPopulated__c = True;
                        newQuantityLimitRecord.QL_Class__c = mapdlName2Id.get(QLRecord);
                        if(!lstToAvoidSameQL.contains(mapdlName2Id.get(QLRecord))){
                            createQLRecords.add(newQuantityLimitRecord);
                            lstToAvoidSameQL.add(mapdlName2Id.get(QLRecord));
                        }
                        //createQLRecords.add(newQuantityLimitRecord);
                        crdRecord.Standard_QL_List_or_Select_Classes__c = QLDRUGLIST;
                    }
                }
                //Create Step Therapy Records only if Is there Step Therapy is 'Yes'
                if(YESLABEL.equalsIgnoreCase(crdRecord.Do_you_want_to_do_Step_Therapy__c)){
                //Below If condition by Sushant for Formulary Logic for 'LG Premier Plus' --> commented again
               // if(currentrecord.Formulary_Group__c != 'LG Premier Plus'){
                    for(String STRecord : dlStepTherapy){
                        newStepTherapyRecord = new CRD_Step_Therapy_Junction__c();
                        newStepTherapyRecord.CRD_ID__c = currentRecord.CRD_ID__c;
                        newStepTherapyRecord.IsAutoPopulated__c = True;
                        newStepTherapyRecord.Step_Therapy_DrugList_Class__c = mapdlName2Id.get(STRecord);
                        createSTRecords.add(newStepTherapyRecord);
                        crdRecord.Standard_Program_or_Select_Classes__c = STDRUGLIST;
                    }
                   // }
                }
            } 
            //Step 5 – If Commercial Formulary then create records from ST PA QL Auto Populate object.
            if(currentRecord.Formulary_Group__c ==NULLLABEL || currentRecord.Formulary_Group__c == Null){
                for(ST_PA_QL_Auto_Populate__c stObjList: [Select Id,Contract_State__c,Drug_List__c,Drug_List__r.name,
                                                            Drug_List__r.Drug_List_Name__c,Drug_List__r.Description__c,
                                                            Record_Type__c,What_is_the_Funding_Type__c 
                                                            From ST_PA_QL_Auto_Populate__c limit 10000]){               
                   if(YESLABEL.equalsIgnoreCase(crdRecord.Do_you_want_to_do_Step_Therapy__c) && 
                                                STEPTHERAPY.equalsIgnoreCase(stObjList.Record_Type__c) && 
                                                stObjList.What_is_the_Funding_Type__c.CONTAINS(crdRecord.Insured_Type__c) && 
                                                stObjList.Contract_State__c.CONTAINS(crdRecord.Contract_State__c)){
                       newStepTherapyRecord = new CRD_Step_Therapy_Junction__c();
                       newStepTherapyRecord.Isautopopulated__c = True;
                       newStepTherapyRecord.CRD_ID__c =crdRecord.id;
                       newStepTherapyRecord.Step_Therapy_DrugList_Class__c = stObjList.Drug_List__c;
                       createSTRecords.add(newStepTherapyRecord);
                       crdRecord.Standard_Program_or_Select_Classes__c = STDRUGLIST;
                   }
                   
                   if(YESLABEL.equalsIgnoreCase(crdRecord.Do_you_want_to_do_Precert__c) && 
                            PRECERT.equalsIgnoreCase(stObjList.Record_Type__c) && 
                            stObjList.What_is_the_Funding_Type__c.CONTAINS(crdRecord.Insured_Type__c) && 
                            stObjList.Contract_State__c.CONTAINS(crdRecord.Contract_State__c)){
                       newPriorAuthRecord = new CRD_PriorAuth_Junction__c ();
                       newPriorAuthRecord.Isautopopulated__c = True;
                       newPriorAuthRecord.CRD_ID__c =crdRecord.id;
                       newPriorAuthRecord.Precert_Class__c= stObjList.Drug_List__c;
                       createPrecertRecords.add(newPriorAuthRecord );
                       crdRecord.Standard_Precert_List_or_Select_Classes__c = PADRUGLIST;
                   }
                   
                   if(YESLABEL.equalsIgnoreCase(crdRecord.Are_there_Quantity_Limits__c) && 
                                    QUANTITYLIMIT.equalsIgnoreCase(stObjList.Record_Type__c) && 
                                    stObjList.What_is_the_Funding_Type__c.CONTAINS(crdRecord.Insured_Type__c) && 
                                    stObjList.Contract_State__c.CONTAINS(crdRecord.Contract_State__c)){
                       newQuantityLimitRecord = new CRD_Quantity_Limit_Junction__c ();
                       newQuantityLimitRecord.Isautopopulated__c = True;
                       newQuantityLimitRecord.CRD_ID__c =crdRecord.id;
                       newQuantityLimitRecord.QL_Class__c= stObjList.Drug_List__c;
                       createQLRecords.add(newQuantityLimitRecord);
                       crdRecord.Standard_QL_List_or_Select_Classes__c = QLDRUGLIST;
                   }
               
                }
            }
            
            Database.update (crdRecord,false);
            //Create Records
            if(createPrecertRecords!= Null && createPrecertRecords.size() >0){
                Database.insert (createPrecertRecords,false);
            }
            if(createQLRecords!= Null && createQLRecords.size() >0){
                Database.insert (createQLRecords,false);
            }
            if(createSTRecords!= Null && createSTRecords.size() >0){
                Database.insert (createSTRecords,false);
            } 
          //Ends
        }catch (exception e){ throw e;}
    } 
}