/*Purpose: Apex Batch Class to make Create Crd's from Pers Reports
========================================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE                          DETAIL                                 
1.0      Ankur Aggarwal           5/20/2014       Apex Batch Class to make Create Crd's from Pers Reports
2.0      Amit Jain                2nd Jan, 2015   Updated the Fallout Case Creation, Changed System.now() to CRDBuild PersStamp
3.0      Ankur Aggarwal           19th feb, 2015   Updated to add stepped copay as part of 5463 story.                           
4.0      Nikita Bansal            3/4/2015        Commented code as per Request 05589
4.1      Sushant Sethi            5/5/2015        Implemented request 05730
4.2      Abhishek goel            8/17/2015       Implementation for ST#263
4.3      Raj Prasad                9/2/2015       Commented code as per Defect #D00614
4.4      Raj Prasad                9/16/2015       Revert back the changes as per Defect #D00614
4.5      Raj Prasad                11/18/2015      Implementation for ST# 155
4.6      Vikram                    12/30/2015      Implementation for ST# 763 (Request - 06279)
4.7      Shubham Kumar             01/21/2016      Implementation for ST# 562 
4.8      Shubham Kumar             02/15/2016      Implementation for ST# 913 (Request- 06368)
4.9      Bhaskar Arora             06/28/2016      Implementation update on ST#1191 (Request 06528)
5.0      Nitish                    01/17/2016      Implemented Request 6819
5.1      Nitish                    05/30/2017      Implemented Request 6973
5.2      Nitish                    06/01/2017      Implemented Request 6988
==================================r====================================== */
global without sharing class CB_BuildStep {
    //Class Variables
    //DataType 
    private static final string MULTIPLIERAPI = 'Multiplier__c';
    private static final string DOLLARAMTAPI = 'Dollar_Amount__c';
    private static final string MINDOLAPI = 'Min_Dollar__c';
    private static final string MAXDOLAPI = 'Max_Dollar__c';
    private static final string PERCENTAMTAPI = 'Percent_Amount__c';
    private static final string PERCENTAPI = 'Percent__c';
    private static final string COPAYCALCAPI = 'Copay_Calc__c';
    private static final string BLANKVAL = '';
    private static final string ACCUMAPI = 'Accumulations__c';
    private static final string COPAYAPI = 'Copay_Tier__c';
    private static final string DRUGCOVAPI = 'Drug_Coverage__c';
    private static final string DCDLAPI = 'DC_Drug_List_Group__c';
    private static final string CRDAPI = 'CRD__c';
    private static final string IDVAL = 'id';
    private static final string IDVAL1 = 'ID';
    private static final string COMMAVAL = ',';
    private static final string SEMICOLVAL = ';';
    private static final string SELECTVAL = 'SELECT ';
    private static final string QUERYEND = ' FROM Pers_Full_Report__c WHERE CRD_Build_Order__c IN:batchIds ORDER BY Name DESC';
    private static final string VARP = 'P';
    private static final string VARL = 'L';
    private static final string PROVLINEVAL = 'P34L0';
    private static final string PROVLINEVAL2 = 'P113L0';
    private static final string PROVLINEVAL3 = 'P31L0';
    private static final string CARRIERHNO = 'HNO';
    private static final string CRDBUILDERFALVAL = 'CRD Builder fallout';
    private static final string CONFLICTERRVAL = 'Conflict Error - This is due to DuplicateBPLVs';
    private static final string ERRMSGVAL = 'DuplicateBPLVs';
    private static final string CONFLICTERRVAL2 = 'Error - This is due to MissingBPLVs';
    private static final string ERRMSGVAL2 = 'MissingBPLVs';
    private static final string CONFLICTERRVAL3 = 'CRD Requires Fallout';
    private static final string ERRMSGVAL3 = 'Error - Invalid Situs State Received';
    private static final string ERRMSGVAL4 = 'Situs State';
    // Added by Bhaskar for Request 06528 (ST#1191) Start
    private static final string ASH = 'Aetna Student Health';
    private static final string ISMAB = 'Is_there_a_Maximum_Allowable_Benefit__c';
    private static final string ISMOP = 'Is_there_a_Maximum_Out_of_Pocket__c';
    private static final string DEDUCTAMOUNT = 'Deductible_Amount__c';
    private static final string INDEDUCTAMOUNT = 'What_is_the_In_Network_Deductible_Amount__c';
    private static final string OONDEDUCTAMOUNT = 'What_is_the_OON_Deductible_Amount__c';
    private static final string YES_LABEL= 'Yes';
    private static final string SAVEERRORS = 'Save Errors';
    private static boolean checkProvision45and46 = False;
    private static boolean checkDiabeticPlan = false ; //Request 6819 by Nitish
    private static final string DNA = 'Does not Apply';//By Nitish Request 6820

    // Added by Bhaskar for Request 06528 (ST#1191) End
    String  multiplierlabel= MULTIPLIERAPI;
    boolean crdrecordinsert = false; // Added by Ayushi for Request 06528 (ST#1191)
    public static boolean FormularyFlag = False;
    Boolean createAccumulations = True;
    Boolean scenarioAccum3 = False;
    map <id,CRD__c> cRDIdsObjectmap = new map<id,CRD__c>(); // Added by Ayushi for Request 06528 (ST#1191)
    boolean ischemodrugbypass = False; // Added by Ayushi for Request 06528 (ST#1191) to see if the Chemo Drugs should be Bypassed
    Private static final string PAPEROONLABEL = 'Paper Out of Network';
    String Dollaramount = DOLLARAMTAPI;
    String mindollar = MINDOLAPI;
    String maxdollar = MAXDOLAPI;
    String percentamount = PERCENTAMTAPI;
    String percent = PERCENTAPI;
    String copaycalc = COPAYCALCAPI;
    string crdBuildOrderId = null;
    public list < CRD_BuilderFallout__c > CrdBuilderFallouts = new List<CRD_BuilderFallout__c>();
    public boolean hasBuilderFallout = False;
    public static boolean passPreBuildFallout = False;
    String QString; //Query string for start method
    Id falloutCaseRecordId; //Used to hold evennotification recordtypeId
    public  list<DC_Drug_List_Group__c>  lstDruglistGroupdelete = new list<DC_Drug_List_Group__c> ();
    private Map < string, set < string >> cp_cpeMap = new Map < string, set < string >>();///map between controlplan and controlplaneffective  
    private Map < string, set < Mapping_Values__c >> CPEtoMappingValuesMap= new  Map < string, set < Mapping_Values__c >>();//Map between CPE and 
    public List<Mapping_Values__c> asdMapVal ;// Added By Nitish for #7094
    public void setupdatePERSListpage(list < Pers_Full_Report__c > templist){
    updatePERSList= templist;
    }
            //Added by JR to implement request 6154
            Public boolean bProvLineValue= false;
            Public boolean bNewProvLineValue= false;
            Public boolean preBuildFallout = False;
            string controlPreBuild = BLANKVAL;
            id cbonPreBuild;
            string effectiveDatePreBuild = BLANKVAL;
            string psuidPreBuild = BLANKVAL;
            string carrierPreBuild = BLANKVAL;
            Set<String> setFalloutKey = new Set<String>();
                        private Date crdEffectiveDate = Null;
                        private list < Pers_Full_Report__c > updatePERSList = new List<Pers_Full_Report__c>();
                        map < string, sobject > mappingSobjectMap {
                            get;
                            set;
                        }
                        Mapping_Values__c crdMappingvalue {
                            get;
                            set;
                        }
                        private set < String > ConflictErrorsMesseges {
                            get;
                            set;
                        }
                        private list<recordtype> Recordtypeaccum{
                            get;
                            set;
                        }
                        private map < decimal, set < decimal >> provlines{
                            get;
                            set;
                        }
                        private map<id,recordtype> copayrecordtypes {
                            get;
                            set;
                        }
                        private map<id,recordtype> recordtypes{
                            get;
                            set;
                        }
                        private map < String ,string> ConflictErrorsMessegesMap {
                            get;
                            set;
                        }               
                    private case existingFalloutCase {
                            get;
                            set;
                        }
                    private case SuccessCase {
                            get;
                            set;
                        }
                        private Map < String, Schema.SObjectType > GlobalDescribe = Schema.getGlobalDescribe();
                        Static String CPEfortest {
                            get;
                            set;
                        }
                        private boolean BPLVMissing;
                        Boolean createAccumus = false;
                        // list of mandatory provision number that should be in the pers data.
                       
                        map < decimal, Pers_Full_Report__c> provision = new map < decimal, Pers_Full_Report__c> ();
                        //============================
                        // Constructor
                        //============================



                        global CB_BuildStep() {
                            list <recordtype> recordtypesall= [select id,name,sobjecttype from recordtype 
                                                                where 
                                                                sobjecttype=: ACCUMAPI or sobjecttype=: COPAYAPI or  sobjecttype=:DRUGCOVAPI limit 1000];
                            
                            Recordtypeaccum = new list<recordtype>();
                            copayrecordtypes = new map<id,recordtype>();
                            recordtypes = new map<id,recordtype>();
                            for(recordtype temprectype : recordtypesall){
                                if(temprectype.sobjecttype== ACCUMAPI){
                                    Recordtypeaccum.add(temprectype);
                                }
                                    
                                if(temprectype.sobjecttype== COPAYAPI){
                                    copayrecordtypes.put(temprectype.id,temprectype);
                                }
                                    
                                if(temprectype.sobjecttype== DRUGCOVAPI){
                                    recordtypes.put(temprectype.id,temprectype);
                                }
                            }
                            crdMappingvalue = [select id from mapping_values__c where creates_record__c = true and object_api__c =: CRDAPI limit 50000];
                        }
                        
                        //Start method for the batch                    
                        global void execute(List < sobject > scope) {

                            crdBuildOrderId = scope[0].id;
                            //=======================GATHER=======================================================================================
                            crdBuilderFallouts = new list < CRD_BuilderFallout__c > ();
                            
                            //-------------------STEP 1: Refetch records order by createddate.--------------------------------------
                            List < Pers_Full_Report__c > BatchScope;
                            List < Id > batchIds = new List < Id > ();
                            for(sobject batchrecord  : scope)
                                batchIds.add((id)batchrecord.get(IDVAL));
                            // Refresh records and order by createddate.
                            //collect all Ids
                            Schema.DescribeSObjectResult describeRec = Pers_Full_Report__c.sObjectType.getDescribe();
                            //get all field names
                            Map < String, Schema.SObjectField > fieldsMap = describeRec.fields.getMap();
                            String qry = BLANKVAL;
                            for (String s: fieldsMap.keyset()) {
                                qry += s + COMMAVAL;
                            }
                            qry = qry.left(qry.length() - 1); //removing the extra comma

                            
                            
                            
                            //-------------------STEP 2: Get the most recent changes for a CPE.--------------------------------------
                            list < decimal > allProvisionLineCombo = new list < decimal > ();
                            list<string> allProvisionLine = new list<string>();
                            set < string > allProvisionLineCombo_inScope = new set < string > ();
                            
                            map < string, map < decimal, set < decimal >>> cpeProvlines = new map < string, map < decimal, set < decimal >>> ();
                            //map < string, string > CPE_PSUIDmap = new map < string, string > ();
                            
                            //list<CRDBuildOrder__c> temcbon = Database.query('SELECT id,(select ' + qry + ' FROM Pers_Full_Report__r) from CRDBuildOrder__c WHERE id = ORDER BY Name DESC');
                            //This following logic will create a map of control plan effective vs Provision and line values to be applied for that CPE
                            boolean bPLVconflict = false;
                            Boolean missingBPLV = False;
                            boolean situsState=false;
                            
                            string provLV =BLANKVAL;
                            Set<String>lstProvisions = new Set<String>();
                            //Added by Sushant for Request 06329
                            for(Plan_Fallout__c pFallout : [Select id,Carrier_ID__c,Control__c,Effective_Date__c,PSUID__c 
                                            FROM 
                                              Plan_Fallout__c 
                                            WHERE Active__c = true limit 50000]){
                                        String key =BLANKVAL;
                                        String Control =BLANKVAL;
                                        String EffectiveDate=BLANKVAL;
                                        String Carrier= BLANKVAL;
                                        String PSUID= BLANKVAL;                
                                        if(pFallout.Control__c!= Null){
                                            Control= pFallout.Control__c;
                                        }
                                        if(pFallout.Effective_Date__c!= Null){
                                            EffectiveDate = String.valueof(pFallout.Effective_Date__c);
                                        }
                                        if(pFallout.Carrier_ID__c!= Null){
                                            Carrier = String.valueof(pFallout.Carrier_ID__c);
                                        }
                                        if(pFallout.PSUID__c!= Null){
                                            PSUID = pFallout.PSUID__c;
                                        }
                                        key = Control +SEMICOLVAL + EffectiveDate +SEMICOLVAL + Carrier +SEMICOLVAL + PSUID;
                                        setFalloutKey.add(key);     
                                    }
                            for (Pers_Full_Report__c cprx: Database.query(SELECTVAL + qry + QUERYEND)) {
                           
                                controlPreBuild = string.valueof(cprx.WS_CNTRL_NO__c);
                                effectiveDatePreBuild = String.valueof(cprx.WS_NEW_INFRC_EFF_DT__c);//Amit corrected the Date field for defect D-01017
                                carrierPreBuild = String.valueof(cprx.Carrier_ID__c);
                                psuidPreBuild = String.valueof(integer.valueof(cprx.WS_PSUID__c));//Amit corrected to remove leading 0's for ST# 1385 on 14 Jun, 2016
                                cbonPreBuild = cprx.CRD_Build_Order__c;
                                
                                //Added by JR to implement request 6154
                                provLV = VARP+cprx.WS_PROV_NUM__c+VARL+cprx.WS_LV_NO__c;
                                if(provLV==PROVLINEVAL){
                                    bNewProvLineValue = true;
                                }
                                 
                                if(provLV==PROVLINEVAL2||provLV==PROVLINEVAL3){
                                    lstProvisions.add(provLV);
                                  
                                    if(crdEffectiveDate == null){
                                        crdEffectiveDate = cprx.WS_NEW_INFRC_EFF_DT__c;
                                    }
                                }
                                    
                                cprx.Processed__c = true;
                                updatePERSList.add(cprx);
                                allProvisionLineCombo.add(cprx.WS_PROV_NUM__c);
                                allProvisionLine.add(VARP + cprx.WS_PROV_NUM__c + VARL + cprx.WS_LV_NO__c);
                                provision.put(cprx.WS_PROV_NUM__c, cprx);
                                missingBPLV = checkMissingBPLV(provision);
                                //if(!missingBPLV){
                                    if (!cpeProvlines.containskey(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c)) {
                                    provlines = new map < decimal, set < decimal >> ();
                                    set < decimal > lines = new set < decimal > ();
                                    lines.add(cprx.WS_LV_NO__c);
                                    provlines.put(cprx.WS_PROV_NUM__c, lines);
                                    cpeProvlines.put(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c, provlines);
                                    } else {
                                        map < decimal, set < decimal >> provlines = 
                                                                    cpeProvlines.get(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c);
                                        if (!provlines.containskey(cprx.WS_PROV_NUM__c)) {
                                            set < decimal > lines = new set < decimal > ();
                                            lines.add(cprx.WS_LV_NO__c);
                                            provlines.put(cprx.WS_PROV_NUM__c, lines);
                                            cpeProvlines.put(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c, provlines);
                                        } else {
                                            if(cprx.WS_PROV_NUM__c != 0){
                                                bPLVconflict = true;
                                            }
                                            
                                               
                                            set < decimal > lines = provlines.get(cprx.WS_PROV_NUM__c);
                                            lines.add(cprx.WS_LV_NO__c);
                                            provlines.put(cprx.WS_PROV_NUM__c, lines);
                                            cpeProvlines.put(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c, provlines);
                                        }
                                    }
                                   
                            if( (cprx.What_is_the_carrier__c==CARRIERHNO && cprx.WS_MLR_CONTRACT_SITUS_ST__c!=null 
                                && cprx.WS_MLR_CONTRACT_SITUS_ST__c.length()!=2))
                            
                             {
                                        situsState=true;
                             }
                             
                            }
                            //Added by Sushant for Request 06329
                                    for(String errFallout : setFalloutKey){ 
                                        String crdKey =BLANKVAL;
                                        String Control =BLANKVAL;
                                        String EffectiveDate=BLANKVAL;
                                        String Carrier=BLANKVAL;
                                        String PSUID=BLANKVAL;                    
                                        String[] strFallout = errFallout.split(SEMICOLVAL);                    
                                        if(strFallout.size()>=1 && strFallout[0] != Null &&  strFallout[0] != BLANKVAL){
                                            Control = controlPreBuild;
                                        }
                                        if(strFallout.size()>=2 && strFallout[1] != Null &&  strFallout[1] != BLANKVAL){
                                            EffectiveDate = effectiveDatePreBuild;
                                        }
                                        if(strFallout.size()>=3 && strFallout[2] != Null &&  strFallout[2] != BLANKVAL){
                                            Carrier = carrierPreBuild;
                                        }
                                        if(strFallout.size()==4 && strFallout[3] != Null &&  strFallout[3] != BLANKVAL){
                                            PSUID = psuidPreBuild;
                                        }
                                        crdKey = Control + SEMICOLVAL + EffectiveDate + SEMICOLVAL + Carrier + SEMICOLVAL + PSUID;
                                        if(!setFalloutKey.isempty() && setFalloutKey.contains(crdKey)){
                                              preBuildFallout = true;                                               
                                        }
                                    }                                          
                                        
                                
                            //Added by JR to implement request 6154
                            if(lstProvisions.size()==2){                                
                              bProvLineValue = true;
                            }
                          
                            /*for (Pers_Full_Report__c cprx: updatePERSList) {
                                if (!cpeProvlines.containskey(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c)) {
                                    provlines = new map < decimal, set < decimal >> ();
                                    set < decimal > lines = new set < decimal > ();
                                    lines.add(cprx.WS_LV_NO__c);
                                    provlines.put(cprx.WS_PROV_NUM__c, lines);
                                    cpeProvlines.put(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c, provlines);
                                } else {
                                    map < decimal, set < decimal >> provlines = cpeProvlines.get(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c);
                                    if (!provlines.containskey(cprx.WS_PROV_NUM__c)) {
                                        set < decimal > lines = new set < decimal > ();
                                        lines.add(cprx.WS_LV_NO__c);
                                        provlines.put(cprx.WS_PROV_NUM__c, lines);
                                        cpeProvlines.put(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c, provlines);
                                    } else {
                                        set < decimal > lines = provlines.get(cprx.WS_PROV_NUM__c);
                                        lines.add(cprx.WS_LV_NO__c);
                                        provlines.put(cprx.WS_PROV_NUM__c, lines);
                                        cpeProvlines.put(cprx.ControlPlanEffective__c + COMMAVAL + cprx.PERStimestamp__c, provlines);
                                    }
                                }
                            }*/

                            //Create CRD for PERS report which passed through entry condition
                            if(bPLVconflict){
                                hasBuilderFallout = true;
                                CRDBuildOrder__c tempCBON = [select id,ControlPlanEffective__c,FalloutCase__c,crd__r.Account__c
                                                ,crd__r.Effective_Date__c,Crd__c,PERS_timestamp__c  
                                              from 
                                                CRDBuildOrder__c 
                                              where id =:batchIds limit 1];
                                case existingFalloutCase;
                                if(tempCBON.FalloutCase__c == null){
                                    //Amit updated Timestamp to tempCBON.PERS_timestamp__c from System.now()
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CRDBUILDERFALVAL
                                                                                   ,CONFLICTERRVAL
                                                                                   , ERRMSGVAL
                                                                                   ,tempCBON.PERS_timestamp__c
                                                                                   ,tempCBON.ControlPlanEffective__c
                                                                                   ,tempCBON.crd__r.Account__c
                                                                                   ,tempCBON.crd__r.Effective_Date__c
                                                                                   ,tempCBON.crd__c);
                                    database.insert(existingFalloutCase);
                                    tempCBON.FalloutCase__c = existingFalloutCase.id;
                                    database.update(tempCBON);
                                    CRD_BuilderFallout__c tempcbFallout = new CRD_BuilderFallout__c(Error_Description__c = CONFLICTERRVAL
                                                                    , Type__c = ERRMSGVAL
                                                                    ,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);
                                }else{                                       
                                    //Update existing fallout case
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(tempCBON.FalloutCase__c
                                                                         ,CRDBUILDERFALVAL
                                                                         ,CONFLICTERRVAL
                                                                         ,ERRMSGVAL
                                                                         ,tempCBON.PERS_timestamp__c
                                                                         ,tempCBON.ControlPlanEffective__c
                                                                         ,tempCBON.crd__r.Account__c
                                                                         ,tempCBON.crd__r.Effective_Date__c
                                                                         ,tempCBON.crd__c);
                                    database.update(existingFalloutCase);                                   
                                    CRD_BuilderFallout__c tempcbFallout = 
                                                            new CRD_BuilderFallout__c(Error_Description__c = CONFLICTERRVAL, Type__c = ERRMSGVAL,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);                                     
                          
                                }
                                
                            }else if(BPLVMissing){
                                hasBuilderFallout = true;
                                CRDBuildOrder__c tempCBON = [select id,ControlPlanEffective__c,FalloutCase__c,crd__r.Account__c
                                                ,crd__r.Effective_Date__c,Crd__c,PERS_timestamp__c  
                                              from 
                                                CRDBuildOrder__c 
                                              where id =:batchIds limit 1];
                                case existingFalloutCase;
                                if(tempCBON.FalloutCase__c == null){
                                    //Amit updated Timestamp to tempCBON.PERS_timestamp__c from System.now()
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CRDBUILDERFALVAL
                                                                                   ,CONFLICTERRVAL2
                                                                                   , ERRMSGVAL2
                                                                                   ,tempCBON.PERS_timestamp__c
                                                                                   ,tempCBON.ControlPlanEffective__c
                                                                                   ,tempCBON.crd__r.Account__c
                                                                                   ,tempCBON.crd__r.Effective_Date__c
                                                                                   ,tempCBON.crd__c);
                                    database.insert(existingFalloutCase);
                                    tempCBON.FalloutCase__c = existingFalloutCase.id;
                                    database.update(tempCBON);
                                    CRD_BuilderFallout__c tempcbFallout = new CRD_BuilderFallout__c(Error_Description__c = CONFLICTERRVAL2
                                                                    , Type__c = ERRMSGVAL2
                                                                    ,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);
                                }else{                                       
                                    //Update existing fallout case
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(tempCBON.FalloutCase__c
                                                                         ,CRDBUILDERFALVAL
                                                                         ,CONFLICTERRVAL2
                                                                         ,ERRMSGVAL2
                                                                         ,tempCBON.PERS_timestamp__c
                                                                         ,tempCBON.ControlPlanEffective__c
                                                                         ,tempCBON.crd__r.Account__c
                                                                         ,tempCBON.crd__r.Effective_Date__c
                                                                         ,tempCBON.crd__c);
                                    database.update(existingFalloutCase);                                   
                                    CRD_BuilderFallout__c tempcbFallout = new CRD_BuilderFallout__c(Error_Description__c = CONFLICTERRVAL2
                                                                    , Type__c = ERRMSGVAL2
                                                                    ,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);                                     
                          
                                }
                            }
                            //Implenebtation for Request #06329
                           
                            else if(preBuildFallout && !passPreBuildFallout){
                                hasBuilderFallout = true;
                                CRDBuildOrder__c tempCBON = [select id,ControlPlanEffective__c,Plan_Fallout__c,FalloutCase__c
                                                ,crd__r.Account__c,crd__r.Effective_Date__c,Crd__c,PERS_timestamp__c  
                                                from 
                                                  CRDBuildOrder__c 
                                                where id =:batchIds limit 1];
                                case existingFalloutCase;
                                if(tempCBON.FalloutCase__c == null && (tempCBON.plan_fallout__c != NULL && tempCBON.plan_fallout__c != true)){
                                    //Amit updated Timestamp to tempCBON.PERS_timestamp__c from System.now()
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CRDBUILDERFALVAL
                                                                                   ,SYSTEM.LABEL.ERR0294
                                                                                   , CONFLICTERRVAL3
                                                                                   ,tempCBON.PERS_timestamp__c
                                                                                   ,tempCBON.ControlPlanEffective__c
                                                                                   ,tempCBON.crd__r.Account__c
                                                                                   ,tempCBON.crd__r.Effective_Date__c
                                                                                   ,tempCBON.crd__c);
                                    database.insert(existingFalloutCase);
                                    tempCBON.FalloutCase__c = existingFalloutCase.id;
                                    tempCBON.Plan_Fallout__c = true;
                                    database.update(tempCBON);
                                    CRD_BuilderFallout__c tempcbFallout = new CRD_BuilderFallout__c(Error_Description__c = SYSTEM.LABEL.ERR0294
                                                                    , Type__c = CONFLICTERRVAL3
                                                                    ,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);
                                }else{                                       
                                    //Update existing fallout case
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(tempCBON.FalloutCase__c
                                                                         ,CRDBUILDERFALVAL
                                                                         ,SYSTEM.LABEL.ERR0294
                                                                         ,CONFLICTERRVAL3
                                                                         ,tempCBON.PERS_timestamp__c
                                                                         ,tempCBON.ControlPlanEffective__c
                                                                         ,tempCBON.crd__r.Account__c
                                                                         ,tempCBON.crd__r.Effective_Date__c
                                                                         ,tempCBON.crd__c);
                                    database.update(existingFalloutCase);                                   
                                    CRD_BuilderFallout__c tempcbFallout = new CRD_BuilderFallout__c(Error_Description__c = SYSTEM.LABEL.ERR0294
                                                                    , Type__c = CONFLICTERRVAL3
                                                                    ,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);                                     
                          
                                }
                            }
                            //Implementation for ST# 155 Start
                            else if(situsState){
                                hasBuilderFallout = true;
                                CRDBuildOrder__c tempCBON = [select id,ControlPlanEffective__c,FalloutCase__c,crd__r.Account__c
                                                ,crd__r.Effective_Date__c,Crd__c,PERS_timestamp__c  
                                              from 
                                                CRDBuildOrder__c 
                                              where id =:batchIds limit 1];
                                case existingFalloutCase;
                                if(tempCBON.FalloutCase__c == null){
                                    //Amit updated Timestamp to tempCBON.PERS_timestamp__c from System.now()
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CRDBUILDERFALVAL
                                                                                   ,ERRMSGVAL3
                                                                                   ,ERRMSGVAL4
                                                                                   ,tempCBON.PERS_timestamp__c
                                                                                   ,tempCBON.ControlPlanEffective__c
                                                                                   ,tempCBON.crd__r.Account__c
                                                                                   ,tempCBON.crd__r.Effective_Date__c
                                                                                   ,tempCBON.crd__c);
                                    database.insert(existingFalloutCase);
                                    tempCBON.FalloutCase__c = existingFalloutCase.id;
                                    database.update(tempCBON);
                                    CRD_BuilderFallout__c tempcbFallout = new CRD_BuilderFallout__c(Error_Description__c = ERRMSGVAL3
                                                                    , Type__c = SAVEERRORS
                                                                    ,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);
                                }else{                                       
                                    //Update existing fallout case
                                    existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(tempCBON.FalloutCase__c
                                                                         ,CRDBUILDERFALVAL
                                                                         ,ERRMSGVAL3
                                                                         ,ERRMSGVAL4
                                                                         ,tempCBON.PERS_timestamp__c
                                                                         ,tempCBON.ControlPlanEffective__c
                                                                         ,tempCBON.crd__r.Account__c
                                                                         ,tempCBON.crd__r.Effective_Date__c
                                                                         ,tempCBON.crd__c);
                                    database.update(existingFalloutCase);                                   
                                    CRD_BuilderFallout__c tempcbFallout = new CRD_BuilderFallout__c(Error_Description__c = ERRMSGVAL3
                                                                    , Type__c = SAVEERRORS
                                                                    ,caseid__c = existingFalloutCase.id);
                                    database.insert(tempcbFallout);                                     
                          
                                }
                            }
                            //Implementation for ST# 155 End
                            else{
                                //throw new CB_BuildStep.MerchandiseException(JSON.serialize(cpeProvlines));
                                CRDBuilderfromMapping(allProvisionLine, cpeProvlines);
                            }

                        }



                            
                        public
                        case addcase() {
                            return new
                        case ();
                        }

                        //ST#263:-this method is used to find the missing provision from coming BPLVs.
                        public Boolean checkMissingBPLV(map < decimal, Pers_Full_Report__c> provision) {
                            BPLVMissing = false;
                            for(ListOfBPLV__c dcimalPV:ListOfBPLV__c.getAll().values()){
                            
                                if(!provision.ContainsKey(decimal.valueof(dcimalPV.Name))){
                                    BPLVMissing = true;
                                    break;
                                }
                            }
                            return BPLVMissing;
                        }
                            
                        //this method is used to set the value to sobject and also check for Conflict Errors
                        public Boolean createSobjects(list < mappingValueWrapper > currentWrapRecord) {
                            //Map is used to count the number of copays created for each type
                            map < string, integer > copayscount = new map < string, integer > ();
                            //This is used to see if we have any conflict error
                            Boolean ConflictError = false;
                            //Set field values to Sobject
                            for (mappingValueWrapper tempwrapreccord: currentWrapRecord) {
                                //Used for checking conflict, it will have the field name and value set for this instance of sObject
                                map < string, String > SobjectValues = new map < string, String > ();
                                
                                set<string> conflictFields = new set<string>();
                                map<string,String> FieldProvisions = new map<string,string>();
                                integer currentmappingcounter = 0;
                                list<Mapping_Values__c> newobjectVAlues = new list<Mapping_Values__c>();
                                //tempwrapreccord.ObjectFieldvalaues = newobjectVAlues;
                                //for (Mapping_Values__c currentmapping: tempwrapreccord.ObjectFieldvalaues) {
                               //Added by Abhishek for ST# 541
                                if(tempwrapreccord.sobjecttype == CRDAPI){
                                    if(String.valueof(tempwrapreccord.currentrecord.get('Integrate_with_Medical__c')) == 'Yes'
                                        && String.valueof(tempwrapreccord.currentrecord.get('Plan_Platform__c')) != 'Aetna Student Health'){
                                        createAccumus = true;
                                    }
                                }
                                //Ends
                                for( integer i = 0 ; i  <  tempwrapreccord.ObjectFieldvalaues.size() ; i++) {    
                                    Mapping_Values__c currentmapping = tempwrapreccord.ObjectFieldvalaues[i];
                                    if(!currentmapping.Delete_Record__c){
                                        if(FieldProvisions.containskey(currentmapping.field_api__c)){
                                            FieldProvisions.put(currentmapping.field_api__c,FieldProvisions.get(currentmapping.field_api__c) + ' [MappingId: ' + currentmapping.id +  '| P' + currentmapping.provision__c + VARL + currentmapping.Line_value__c + '],');
                                    }
                                        else{
                                            FieldProvisions.put(currentmapping.field_api__c,  ' [MappingId: ' + currentmapping.id +  '| P' + currentmapping.provision__c + VARL + currentmapping.Line_value__c + '],');
                                        }  
                                        //Check if this mapping is dependent on any Criteria
                                        if (!(currentmapping.Mapping_Value_Criterias__r.size() > 0)) {
                                            newobjectVAlues.add(currentmapping);
                                            if(currentmapping.field_type__C != 'Lookup' && currentmapping.field_api__C != MULTIPLIERAPI){
                                                set < decimal > lines = new set < decimal > ();
                                                if(provlines.containskey(currentmapping.provision__c))
                                                    lines = provlines.get(currentmapping.provision__c);
                                                lines.add(currentmapping.Line_value__c);
                                                provlines.put(currentmapping.provision__c,lines);
                                            }
                                            //Set this value as there is no criteria to adhere to.
                                            if(currentmapping.field_api__c == 'Enroll_in_RxCheck__c'){
                                            }
                                            else{                                   
                                                if (SobjectValues.containskey(currentmapping.field_api__c)) {
                                                    //Check if this field is set to some other value 
                                                    if (SobjectValues.get(currentmapping.field_api__c) != currentmapping.fieldvalue__c && currentmapping.Field_Type__c != 'Lookup') {
                                                        ConflictError = true;
                                                        conflictFields.add(currentmapping.field_api__c);
                                                                                                    
                                                    }
                                                } else {
                                                    SobjectValues.put(currentmapping.field_api__c, currentmapping.fieldvalue__c);

                                                }
                                            }
                                            //currentmappingcounter++;
                                        } else {
                                            //as there are some critria's this mapping value is dependent on check weather all the criteria are satisfied
                                            Boolean CriteriaSatisfied = true;

                                            for (Mapping_Value_Criteria__c Mvc: currentmapping.Mapping_Value_Criterias__r) {
                                                boolean tempCriteriaSatisfied = true;
                                                Sobject Crtieriaobject = mappingSobjectMap.get(Mvc.Mapping_value_Criteria__c);
                                                Object Crtieriaobjectvalue = Crtieriaobject.get(Mvc.Mapping_Column__r.Field_API__c);
                                                set < string > Crtieriaobjectvalues = new set < string > ();
                                                //Check if the critria is or based on multiple values
                                                
                                                if(Crtieriaobjectvalue == null || string.valueof(Crtieriaobjectvalue) == null)
                                                    tempCriteriaSatisfied = tempCriteriaSatisfied && false;
                                                    
                                                
                                                
                                                if (Mvc.Condition_Type__c == 'Single-Option') {
                                                    Crtieriaobjectvalues.add(Mvc.Mapping_Value__c);
                                                } else {
                                                    if (Mvc.Condition_Type__c == 'Multi-Option') {
                                                        Crtieriaobjectvalues.addall(((String) Mvc.Mapping_Value__c).split(SEMICOLVAL));
                                                    }
                                                }
                                                if(Crtieriaobjectvalue == null){
                                                    if(Crtieriaobjectvalues.size() == 0){
                                                        tempCriteriaSatisfied = tempCriteriaSatisfied && true;
                                                    }
                                                    else{
                                                        tempCriteriaSatisfied = tempCriteriaSatisfied && false;
                                                    }
                                                }
                                                else{
                                                    String StringCriteriaobjectvalue = String.valueof(Crtieriaobjectvalue);
                                                    if(Crtieriaobjectvalues.contains(StringCriteriaobjectvalue))
                                                        tempCriteriaSatisfied = tempCriteriaSatisfied && true;
                                                    else
                                                        tempCriteriaSatisfied = tempCriteriaSatisfied && false;
                                                }
                                                if(Mvc.Negate_Rule__c && Crtieriaobjectvalue !=null)
                                                    tempCriteriaSatisfied = !tempCriteriaSatisfied;
                                                if(tempCriteriaSatisfied)
                                                   system.debug('mvcid' + mvc.id);
                                                else{

                                                }
                                                                                                                                                                        
                                                CriteriaSatisfied = CriteriaSatisfied && tempCriteriaSatisfied;
                                            }                                           
                                            if (CriteriaSatisfied) {
                                                newobjectVAlues.add(currentmapping);
                                                //currentmappingcounter++;
                                                //If all criteria as satisfied apply this mapping value and also check if there is no conflict
                                                if(currentmapping.field_type__C != 'Lookup'){
                                                    set < decimal > lines = new set < decimal > ();
                                                    if(provlines.containskey(currentmapping.provision__c))
                                                        lines = provlines.get(currentmapping.provision__c);
                                                    lines.add(currentmapping.Line_value__c);
                                                    provlines.put(currentmapping.provision__c,lines);
                                                }
                                                if(currentmapping.field_api__c == 'Enroll_in_RxCheck__c'){
                                                }
                                                else{
                                                    if (SobjectValues.containskey(currentmapping.field_api__c)) {
                                                        if (SobjectValues.get(currentmapping.field_api__c) != currentmapping.fieldvalue__c) {
                                                            ConflictError = true;
                                                            conflictFields.add(currentmapping.field_api__c);

                                                        }
                                                    } else {
                                                        SobjectValues.put(currentmapping.field_api__c, currentmapping.fieldvalue__c);
                                                        
                                                    }      
                                                }
                                            }
                                            else{
                                                tempwrapreccord.ObjectFieldvalaues.remove(i);
                                                i = i - 1;
                                            }
                                        }
                                    }
                                    else{
                                        set < decimal > lines = new set < decimal > ();
                                        if(provlines.containskey(currentmapping.provision__c))
                                            lines = provlines.get(currentmapping.provision__c);
                                        lines.add(currentmapping.Line_value__c);
                                        provlines.put(currentmapping.provision__c,lines);
                                        tempwrapreccord.Deleteobjects.add(currentmapping);
                                    }
                                    for(string Fieldconflict : conflictFields){
                                        ConflictErrorsMesseges.add(Fieldconflict + ',Conflict Error on Object :'+tempwrapreccord.sobjecttype +'Field :'+Fieldconflict);
                                        ConflictErrorsMessegesmap.put(Fieldconflict + ',Conflict Error on Object :'+tempwrapreccord.sobjecttype +'Field :'+Fieldconflict,FieldProvisions.get(Fieldconflict));
                                        
                                    }
                                } 
                                tempwrapreccord.ObjectFieldvalaues = newobjectVAlues;
                                for(Mapping_Values__c currentmapping :tempwrapreccord.ObjectFieldvalaues){
                                    if(!currentmapping.Delete_Record__c){
                                        if(currentmapping.fieldvalue__c == null){
                                            if(currentmapping.Field_Type__c =='Lookup') {
                                                tempwrapreccord.currentrecord.put(currentmapping.field_api__c,currentmapping.fieldvalue__c);
                                                
                                            }
                                        }
                                        else
                                        {
                        if(currentmapping.Field_api__c != MULTIPLIERAPI){
                                                if (currentmapping.field_type__c == 'Boolean') {
                                                    tempwrapreccord.currentrecord.put(currentmapping.field_api__c, Boolean.valueof(currentmapping.fieldvalue__c));
                                                }
                                                if (currentmapping.field_type__c == 'Picklist') {
                                                    tempwrapreccord.currentrecord.put(currentmapping.field_api__c, String.valueof(currentmapping.fieldvalue__c));
                                                }
                                                if (currentmapping.field_type__c == 'String') {
                                                    //Added By Nitish for 7029
                                                    if((currentmapping.Object_API__c.equalsIgnoreCase(DCDLAPI) && currentmapping.Field_api__c.equalsIgnoreCase('Formulary_Group__c'))){
                                                        //do nothing
                                                    }
                                                    else{
                                                    tempwrapreccord.currentrecord.put(currentmapping.field_api__c, String.valueof(currentmapping.fieldvalue__c));
                                                    }
                                                }
                                                if (currentmapping.field_type__c == IDVAL1) {
                                                    tempwrapreccord.currentrecord.put(currentmapping.field_api__c, String.valueof(currentmapping.fieldvalue__c));
                                                }
                                                if (currentmapping.field_type__c == 'Number') {
                                                            tempwrapreccord.currentrecord.put(currentmapping.field_api__c,  ((currentmapping.fieldvalue__c == null) || (currentmapping.fieldvalue__c == BLANKVAL)) ? null : Decimal.valueof(currentmapping.fieldvalue__c));
                                                }
                                                if (currentmapping.field_type__c == 'Date') {
                                                    tempwrapreccord.currentrecord.put(currentmapping.field_api__c, Date.parse(currentmapping.fieldvalue__c));
                        }
                                            }            
                                        }                               
                                        if (tempwrapreccord.sobjecttype == CRDAPI) {
                                           /* if (String.valueof(tempwrapreccord.currentrecord.get('Insured_Type__c')) == 'Self Insured'){
                                                tempwrapreccord.currentrecord.put('Enroll_in_RxCheck__c','No');
                                            }
                                            else{
                                                tempwrapreccord.currentrecord.put('Enroll_in_RxCheck__c','Yes');
                                            }
                                            */
                                            if (String.valueof(tempwrapreccord.currentrecord.get('Insured_Type__c')) == 'Self Insured' && tempwrapreccord.currentrecord.get('Pharmacy_Advisor__c') != null && Boolean.valueof(tempwrapreccord.currentrecord.get('Pharmacy_Advisor__c'))) {
                                                //Add code to create Fallout Record
                                            }
                                            for (String Copaytype: copayscount.keyset()) {
                                                tempwrapreccord.currentrecord.put(Copaytype.replace('Plan_Type_', BLANKVAL).replace('__c', '_Number_of_Tiers__c'), String.valueof(copayscount.get(Copaytype)));
                                            }
                                        }
                                        if (currentmapping.Object_API__c == CRDAPI) {
                                            Integer currentcheckboxcount = 0;
                                            if (currentmapping.field_type__c == 'Boolean' && Boolean.valueof(currentmapping.fieldvalue__c)) {
                                                if (currentmapping.field_api__c.startsWith('Plan')) {
                                                    if (!copayscount.containskey(currentmapping.field_api__c)) {
                                                        copayscount.put(currentmapping.field_api__c, 1);
                                                    } else {
                                                        currentcheckboxcount = copayscount.get(currentmapping.field_api__c) + 1;
                                                        copayscount.put(currentmapping.field_api__c, currentcheckboxcount);
                                                    }
                                                }
                                                tempwrapreccord.currentrecord.put(currentmapping.field_api__c, Boolean.valueof(currentmapping.fieldvalue__c));
                                            }
                                        }
                                    }
                                                           
                                }
                                //if(tempwrapreccord.sobjecttype == 'AccumulationSpecificDrug__c')
                               
                            }
                                            
                            for (mappingValueWrapper tempwrapreccord: currentWrapRecord) {

                                //Apply Field Values to childobjects

                                Boolean conflictchild = createSobjects(tempwrapreccord.childobjects);
                                //Set conflict flaff in case either this record or any record of child has conflict
                                ConflictError = ConflictError || conflictchild;
                                //}
                            }
                            return ConflictError;
                        }
                        //This method will create a crd and related object records for each cpe and apply the pers report to this CRD
                        public list < mappingValueWrapper > CRDBuilderfromMapping(list < string > lstlinename, map < string, map < decimal, set < decimal >>> cpeProvlines) {
                            if(String.isEmpty(crdBuildOrderId)){
                                crdBuildOrderId = updatePERSList[0].CRD_Build_Order__c;
                            }
                            CRDBuildOrder__c crdbuild = new CRDBuildOrder__c();
                                
                            for(CRDBuildOrder__c crdbuildorder : [select id,PERS_timestamp__c,Control_Plan_Effective__c,FalloutCase__c,crd__r.Account__c,crd__r.Effective_Date__c,Crd__c  from CRDBuildOrder__c where id =:crdBuildOrderId]){
                                crdbuild = crdbuildorder;
                            }
                            mappingSobjectMap = new map < string, sobject > ();
                            map < id, Mapping_Values__c > mappingvaluesRootList 
                                                    = new map < id, Mapping_Values__c > ([select 
                                                                                                Id, RecordTypeId__c, Object_API__c, ParentMappingValue__c, Creates_Record__c, Provision__c
                                                                                                , Line_value__c, Field_API__c, Field_Type__c, FieldValue__c, Parent_Field_Value__c,Delete_Record__c
                                                                                                , (select 
                                                                                                        id, Mapping_Column__c, Mapping_Value__c, Mapping_Column__r.Field_Type__c, Mapping_Column__r.Object__c
                                                                                                        , Mapping_Column__r.Field_API__c, Mapping_value_Criteria__c,name, Parent_Mapping_value__c, Negate_Rule__c
                                                                                                        , Condition_Type__c 
                                                                                                    from 
                                                                                                        Mapping_Value_Criterias__r) 
                                                                                        from 
                                                                                            Mapping_Values__c 
                                                                                        where 
                                                                                            (line_valueid__r.name IN : lstlinename 
                                                                                                    AND Line_ValueID__r.Active__c = true 
                                                                                                    AND Line_ValueID__r.Provision_ID__r.Active__c = true) 
                                                                                            or Provision__c = null]);
                            list < mappingValueWrapper > returnvar = new list < mappingValueWrapper > ();
                            map < decimal, map < decimal, map < id, list < Mapping_Values__c >>> > ProvlineMappingvales = new map < decimal, map < decimal, map < id, list < Mapping_Values__c >>> > ();

                            //Map<id,Mapping_Values__c> defaultMappingsforGlobal = new Map<id,Mapping_Values__c>()
                            for (Mapping_Values__c tempMappingValue: mappingvaluesRootList.values()) {
                                if (!ProvlineMappingvales.containskey(tempMappingValue.Provision__c)) {
                                    map < decimal, map < id, list < Mapping_Values__c >>> linemappingvalue = new map < decimal, map < id, list < Mapping_Values__c >>> ();
                                    map < id, list < Mapping_Values__c >> MappingValueFieldValues = new map < id, list < Mapping_Values__c >> ();
                                    if (!tempMappingValue.Creates_Record__c) {
                                        list < Mapping_Values__c > fieldvaluelst = new list < Mapping_Values__c > ();
                                        if (MappingValueFieldValues.containskey(tempMappingValue.ParentMappingValue__c)) fieldvaluelst = MappingValueFieldValues.get(tempMappingValue.ParentMappingValue__c);
                                        fieldvaluelst.add(tempMappingValue);
                                        MappingValueFieldValues.put(tempMappingValue.ParentMappingValue__c, fieldvaluelst);
                                        linemappingvalue.put(tempMappingValue.Line_value__c, MappingValueFieldValues);
                                        ProvlineMappingvales.put(tempMappingValue.Provision__c, linemappingvalue);
                                    }
                                } else {
                                    map < decimal, map < id, list < Mapping_Values__c >>> linemappingvalue = ProvlineMappingvales.get(tempMappingValue.Provision__c);
                                    if (!linemappingvalue.containskey(tempMappingValue.Line_value__c)) {
                                        map < id, list < Mapping_Values__c >> MappingValueFieldValues = new map < id, list < Mapping_Values__c >> ();
                                        if (!tempMappingValue.Creates_Record__c) {
                                            list < Mapping_Values__c > fieldvaluelst = new list < Mapping_Values__c > ();
                                            if (MappingValueFieldValues.containskey(tempMappingValue.ParentMappingValue__c)) fieldvaluelst = MappingValueFieldValues.get(tempMappingValue.ParentMappingValue__c);
                                            fieldvaluelst.add(tempMappingValue);
                                            MappingValueFieldValues.put(tempMappingValue.ParentMappingValue__c, fieldvaluelst);
                                            linemappingvalue.put(tempMappingValue.Line_value__c, MappingValueFieldValues);
                                            ProvlineMappingvales.put(tempMappingValue.Provision__c, linemappingvalue);
                                        }
                                    } else {
                                        //map<decimal,map<id,list<Mapping_Values__c>>> linemappingvalue = ProvlineMappingvales.get(tempMappingValue.Provision__c);
                                        map < id, list < Mapping_Values__c >> MappingValueFieldValues = linemappingvalue.get(tempMappingValue.Line_value__c);
                                        if (!tempMappingValue.Creates_Record__c) {
                                            list < Mapping_Values__c > fieldvaluelst = new list < Mapping_Values__c > ();
                                            if (MappingValueFieldValues.containskey(tempMappingValue.ParentMappingValue__c)) fieldvaluelst = MappingValueFieldValues.get(tempMappingValue.ParentMappingValue__c);
                                            fieldvaluelst.add(tempMappingValue);
                                            MappingValueFieldValues.put(tempMappingValue.ParentMappingValue__c, fieldvaluelst);
                                            linemappingvalue.put(tempMappingValue.Line_value__c, MappingValueFieldValues);
                                            ProvlineMappingvales.put(tempMappingValue.Provision__c, linemappingvalue);
                                        }
                                    }
                                }
                            }
                            //map<string,mappingValueWrapper> CPECRDmap = new map<string,mappingValueWrapper>();
                            //TODO:- Create CRD With common Actions 
                            
                            for (string tempCPE: cpeProvlines.keyset()) {
                                provlines = new map < decimal, set < decimal >> ();
                                //CPECRDmap.put(tempcpe,new mappingValueWrapper((sobject)commonaction(tempCPE),CRDAPI));

                                //Get All the mapping values to be applied to current CRD based on Controlplaneffective
                                map < string, map < id, list < Mapping_Values__c >>> provlinesForcurrentCPE = new map < string, map < id, list < Mapping_Values__c >>> ();
                                
                                for (Decimal Provline: cpeProvlines.get(tempCPE).keyset()) {
                                    if (cpeProvlines.get(tempCPE).containskey(Provline)) {
                                        for (decimal linevalue: cpeProvlines.get(tempCPE).get(Provline)) {
                                            if (ProvlineMappingvales.containskey(Provline) && ProvlineMappingvales.get(Provline).containskey(linevalue)) {
                                                for (id mappingid: ProvlineMappingvales.get(Provline).get(linevalue).keyset()) {
                                                    if (provlinesForcurrentCPE.containskey((mappingvaluesRootList.get(mappingid).Object_API__c).toLowerCase())) {
                                                        map < id, list < Mapping_Values__c >> parentmappings = provlinesForcurrentCPE.get((mappingvaluesRootList.get(mappingid).Object_API__c).toLowerCase());
                                                        if (parentmappings.containskey(mappingid)) {
                                                            list < Mapping_Values__c > tempmappings = parentmappings.get(mappingid);
                                                            tempmappings.addall(ProvlineMappingvales.get(Provline).get(linevalue).get(mappingid));
                                                            parentmappings.put(mappingid, tempmappings);
                                                            provlinesForcurrentCPE.put((mappingvaluesRootList.get(mappingid).Object_API__c).toLowerCase(), parentmappings);
                                                        } else {
                                                            list < Mapping_Values__c > tempmappings = ProvlineMappingvales.get(Provline).get(linevalue).get(mappingid);
                                                            //tempmappings.addall(ProvlineMappingvales.get(Provline).get(linevalue).get(mappingid));
                                                            parentmappings.put(mappingid, tempmappings);
                                                            provlinesForcurrentCPE.put((mappingvaluesRootList.get(mappingid).Object_API__c).toLowerCase(), parentmappings); //provlinesForcurrentCPE.put(mappingid,ProvlineMappingvales.get(Provline).get(linevalue).get(mappingid));
                                                        }
                                                    } else {
                                                        map < id, list < Mapping_Values__c >> parentmappings = new map < id, list < Mapping_Values__c >> ();
                                                        list < Mapping_Values__c > tempmappings = ProvlineMappingvales.get(Provline).get(linevalue).get(mappingid);
                                                        parentmappings.put(mappingid, tempmappings);
                                                        provlinesForcurrentCPE.put((mappingvaluesRootList.get(mappingid).Object_API__c).toLowerCase(), parentmappings);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if (ProvlineMappingvales.containskey(null) && ProvlineMappingvales.get(null).containskey(null)) {
                                    for (id provid: ProvlineMappingvales.get(null).get(null).keyset()) {
                                        if (provid != null) {
                                            for (Mapping_Values__c currentMappinvalue: ProvlineMappingvales.get(null).get(null).get(provid)) {
                                                map < id, list < Mapping_Values__c >> parentmappings = new map < id, list < Mapping_Values__c >> ();
                                                if (provlinesForcurrentCPE.containskey(currentMappinvalue.Object_API__c.toLowerCase())) {
                                                    parentmappings = provlinesForcurrentCPE.get(currentMappinvalue.Object_API__c.toLowerCase());
                                                }
                                                list < Mapping_Values__c > tempmappingvaluelst = new list < Mapping_Values__c > ();
                                                if (parentmappings.containskey(currentMappinvalue.ParentMappingValue__C)) {
                                                    tempmappingvaluelst = parentmappings.get(currentMappinvalue.ParentMappingValue__C);

                                                }
                                                tempmappingvaluelst.add(currentMappinvalue);
                                                parentmappings.put(currentMappinvalue.ParentMappingValue__C, tempmappingvaluelst);
                                                provlinesForcurrentCPE.put(currentMappinvalue.Object_API__c.toLowerCase(), parentmappings);
                                            }
                                        }
                                    }
                                }



                                //Fetch all the dc frud list group and apply the reocrds values
                                map < id, list < mappingValueWrapper >> DC_Drug_List_Group_wrappers = getWrapperRecords('DC_Drug_List_Group__c', mappingvaluesRootList, provlinesForcurrentCPE);
                                set < id > Drug_Coverage_ids = new set < id > ();
                                Drug_Coverage_ids.addall(DC_Drug_List_Group_wrappers.keyset());
                                if (provlinesForcurrentCPE.containskey(DRUGCOVAPI.toLowerCase())) {
                                    Drug_Coverage_ids.addAll(provlinesForcurrentCPE.get(DRUGCOVAPI.toLowerCase()).keyset());
                                }
                                //Fetch all the dRUG COVERAGE and apply the reocrds values
                                list < mappingValueWrapper > Drug_Coverage_wrappers = new list < mappingValueWrapper > ();
                                for (id currentMappingId: Drug_Coverage_ids) {

                                    sobject s = GlobalDescribe.get(DRUGCOVAPI).newsobject();
                                    mappingSobjectMap.put(currentMappingId, s);
                                    if (mappingvaluesRootList.get(currentMappingId).recordtypeid__c != null && mappingvaluesRootList.get(currentMappingId).recordtypeid__c != BLANKVAL) {
                                        s.put('recordtypeid', mappingvaluesRootList.get(currentMappingId).recordtypeid__c);
                                    }
                                    mappingValueWrapper SobjectRecord = new mappingValueWrapper(s, DRUGCOVAPI);
                                    SobjectRecord.ObjectFieldvalaues = provlinesForcurrentCPE.get(DRUGCOVAPI.toLowerCase()).get(currentMappingId);
                                    if (DC_Drug_List_Group_wrappers.containskey(currentMappingId)) SobjectRecord.childobjects = DC_Drug_List_Group_wrappers.get(currentMappingId);
                                    Drug_Coverage_wrappers.add(SobjectRecord);

                                }                                
                                map < id, list < mappingValueWrapper >> AccumulationSpecificDrug_wrappers = getWrapperRecords('AccumulationSpecificDrug__c', mappingvaluesRootList, provlinesForcurrentCPE);
                                set < id > Accumulations_ids = new set < id > ();
                                
                                Accumulations_ids.addall(AccumulationSpecificDrug_wrappers.keyset());
                                if (provlinesForcurrentCPE.containskey(ACCUMAPI.toLowerCase())) {
                                    Accumulations_ids.addAll(provlinesForcurrentCPE.get(ACCUMAPI.toLowerCase()).keyset());
                                } 
                                
                                 //Added By Nitish for 7094
                                asdMapVal = new List<Mapping_Values__c>();
                                if(AccumulationSpecificDrug_wrappers.size()>0){
                                    for(mappingValueWrapper mvWrap : AccumulationSpecificDrug_wrappers.get((new List<id>(Accumulations_ids))[0])){
                                        if(mvWrap.ObjectFieldvalaues.size()>0){
                                            for(Mapping_Values__c asdMV: mvWrap.ObjectFieldvalaues){
                                                asdMapVal.add(asdMV);
                                            }
                                        }
                                    }   
                                } 
                                
                                list < mappingValueWrapper > Accumulations_wrappers = new list < mappingValueWrapper > ();
                                for (id currentMappingId: Accumulations_ids) {

                                    sobject s = GlobalDescribe.get(ACCUMAPI).newsobject();
                                    mappingSobjectMap.put(currentMappingId, s);
                                    if (mappingvaluesRootList.get(currentMappingId).recordtypeid__c != null && mappingvaluesRootList.get(currentMappingId).recordtypeid__c != BLANKVAL) {
                                        s.put('recordtypeid', mappingvaluesRootList.get(currentMappingId).recordtypeid__c);
                                    }
                                    mappingValueWrapper SobjectRecord = new mappingValueWrapper(s, ACCUMAPI);
                                    SobjectRecord.ObjectFieldvalaues = provlinesForcurrentCPE.get(ACCUMAPI.toLowerCase()).get(currentMappingId);
                                    if (AccumulationSpecificDrug_wrappers.containskey(currentMappingId)) SobjectRecord.childobjects = AccumulationSpecificDrug_wrappers.get(currentMappingId);

                                    Accumulations_wrappers.add(SobjectRecord);

                                }                                         

                                //Fetch all the Network junctions and apply the reocrds values
                                list < mappingValueWrapper > Network_junction_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('Network_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    Network_junction_wrappers.addall(tempWrapperlst);
                                }

                                //Fetch all the Aetna RxStep junctions and apply the reocrds values
                                list < mappingValueWrapper > Aetna_rxStep_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('Aetna_RxStep_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    Aetna_rxStep_wrappers.addall(tempWrapperlst);
                                }
                                
                                //Fetch all the Retail Vaccine Program and apply the reocrds values
                                list < mappingValueWrapper > retail_Vaccine_program_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('Retail_Vaccine_Program__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    retail_Vaccine_program_wrappers.addall(tempWrapperlst);
                                }
                                
                                //Fetch all the Copays and apply the reocrds values
                                list < mappingValueWrapper > Copay_wrappers = new list < mappingValueWrapper > ();
                                integer i = 0;
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords(COPAYAPI, mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    Copay_wrappers.addall(tempWrapperlst);
                                    list < mappingValueWrapper > steppedcopay_wrappers = new list < mappingValueWrapper > ();                                   
                                    for (list < mappingValueWrapper > tempWrappercopaylst: getWrapperRecords('SteppedCopay__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                        steppedcopay_wrappers.addall(tempWrappercopaylst);
                                    }       
                                    
                                    for(mappingValueWrapper tempwrapper :tempWrapperlst){
                                        
                                        tempwrapper.childobjects = new list<mappingValueWrapper>();
                                        
                                             string dummyid = 'a5DR00000008f';
                                             
                                            if(i  < 10)
                                                dummyid = dummyid + '0' + i;
                                            else
                                                dummyid = dummyid + i; 
                                            i++;                                                  
                                        mappingSobjectMap.put((id)dummyid,tempwrapper.currentrecord);
                                        steppedcopay_wrappers = getWrapperRecords('SteppedCopay__c', mappingvaluesRootList, provlinesForcurrentCPE).get((id)tempwrapper.currentrecord.get('recordtypeid'));
                                        for(mapping_values__c currentmapping : tempwrapper.ObjectFieldvalaues){
                                            if (currentmapping.field_type__c == 'Boolean') {
                                                tempwrapper.currentrecord.put(currentmapping.field_api__c, Boolean.valueof(currentmapping.fieldvalue__c));
                                            }
                                            if (currentmapping.field_type__c == 'Picklist') {
                                                tempwrapper.currentrecord.put(currentmapping.field_api__c, String.valueof(currentmapping.fieldvalue__c));
                                            }
                                            if (currentmapping.field_type__c == 'String') {
                                            
                                                tempwrapper.currentrecord.put(currentmapping.field_api__c, String.valueof(currentmapping.fieldvalue__c));
                                            }
                                            if (currentmapping.field_type__c == IDVAL1) {
                                                tempwrapper.currentrecord.put(currentmapping.field_api__c, String.valueof(currentmapping.fieldvalue__c));
                                            }
                                            if (currentmapping.field_type__c == 'Number') {
                                                tempwrapper.currentrecord.put(currentmapping.field_api__c,  currentmapping.fieldvalue__c == null ? null : Decimal.valueof(currentmapping.fieldvalue__c));
                                            }
                                            if (currentmapping.field_type__c == 'Date') {
                                                tempwrapper.currentrecord.put(currentmapping.field_api__c, Date.parse(currentmapping.fieldvalue__c));
                                            } 
                                        }
                                        
                                        if(steppedcopay_wrappers != null){
                                            for(mappingValueWrapper stppwrapp : steppedcopay_wrappers ){
                        //integer j = 
                                                    //Added the following code for implementiation of 5463 - Start
                                                    list<Mapping_Values__c> tempchildval = stppwrapp.ObjectFieldvalaues;
                                                    String multiplier = BLANKVAL;
                                                    for(Mapping_Values__c tempfieldval : tempchildval){
                                                        if(tempfieldval.Field_API__c == multiplierlabel)
                                                            multiplier = tempfieldval.fieldvalue__C;
                                                    }
                                                    stppwrapp = new mappingValueWrapper(stppwrapp.currentrecord.clone(false),'SteppedCopay__c');
                                                    stppwrapp.ObjectFieldvalaues = new list<Mapping_Values__c>();
                                                        //Code Logic Changed By Nitish as per Request 6973
                                                    if(tempwrapper.currentrecord.get(Dollaramount) !=null && tempwrapper.currentrecord.get(Dollaramount) !=0){
                                                        stppwrapp.currentrecord.put(Dollaramount,Decimal.valueof(multiplier)*Decimal.valueof(string.valueof(tempwrapper.currentrecord.get(Dollaramount))));
                                                    if(tempwrapper.currentrecord.get(mindollar) !=null)
                                                        stppwrapp.currentrecord.put(mindollar,decimal.valueof(multiplier)*decimal.valueof(string.valueof(tempwrapper.currentrecord.get(mindollar)))) ;
                                                    if(tempwrapper.currentrecord.get(maxdollar) !=null)
                                                        stppwrapp.currentrecord.put(maxdollar,decimal.valueof(multiplier)*decimal.valueof(string.valueof(tempwrapper.currentrecord.get(maxdollar)))) ;
                                                    if(tempwrapper.currentrecord.get(percent) !=null)
                                                        stppwrapp.currentrecord.put(percentamount,decimal.valueof(string.valueof(tempwrapper.currentrecord.get(percent)))) ;                                                     
                                                    if(tempwrapper.currentrecord.get(copaycalc) !=null)
                                                        stppwrapp.currentrecord.put(copaycalc,tempwrapper.currentrecord.get(copaycalc)) ; 
                                                        tempwrapper.childobjects.add(stppwrapp);
                                                        tempwrapper.currentrecord.put('Stepped_Copay__c',true);
                                                    }
                                                    else if(tempwrapper.currentrecord.get(Dollaramount) == null && tempwrapper.currentrecord.get(percent) !=null
                                                            && tempwrapper.currentrecord.get(mindollar) ==null && tempwrapper.currentrecord.get(maxdollar) ==null){
                                                         //do nothing
                                                    }
                                                    else if(tempwrapper.currentrecord.get(Dollaramount) ==null && tempwrapper.currentrecord.get(percent) !=null 
                                                        &&(tempwrapper.currentrecord.get(mindollar) !=null || tempwrapper.currentrecord.get(maxdollar) !=null)){
                                                        
                                                        stppwrapp.currentrecord.put(percentamount,decimal.valueof(string.valueof(tempwrapper.currentrecord.get(percent)))) ;
                                                        if(tempwrapper.currentrecord.get(mindollar) !=null)
                                                            stppwrapp.currentrecord.put(mindollar,decimal.valueof(multiplier)*decimal.valueof(string.valueof(tempwrapper.currentrecord.get(mindollar)))) ;
                                                        if(tempwrapper.currentrecord.get(maxdollar) !=null)
                                                            stppwrapp.currentrecord.put(maxdollar,decimal.valueof(multiplier)*decimal.valueof(string.valueof(tempwrapper.currentrecord.get(maxdollar)))) ;
                                                        if(tempwrapper.currentrecord.get(copaycalc) !=null)
                                                            stppwrapp.currentrecord.put(copaycalc,tempwrapper.currentrecord.get(copaycalc)) ; 
                                                            tempwrapper.childobjects.add(stppwrapp);
                                                            tempwrapper.currentrecord.put('Stepped_Copay__c',true);
                                                    }
                                                for(Mapping_Values__c tempfieldval : tempchildval){
                                                    
                                                    Mapping_Values__c valuedummy = tempfieldval.clone(false,true); 
                                                    if(valuedummy.Field_type__c == 'Lookup'){
                                                        valuedummy.Parent_Field_Value__c = (id)dummyid;                                                 
                                                    }
                                                    
                                                    stppwrapp.ObjectFieldvalaues.add(valuedummy);
                                                    
                                                        
                                                }
                                                
                    
                                        }
                                                //throw new MerchandiseExceptiMerchandiseExceptionon(JSON.serialize(tempwrapper.currentrecord));

                                            
                                        }
                                        //tempwrapreccord.currentrecord.put(CurrentFieldValue.field_api__c, mappingSobjectMap.get(CurrentFieldValue.Parent_Field_Value__c).get(IDVAL));
                                    }
                                }
                                //Fetch all the Accumulations and apply the reocrds values

                                
                                //Fetch all the Clinical Program Group junctions and apply the reocrds values
                                list < mappingValueWrapper > Clinical_Program_Group_Junction_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('Clinical_Program_Group_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    Clinical_Program_Group_Junction_wrappers.addall(tempWrapperlst);
                                }
                                
                                list < mappingValueWrapper > AHA_Junction_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('AHA_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    AHA_Junction_wrappers.addall(tempWrapperlst);
                                }

                                list < mappingValueWrapper > CRD_Step_Therapy_Junction_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('CRD_Step_Therapy_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    CRD_Step_Therapy_Junction_wrappers.addall(tempWrapperlst);
                                }
                                
                                list < mappingValueWrapper > Waiver_Of_Deductible_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('Waiver_Of_Deductible__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    Waiver_Of_Deductible_wrappers.addall(tempWrapperlst);
                                }
                                list < mappingValueWrapper > Drug_Specific_Copay_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('Drug_Specific_Copay__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    Drug_Specific_Copay_wrappers.addall(tempWrapperlst);
                                }
                                
                                list < mappingValueWrapper > CRD_PriorAuth_Junction_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('CRD_PriorAuth_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    CRD_PriorAuth_Junction_wrappers.addall(tempWrapperlst);
                                }
                                
                                list < mappingValueWrapper > CRD_Quantity_Limit_Junction_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('CRD_Quantity_Limit_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    CRD_Quantity_Limit_Junction_wrappers.addall(tempWrapperlst);
                                }
                                

             
                                list < mappingValueWrapper > Save_A_Copay_Junction_wrappers = new list < mappingValueWrapper > ();
                                for (list < mappingValueWrapper > tempWrapperlst: getWrapperRecords('Save_A_Copay_Junction__c', mappingvaluesRootList, provlinesForcurrentCPE).values()) {
                                    Save_A_Copay_Junction_wrappers.addall(tempWrapperlst);
                                } 
                                //Fetch all the CRd and attach the related records to this and apply the reocrds values
                                sobject scrd;
                                    // Added By Nitish 6819
                                if(updatePERSList.size()>0){
                                  for(Pers_Full_Report__c pfr : updatePERSList){
                                      if(pfr.WS_PROV_NUM__c == 134 && pfr.WS_LV_NO__c ==84){
                                        checkDiabeticPlan = true;
                                      }
                                    }
                                }
                                CB_CrdBuilderUtil utilclass = new CB_CrdBuilderUtil();
                                    utilclass.checkForDiabeticPlan(updatePERSList);
                                    scrd = utilclass .commonaction(updatePERSList[0]);
                               // Request No - 06011 By Nitish
                               /*// Updated below logic of Request - 06011 According to ST 494 (PMO Request - 06226)
                                Boolean PaperRetailChk;
                                boolean MailCheck;
                                Integer PaperRetailProv = 9;
                                Integer MailProv = 13;    
                                
                                
                                 for(Pers_Full_Report__c pfrv:updatePERSList )
                                 {
                                    if((PaperRetailProv == integer.valueof(pfrv.WS_PROV_NUM__c)) && (pfrv.WS_LV_NO__c!=0 && pfrv.WS_LV_NO__c!=999)){
                                     PaperRetailChk = True;
                                     scrd.put('Plan_Type_Retail__c',PaperRetailChk);
                                  
                                     }
                                     else if((MailProv == integer.valueof(pfrv.WS_PROV_NUM__c)) && (pfrv.WS_LV_NO__c!=0 && pfrv.WS_LV_NO__c!=999)){
                                       MailCheck = True;
                                      scrd.put('Plan_Type_Mail__c',MailCheck);
                                      }
                                 } */
  
                                // Below logic added by Vikram for Request - 06279 (ST# 763) - (Covers above logic of request 06011)
                                Boolean RCheck;
                                Boolean MCheck;
                                Set<Integer> RProv = new Set<Integer>{1, 17, 135, 9,151};//Added P151 for story 6988
                                // By Shubham - Provision 147 is added in the Set as per Request 06368
                                Set<Integer> MProv = new Set<Integer>{12, 25, 136, 13, 147};
                                 map < decimal, set < decimal >> tempProvlines = cpeProvlines.get(tempcpe);
                                 
                                list<LineValue__c> templinevalues =  [select id, Provision_ID__r.ProvisionNumber__c,Line_value__c from LineValue__c  where name in :lstlinename];
                                map<decimal,set<decimal>> tempvalidprovlines = new map<decimal,set<decimal>>();
                                    for(LineValue__c linevalue : templinevalues){
                                        set<decimal> tempsetlinevales = new set<decimal>();
                                        if(tempvalidprovlines.containskey(linevalue.Provision_ID__r.ProvisionNumber__c)){
                                            tempsetlinevales = tempvalidprovlines.get(linevalue.Provision_ID__r.ProvisionNumber__c);
                                        }
                                        if(!tempsetlinevales.contains(linevalue.Line_value__c))
                                            tempsetlinevales.add(linevalue.Line_value__c);
                                        tempvalidprovlines.put(linevalue.Provision_ID__r.ProvisionNumber__c,tempsetlinevales);
                                        
                                    }
                                    
                                 for(Pers_Full_Report__c pfrv:updatePERSList)
                                 {
                                     
                     if((RProv.contains(integer.valueof(pfrv.WS_PROV_NUM__c))) && (pfrv.WS_LV_NO__c!=0 && pfrv.WS_LV_NO__c!=999) && !(tempvalidprovlines.containskey(pfrv.WS_PROV_NUM__c))){
                                     RCheck = True;
                                     scrd.put('Plan_Type_Retail__c',RCheck);
                                     }                                  
                                     else if((MProv.contains(integer.valueof(pfrv.WS_PROV_NUM__c))) && (pfrv.WS_LV_NO__c!=0 && pfrv.WS_LV_NO__c!=999) && !(tempvalidprovlines.containskey(pfrv.WS_PROV_NUM__c))){
                                        MCheck = True;
                                        scrd.put('Plan_Type_Mail__c',MCheck);
                                        }
                                    }
                                // Logic for 06279 ends
                                
                                //else
                                    //scrd = GlobalDescribe.get('crd__c').newsobject();
                                mappingSobjectMap.put(crdMappingvalue.id, scrd);
                                mappingValueWrapper CRDRecord = new mappingValueWrapper(scrd, CRDAPI);
                                CRDRecord.childobjects = Drug_Coverage_wrappers;
                                CRDRecord.childobjects.addall(Copay_wrappers);
                                CRDRecord.childobjects.addall(Aetna_rxStep_wrappers);
                                CRDRecord.childobjects.addall(retail_Vaccine_program_wrappers);
                                CRDRecord.childobjects.addall(Network_junction_wrappers);
                                CRDRecord.childobjects.addall(Accumulations_wrappers);
                                CRDRecord.childobjects.addall(Clinical_Program_Group_Junction_wrappers);
                                CRDRecord.childobjects.addall(Waiver_Of_Deductible_wrappers);
                                CRDRecord.childobjects.addall(Drug_Specific_Copay_wrappers);
                                CRDRecord.childobjects.addall(CRD_PriorAuth_Junction_wrappers);
                                CRDRecord.childobjects.addall(CRD_Step_Therapy_Junction_wrappers);
                                CRDRecord.childobjects.addall(Save_A_Copay_Junction_wrappers);
                                CRDRecord.childobjects.addall(CRD_Quantity_Limit_Junction_wrappers);
                                CRDRecord.childobjects.addall(AHA_Junction_wrappers);
                                
                                
                                if (provlinesForcurrentCPE.containskey(CRDAPI.toLowerCase())) {
                                
                                    for (id currentMappingId: provlinesForcurrentCPE.get(CRDAPI.toLowerCase()).keyset()) {
                                        CRDRecord.ObjectFieldvalaues = provlinesForcurrentCPE.get(CRDAPI.toLowerCase()).get(currentMappingId);
                                    }
                                }
                                mappingValueWrapper tempinstance = new mappingValueWrapper();
                                list < mappingValueWrapper > CRDRecordlst = new list < mappingValueWrapper > ();
                                CRDRecordlst.add(CRDRecord);
                                ConflictErrorsMesseges = new set<string>();
                                ConflictErrorsMessegesmap = new map<string,string>();
                                Boolean conflictError = createSobjects(CRDRecordlst);
                                 CrdBuilderFallouts = new list < CRD_BuilderFallout__c > ();
                                Case successcase;
                                
                                        
                                  
                                //Check if this CRD and related child records have any conflic
                                existingFalloutCase = null;
                                /*if(updatePERSList[0].WS_ACQ_BUSS_CD__c == '01'){
                                    if (existingFalloutCase == null) {
                                        //Amit updated Timestamp to crdbuild.PERS_timestamp__c from System.now()
                                        existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CRDBUILDERFALVAL
                                                                                        , '01 : COVENTRY MIGRATED CONTROLS'
                                                                                        , 'CB_PreB_manual'
                                                                                        , crdbuild.PERS_timestamp__c
                                                                                        ,tempcpe.split(COMMAVAL,0)[0]
                                                                                        ,crdbuild.crd__r.Account__c
                                                                                        ,crdbuild.crd__r.Effective_Date__c
                                                                                        ,crdbuild.crd__c);

                                    }
                                    
                                        CRD_BuilderFallout__c builderFallout = new CRD_BuilderFallout__c(Error_Description__c = 'Pers full report created with Acquisition indicator = 01', Field__c = 'PERS_Full_Report.WS_ACQ_BUSS_CD__c', Type__c = 'Common');
                                        CrdBuilderFallouts.add(builderFallout);
                                    
                                }*/ //Commented by Nikita as per request 05589 
                                if (conflictError) {
                                    if (existingFalloutCase == null) {
                                        //Amit updated Timestamp to crdbuild.PERS_timestamp__c from System.now()
                                        existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CRDBUILDERFALVAL
                                                                                        , 'Conflict Error - This is due to Conflict in fields'
                                                                                        , 'CB_ExecuteBuild'
                                                                                        , crdbuild.PERS_timestamp__c
                                                                                        ,tempcpe.split(COMMAVAL,0)[0]
                                                                                        ,crdbuild.crd__r.Account__c
                                                                                        ,crdbuild.crd__r.Effective_Date__c
                                                                                        ,crdbuild.crd__c);

                                    }
                                    
                                    for (String ConflictErrormess: ConflictErrorsMesseges) {
                                        list < String > fieldErrormss = ConflictErrormess.split(COMMAVAL);
                                        CRD_BuilderFallout__c builderFallout = new CRD_BuilderFallout__c(Error_Description__c = fieldErrormss[1], Field__c = fieldErrormss[0], Type__c = 'Conflicts',Conflict_Provision_Lines__c = ConflictErrorsMessegesmap.get(ConflictErrormess));
                                        CrdBuilderFallouts.add(builderFallout);
                                    }


                                } else {
                                                             

                                    //Create a Save error crdbuilder fallout record if any error is thrown at build step
                                    Savepoint sp = Database.setSavepoint();
                                    try {
                                        returnvar = createMappingWrapperREcord(CRDRecordlst, null);
                                        database.update(updatePERSList);                                
                                        utilclass .CommonPostBuildActivities(returnvar[0].currentrecord.id, crdBuildOrderId);
                                        posbuildchanges(CRDRecordlst);
                                        crdbuild.CRD__c = returnvar[0].currentrecord.id;
                                        //returnvar.clear();
                                        //crdbuild.Case__c = successcase.id;

                                   } catch (exception ex) {
                                        //throw ex;
                                        system.debug('############# ' +ex.getlinenumber());
                                        Database.rollback(sp);
                                        if (existingFalloutCase == null) {
                                            //Amit updated Timestamp to crdbuild.PERS_timestamp__c from System.now()
                                            existingFalloutCase = CB_CaseLogger.CreateCaseBuilder(CRDBUILDERFALVAL
                                                                                            , 'Save Error'
                                                                                            , 'CB_ExecuteBuild'
                                                                                            , crdbuild.PERS_timestamp__c
                                                                                            ,tempcpe.split(COMMAVAL,0)[0]                                                                                        
                                                                                            ,crdbuild.crd__r.Account__c
                                                                                            ,crdbuild.crd__r.Effective_Date__c
                                                                                            ,crdbuild.crd__c);

                                        }
                                       CRD_BuilderFallout__c builderFallout = new CRD_BuilderFallout__c(Error_Description__c = ex.getMessage(), Type__c = SAVEERRORS);
                                       CrdBuilderFallouts.add(builderFallout);
                                       database.upsert(builderFallout);
                                    }
                                    
                                }
                //                    insert CrdBuilderFallouts;
                                    Boolean IsinvalidProvision  = false;                                        
                                    if(existingFalloutCase != null){
                                        if(crdbuild.FalloutCase__c == null)
                                            database.upsert(existingFalloutCase);
                                        else
                                            existingFalloutCase = new case(id=crdbuild.FalloutCase__c );
                                        crdbuild.FalloutCase__c = existingFalloutCase.id;
                                    }
                                    for(CRD_BuilderFallout__c currentCRDfallout :CrdBuilderFallouts)
                                        currentCRDfallout.caseid__c = existingFalloutCase.id;
                                    

                                    database.upsert(CrdBuilderFallouts);
                                    list<LineValue__c> linevalues =  [select id, Provision_ID__r.ProvisionNumber__c,Line_value__c from LineValue__c  where name in :lstlinename];
                                    map<decimal,set<decimal>> validprovlines = new map<decimal,set<decimal>>();
                                    for(LineValue__c linevalue : linevalues){
                                        set<decimal> setlinevales = new set<decimal>();
                                        if(validprovlines.containskey(linevalue.Provision_ID__r.ProvisionNumber__c)){
                                            setlinevales = validprovlines.get(linevalue.Provision_ID__r.ProvisionNumber__c);
                                        }
                                        if(!setlinevales.contains(linevalue.Line_value__c))
                                            setlinevales.add(linevalue.Line_value__c);
                                        validprovlines.put(linevalue.Provision_ID__r.ProvisionNumber__c,setlinevales);
                                    }
                                    
                                    ///Set All Provisions processed where line value exist but mapping values are zero
                                     
                                    Map<String,Pers_Full_Report__c> mapLvToPers = new Map<String,Pers_Full_Report__c>();
                                    for(Pers_Full_Report__c PersRecord : updatePERSList){
                                            
                                            if (existingFalloutCase == null) {
                                                String key = VARP + PersRecord.WS_PROV_NUM__c + VARL + PersRecord.WS_LV_NO__c;
                                                
                                                if(provlines.containskey(PersRecord.WS_PROV_NUM__c) && provlines.get(PersRecord.WS_PROV_NUM__c).contains(PersRecord.WS_LV_NO__c)){
                                                    PersRecord.Processed__c = true;
                                                    if((mappingSobjectMap.get(crdMappingvalue.id).get('Do_you_want_to_do_Save_A_Copay__c') == null || mappingSobjectMap.get(crdMappingvalue.id).get('Do_you_want_to_do_Save_A_Copay__c') == BLANKVAL) && PersRecord.WS_PROV_NUM__c == 71)
                                                        PersRecord.Processed__c = false;
                                                        
                                                }
                                                else{
                                                    mapLVtoPers.put(key,PersRecord);
                                                    
                                                    PersRecord.Processed__c = false;
                                                    //Ayushi commented for Request 06527 (ST#1191) starts
                                                    /*if(createAccumus){
                                                    if(PersRecord.WS_PROV_NUM__c == 14 || PersRecord.WS_PROV_NUM__c == 15    || PersRecord.WS_PROV_NUM__c == 27 ||PersRecord.WS_PROV_NUM__c == 29|| PersRecord.WS_PROV_NUM__c == 30|| PersRecord.WS_PROV_NUM__c == 31||PersRecord.WS_PROV_NUM__c == 34 || PersRecord.WS_PROV_NUM__c == 113)
                                                        PersRecord.Processed__c = true;
                                                    }*/
                                                    //Request 06527 (ST#1191) ends
                                                    if(PersRecord.WS_PROV_NUM__c == 37 || PersRecord.WS_PROV_NUM__c == 38 || PersRecord.WS_PROV_NUM__c == 39 || PersRecord.WS_PROV_NUM__c == 40 || PersRecord.WS_PROV_NUM__c == 41 || PersRecord.WS_PROV_NUM__c == 42 || PersRecord.WS_PROV_NUM__c == 121 || PersRecord.WS_PROV_NUM__c == 122 || PersRecord.WS_PROV_NUM__c == 123 || PersRecord.WS_PROV_NUM__c == 124 || PersRecord.WS_PROV_NUM__c == 125 || PersRecord.WS_PROV_NUM__c == 126 || PersRecord.WS_PROV_NUM__c == 127)
                                                        PersRecord.Processed__c = true;
                                                }
                                                PersRecord.crd__c= crdbuild.CRD__c;                        
                                            }
                                            else{
                                                    PersRecord.Case__c = existingFalloutCase.id;
                                                    PersRecord.Processed__c = false;
                                            
                                            }                       
                       
                                    }
                                    
                                    for(LineValue__c lv : [Select 
                                                                Id, Name 
                                                                , (Select 
                                                                        Id 
                                                                    From 
                                                                        Mapping_Values__r
                                                                    Limit 1) 
                                                            From 
                                                                LineValue__c 
                                                            Where 
                                                                Name in:mapLVtoPers.keyset()]){
                                                                
                                    if(lv.Mapping_Values__r.size() == 0 &&  mapLVtoPers.containsKey(lv.Name)){
                                        mapLVtoPers.get(lv.Name).processed__c = true;
                                        
                                    }
                                    
                                 }
                                 
                              
                                     
                                Database.update (updatePERSList,false);
                                if(utilclass != null && utilclass.provFormullaryMap != null){
                                    update utilclass.provFormullaryMap.values();
                                }
                                 
                                 set<string> formularyGroup = new set<String>();
                                 set<id> formularyId = new set<id>();
                                 
                                 if(crdbuild.CRD__c != null){
                                     for(Drug_Coverage__c dc:[select Formulary__r.Name,Formulary__c,Formulary_Group__c from Drug_Coverage__c where CRD_ID__c =:crdbuild.CRD__c]){
                                         if(dc.Formulary__c!=Null){ 
                                             
                                                if(dc.Formulary_Group__c!= Null && dc.Formulary_Group__c!=BLANKVAL){
                                                    formularyGroup.add(dc.Formulary_Group__c);                                      
                                                }
                                         formularyId.add(dc.Formulary__c);
                                        }
                                     }
                                 }
                                 utilclass.validateDSC(provision,formularyGroup,formularyId);
                                 
                               if(returnvar.size()>0 && provision.size()>0){
                                   utilclass.validateWOD(provision,formularyGroup,returnvar[0].currentrecord.id,formularyId);//Added By Nitish for ST#2515
                               }
                                
                                                      
                              
                                
                            }
                            
                            database.upsert(crdbuild);
                           
                            return returnvar;
                        }

                        //This method send back the records to be created and the field values that need to be populated based on the sobject
                        public Map < id, list < mappingValueWrapper > > getWrapperRecords(String Sobjectname, map < id, Mapping_Values__c > mappingvaluesRootList, map < string, map < id, list < Mapping_Values__c >>> provlinesForcurrentCPE) {
                            Map < id, list < mappingValueWrapper > > wrappers = new Map < id, list < mappingValueWrapper > > ();
                            if (provlinesForcurrentCPE.containskey(Sobjectname.toLowerCase())) {
                                if(Sobjectname.toLowerCase() != 'SteppedCopay__c'.toLowerCase()){
                                    for (id currentMappingId: provlinesForcurrentCPE.get(Sobjectname.toLowerCase()).keyset()) {

                                        sobject s = GlobalDescribe.get(Sobjectname).newsobject();
                                        mappingSobjectMap.put(currentMappingId, s);
                                        if (mappingvaluesRootList.get(currentMappingId).recordtypeid__c != null && mappingvaluesRootList.get(currentMappingId).recordtypeid__c != BLANKVAL && mappingvaluesRootList.get(currentMappingId).object_api__C != 'SteppedCopay__c' ){
                                            s.put('recordtypeid', mappingvaluesRootList.get(currentMappingId).recordtypeid__c);
                                        }
                                        mappingValueWrapper SobjectRecord = new mappingValueWrapper(s, Sobjectname); 
                                        SobjectRecord.ObjectFieldvalaues = provlinesForcurrentCPE.get(Sobjectname.toLowerCase()).get(currentMappingId);
                                        list < mappingValueWrapper > temp_wrappers = new list < mappingValueWrapper > ();
                                        if (wrappers.containskey(mappingvaluesRootList.get(currentMappingId).ParentMappingValue__c)){
                                            temp_wrappers = wrappers.get(mappingvaluesRootList.get(currentMappingId).ParentMappingValue__c);
                                        }   
                                        temp_wrappers.add(SobjectRecord);
                                        wrappers.put(mappingvaluesRootList.get(currentMappingId).ParentMappingValue__c, temp_wrappers);

                                    }
                                }
                                else{
                                    for (id currentMappingId: provlinesForcurrentCPE.get(Sobjectname.toLowerCase()).keyset()) {

                                        sobject s = GlobalDescribe.get(Sobjectname).newsobject();
                                        mappingSobjectMap.put(currentMappingId, s);

                                        mappingValueWrapper SobjectRecord = new mappingValueWrapper(s, Sobjectname); 
                                        SobjectRecord.ObjectFieldvalaues = provlinesForcurrentCPE.get(Sobjectname.toLowerCase()).get(currentMappingId);
                                        list < mappingValueWrapper > temp_wrappers = new list < mappingValueWrapper > ();
                                        if (wrappers.containskey(mappingvaluesRootList.get(currentMappingId).recordtypeid__c)){
                                            temp_wrappers = wrappers.get(mappingvaluesRootList.get(currentMappingId).recordtypeid__c);
                                        }   
                                        temp_wrappers.add(SobjectRecord);
                                        wrappers.put(mappingvaluesRootList.get(currentMappingId).recordtypeid__c, temp_wrappers);

                                    }
                                }
                            }
                            return wrappers;
                        }

                        //This method will create the records neededd
                        public list < mappingValueWrapper > createMappingWrapperREcord(list < mappingValueWrapper > currentWrapRecord, id parentid) {
                            lisT < sobject > createrecordlst = new list < sobject > ();
                            lisT < sobject > createrecordlst2 = new list < sobject > ();
                            list < sobject > copaylst = new list < sobject > ();
                            list< mappingValueWrapper > Accumslst = new list< mappingValueWrapper >();
                            crdrecordinsert = false;
                            //Date dt;
                            map < id, list < sobject >> Copays = new map < id, list < sobject >> ();
                            ischemodrugbypass = False; // Added by Ayushi for Request 06528 (ST#1191)
                            for (mappingValueWrapper tempwrapreccord: currentWrapRecord) {
                                //The following if loop performs some postbuild logic for drug coverage
                                //Uncommented code as per Defect #D00614
                                if (tempwrapreccord.sobjecttype == ACCUMAPI) {
                                    if(tempwrapreccord.currentrecord.get('Accumulation_End_Date__c') != null){
                                        tempwrapreccord.currentrecord.put('Deductible_Period__c','Custom');
                                        tempwrapreccord.currentrecord.put('MAB_Period__c','Custom');
                                        tempwrapreccord.currentrecord.put('MOOP_Period__c','Custom');                           
                                    }
                                }
                                if (tempwrapreccord.sobjecttype == COPAYAPI) {
                                    copaylst.add(tempwrapreccord.currentrecord);
                                }
                                if(tempwrapreccord.sobjecttype == ACCUMAPI){
                                    Accumslst.add(tempwrapreccord);
                                }                   
                                
                                for (Mapping_Values__c CurrentFieldValue: tempwrapreccord.ObjectFieldvalaues) {
                                    if (CurrentFieldValue.Field_type__c == 'Lookup') {
                                        
                                        tempwrapreccord.currentrecord.put(CurrentFieldValue.field_api__c, mappingSobjectMap.get(CurrentFieldValue.Parent_Field_Value__c).get(IDVAL));
                                    }
                                }
                                if(tempwrapreccord.sobjecttype != DRUGCOVAPI && tempwrapreccord.sobjecttype != 'Save_A_Copay_Junction__c' && tempwrapreccord.sobjecttype != COPAYAPI && tempwrapreccord.sobjecttype != ACCUMAPI ){
                                    if(tempwrapreccord.sobjecttype == 'Clinical_Program_Group_Junction__c' || tempwrapreccord.sobjecttype == 'CRD_Step_Therapy_Junction__c' || tempwrapreccord.sobjecttype == 'Waiver_Of_Deductible__c' || tempwrapreccord.sobjecttype == 'Drug_Specific_Copay__c' || tempwrapreccord.sobjecttype == 'CRD_PriorAuth_Junction__c'){
                                        createrecordlst2.add(tempwrapreccord.currentrecord);
                                    }
                                    else {
                                            // Added by Ayushi for Request 06528 (ST#1191)
                                            if(tempwrapreccord.sobjecttype == 'CRD__c'){ 
                                                    crdrecordinsert = true; 
                                            }
                                            createrecordlst.add(tempwrapreccord.currentrecord);
                                        }
                                }
                                else{
                                    if(tempwrapreccord.sobjecttype == DRUGCOVAPI && (tempwrapreccord.ObjectFieldvalaues.size()  > 1 || tempwrapreccord.childobjects.size()  > 1))
                                        if(tempwrapreccord.sobjecttype == 'Clinical_Program_Group_Junction__c' || tempwrapreccord.sobjecttype == 'CRD_Step_Therapy_Junction__c' || tempwrapreccord.sobjecttype == 'Waiver_Of_Deductible__c' || tempwrapreccord.sobjecttype == 'Drug_Specific_Copay__c' || tempwrapreccord.sobjecttype == 'CRD_PriorAuth_Junction__c')
                                            createrecordlst2.add(tempwrapreccord.currentrecord);
                                        else
                                            createrecordlst.add(tempwrapreccord.currentrecord);
                                    if(tempwrapreccord.sobjecttype == 'Save_A_Copay_Junction__c'){
                                        if(mappingSobjectMap.get(crdMappingvalue.id).get('Do_you_want_to_do_Save_A_Copay__c') == 'Yes')
                                            if(tempwrapreccord.sobjecttype == 'Clinical_Program_Group_Junction__c' || tempwrapreccord.sobjecttype == 'CRD_Step_Therapy_Junction__c' || tempwrapreccord.sobjecttype == 'Waiver_Of_Deductible__c' || tempwrapreccord.sobjecttype == 'Drug_Specific_Copay__c' || tempwrapreccord.sobjecttype == 'CRD_PriorAuth_Junction__c')
                                                createrecordlst2.add(tempwrapreccord.currentrecord);        
                                            else
                                                createrecordlst.add(tempwrapreccord.currentrecord);
                                    }                       
                                }
                                //Added by Amit for ST# 541
                                if(tempwrapreccord.sobjecttype == CRDAPI){
                                    if(String.valueof(tempwrapreccord.currentrecord.get('Integrate_with_Medical__c')) == 'No'
                                        && String.valueof(tempwrapreccord.currentrecord.get('Plan_Platform__c')) != 'Aetna Student Health'){
                                        createAccumulations = False;
                                        scenarioAccum3 = True;
                                    }
                                    /*Added by JR to implement request no 6154
                                    if(tempwrapreccord.currentrecord.get('Effective_Date__c')!=null){
                                        dt = date.valueof(tempwrapreccord.currentrecord.get('Effective_Date__c'));
                                    }*/
                                    //Added By Nitish 6820
                                     if(checkDiabeticPlan){
                                        tempwrapreccord.currentrecord.put('Medical_Injectible_Claim_Denial_Process__c',DNA);
                                        
                                    }
                                }
                                //Ends
                            }
                            list<mappingValueWrapper> Accumfinals = new list<mappingValueWrapper>();                           
                            for(mappingValueWrapper tempaccum : Accumslst){
                                                               
                                set<string> ignorefields = new set<string>();
                                boolean ignoreAccum = true;

                                // Added by Ayushi for Request 06528 (ST#1191) starts
                                // Added updates by Bhaskar for Request 06528 (ST#1191)
                                if(((cRDIdsObjectmap.containsKey(parentid) && cRDIdsObjectmap.get(parentid).Does_Chemo_Parity_Apply__c != NULL && cRDIdsObjectmap.get(parentid).Does_Chemo_Parity_Apply__c) && (cRDIdsObjectmap.get(parentid).integrate_with_medical__c != NULL && cRDIdsObjectmap.get(parentid).integrate_with_medical__c == YES_LABEL) && (cRDIdsObjectmap.get(parentid).plan_platform__c != NULL && cRDIdsObjectmap.get(parentid).plan_platform__c != ASH)) ||
                                            (cRDIdsObjectmap.containsKey(parentid) && (cRDIdsObjectmap.get(parentid).Does_Chemo_Parity_Apply__c != NULL && cRDIdsObjectmap.get(parentid).Does_Chemo_Parity_Apply__c) && ((cRDIdsObjectmap.get(parentid).integrate_with_medical__c != NULL && cRDIdsObjectmap.get(parentid).integrate_with_medical__c != YES_LABEL) || (cRDIdsObjectmap.get(parentid).plan_platform__c != NULL && cRDIdsObjectmap.get(parentid).plan_platform__c == ASH)) )){
                                    if(tempaccum.currentrecord.get(ISMAB) != NULL && tempaccum.currentrecord.get(ISMAB) == YES_LABEL){
                                        cRDIdsObjectmap.get(parentid).Chemo_Drugs_Bypass_MAB__c = True;
                                        ischemodrugbypass = True;
                                    }
                                    if(tempaccum.currentrecord.get(ISMOP) != NULL && tempaccum.currentrecord.get(ISMOP) == YES_LABEL){
                                        cRDIdsObjectmap.get(parentid).Chemo_Drugs_Bypass_OOP__c = True;
                                        ischemodrugbypass = True;
                                    }
                                    if ((tempaccum.currentrecord.get(DEDUCTAMOUNT)!= NULL && tempaccum.currentrecord.get(DEDUCTAMOUNT)!='0' && tempaccum.currentrecord.get(DEDUCTAMOUNT)!= BLANKVAL )||
                                            ( tempaccum.currentrecord.get(INDEDUCTAMOUNT)!=NULL  && tempaccum.currentrecord.get(INDEDUCTAMOUNT)!='0' && tempaccum.currentrecord.get(INDEDUCTAMOUNT)!= BLANKVAL)||
                                                (tempaccum.currentrecord.get(OONDEDUCTAMOUNT)!=NULL && tempaccum.currentrecord.get(OONDEDUCTAMOUNT)!='0' && tempaccum.currentrecord.get(OONDEDUCTAMOUNT)!= BLANKVAL)){
                                        cRDIdsObjectmap.get(parentid).Chemo_Drugs_Bypass_Deductible__c = True;
                                        ischemodrugbypass = True;
                                    }    
                                }
                                // Added by Ayushi for Request 06528 (ST#1191) ends
                                    ignorefields.add('Start_Month_New__c');
                                    ignorefields.add('Start_Day__c');
                                    ignorefields.add('Accumulation_End_Date__c');
                                    ignorefields.add('When_will_the_Accumulations_renew__c');
                                    ignorefields.add('Carry_Balance_when_member_moves__c');
                                    ignorefields.add('Accum_Code_Deductible__c');                       
                                    ignorefields.add('Accum_Code_Maximum_Allowable_Benefit__c');
                                    ignorefields.add('What_happens_when_the_MAB_is_met__c');
                                    ignorefields.add('Accum_Code_Maximum_Out_Of_Pocket__c');
                                    ignorefields.add('What_happens_when_MOOP_is_met__c');
                                    ignorefields.add('CRD_ID__c');
                                    ignorefields.add('Deuductible_Accumulation_from_4th_Qtr__c');
                                    ignorefields.add('Cross_Accumulation__c');
                                    ignorefields.add('Is_there_a_Maximum_Out_of_Pocket__c');//Richa added for Req 5083
                                    ignorefields.add('Is_there_a_Maximum_Allowable_Benefit__c');//Richa added for Req 5083
                                    
                                    for(Mapping_Values__c tempobjfieldvalue : tempaccum.ObjectFieldvalaues){
                                        if(!ignorefields.contains(tempobjfieldvalue.field_api__c)){
                                            ignoreAccum = false;
                                        }
                                    }
                                    //Richa added below if for ST 748
                                    if((tempaccum.currentrecord.get('Is_there_a_Maximum_Out_of_Pocket__c') == null || String.valueof(tempaccum.currentrecord.get('Is_there_a_Maximum_Out_of_Pocket__c')) == BLANKVAL) && 
                                        (tempaccum.currentrecord.get('Is_there_a_Maximum_Allowable_Benefit__c') == null || String.valueof(tempaccum.currentrecord.get('Is_there_a_Maximum_Allowable_Benefit__c')) == BLANKVAL) && 
                                            (tempaccum.currentrecord.get('Deductible_Amount__c') == null || 
                                            String.valueof(tempaccum.currentrecord.get('Deductible_Amount__c')) == BLANKVAL) &&
                                                (tempaccum.currentrecord.get('What_is_the_In_Network_Deductible_Amount__c') == null || String.valueof(tempaccum.currentrecord.get('What_is_the_In_Network_Deductible_Amount__c')) == BLANKVAL) &&
                                                    (tempaccum.currentrecord.get('What_is_the_OON_Deductible_Amount__c') == null || String.valueof(tempaccum.currentrecord.get('What_is_the_OON_Deductible_Amount__c')) == BLANKVAL) && String.valueof(tempaccum.currentrecord.get('Are_there_any_drug_specific_deductibles__c')) == null && String.valueof(tempaccum.currentrecord.get('Are_there_any_drug_specific_MAB__c')) == null && 
                                                    String.valueof(tempaccum.currentrecord.get('Are_there_any_drug_specifc_MOOP__c')) == null){ 
                                                        scenarioAccum3 = false;
                                    }              
                                    
                                    if(!ignoreAccum || 
                                        (!createAccumulations && scenarioAccum3)){

                                        if(tempaccum.currentrecord.get('Is_there_a_Maximum_Out_of_Pocket__c') == null || String.valueof(tempaccum.currentrecord.get('Is_there_a_Maximum_Out_of_Pocket__c')) == BLANKVAL){
                                            tempaccum.currentrecord.put('Is_there_a_Maximum_Out_of_Pocket__c','No');//Richa added for Req 5083
                                        }
                                        if(tempaccum.currentrecord.get('Is_there_a_Maximum_Allowable_Benefit__c') == null || String.valueof(tempaccum.currentrecord.get('Is_there_a_Maximum_Allowable_Benefit__c')) == BLANKVAL){
                                            tempaccum.currentrecord.put('Is_there_a_Maximum_Allowable_Benefit__c','No');//Richa added for Req 5083
                                        }
                                        if(tempaccum.currentrecord.get('Cross_Accumulation__c') == null || String.valueof(tempaccum.currentrecord.get('Cross_Accumulation__c')) == BLANKVAL){
                                            tempaccum.currentrecord.put('Cross_Accumulation__c','Does Not Apply');  
                                        }
                                        //Added by JR to implement request 6154

                                         
                                          if(bProvLineValue == true && bNewProvLineValue == false){
                                            tempaccum.currentrecord.put('Carry_Balance_when_member_moves__c','No');
                                            tempaccum.currentrecord.put('Start_Day__c',string.valueof(crdEffectiveDate.day()));
                                            DateTime dt = DateTime.newInstance(crdEffectiveDate.year(), crdEffectiveDate.month(), crdEffectiveDate.day());
                                            tempaccum.currentrecord.put('Start_Month_New__c',dt.format('MMMMMMMM'));
                                          }
                                          //Added By Nitish for 7094
                                          if(asdMapVal.size()>0 && cRDIdsObjectmap.get(parentid).integrate_with_medical__c != NULL && cRDIdsObjectmap.get(parentid).integrate_with_medical__c == YES_LABEL && cRDIdsObjectmap.get(parentid).plan_platform__c != NULL && cRDIdsObjectmap.get(parentid).plan_platform__c != ASH){
                                            tempaccum.currentrecord.put('Deuductible_Accumulation_from_4th_Qtr__c',null);
                                            tempaccum.currentrecord.put('What_is_the_In_Network_Deductible_Amount__c',null);
                                            tempaccum.currentrecord.put('Cross_Accumulation__c',null);
                                            tempaccum.currentrecord.put('Deductible_Period__c',null);
                                            tempaccum.currentrecord.put('Are_there_any_drug_specific_MAB__c',False);
                                            tempaccum.currentrecord.put('Are_there_any_drug_specifc_MOOP__c',False);
                                            tempaccum.currentrecord.put('Are_there_any_drug_specific_deductibles__c',False);
                                            tempaccum.currentrecord.put('Is_there_a_Maximum_Out_of_Pocket__c','No');
                                            tempaccum.currentrecord.put('MOOP_Dedictible_Amount__c',null);
                                            tempaccum.currentrecord.put('MOOP_Period__c',null);
                                            tempaccum.currentrecord.put('What_happens_when_MOOP_is_met__c',null);
                                            tempaccum.currentrecord.put('DAW_Differential_Penalty_Applies_to_MOOP__c',null);
                                            tempaccum.currentrecord.put('Deductible_Applies_towards_the_MOOP__c',null);
                                            tempaccum.currentrecord.put('Deductible_Amount__c',null);
                                            tempaccum.currentrecord.put('What_is_the_OON_Deductible_Amount__c',null);
                                            tempaccum.currentrecord.put('MAB_Out_of_Network__c',False);
                                            tempaccum.currentrecord.put('MAB_Period__c',null);
                                            tempaccum.currentrecord.put('What_happens_when_the_MAB_is_met__c',null);
                                            tempaccum.currentrecord.put('MAB_In_Network__c',False);
                                            tempaccum.currentrecord.put('MAB_Generic_Drugs__c',False);
                                            tempaccum.currentrecord.put('MAB_Brand_Drugs_Generics__c',False);
                                            tempaccum.currentrecord.put('MAB_Brand_Drugs_no_Generics__c',False);
                                            tempaccum.currentrecord.put('MAB_Maintenance_Drugs__c',False);
                                            tempaccum.currentrecord.put('Is_there_a_Maximum_Allowable_Benefit__c','No');
                                            tempaccum.currentrecord.put('MAB_Dedictible_Amount__c',null);
                                            tempaccum.currentrecord.put('What_is_the_In_Network_MOOP_Amount__c',null);
                                            tempaccum.currentrecord.put('What_is_the_OON_MOOP_Amount__c',null);
                                            tempaccum.currentrecord.put('MOOP_Maintenance_Drugs__c',False);
                                            tempaccum.currentrecord.put('MOOP_Out_of_Network__c',False);
                                            tempaccum.currentrecord.put('MOOP_Brand_Drugs_Generics__c',False);
                                            tempaccum.currentrecord.put('MOOP_Brand_Drugs_no_Generics__c',False);
                                            tempaccum.currentrecord.put('MOOP_Generic_Drugs__c',False);
                                            tempaccum.currentrecord.put('MOOP_In_Network__c',False);

                                          }
                                        Accumfinals.add(tempaccum);
                                    }
                            }
                            list<string> familyrecordtypes = new list<string>();
                            list<string> individualrecordtypes = new list<string>();

                                                                                  
                            map<string,string> AccumRecordtypemap = new map<string,string>();
                            for(recordtype  recordtypeitem : recordtypeaccum)
                                AccumRecordtypemap.put(recordtypeitem.name,recordtypeitem.id);
                            
                            map<String,mappingValueWrapper> Accumulationsrecordtypemap = new map<String,mappingValueWrapper>();
                            for(mappingValueWrapper tempAccum :Accumfinals){
                                Accumulationsrecordtypemap.put(String.valueof(tempAccum.currentrecord.get('recordtypeid')),tempAccum);
                            }
                            Accumfinals = new list<mappingValueWrapper>();
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Individual - All')))
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Individual - All')));
                            else{
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Individual - Retail'))){
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Individual - Retail')));
                            }
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Individual - Mail'))){
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Individual - Mail')));
                            }
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Individual - Specialty'))){
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Individual - Specialty')));
                            }
                                }
                                
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Family - All')))
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Family - All')));
                            else{ 
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Family - Retail'))){
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Family - Retail')));
                            }
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Family - Mail'))){
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Family - Mail')));
                            }
                            if(Accumulationsrecordtypemap.containskey(AccumRecordtypemap.get('Family - Specialty'))){
                                Accumfinals.add(Accumulationsrecordtypemap.get(AccumRecordtypemap.get('Family - Specialty')));
                            }
                                }
                            
                            for(mappingValueWrapper tempaccum : Accumfinals)
                                createrecordlst.add(tempaccum.currentrecord);
                            //The following performs the postbuild logic for copays
                            if (copaylst != null && copaylst.size() > 0) {
                                Id retailId = Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
                                Id mailId = Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
                                Id specialityId = Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Specialty').getRecordTypeId();
                                for (sobject copayrec: copaylst) {
                                    list < sobject > tempcopaylst = new list < sobjecT > ();
                                    if (Copays.containskey((id) copayrec.get('recordtypeid'))) {
                                        tempcopaylst = Copays.get((id) copayrec.get('recordtypeid'));
                                        tempcopaylst.add(copayrec);
                                    } else {
                                        tempcopaylst.add(copayrec);
                                    }
                                    Copays.put((id) copayrec.get('recordtypeid'), tempcopaylst);
                                    //Added By Nitish 6819
                                    if(checkDiabeticPlan && (retailId == (id) copayrec.get('recordtypeid'))){
                                        Copays.remove((id) copayrec.get('recordtypeid'));
                                    }
                                   

                                }
                            }
                            map < id, map <string, sobject >> Copaydedupelist = new map < id, map <string, sobject >> ();
                            
                            //Modified by Amit for request 5242
                            boolean rundedupe = true;
                            for(string recordtypeid : Copays.keyset()){
                                if((copayrecordtypes.get((id)recordtypeid).name == 'Retail' 
                                        || copayrecordtypes.get((id)recordtypeid).name == 'Paper' 
                                        || copayrecordtypes.get((id)recordtypeid).name == 'Mail'
                                        || copayrecordtypes.get((id)recordtypeId).name == PAPEROONLABEL) && Copays.get(recordtypeid).size() == 3){

                                        
                                        map<integer,string> tierkeys = new map<integer,string>();
                                        map<integer,sobject> tiercopaySobject = new map<integer,sobject>();
                                        map<string,sobject> copaysmap  = new map<string,sobject>();
                                        for(sobject tempcopay : Copays.get(recordtypeid)){
                                            string key = String.valueof(tempcopay.get(DOLLARAMTAPI)) + String.valueof(tempcopay.get(PERCENTAPI)) + tempcopay.get(COPAYCALCAPI) + String.valueof(tempcopay.get(MINDOLAPI)) + String.valueof(tempcopay.get(MAXDOLAPI)) + String.valueof(tempcopay.get('Days_Per_Fill__c'));
                                            tierkeys.put(Integer.valueof(tempcopay.get('Tier__c')),key);
                                            tiercopaySobject.put(Integer.valueof(tempcopay.get('Tier__c')),tempcopay);
                                        }
                                        
                                        //Changed as per D-00413 by Sushant
                                        if(tierkeys.containskey(3) && tierkeys.containskey(2) && tierkeys.containskey(1)){
                                            if((tierkeys.get(3) == tierkeys.get(2)) && (tierkeys.get(2) == tierkeys.get(1))){
                                                tierkeys.remove(3);
                                                tierkeys.remove(2);
                                            }                       
                                        }
                                        if(tierkeys.containskey(3) && tierkeys.containskey(2)){
                                            if(tierkeys.get(3) == tierkeys.get(2)){
                                                tierkeys.remove(3);
                                            }
                                        }
                                        /* 
                                        if(tierkeys.containskey(3) && tierkeys.containskey(1)){
                                            if(tierkeys.get(3) == tierkeys.get(1)){
                                                tierkeys.remove(3);
                                            }                       
                                        }
                                        */
                                        list<sobject> copaysdedupedlist = new list<sobject>();
                                        for(integer i =1 ; i <=3 ; i++){
                                            if(tierkeys.containskey(i)){
                                                copaysdedupedlist.add(tiercopaySobject.get(i));
                                            }
                                        }
                                        copays.put(recordtypeid,copaysdedupedlist);
                                        createrecordlst.addall(copaysdedupedlist);
                                        
                                }
                                else{                          
                                    map<string,sobject> copaysmap  = new map<string,sobject>();
                                    for(sobject tempcopay : Copays.get(recordtypeid)){
                                        string key = String.valueof(tempcopay.get(DOLLARAMTAPI)) + String.valueof(tempcopay.get(PERCENTAPI)) + tempcopay.get(COPAYCALCAPI) + String.valueof(tempcopay.get(MINDOLAPI)) + String.valueof(tempcopay.get(MAXDOLAPI)) + String.valueof(tempcopay.get('Days_Per_Fill__c'));
                                        if (copaysmap.containskey(key)){
                                            if(Integer.valueof(tempcopay.get('Tier__c')) < Integer.valueof(copaysmap.get(key).get('Tier__c')))
                                                copaysmap.put(key,tempcopay);
                                        }
                                        else{
                                            copaysmap.put(key,tempcopay);
                                        }                       
                                    }
                                    Copaydedupelist.put(recordtypeid,copaysmap);
                                }
                            }               
                            //Added by Sushant for fix of Observation #15 | Mapping Unit 5
                            for(string recordtypeid : Copaydedupelist.keyset()){
                            /*for(Sobject copaytier : Copaydedupelist.get(recordtypeid).values()){
                                        if(copayTier.get('tier__c') != NULL && copayTier.get('tier__c') == 3){
                                      string copayNonformulary = string.valueof(copaytier.get(DOLLARAMTAPI))+COMMAVAL+String.valueof(copaytier.get(PERCENTAPI))+COMMAVAL+String.valueof(copayTier.get(MINDOLAPI))+COMMAVAL+String.valueof(copaytier.get(MAXDOLAPI))+COMMAVAL+copaytier.get(COPAYCALCAPI);
                                      copaytier.put('Non_Formulary_String__c',copayNonformulary);
                                      }
                                      }
                                      */
                                createrecordlst.addall(Copaydedupelist.get(recordtypeid).values());
                                Copays.put(recordtypeid,Copaydedupelist.get(recordtypeid).values());
                            }
                            
                            
                            for (id recordid: Copays.keyset()) {
                                    list < sobject > tempcopays = Copays.get(recordid);
                                //Added by Amit
                                if(copayrecordtypes.get((id)recordid) != Null && tempcopays.size() == 3){
                                    for (sobject tempcopay: tempcopays) {
                                        if (tempcopay.get('Tier__c')!= Null && Integer.valueof(tempcopay.get('Tier__c')) == 3) {
                                            string copayNonformulary=BLANKVAL;
                                            string DollarAmount=BLANKVAL;
                                            string Percent =BLANKVAL;
                                            string MinimunDollar =BLANKVAL;
                                            string MaxDollar=BLANKVAL;
                                            string CopayCalc=BLANKVAL;
                                            
                                           if(tempcopays[2].get(DOLLARAMTAPI)!= Null){                                                
                                                DollarAmount = String.valueof(Decimal.valueof(string.valueof(tempcopays[2].get(DOLLARAMTAPI))).setScale(2));
                                            }
                                            if(tempcopays[2].get(PERCENTAPI)!= Null){
                                                Percent = String.valueof(Decimal.valueof(string.valueof(tempcopays[2].get(PERCENTAPI))).setScale(2));
                                            }
                                            if(tempcopays[2].get(MINDOLAPI)!= Null){
                                                MinimunDollar = String.valueof(Decimal.valueof(string.valueof(tempcopays[2].get(MINDOLAPI))).setScale(2));
                                            }
                                            if(tempcopays[2].get(MAXDOLAPI)!= Null){
                                                MaxDollar = String.valueof(Decimal.valueof(string.valueof(tempcopays[2].get(MAXDOLAPI))).setScale(2));
                                            }
                                            
                                            copayNonformulary = DollarAmount +COMMAVAL +Percent +COMMAVAL +MinimunDollar +COMMAVAL +MaxDollar +COMMAVAL +CopayCalc;
                                            tempcopays[2].put('Non_Formulary_String__c', copayNonformulary);
                                        }
                                    }
                                }
                                //Ends
                                if(copayrecordtypes.get((id)recordid) != Null){
                                    if(copayrecordtypes.get((id)recordid).name == 'Retail' 
                                        || copayrecordtypes.get((id)recordid).name == 'Paper' 
                                        || copayrecordtypes.get((id)recordid).name == 'Mail'){
                                        if (tempcopays.size() == 1 ) {
                                            tempcopays[0].put('Tier_Type__c', 'All Drugs');
                                            tempcopays[0].put('Tier__c', '1');
                                        } else {
                                            if (tempcopays.size() == 2) {
                                                for (sobject tempcopay: tempcopays) {
                                                    if (Integer.valueof(tempcopay.get('Tier__c')) != 1) {
                                                        tempcopay.put('Tier__c', '2');  
                                                        tempcopay.put('Tier_Type__c', 'Brand (SSB & MSB)'); 
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if(copayrecordtypes.get((id)recordid) != Null){
                                    if((copayrecordtypes.get((id)recordid).name == 'Specialty') || (copayrecordtypes.get((id)recordid).name == 'Specialty OON')){
                                        if (tempcopays.size() == 1 ) {
                                            tempcopays[0].put('Tier_Type__c', 'Specialty (Preferred & Non-Preferred)');
                                            tempcopays[0].put('Tier__c', '1');
                                        }
                                        else {
                                            if (tempcopays.size() == 2) {
                                                //check for same dollar amount
                                                if(tempcopays[0].get(DOLLARAMTAPI) != null && tempcopays[1].get(DOLLARAMTAPI) != null){
                                                    
                                                    if(Integer.valueof(tempcopays[0].get(DOLLARAMTAPI)) < Integer.valueof(tempcopays[1].get(DOLLARAMTAPI))){
                                                        
                                                        tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                        tempcopays[0].put('Tier__c', '1');
                                                        tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                        tempcopays[1].put('Tier__c', '2');
                                                    }
                                                    else{
                                                        
                                                        tempcopays[0].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                        tempcopays[0].put('Tier__c', '2');
                                                        tempcopays[1].put('Tier_Type__c', 'Preferred Specialty');
                                                        tempcopays[1].put('Tier__c', '1');
                                                    }
                                                }
                                                else{
                                                    
                                                    if(tempcopays[0].get(PERCENTAPI) != null && tempcopays[1].get(PERCENTAPI) != null){
                                                        
                                                     // Added by Shubham to implement ST#562 - the code to handle scenarios for specialty copays with the same Max dollar amount 
                                                        if(tempcopays[0].get(MAXDOLAPI) != null && tempcopays[1].get(MAXDOLAPI) != null && (Integer.valueof(tempcopays[0].get(MAXDOLAPI)) != Integer.valueof(tempcopays[1].get(MAXDOLAPI)))){
                                                            
                                                            if(Integer.valueof(tempcopays[0].get(MAXDOLAPI)) < Integer.valueof(tempcopays[1].get(MAXDOLAPI))){
                                                                
                                                                tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                tempcopays[0].put('Tier__c', '1');
                                                                tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                tempcopays[1].put('Tier__c', '2');
                                                            }
                                                            else{
                                                                
                                                                tempcopays[0].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                tempcopays[0].put('Tier__c', '2');
                                                                tempcopays[1].put('Tier_Type__c', 'Preferred Specialty');
                                                                tempcopays[1].put('Tier__c', '1');
                                                                
                                                            }
                                                        }else if((tempcopays[0].get(MAXDOLAPI) == null && tempcopays[1].get(MAXDOLAPI) != null) || (tempcopays[1].get(MAXDOLAPI) == null && tempcopays[0].get(MAXDOLAPI) != null )){
                                                            
                                                            //check for same percent and one copay having max dollar as not null while other has null(new sceanrio in request 06426)
                                                            if(Integer.valueof(tempcopays[0].get(PERCENTAPI)) == Integer.valueof(tempcopays[1].get(PERCENTAPI))){
                                                            system.debug('************************************vatsal***************************************');
                                                               if(tempcopays[0].get(MAXDOLAPI) == null){
                                                            system.debug('**************************************vatsal*************************************');                                                                
                                                                tempcopays[1].put('Tier_Type__c', 'Preferred Specialty');
                                                                tempcopays[1].put('Tier__c', '1');
                                                                tempcopays[0].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                tempcopays[0].put('Tier__c', '2');
                                                            }else if(tempcopays[1].get(MAXDOLAPI) == null){
                                                            system.debug('*************************************vatsal**************************************');                                                                
                                                                tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                tempcopays[1].put('Tier__c', '2');
                                                                tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                tempcopays[0].put('Tier__c', '1');
                                                            }else{
                                                                checkProvision45and46 = True;
                                                            }
                                                        }
                                                        }
                                                        else{
                                                            
                                                            //check if percent of copay[0] is lesser
                                                            if(Integer.valueof(tempcopays[0].get(PERCENTAPI)) < Integer.valueof(tempcopays[1].get(PERCENTAPI))){
                                                                
                                                                tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                tempcopays[0].put('Tier__c', '1');
                                                                tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                tempcopays[1].put('Tier__c', '2');
                                                            }//check if percent of copay[1] is lesser
                                                            else if(Integer.valueof(tempcopays[0].get(PERCENTAPI)) > Integer.valueof(tempcopays[1].get(PERCENTAPI))){
                                                                
                                                                    tempcopays[0].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                    tempcopays[0].put('Tier__c', '2');
                                                                    tempcopays[1].put('Tier_Type__c', 'Preferred Specialty');
                                                                    tempcopays[1].put('Tier__c', '1');
                                                                }
                                                            else{
                                                                
                                                                //reach here if both the percent of copay[0] and copay[1] are same.
                                                                if((Integer.valueof(tempcopays[0].get(MINDOLAPI)) != NULL) && (Integer.valueof(tempcopays[1].get(MINDOLAPI)) != NULL) ){
                                                                    
                                                                    //check for min dollar of copay[0] greater than copay[1]
                                                                if(Integer.valueof(tempcopays[0].get(MINDOLAPI)) > Integer.valueof(tempcopays[1].get(MINDOLAPI))){
                                                                    
                                                                    tempcopays[0].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                    tempcopays[0].put('Tier__c', '2');
                                                                    tempcopays[1].put('Tier_Type__c', 'Preferred Specialty');
                                                                    tempcopays[1].put('Tier__c', '1');
                                                                }//check for min dollar of copay[0] lesser than copay[1]
                                                                else if(Integer.valueof(tempcopays[0].get(MINDOLAPI)) < Integer.valueof(tempcopays[1].get(MINDOLAPI))){
                                                                    
                                                                    tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                    tempcopays[0].put('Tier__c', '1');
                                                                    tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                    tempcopays[1].put('Tier__c', '2');
                                                                }else{
                                                                    checkProvision45and46 = True;
                                                                }
                                                                }
                                                                //reach here if either of min dollar of copay[0] or copay[1] is not null and the other is null
                                                                else if((Integer.valueof(tempcopays[0].get(MINDOLAPI)) != NULL && Integer.valueof(tempcopays[1].get(MINDOLAPI)) == NULL) || (Integer.valueof(tempcopays[0].get(MINDOLAPI)) == NULL && Integer.valueof(tempcopays[0].get(MINDOLAPI)) != NULL)){
                                                                    //check if min dollar of copay[0] is not null
                                                                    
                                                                    if(Integer.valueof(tempcopays[0].get(MINDOLAPI)) != NULL && Integer.valueof(tempcopays[1].get(MINDOLAPI)) == NULL){
                                                                        
                                                                        tempcopays[0].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                        tempcopays[0].put('Tier__c', '2');
                                                                        tempcopays[1].put('Tier_Type__c', 'Preferred Specialty');
                                                                        tempcopays[1].put('Tier__c', '1');
                                                                        
                                                                    }//check if min dollar of copay[1] is not null
                                                                    else if(Integer.valueof(tempcopays[0].get(MINDOLAPI)) == NULL && Integer.valueof(tempcopays[1].get(MINDOLAPI)) != NULL){
                                                                        
                                                                        tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                        tempcopays[0].put('Tier__c', '1');
                                                                        tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                        tempcopays[1].put('Tier__c', '2');
                                                                        
                                                                    }//check for both the copays having null as min dollar
                                                                    else{
                                                                        checkProvision45and46 = True;
                                                                    }
                                                                }else if((Integer.valueof(tempcopays[0].get(MINDOLAPI)) == NULL && Integer.valueof(tempcopays[1].get(MINDOLAPI)) == NULL)){
                                                                    
                                                                        tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                        tempcopays[0].put('Tier__c', '1');
                                                                        tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                        tempcopays[1].put('Tier__c', '2');
                                                                }//check for same min dollar
                                                                else if(Integer.valueof(tempcopays[0].get(MINDOLAPI)) != NULL && Integer.valueof(tempcopays[1].get(MINDOLAPI)) != NULL && (Integer.valueof(tempcopays[0].get(MINDOLAPI)) == Integer.valueof(tempcopays[1].get(MINDOLAPI)))){
                                                                        
                                                                        tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                        tempcopays[0].put('Tier__c', '1');
                                                                        tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                        tempcopays[1].put('Tier__c', '2');
                                                                }else{
                                                                    checkProvision45and46 = True;
                                                                }
                                                            
                                                            }
                                                        }                                       
                                                    }else{
                                                        checkProvision45and46 = True;
                                                    }
                                                    //Added By Nitish 06693
                                                    if(checkProvision45and46 && (provision.containsKey(45) && provision.get(45).WS_LV_NO__c > 0 && provision.get(45).WS_LV_NO__c < 999
                                                                && provision.containsKey(46))&& provision.get(46).WS_LV_NO__c > 0 && provision.get(46).WS_LV_NO__c < 999
                                                                ){
                                                        
                                                                    if(tempcopays[0].get('Tier_Type__c') == 'Non-Preferred Specialty'){
                                                                        tempcopays[1].put('Tier_Type__c', 'Preferred Specialty');
                                                                        tempcopays[1].put('Tier__c', '1');
                                                                        tempcopays[0].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                        tempcopays[0].put('Tier__c', '2');
                                                                    }else if(tempcopays[1].get('Tier_Type__c') == 'Non-Preferred Specialty'){
                                                                        tempcopays[0].put('Tier_Type__c', 'Preferred Specialty');
                                                                        tempcopays[0].put('Tier__c', '1');
                                                                        tempcopays[1].put('Tier_Type__c', 'Non-Preferred Specialty');
                                                                        tempcopays[1].put('Tier__c', '2');
                                                                    }
           
                                                    }    
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                                                
                                }                  
                                                 
                                for (mappingValueWrapper tempwrapreccord: currentWrapRecord) {
                                    if (tempwrapreccord.sobjecttype == COPAYAPI) {
                                        if(tempwrapreccord.childobjects != null && tempwrapreccord.childobjects.size() > 0)
                                            for(mapping_values__c currentmapping : tempwrapreccord.ObjectFieldvalaues){
                                                if(currentmapping.field_api__C != 'Non_Formulary_String__c' 
                                                    && currentmapping.field_api__C != 'CRDB_Copay_Logic__c' 
                                                    && currentmapping.field_api__C != 'Tier_Type__c' 
                                                    && currentmapping.field_api__C != 'Tier__c' 
                                                    && currentmapping.field_api__C != CRDAPI){
                                                        tempwrapreccord.currentrecord.put(currentmapping.field_api__C,null);
                                                    }
                                            }                                       
                                    }
                                }                              
                            if(createrecordlst.size() > 0)
                              try{
                                database.insert(createrecordlst);
                                // Added by Ayushi for Request 06528 (ST#1191)
                                if(crdrecordinsert){
                                    cRDIdsObjectmap.put(createrecordlst[0].id,(CRD__c)createrecordlst[0]); 
                                }
                                String maplist = BLANKVAL;
                                for(id tempid :mappingSobjectMap.keyset()){
                                    maplist +=  COMMAVAL + tempid;
                                }
                              }catch(Exception ex){
                                for(sobject s :createrecordlst ){
                                }
                                throw ex;
                                
                              }  
                            if(createrecordlst2.size() > 0){
                                database.insert(createrecordlst2);
                            }    
                            
                            // Added by Ayushi for Request 06528 (ST#1191)
                            if(ischemodrugbypass && cRDIdsObjectmap.get(parentid)!=null){
                              update cRDIdsObjectmap.get(parentid);
                            }
                            
                            for (mappingValueWrapper tempwrapreccord: currentWrapRecord) {
                                if(tempwrapreccord.currentrecord.id != null && tempwrapreccord.childobjects.size() > 0){
                                    createMappingWrapperREcord(tempwrapreccord.childobjects, tempwrapreccord.currentrecord.id);
                                }

                            }
                            return currentWrapRecord;

                        }
                        
                        public void posbuildchanges(list<mappingValueWrapper> currentwraprecord){
                            boolean callnextIteration = true;
                            id crdid = null;
                                                                    
                            for(mappingValueWrapper tempwraprec : currentwraprecord){
                            
                                if(tempwraprec.sobjecttype == CRDAPI){
                                    posbuildchanges(tempwraprec.childobjects);                          
                                    callnextIteration = false;
                                }
                                if(tempwraprec.sobjecttype == DRUGCOVAPI){
                                    crdid = (id)tempwraprec.currentrecord.get('CRD_id__c');
                                }
                            }
                            if(callnextIteration){
                           
                                list<Pers_Full_Report__c > prv = new list<Pers_Full_Report__c>();                                
                                if(crdid != null)
                                    //This is to Split the 18 digit CRDID to 15 digit, as CRD__c is a formula field and will have 15 digit ID
                                    prv=[select WS_LV_NO__c,processed__c  from Pers_Full_Report__c 
                                                where CRD_Build_Order__c =:crdBuildOrderId AND WS_PROV_NUM__c= 134 limit 100];
                                     
                                if(prv.size() == 0 || (prv.size() > 0 &&  prv[0].processed__c == false)){ 
                                    list<drug_coverage__C> drugcovs = [select id,recordtype.name
                                                                        ,(select id,Drug_Group__c,drug_list__C from DC_Drug_List__r ) 
                                                                        from drug_coverage__c where crD_id__C = :crdid limit 5000];

                                    map<string,list<DC_Drug_List_Group__c>> dcdlbyrecordtype = new  map<string,list<DC_Drug_List_Group__c>>();
                                    for(drug_coverage__C tempdrugcov : drugcovs){
                                        dcdlbyrecordtype.put(tempdrugcov.recordtype.name,tempdrugcov.DC_Drug_List__r);
                                    }
                                    list<DC_Drug_Class__c> lstdrugclasses =  [select id, name,Drug_Group__c, Drug_List__c, Drug_Class__c, Inclusion_Exclusion__c, Apply_Limitations__c,Quantity_Over_Time_Quantity__c, For_Retail_Drug_Coverage__c,For_Mail_Drug_Coverage__c,Quantity_Over_Time_Time_Period__c,Quantity_Over_Time_Time_Value__c, Start_Age__c, Start_Age_Type__c,Bypass_M__c From DC_Drug_Class__c where(Mandatory__c = 'Yes' AND (For_Mail_Drug_Coverage__c = true or For_Retail_Drug_Coverage__c = True ))];
                                    map<string,list<DC_Drug_Class__c>> mapDrugclasses = new map<string,list<DC_Drug_Class__c>>();
                                    for(DC_Drug_Class__c tempdrugClass : lstdrugclasses){
                                        if(tempdrugClass.For_Mail_Drug_Coverage__c){
                                            list<DC_Drug_Class__c> tempdrugclasslst = new list<DC_Drug_Class__c>();
                                            if(mapDrugclasses.containskey('Mail')){
                                                tempdrugclasslst = mapDrugclasses.get('Mail');
                                            }
                                            tempdrugclasslst.add(tempdrugClass);
                                            mapDrugclasses.put('Mail',tempdrugclasslst);
                                        }
                                        
                                        if(tempdrugClass.For_Retail_Drug_Coverage__c){
                                            list<DC_Drug_Class__c> tempdrugclasslst = new list<DC_Drug_Class__c>();
                                            if(mapDrugclasses.containskey('Retail')){
                                                tempdrugclasslst = mapDrugclasses.get('Retail');
                                            }
                                            tempdrugclasslst.add(tempdrugClass);
                                            mapDrugclasses.put('Retail',tempdrugclasslst);
                                        }
                                    }
                                    list<DC_Drug_List_Group__c> lstDruglistGroup = new list<DC_Drug_List_Group__c>();
                                    for(mappingValueWrapper tempwraprec : currentwraprecord){
                                     
                                        if(tempwraprec.sobjecttype == DRUGCOVAPI && tempwraprec.currentrecord.id != null){
                                        if(dcdlbyrecordtype.containskey(recordtypes.get(String.valueof(tempwraprec.currentrecord.get('recordtypeid'))).Name) && tempwraprec.sobjecttype == DRUGCOVAPI && tempwraprec.currentrecord.id != null){
                                            list<string> dcdruglstdelete = new list<string>();
                                            list<string> dcdruggrpdelete = new list<string>();
                                            set<string> druglstidscreated = new set<string>();
                                            set<string> druggrpidscreated = new set<string>();
                                            
                                            for(DC_Drug_List_Group__c Childrec :dcdlbyrecordtype.get(recordtypes.get(String.valueof(tempwraprec.currentrecord.get('recordtypeid'))).Name)){
                                                druglstidscreated.add(String.valueof(Childrec.get('Drug_List__c')));                          
                                                druggrpidscreated.add(String.valueof(Childrec.get('Drug_Group__c')));
                                            }
                                            
                                            for(DC_Drug_Class__c tempdrugclass :mapDrugclasses.get(recordtypes.get(String.valueof(tempwraprec.currentrecord.get('recordtypeid'))).Name)){
                                                if(tempdrugclass.Drug_List__c !=null){
                                                    if(!druglstidscreated.contains(tempdrugclass.Drug_List__c)){
                                                        DC_Drug_List_Group__c dcRecord = new DC_Drug_List_Group__c();
                                                        dcRecord.Related_Drug_Coverage__c = tempwraprec.currentrecord.id;
                                                        dcRecord.Drug_Group__c = tempdrugclass.Drug_Group__c;
                                                        //dcRecord.Inclusion_Exclusion_Drug_Class__c = tempdrugclass.Drug_Class__c;
                                                        dcRecord.Drug_List__c = tempdrugclass.Drug_List__c;
                                                        dcRecord.Inclusion_Exclusion__c = tempdrugclass.Inclusion_Exclusion__c;
                                                        dcRecord.Apply_Limitations__c = tempdrugclass.Apply_Limitations__c;
                                                        dcRecord.Quantity_Over_Time_Quantity__c = tempdrugclass.Quantity_Over_Time_Quantity__c;
                                                        dcRecord.Quantity_Over_Time_Time_Period__c = tempdrugclass.Quantity_Over_Time_Time_Period__c;
                                                        dcRecord.Quantity_Over_Time_Time_Value__c = tempdrugclass.Quantity_Over_Time_Time_Value__c;
                                                        dcRecord.Start_Age__c = tempdrugclass.Start_Age__c;
                                                        dcRecord.Start_Age_Type__c = tempdrugclass.Start_Age_Type__c;
                                                        dcRecord.Bypass_MOOP__c = tempdrugclass.Bypass_M__c;
                                                        lstDruglistGroup.add(dcRecord);
                                                        
                                                    }
                                                }
                                                else{
                                                    if(!druggrpidscreated.contains(tempdrugclass.Drug_Group__c)){
                                                        DC_Drug_List_Group__c dcRecord1 = new DC_Drug_List_Group__c();
                                                        dcRecord1.Related_Drug_Coverage__c = tempwraprec.currentrecord.id;
                                                        dcRecord1.Drug_Group__c = tempdrugclass.Drug_Group__c;
                                                        //dcRecord1.Inclusion_Exclusion_Drug_Class__c = tempdrugclass.Drug_Class__c;
                                                        dcRecord1.Drug_List__c = tempdrugclass.Drug_List__c;
                                                        dcRecord1.Inclusion_Exclusion__c = tempdrugclass.Inclusion_Exclusion__c;
                                                        dcRecord1.Apply_Limitations__c = tempdrugclass.Apply_Limitations__c;
                                                        dcRecord1.Quantity_Over_Time_Quantity__c = tempdrugclass.Quantity_Over_Time_Quantity__c;
                                                        dcRecord1.Quantity_Over_Time_Time_Period__c = tempdrugclass.Quantity_Over_Time_Time_Period__c;
                                                        dcRecord1.Quantity_Over_Time_Time_Value__c = tempdrugclass.Quantity_Over_Time_Time_Value__c;
                                                        dcRecord1.Start_Age__c = tempdrugclass.Start_Age__c;
                                                        dcRecord1.Start_Age_Type__c = tempdrugclass.Start_Age_Type__c;
                                                        dcRecord1.Bypass_MOOP__c = tempdrugclass.Bypass_M__c;
                                                        lstDruglistGroup.add(dcRecord1);
                                                        
                                                    }
                                                }
                                            }
                                            }
                                            
                                        }
                                    }
                                    if(lstDruglistGroup != null && lstDruglistGroup.size() > 0)
                                        database.insert(lstDruglistGroup);
                                   // throw new MerchandiseException (string.valueof(lstDruglistGroup.size()));
                                        //Added By Nitish Request 6819
                                        /**
                                        if(checkDiabeticPlan){
                                            map<id,Drug_Group__c> dcdlDGMap = new Map<id,Drug_Group__c>([select id from Drug_Group__c where Name IN ('DCA-0000705','DCA-0028610')]);
                                            for(DC_Drug_List_Group__c dcdl :lstDruglistGroup){
                                                if(!dcdlDGMap.containsKey(dcdl.Drug_Group__c) && !dcdlDGMap.containsKey(dcdl.Drug_Group__c) || dcdl.Drug_Group__c == Null){
                                                    lstDruglistGroupdelete.add(dcdl);
                                                    system.debug('dcdlId +++ ' +dcdl.id);
                                                }
                                            }
                                            system.debug('lstDruglistGroupdelete++++ ' + lstDruglistGroupdelete);
                                        }**/
                                }
                                
                                
                                
                                for(mappingValueWrapper tempwraprec : currentwraprecord){
                                    list<id> dcdruglstdelete = new list<id>();
                                    list<id> dcdruggrpdelete = new list<id>();
                                    if(tempwraprec.sobjecttype == 'DC_Drug_List_Group__c'){
                                       
                                    }
                                    if(tempwraprec.sobjecttype == DRUGCOVAPI && tempwraprec.currentrecord.id != null){
                                        for(Mapping_Values__c deletemappinvalue :tempwraprec.Deleteobjects){
                                            if(deletemappinvalue.field_api__c == 'Drug_List__c')
                                                dcdruglstdelete.add(deletemappinvalue.FieldValue__c);
                                            if(deletemappinvalue.field_api__c  == 'Drug_Group__c')
                                                dcdruggrpdelete.add(deletemappinvalue.FieldValue__c);
                                        }

                                        if(dcdruglstdelete.size() > 0 || dcdruggrpdelete.size() > 0){
                                            list<DC_Drug_List_Group__c> deleterec = [select id,Related_Drug_Coverage__c,Drug_List__c 
                                                                                    from 
                                                                                        DC_Drug_List_Group__c 
                                                                                    where 
                                                                                    (drug_list__c in :dcdruglstdelete or Drug_Group__c in :dcdruggrpdelete)and Related_Drug_Coverage__c = :tempwraprec.currentrecord.id limit 5000];
                                            lstDruglistGroupdelete.addall(deleterec);
                                            
                                        }
                                    }
                                }
                                map<id,DC_Drug_List_Group__c> dcdlMap = new map<id,DC_Drug_List_Group__c>();
                                for(DC_Drug_List_Group__c dcdl : lstDruglistGroupdelete){
                                    if(!dcdlMap.containskey(dcdl.id)){
                                        dcdlMap.put(dcdl.id,dcdl);
                                    }
                                }
                                
                                database.delete(dcdlMap.values());
                                
                            }
                        }
                        
                        /** 
                        *Class:- mappingValueWrapper
                        *Description:- The following wrapper class is created to hold all the records that are to be created with their child records and the mappng values that need to be  set for that instance
                        **/
                        public Class mappingValueWrapper {
                            //This list will hold all the prov line number from where this mapping value comes
                            public List<String> provisionLines {get;set;}
                            //Wrappers varible declaration
                            public map < id, sobject > mappingSobjectMap {
                                get;
                                set;
                            }
                            public list < mappingValueWrapper > childobjects {
                                get;
                                set;
                            }
                            public list < Mapping_Values__c > Deleteobjects {
                                get;
                                set;
                            }
                            public list < Mapping_Values__c > ObjectFieldvalaues {
                                get;
                                set;
                            }
                            public Mapping_Values__c CreateRecord {
                                get;
                                set;
                            }
                            public sobject currentrecord {
                                get;
                                set;
                            }
                            public string sobjecttype {
                                get;
                                set;
                            }
                            public map < string, id > Lookupmap {
                                get;
                                set;
                            }

                            public map < string, list < sobject >> mapsbojects {
                                get;
                                set;
                            }

                            public mappingValueWrapper() {
                                //Wrappers varible initialization
                                Lookupmap = new map < string, id > ();
                                mapsbojects = new map < string, list < sobject >> ();
                                mappingSobjectMap = new map < id, sobject > ();
                                ObjectFieldvalaues = new list < Mapping_Values__c > ();
                                Deleteobjects = new list< Mapping_Values__c > ();
                                provisionLines = new List<String>();
                            }
                            public mappingValueWrapper(sobject currecord, string type) {
                                //Wrappers varible initialization
                                childobjects = new list < mappingValueWrapper > ();
                                ObjectFieldvalaues = new list < Mapping_Values__c > ();
                                Deleteobjects = new list< Mapping_Values__c > ();
                                currentrecord = currecord;
                                sobjecttype = type;
                                mapsbojects = new map < string, list < sobject >> ();
                                mappingSobjectMap = new map < id, sobject > ();
                                provisionLines = new List<String>();
                            }
                            
                            //Constructor for wrapper class
                            public void mapforValidation(list < mappingValueWrapper > currentWrapRecord) {
                                //Wrappers varible initialization
                                for (mappingValueWrapper tempwrapreccord: currentWrapRecord) {
                                    list < sobject > lstsobjects = new list < sobject > ();
                                    if (mapsbojects.containskey(tempwrapreccord.sobjecttype)) {
                                        lstsobjects = mapsbojects.get(tempwrapreccord.sobjecttype);
                                        lstsobjects.add(tempwrapreccord.currentrecord);
                                        mapsbojects.put(tempwrapreccord.sobjecttype, lstsobjects);
                                    } else {
                                        lstsobjects.add(tempwrapreccord.currentrecord);
                                        mapsbojects.put(tempwrapreccord.sobjecttype, lstsobjects);
                                    }
                                    if (tempwrapreccord.Childobjects != null && tempwrapreccord.childobjects.size() > 0) {
                                        mapforValidation(tempwrapreccord.Childobjects);
                                    }
                                }


                            }


                        }
                        

    /** 
    *Class:- MerchandiseException
    *Description:- Apex Class to extend custom exception
    **/
    public class MerchandiseException extends Exception {}    
}