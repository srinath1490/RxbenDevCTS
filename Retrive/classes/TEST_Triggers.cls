/*Purpose: Apex Test Class for TEST_Triggers.
    ========================================================================
     History                                                           
        -------                                                          
     VERSION     AUTHOR                 DATE                    DETAIL                                 
         1.0 -   Amit                 4/12/2015       Apex Test Class for TEST_Triggers.
    ======================================================================== 
    */
    @isTest
        private class TEST_Triggers {
            static testMethod void myUnitTest(){
                // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
                String accumFamilyRetail;
                String dawSpecificMail;
                String drugListRecordId;
                String dcRetailRecordID;
                for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
                    if(RecType.SobjectType =='Accumulations__c' && RecType.Name =='Family - Retail'){
             			accumFamilyRetail = RecType.ID;
         			}else if(RecType.SobjectType =='DAW_Specific_Copay__c' && RecType.Name =='Mail'){
             			dawSpecificMail = RecType.ID;
         			}else if(RecType.SobjectType =='Drug_List__c' && RecType.Name =='Drug List'){
             			drugListRecordId = RecType.ID;
         			}else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
                        dcRetailRecordID = RecType.ID;
                     }
                }
                CRD__c crd = new CRD__c();
                insert crd;
                
                CRD__c crd1 = new CRD__c();
                insert crd1;
                
                Accumulations__c accumFA = new Accumulations__c();
        		accumFA.CRD_ID__c = crd.id;
        		accumFA.RecordTypeId =accumFamilyRetail;
        		accumFA.What_happens_when_MOOP_is_met__c = 'Change Copay';
        		insert accumFA;
                
                AccumulationSpecificDrug__c newRecord = new AccumulationSpecificDrug__c();
                newRecord.Accumulations_ID__c = accumFA.ID;
                insert newRecord;
                
                newRecord.Accumulatoins_Type__c ='Test';
                update newRecord;
                delete newRecord;
                
                DAW_Specific_Copay__c dscPaperOON = new DAW_Specific_Copay__c();
        		dscPaperOON.CRD_ID__c = crd.id;
        		dscPaperOON.RecordTypeId =dawSpecificMail;
        		insert dscPaperOON;
                
                DAW_Specific_Stepped_Copay__c dssc2 = new DAW_Specific_Stepped_Copay__c();
        		dssc2.DAW_Specific_Copay_ID__c = dscPaperOON.Id;
        		dssc2.Beginning_Range__c = 5;
        		dssc2.End_Range__c = 2;
        		insert dssc2;  
                
                dssc2.End_Range__c = 3;
                update dssc2;
                
                delete dssc2;
                
                CRD_Step_Therapy_Junction__c stJunc1 = new CRD_Step_Therapy_Junction__c();
                    stJunc1.CRD_ID__c = crd.id;
                    insert stJunc1;
                	stJunc1.CRD_ID__c = crd1.id;
                	update stJunc1;
                	delete stJunc1;
             	CRD_PriorAuth_Junction__c paJunc1 = new CRD_PriorAuth_Junction__c();
                    paJunc1.CRD_ID__c = crd.id; 
                    insert paJunc1;
                	paJunc1.CRD_ID__c = crd1.id;
                	update paJunc1;
                	delete paJunc1;
             	CRD_Quantity_Limit_Junction__c qlJunc1 = new CRD_Quantity_Limit_Junction__c(); 
                    qlJunc1.CRD_ID__c = crd.id;
                    insert qlJunc1;
                	qlJunc1.CRD_ID__c = crd1.id;
                	update qlJunc1;
                	delete qlJunc1;
                Exception__c exc = new Exception__c();
                insert exc;
                exc.Effective_Date__c = System.Today();
                update exc;
                
                Drug_List__c dl = new Drug_List__c();
                dl.Drug_List_Name__c = 'Test';
                dl.Description__c = 'Dummy';
                dl.RecordTypeID = drugListRecordId;
                insert dl;
                Drug_List_Criteria__c dlc = new Drug_List_Criteria__c();
                dlc.Drug_List__c = dl.id;
                dlc.Effective__c = System.today(); 
                dlc.Term__c = System.today();
                insert dlc;
                
                Stepped_Over_Time__c stp = new Stepped_Over_Time__c();
                stp.Related_Drug_List_Criteria__c = dlc.id;
                insert stp;
                update stp;
                
                Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
                dCoverageRetail.RecordTypeId = dcRetailRecordID;
                dCoverageRetail.CRD_ID__c = crd.Id;
                dCoverageRetail.Do_you_have_Specialty__c = 'Yes';
                dCoverageRetail.Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List';
                dCoverageRetail.Force_to_Specialty__c = 'No';
                insert dCoverageRetail;
                
                DC_Drug_List_Group__c dcdl = new DC_Drug_List_Group__c();
                dcdl.Related_Drug_Coverage__c = dCoverageRetail.id;
                dcdl.Inclusion_Exclusion__c = 'Include';
                dcdl.Apply_Limitations__c ='No';
                insert dcdl;
                delete dcdl;
                
        	}
		}