global class BAC_ReadAndPopulateBatch implements Database.batchable<string>, Database.Stateful
{
   public  List<CRD_Medicare__c>lstCrdMedicare{get;set;}
   public String m_csvFile;
   public String HeaderRow;
   public integer COLUMNsize;
   private Integer m_startRow; 
   public Map<string,string> mapFieldValue = new Map<String,String>();  
   Private static transient final string RECORDTYPE = 'External Medicare CRD';
    Private static transient final string PBP = 'PBP';
    Private static transient final string FUNDING_TYPE = 'Funding Type';
    Private static transient final string FULLY_INSURED = 'Fully Insured';
    Private static transient final string I_OR_G = 'Individual or Group Plan';  
    Private static transient final string CMSPLAN = 'CMSPlanName/Plan Sponsor Name'; 
    Private static transient final string INDIVIDUAL = 'Individual';
    Private static transient final string PLANBUILDID = 'PlanBuildId';
    Private static transient final string PRODUCT = 'Product';
    Private static transient final string GROUPS = 'Group';
    Private static transient final string ADMIN = 'Admin';
    Private static transient final string SELF_INSURED = 'Self Insured';
    Private static transient final string SPLIT_FUNDED = 'Split Funded';
    Private static transient final string R = 'R';
    Private static transient final string N = 'N';
    Private static transient final string S = 'S';
    Private static transient final string COMMA = ',';
    Private static transient final string NEWSTRING = 'new';
    Private static transient final string CRDMEDICARE = 'Medicare CRD';
    Private static transient final string MEDICARENEW = 'Medicare CRD New';
    Private static transient final string TEXTPLAIN = 'text/plain; charset=UTF-8';
    Private static transient final string CSV = '.csv';
    Private static transient final string CAT = 'case';
    Private static transient final string ERR = 'An error has occured while importing data Please make sure input csv file is correct';
    Private static transient final string SPACE = '';
    Private static transient final string CARRIAGERETURN = '\r\n';
    Private static transient final string Formulary_Name = 'FormularyName'; 
    Private static transient final string Step_Therapy = 'Step Therapy';
    Private static transient final string Plan_Effective_Date = 'Plan Effective Date';
    Private static transient final string Non_PartDrug = 'Non Part D Drugs/List Name (if Included)';
    Private static transient final string Part_DMoop= 'Part D MOOP (Max Out of Pocket)';
    Private static transient final string CMS_Formulary = 'CMS FormularyID';

    
   public BAC_ReadAndPopulateBatch(){}
   //public static ID run(){....}
   global Iterable<string> start(Database.batchableContext batchableContext)
   { 
       return new CM_CSVIterator(m_csvFile);
     
   }
   global void execute(Database.BatchableContext batchableContext, List<string> scope)  
   {   
       system.debug('******JR********'+scope);
       List<String> strList = new List<string>();
       List<String> headerList = new List<string>();
      
       String currentfile = SPACE;
       Map <String,CrdCVSMedicare__c> fieldcustomMap = new map<string,CrdCVSMedicare__c>();
       List<Attachment> acclist = new List<Attachment>();
       List<case>lstCase = new List<case>();
       List<CRD_Medicare__c>lstCrdMedicare = new List<CRD_Medicare__c>();
       set<Id>setCases = new set<Id>();
       set<Id>setMedicare = new set<Id>();
       
       headerList = HeaderRow.split(COMMA); 
       integer headerListSize = headerList.size();
       
       strList = scope[0].split(COMMA);
       Integer COLUMNsize = scope[0].split(COMMA).size();
       List<RecordType> rcrdType = [SELECT Id FROM RecordType WHERE SobjectType =: CAT AND Name =:RECORDTYPE LIMIT 1];
       
       for(Integer j=COLUMNsize ;j<headerListSize ;j++ )
       {
           strList.add('');
       }
         system.debug('----'+headerListSize);  
        system.debug('----'+COLUMNsize);
       for(integer j = 0 ; j < headerListSize ; j++)
       {
           system.debug('\\\\'+strList.size());
       
          currentfile = currentfile + headerList[j] + COMMA + strList[j] + CARRIAGERETURN;
       }
       
       for(CrdCVSMedicare__c customset : [select Name, Field_Name__c, Object_API__c from CrdCVSMedicare__c]){  
            fieldcustomMap.put(customset.Name , customset);
       }
       
       CRD_Medicare__c medicare = new CRD_Medicare__c();
       
       
       integer k =0;
       string selfInsured = 'SI';
       string fullyInsured = 'FI';
       string splitfunded = 'SF';
       
        CrdCVSMedicare__c mapVal = new CrdCVSMedicare__c() ;    
        while (k < headerListSize){
           mapVal = fieldcustomMap.get(headerList[K]);
                
            if(mapVal!=null)
            {
                  String FieldName = mapVal.Field_Name__c;
                  String objName = mapVal.Object_API__c ;
                   
                //Check for contract and P2BP field on CRD Medicare
                  if(string.valueof(headerList[K])  == PBP ){
                     if(medicare.CMS_Contract_ID_Plan_PBP_ID__c == null || string.IsBlank(medicare.CMS_Contract_ID_Plan_PBP_ID__c)){
                        medicare.put(FieldName ,strList[k]);
                        mapFieldValue.put('Contract-PBP', strList[k]);
                        }
                     else{
                         if(!string.isBlank(strList[k]))
                         {
                            medicare.CMS_Contract_ID_Plan_PBP_ID__c = string.valueof(medicare.CMS_Contract_ID_Plan_PBP_ID__c + '-'+ strList[k]);
                            mapFieldValue.put('Contract-PBP', medicare.CMS_Contract_ID_Plan_PBP_ID__c);
                         }
                    }
                  }
                else {
                    medicare.put(FieldName ,strList[k]);
                }
                }
                if(string.valueof(headerList[K])  == I_OR_G){
                 system.debug('#########Entered Individual'+mapFieldValue);
                    mapFieldValue.put(headerList[K],strList[k]);                                            
                }
                if(string.valueof(headerList[K])  == CMSPLAN){
                    system.debug('#########Entered PlanSponsor'+mapFieldValue);
                    mapFieldValue.put(headerList[K],strList[k]);
                }
                if(string.valueof(headerList[K])  == PRODUCT){
                system.debug('#########Entered Product'+mapFieldValue);
                    mapFieldValue.put(headerList[K],strList[k]);
                }
                if(string.valueof(headerList[K])  == PLANBUILDID){
                system.debug('#########Entered Planbuild'+mapFieldValue);
                    mapFieldValue.put(headerList[K],strList[k]);
                }
                //New 6 field add on CRD Medicare object for ST#974
                if(string.valueof(headerList[k]) == CMS_Formulary){ 
                     mapFieldValue.put(headerList[K],strList[k]);
                    system.debug('#########CMS_Formulary'+mapFieldValue);
                }
                if(string.valueof(headerList[k]) == Formulary_Name){
                    mapFieldValue.put(headerList[K],strList[k]);
                    system.debug('#########Enter Formulary Name'+mapFieldValue);
                }
                if(string.valueof(headerList[k]) == Step_Therapy){  
                    mapFieldValue.put(headerList[K],strList[k]);
                    system.debug('#########Step_Therapy'+mapFieldValue);
                }
                if(string.valueof(headerList[k]) == Plan_Effective_Date){
                    mapFieldValue.put(headerList[K],strList[k]);
                    system.debug('#########Plan_Effective_Date'+mapFieldValue);
                }
                if(string.valueof(headerList[k]) == Non_PartDrug){
                    
                    mapFieldValue.put(headerList[K],strList[k]);
                    system.debug('#########Non_PartDrug'+mapFieldValue);
                }
                if(string.valueof(headerList[k]) == Part_DMoop){
                    
                    mapFieldValue.put(headerList[K],strList[k]);
                    system.debug('#########Part_DMoop'+mapFieldValue);
                }
                //Check for Funding type field on Crd Medicare
                    if(string.valueof(headerList[K])  == FUNDING_TYPE){
                        system.debug('^^^^'+headerList[K]);
                        if(strList[k]=='FI'){
                            medicare.Funding_Type__c = FULLY_INSURED;
                            medicare.Risk_Indicator__c='R';
                        }else if(strList[k]=='SI'){
                            medicare.Funding_Type__c = SELF_INSURED;
                            medicare.Risk_Indicator__c='N';
                        }else if(strList[k]=='SF'){
                            medicare.Funding_Type__c = SPLIT_FUNDED;
                            medicare.Risk_Indicator__c='S';
                        }else if(strList[k]==''|| strList[k]== Null){
                            medicare.Funding_Type__c = FULLY_INSURED;
                            medicare.Risk_Indicator__c='R';
                        }
                    }
                             
            k=k+1;
            system.debug('@@@@@'+mapFieldValue);
        }
        system.debug('#########'+mapFieldValue);
        system.debug('&&&&&&'+mapVal);
        //Create External case record
            case cases = new case();
            cases.status= NEWSTRING;
            cases.recordtypeid=rcrdType[0].id;
            cases.Aetna_Case_Type__c = CRDMEDICARE ;
            cases.CRD_GMF_Case_Status__c = NEWSTRING;
            cases.CRD_GMF_Case_Types__c = MEDICARENEW ; 
            cases.CRD_Benefits__c = TRUE;
            cases.CRD_Integration__c = TRUE;     
            cases.Medicare_D__c = TRUE;
            String subjects = '';
            String descriptions='';
            string products='';
            
            //Create Crd Medicare record
             Boolean errFile = false;
            CRDMedicare__c failedRecords = new CRDMedicare__c();
            Map<String,CRDMedicare__c> lstFailedRecords = new Map<String,CRDMedicare__c>();
            try{
                   system.debug('SDSDSDSD' + mapFieldValue.keyset());
                   if(mapFieldValue.containsKey(CMS_Formulary)){
                           if(mapFieldValue.get(CMS_Formulary)!='' && mapFieldValue.get(CMS_Formulary)!=null){
                              
                                 medicare.CMS_formulary_ID__c = decimal.valueof(mapFieldValue.get(CMS_Formulary));
                              
                              system.debug('#########medicare.CMS_formulary_ID__c'+medicare.CMS_formulary_ID__c);
                           }        
                    }       
                    if(mapFieldValue.containsKey(Formulary_Name)){
                        medicare.Formulary_Name__c = mapFieldValue.get(Formulary_Name);
                       system.debug('#########medicare.Formulary_Name__c'+medicare.Formulary_Name__c);
                    }
                    if(mapFieldValue.containsKey(Step_Therapy)){
                        medicare.Step_Therapy__c = mapFieldValue.get(Step_Therapy);
                       system.debug('#########medicare.Step_Therapy__c'+medicare.Step_Therapy__c);
                    }
                    if(mapFieldValue.containsKey(Plan_effective_Date)){
                        String planDate = mapFieldValue.get(Plan_effective_Date);
                        Date planEffDate = Date.parse(planDate);
                        medicare.Plan_Effective_Date__c = planEffDate;
                        system.debug('#########medicare.Step_Therapy__c'+medicare.Step_Therapy__c);
                    }
                   if(mapFieldValue.containsKey(Non_PartDrug)){
                        medicare.Non_Part_D_Drugs_List_Name__c = mapFieldValue.get(Non_PartDrug);
                        system.debug('#########medicare.Non_Part_D_Drugs_List_Name__c'+medicare.Non_Part_D_Drugs_List_Name__c);
                    }
                    if(mapFieldValue.containsKey(Part_DMoop)){
                        medicare.Part_D_MOOP__c = mapFieldValue.get(Part_DMoop);
                        system.debug('#########medicare.Part_D_MOOP__c '+medicare.Part_D_MOOP__c );
                    }
                    
            }
            catch(exception ex){
                            errFile = true;
                            failedRecords.Error_Description__c = string.valueof(ex.getMessage());
                            failedRecords.PBP_ID_del__c = medicare.CMS_Contract_ID_Plan_PBP_ID__c;
                            failedRecords.name = 'Plan Failed'+ medicare.CMS_Contract_ID_Plan_PBP_ID__c + medicare.PlanBuildID__c;
                            failedRecords.PlanBuildID__c = medicare.PlanBuildID__c;
                            failedRecords.UserId__c = userInfo.getuserid();
                            //lstFailedRecords.add(failedRecords);
                            lstFailedRecords.put(failedRecords.name,failedRecords);
                            //delete medicare;
            }

            if(mapFieldValue.get(I_OR_G)==INDIVIDUAL){
                subjects = INDIVIDUAL +' - '+mapFieldValue.get('Contract-PBP')+'  '+mapFieldValue.get(PRODUCT);
                if(subjects.contains(selfInsured)){
                    subjects = subjects.replace(selfInsured,' ');
                }else if(subjects.contains(fullyInsured)){
                    subjects = subjects.replace(fullyInsured,' ');
                }else if(subjects.contains(splitfunded)){
                    subjects = subjects.replace(splitfunded,' ');
                }
                cases.Subject = subjects;
                
                descriptions = 'Request for individual '+ mapFieldValue.get(PRODUCT)+' plan build';
                if(descriptions.contains(selfInsured)){
                    descriptions = descriptions.replace(selfInsured,'');
                }else if(descriptions.contains(fullyInsured)){
                    descriptions = descriptions.replace(fullyInsured,'');
                }else if(descriptions.contains(splitfunded)){
                    descriptions = descriptions.replace(splitfunded,'');
                }
                cases.Description = descriptions;
                
                products = mapFieldValue.get(PRODUCT)+' - '+INDIVIDUAL;
                if(products.contains(selfInsured)){
                    products = products.replace(selfInsured,'');
                }else if(products.contains(fullyInsured)){
                    products = products.replace(fullyInsured,'');
                }else if(products.contains(splitfunded)){
                    products = products.replace(splitfunded,'');
                }
                cases.Product_Medicare__c = products;
            
            }else if((mapFieldValue.get(I_OR_G)==GROUPS) && (mapFieldValue.get(CMSPLAN)==ADMIN)){
                subjects = 'Group Standard – ' + mapFieldValue.get(PLANBUILDID)+'  '+mapFieldValue.get(PRODUCT);
                if(subjects.contains(selfInsured)){
                    subjects = subjects.replace(selfInsured,' ');
                }else if(subjects.contains(fullyInsured)){
                    subjects = subjects.replace(fullyInsured,' ');
                }else if(subjects.contains(splitfunded)){
                    subjects = subjects.replace(splitfunded,' ');
                }
                cases.Subject = subjects;                               
                
                cases.Description = 'Request for group standard plan build';
                
                products = mapFieldValue.get(PRODUCT)+' - '+GROUPS; 
                if(products.contains(selfInsured)){
                    products = products.replace(selfInsured,'');
                }else if(products.contains(fullyInsured)){
                    products = products.replace(fullyInsured,'');
                }else if(products.contains(splitfunded)){
                    products = products.replace(splitfunded,'');
                }
                cases.Product_Medicare__c = products;
               
            
            }else if((mapFieldValue.get(I_OR_G)==GROUPS) && (mapFieldValue.get(CMSPLAN)!=ADMIN)){
                subjects = 'Group Custom – ' + mapFieldValue.get(CMSPLAN)+'  '+mapFieldValue.get(PRODUCT);
                if(subjects.contains(selfInsured)){
                    subjects = subjects.replace(selfInsured,' ');
                }else if(subjects.contains(fullyInsured)){
                    subjects = subjects.replace(fullyInsured,' ');
                }else if(subjects.contains(splitfunded)){
                    subjects = subjects.replace(splitfunded,' ');
                }
                cases.Subject = subjects;
                
                cases.Description = 'Request for group custom plan build';
                
                products = mapFieldValue.get(PRODUCT)+' - Group Custom'; 
                if(products.contains(selfInsured)){
                    products = products.replace(selfInsured,'');
                }else if(products.contains(fullyInsured)){
                    products = products.replace(fullyInsured,'');
                }else if(products.contains(splitfunded)){
                    products = products.replace(splitfunded,'');
                }
                cases.Product_Medicare__c = products;
                
            }
            lstCase.add(cases);             
            
            
            medicare.Status__c = NEWSTRING;
            medicare.ContractPBPPlanbuildID__c = medicare.CMS_Contract_ID_Plan_PBP_ID__c + medicare.PlanBuildID__c;
            lstCrdMedicare.add(medicare);
            system.debug('----'+lstCrdMedicare.size()); 
            system.debug('----'+medicare);
            
            //create CSV attachments for external case
            Attachment attach = new Attachment();
            attach.name = medicare.CMS_Contract_ID_Plan_PBP_ID__c + medicare.PlanBuildID__c+CSV ;
            attach.body=blob.valueof(currentfile);
            attach.ContentType = TEXTPLAIN; 
            attach.parentid = cases.id;
            acclist.add(attach); 
           
            
            if(lstCase.size()!=0 && !lstCase.IsEmpty())
            {
                
             Database.SaveResult[] sr1 = Database.insert(lstCase,false);
             for (Database.SaveResult sr:sr1){
                if(!sr.isSuccess()){
                    Database.Error err1 = sr.getErrors()[0];                    
                    failedRecords.Error_Description__c = string.valueof(sr.getErrors()[0]);
                    failedRecords.PBP_ID_del__c = lstCrdMedicare[0].CMS_Contract_ID_Plan_PBP_ID__c;
                    failedRecords.name = 'Plan Failed'+ lstCrdMedicare[0].CMS_Contract_ID_Plan_PBP_ID__c + lstCrdMedicare[0].PlanBuildID__c;
                    failedRecords.PlanBuildID__c = lstCrdMedicare[0].PlanBuildID__c;
                    failedRecords.UserId__c = userInfo.getuserid();
                    //lstFailedRecords.add(failedRecords);
                    lstFailedRecords.put(failedRecords.name,failedRecords);
                  }
             }
                    
             
                      
                          Database.SaveResult[] sr2 = Database.insert(lstCrdMedicare,false);
                          system.debug('#########sr2'+sr2);
                          for (Database.SaveResult srm:sr2){
                              if(!srm.isSuccess()){
                                Database.Error err2 = srm.getErrors()[0];
                                failedRecords.Error_Description__c = string.valueof(srm.getErrors()[0]);
                                failedRecords.PBP_ID_del__c = lstCrdMedicare[0].CMS_Contract_ID_Plan_PBP_ID__c;
                                failedRecords.name = 'Plan Failed'+ lstCrdMedicare[0].CMS_Contract_ID_Plan_PBP_ID__c + lstCrdMedicare[0].PlanBuildID__c;
                                failedRecords.PlanBuildID__c = lstCrdMedicare[0].PlanBuildID__c;
                                failedRecords.UserId__c = userInfo.getuserid();
                                //lstFailedRecords.add(failedRecords);
                                lstFailedRecords.put(failedRecords.name,failedRecords);
                                system.debug('#########lstFailedRecords'+lstFailedRecords.values());
                            }   
                          }
                      
                      system.debug('medicare  :  '+sr2 );
                      system.debug('case  :  '+sr1 );
                      
                      
                      for(integer i=0;i<lstCase.size();i++){
                          lstCrdMedicare[i].External_Medicare_CRD_Case__c = lstCase[i].id ;
                          lstCase[i].CRD_Medicare__c = lstCrdMedicare[i].id;
                          acclist[i].parentid =  lstCase[i].id;
                          setCases.add(lstCase[i].id);
                          setMedicare.add(lstCrdMedicare[i].id);
                          system.debug('#########setMedicare'+setMedicare);
                        }
                           
                       Database.SaveResult[] sr4 =  Database.update(lstCase,false);
                        for (Database.SaveResult src:sr4){
                            if(!src.isSuccess())
                                Database.Error err4 = src.getErrors()[0];
                        }
                        system.debug('#########sr4'+sr4);
                        Database.SaveResult[] sr5 = Database.update(lstCrdMedicare,false);
                        for (Database.SaveResult srmu:sr5){
                            if(!srmu.isSuccess())                        
                                Database.Error err5 = srmu.getErrors()[0];                           
                        }
                        system.debug('#########sr5'+sr5);
                        Database.SaveResult[] sr3 = Database.insert(acclist,false);
                        for (Database.SaveResult sra:sr3){
                            if(!sra.isSuccess())
                                Database.Error err3 = sra.getErrors()[0];
                        }
                    
                      for(case ct : [Select CRD_Medicare__c from case where id IN:setCases])
                      {
                          if(ct.CRD_Medicare__c == null)
                            database.delete(ct);
                      }
                
                    for(CRD_Medicare__c cm : [Select External_Medicare_CRD_Case__c from CRD_Medicare__c where id IN:setMedicare])
                      {
                          if(cm.External_Medicare_CRD_Case__c == null)
                            database.delete(cm);
                      }
                      for(CRD_Medicare__c cm1 : [Select ID from CRD_Medicare__c where id IN:setMedicare])
                      {
                          if(errFile)
                            database.delete(cm1);
                            //errFile = false;
                      }
                      
                      if(lstFailedRecords!=Null){
                        insert lstFailedRecords.values();
                        system.debug('#########lstFailedRecords'+lstFailedRecords.values());
                      }
              }         
               
                     
    }
   global void finish(Database.BatchableContext batchableContext){
        
   }
}