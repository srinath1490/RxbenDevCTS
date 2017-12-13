public without sharing class SS_caseAutomationStarterCtrl {
    public CaseAuto_BatchLinker linker;
    public Boolean LimitedExecution {get;set;}
    public Boolean LimitbyDefault {get;set;}
    public Boolean LimitBy {get;set;}
    public Boolean DateLimitDefault {get;set;}
    public Boolean DateLimit {get;set;}
    public datetime dtStart {get;set;}
    public datetime dtEnd {get;set;}
    integer BATCHSIZE;
    public integer LimitByvalue {get;set;}
    public Boolean showApexJob {get;set;}
    public String JobId{get;set;}    
    public Boolean confirmForceRun{get;set;}
    public Boolean confirmFallout{get;set;}
    public Boolean confirmSuccessPkg{get;set;}
    public Boolean confirmSuccessNonPkg{get;set;}
    public Boolean confirmPERSpkg{get;set;}
    public Boolean confirmPERSnonpkg{get;set;}
    
    public List<AsyncApexJob> ApexJobList {
        get{
             return [select Id,CreatedDate,JobType,Status,ExtendedStatus,TotalJobItems,JobItemsProcessed,NumberOfErrors,CompletedDate,ApexClass.Name,MethodName from AsyncApexJob where CreatedDate=TODAY AND createdBy.FirstName='Saraag' AND JobType='BatchApex' ORDER BY CreatedDate DESC LIMIT 7 ];
        }
        set;}


    public SS_caseAutomationStarterCtrl(){
        linker=new CaseAuto_BatchLinker();
        BATCHSIZE=Integer.valueOf(system.label.CaseAutho_Batchsize);
        initializeOptions();
        ApexJobList=new List<AsyncApexJob>();
        showApexJob=false;
    }
    public pagereference fallout(){
    if(confirmForceRun&&confirmFallout){
    
      if(LimitedExecution){
           if(getFilters()!=NULL){
                String qry='';   
                Schema.DescribeSObjectResult  DescribeRec=NotificationFallout__c.sObjectType.getDescribe();
                Map<String, Schema.SObjectField> parentFieldsMap= DescribeRec.fields.getMap();
                    for (String s:parentFieldsMap.keyset()){
                       qry+=s+',';
                    }
                    
                qry=qry.left(qry.length()-1); 
                String query = 'SELECT '+qry+ ' FROM NotificationFallout__c WHERE Processed__c=False'+getFilters();
                ID batchJob= database.executeBatch(new BAT_TradFallNotifProcessor(query),BATCHSIZE );
                JobLogger.create(batchJob,'TraditionalFallout');

                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started Fallout Batch:'+batchJob);
                ApexPages.addMessage(myMsg);
                initializeOptions();

                return NULL;
            }
            else{
                initializeOptions();
                return NULL;
            }
        }
        else{ //standard process
            if(!anythingelseselected()){
            falloutStd();
            }
            else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm limits');
                ApexPages.addMessage(myMsg);
            }
            initializeOptions();
            
            return NULL;
        }
      }
      else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm forced run' );
                ApexPages.addMessage(myMsg);
                initializeOptions();

                return NULL;
      }
    }
    
     public pagereference GenericRun(){
    if(confirmForceRun){
    
      if(LimitedExecution){
           if(getFilters()!=NULL){
                String qry='';   
                Schema.DescribeSObjectResult  DescribeRec=NotificationFallout__c.sObjectType.getDescribe();
                Map<String, Schema.SObjectField> parentFieldsMap= DescribeRec.fields.getMap();
                    for (String s:parentFieldsMap.keyset()){
                       qry+=s+',';
                    }
                    
                qry=qry.left(qry.length()-1); 
                String query = 'SELECT '+qry+ ' FROM NotificationFallout__c WHERE Processed__c=False'+getFilters();
                ID batchJob= database.executeBatch(new BAT_TradFallNotifProcessor(query),BATCHSIZE );
                JobLogger.create(batchJob,'TraditionalFallout');

                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started Fallout Batch:'+batchJob);
                ApexPages.addMessage(myMsg);
                initializeOptions();

                return NULL;
            }
            else{
                initializeOptions();
                return NULL;
            }
        }
        else{ //standard process
            if(!anythingelseselected()){
            falloutStd();
            }
            else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm limits');
                ApexPages.addMessage(myMsg);
            }
            initializeOptions();
            
            return NULL;
        }
      }
      else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm forced run' );
                ApexPages.addMessage(myMsg);
                initializeOptions();

                return NULL;
      }
    }
    
    
    public pageReference StdPkg(){
    if(confirmForceRun&&ConfirmSuccessPkg){
       if(LimitedExecution){

          if(getFilters()!=NULL){
                Schema.DescribeSObjectResult  DescribeRec=NotificationStandard__c.sObjectType.getDescribe();
                Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
                String qry='';
                for(String s:FieldsMap.keyset()){
                   qry+=s+',';
                }
                qry=qry.left(qry.length()-1); 
                        
                string s='SELECT id FROM NotificationStandard__c where Package__c=true AND Processed__c=false'+getFilters();
                BAT_TradStdPkgProcessor bch=new BAT_TradStdPkgProcessor(s);
                ID batchprocessid = Database.executeBatch(bch,BATCHSIZE);
                JobLogger.create(batchprocessid,'TraditionalStdPkg');

                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started Standard Package Batch:'+batchprocessid );
                ApexPages.addMessage(myMsg);
                initializeOptions();

                return NULL;
            }
            else{ //options were incorrect.
                initializeOptions();
                return NULL;
            }
        }
        else{ //Standard mode
     
           if(!anythingelseselected())
            StdPkgStd();
           else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm limits');
                ApexPages.addMessage(myMsg);
            }
            initializeOptions();
            return NULL;
        }
      }
      else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm forced run' );
                ApexPages.addMessage(myMsg);
                initializeOptions();

                return NULL;
      }
    }
    
    public pageReference stdnpkg(){
    if(confirmForceRun&&confirmSuccessNonPkg){
        if(LimitedExecution){
            if(getFilters()!=null){
                Schema.DescribeSObjectResult  DescribeRec=NotificationStandard__c.sObjectType.getDescribe();
                //get all field names
                Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
                String qry='';
                for(String s:FieldsMap.keyset()){
                   qry+=s+',';
                }
                qry=qry.left(qry.length()-1); //removing the extra comma
                        
                string s='SELECT Id FROM NotificationStandard__c where Package__c=false AND Processed__c=false'+getFilters();                            
                BAT_TradStdNPkgProcessor bch=new BAT_TradStdNPkgProcessor(s);
                ID batchprocessid= Database.executeBatch(bch,BATCHSIZE);
                JobLogger.create(batchprocessid,'TraditionalStdNon-Pkg');

                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started Standard non package Batch:'+batchprocessid );
                ApexPages.addMessage(myMsg);
                initializeOptions();
                return NULL;
            }
            else{ //options were incorrect.
                initializeOptions();
                return NULL;
            }
        }
        else{ //standard mode
           if(!anythingelseselected())
            stdnpkgStd();
            else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm limits');
                ApexPages.addMessage(myMsg);
            }
            initializeOptions();
            return NULL;
        }
      }
      else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm forced run' );
                ApexPages.addMessage(myMsg);
                initializeOptions();
                return NULL;
      }
    }
    
    public pageReference PersPkg(){
       if(confirmForceRun&&confirmPERSpkg){
        if(LimitedExecution){
            if(getFilters()!=null){
                Schema.DescribeSObjectResult  DescribeRec=PERS_report__c.sObjectType.getDescribe();
                //get all field names
                Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
                String qry='';
                for(String s:FieldsMap.keyset()){
                   qry+=s+',';
                }
                qry=qry.left(qry.length()-1); //removing the extra comma
                      
                 string s='SELECT Id FROM PERS_report__c where  Package__c=\'true\' AND Processed__c=False'+getFilters();       
                 BAT_PERSPkgProcessor bch=new BAT_PERSPkgProcessor(s);
                 ID batchprocessid= Database.executeBatch(bch,BATCHSIZE);
                 JobLogger.create(batchprocessid,'PERSPkg');

                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started PERS package Batch:'+batchprocessid );
                 ApexPages.addMessage(myMsg);
                 initializeOptions();
                 return NULL;
            }
            else{ //incorrect options
                   initializeOptions();

                return NULL;
            }
        }
        else{ //standard mode.
           if(!anythingelseselected())
            PersPkgStd();
            else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm limits');
                ApexPages.addMessage(myMsg);
            }
            initializeOptions();
            return NULL;
        }
      }
      else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm forced run' );
                ApexPages.addMessage(myMsg);
                initializeOptions();
                return NULL;
      }
    }
    
    public pagereference PersNPkg(){
     if(confirmForceRun&&confirmPERSnonpkg){

        if(LimitedExecution){
            if(getFilters()!=NULL){
                Schema.DescribeSObjectResult  DescribeRec=PERS_report__c.sObjectType.getDescribe();
                //get all field names
                Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
                String qry='';
                for(String s:FieldsMap.keyset()){
                   qry+=s+',';
                }
                qry=qry.left(qry.length()-1); //removing the extra comma
                        
                string s='SELECT Id FROM PERS_report__c where  Package__c=\'false\' AND Processed__c=False'+getFilters();
                BAT_PERSNonPkgProcessor bch=new BAT_PERSNonPkgProcessor(s);
                ID batchprocessid= Database.executeBatch(bch,BATCHSIZE);
                JobLogger.create(batchprocessid,'PERSNon-Pkg');

                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started PERS non package Batch:'+batchprocessid );
                ApexPages.addMessage(myMsg);
                initializeOptions();
                return NULL;
            }
            else{ //incorrect options
                initializeOptions();
                return NULL;

            }
        }
        else{ //standard mode
           if(!anythingelseselected())
            PersNPkgStd();
            else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm limits');
                ApexPages.addMessage(myMsg);
            }
            initializeOptions();
            return NULL;
        }
     }
     else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Please confirm forced run' );
          ApexPages.addMessage(myMsg);
          initializeOptions();
          return NULL;
      }
    }


    public pagereference showApexJobs(){
        showApexJob=true;
        return NULL;
    }
    private pagereference falloutStd(){
        Id batchProcessid=linker.callTradFallout();
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started Fallout Batch:'+batchprocessid );
        ApexPages.addMessage(myMsg);
        return NULL;
    }

    private pagereference StdPkgStd(){
         Id batchProcessid=linker.callTradStdPkg();
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started Standard package Batch:'+batchprocessid );
         ApexPages.addMessage(myMsg);
        return NULL;
    }

    private pagereference stdnpkgStd(){
         Id batchProcessid=linker.callTradStdNonPkg();
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started Standard non package Batch:'+batchprocessid );
         ApexPages.addMessage(myMsg);
        return NULL;
    }

    private pagereference PersPkgStd(){
         Id batchProcessid=linker.callTradPERSPkg();
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started PERS package Batch:'+batchprocessid );
         ApexPages.addMessage(myMsg);
        return NULL;
    }

    private pagereference PersNPkgStd(){
         Id batchProcessid=linker.callTradPERSNonPkg();
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Started PERS non package Batch:'+batchprocessid );
         ApexPages.addMessage(myMsg);
        return NULL;
    }

    public string getFilters(){
         string query='';
         if(((LimitBy||LimitbyDefault)&&(DateLimit||DateLimitDefault))||(LimitBy&&LimitbyDefault)||(DateLimit&&DateLimitDefault)){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Can only select one limiting option');
             ApexPages.addMessage(myMsg);
             query='';
             initializeOptions();
             return NULL;
         }

         else{
           
            if(LimitbyDefault)
                  query = ' ORDER BY Name ASC LIMIT 2000';
            else if(LimitBy){
                 if(LimitByvalue!=NULL&&Integer.valueOf(LimitByvalue)>0)
                   query = ' ORDER BY Name ASC LIMIT '+LimitByvalue;
                 else{
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Invalid Limit value');
                         ApexPages.addMessage(myMsg);
                         query='';
                         initializeOptions();
                         return NULL;
                 }

            }else if(DateLimitDefault){
                    query = ' AND CreatedDate=YESTERDAY ORDER BY Name DESC';

            }else if(DateLimit){
                    query = ' AND CreatedDate>='+dtstart.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+' AND CreatedDate<='+dtend.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+' ORDER BY Name DESC';

            }
            
            
       }
       return query;
    }

    private void initializeOptions(){

            LimitbyDefault=false;
            LimitBy=false;
            DateLimitDefault=false;
            DateLimit=false;
            dtStart=NULL;
            dtEnd=NULL;
            LimitedExecution=false;
            confirmForceRun=false;
            LimitByvalue=NULL;
            confirmFallout=false;
            confirmSuccessPkg=false;
            confirmSuccessNonPkg=false;
            confirmPERSpkg=false;
            confirmPERSnonpkg=false;
    }
    
    private Boolean anythingelseselected(){
        return (LimitBy||LimitbyDefault||DateLimit||DateLimitDefault);

    }
    
    public pageReference cancelJob(){
        if(jobId!=null&&JobId!=''){
            system.abortJob(jobId);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.CONFIRM,'Cancelled Job:'+JobId);
            ApexPages.addMessage(myMsg);
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.WARNING,'Job Id is blank');
            ApexPages.addMessage(myMsg);
        }
        return NULL;
    }

}