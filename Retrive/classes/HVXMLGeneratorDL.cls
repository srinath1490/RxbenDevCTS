global class HVXMLGeneratorDL implements Database.batchable<Drug_List_Criteria__c>, Database.Stateful{
   //drug list controller. 
    global String XMLstring;
    public boolean batchContext = false;
    public Id parentId;
    global Drug_List__c DLrecord;
    List<Drug_List_Criteria__c>  DLCRecord;
    static List<Id> stepTherapyId;
    static List<Step_Therapy_PreRequisite_Drug__c> steptherapyList;
    global Map<Id, List<Step_Therapy_PreRequisite_Drug__c>> grandgrandchild;
    global static Attachment a;
    public Id tempAid;
    global case c;
    global Integer currentFileNumber;
    global static final Integer MAXSIZE=3145728; //in Bytes. Current size: 3MB

    global HVXMLGeneratorDL(Id p){
        XMLstring='';
        parentId=p;
        batchContext = GMFBuilderUtil.batchContext;
        grandgrandchild = new Map<Id, List<Step_Therapy_PreRequisite_Drug__c>>();
        stepTherapyId = new List<Id>();
        XMLStreamWriter w=new XmlStreamWriter();
        currentFileNumber=0;
        DLrecord=[SELECT 
                    Clinical_Edit_Code_Description__c, Clinical_Edit_Code__c, Termination_Date__c, LastModifiedDate,LastSent__c,Sent_To_CVS_Date__c,Non_GPI_Non_NDC_Check__c,State__c, Standard__c, Special_Use__c, Segment__c, RecordType.Name, Platform__c, 
                        Name, Inactive__c, Id, Funding__c, Effective_Date__c, CVS_Caremark_Drug_List_ID__c, HIX__c, Drug_List_Name__c, Description__c, Account__c
                    FROM Drug_List__c 
                    WHERE Id=:parentId LIMIT 1];

        a=new Attachment();
        a.body=Blob.valueof('');
        a.Name=DLrecord.Name+'.txt';
            a.parentId=DLrecord.Id;
            a.contentType='TXT';
        insert a;
        tempAid=a.Id;

                    
//beging retrieving child and grand child
            
            DLCrecord=[SELECT   
                        Name,Description_of_NDC_Drug_List_Criteria__c,NDC__c,Funding__c, LastModifiedDate,Unit_Cost__c, Transition_of_Care__c, Term__c, Status__c, Start_Age__c, Start_Age_Type__c, Specialty_Name__c, 
                        Specialty_Description__c, Speciality__r.Name, Speciality__r.LastModifiedDate, Speciality__r.Sent_To_CVS_Date__c, Sequence__c, Rx__c, Rule__c, Route__c, Required__c, 
                        RecordType.Name, Quantity_over_Time_Time_Value__c, Quantity_over_Time_Time_Period__c, Quantity_over_Time_Quantity__c,Allow_Transition_Fill__c,
                        Provider__r.Name, Provider__r.LastModifiedDate, Provider__r.Sent_To_CVS_Date__c, Provider_Name__c, Provider_Descriptoin__c, Prescriber__r.Name, Prescriber__r.LastModifiedDate, Prescriber__r.Sent_To_CVS_Date__c,Prescriber_Name__c, 
                        Prescriber_Description__c, Per__c, OTC__c, Number_of_pre_requisites__c, Notes__c,Intent__c, Non_Maintenance__c, Start_Date__c,Maximum_Fills_Over_Time_Time_Period__c,
                        Non_Compliance__c, Minimum_Quantity__c,Minimum_Days__c, Message__c, Maximum_Quantity__c, Maximum_Fills__c, Maxiumum_Fills_Over_Time_Time_Value__c,
                        Maximum_Dollars__c, Maximum_Days__c, Max_Quantity_per_Fill__c, Max_Days_per_Fill__c, Maintenance__c, MS_Code_Y__c,Qualifiers__c, Member_Message__c,
                        MS_Code_O__c, MS_Code_N__c, MS_Code_M__c, Lab_Tests__r.Name, Lab_Tests__r.LastModifiedDate, Lab_Tests__r.Sent_To_CVS_Date__c, Lab_Tests_Name__c, Lab_Test_Description__c, Id, 
                        Grandfathering__c, Gender__c, Force_to_Specialty__c, End_Age__c, End_Age_Type__c, Effective__c, Drug_Type_Code__c, 
                        Drug_List_Criteria_Description__c, Drug_Code_Value__c, Diagnosis__r.Name, Diagnosis__r.LastModifiedDate, Diagnosis__r.Sent_To_CVS_Date__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                        Days_over_Time_of_Days__c, Days_over_Time_Time_Value__c, Days_over_Time_Time_Period__c, Daily_Dose__c, DESI__c, TOC_applies__c,Should_count_towards_meeting_ST_Protocol__c,
                        Clinical_Edit_Option_Code__c, Inactive__c , Bypass_days__c, Repack__c, X100_Copay__c,DAW_Code__c,Excluded_from_Deductible__c,
                        Clinical_Edit_Code_Description__c, Zero_Copay__c,Message_Action__c,By_pass_Aetna_Health_Fund__c,
                        (SELECT Denial_Letter_ID__r.Name,Drug_List_Criteria_ID__r.Name,Name,Drug_List_Criteria_ID__c,Denial_Letter_ID__c,Denial_Letter_Name__c,Denial_Letter_Description__c,Record_Type__c
                           FROM Denial_Letter_Junction__r)
                    FROM Drug_List_Criteria__c 
                    WHERE Inactive__c=false and Drug_List__c=:DLrecord.Id AND isDeleted = false ];
        
               
      //intializing XML
        w.writeStartDocument(null, '1.0');
                   
        //writing parent elements
       //LEVEL 1: writing parent elements- Drug List
        w.writeComment('DrugList Section');
        w.writeStartElement(null,'DrugList', null);
            writeXMLElement(w,'DrugList-XMLVersion',String.valueOf('1.4'));      
            writeXMLElement(w,'DrugListID',String.valueOf(DLrecord.Name));
            writeXMLElement(w,'DrugListName',String.valueOf(DLrecord.Drug_List_Name__c));
            writeXMLElement(w,'DrugGroupDescription',String.valueOf(DLrecord.Description__c));
            writeXMLElement(w,'RecordType',String.valueOf(DLrecord.RecordType.Name));
            writeXMLElement(w,'SpecialUse',String.valueOf(DLrecord.Special_Use__c));
            writeXMLElement(w,'EffectiveDate',String.valueOf(DLrecord.Effective_Date__c));
            writeXMLElement(w,'TerminationDate',String.valueOf(DLrecord.Termination_Date__c));
            writeXMLElement(w,'HIX',String.valueOf(DLrecord.Hix__c)); 
            writeXMLElement(w,'Inactive',String.valueOf(DLrecord.Inactive__c)); 
            writeXMLElement(w,'ClinicalEditCode',String.valueOf(DLrecord.Clinical_Edit_Code__c));
            writeXMLElement(w,'ClinicalEditCodeDescription',String.valueOf(DLrecord.Clinical_Edit_Code_Description__c));
            writeXMLElement(w,'CVSCaremarkDrugListID',String.valueOf(DLrecord.CVS_Caremark_Drug_List_ID__c));
            writeXMLElement(w,'NonGPINonNDCCheck',String.valueOf(DLrecord.Non_GPI_Non_NDC_Check__c));
            writeXMLElement(w,'LastModifiedDate',String.valueOf(DLrecord.LastModifiedDate));
            writeXMLElement(w,'SentToCVSDate',String.valueOf(DLrecord.Sent_To_CVS_Date__c));
            writeXMLElement(w,'TimeStamp',String.valueOf(system.now()));
        // END LEVEL 1
              
        XMLstring+=w.getXmlString();
    w.close();
    a.body=Blob.valueOf(XMLstring);
    update a;
    XMLstring='';

    system.debug(LoggingLevel.ERROR,'Constructor-String so far:'+XMLString);
    }

    global Iterable<Drug_List_Criteria__c> start(Database.BatchableContext BC){
        return new DLCIterable(DLCrecord);
    }

    global void execute(Database.BatchableContext BC, List<Drug_List_Criteria__c> scope){

        //building XML
                XMLStreamWriter w=new XmlStreamWriter();

        for(Drug_List_Criteria__c dlc:scope){ // BEGING LEVEL 2
            w.writeComment('Drug ListCriteria Section');
            w.writeStartElement(null,'DrugListCriteria', null);  
            writeXMLElement(w,'DrugListCriteriaID',String.valueOf(dlc.Name));        
            //writeXMLElement(w,'DrugList',String.valueOf(DLrecord.Name));
            writeXMLElement(w,'LastModifiedDate',String.valueOf(dlc.LastModifiedDate));
        
            writeXMLElement(w,'RecordType',String.valueOf(dlc.RecordType.Name)); 
            writeXMLElement(w,'Inactive',String.valueOf(dlc.Inactive__c)); 
            writeXMLElement(w,'DescriptionofDrugListCriteria',String.valueOf(dlc.Drug_List_Criteria_Description__c));
            writeXMLElement(w,'EffectiveDate',String.valueOf(dlc.Effective__c));
            writeXMLElement(w,'TerminationDate',String.valueOf(dlc.Term__c));
            writeXMLElement(w,'NumberRequired',String.valueOf(dlc.Required__c));
            writeXMLElement(w,'BypassDays',String.valueOf(dlc.Bypass_days__c));
            writeXMLElement(w,'Intent',String.valueOf(dlc.Intent__c));
            writeXMLElement(w,'Notes',String.valueOf(dlc.Notes__c));
            writeXMLElement(w,'NumberOfPreRequisites',String.valueOf(dlc.Number_of_pre_requisites__c));
            writeXMLElement(w,'NonCompliance',String.valueOf(dlc.Non_Compliance__c));
            writeXMLElement(w,'Funding',String.valueOf(dlc.Funding__c));
            writeXMLElement(w,'DrugTypeCode',String.valueOf(dlc.Drug_Type_Code__c));
            writeXMLElement(w,'DrugCodeValue',String.valueOf(dlc.Drug_Code_Value__c));
            writeXMLElement(w,'NDC',String.valueOf(dlc.NDC__c));
            writeXMLElement(w,'DescriptionofNDCDrugListCriteria',String.valueOf(dlc.Description_of_NDC_Drug_List_Criteria__c));
            writeXMLElement(w,'AllowTransitionFill',String.valueOf(dlc.Allow_Transition_Fill__c));
            writeXMLElement(w,'TOCapplies',String.valueOf(dlc.TOC_applies__c));
            writeXMLElement(w,'ShouldcounttowardsmeetingSTProtocol',String.valueOf(dlc.Should_count_towards_meeting_ST_Protocol__c));
            writeXMLElement(w,'Status',String.valueOf(dlc.Status__c));
            writeXMLElement(w,'MSCode_M',String.valueOf(dlc.MS_Code_M__c));
            writeXMLElement(w,'MSCode_N',String.valueOf(dlc.MS_Code_N__c));
            writeXMLElement(w,'MSCode_O',String.valueOf(dlc.MS_Code_O__c));
            writeXMLElement(w,'MSCode_Y',String.valueOf(dlc.MS_Code_Y__c));
            writeXMLElement(w,'Qualifiers',String.valueOf(dlc.Qualifiers__c));
            writeXMLElement(w,'RX',String.valueOf(dlc.Rx__c));
            writeXMLElement(w,'OTC',String.valueOf(dlc.OTC__c));
            writeXMLElement(w,'Repack',String.valueOf(dlc.Repack__c));
            writeXMLElement(w,'DESI',String.valueOf(dlc.DESI__c));
            writeXMLElement(w,'Maintenance',String.valueOf(dlc.Maintenance__c));
            writeXMLElement(w,'NonMaintenance',String.valueOf(dlc.Non_Maintenance__c));
            writeXMLElement(w,'RouteOfAdministration',String.valueOf(dlc.Route__c));
            writeXMLElement(w,'DAWCode',String.valueOf(dlc.DAW_Code__c));
            writeXMLElement(w,'ZeroCopay',String.valueOf(dlc.Zero_Copay__c));
            writeXMLElement(w,'ExcludedFromDeductOrAccum',String.valueOf(dlc.Excluded_from_Deductible__c));
            writeXMLElement(w,'Prescriber',String.valueOf(dlc.Prescriber__r.Name));
            writeXMLElement(w,'PrescriberName',String.valueOf(dlc.Prescriber_Name__c));
            writeXMLElement(w,'PrescriberDescription',String.valueOf(dlc.Prescriber_Description__c));
            writeXMLElement(w,'PrescriberLastModified',String.valueOf(dlc.Prescriber__r.LastModifiedDate));
            writeXMLElement(w,'PrescriberSentToCVSDate',String.valueOf(dlc.Prescriber__r.Sent_To_CVS_Date__c));
            writeXMLElement(w,'Specialty',String.valueOf(dlc.Speciality__r.Name));
            writeXMLElement(w,'SpecialtyName',String.valueOf(dlc.Specialty_Name__c));
            writeXMLElement(w,'SpecialtyDescription',String.valueOf(dlc.Specialty_Description__c));
            writeXMLElement(w,'SpecialtyLastModified',String.valueOf(dlc.Speciality__r.LastModifiedDate));
            writeXMLElement(w,'SpecialtySentToCVSDate',String.valueOf(dlc.Speciality__r.Sent_To_CVS_Date__c));
            writeXMLElement(w,'LabTests',String.valueOf(dlc.Lab_Tests__r.Name));
            writeXMLElement(w,'LabTestsName',String.valueOf(dlc.Lab_Tests_Name__c));
            writeXMLElement(w,'LabTestDescription',String.valueOf(dlc.Lab_Test_Description__c));
            writeXMLElement(w,'LabTestsLastModified',String.valueOf(dlc.Lab_Tests__r.LastModifiedDate));
            writeXMLElement(w,'LabTestsSentToCVSDate',String.valueOf(dlc.Lab_Tests__r.Sent_To_CVS_Date__c));
            writeXMLElement(w,'Diagnosis',String.valueOf(dlc.Diagnosis__r.Name));
            writeXMLElement(w,'DiagnosisName',String.valueOf(dlc.Diagnosis_Name__c));
            writeXMLElement(w,'DiagnosisDescription',String.valueOf(dlc.Diagnosis_Description__c));
            writeXMLElement(w,'DiagnosisLastModified',String.valueOf(dlc.Diagnosis__r.LastModifiedDate));
            writeXMLElement(w,'DiagnosisSentToCVSDate',String.valueOf(dlc.Diagnosis__r.Sent_To_CVS_Date__c));
            writeXMLElement(w,'Provider',String.valueOf(dlc.Provider__r.Name));
            writeXMLElement(w,'ProviderName',String.valueOf(dlc.Provider_Name__c));
            writeXMLElement(w,'ProviderDescription',String.valueOf(dlc.Provider_Descriptoin__c));
            writeXMLElement(w,'ProviderLastModified',String.valueOf(dlc.Provider__r.LastModifiedDate));
            writeXMLElement(w,'ProviderSentToCVSDate',String.valueOf(dlc.Provider__r.Sent_To_CVS_Date__c));
            writeXMLElement(w,'StartAge',String.valueOf(dlc.Start_Age__c));
            writeXMLElement(w,'EndAge',String.valueOf(dlc.End_Age__c));
            writeXMLElement(w,'EndAgeType',String.valueOf(dlc.End_Age_Type__c));
            writeXMLElement(w,'PeriodtoDateStartDate',String.valueOf(dlc.Start_Date__c));
            writeXMLElement(w,'Gender',String.valueOf(dlc.Gender__c));
            writeXMLElement(w,'Grandfathering',String.valueOf(dlc.Grandfathering__c));
            writeXMLElement(w,'TransitionOfCare',String.valueOf(dlc.Transition_of_Care__c));
            writeXMLElement(w,'MinimumDays',String.valueOf(dlc.Minimum_Days__c));
            writeXMLElement(w,'MaximumDays',String.valueOf(dlc.Maximum_Days__c));
            writeXMLElement(w,'DayQuantityRule',String.valueOf(dlc.Rule__c));
            writeXMLElement(w,'MinimumQuantity',String.valueOf(dlc.Minimum_Quantity__c));
            writeXMLElement(w,'MaximumQuantity',String.valueOf(dlc.Maximum_Quantity__c));
            writeXMLElement(w,'MaximumDollars',String.valueOf(dlc.Maximum_Dollars__c));
            writeXMLElement(w,'MaximumFills',String.valueOf(dlc.Maximum_Fills__c));
            writeXMLElement(w,'MaximumFillsOverTimePeriod',String.valueOf(dlc.Maximum_Fills_Over_Time_Time_Period__c));
            writeXMLElement(w,'MaximumFillsOverTimeValue',String.valueOf(dlc.Maxiumum_Fills_Over_Time_Time_Value__c));
            writeXMLElement(w,'DailyDose',String.valueOf(dlc.Daily_Dose__c));
            writeXMLElement(w,'DaysOverTimeNumberOfDays',String.valueOf(dlc.Days_over_Time_of_Days__c));
            writeXMLElement(w,'DaysOverTimeTimePeriod',String.valueOf(dlc.Days_over_Time_Time_Period__c));
            writeXMLElement(w,'DaysOverTimeTimeValue',String.valueOf(dlc.Days_over_Time_Time_Value__c));
            writeXMLElement(w,'QuantityOverTimeQuantity',String.valueOf(dlc.Quantity_over_Time_Quantity__c));
            writeXMLElement(w,'QuantityOverTimeTimePeriod',String.valueOf(dlc.Quantity_over_Time_Time_Period__c));
            writeXMLElement(w,'QuantityOverTimeTimeValue',String.valueOf(dlc.Quantity_over_Time_Time_Value__c));
            writeXMLElement(w,'MaxDaysPerFill',String.valueOf(dlc.Max_Days_per_Fill__c));
            writeXMLElement(w,'MaxQuantityPerFill',String.valueOf(dlc.Max_Quantity_per_Fill__c));
            writeXMLElement(w,'ForceToSpecialty',String.valueOf(dlc.Force_to_Specialty__c));
            writeXMLElement(w,'UnitCost',String.valueOf(dlc.Unit_Cost__c));
            writeXMLElement(w,'PharmacyMessage',String.valueOf(dlc.Message__c));
            writeXMLElement(w,'MemberMessage',String.valueOf(dlc.Member_Message__c));
            writeXMLElement(w,'MessageAction',String.valueOf(dlc.Message_Action__c));
            writeXMLElement(w,'OneHundredPercentCopay',String.valueOf(dlc.X100_Copay__c));
            writeXMLElement(w,'ClinicalEditOptionCode',String.valueOf(dlc.Clinical_Edit_Option_Code__c));
            writeXMLElement(w,'ClinicalEditCodeDescription',String.valueOf(dlc.Clinical_Edit_Code_Description__c));
            writeXMLElement(w,'BypassAetnaHealthFund',String.valueOf(dlc.By_pass_Aetna_Health_Fund__c));
         
            
            //LEVEL 3: GRANDCHILD- FORM JUNCTION
               for(Denial_Letter_Junction__c formJunction:dlc.Denial_Letter_Junction__r){
                 w.writeComment('Form Junction Section');
                 w.writeStartElement(null,'FormJunction', null);
                 writeXMLElement(w,'FormJunctionID',String.valueOf(formJunction.Name));
                 writeXMLElement(w,'RelatedDrugListCriteriaID',String.valueOf(formJunction.Drug_List_Criteria_ID__r.Name));
                 writeXMLElement(w,'RelatedFormID',String.valueOf(formJunction.Denial_Letter_ID__r.Name));
                 writeXMLElement(w,'FormDescription',String.valueOf(formJunction.Denial_Letter_Description__c));
                 writeXMLElement(w,'RecordType',String.valueOf(formJunction.Record_Type__c));
                 w.writeEndElement();
                }//END LEVEL 3
            w.writeEndElement();
            //END LEVEL 2
        }//end for-loop
        
     
     //file handling code   
        a=[select id,body,BodyLength from Attachment where id=:tempAid];
        //check if the size is less than MAXSIZE MB.
        if(a.BodyLength>=MAXSIZE){ //greater than or equal to MAXSIZE.
            if(c==NULL){
                c=new Case();
                c.Aetna_Case_Type__c='GMF Case';
                c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
                c.Effective_Date__c=DLrecord.Effective_Date__c;
                c.GMF_Drug_List__c = true;
                if(DLrecord.Special_Use__c=='Specialty List'){
                    c.GMF_Specialty_Drug_Lists__c=true;
                } else {
                    c.GMF_Specialty_Drug_Lists__c=false;
                }
                c.Subject=String.valueOf(DLrecord.Name)+' '+'-'+' '+String.valueOf(DLrecord.Drug_List_Name__c);
                c.Existing_CVS_Caremark_Drug_List_ID__c = DLrecord.CVS_Caremark_Drug_List_ID__c;
                if (DLrecord.HIX__c == true) {
                c.HIX__c = true;
                } else {
                    c.HIX__c = false;
                }
                GMFBuilderUtil.updateExternalCase(c,DLrecord);//Richa added for Req 6012
                insert c;
                if(!batchContext){
                  DLrecord.External_Case__c = c.id;
                }
            }
            XMLstring=w.getXmlString();
            XMLstring=a.body.toString()+XMLstring;
            
            String cN=[select caseNumber from case where id=:c.Id][0].caseNumber;
            
            currentFileNumber++;
            Blob xmlblob=Blob.valueof(endXML(XMLString,cN));
            Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            //xmlAttach.Name=DLrecord.Name+' '+system.now()+'.xml';
            xmlAttach.Name=DLrecord.Name+'_'+cN+'_'+currentFileNumber+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
            insert xmlAttach;

            //intializing temporary attachment
            a.body=Blob.valueof(startXML());
            update a;

        } 

        else{ //with in size limits.

            XMLstring=w.getXmlString();
            XMLstring=a.body.toString()+XMLstring;
            a.body=Blob.valueOf(XMLstring);
            update a;
        }
     //End file handling
        
     XMLString='';
     w.close();


    }

//----FINISH METHOD----
    global void finish(Database.BatchableContext BC){
        
        //finishing XML
            a=[select id,body from Attachment where id=:tempAid];

            
            //updating record.
        DLrecord.LastSent__c=system.now();
        
        
        //End
        //inserting case if it wasn't already inserted by execute method.
          if(c==NULL){
                c=new Case();
                c.Aetna_Case_Type__c='GMF Case';
                c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
                c.Effective_Date__c=DLrecord.Effective_Date__c;
                c.GMF_Drug_List__c = true;
                if(DLrecord.Special_Use__c=='Specialty List'){
                    c.GMF_Specialty_Drug_Lists__c=true;
                } else {
                    c.GMF_Specialty_Drug_Lists__c=false;
                }
                c.Subject=String.valueOf(DLrecord.Name)+' '+'-'+' '+String.valueOf(DLrecord.Drug_List_Name__c);
                c.Existing_CVS_Caremark_Drug_List_ID__c = DLrecord.CVS_Caremark_Drug_List_ID__c;
                if (DLrecord.HIX__c == true) {
                c.HIX__c = true;
                } else {
                    c.HIX__c = false;
                }
                GMFBuilderUtil.updateExternalCase(c,DLrecord);//Richa added for Req 6012
                insert c;
                if(!batchContext){
                  DLrecord.External_Case__c = c.id;
                }
            }
        //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
      if(!batchContext){
          DLrecord.Sent_To_CVS_Date__c=system.now();
          DLrecord.PDF_Date__c=system.now();
      }
          update DLrecord;    
       
        String cN=[select caseNumber from case where id=:c.Id][0].caseNumber;
        system.debug(logginglevel.error,'caseNumber:'+cN);
        system.debug(logginglevel.error,'case record:'+c);
       
        currentFileNumber++;
        XMLstring=a.body.toString()+'<!-- XML Meta info.FB --><XMLcaseNumber>'+cN+'</XMLcaseNumber>'+'<XMLfileNumber>'+String.valueOf(currentFileNumber)+'</XMLfileNumber>'+'<XMLfinalFile>true</XMLfinalFile><!-- End XML Meta info --></DrugList>'; //finishing up the XML.
        
        Blob xmlblob=Blob.valueof(XMLString);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=DLrecord.Name+'_'+cN+'_'+currentFileNumber+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
        insert xmlAttach;
        
        //sending email
        HVXMLCaller.callMailHandler(c.Id,Userinfo.getUserEmail(),Dlrecord.Name);
    }

    private void writeXMLElement(XMLStreamWriter sw,String elementName, String elementValue){
        sw.writeStartElement(null,elementName,null);
        if(elementValue!=NULL){
            sw.writeCharacters(elementValue);
        }
        else{
            sw.writeCharacters('');
        }
        sw.writeEndElement();
    }

    private string startXML(){

        XMLStreamWriter w=new XMLStreamWriter();

         w.writeStartDocument(null, '1.0');
                   
        //writing parent elements
        w.writeComment('DrugList Section');
        w.writeStartElement(null,'DrugList', null);
        writeXMLElement(w,'DrugList-XMLVersion',String.valueOf('1.4'));        
            writeXMLElement(w,'DrugListID',String.valueOf(DLrecord.Name));
            writeXMLElement(w,'DrugListName',String.valueOf(DLrecord.Drug_List_Name__c));
            writeXMLElement(w,'DrugGroupDescription',String.valueOf(DLrecord.Description__c));
            writeXMLElement(w,'RecordType',String.valueOf(DLrecord.RecordType.Name));
            writeXMLElement(w,'TimeStamp',String.valueOf(system.now()));
            writeXMLElement(w,'LastModifiedDate',String.valueOf(DLrecord.LastModifiedDate));
            writeXMLElement(w,'SentToCVSDate',String.valueOf(DLrecord.Sent_To_CVS_Date__c));
            writeXMLElement(w,'SpecialUse',String.valueOf(DLrecord.Special_Use__c));
            writeXMLElement(w,'EffectiveDate',String.valueOf(DLrecord.Effective_Date__c));
            writeXMLElement(w,'TerminationDate',String.valueOf(DLrecord.Termination_Date__c));
            writeXMLElement(w,'Inactive',String.valueOf(DLrecord.Inactive__c));
            writeXMLElement(w,'ClinicalEditCode',String.valueOf(DLrecord.Clinical_Edit_Code__c));
            writeXMLElement(w,'ClinicalEditCodeDescription',String.valueOf(DLrecord.Clinical_Edit_Code_Description__c));
            writeXMLElement(w,'CVSCaremarkDrugListID',String.valueOf(DLrecord.CVS_Caremark_Drug_List_ID__c));
            writeXMLElement(w,'NonGPINonNDCCheck',String.valueOf(DLrecord.Non_GPI_Non_NDC_Check__c));
              
        String InitialString=w.getXmlString();
        w.close();
        return InitialString;
    }

    private string endXML(String s,String caseNum){
        return s+('<!-- XML Meta info --><XMLcaseNumber>'+caseNum+'</XMLcaseNumber>'+'<XMLfileNumber>'+String.valueOf(currentFileNumber)+'</XMLfileNumber>'+'<XMLfinalFile>false</XMLfinalFile><!-- End XML Meta info --></DrugList>');
    }
    
}//end class