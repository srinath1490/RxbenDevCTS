/*Purpose: Apex Class to Auto Populate the DCDL found from DC Drug Class Using Froup of Formulary on Drug Coverage Records
========================================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE                          DETAIL                                 
   1.0         Amit Jain        19 Feb, 2015      Apex Class to Auto Populate the DCDL found from DC Drug Class Using Froup of Formulary on Drug Coverage Records
   1.1        Sushant Sethi    21 Sep,2016        Modified Logic in accordance to request 6661

======================================================================== */
public with sharing class CB_DCDLLogic {
    public void mapDCDLtoDrugCoverage(  map<ID,String> DCwithRecordType,map<ID,String> DCwithFormulryGrp, Map<ID,Boolean> DCwithAutomatedFlag){
        GC_Utils_Method utilinstance = new GC_Utils_Method();
        Set<ID> DLorDGwithDGMail = new Set<ID>();    //Request 6661
        Set<ID> DLorDGwithDGRetail = new Set<ID>();  //Request 6661
        Map<Id,String> DC2FormularyGroup = new Map<Id,String>();
        DC2FormularyGroup.putall(DCwithFormulryGrp);
        DC_Drug_List_Group__c newdcdlRecord;
        List<DC_Drug_List_Group__c> createDCDL = new List<DC_Drug_List_Group__c>();
        //Fetch DCDL records related to Drug Coverage
        for(DC_Drug_List_Group__c dcdlRecord: [Select Id, Name,Drug_Class_Name__c,Drug_Group__c,Drug_List__c,Is_Automated__c,Related_Drug_Coverage__c
                                                            ,Related_Drug_Coverage__r.recordtype.name,Related_Drug_Coverage__r.Formulary_Group__c,Related_Drug_Coverage__r.Formulary__c
                                                From 
                                                   DC_Drug_List_Group__c
                                                Where
                                                Related_Drug_Coverage__c =: DCwithRecordType.keyset()]){
                      if(dcdlRecord.Related_Drug_Coverage__r.Formulary_Group__c!= Null && dcdlRecord.Related_Drug_Coverage__r.Formulary_Group__c!= ''){
                        DC2FormularyGroup.put(dcdlRecord.Related_Drug_Coverage__c,dcdlRecord.Related_Drug_Coverage__r.Formulary_Group__c);
                      }
                      //Add DrugGroup/DrugList for Mail/Retail Drug Coverage -- Modified for Request 6661
                      if(dcdlRecord.Drug_Group__c!= Null && dcdlRecord.Drug_List__c== Null && dcdlRecord.Related_Drug_Coverage__r.recordtype.name != NULL){
                          if((dcdlRecord.Related_Drug_Coverage__r.recordtype.name == 'Mail')){
                                    DLorDGwithDGMail.add(dcdlRecord.Drug_Group__c);
                                }else if((dcdlRecord.Related_Drug_Coverage__r.recordtype.name == 'Retail')){
                                    DLorDGwithDGRetail.add(dcdlRecord.Drug_Group__c);
                                }
                        
                      }else if(dcdlRecord.Drug_Group__c== Null && dcdlRecord.Drug_List__c!= Null && dcdlRecord.Related_Drug_Coverage__r.recordtype.name != NULL){
                       if(dcdlRecord.Related_Drug_Coverage__r.recordtype.name == 'Mail'){
                                DLorDGwithDGMail.add(dcdlRecord.Drug_List__c);
                            } 
                        else if(dcdlRecord.Related_Drug_Coverage__r.recordtype.name == 'Retail'){
                                DLorDGwithDGRetail.add(dcdlRecord.Drug_List__c);
                            }
                      }  
                       
        }
        if(DCwithRecordType!= Null){    
            for(DC_Drug_Class__c dcDrugClassRecord: [Select Id,Name,Drug_Group__c,Drug_List__c,Mandatory__c, For_Mail_Drug_Coverage__c, For_Retail_Drug_Coverage__c, Group__c
                                                    ,Inclusion_Exclusion__c,Apply_Limitations__c,Quantity_Over_Time_Quantity__c,Quantity_Over_Time_Time_Period__c
                                                    ,Quantity_Over_Time_Time_Value__c,Start_Age__c,Start_Age_Type__c,Bypass_M__c
                                              From
                                                DC_Drug_Class__c
                                              Where
                                                For_Mail_Drug_Coverage__c = True OR For_Retail_Drug_Coverage__c = True]){
                          for(ID drugRecord: DCwithRecordType.keyset()){                
                            //Check For Mail Drug Coverage -- Modified for Request 6661
                            if(DCwithRecordType.get(drugRecord)== 'Mail' && dcDrugClassRecord.For_Mail_Drug_Coverage__c 
                                && ((DC2FormularyGroup.get(drugRecord)!= Null && DC2FormularyGroup.get(drugRecord)!= '' && dcDrugClassRecord.Group__c!= Null 
                                        && dcDrugClassRecord.Group__c.contains(DC2FormularyGroup.get(drugRecord))!= Null && utilinstance.compareWithMultiSelect(dcDrugClassRecord.Group__c,DC2FormularyGroup.get(drugRecord)))
                                    ||(DC2FormularyGroup.get(drugRecord)== Null && dcDrugClassRecord.Mandatory__c == 'Yes'))){
                                if(!DLorDGwithDGMail.contains(dcDrugClassRecord.Drug_List__c) && dcDrugClassRecord.Drug_List__c!= Null){
                                    newdcdlRecord = new DC_Drug_List_Group__c();
                                    newdcdlRecord.Inclusion_Exclusion__c = dcDrugClassRecord.Inclusion_Exclusion__c;
                                    newdcdlRecord.Drug_List__c = dcDrugClassRecord.Drug_List__c;
                                    newdcdlRecord.Related_Drug_Coverage__c = drugRecord;
                                    newdcdlRecord.Apply_Limitations__c = dcDrugClassRecord.Apply_Limitations__c;
                                    newdcdlRecord.Quantity_Over_Time_Quantity__c = dcDrugClassRecord.Quantity_Over_Time_Quantity__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Period__c = dcDrugClassRecord.Quantity_Over_Time_Time_Period__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Value__c = dcDrugClassRecord.Quantity_Over_Time_Time_Value__c;
                                    newdcdlRecord.Start_Age__c = dcDrugClassRecord.Start_Age__c;
                                    newdcdlRecord.Start_Age_Type__c = dcDrugClassRecord.Start_Age_Type__c;
                                    newdcdlRecord.Bypass_MOOP__c = dcDrugClassRecord.Bypass_M__c;
                                    createDCDL.add(newdcdlRecord);
                                }else if(!DLorDGwithDGMail.contains(dcDrugClassRecord.Drug_Group__c) && dcDrugClassRecord.Drug_Group__c!= Null){
                                    newdcdlRecord = new DC_Drug_List_Group__c();
                                    newdcdlRecord.Inclusion_Exclusion__c = dcDrugClassRecord.Inclusion_Exclusion__c;
                                    newdcdlRecord.Drug_Group__c = dcDrugClassRecord.Drug_Group__c;
                                    newdcdlRecord.Related_Drug_Coverage__c = drugRecord;
                                    newdcdlRecord.Apply_Limitations__c = dcDrugClassRecord.Apply_Limitations__c;
                                    newdcdlRecord.Quantity_Over_Time_Quantity__c = dcDrugClassRecord.Quantity_Over_Time_Quantity__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Period__c = dcDrugClassRecord.Quantity_Over_Time_Time_Period__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Value__c = dcDrugClassRecord.Quantity_Over_Time_Time_Value__c;
                                    newdcdlRecord.Start_Age__c = dcDrugClassRecord.Start_Age__c;
                                    newdcdlRecord.Start_Age_Type__c = dcDrugClassRecord.Start_Age_Type__c;
                                    newdcdlRecord.Bypass_MOOP__c = dcDrugClassRecord.Bypass_M__c;
                                    createDCDL.add(newdcdlRecord);                                  
                                }
                            }
                            //Check For Retail Drug Coverage -- Modified for Request 6661
                            
                            if(DCwithRecordType.get(drugRecord)== 'Retail' && dcDrugClassRecord.For_Retail_Drug_Coverage__c 
                                && ((DC2FormularyGroup.get(drugRecord)!= Null && DC2FormularyGroup.get(drugRecord)!= '' && dcDrugClassRecord.Group__c!= Null 
                                        && dcDrugClassRecord.Group__c.contains(DC2FormularyGroup.get(drugRecord))!= Null && utilinstance.compareWithMultiSelect(dcDrugClassRecord.Group__c,DC2FormularyGroup.get(drugRecord))) 
                                    ||(DC2FormularyGroup.get(drugRecord)== Null && dcDrugClassRecord.Mandatory__c == 'Yes'))){
                                if(!DLorDGwithDGRetail.contains(dcDrugClassRecord.Drug_List__c) && dcDrugClassRecord.Drug_List__c!= Null){
                                    newdcdlRecord = new DC_Drug_List_Group__c();
                                    newdcdlRecord.Inclusion_Exclusion__c = dcDrugClassRecord.Inclusion_Exclusion__c;
                                    newdcdlRecord.Drug_List__c = dcDrugClassRecord.Drug_List__c;
                                    newdcdlRecord.Related_Drug_Coverage__c = drugRecord;
                                    newdcdlRecord.Apply_Limitations__c = dcDrugClassRecord.Apply_Limitations__c;
                                    newdcdlRecord.Quantity_Over_Time_Quantity__c = dcDrugClassRecord.Quantity_Over_Time_Quantity__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Period__c = dcDrugClassRecord.Quantity_Over_Time_Time_Period__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Value__c = dcDrugClassRecord.Quantity_Over_Time_Time_Value__c;
                                    newdcdlRecord.Start_Age__c = dcDrugClassRecord.Start_Age__c;
                                    newdcdlRecord.Start_Age_Type__c = dcDrugClassRecord.Start_Age_Type__c;
                                    newdcdlRecord.Bypass_MOOP__c = dcDrugClassRecord.Bypass_M__c;
                                    createDCDL.add(newdcdlRecord);                                  
                                }else if(!DLorDGwithDGRetail.contains(dcDrugClassRecord.Drug_Group__c) && dcDrugClassRecord.Drug_Group__c!= Null){
                                    newdcdlRecord = new DC_Drug_List_Group__c();
                                    newdcdlRecord.Inclusion_Exclusion__c = dcDrugClassRecord.Inclusion_Exclusion__c;
                                    newdcdlRecord.Drug_Group__c = dcDrugClassRecord.Drug_Group__c;
                                    newdcdlRecord.Related_Drug_Coverage__c = drugRecord;
                                    newdcdlRecord.Apply_Limitations__c = dcDrugClassRecord.Apply_Limitations__c;
                                    newdcdlRecord.Quantity_Over_Time_Quantity__c = dcDrugClassRecord.Quantity_Over_Time_Quantity__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Period__c = dcDrugClassRecord.Quantity_Over_Time_Time_Period__c;
                                    newdcdlRecord.Quantity_Over_Time_Time_Value__c = dcDrugClassRecord.Quantity_Over_Time_Time_Value__c;
                                    newdcdlRecord.Start_Age__c = dcDrugClassRecord.Start_Age__c;
                                    newdcdlRecord.Start_Age_Type__c = dcDrugClassRecord.Start_Age_Type__c;
                                    newdcdlRecord.Bypass_MOOP__c = dcDrugClassRecord.Bypass_M__c;
                                    createDCDL.add(newdcdlRecord);                                  
                                }
                            }
                          }
                          // Add the DrugGroup/DrugList for comparison for Mail/Retail Drug Coverage records -- Modified for Request 6661
                          if(dcDrugClassRecord.Drug_List__c!= Null){
                                DLorDGwithDGMail.add(dcDrugClassRecord.Drug_List__c);
                                DLorDGwithDGRetail.add(dcDrugClassRecord.Drug_List__c);
                                
                          }else if(dcDrugClassRecord.Drug_Group__c!= Null){
                                DLorDGwithDGMail.add(dcDrugClassRecord.Drug_Group__c);
                                DLorDGwithDGRetail.add(dcDrugClassRecord.Drug_Group__c);
                        }
             }
             if(createDCDL!= Null && createDCDL.size()> 0 ){
              insert createDCDL;
             }
        }
    }
}