/*Purpose: Apex Class to implement to insert record into Pers seed table.
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Abhishek        06/29/2015          Implementation of Request #05870 for insert the recrod into pers seed table based upon PersKey__c.
   2.0		   Amit			25 Nov, 2015            Added logic to Format control to 7 digit for Pers Seed, ST# 497
======================================================================== */
global class CB_PersSeedRecordCreate{
    //call a method form java script button on Partial Control/Group Detail page
    webservice static string createPersseedRecord(Id pcgId){
        list < PERS_Seed__c > lstPersupdate = new list < PERS_Seed__c > ();
        Map<String,PERS_Seed__c > existingCrd = new  Map<string,PERS_Seed__c >();
        Map<String,String> mapkey2CRDName = new Map<String,String>();
        List<CSAP_CGLP_Junction__c> lstCsapJunction = [select id,CRD__c,crd__r.name,crd__r.Effective_Date__c,crd__r.Y_Schd__c,CSAP_Control_ID__c,CSAP_Plan_ID__c,CRD_RxPlan_ID__c  FROM CSAP_CGLP_Junction__c WHERE Partial_Control_Group__c =: pcgId];
        List<string> lstCrdID = new List<string>();
        Set<String> lstPersCRD = new Set<String>();
        system.debug('lstjumc'+lstCsapJunction);
        String successMessage='';
        String errorMesasge= '';
        String blankRxPlanId = '';
        String lengthOfField = '';
        set<String> crdName = new set<String>();
        boolean checkCRDExist = False;
        if(lstCsapJunction.size()>0){
            for(CSAP_CGLP_Junction__c lstjunc : lstCsapJunction){
                if(lstjunc.CRD_RxPlan_ID__c!=null){
                     PERS_Seed__c newPERSRow = new PERS_Seed__c();
                     newPERSRow.crd__c = lstjunc.CRD__c;
                     newPERSRow.RxplanID__c = lstjunc.CRD_RxPlan_ID__c;
                     lengthOfField = string.valueof(lstjunc.CSAP_Control_ID__c.Length());
                     /*
                     if(lengthOfField == '7'){
                        newPERSRow.Control__c = lstjunc.CSAP_Control_ID__c.Substring(1,7);
                     }
                     newPERSRow.Control__c = lstjunc.CSAP_Control_ID__c;
                     */
                     newPERSRow.Control__c = GC_Utils_Method.calculateControl(lstjunc.CSAP_Control_ID__c);//Added by Amit for ST# 497
                     newPERSRow.Plan__c = lstjunc.CSAP_Plan_ID__c;
                     newPERSRow.EffectiveDate__c = lstjunc.crd__r.Effective_Date__c;
                     newPERSRow.Yschedule__c = lstjunc.crd__r.Y_Schd__c;
                     newPERSRow.Key__c = (newPERSRow.RxplanID__c != null ? newPERSRow.RxplanID__c : '') 
                                + (newPERSRow.Control__c  != null ? newPERSRow.Control__c  : '')
                                + ( newPERSRow.Plan__c != null ?  newPERSRow.Plan__c : '')
                                + (newPERSRow.EffectiveDate__c != null ? DateTime.newInstance(newPERSRow.EffectiveDate__c, Time.newInstance(0,0,0,0)).format('MM/dd/yyyy') : '');
                    existingCrd.put(newPERSRow.Key__c,newPERSRow);
                    mapkey2CRDName.put(newPERSRow.Key__c,lstjunc.CRD__r.name);
                    system.debug('***list**'+existingCrd.values());
                    system.debug('**key***'+newPERSRow.Key__c);    
                }else if(lstjunc.CRD_RxPlan_ID__c==null && lstjunc.CRD__c!=null){
                    lstCrdID.add(lstjunc.crd__r.name);
                    blankRxPlanId =  'RxplanId is not received for CRDs: ' +lstCrdID;
                    checkCRDExist= True;
                }
            }
            if(!checkCRDExist){
                errorMesasge = 'CSAP Record does not contain any CRD';
            }
            //To find the Pers record based on Key.
            for(PERS_Seed__c lstPcg : [select Key__c,crd__r.name From PERS_Seed__c WHERE Key__c IN : existingCrd.Keyset()]){
                 existingCrd.remove(lstPcg.key__c);
                 mapkey2CRDName.remove(lstPcg.key__c);
                 lstPersCRD.add(lstPcg.crd__r.name);
                 errorMesasge =  'Record already exists for the same controlPlan in PERS Seed Table for CRDs :' +lstPersCRD;

            }
            try{
                insert existingCrd.values();
                if(!mapkey2CRDName.keyset().isEmpty())
                {
                    successMessage = 'Successfully inserted Pers seed Records for CRDs: '+mapkey2CRDName.values();
                }
            }catch(exception e){
                 errorMesasge = e.getmessage();
                 successMessage ='';
            }
    
        }else{
            errorMesasge = 'There is no CSAP/CGLP Junction records';
        }
        return blankRxPlanId + '\r\n' + successMessage + '\r\n' + errorMesasge;
    }
    
}