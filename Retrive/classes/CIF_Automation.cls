public with sharing class CIF_Automation {
    
    public static void CIFAutomation(list<CRD__c> scope){
        Id contactID = [Select id from Contact where LastName = :System.Label.DCSRT35][0].Id; // Contact to which the mail of updated CIF is to be sent
        list<CIF__c> lstCIF = new list<CIF__c>();
        map<string, list<CRD__c>> CRDmap = new map<string, list<CRD__c>>();
        string FIsubjct = 'Fully Insured CarrierID, RxPlan ID {';
        string FImail = 'The following Fully Insured RxPlan ID, and Control/Plan {';
        map<string, list<CIF__c>> CIFmap = new map<string, list<CIF__c>>();
        list<CRD__c> CIFsToBeCreated = new list<CRD__c>(); 
        list<CIF__c> CIFsToBeUpdated = new list<CIF__c>();
        list<CRD__c> FullyInsuredCRDs = new list<CRD__c>();
        list<CRD__c> SelfInsuredCRDs = new list<CRD__c>();
        list<CIF__c> SelfInsuredCIFs = new list<CIF__c>();     
        Set<String> accountSet=new Set<String>();
        Set<String> excludedAcc = new Set<String>();
        
        Map<Id,CRD__c> mapCrds              //Map to fetch the CRD's Drug Coverage and CSAP CGLP Junction Records
                        = new Map<Id,Crd__c>( 
                                [select 
                                    id,(
                                        Select
                                            CSAP_Detail__c,CSAP_Control_Plan__c,CSAP_Control_ID__c, CSAP_Plan_ID__c 
                                        From 
                                            CSAP_CGLP_Junction__r 
                                        Where
                                            CSAP_Detail__c <> null
                                        ),(
                                        Select 
                                            CRD_ID__c, RecordType.DeveloperName, Force_to_Specialty__c, Maintenance_Choice__c
                                        From
                                            Drug_Coverage__r
                                        )
                                from 
                                    CRD__c 
                                where 
                                    id IN :scope]);
        
        
        for(AccountsToExcludeFromCIF__c acc : AccountsToExcludeFromCIF__c.getAll().values()){
           excludedAcc.add(acc.PSUID__c);   //adding PSUids that should not be considered in CIF creation for Req 5197
        }          
        for(CRD__c crd : scope){
            if(!excludedAcc.contains(crd.PSU__c)){      //Accounts present in the Custom setting are to be excluded from CIF creation      
                if(crd.Insured_Type__c != 'Self Insured'){
                    FullyInsuredCRDs.add(crd);
                    FIsubjct = FIsubjct + '(' + crd.Carrier_Number__c + ',' + crd.RxPlanID__c + ')';
                    string groupPlan;
                    string truncGroupPlan;
                    truncGroupPlan ='';   
                    for(CSAP_CGLP_Junction__c csapJunction : mapCrds.get(crd.id).CSAP_CGLP_Junction__r){
                        truncGroupPlan = groupPlan + (groupPlan == '' ?  '' : ';') + csapJunction.CSAP_Control_Plan__c;
                        GC_Utils_Method gcUtilsMethod = new GC_Utils_Method();
                        groupPlan = gcUtilsMethod.truncateString(truncGroupPlan,5000);
                    }
                    FImail = FImail + '(' + crd.Carrier_Number__c + ',' + crd.RxPlanID__c + ',' + groupPlan +') ';    
                } else {
                SelfInsuredCRDs.add(crd);
                }
            }
        } 
        scope.clear();
                                  
        for(CRD__c crd : SelfInsuredCRDs){                                //Creating map of all the CRDs with Key as the combination of mapping fields
            accountSet.add(crd.Account__c);                     //Collection of the PSUs and Accounts of the new CRDs           
            boolean speCareRx = false;
            boolean mainChoice = false;
            if(!mapCrds.get(crd.id).Drug_Coverage__r.isempty()){
                                for (Drug_Coverage__c DCrecord: mapCrds.get(crd.id).Drug_Coverage__r) {                
                                    if (DCrecord.RecordType.DeveloperName == 'Retail'){
                                        if(DCRecord.Force_to_Specialty__c == 'Yes')                   
                                            speCareRx = true;
                                    }
                                    if (DCrecord.RecordType.DeveloperName == 'Mail'){
                                        if(DCRecord.Maintenance_Choice__c != 'Not Applicable' && DCRecord.Maintenance_Choice__c != null)
                                            mainChoice = true;
                                    }
                                }
            }
                       
           String carrierNum = (crd.Carrier_Number__c != null ? crd.Carrier_Number__c.substring(0,4) : null);
           String keyOfCRD = crd.PSU__c + carrierNum + crd.Old_RxPlan_ID__c + crd.Plan_Type_Mail__c + (crd.Plan_Type_Mail__c ? 'false' : 'true') + crd.Plan_Type_Retail__c + crd.Plan_Type_Paper__c + (crd.Do_you_want_to_do_Step_Therapy__c != 'Yes'?'No':'Yes') + speCareRx + crd.In_Network_claims_are_reimbursed__c + crd.Out_of_Network_claims_are_reimbused__c + (crd.Does_the_client_want_to_do_COB__c != 'Yes'?'No':'Yes') + crd.Prorate__c + mainChoice + (crd.Do_you_want_to_do_Step_Therapy__c != 'Yes'?'No':'Yes'); 
           list <CRD__c> temp = CRDmap.get(keyOfCRD);
           if(temp == null){
              CRDmap.put(keyOfCRD, new list<CRD__c> {crd});                                             //CRD Map    
             } else {                    
                 temp.add(crd);                
                }   
        }
        
        //Search matching CIFs of the new CRDs
        lstCIF = [Select id, Name, Insured_Type__c,Account__r.APM_PSUID__c, Client_Code__c, CRD_Name__c, RxPlan_ID__c, Old_RxPlan_ID__c, Group_Plan__c, Customer_Care_Number__c, Delivery_Systems_Mail__c, Delivery_System_No_Mail__c, Delivery_System_Point_of_Sale__c, Delivery_System_Paper__c, Step_Therapy_Programs__c, Specialty_Care_Rx__c, In_Network_Claims__c, Out_of_Network_Claims__c, COB_Claims__c, Prorate_Information__c, Maintenance_Choice__c, Step_Therapy__c, Sent_to_CVS__c from CIF__c where Insured_Type__c = 'Self Insured' AND Account__c IN (Select Account__c from CRD__c where Id IN :SelfInsuredCRDs)];    
        if(!lstCIF.isempty()){      //If no matching CIF is found
            for(CIF__c cif : lstCIF){ // Create maps of CIFs with the combination of mapping fields as the key
                String keyOfCIF = cif.Account__r.APM_PSUID__c + cif.Client_Code__c + cif.Old_RxPlan_ID__c + cif.Delivery_Systems_Mail__c + cif.Delivery_System_No_Mail__c + cif.Delivery_System_Point_of_Sale__c + cif.Delivery_System_Paper__c + cif.Step_Therapy_Programs__c + (cif.Specialty_Care_Rx__c != 'Yes'?'false':'true') + (cif.In_Network_Claims__c != 'Yes'?'false':'true') + (cif.Out_of_Network_Claims__c != 'Yes'?'false':'true') + cif.COB_Claims__c + cif.Prorate_Information__c + (cif.Maintenance_Choice__c != 'Yes'?'false':'true') + cif.Step_Therapy__c;
                list <CIF__c> temp = CIFmap.get(keyOfCIF);
                if(temp == null){
                  CIFmap.put(keyOfCIF, new list<CIF__c> {cif});                                         //CIF Map     
                 }else{                    
                     temp.add(cif);                
                    }
            }
            for(String CRDkey : CRDmap.keyset()){                                                       
                if(CIFmap.containsKey(CRDkey)){                                                         //Check if any matching CIF is present in the set
                    for(CIF__c cif : CIFmap.get(CRDkey)){                                               //If matching CIF is found, update the CIF record
                        for(CRD__c crd : CRDmap.get(CRDkey)){
                            cif.RxPlan_ID__c += '+' + crd.RxPlanID__c;
                            cif.Group_Plan__c += '+';
                            string truncGroupPlan;
                            truncGroupPlan ='';   
                            for(CSAP_CGLP_Junction__c csapJunction : mapCrds.get(crd.id).CSAP_CGLP_Junction__r){
                                truncGroupPlan = cif.Group_Plan__c + (cif.Group_Plan__c == '' ?  '' : ';') + csapJunction.CSAP_Control_Plan__c;
                                GC_Utils_Method gcUtilsMethod = new GC_Utils_Method();
                                cif.Group_Plan__c = gcUtilsMethod.truncateString(truncGroupPlan,5000);
                            }
                        }
                        CIFsToBeUpdated.add(cif);
                        if(cif.Sent_to_CVS__c)                           //Mail to be sent to aetnaclientliaison@caremark.com of CIF update
                            SelfInsuredCIFs.add(cif);                       //Collection of Self Insured CRDs to whom mail is to be sent
                    }
                    CRDmap.remove(CRDkey);
                    CIFmap.remove(CRDkey);
                } else {
                            CIFsToBeCreated.addAll(CRDmap.get(CRDkey));         //Collection of CRDs whose match is not found
                            CRDmap.remove(CRDkey);  
                        }
            }
        } else {
                    CIFsToBeCreated.addAll(SelfInsuredCRDs);                              //Collection of CRDs if no CIFs are present of the same PSU                             
                    CRDmap.clear();
                }
                                          
        lstCIF.clear();
        SelfInsuredCRDs.clear();

        if(!CIFsToBeUpdated.isempty()){
            update CIFsToBeUpdated;                                         //Update the exact matching CIFs
        }
        CIFsToBeUpdated.clear();
        
        if(!SelfInsuredCIFs.isempty()){                                         //Email to be sent for updated Self Insured CIFs
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(contactID);   
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSubject('RxPlan ID added to existing CIF');
            string SImail = '';
            for(CIF__c cif : SelfInsuredCIFs){
                SImail = SImail + '(' + cif.RxPlan_ID__c + ',' + cif.Group_Plan__c + ',' + CIF.Name + ') ';  
            }
            mail.setPlainTextBody('The following RxPlan ID, Control/Plan have been added to the existing CIF { ' + SImail + ' } which already contains the following plans.');
            mail.setSaveAsActivity(false); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
        }
        SelfInsuredCIFs.clear();
        
        if(!FullyInsuredCRDs.isempty()){                                        //Email to be sent for proposed new values of Fully Insured/Split Funded CIFs
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(contactID);  
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSubject(FIsubjct + '} added to existing CIF.');
            mail.setPlainTextBody(FImail + '} have been added to the existing default CIF for Fully Insured Plans.');
            mail.setSaveAsActivity(false); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        FullyInsuredCRDs.clear();
        
        if(!CIFsToBeCreated.isempty()){                                         //New CIFs to be created
            Map<String,String> acctTeams = new Map<String,String>{};            //Map for AccountTeamMember to whom new CIFs would be assigned
            for(AccountTeamMember atm: [Select 
                                                AccountId, UserId, TeamMemberRole, Account.NB_Implementation__c, User.IsActive
                                            from 
                                                AccountTeamMember 
                                            where 
                                                TeamMemberRole in ('Pharmacy Account Manager' ,'Implementation Manager') AND AccountId IN:accountSet]){                     
                if(atm.Account.NB_Implementation__c == true && atm.TeamMemberRole == 'Implementation Manager'&& atm.User.IsActive == true){
                    acctTeams.put(atm.AccountId,atm.UserId);
                } else if(atm.Account.NB_Implementation__c == false && atm.TeamMemberRole == 'Pharmacy Account Manager'&& atm.User.IsActive == true){
                            acctTeams.put(atm.AccountId,atm.UserId);
                    }
            }       
        accountSet.clear();    
        CIFcreation(CIFsToBeCreated, acctTeams);                //Call the CIF Creating method
        }
    }    
 
    public static void CIFcreation(list<CRD__c> crds,  Map<String,String> AcctTeams){
        List<CIF__c> cifInsertList=new List<CIF__c>();
        GC_Utils_Method gcUtilsMethod = new GC_Utils_Method();        
        //Added by JR to implement request no 04721
        Map<Id,CRD__c> mapCrds 
                        = new Map<Id,Crd__c>( 
                                [select 
                                    id,(
                                        Select
                                            CSAP_Detail__c,CSAP_Control_Plan__c,CSAP_Control_ID__c, CSAP_Plan_ID__c 
                                        From 
                                            CSAP_CGLP_Junction__r 
                                        Where
                                            CSAP_Detail__c <> null
                                        ),(
                                        Select 
                                            CRD_ID__c, RecordType.DeveloperName, Force_to_Specialty__c, Maintenance_Choice__c
                                        From
                                            Drug_Coverage__r
                                        )
                                from 
                                    CRD__c 
                                where 
                                    id IN :crds]); 
        //Copies the value from CRD fields to CIF fields of newly created CIFs                                   
        for(CRD__c crdRecord : crds){
            CIF__c cf = new CIF__c(CRD_Name__c = crdRecord.id);
            if(AcctTeams.containsKey(crdRecord.account__c)){                //Assigning the new CIFs
                cf.OwnerId  = AcctTeams.get(crdRecord.account__c);
            }else {
                if(crdRecord.National__c == 'National' || crdRecord.National__c == 'Government/Labor'){
                    cf.OwnerId = system.Label.CIF_Automation_Default_Owner;
                }else {
                    cf.OwnerId = system.Label.CIF_Automation_Default_Owner_Heather;
                }
            }
            cf.Account__c = crdRecord.Account__c;
            cf.Client_Code__c = crdRecord.Carrier_Number__c;
            cf.RxPlan_ID__c = crdRecord.RxPlanID__c;
            cf.Old_RxPlan_ID__c = crdRecord.Old_RxPlan_ID__c;
            cf.Insured_Type__c = crdRecord.Insured_Type__c;
            cf.Delivery_System_Point_of_Sale__c = crdRecord.Plan_Type_Retail__c;         
            cf.Delivery_System_Paper__c = crdRecord.Plan_Type_Paper__c;
            
            //added by JR to implement request no 04721
            //Modified by Sourabh to truncate the field.
            string truncGroupPlan;
            truncGroupPlan ='';   
            for(CSAP_CGLP_Junction__c csapJunction : mapCrds.get(crdRecord.id).CSAP_CGLP_Junction__r){
                truncGroupPlan = cf.Group_Plan__c + (cf.Group_Plan__c == '' ?  '' : ';') + csapJunction.CSAP_Control_Plan__c;
                cf.Group_Plan__c = gcUtilsMethod.truncateString(truncGroupPlan,5000);
            }
              
            if(crdRecord.Plan_Type_Mail__c==true){
                cf.Delivery_Systems_Mail__c=true;
            } else {
                cf.Delivery_Systems_Mail__c=false;
                cf.Delivery_System_No_Mail__c=true;
                cf.Mail_Order_Delay__c='Not Applicable';
            }
            if(crdRecord.In_Network_claims_are_reimbursed__c==true){ 
                cf.In_Network_Claims__c='Yes';
            } else { 
                cf.In_Network_Claims__c='No';
            }
            if(crdRecord.Out_of_Network_claims_are_reimbused__c==true){ 
                cf.Out_of_Network_Claims__c='Yes';
            } else { 
                cf.Out_of_Network_Claims__c='No';
            }
            if(crdRecord.Plan_Type_Specialty__c==false){
                cf.Specialty_Retail_Lock_out__c='Not Applicable';
            }
            /*if(crdRecord.Toll_Free_Number__c=='Custom'){ This field is no more used - Richa
                cf.Customer_Care_Number__c = crdRecord.Custom_TFN__c;
            }*/ 
            if(crdRecord.Does_the_client_want_to_do_COB__c=='Yes'){ 
                cf.COB_Claims__c='Yes';
            } else{
                cf.COB_Claims__c='No';
            }
            if(crdRecord.Do_you_want_to_do_Step_Therapy__c=='Yes'){ 
                cf.Step_Therapy__c='Yes';
                cf.Step_Therapy_Programs__c='Yes';
            } else{ 
                cf.Step_Therapy__c='No';
                cf.Step_Therapy_Programs__c='No';
            }
            cf.Prorate_Information__c = String.valueof(crdRecord.Prorate__c) ; //Richa added field for Req 5015
            cf.Specialty_Care_Rx__c= 'No';
            cf.Maintenance_Choice__c='No';
            for (Drug_Coverage__c DCrecord: mapCrds.get(crdRecord.id).Drug_Coverage__r) {
                if (DCrecord.RecordType.DeveloperName == 'Retail' && DCRecord.Force_to_Specialty__c=='Yes') {
                    cf.Specialty_Care_Rx__c='Yes';
                } 
                if (DCrecord.RecordType.DeveloperName == 'Mail' && (DCRecord.Maintenance_Choice__c != 'Not Applicable' && DCRecord.Maintenance_Choice__c != null )) {
                    cf.Maintenance_Choice__c='Yes';
                } 
            }
            cifInsertList.add(cf);
        }
        insert cifInsertList;
    }
}