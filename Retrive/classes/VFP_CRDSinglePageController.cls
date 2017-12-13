/*Purpose: Apex Class for VF_CRDSinglePage.
========================================================================
 History                                                           
    -------                      `   DATE                    DETAIL                                 
     1.0 -    Abhay                 02/10/2013              Apex Class for VF_CRDSinglePage.
     1.1 -    Sushant               07/24/2013              Added DC Drug List/Group Section As per Req. 01057
     1.2 -    Rahul                 07/06/2013              Added Related_Copay_Record_Type__c field in Stepped_Copay Object,Request 00914 
     1.3 -       Abhishek           02/19/2015               added a reverse__c field in the query for request 05557

======================================================================== 
*/

public with sharing class VFP_CRDSinglePageController {
    public String CRDID;
    public String CRDIDSubString;
    public String partnerServer;
    // public String email {get;set;}
    Public CRD__c crd {
        get;
        set;
    }
    public list < Copay_Tier__c > lstCopays {
        get;
        set;
    }
    public list < Drug_Specific_Copay__c > lstDrugSpecificCopays {
        get;
        set;
    }
    public list < DAW_Specific_Copay__c > lstDAWSpecificCopays {
        get;
        set;
    }
    public list < AccumulationSpecificDrug__c > lstAccumSpecificDrugs {
        get;
        set;
    }
    public list < Drug_Coverage__c > lstDrugCoverage {
        get;
        set;
    }
    public list < DC_Drug_List_Group__c > lstDrugListGroup {
    get;
    set;
    }
    public list < Accumulations__c > lstAccumulations {
        get;
        set;
    }
    public list < Network_Junction__c > lstNetworkJunction {
        get;
        set;
    }
    public list < CSAP_CGLP_Junction__c > lstCSAPJunction {
        get;
        set;
    }
    public list < Drug_Specific_Stepped_Copay__c > lstDrugSpecificSteppedCopay {
        get;
        set;
    }
    public Network_Junction__c currentNetworkJunction {
        get;
        set;
    }
    public list < SteppedCopay__c > lstSteppedCopay {
        get;
        set;
    }
    
     private Map < String, String > congaQ = new Map < String, String > ();
    
    private String RecordTemplateId = [SELECT Id from APXTConga4__Conga_Template__c WHERE APXTConga4__Name__c = 'Single Page CRD Layout' LIMIT 1].Id;

  
        

    public VFP_CRDSinglePageController(ApexPages.StandardController controller) {
        this.crd = (CRD__c) Controller.getRecord();
        CRDID = controller.getrecord().id;
        CRDIDSubString = CRDID.substring(0, 15);
        system.debug('New String' + CRDIDSubString);
        crd = [select id,Name,Partner_Server__c FROM CRD__c where id =: crd.id limit 1];
        
        lstDrugSpecificSteppedCopay = new list < Drug_Specific_Stepped_Copay__c > ();
        lstDrugSpecificSteppedCopay = [SELECT Drug_Specific_Copay_ID__r.CRD_ID__c, Beginning_Range__c,Copay_Calculation__c,CRD_ID__c,Dollar_Amount__c,Drug_Specific_Copay_ID__c,End_Range__c,Maximum_Dollar__c,Minimum_Dollar__c,Name,Number_of_Steps__c,Percent__c,Related_Drug_Group_List__c,Stepped_CoPay_Type__c FROM Drug_Specific_Stepped_Copay__c WHERE Drug_Specific_Copay_ID__r.CRD_ID__c = :CRDID order by  Drug_Specific_Copay_ID__r.RecordType.DeveloperName, Beginning_Range__c];
        
        lstSteppedCopay = new List < SteppedCopay__c > ();
        //Request 00914 Rahul Nasa 06/07/2013

       
        lstSteppedCopay = [SELECT  s.Copay_Tier__r.CRD__c,s.Reverse__c, s.Copay_Calc__c,s.Copay_Tier__c,s.CRD_ID__c,s.Dollar_Amount__c,s.Id,s.Max_Dollar__c,s.Max_Range__c,s.Min_Dollar__c,s.Min_Range__c,s.Name,s.Number_of_Ranges__c,s.Percent_Amount__c,s.Stepped_CoPay_Types__c,s.Tier_Type__c,s.Related_Copay_Record_Type__c FROM SteppedCopay__c s WHERE s.Copay_Tier__r.CRD__c = :CRDID order by s.Copay_Tier__r.RecordType.DeveloperName,s.Tier_Type__c,s.Min_Range__c];

        //Request 00914 Rahul Nasa 06/07/2013


        lstCopays = new list < Copay_Tier__c > ();
        lstCopays = [Select c.recordtype.name, c.Tier__c, c.Tier_Type__c, c.Stepped_Copay__c, c.Reverse_Copay__c, c.Percent__c, c.Min_Dollar__c, c.Max_Dollar__c, c.Dollar_Amount__c, c.Days_Per_Fill__c, c.Copay_Calc__c From Copay_Tier__c c where c.CRD__c = : CRDID order by c.recordtype.name,c.Tier__c];

        lstDrugSpecificCopays = new list < Drug_Specific_Copay__c > ();
        lstDrugSpecificCopays = [Select d.recordType.Name,d.Reverse_Copay__c, d.Stepped_Copay__c, d.Y__c, d.Percent__c, d.O__c, d.N__c, d.Minimum_Dollar__c, d.Maximum_Dollar__c, d.M__c, d.Id, d.Drug_List__c, d.Drug_List__r.Name, d.Drug_List__r.Drug_List_Name__c, d.Drug_Group__c, d.Drug_Group__r.Drug_Group_Name__c, d.Drug_Group__r.Name, d.Dollar_Amount__c, d.Copay_Calculation__c From Drug_Specific_Copay__c d where d.CRD_ID__c = : CRDID order by d.recordType.Name];

        lstDAWSpecificCopays = new list < DAW_Specific_Copay__c > ();
        lstDAWSpecificCopays = [SELECT recordType.Name, Copay_Calculation__c, CRD_ID__c, DAW_Code__c, Dollar_Amount__c, Id, Maximum_Dollar__c, Minimum_Dollar__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Reverse__c, Name, Percent__c, RecordTypeId,  SteppedCopayCount__c, Stepped__c FROM DAW_Specific_Copay__c where CRD_ID__c = : CRDID];

        lstDrugCoverage = new list < Drug_Coverage__c > ();
        lstDrugCoverage = [Select d.What_Option__c, d.Custom_Refill_too_Soon__r.Refill_too_Soon_Name__c, d.Exception_Drug_Group__r.Drug_Group_Name__c, d.Speciality_Drug_List__r.Drug_List_Name__c, d.Standard_Refill_too_Soon__c, d.Rule_for_supply_quantity__c, d.RecordType.Name, d.RecordTypeId, d.Minimum_quantity__c, d.Minimum_days_supply__c, d.Maximum_quantity__c, d.Maximum_days_supply__c, d.Mandatory_Mail_Order_Option__c, d.Maintenance_Choice__c, d.Formulary__c, d.Formulary__r.Formulary_Name__c, d.Formulary__r.Formulary_Description__c, d.Formulary_Open_Closed__c, d.Force_to_Specialty__c, d.Do_you_have_Specialty__c, d.Do_you_have_Choose_Generic__c, d.Days_Per_Fill__c, d.CRD_ID__c, d.Aetna_Specialty_Care_Rx__c, d.Custom_Refill_too_Soon__r.Name, d.Exception_Drug_Group__r.Name, d.Speciality_Drug_List__r.Name From Drug_Coverage__c d where d.CRD_ID__c = : CRDID];
         //Changed as per the request from Ryan[Start Month New field is fetched now instead of Start Month]
        // added by sushant on 24/07/2013 for request 01057
        lstDrugListGroup = new list <DC_Drug_List_Group__c> ();
        lstDrugListGroup = [Select /*g.Inclusion_Exclusion_Drug_Class__c,*/ g.Related_Drug_Coverage__r.RecordType.Name, g.CRDID__c, g.Inclusion_Exclusion__c, g.Drug_Group__c,g.Drug_Group__r.name, g.Drug_Group_Name__c, g.Drug_List__c,g.Drug_List__r.name, g.Drug_List_Name__c, g.Apply_Limitations__c FROM DC_Drug_List_Group__c g where g.CRDID__c = : CRDIDSubString];
        lstAccumulations = new list < Accumulations__c > ();
        lstAccumulations = [Select a.recordtype.Name, a.Start_Month_New__c, a.Start_Day__c, a.MAB_Out_of_Network__c, a.MAB_Maintenance_Drugs__c, a.MAB_In_Network__c, a.MAB_Generic_Drugs__c, a.MAB_Brand_Drugs_no_Generics__c, a.MAB_Brand_Drugs_Generics__c, a.Is_there_a_Maximum_Out_of_Pocket__c,  a.Is_there_a_Maximum_Allowable_Benefit__c, a.Deuductible_Accumulation_from_4th_Qtr__c, a.Deductible_Period__c, a.Deductible_Amount__c,  a.Carry_Balance_when_member_moves__c, a.CRD_ID__c, a.Are_there_any_drug_specific_MAB__c, a.Are_there_any_drug_specifc_MOOP__c, a.Family_Members_to_meet_Family_Deduct__c, a.Are_there_any_drug_specific_deductibles__c, a.MAB_Dedictible_Amount__c, a.MOOP_Dedictible_Amount__c, a.MAB_Period__c, a.MOOP_Period__c From Accumulations__c a where a.CRD_ID__c = : CRDID];
        //Changed as per the request from Ryan
        lstNetworkJunction = new list < Network_Junction__c > ();
        lstNetworkJunction = [select id, Network_Retail__c, Network_Mail__c, Network_Specialty__c, Retail_Custom__r.Name, Specialty_Custom__r.name, Mail_Custom__r.name, CRD_ID__c from Network_Junction__c where CRD_ID__c = : CRDID];
        if (lstNetworkJunction != null && lstNetworkJunction.size() > 0) {
            currentNetworkJunction = lstNetworkJunction[0];
        }

        lstAccumSpecificDrugs = new list < AccumulationSpecificDrug__c > ();
        lstAccumSpecificDrugs = [SELECT Accumulations_ID__c, Accumulatoins_Type__c, CRDID__c, CRD_ID__c, DAW_Differential_Penalty_Applies_to_MOOP__c, Deductible_Amount__c, Deductible_Applies_towards_the_MOOP__c, Deductible_Period__c, Deuductible_Accumulation_from_4th_Qtr__c, Drug_Group_ID__c, Drug_Group__c, Drug_Group__r.Drug_Group_Name__c, Drug_List_ID__c, Drug_List__c, Drug_List__r.Drug_List_Name__c, Id, MAB_Dedictible_Amount__c, MAB_Period__c, MOOP_Dedictible_Amount__c, MOOP_Period__c, Name, Pay_the_DAW_difference_after_deductible__c, RecordTypeId, What_happens_when_MAB_is_met__c, What_happens_when_MOOP_is_met__c, RecordType.Name FROM AccumulationSpecificDrug__c where CRDID__c = : CRDIDSubString];

        lstCSAPJunction = new list < CSAP_CGLP_Junction__c > ();
        lstCSAPJunction = [select id, Name, Full_Control_Group__c, GLP_Group_Number__c, GLP_Plan_ID__c, Partial_Control_Group__c, CSAP_Control_ID__c, CSAP_Plan_ID__c from CSAP_CGLP_Junction__c where CRD__c = : CRDID and RecordType.Name = 'CRD to Partial CG'];
    }


   
    
    Public string getcongaComposerSinglePage() {
            
            for (APXT_CMQR__Conga_Merge_Query__c cq: [Select a.Id, a.APXT_CMQR__Name__c From APXT_CMQR__Conga_Merge_Query__c a WHERE a.APXT_CMQR__Name__c like 'Single Page%']) {
            congaQ.put(cq.APXT_CMQR__Name__c, cq.id);
        }
        
            string URL = 'https://www.appextremes.com/apps/Conga/PM.aspx' + '?sessionId=' + EncodingUtil.urlEncode(userInfo.getsessionId(), 'UTF-8') + '&serverUrl=' + EncodingUtil.urlEncode(crd .Partner_Server__c, 'UTF-8') + '&id=' + crd.id  + '&QueryId=';

            if (congaQ.containsKey('Single Page Accumulation Specific Drug')) { 
                URL += '[ASD]' + congaQ.get('Single Page Accumulation Specific Drug') + '?pv0=' + crd.Name  +  ','; 
            }

            if (congaQ.containsKey('Single Page Accumulations')) { 
                URL += '[AQ]' + congaQ.get('Single Page Accumulations') + '?pv0=' + crd.id  +  ',';
            }

            if (congaQ.containsKey('Single Page Copay Tier')) { 
                URL += '[CT]' + congaQ.get('Single Page Copay Tier') + '?pv0=' + crd.id  +  ','; 
            }

            if (congaQ.containsKey('Single Page CSAP/CGLP Junction')) { 
                URL += '[CSAP]' + congaQ.get('Single Page CSAP/CGLP Junction') + '?pv0=' + crd.id  +  ','; 
            }

            if (congaQ.containsKey('Single Page DAW Specific Copay')) { 
                URL += '[DAWS]' + congaQ.get('Single Page DAW Specific Copay') + '?pv0=' + crd.id  +  ','; 
            }

            if (congaQ.containsKey('Single Page Drug Coverage')) { 
                URL += '[DC]' + congaQ.get('Single Page Drug Coverage') + '?pv0=' + crd.id +  ',';
            }

            if (congaQ.containsKey('Single Page Drug Specific Copay')) { 
                URL += '[DSC]' + congaQ.get('Single Page Drug Specific Copay') + '?pv0=' + crd.id  +  ',';
            }

            if (congaQ.containsKey('Single Page Network Junction')) { 
                URL += '[NJ]' + congaQ.get('Single Page Network Junction') + '?pv0=' + crd.id +  ','  ;
            }
            if (congaQ.containsKey('Single Page Stepped Copay')) { 
                URL += '[SC]' + congaQ.get('Single Page Stepped Copay') + '?pv0=' + crd.id +  ','  ;
            }
            if (congaQ.containsKey('Single Page Drug Specific Stepped Copay')) { 
                URL += '[DSSC]' + congaQ.get('Single Page Drug Specific Stepped Copay') + '?pv0=' + crd.id +  ','  ;
            }
            // Added by Sushant: Req 01057
            if (congaQ.containsKey('Single Page DC Drug List Group')) { 
                URL += '[DCDLG]' + congaQ.get('Single Page DC Drug List Group') + '?pv0=' + CRDIDSubString +  ','  ;
            }
            

            if (null != RecordTemplateId) { // template reference
                URL += '&TemplateId=' + RecordTemplateId + '&OFN=' + crd.Name + ' RxCCI';

            }
            system.debug('url =' + url);
            return URL;
        
    }
}