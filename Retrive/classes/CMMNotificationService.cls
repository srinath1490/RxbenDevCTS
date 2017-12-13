/**
*Purpose: Webservice Class for CMM Integration.                                         
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR                DATE            DETAIL                                 
*  1.0           Vikram                9/29/2015       Webservice Class for CMM Integration
*  1.1           Vikram                12/4/2015       Request 06260 : Additional Infertility fields for CMM output
*  1.2           Richa                 3/21/2016       Request 6428 : ST 810 Additional Status Checks for Active CRDs in CMM process
-*======================================================================== 
**/ 

global class CMMNotificationService{

    private static final String RECORDTYPERETAIL = 'Retail';
    private static final String RECORDTYPEMAIL = 'Mail';
    private static final String NATIONAL = 'Individual';
    private static final String ACCOUNT =  'IVL Public Exchange';
    private static final String IVLMEMBERYES = 'Yes';
    private static final String IVLMEMBERNO = 'No';
    private static final String CRDSTATUS1 = 'In Progress';
    private static final String CRDSTATUS2 = 'On Hold';
    private static final String EXCLUDE = 'Exclude';
    private static final String FERTILITYINJYES =  'Yes';
    private static final String FERTILITYINJNO =  'No';
    private static final String FERTILITYORALYES =  'Yes';
    private static final String FERTILITYORALNO =  'No';
    private static final String ERR001 = 'Err001';
    private static final String ERR002 = 'Err002';
    private static final String ERR003 = 'Err003';
    private static final String ERR004 = 'Err004';
    private static final String ERR005 = 'Err005';
    private static final String DESC01 = 'No benefits found for this member';
    private static final String DESC02 = 'Missing required information{ Control:  / Plan Summary: / Effective Date :  / Request Type:}';
    private static final String DOYOUHAVESPECIALTYYES = 'Yes';
    

//Output class    

    global class CMMNotication{
      webservice String forceToSpecialty;
      webservice String aetnaSpecialtyCareRx;
      webservice Integer noOfFillsBeforeForceToSpecialty;
      webservice String iVLMember;
      webservice String errorDescription;
      webservice String errorCode;
      webservice String status;
      
      webservice FertilityBenefitInj fertilityBenefitInj = new FertilityBenefitInj();
      webservice FertilityBenefitOral fertilityBenefitOral = new FertilityBenefitOral();
    
   }
   
    global class FertilityBenefitInj{
          webservice String fertilityInj;      
          webservice String drugListInj;
          webservice String relatedDrugCoverageNameInj;
          webservice String inclusionExclusionDrugClassInj;
          webservice String drugListNameInj;
      
    }
   
    global class FertilityBenefitOral{
          webservice String fertilityOral;      
          webservice String drugListOral;
          webservice String relatedDrugCoverageNameOral;
          webservice String inclusionExclusionDrugClassOral;
          webservice String drugListNameOral;
      
    }
   
        

// Webservice Method 

    webService static CMMNotication getBenefitDetails(String plan, Integer control, Date effectiveDate, String requestType) {
        
        Map<String,String> errorCodeMap = new Map<String,String>{ERR001 =>DESC01, ERR002 =>DESC01 ,ERR003 =>DESC01 ,ERR004 =>DESC01 ,ERR005 =>DESC02};
        string control0 = string.valueof(control);
        string control1 = GC_Utils_Method.calculateControl(control0);
        System.debug('>>>>>'+control1);
        CMMNotication cmm = new CMMNotication();
        
        IntegrationLogger logger = new IntegrationLogger();
        logger.initialiseLogCMM('CMM Notification log', 'Checkpoint 0: Init', 'Plan:'+plan+', Control:'+control+', Effective Date:'+effectiveDate+', Request Type:'+requestType);
        
        
        If ( String.isBlank(plan) || control == null || effectiveDate == null || String.isBlank(requestType)){
            cmm.errorCode = ERR005 ;
            cmm.errorDescription = errorCodeMap.get(ERR005);
            logger.finalLogCMM('CMM Notification log', 'Checkpoint Output: Error sent', 'errorCode:'+cmm.errorCode +', errorDescription:'+cmm.errorDescription);
            return cmm;
        }
        else{
        
            logger.logCMMState('Checkpoint 1: Valid Params received');
        
            try {
        
                list<Partial_Control_Group__c> pcg = new list<Partial_Control_Group__c>();
                pcg = [SELECT Id FROM Partial_Control_Group__c WHERE CSAP_Control_ID__c =: control1 AND CSAP_Plan_ID__c =: plan LIMIT 1000];
                
                List <CSAP_CGLP_Junction__c> cs = new List <CSAP_CGLP_Junction__c>();
          
                if (pcg != null && pcg.size() > 0){
                    logger.logCMMState('Checkpoint 2: pcg found');
                    cs = [SELECT CRD__c,Id FROM CSAP_CGLP_Junction__c WHERE Partial_Control_Group__c =: pcg[0].id LIMIT 1000];
        
                List<CRD__c> crd = new List<CRD__c>();
                set<id> crdId = new set<id>();
                if (cs != null && cs.size() > 0){
                    logger.logCMMState('Checkpoint 3: CSAP found');
                    
                    for(CSAP_CGLP_Junction__c cs1 : cs){
                        CRDId.add(cs1.CRD__c);
                    }
                
                    //Richa added 3 additional status checks for Req 6428 in the below query
                    crd = [SELECT Id, CreatedDate FROM CRD__c WHERE Id IN: crdId AND Effective_Start_Date__c=: effectiveDate AND Status__c != 'In Progress' AND Status__c != 'On Hold' AND Status__c != 'On Hold for Future Use' AND Status__c != 'Holding - Interim State' AND Status__c != 'Awaiting Aetna Approval' AND Archived__c != True LIMIT 1000];
                    
                    if (crd != null && crd.size() > 0){
                        logger.logCMMState('Checkpoint 4: Active CRD found');
                        
                        CRD__c currentCRD;
                        Integer size = crd.size();
                        If ( size > 1){
                            currentCRD = crd[0];
                            for (CRD__c c : crd){
                                If (c.CreatedDate > currentCRD.CreatedDate) {
                                    currentCRD = c;
                                }
                            }
                        }
                        else{
                            currentCRD = crd[0];
                        }
                
                        CMMNotificationService cmmn = new CMMNotificationService();
                        cmm = cmmn.formatOutput(currentCRD);
                        logger.finalLogCMM('CMM Notification log', 'Checkpoint Output: Valid Output sent', 'forceToSpecialty:'+cmm.forceToSpecialty+', aetnaSpecialtyCareRx:'+cmm.aetnaSpecialtyCareRx+', noOfFillsBeforeForceToSpecialty:'+cmm.noOfFillsBeforeForceToSpecialty+', iVLMember:'+cmm.iVLMember+', fertilityInj:'+cmm.fertilityBenefitInj.fertilityInj+', fertilityOral:'+cmm.fertilityBenefitOral.fertilityOral);
                
                    }
                    else{
                        cmm.errorCode = ERR001 ;
                        cmm.errorDescription = errorCodeMap.get(ERR001);
                        cmm.forceToSpecialty = '';
                        cmm.aetnaSpecialtyCareRx = '';
                        cmm.noOfFillsBeforeForceToSpecialty = null;
                        cmm.iVLMember ='';
                        cmm.fertilityBenefitOral.fertilityOral = '';
                        cmm.fertilityBenefitOral.drugListOral = '' ;
                        cmm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                        cmm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                        cmm.fertilityBenefitOral.drugListNameOral = '' ;
                        cmm.fertilityBenefitInj.fertilityInj = '';
                        cmm.fertilityBenefitInj.drugListInj = '' ;
                        cmm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                        cmm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                        cmm.fertilityBenefitInj.drugListNameInj = '' ;
                        logger.finalLogCMM('CMM Notification log', 'Checkpoint Output: Error sent', 'errorCode:'+cmm.errorCode +', errorDescription:'+cmm.errorDescription);
            
                    }       
                }
               }
                List<ControlPlanRxPlan__c> cprp = new List<ControlPlanRxPlan__c>();
        
                if (pcg.isEmpty() || cs.isEmpty()){
                    
                    logger.logCMMState('Checkpoint 5: pcg or CSAP not found');
                    cprp = [SELECT Id, CRD__c, Name FROM ControlPlanRxPlan__c WHERE Control__c =: control0 AND Plan__c =: plan LIMIT 1000];
            
                    ControlPlanRxPlan__c highcp ;
                    If (cprp != null && cprp.size() > 0){
                        logger.logCMMState('Checkpoint 6: TradPkgControlPlanLookup found');
                        Integer size1 = cprp.size();
                        highcp = cprp[0];
                        If ( size1 > 1){
                
                            for (ControlPlanRxPlan__c c : cprp){
                                If (c.Name > highcp.Name) {
                                highcp = c;
                                }
                            }
                            system.debug('Highest ControlPlanRxPlanName'+highcp);
                        }
                        
                        List<CRD__c> crd2 = new List<CRD__c>();
                        crd2 = [SELECT Id FROM CRD__c WHERE Id =: highcp.CRD__c];
                    
                        if (crd2.isEmpty()){
                            cmm.errorCode = ERR003 ;
                            cmm.errorDescription = errorCodeMap.get(ERR003);
                            cmm.forceToSpecialty = '';
                            cmm.aetnaSpecialtyCareRx = '';
                            cmm.noOfFillsBeforeForceToSpecialty = null;
                            cmm.iVLMember ='';
                            cmm.fertilityBenefitOral.fertilityOral = '';
                            cmm.fertilityBenefitOral.drugListOral = '' ;
                            cmm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                            cmm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                            cmm.fertilityBenefitOral.drugListNameOral = '' ;
                            cmm.fertilityBenefitInj.fertilityInj = '';
                            cmm.fertilityBenefitInj.drugListInj = '' ;
                            cmm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                            cmm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                            cmm.fertilityBenefitInj.drugListNameInj = '' ;
                            logger.finalLogCMM('CMM Notification log', 'Checkpoint Output: Error sent', 'errorCode:'+cmm.errorCode +', errorDescription:'+cmm.errorDescription);
            
                        }  
                        else{
                            List<CRD__c> crd1 = new List<CRD__c>();
                             //Richa added 3 additional status checks for Req 6428 in the below query
                            crd1 = [SELECT Id FROM CRD__c WHERE Id =: highcp.CRD__c AND Status__c != 'In Progress' AND Status__c != 'On Hold' AND Status__c != 'On Hold for Future Use' AND Status__c != 'Holding - Interim State' AND Status__c != 'Awaiting Aetna Approval' AND Archived__c != True LIMIT 1000];
            
                            if (crd1.size() > 0){
                                logger.logCMMState('Checkpoint 7: Active CRD found');
                                CMMNotificationService cmmn = new CMMNotificationService();
                                cmm = cmmn.formatOutput(crd1[0]);
                                logger.finalLogCMM('CMM Notification log', 'Checkpoint Output: Valid Output sent', 'forceToSpecialty:'+cmm.forceToSpecialty+', aetnaSpecialtyCareRx:'+cmm.aetnaSpecialtyCareRx+', noOfFillsBeforeForceToSpecialty:'+cmm.noOfFillsBeforeForceToSpecialty+', iVLMember:'+cmm.iVLMember+', fertilityInj:'+cmm.fertilityBenefitInj.fertilityInj+', fertilityOral:'+cmm.fertilityBenefitOral.fertilityOral);
                
                            }
                            else{
                                cmm.errorCode = ERR004 ;
                                cmm.errorDescription = errorCodeMap.get(ERR004);
                                cmm.forceToSpecialty = '';
                                cmm.aetnaSpecialtyCareRx = '';
                                cmm.noOfFillsBeforeForceToSpecialty = null;
                                cmm.iVLMember ='';
                                cmm.fertilityBenefitOral.fertilityOral = '';
                                cmm.fertilityBenefitOral.drugListOral = '' ;
                                cmm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                                cmm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                                cmm.fertilityBenefitOral.drugListNameOral = '' ;
                                cmm.fertilityBenefitInj.fertilityInj = '';
                                cmm.fertilityBenefitInj.drugListInj = '' ;
                                cmm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                                cmm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                                cmm.fertilityBenefitInj.drugListNameInj = '' ;
                                logger.finalLogCMM('CMM Notification log', 'Checkpoint Output: Error sent', 'errorCode:'+cmm.errorCode +', errorDescription:'+cmm.errorDescription);
            
                            }
                        }
                    }
                    else{
                        cmm.errorCode = ERR002 ;
                        cmm.errorDescription = errorCodeMap.get(ERR002);
                        cmm.forceToSpecialty = '';
                        cmm.aetnaSpecialtyCareRx = '';
                        cmm.noOfFillsBeforeForceToSpecialty = null;
                        cmm.iVLMember ='';
                        cmm.fertilityBenefitOral.fertilityOral = '';
                        cmm.fertilityBenefitOral.drugListOral = '' ;
                        cmm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                        cmm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                        cmm.fertilityBenefitOral.drugListNameOral = '' ;
                        cmm.fertilityBenefitInj.fertilityInj = '';
                        cmm.fertilityBenefitInj.drugListInj = '' ;
                        cmm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                        cmm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                        cmm.fertilityBenefitInj.drugListNameInj = '' ;
                        logger.finalLogCMM('CMM Notification log', 'Checkpoint Output: Error sent', 'errorCode:'+cmm.errorCode +', errorDescription:'+cmm.errorDescription);
            
                    }
                    
                    
            
            
                }
        
        
                return cmm;
             }
             
             catch(Exception e){
                 Integer i = e.getLineNumber();
                 string s = string.valueof(i);
                 logger.logCMMError(True, 'CMM Notification log',e.getMessage()+', Line:'+i, 'Exception');
                 return null;   
             }
        
             Finally
             {
                 logger.logCMMCommit();
             }
        }
     }
    
// Format Output Parameters
    
    private CMMNotication formatOutput(CRD__c c){
    
            
            CMMNotication cm = new CMMNotication();
            
            List<Drug_Coverage__c> dc = new List <Drug_Coverage__c>();
            List<Drug_Coverage__c> dc1 = new List <Drug_Coverage__c>();
            
            Id dcId = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get(RECORDTYPERETAIL).RecordTypeId;
            Id dcId1 = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get(RECORDTYPEMAIL).RecordTypeId;
            
            dc = [SELECT Aetna_Specialty_Care_Rx__c,Force_to_Specialty__c,of_fills_before_force_to_specialty__c,Do_you_have_Specialty__c,Id FROM Drug_Coverage__c WHERE RecordTypeId =: dcId AND CRD_ID__c =: c.id LIMIT 1000];
            dc1 = [SELECT Id FROM Drug_Coverage__c WHERE RecordTypeId =: dcId1 AND CRD_ID__c =: c.id LIMIT 1000];
            
            If (dc != null && dc.size() > 0){
             //   logger.logCMMState('Checkpoint 8: Retail DC found');
                
                 If (dc[0].Do_you_have_Specialty__c != null && dc[0].Do_you_have_Specialty__c.equalsignorecase(DOYOUHAVESPECIALTYYES)){
                    cm.forceToSpecialty = dc[0].Force_to_Specialty__c;
                    cm.aetnaSpecialtyCareRx = dc[0].Aetna_Specialty_Care_Rx__c;
                    cm.noOfFillsBeforeForceToSpecialty = Integer.valueof(dc[0].of_fills_before_force_to_specialty__c);
                }
                else{
                    //error6
                    cm.forceToSpecialty = '';
                    cm.aetnaSpecialtyCareRx = '';
                    cm.noOfFillsBeforeForceToSpecialty = null;
                }
                
                List<DC_Drug_List_Group__c> dcdl = new List<DC_Drug_List_Group__c>();
                List<DC_Drug_List_Group__c> dcdl1 = new List<DC_Drug_List_Group__c>();
                List<DC_Drug_List_Group__c> dcdl2 = new List<DC_Drug_List_Group__c>();
                
                dcdl = [SELECT Id, Drug_List__c, Drug_List_Name__c, Inclusion_Exclusion__c, Related_Drug_Coverage_Name__c, Inclusion_Exclusion_Drug_Class__c, Drug_List__r.Name FROM DC_Drug_List_Group__c WHERE Related_Drug_Coverage__c =: dc[0].id AND (Drug_List__c =: System.Label.Drug_List_Fertility_Inj OR Drug_List__c =: System.Label.Drug_List_Fertility_oral) LIMIT 1000];
                dcdl1 = [SELECT Id, Drug_List__c, Drug_List_Name__c, Inclusion_Exclusion__c, Related_Drug_Coverage_Name__c, Inclusion_Exclusion_Drug_Class__c, Drug_List__r.Name FROM DC_Drug_List_Group__c WHERE Related_Drug_Coverage__c =: dc[0].id AND Drug_List__c =: System.Label.Drug_List_Fertility_Inj LIMIT 1000];
                dcdl2 = [SELECT Id, Drug_List__c, Drug_List_Name__c, Inclusion_Exclusion__c, Related_Drug_Coverage_Name__c, Inclusion_Exclusion_Drug_Class__c, Drug_List__r.Name FROM DC_Drug_List_Group__c WHERE Related_Drug_Coverage__c =: dc[0].id AND Drug_List__c =: System.Label.Drug_List_Fertility_oral LIMIT 1000];
                                
                
                if (dcdl != null && dcdl.size() > 0){
                     
                    if ( dcdl1 != null && dcdl1.size() > 0 ){
                            
                                if (dcdl1[0].Drug_List__c == System.Label.Drug_List_Fertility_Inj && dcdl1[0].Inclusion_Exclusion__c.equalsignorecase(EXCLUDE) ){
                                    cm.fertilityBenefitInj.fertilityInj = FERTILITYINJYES ;
                                    cm.fertilityBenefitInj.drugListInj = dcdl1[0].Drug_List__r.Name ;
                                    cm.fertilityBenefitInj.relatedDrugCoverageNameInj = dcdl1[0].Related_Drug_Coverage_Name__c ;
                                    cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = dcdl1[0].Inclusion_Exclusion_Drug_Class__c ;
                                    cm.fertilityBenefitInj.drugListNameInj = dcdl1[0].Drug_List_Name__c ;
                                }
                                else{
                                    cm.fertilityBenefitInj.fertilityInj = '';
                                    cm.fertilityBenefitInj.drugListInj = '' ;
                                    cm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                                    cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '' ;
                                    cm.fertilityBenefitInj.drugListNameInj = '' ;
                                }
                            }
                            else{
                                cm.fertilityBenefitInj.fertilityInj = '';
                                cm.fertilityBenefitInj.drugListInj = '' ;
                                cm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                                cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                                cm.fertilityBenefitInj.drugListNameInj = '' ;
                            }
                            
                            if ( dcdl2 != null && dcdl2.size() > 0 ){
                            
                                if (dcdl2[0].Drug_List__c == System.Label.Drug_List_Fertility_oral && dcdl2[0].Inclusion_Exclusion__c.equalsignorecase(EXCLUDE) ){
                                    cm.fertilityBenefitOral.fertilityOral = FERTILITYORALYES ;
                                    cm.fertilityBenefitOral.drugListOral = dcdl2[0].Drug_List__r.Name ;
                                    cm.fertilityBenefitOral.relatedDrugCoverageNameOral = dcdl2[0].Related_Drug_Coverage_Name__c ;
                                    cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = dcdl2[0].Inclusion_Exclusion_Drug_Class__c ;
                                    cm.fertilityBenefitOral.drugListNameOral = dcdl2[0].Drug_List_Name__c ;
                                }
                                else{
                                    cm.fertilityBenefitOral.fertilityOral = '';
                                    cm.fertilityBenefitOral.drugListOral = '' ;
                                    cm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                                    cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                                    cm.fertilityBenefitOral.drugListNameOral = '' ;
                                }
                            }
                            else{
                                cm.fertilityBenefitOral.fertilityOral = '';
                                cm.fertilityBenefitOral.drugListOral = '' ;
                                cm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                                cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                                cm.fertilityBenefitOral.drugListNameOral = '' ;
                            }
                            
                 }
                 else{
                     //error7
                     cm.fertilityBenefitOral.fertilityOral = '';
                     cm.fertilityBenefitOral.drugListOral = '' ;
                     cm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                     cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                     cm.fertilityBenefitOral.drugListNameOral = '' ;
                     cm.fertilityBenefitInj.fertilityInj = '';
                     cm.fertilityBenefitInj.drugListInj = '' ;
                     cm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                     cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                     cm.fertilityBenefitInj.drugListNameInj = '' ;
                 }  
                
            }
            else{
                cm.forceToSpecialty = '';
                cm.aetnaSpecialtyCareRx = '';
                cm.noOfFillsBeforeForceToSpecialty = null;
                    
                If (dc1 != null && dc1.size() > 0){
                   //     logger.logCMMState('Checkpoint 10: Mail DC found');
                        List<DC_Drug_List_Group__c> dcdl = new List<DC_Drug_List_Group__c>();
                        List<DC_Drug_List_Group__c> dcdl1 = new List<DC_Drug_List_Group__c>();
                        List<DC_Drug_List_Group__c> dcdl2 = new List<DC_Drug_List_Group__c>();
                        
                        
                        dcdl = [SELECT Id, Drug_List__c, Drug_List_Name__c, Inclusion_Exclusion__c, Related_Drug_Coverage_Name__c, Inclusion_Exclusion_Drug_Class__c, Drug_List__r.Name FROM DC_Drug_List_Group__c WHERE Related_Drug_Coverage__c =: dc1[0].id AND (Drug_List__c =: System.Label.Drug_List_Fertility_Inj OR Drug_List__c =: System.Label.Drug_List_Fertility_oral) LIMIT 1000];
                        
                        dcdl1 = [SELECT Id, Drug_List__c, Drug_List_Name__c, Inclusion_Exclusion__c, Related_Drug_Coverage_Name__c, Inclusion_Exclusion_Drug_Class__c, Drug_List__r.Name FROM DC_Drug_List_Group__c WHERE Related_Drug_Coverage__c =: dc1[0].id AND Drug_List__c =: System.Label.Drug_List_Fertility_Inj LIMIT 1000];
                        dcdl2 = [SELECT Id, Drug_List__c, Drug_List_Name__c, Inclusion_Exclusion__c, Related_Drug_Coverage_Name__c, Inclusion_Exclusion_Drug_Class__c, Drug_List__r.Name FROM DC_Drug_List_Group__c WHERE Related_Drug_Coverage__c =: dc1[0].id AND Drug_List__c =: System.Label.Drug_List_Fertility_oral LIMIT 1000];
                        
                        
                        
                        if (dcdl != null && dcdl.size() > 0){
                    
                            if ( dcdl1 != null && dcdl1.size() > 0 ){
                            
                                if (dcdl1[0].Drug_List__c == System.Label.Drug_List_Fertility_Inj && dcdl1[0].Inclusion_Exclusion__c.equalsignorecase(EXCLUDE) ){
                                    cm.fertilityBenefitInj.fertilityInj = FERTILITYINJYES ;
                                    cm.fertilityBenefitInj.drugListInj = dcdl1[0].Drug_List__r.Name ;
                                    cm.fertilityBenefitInj.relatedDrugCoverageNameInj = dcdl1[0].Related_Drug_Coverage_Name__c ;
                                    cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = dcdl1[0].Inclusion_Exclusion_Drug_Class__c ;
                                    cm.fertilityBenefitInj.drugListNameInj = dcdl1[0].Drug_List_Name__c ;
                                }
                                else{
                                    cm.fertilityBenefitInj.fertilityInj = '';
                                    cm.fertilityBenefitInj.drugListInj = '' ;
                                    cm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                                    cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                                    cm.fertilityBenefitInj.drugListNameInj = '' ;
                                }
                            }
                            else{
                                cm.fertilityBenefitInj.fertilityInj = '';
                                cm.fertilityBenefitInj.drugListInj = '' ;
                                cm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                                cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                                cm.fertilityBenefitInj.drugListNameInj = '' ;
                            }
                            
                            if ( dcdl2 != null && dcdl2.size() > 0 ){
                            
                                if (dcdl2[0].Drug_List__c == System.Label.Drug_List_Fertility_oral && dcdl2[0].Inclusion_Exclusion__c.equalsignorecase(EXCLUDE) ){
                                    cm.fertilityBenefitOral.fertilityOral = FERTILITYORALYES ;
                                    cm.fertilityBenefitOral.drugListOral = dcdl2[0].Drug_List__r.Name ;
                                    cm.fertilityBenefitOral.relatedDrugCoverageNameOral = dcdl2[0].Related_Drug_Coverage_Name__c ;
                                    cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = dcdl2[0].Inclusion_Exclusion_Drug_Class__c ;
                                    cm.fertilityBenefitOral.drugListNameOral = dcdl2[0].Drug_List_Name__c ;
                                }
                                else{
                                    cm.fertilityBenefitOral.fertilityOral = '';
                                    cm.fertilityBenefitOral.drugListOral = '' ;
                                    cm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                                    cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                                    cm.fertilityBenefitOral.drugListNameOral = '' ;
                                }
                            }
                            else{
                                cm.fertilityBenefitOral.fertilityOral = '';
                                cm.fertilityBenefitOral.drugListOral = '' ;
                                cm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                                cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                                cm.fertilityBenefitOral.drugListNameOral = '' ;
                            }
                         }
                         else{
                             //error7
                             cm.fertilityBenefitOral.fertilityOral = '';
                             cm.fertilityBenefitOral.drugListOral = '' ;
                             cm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                             cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                             cm.fertilityBenefitOral.drugListNameOral = '' ;
                             cm.fertilityBenefitInj.fertilityInj = '';
                             cm.fertilityBenefitInj.drugListInj = '' ;
                             cm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                             cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                             cm.fertilityBenefitInj.drugListNameInj = '' ;
                         } 
                
                }
                else{
                    cm.fertilityBenefitOral.fertilityOral = '';
                    cm.fertilityBenefitOral.drugListOral = '' ;
                    cm.fertilityBenefitOral.relatedDrugCoverageNameOral = '';
                    cm.fertilityBenefitOral.inclusionExclusionDrugClassOral = '' ;
                    cm.fertilityBenefitOral.drugListNameOral = '' ;
                    cm.fertilityBenefitInj.fertilityInj = '';
                    cm.fertilityBenefitInj.drugListInj = '' ;
                    cm.fertilityBenefitInj.relatedDrugCoverageNameInj = '';
                    cm.fertilityBenefitInj.inclusionExclusionDrugClassInj = '';
                    cm.fertilityBenefitInj.drugListNameInj = '' ;
                }
           
            }
          
          CRD__c c1 = [SELECT Account__c,National__c,Account__r.name FROM CRD__c WHERE Id =: c.id];
          If (c1.National__c.equalsignorecase(NATIONAL) )
          {
              If (c1.Account__r.name.equalsignorecase(ACCOUNT) )
              {
                  cm.iVLMember = IVLMEMBERYES ;
              }
              else
              {
                  cm.iVLMember = IVLMEMBERNO ;
              }
          }
          else
          {
              cm.iVLMember = IVLMEMBERNO ;
          }  
            
         return cm;   
       }

}