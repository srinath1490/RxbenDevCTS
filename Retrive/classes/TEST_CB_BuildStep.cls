@isTest(seealldata = true)
    private class TEST_CB_BuildStep{   		
        Static testMethod void buildStepTest(){
            String dcMailRecordID;
            String dcRetailRecordID;
            String cTierMail;
			String cTierPaper;
			String cTierpaperOON;
			String cTierRetail;
			String cTierSpecialty;
			String cTierSpecialtyOON;
            for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
                if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
                    dcMailRecordID =  RecType.ID;            
                }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
                    dcRetailRecordID = RecType.ID;
                }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Mail'){
					 cTierMail = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Paper'){
					 cTierPaper = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Paper Out of Network'){
					 cTierpaperOON = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Retail'){
					 cTierRetail = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Specialty'){
					 cTierSpecialty = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Specialty OON'){
					 cTierSpecialtyOON = RecType.ID;
				 }
            }
            case c = new case(subject ='TestData',Service_Request_Type__c='Issue',Triage_Category__c='Other');
            insert c;           
			
            CRD__c testCrd2=new CRD__c();
            testCrd2.crd_automated__c=True;
            testCrd2.crd_automated__c=True;
            testcrd2.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
            testcrd2.Plan_Type_Mail__c = true;
            testcrd2.Plan_Platform__c = 'Aetna Global Benefits';
            testcrd2.Insured_Type__c = 'Self Insured';
            testcrd2.Effective_Date__c = Date.newInstance(2016,8,4);
            testcrd2.control__c = '450360';
			testcrd2.Do_you_want_to_do_Precert__c = 'Yes';
			testcrd2.Do_you_want_to_do_Step_Therapy__c = 'Yes';
            insert testCrd2;
            
            Test_TestDataFactory testdataDrugList = new Test_TestDataFactory();
            drug_list__c dl1 = testdataDrugList.TestDataFactoryDrugList();
			List<Drug_Coverage__c> listDC = new List<Drug_Coverage__c>();
			Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
			dCoverageMail.RecordTypeId = dcMailRecordID;
			dCoverageMail.CRD_ID__c = testCRD2.Id;
			dCoverageMail.Do_you_have_Choose_Generic__c = Null;
			dCoverageMail.Brand_Penalty_Type__c = Null;
			dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
			dCoverageMail.Brand_Penalty_Percent__c = 13;
			dCoverageMail.Generic_Penalty_Type__c = Null;
			dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
			dCoverageMail.Generic_Penalty_Percent__c = 13;
			dCoverageMail.Maintenance_Choice__c = 'Voluntary';
			dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
			dCoverageMail.Mandatory_Mail_Order_Option__c = 'Mandatory w / Opt Out';
			dCoverageMail.fills_before_MMO_option_is_invoked__c = 1;
			dCoverageMail.Non_Pref_Brand_Penalty_Percent__c = 3;
			dCoverageMail.Non_Pref_Brand_Penalty_Dollar_Amount__c = 1;
			dCoverageMail.Non_Pref_Brand_Penalty_Type__c = Null;
			dCoverageMail.Non_Pref_Brand_Penalty_Maximum_Dollar__c = 5;
			dCoverageMail.Non_Pref_Brand_Penalty_Minimum_Dollar__c =3;
			dCoverageMail.Brand_Penalty_Maximum_Dollar__c = 10;
			dCoverageMail.Secondary_Aetna_Specialty_Care_Rx__c ='Custom';
			dCoverageMail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
			dCoverageMail.Days_Per_Fill__c = 2;
			//dCoverageMail.Secondary_Speciality_Drug_List__c = dl.id;
			listDC.add( dCoverageMail);
            Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
            dCoverageRetail.RecordTypeId = dcRetailRecordID;
            dCoverageRetail.CRD_ID__c = testCRD2.Id;
            dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
            dCoverageRetail.Do_you_have_Specialty__c = 'No';
            dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
            dCoverageRetail.Force_to_Specialty__c = 'No';
            dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Does not Apply (Insured/not state filed)';
            dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = 2;
            dCoverageRetail.Days_Per_Fill__c = 2;
			dCoverageRetail.Speciality_Drug_List__c = dl1.id;
            listDC.add( dCoverageRetail);
			insert listDC;
            List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
            crdbuildorder__c  obj = new crdbuildorder__c ();                        
            obj.XML__c  = true;
            obj.CRD__c = testCrd2.id; 
            obj.Case__c = c.id;    
            obj.FalloutCase__c = c.id;
            obj.Success_Case__c = c.id;  
            insert obj;
            lstCBO.add(obj);
            
            
            Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
            mapCrdIdsToBuilder.put(obj.CRD__c,obj);
            //List<sObject> lstpfr = Test.loadData(Pers_Full_Report__c.sObjectType, 'testPFR');
            //List<sObject> lstpfr =  test.loadData(Pers_Full_Report__c., String resourceName)
            Pers_Full_Report__c objPers;
            list<Pers_Full_Report__c> lstpers = new list<Pers_Full_Report__c>();
            
            //Update on 07/-7/2016 by Bhaskar  to use GC_UtilityClassTestData to create PFR.
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            
            Pers_Full_Report__c pfr1=testdata.createPFR(6,72,obj.id);lstpers.add(pfr1);
            Pers_Full_Report__c pfr2=testdata.createPFR(1,576,obj.id);lstpers.add(pfr2);
            Pers_Full_Report__c pfr3=testdata.createPFR(147,0,obj.id);lstpers.add(pfr3);
            //Pers_Full_Report__c pfr4=testdata.createPFR(134,0,obj.id);lstpers.add(pfr4);
            Pers_Full_Report__c pfr5=testdata.createPFR(2,32,obj.id);lstpers.add(pfr5);
            Pers_Full_Report__c pfr6=testdata.createPFR(4,20,obj.id);lstpers.add(pfr6);
            Pers_Full_Report__c pfr7=testdata.createPFR(5,126,obj.id);lstpers.add(pfr7);
            Pers_Full_Report__c pfr8=testdata.createPFR(8,1,obj.id);lstpers.add(pfr8);
            Pers_Full_Report__c pfr9=testdata.createPFR(9,23,obj.id);lstpers.add(pfr9);
            Pers_Full_Report__c pfr10=testdata.createPFR(12,49,obj.id);lstpers.add(pfr10);
            Pers_Full_Report__c pfr11=testdata.createPFR(13,38,obj.id);lstpers.add(pfr11);
            //Pers_Full_Report__c pfr12=testdata.createPFR(13,38,obj.id);lstpers.add(pfr12);
            Pers_Full_Report__c pfr13=testdata.createPFR(14,0,obj.id);lstpers.add(pfr13);
            Pers_Full_Report__c pfr14=testdata.createPFR(15,0,obj.id);lstpers.add(pfr14);
            Pers_Full_Report__c pfr15=testdata.createPFR(17,256,obj.id);lstpers.add(pfr15);
            Pers_Full_Report__c pfr16=testdata.createPFR(19,17,obj.id);lstpers.add(pfr16);
            Pers_Full_Report__c pfr17=testdata.createPFR(20,78,obj.id);lstpers.add(pfr17);
            Pers_Full_Report__c pfr18=testdata.createPFR(24,39,obj.id);lstpers.add(pfr18);
            Pers_Full_Report__c pfr19=testdata.createPFR(25,1,obj.id);lstpers.add(pfr19);
            Pers_Full_Report__c pfr20=testdata.createPFR(27,0,obj.id);lstpers.add(pfr20);
            Pers_Full_Report__c pfr21=testdata.createPFR(28,34,obj.id);lstpers.add(pfr21);
            Pers_Full_Report__c pfr22=testdata.createPFR(29,0,obj.id);lstpers.add(pfr22);
            Pers_Full_Report__c pfr23=testdata.createPFR(30,0,obj.id);lstpers.add(pfr23);
            Pers_Full_Report__c pfr24=testdata.createPFR(31,0,obj.id);lstpers.add(pfr24);
            Pers_Full_Report__c pfr25=testdata.createPFR(32,0,obj.id);lstpers.add(pfr25);
            Pers_Full_Report__c pfr26=testdata.createPFR(34,0,obj.id);lstpers.add(pfr26);
            Pers_Full_Report__c pfr27=testdata.createPFR(44,6,obj.id);lstpers.add(pfr27);
            Pers_Full_Report__c pfr28=testdata.createPFR(45,157,obj.id);lstpers.add(pfr28);
            Pers_Full_Report__c pfr29=testdata.createPFR(46,60,obj.id);lstpers.add(pfr29);
            Pers_Full_Report__c pfr30=testdata.createPFR(53,0,obj.id);lstpers.add(pfr30);
            Pers_Full_Report__c pfr31=testdata.createPFR(54,0,obj.id);lstpers.add(pfr31);
            Pers_Full_Report__c pfr32=testdata.createPFR(55,1,obj.id);lstpers.add(pfr32);
            Pers_Full_Report__c pfr33=testdata.createPFR(56,0,obj.id);lstpers.add(pfr33);
            Pers_Full_Report__c pfr34=testdata.createPFR(58,0,obj.id);lstpers.add(pfr34);
            Pers_Full_Report__c pfr35=testdata.createPFR(59,0,obj.id);lstpers.add(pfr35);
            Pers_Full_Report__c pfr36=testdata.createPFR(60,0,obj.id);lstpers.add(pfr36);
            Pers_Full_Report__c pfr37=testdata.createPFR(67,1,obj.id);lstpers.add(pfr37);
            //Pers_Full_Report__c pfr38=testdata.createPFR(71,85,obj.id);lstpers.add(pfr38);
            Pers_Full_Report__c pfr39=testdata.createPFR(71,85,obj.id);lstpers.add(pfr39);
            Pers_Full_Report__c pfr40=testdata.createPFR(73,0,obj.id);lstpers.add(pfr40);
            Pers_Full_Report__c pfr41=testdata.createPFR(74,0,obj.id);lstpers.add(pfr41);
            Pers_Full_Report__c pfr42=testdata.createPFR(91,0,obj.id);lstpers.add(pfr42);
            Pers_Full_Report__c pfr43=testdata.createPFR(92,0,obj.id);lstpers.add(pfr43);         
            Pers_Full_Report__c pfr44=testdata.createPFR(93,0,obj.id);lstpers.add(pfr44);         
            Pers_Full_Report__c pfr45=testdata.createPFR(94,0,obj.id);lstpers.add(pfr45);         
            Pers_Full_Report__c pfr46=testdata.createPFR(95,0,obj.id);lstpers.add(pfr46);    
            Pers_Full_Report__c pfr47=testdata.createPFR(96,0,obj.id);lstpers.add(pfr47);
            Pers_Full_Report__c pfr48=testdata.createPFR(97,0,obj.id);lstpers.add(pfr48);
            Pers_Full_Report__c pfr49=testdata.createPFR(98,0,obj.id);lstpers.add(pfr49);
            Pers_Full_Report__c pfr50=testdata.createPFR(99,0,obj.id);lstpers.add(pfr50);
            Pers_Full_Report__c pfr51=testdata.createPFR(100,0,obj.id);lstpers.add(pfr51);
            Pers_Full_Report__c pfr52=testdata.createPFR(101,0,obj.id);lstpers.add(pfr52);
            Pers_Full_Report__c pfr53=testdata.createPFR(102,0,obj.id);lstpers.add(pfr53);
            Pers_Full_Report__c pfr54=testdata.createPFR(103,0,obj.id);lstpers.add(pfr54);
            Pers_Full_Report__c pfr55=testdata.createPFR(104,0,obj.id);lstpers.add(pfr55);
            Pers_Full_Report__c pfr56=testdata.createPFR(107,0,obj.id);lstpers.add(pfr56);
            Pers_Full_Report__c pfr57=testdata.createPFR(110,0,obj.id);lstpers.add(pfr57);
            Pers_Full_Report__c pfr58=testdata.createPFR(113,0,obj.id);lstpers.add(pfr58);
            Pers_Full_Report__c pfr59=testdata.createPFR(128,1,obj.id);lstpers.add(pfr59);
            Pers_Full_Report__c pfr60=testdata.createPFR(129,0,obj.id);lstpers.add(pfr60);
            Pers_Full_Report__c pfr61=testdata.createPFR(143,1,obj.id);lstpers.add(pfr61);
            Pers_Full_Report__c pfr62=testdata.createPFR(112,1,obj.id);lstpers.add(pfr62);   
            Pers_Full_Report__c pfr63=testdata.createPFR(40,1,obj.id);lstpers.add(pfr63);
			Pers_Full_Report__c pfr64=testdata.createPFR(134,84,obj.id);lstpers.add(pfr64);
			Pers_Full_Report__c pfr65=testdata.createPFR(84,0,obj.id);lstpers.add(pfr65);
    
            CB_PersFullReportTriggerHandler.CLONEMODE = True;
            insert lstpers;
            objPers = [select id ,CRD_Build_Order__c  from Pers_Full_Report__c  where id = :lstpers[0].id];
            
            //objPers = (Pers_Full_Report__c )lstpfr[0];
            
            List<Pers_Full_Report__c>lstPersFullReport = new List<Pers_Full_Report__c>();
            set<string>setCPEs = new set<string>();
            setCPEs.add('308701AI1/1/2010');
            lstPersFullReport.add(objPers); 
            Map<String,List<Pers_Full_Report__c>> mapNotifPersFull = new Map<String,List<Pers_Full_Report__c>>();
            mapNotifPersFull.put('308701AI1/1/2010',lstPersFullReport);
            
            CB_BuildStep objBuild = new CB_BuildStep();
            system.debug(objPers.CRD_Build_Order__c);
            crdbuildorder__c objsobj = [select id,CRD__c,CRD__r.id from crdbuildorder__c where id = :objPers.CRD_Build_Order__c];
            lstCBO.add((crdbuildorder__c )objsobj );
            test.starttest();
            if(lstCBO.size()>0)
            system.debug('IIIII ' + lstCBO);
            objBuild.execute(lstCBO);
            Pers_Full_Report__c testpers = lstpers[0];
            
			CB_CrdBuilderUtil builderUtil = new CB_CrdBuilderUtil();
			builderUtil.checkForDiabeticPlan(lstpers);
            builderUtil.CommonPostBuildActivities(testCrd2.Id,obj.ID);

        } 
         
        Static testMethod void buildStepConflictTest(){
        
            
            //case c = new case(subject ='TestData',Service_Request_Type__c='Issue',Triage_Category__c='Other');
            //insert c;
            
            CRD__c testCrd=new CRD__c();
            testCrd.crd_automated__c=True;
            testcrd.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
            insert testCrd;
            
            List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
            crdbuildorder__c  obj = new crdbuildorder__c ();                        
            obj.XML__c  = true;
            obj.CRD__c = testCrd.id; 
            //obj.Case__c = c.id;      
            insert obj;
            lstCBO.add(obj);
            
            Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
            mapCrdIdsToBuilder.put(obj.CRD__c,obj);
            //List<sObject> lstpfr = Test.loadData(Pers_Full_Report__c.sObjectType, 'testPFR');
            //List<sObject> lstpfr =  test.loadData(Pers_Full_Report__c., String resourceName)
            Pers_Full_Report__c objPers;
            list<Pers_Full_Report__c> lstpers = new list<Pers_Full_Report__c>();
            
            //Update on 07/-7/2016 by Bhaskar  to use GC_UtilityClassTestData to create PFR.
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            
            Pers_Full_Report__c pfr1=testdata.createPFR(1,576,obj.id);lstpers.add(pfr1);
            Pers_Full_Report__c pfr2=testdata.createPFR(147,0,obj.id);lstpers.add(pfr2);
            Pers_Full_Report__c pfr3=testdata.createPFR(2,32,obj.id);lstpers.add(pfr3);
            Pers_Full_Report__c pfr4=testdata.createPFR(4,20,obj.id);lstpers.add(pfr4);
            Pers_Full_Report__c pfr5=testdata.createPFR(5,126,obj.id);lstpers.add(pfr5);
            Pers_Full_Report__c pfr6=testdata.createPFR(6,10,obj.id);lstpers.add(pfr6);
            Pers_Full_Report__c pfr7=testdata.createPFR(8,1,obj.id);lstpers.add(pfr7);
            
            
            Pers_Full_Report__c pfr8=testdata.createPFR(9,23,obj.id);lstpers.add(pfr8);
            Pers_Full_Report__c pfr9=testdata.createPFR(12,49,obj.id);lstpers.add(pfr9);
            Pers_Full_Report__c pfr10=testdata.createPFR(13,38,obj.id);lstpers.add(pfr10);
            Pers_Full_Report__c pfr11=testdata.createPFR(14,0,obj.id);lstpers.add(pfr11);
            Pers_Full_Report__c pfr12=testdata.createPFR(15,0,obj.id);lstpers.add(pfr12);
            Pers_Full_Report__c pfr13=testdata.createPFR(17,256,obj.id);lstpers.add(pfr13);
            Pers_Full_Report__c pfr14=testdata.createPFR(19,17,obj.id);lstpers.add(pfr14);
            //Pers_Full_Report__c pfr15=testdata.createPFR(134,0,obj.id);lstpers.add(pfr15);
            //Pers_Full_Report__c pfr16=testdata.createPFR(19,17,obj.id);lstpers.add(pfr16);//repeat
            Pers_Full_Report__c pfr17=testdata.createPFR(20,1,obj.id);lstpers.add(pfr17);    
               
               
            Pers_Full_Report__c pfr18=testdata.createPFR(24,39,obj.id);lstpers.add(pfr18);
            Pers_Full_Report__c pfr19=testdata.createPFR(25,1,obj.id);lstpers.add(pfr19);
            Pers_Full_Report__c pfr20=testdata.createPFR(27,0,obj.id);lstpers.add(pfr20);
            Pers_Full_Report__c pfr21=testdata.createPFR(28,0,obj.id);lstpers.add(pfr21);
            Pers_Full_Report__c pfr22=testdata.createPFR(29,0,obj.id);lstpers.add(pfr22);
            Pers_Full_Report__c pfr23=testdata.createPFR(30,0,obj.id);lstpers.add(pfr23);
            Pers_Full_Report__c pfr24=testdata.createPFR(31,0,obj.id);lstpers.add(pfr24);
            Pers_Full_Report__c pfr25=testdata.createPFR(32,0,obj.id);lstpers.add(pfr25);
            Pers_Full_Report__c pfr26=testdata.createPFR(34,0,obj.id);lstpers.add(pfr26);
            Pers_Full_Report__c pfr27=testdata.createPFR(44,6,obj.id);lstpers.add(pfr27);   
               
                
                
            Pers_Full_Report__c pfr28=testdata.createPFR(45,157,obj.id);lstpers.add(pfr28);
            Pers_Full_Report__c pfr29=testdata.createPFR(46,60,obj.id);lstpers.add(pfr29);
            Pers_Full_Report__c pfr30=testdata.createPFR(53,0,obj.id);lstpers.add(pfr30);
            Pers_Full_Report__c pfr31=testdata.createPFR(54,0,obj.id);lstpers.add(pfr31);
            Pers_Full_Report__c pfr32=testdata.createPFR(55,1,obj.id);lstpers.add(pfr32);
            Pers_Full_Report__c pfr33=testdata.createPFR(56,0,obj.id);lstpers.add(pfr33);
            Pers_Full_Report__c pfr34=testdata.createPFR(58,0,obj.id);lstpers.add(pfr34);
            Pers_Full_Report__c pfr35=testdata.createPFR(59,0,obj.id);lstpers.add(pfr35);
            Pers_Full_Report__c pfr36=testdata.createPFR(60,0,obj.id);lstpers.add(pfr36);
            Pers_Full_Report__c pfr37=testdata.createPFR(67,1,obj.id);lstpers.add(pfr37);
            Pers_Full_Report__c pfr38=testdata.createPFR(71,0,obj.id);lstpers.add(pfr38);   
              
               
            Pers_Full_Report__c pfr39=testdata.createPFR(73,0,obj.id);lstpers.add(pfr39);
            Pers_Full_Report__c pfr40=testdata.createPFR(74,0,obj.id);lstpers.add(pfr40);
            Pers_Full_Report__c pfr41=testdata.createPFR(91,0,obj.id);lstpers.add(pfr41);
            Pers_Full_Report__c pfr42=testdata.createPFR(92,0,obj.id);lstpers.add(pfr42);
            Pers_Full_Report__c pfr43=testdata.createPFR(93,0,obj.id);lstpers.add(pfr43);
            Pers_Full_Report__c pfr44=testdata.createPFR(94,0,obj.id);lstpers.add(pfr44);
            Pers_Full_Report__c pfr45=testdata.createPFR(95,0,obj.id);lstpers.add(pfr45);
            Pers_Full_Report__c pfr46=testdata.createPFR(96,0,obj.id);lstpers.add(pfr46);
            Pers_Full_Report__c pfr47=testdata.createPFR(97,0,obj.id);lstpers.add(pfr47);
            Pers_Full_Report__c pfr48=testdata.createPFR(98,0,obj.id);lstpers.add(pfr48);
            Pers_Full_Report__c pfr49=testdata.createPFR(99,0,obj.id);lstpers.add(pfr49);
            Pers_Full_Report__c pfr50=testdata.createPFR(100,0,obj.id);lstpers.add(pfr50);   
               
                
              
            Pers_Full_Report__c pfr51=testdata.createPFR(101,0,obj.id);lstpers.add(pfr51);
            Pers_Full_Report__c pfr52=testdata.createPFR(102,0,obj.id);lstpers.add(pfr52);
            Pers_Full_Report__c pfr53=testdata.createPFR(103,0,obj.id);lstpers.add(pfr53);
            Pers_Full_Report__c pfr54=testdata.createPFR(104,0,obj.id);lstpers.add(pfr54);
            Pers_Full_Report__c pfr55=testdata.createPFR(107,0,obj.id);lstpers.add(pfr55);
            Pers_Full_Report__c pfr56=testdata.createPFR(110,1,obj.id);lstpers.add(pfr56);
            Pers_Full_Report__c pfr57=testdata.createPFR(112,0,obj.id);lstpers.add(pfr57);
            Pers_Full_Report__c pfr58=testdata.createPFR(113,0,obj.id);lstpers.add(pfr58);
            Pers_Full_Report__c pfr59=testdata.createPFR(128,1,obj.id);lstpers.add(pfr59);
            Pers_Full_Report__c pfr60=testdata.createPFR(129,0,obj.id);lstpers.add(pfr60);
            Pers_Full_Report__c pfr61=testdata.createPFR(-1,-1,obj.id);
            
           
            lstpers.add(pfr61);


            CB_PersFullReportTriggerHandler.CLONEMODE = True;        
            insert lstpers;
            objPers = [select id ,CRD_Build_Order__c  from Pers_Full_Report__c  where id = :lstpers[0].id];
            
            //objPers = (Pers_Full_Report__c )lstpfr[0];
            
            List<Pers_Full_Report__c>lstPersFullReport = new List<Pers_Full_Report__c>();
            set<string>setCPEs = new set<string>();
            setCPEs.add('308701AI1/1/2010');
            lstPersFullReport.add(objPers); 
            Map<String,List<Pers_Full_Report__c>> mapNotifPersFull = new Map<String,List<Pers_Full_Report__c>>();
            mapNotifPersFull.put('308701AI1/1/2010',lstPersFullReport);
            
            CB_BuildStep objBuild = new CB_BuildStep();
            CB_BuildStep.mappingValueWrapper innerClass = new CB_BuildStep.mappingValueWrapper();

            system.debug(objPers.CRD_Build_Order__c);
            sobject objsobj = [select id from crdbuildorder__c where id = :objPers.CRD_Build_Order__c];
            lstCBO.add((crdbuildorder__c )objsobj );
            if(lstCBO.size()>0)
            system.debug('KKKKKKK ' + lstCBO);
            objBuild.execute(lstCBO);
            objBuild.setupdatePERSListpage(lstpers);
            
        } 
		
		Static testMethod void buildStepTest1(){
            String dcMailRecordID;
            String dcRetailRecordID;
            for(RecordType RecType : [Select Id,Name,SobjectType From RecordType where SobjectType ='Drug_Coverage__c']){
                if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
                    dcMailRecordID =  RecType.ID;            
                }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
                    dcRetailRecordID = RecType.ID;
                }
            }
            //case c = new case(subject ='TestData',Service_Request_Type__c='Issue',Triage_Category__c='Other');
            //insert c;
            
            FormularyXCustomDL_ERD__c objForm = new FormularyXCustomDL_ERD__c();
            objform.precert__c = 'precert';
            objForm.Quantity_Limit__c = 'ql';
            objform.Step_Therapy__c = 'st';
            objForm.Save_A_Copay__c = 'sac';
            objform.Secondary_Aetna_Specialty_Care_Rx__c = 'test1';
            insert objform;
            CRD__c testCrd=new CRD__c();
            testCrd.crd_automated__c=True;
            testcrd.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
            testcrd.carrier_id__c = 7710;
            testcrd.Plan_Type_Mail__c = true;
            testcrd.Plan_Platform__c = 'Aetna Global Benefits';
            testcrd.Insured_Type__c = 'Self Insured';
            insert testCrd;
            CRD__c testCrd2=new CRD__c();
            testCrd2.crd_automated__c=True;
            testcrd.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
            testcrd.carrier_id__c = 7710;
            insert testCrd2;
            
            Test_TestDataFactory testdataDrugList = new Test_TestDataFactory();
            drug_list__c dl2 = testdataDrugList.TestDataFactoryDrugList();
            Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
            dCoverageRetail.RecordTypeId = dcRetailRecordID;
            dCoverageRetail.CRD_ID__c = testCRD2.Id;
            dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
            dCoverageRetail.Do_you_have_Specialty__c = 'No';
            dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
            dCoverageRetail.Force_to_Specialty__c = 'No';
            dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Applies-LG Value no Fertility';
            dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
            //dCoverageRetail.Secondary_Speciality_Drug_List__c = dl2.id;
            insert dCoverageRetail;
                
            List<Copay_Tier__c> cTierList = new List<Copay_Tier__c>();
            List<SteppedCopay__c> steppedCopayList = new List<SteppedCopay__c>();
            ID cTierMail = Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
            ID cTierPaper = Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper').getRecordTypeId();
            Copay_Tier__c cTier1 = new Copay_Tier__c();
            cTier1.CRD__c = testCrd.id;
            cTier1.RecordTypeId = cTierMail;
            cTier1.Dollar_Amount__c = 3;
            cTier1.Percent__c = 2;
            cTier1.Copay_Calc__c = 'Greatest of All';
            cTier1.Tier_Type__c =   'Brand (SSB & MSB)';
            cTier1.Stepped_Copay__c = True;
            cTierList.add(cTier1);
        
            Copay_Tier__c cTier2 = new Copay_Tier__c();
            cTier2.CRD__c = testCrd2.id;
            cTier2.RecordTypeId = cTierPaper;
            cTier2.Tier_Type__c = 'Specialty (Preferred & Non-Preferred)';
            cTierList.add(cTier2);
            
            insert cTierList;
            ID dSpecificMail = Schema.SObjectType.Drug_Specific_Copay__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
            Drug_Specific_Copay__c sdMail = new Drug_Specific_Copay__c();
            sdMail.CRD_ID__c = testCrd.id;
            sdMail.RecordTypeId =dSpecificMail; 
            insert sdMail;
            
            List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
            crdbuildorder__c  obj = new crdbuildorder__c ();                        
            obj.XML__c  = true;
            obj.CRD__c = testCrd.id; 
            //obj.Case__c = c.id;      
            insert obj;
            lstCBO.add(obj);
            CB_CrdBuilderUtil builderUtil = new CB_CrdBuilderUtil();
            builderUtil.CommonPostBuildActivities(testCRD.Id,obj.ID);
            
            Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
            mapCrdIdsToBuilder.put(obj.CRD__c,obj);
            //List<sObject> lstpfr = Test.loadData(Pers_Full_Report__c.sObjectType, 'testPFR');
            //List<sObject> lstpfr =  test.loadData(Pers_Full_Report__c., String resourceName)
            Pers_Full_Report__c objPers;
            list<Pers_Full_Report__c> lstpers = new list<Pers_Full_Report__c>();
            
            //Update on 07/-7/2016 by Bhaskar  to use GC_UtilityClassTestData to create PFR.
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            
            Pers_Full_Report__c pfr1=testdata.createPFR(6,72,obj.id);
            //pfr1.What_is_the_carrier__c='HNO';
            //pfr1.WS_MLR_CONTRACT_SITUS_ST__c='HNO';
            lstpers.add(pfr1);
            Pers_Full_Report__c pfr2=testdata.createPFR(147,0,obj.id);lstpers.add(pfr2);
            Pers_Full_Report__c pfr3=testdata.createPFR(1,576,obj.id);lstpers.add(pfr3);
            Pers_Full_Report__c pfr4=testdata.createPFR(134,0,obj.id);lstpers.add(pfr4);
            Pers_Full_Report__c pfr5=testdata.createPFR(2,32,obj.id);lstpers.add(pfr5);
            Pers_Full_Report__c pfr444=testdata.createPFR(4,20,obj.id);lstpers.add(pfr444);
            Pers_Full_Report__c pfr6=testdata.createPFR(5,126,obj.id);lstpers.add(pfr6);
    
            Pers_Full_Report__c pfr7=testdata.createPFR(8,1,obj.id);lstpers.add(pfr7);
            Pers_Full_Report__c pfr8=testdata.createPFR(9,23,obj.id);lstpers.add(pfr8);
            Pers_Full_Report__c pfr9=testdata.createPFR(12,49,obj.id);lstpers.add(pfr9);
            Pers_Full_Report__c pfr10=testdata.createPFR(13,38,obj.id);lstpers.add(pfr10);
            Pers_Full_Report__c pfr11=testdata.createPFR(14,0,obj.id);lstpers.add(pfr11);
            Pers_Full_Report__c pfr12=testdata.createPFR(15,0,obj.id);lstpers.add(pfr12);
            Pers_Full_Report__c pfr13=testdata.createPFR(17,256,obj.id);lstpers.add(pfr13);
            Pers_Full_Report__c pfr14=testdata.createPFR(19,17,obj.id);lstpers.add(pfr14);
            Pers_Full_Report__c pfr15=testdata.createPFR(20,78,obj.id);lstpers.add(pfr15);
            Pers_Full_Report__c pfr16=testdata.createPFR(24,39,obj.id);lstpers.add(pfr16);
    
            Pers_Full_Report__c pfr18=testdata.createPFR(25,1,obj.id);lstpers.add(pfr18);
            Pers_Full_Report__c pfr19=testdata.createPFR(27,0,obj.id);lstpers.add(pfr19);
            Pers_Full_Report__c pfr20=testdata.createPFR(28,34,obj.id);lstpers.add(pfr20);
            Pers_Full_Report__c pfr21=testdata.createPFR(29,0,obj.id);lstpers.add(pfr21);
            Pers_Full_Report__c pfr22=testdata.createPFR(30,0,obj.id);lstpers.add(pfr22);
            Pers_Full_Report__c pfr23=testdata.createPFR(31,0,obj.id);lstpers.add(pfr23);
            Pers_Full_Report__c pfr24=testdata.createPFR(32,0,obj.id);lstpers.add(pfr24);
            Pers_Full_Report__c pfr25=testdata.createPFR(34,0,obj.id);lstpers.add(pfr25);
            Pers_Full_Report__c pfr26=testdata.createPFR(44,6,obj.id);lstpers.add(pfr26);
            
            Pers_Full_Report__c pfr27=testdata.createPFR(45,157,obj.id);lstpers.add(pfr27);
            Pers_Full_Report__c pfr28=testdata.createPFR(46,60,obj.id);lstpers.add(pfr28);
            Pers_Full_Report__c pfr29=testdata.createPFR(53,0,obj.id);lstpers.add(pfr29);
            Pers_Full_Report__c pfr30=testdata.createPFR(54,0,obj.id);lstpers.add(pfr30);
            Pers_Full_Report__c pfr31=testdata.createPFR(55,1,obj.id);lstpers.add(pfr31);
            Pers_Full_Report__c pfr32=testdata.createPFR(56,0,obj.id);lstpers.add(pfr32);
            Pers_Full_Report__c pfr33=testdata.createPFR(58,0,obj.id);lstpers.add(pfr33);
            Pers_Full_Report__c pfr34=testdata.createPFR(59,0,obj.id);lstpers.add(pfr34);
            Pers_Full_Report__c pfr35=testdata.createPFR(60,0,obj.id);lstpers.add(pfr35);
            Pers_Full_Report__c pfr355=testdata.createPFR(67,1,obj.id);lstpers.add(pfr355);
            Pers_Full_Report__c pfr36=testdata.createPFR(71,85,obj.id);lstpers.add(pfr36);
            
            Pers_Full_Report__c pfr37=testdata.createPFR(73,0,obj.id);lstpers.add(pfr37);
            Pers_Full_Report__c pfr38=testdata.createPFR(74,0,obj.id);lstpers.add(pfr38);
            Pers_Full_Report__c pfr39=testdata.createPFR(91,0,obj.id);lstpers.add(pfr39);
            Pers_Full_Report__c pfr40=testdata.createPFR(92,0,obj.id);lstpers.add(pfr40);
            Pers_Full_Report__c pfr41=testdata.createPFR(93,0,obj.id);lstpers.add(pfr41);
            Pers_Full_Report__c pfr42=testdata.createPFR(94,0,obj.id);lstpers.add(pfr42);
            Pers_Full_Report__c pfr43=testdata.createPFR(95,0,obj.id);lstpers.add(pfr43);
            Pers_Full_Report__c pfr44=testdata.createPFR(96,0,obj.id);lstpers.add(pfr44);
            Pers_Full_Report__c pfr45=testdata.createPFR(97,0,obj.id);lstpers.add(pfr45);
            Pers_Full_Report__c pfr46=testdata.createPFR(98,0,obj.id);lstpers.add(pfr46);
   
            Pers_Full_Report__c pfr47=testdata.createPFR(99,0,obj.id);lstpers.add(pfr47);
            Pers_Full_Report__c pfr48=testdata.createPFR(100,0,obj.id);lstpers.add(pfr48);
            Pers_Full_Report__c pfr49=testdata.createPFR(101,0,obj.id);lstpers.add(pfr49);
            Pers_Full_Report__c pfr50=testdata.createPFR(102,0,obj.id);lstpers.add(pfr50);
            Pers_Full_Report__c pfr51=testdata.createPFR(103,0,obj.id);lstpers.add(pfr51);
            Pers_Full_Report__c pfr52=testdata.createPFR(104,0,obj.id);lstpers.add(pfr52);
            Pers_Full_Report__c pfr53=testdata.createPFR(107,0,obj.id);lstpers.add(pfr53);
            Pers_Full_Report__c pfr54=testdata.createPFR(110,0,obj.id);lstpers.add(pfr54);
            Pers_Full_Report__c pfr55=testdata.createPFR(113,0,obj.id);lstpers.add(pfr55);
            Pers_Full_Report__c pfr56=testdata.createPFR(128,1,obj.id);lstpers.add(pfr56);
            
            Pers_Full_Report__c pfr57=testdata.createPFR(129,0,obj.id);lstpers.add(pfr57);
            Pers_Full_Report__c pfr58=testdata.createPFR(143,1,obj.id);lstpers.add(pfr58);
            Pers_Full_Report__c pfr59=testdata.createPFR(112,1,obj.id);lstpers.add(pfr59);
            Pers_Full_Report__c pfr60=testdata.createPFR(40,1,obj.id);lstpers.add(pfr60);
            Pers_Full_Report__c pfr61=testdata.createPFR(130,0,obj.id);lstpers.add(pfr61);
            Pers_Full_Report__c pfr62=testdata.createPFR(131,0,obj.id);lstpers.add(pfr62);
            Pers_Full_Report__c pfr63=testdata.createPFR(132,0,obj.id);lstpers.add(pfr63);
            Pers_Full_Report__c pfr64=testdata.createPFR(133,1,obj.id);lstpers.add(pfr64);
            Pers_Full_Report__c pfr65=testdata.createPFR(135,0,obj.id);lstpers.add(pfr65);
            Pers_Full_Report__c pfr66=testdata.createPFR(136,0,obj.id);lstpers.add(pfr66);
            
            Pers_Full_Report__c pfr67=testdata.createPFR(137,0,obj.id);lstpers.add(pfr67);
            Pers_Full_Report__c pfr68=testdata.createPFR(138,0,obj.id);lstpers.add(pfr68);
            Pers_Full_Report__c pfr69=testdata.createPFR(139,0,obj.id);lstpers.add(pfr69);
            Pers_Full_Report__c pfr70=testdata.createPFR(142,0,obj.id);lstpers.add(pfr70);
            Pers_Full_Report__c pfr71=testdata.createPFR(144,0,obj.id);lstpers.add(pfr71);
            Pers_Full_Report__c pfr72=testdata.createPFR(145,0,obj.id);lstpers.add(pfr72);
                      

            CB_PersFullReportTriggerHandler.CLONEMODE = True;
            insert lstpers;
            objPers = [select id ,CRD_Build_Order__c  from Pers_Full_Report__c  where id = :lstpers[0].id];
            
            //objPers = (Pers_Full_Report__c )lstpfr[0];
            
            List<Pers_Full_Report__c>lstPersFullReport = new List<Pers_Full_Report__c>();
            set<string>setCPEs = new set<string>();
            setCPEs.add('308701AI1/1/2010');
            lstPersFullReport.add(objPers); 
            Map<String,List<Pers_Full_Report__c>> mapNotifPersFull = new Map<String,List<Pers_Full_Report__c>>();
            mapNotifPersFull.put('308701AI1/1/2010',lstPersFullReport);
            
            CB_BuildStep objBuild = new CB_BuildStep();
            system.debug(objPers.CRD_Build_Order__c);
            crdbuildorder__c objsobj = [select id,CRD__c,CRD__r.id from crdbuildorder__c where id = :objPers.CRD_Build_Order__c];
            lstCBO.add((crdbuildorder__c )objsobj );
            test.starttest();
            if(lstCBO.size()>0)
            system.debug('LLLLLL ' + lstCBO);
            objBuild.execute(lstCBO);
            Pers_Full_Report__c testpers = lstpers[0];
            
            CB_CrdBuilderUtil testinstance = new CB_CrdBuilderUtil();
            testpers.WS_RISK_IND__c = 'R';
            testinstance.commonAction(testpers);
            testpers.WS_RISK_IND__c = 'S';
            testpers.WS_PSUID__c = '1';
            testinstance.commonAction(testpers);
            testpers.WS_RISK_IND__c = 'N';
            testpers.WS_PSUID__c = '0001';
            testpers.WS_ACQ_BUSS_CD__c  = '01';
            testpers.Carrier_ID__c  = 7760;
            testpers.WS_CUST_SUBSEG__c = 'AGB';
            testinstance.commonAction(testpers);
            //id crdid = objsobj.CRD__c;
            //crd__c crd = new crd__c(Id = crdborecord.crd__r.id);
            id crdid = objsobj.CRD__r.id;
            
            //crd__C newcrd = new crd__C(id = crdid,Insured_Type__c ='Fully Insured');
            //newcrd.Insured_Type__c  = 'Fully Insured';
            //update newcrd;
            //testinstance.CommonPostBuildActivities(crdid,objsobj.id);
            //objBuild.commonaction(objPers);
            //CB_BuildStep.executetest(objPers.id);
        }
        
        
        
        Static testMethod void buildStepConflictlineTest_Negative(){
			String dcMailRecordID;
            String dcRetailRecordID;
            String cTierMail;
			String cTierPaper;
			String cTierpaperOON;
			String cTierRetail;
			String cTierSpecialty;
			String cTierSpecialtyOON;
            for(RecordType RecType : [Select Id,Name,SobjectType From RecordType where SobjectType ='Drug_Coverage__c' or SobjectType ='Copay_Tier__c']){
                if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
                    dcMailRecordID =  RecType.ID;            
                }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
                    dcRetailRecordID = RecType.ID;
                }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Mail'){
					 cTierMail = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Paper'){
					 cTierPaper = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Paper Out of Network'){
					 cTierpaperOON = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Retail'){
					 cTierRetail = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Specialty'){
					 cTierSpecialty = RecType.ID;
				 }else if(RecType.SobjectType =='Copay_Tier__c' && RecType.Name =='Specialty OON'){
					 cTierSpecialtyOON = RecType.ID;
				 }
            }
            FormularyXCustomDL_ERD__c objForm = new FormularyXCustomDL_ERD__c();
            objform.precert__c = 'precert';
            objForm.Quantity_Limit__c = 'ql';
            objform.Step_Therapy__c = 'st';
            objForm.Save_A_Copay__c = 'sac';
            objform.Secondary_Aetna_Specialty_Care_Rx__c = 'test1';
            insert objform;

            CRD__c testCrd2=new CRD__c();
            testCrd2.crd_automated__c=True;
            testCrd2.crd_automated__c=True;
            testcrd2.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
            testcrd2.Plan_Type_Mail__c = true;
            testcrd2.Plan_Platform__c = 'Aetna Global Benefits';
            testcrd2.Insured_Type__c = 'Fully Insured';
            testcrd2.Effective_Date__c = Date.newInstance(2016,8,4);
            testcrd2.control__c = '450360';
			testcrd2.Do_you_want_to_do_Precert__c = 'Yes';
			testcrd2.Do_you_want_to_do_Step_Therapy__c = 'Yes';
			testcrd2.National__c ='National';
			testcrd2.Contract_State__c ='AK';
            insert testCrd2;
            
            Test_TestDataFactory testdataDrugList = new Test_TestDataFactory();
            drug_list__c dl1 = testdataDrugList.TestDataFactoryDrugList();
			List<Drug_Coverage__c> listDC = new List<Drug_Coverage__c>();
			Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
			dCoverageMail.RecordTypeId = dcMailRecordID;
			dCoverageMail.CRD_ID__c = testCRD2.Id;
			dCoverageMail.Do_you_have_Choose_Generic__c = Null;
			dCoverageMail.Brand_Penalty_Type__c = Null;
			dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
			dCoverageMail.Brand_Penalty_Percent__c = 13;
			dCoverageMail.Generic_Penalty_Type__c = Null;
			dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
			dCoverageMail.Generic_Penalty_Percent__c = 13;
			dCoverageMail.Maintenance_Choice__c = 'Voluntary';
			dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
			dCoverageMail.Mandatory_Mail_Order_Option__c = 'Mandatory w / Opt Out';
			dCoverageMail.fills_before_MMO_option_is_invoked__c = 1;
			dCoverageMail.Non_Pref_Brand_Penalty_Percent__c = 3;
			dCoverageMail.Non_Pref_Brand_Penalty_Dollar_Amount__c = 1;
			dCoverageMail.Non_Pref_Brand_Penalty_Type__c = Null;
			dCoverageMail.Non_Pref_Brand_Penalty_Maximum_Dollar__c = 5;
			dCoverageMail.Non_Pref_Brand_Penalty_Minimum_Dollar__c =3;
			dCoverageMail.Brand_Penalty_Maximum_Dollar__c = 10;
			dCoverageMail.Secondary_Aetna_Specialty_Care_Rx__c ='Custom';
			dCoverageMail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
			dCoverageMail.Days_Per_Fill__c = 2;
			//dCoverageMail.Secondary_Speciality_Drug_List__c = dl.id;
			listDC.add( dCoverageMail);
            Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
            dCoverageRetail.RecordTypeId = dcRetailRecordID;
            dCoverageRetail.CRD_ID__c = testCRD2.Id;
            dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
            dCoverageRetail.Do_you_have_Specialty__c = 'No';
            dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
            dCoverageRetail.Force_to_Specialty__c = 'No';
            dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Does not Apply (Insured/not state filed)';
            dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = 2;
            dCoverageRetail.Days_Per_Fill__c = 2;
			dCoverageRetail.Speciality_Drug_List__c = dl1.id;
            listDC.add(  dCoverageRetail);
            insert listDC;
			List<Copay_Tier__c> cTierList = new List<Copay_Tier__c>();				
			Copay_Tier__c cTier1 = new Copay_Tier__c();
				cTier1.CRD__c = testCRD2.id;
				cTier1.RecordTypeId = cTierMail;
				cTier1.Dollar_Amount__c = 3;
				cTier1.Percent__c = 2;
				cTier1.Copay_Calc__c = 'Greatest of All';
				cTier1.Tier_Type__c =   'Brand (SSB & MSB)';
				cTier1.Stepped_Copay__c = True;
				cTierList.add(cTier1);
			
			Copay_Tier__c cTier2 = new Copay_Tier__c();
				cTier2.CRD__c = testCRD2.id;
				cTier2.RecordTypeId = cTierPaper;
				cTier2.Tier_Type__c = 'Specialty (Preferred & Non-Preferred)';
				cTierList.add(cTier2);
				
			Copay_Tier__c cTier3 = new Copay_Tier__c();
				cTier3.CRD__c = testCRD2.id;
				cTier3.RecordTypeId = cTierpaperOON;
				cTier3.Tier_Type__c = 'Generic (SSG & MSG)';
				cTierList.add(cTier3);
				
			Copay_Tier__c cTier4 = new Copay_Tier__c();
				cTier4.CRD__c = testCRD2.id;
				cTier4.RecordTypeId = cTierRetail;
				cTier4.Tier_Type__c = 'Single Source Brand (SSB)';
				cTierList.add(cTier4);
				
			Copay_Tier__c cTier5 = new Copay_Tier__c();
				cTier5.CRD__c = testCRD2.id;
				cTier5.RecordTypeId = cTierSpecialty;
				cTier5.Dollar_Amount__c = 3; 
				cTier5.Copay_Calc__c = 'Lower of the Copay or percentage';
				cTier5.Tier_Type__c = 'Preferred Specialty';
				cTierList.add(cTier5);
				
			Copay_Tier__c cTier6 = new Copay_Tier__c();
				cTier6.CRD__c = testCRD2.id;
				cTier6.RecordTypeId = cTierSpecialtyOON;
				cTier6.Stepped_Copay__c = True;
				cTier6.Dollar_Amount__c = 3;  
				cTier6.Tier_Type__c = 'Single Source Generic (SSG)';
				cTierList.add(cTier6);
				insert cTierList;
			
			Waiver_Of_Deductible__c wod1 = new Waiver_Of_Deductible__c();
			wod1.Standard__c = True;
			wod1.CRD_ID__c = testCRD2.id;
			wod1.M__c = True;
			wod1.N__c = True;
			wod1.O__c = True;
			wod1.Y__c = True;
			insert wod1;
            //case c = new case(subject ='TestData',Service_Request_Type__c='Issue',Triage_Category__c='Other');
            //insert c;
            /*
            CRD__c testCrd=new CRD__c();
				testCrd.crd_automated__c=True;
                testcrd.Standard_or_Custom_Plan__c = 'Cloning a custom plan from existing CRD';
            insert testCrd;
            */
            List<crdbuildorder__c>lstCBO = new List<crdbuildorder__c>();
            crdbuildorder__c  obj = new crdbuildorder__c ();                        
            //obj.XML__c  = true;
            obj.CRD__c = testCrd2.id; 
            //obj.Case__c = c.id;  
           // obj.FalloutCase__c=c.id;//bhaskar
            insert obj;
            lstCBO.add(obj);
            
            Map<Id,CRDBuildOrder__c>mapCrdIdsToBuilder = new Map<Id,CRDBuildOrder__c>();
            mapCrdIdsToBuilder.put(obj.CRD__c,obj);
            //List<sObject> lstpfr = Test.loadData(Pers_Full_Report__c.sObjectType, 'testPFR');
            //List<sObject> lstpfr =  test.loadData(Pers_Full_Report__c., String resourceName)
            Pers_Full_Report__c objPers;
            list<Pers_Full_Report__c> lstpers = new list<Pers_Full_Report__c>();

            //Update on 07/-7/2016 by Bhaskar  to use GC_UtilityClassTestData to create PFR.
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            
            Pers_Full_Report__c pfr1=testdata.createPFR(1,576,obj.id);lstpers.add(pfr1);
            Pers_Full_Report__c pfr2=testdata.createPFR(147,0,obj.id);lstpers.add(pfr2);
            Pers_Full_Report__c pfr3=testdata.createPFR(2,32,obj.id);lstpers.add(pfr3);
            Pers_Full_Report__c pfr4=testdata.createPFR(4,20,obj.id);lstpers.add(pfr4);
            Pers_Full_Report__c pfr5=testdata.createPFR(5,126,obj.id);lstpers.add(pfr5);
            Pers_Full_Report__c pfr6=testdata.createPFR(6,10,obj.id);lstpers.add(pfr6);
            Pers_Full_Report__c pfr7=testdata.createPFR(8,1,obj.id);lstpers.add(pfr7);
  
    
            Pers_Full_Report__c pfr8=testdata.createPFR(9,23,obj.id);lstpers.add(pfr8);
            Pers_Full_Report__c pfr9=testdata.createPFR(12,49,obj.id);lstpers.add(pfr9);
            Pers_Full_Report__c pfr10=testdata.createPFR(13,38,obj.id);lstpers.add(pfr10);
            Pers_Full_Report__c pfr11=testdata.createPFR(14,0,obj.id);lstpers.add(pfr11);
            Pers_Full_Report__c pfr12=testdata.createPFR(15,0,obj.id);lstpers.add(pfr12);
            Pers_Full_Report__c pfr13=testdata.createPFR(17,256,obj.id);lstpers.add(pfr13);
            Pers_Full_Report__c pfr14=testdata.createPFR(19,17,obj.id);lstpers.add(pfr14);
            Pers_Full_Report__c pfr15=testdata.createPFR(19,17,obj.id);lstpers.add(pfr15);//repeat
            Pers_Full_Report__c pfr16=testdata.createPFR(134,0,obj.id);lstpers.add(pfr16);
            Pers_Full_Report__c pfr17=testdata.createPFR(20,1,obj.id);lstpers.add(pfr17);    
    
            
            Pers_Full_Report__c pfr18=testdata.createPFR(24,39,obj.id);lstpers.add(pfr18);
            Pers_Full_Report__c pfr19=testdata.createPFR(25,1,obj.id);lstpers.add(pfr19);
            Pers_Full_Report__c pfr20=testdata.createPFR(27,0,obj.id);lstpers.add(pfr20);
            Pers_Full_Report__c pfr21=testdata.createPFR(28,0,obj.id);lstpers.add(pfr21);
            Pers_Full_Report__c pfr22=testdata.createPFR(29,0,obj.id);lstpers.add(pfr22);
            Pers_Full_Report__c pfr23=testdata.createPFR(30,0,obj.id);lstpers.add(pfr23);
            Pers_Full_Report__c pfr24=testdata.createPFR(31,0,obj.id);lstpers.add(pfr24);
            Pers_Full_Report__c pfr25=testdata.createPFR(32,0,obj.id);lstpers.add(pfr25);
            Pers_Full_Report__c pfr26=testdata.createPFR(34,0,obj.id);lstpers.add(pfr26);
            Pers_Full_Report__c pfr27=testdata.createPFR(44,6,obj.id);lstpers.add(pfr27);
    
    
            Pers_Full_Report__c pfr28=testdata.createPFR(45,157,obj.id);lstpers.add(pfr28);
            Pers_Full_Report__c pfr29=testdata.createPFR(46,60,obj.id);lstpers.add(pfr29);
            Pers_Full_Report__c pfr30=testdata.createPFR(53,0,obj.id);lstpers.add(pfr30);
            Pers_Full_Report__c pfr31=testdata.createPFR(54,0,obj.id);lstpers.add(pfr31);
            Pers_Full_Report__c pfr32=testdata.createPFR(55,1,obj.id);lstpers.add(pfr32);
            Pers_Full_Report__c pfr33=testdata.createPFR(56,0,obj.id);lstpers.add(pfr33);
            Pers_Full_Report__c pfr34=testdata.createPFR(58,0,obj.id);lstpers.add(pfr34);
            Pers_Full_Report__c pfr35=testdata.createPFR(59,0,obj.id);lstpers.add(pfr35);
            Pers_Full_Report__c pfr36=testdata.createPFR(60,0,obj.id);lstpers.add(pfr36);
            Pers_Full_Report__c pfr37=testdata.createPFR(67,1,obj.id);lstpers.add(pfr37);
            Pers_Full_Report__c pfr38=testdata.createPFR(71,0,obj.id);lstpers.add(pfr38);  
    
   
            Pers_Full_Report__c pfr39=testdata.createPFR(73,0,obj.id);lstpers.add(pfr39);
            Pers_Full_Report__c pfr40=testdata.createPFR(74,0,obj.id);lstpers.add(pfr40);
            Pers_Full_Report__c pfr41=testdata.createPFR(91,0,obj.id);lstpers.add(pfr41);
            Pers_Full_Report__c pfr42=testdata.createPFR(92,0,obj.id);lstpers.add(pfr42);
            Pers_Full_Report__c pfr43=testdata.createPFR(93,0,obj.id);lstpers.add(pfr43);
            Pers_Full_Report__c pfr44=testdata.createPFR(94,0,obj.id);lstpers.add(pfr44);
            Pers_Full_Report__c pfr45=testdata.createPFR(95,0,obj.id);lstpers.add(pfr45);
            Pers_Full_Report__c pfr46=testdata.createPFR(96,0,obj.id);lstpers.add(pfr46);
            Pers_Full_Report__c pfr47=testdata.createPFR(97,0,obj.id);lstpers.add(pfr47);
            Pers_Full_Report__c pfr48=testdata.createPFR(98,0,obj.id);lstpers.add(pfr48);
            Pers_Full_Report__c pfr49=testdata.createPFR(99,0,obj.id);lstpers.add(pfr49);
            Pers_Full_Report__c pfr50=testdata.createPFR(100,0,obj.id);lstpers.add(pfr50);
   
            Pers_Full_Report__c pfr51=testdata.createPFR(101,0,obj.id);lstpers.add(pfr51);
            Pers_Full_Report__c pfr52=testdata.createPFR(102,0,obj.id);lstpers.add(pfr52);
            Pers_Full_Report__c pfr53=testdata.createPFR(103,0,obj.id);lstpers.add(pfr53);
            Pers_Full_Report__c pfr54=testdata.createPFR(104,0,obj.id);lstpers.add(pfr54);
            Pers_Full_Report__c pfr55=testdata.createPFR(107,0,obj.id);lstpers.add(pfr55);
            Pers_Full_Report__c pfr56=testdata.createPFR(110,0,obj.id);lstpers.add(pfr56);
            Pers_Full_Report__c pfr57=testdata.createPFR(112,0,obj.id);lstpers.add(pfr57);
            Pers_Full_Report__c pfr58=testdata.createPFR(113,0,obj.id);lstpers.add(pfr58);
            Pers_Full_Report__c pfr59=testdata.createPFR(128,1,obj.id);lstpers.add(pfr59);
            Pers_Full_Report__c pfr60=testdata.createPFR(129,0,obj.id);lstpers.add(pfr60);
            Pers_Full_Report__c pfr61=testdata.createPFR(-1,-1,obj.id);//bhaskar
            pfr61.What_is_the_carrier__c='HNO';
            pfr61.WS_MLR_CONTRACT_SITUS_ST__c='HNO';
            lstpers.add(pfr61);
            
            CB_PersFullReportTriggerHandler.CLONEMODE = True;       
            insert lstpers;
            objPers = [select id ,CRD_Build_Order__c  from Pers_Full_Report__c  where id = :lstpers[0].id];
            
            //objPers = (Pers_Full_Report__c )lstpfr[0];
            
            List<Pers_Full_Report__c>lstPersFullReport = new List<Pers_Full_Report__c>();
            set<string>setCPEs = new set<string>();
            setCPEs.add('308701AI1/1/2010');
            lstPersFullReport.add(objPers); 
            Map<String,List<Pers_Full_Report__c>> mapNotifPersFull = new Map<String,List<Pers_Full_Report__c>>();
            mapNotifPersFull.put('308701AI1/1/2010',lstPersFullReport);
            map<decimal,Pers_Full_Report__c> persMap = new map<decimal,Pers_Full_Report__c>();
            persMap.put(129,pfr60);
            set<string> formularyGroupString = new set<string>();
            formularyGroupString.add('LG Value');
            set<id> formularId = new set<id>();
            for(Formulary__C formulary : [Select Id from Formulary__c Limit 1]){
                formularId.add(formulary.id);
            }
            CB_BuildStep objBuild = new CB_BuildStep();
            
            system.debug(objPers.CRD_Build_Order__c);
            sobject objsobj = [select id from crdbuildorder__c where id = :objPers.CRD_Build_Order__c];
            //objsobj.FalloutCase__c=c;
            lstCBO.add((crdbuildorder__c )objsobj );
            if(lstCBO.size()>0)
            system.debug('JJJJJJ ' + lstCBO);
            objBuild.execute(lstCBO);
            Pers_Full_Report__c testpers = lstpers[0];
            testpers.CRD__c = testCrd2.id;
            CB_CrdBuilderUtil testinstance = new CB_CrdBuilderUtil();
            testpers.WS_RISK_IND__c = 'R';
            testinstance.commonAction(testpers);
            testpers.WS_RISK_IND__c = 'S';
            testpers.WS_PSUID__c = '1';
            testinstance.commonAction(testpers);
            testpers.WS_RISK_IND__c = 'N';
            testpers.WS_PSUID__c = '0001';
            testpers.WS_ACQ_BUSS_CD__c  = '01';
            testpers.Carrier_ID__c  = 7760;
            testpers.WS_CUST_SUBSEG__c = 'AGB';
            testinstance.commonAction(testpers);
            
            Waiver_Of_Deductible_Drug_Class__c wod = new Waiver_Of_Deductible_Drug_Class__c();
            insert wod;

            objBuild.setupdatePERSListpage(lstpers);

            testinstance.CommonPostBuildActivities(testCrd2.id,objsobj.id);

            testinstance.validateDSC(persMap,formularyGroupString,formularId );
            testinstance.compareWithMultiSelect('Test;Test1', 'Test');
            CB_BuildStep.mappingValueWrapper mvr= new CB_BuildStep.mappingValueWrapper();
            List<CB_BuildStep.mappingValueWrapper> mvList = new List<CB_BuildStep.mappingValueWrapper>();
            
            CB_BuildStep.mappingValueWrapper mvr2= new CB_BuildStep.mappingValueWrapper((sObject)wod,'Waiver_Of_Deductible__c');
            CB_BuildStep.mappingValueWrapper mvr3 = new CB_BuildStep.mappingValueWrapper();
            mvr3.mapforValidation(mvr2.childobjects);
            
            testinstance.checkForDiabeticPlan(lstpers);
        }
        
    }