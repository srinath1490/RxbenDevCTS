/**
*Purpose: Apex Batch Class for creating XML for GMF objects
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*   1.0 -    Ankur           14 July 2015       Apex Batch Class for GMF XML objects
*======================================================================== 
**/
global class BAC_GMF_XMLGenerator implements Database.Batchable <GMF_XMLWrapper> {
   
    public list<GMF_XMLWrapper> passedIDs {get;set;}
    private static final string XML = 'XML__c';
    private static final string PDF = 'PDF__c';
    private static final string CVS = 'CVS__c';
    private static final string LASTSENT = 'LastSent__c';
    private static final string EXTERNALCASE = 'External_Case__c';
    private static final string CPG = 'Clinical Program Group';
    private static final string CP = 'Clinical Programs';
    private static final string DG = 'Drug Group';
    private static final string FORMULARY = 'Formulary';
    private static final string FL = 'Formulary List';
    private static final string GCC = 'Generic Code Conversion';
    private static final string OL = 'Object Lists';
    private static final string OC = 'Option Codes';
    private static final string DL = 'Drug List';
    private static final string PRIORAUTH = 'Prior Authorization';
    private static final string STEPTHERAPY = 'Step Therapy';
    private static final string QTYLMT = 'Quantity Limit';
    private static final string SENDERROR = 'Send_Error__c';

/**
* Method :- BAC_GMF_XMLGenerator()
* Description :- Contructor method to start the Batch Process
**/
    public BAC_GMF_XMLGenerator() { 
    }
    
/**
* Method :- start(Database.BatchableContext BC)
* Description :- Start Method for the Batch process
**/
    global Iterable<GMF_XMLWrapper> start(Database.BatchableContext BC) {
        return new GMF_CustomIterableWrapper(passedIDs);
    }  
      
/**
* Method :- execute(Database.BatchableContext BC, List < sObject > scope)
* Description :- Execute method where the records are processed and code logic is performed.
*                It is calling XML generate for GMF objects Method from  Class where further processing is done.
**/
    global void execute(Database.BatchableContext BC, List < GMF_XMLWrapper> scope) {
        GMFBuilderUtil.batchContext = true;
        list<sobject> objectupdate = new list<sobject>();
        sObject tempsObject;
        try{
        
        for(GMF_XMLWrapper tempscopeid : scope){
            String scopeid = string.valueof(tempscopeid.Recordid );
            pagereference temppg ;
            if(tempscopeid.Objecttype == DL){
                Drug_List__c tempformulary = new Drug_List__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject);
                GMF_XML_DrugList_RT_DrugList_controller GMFcont = new GMF_XML_DrugList_RT_DrugList_controller(StandardCont);
                temppg = GMFcont.generateXML(); 
            }
            if(tempscopeid.Objecttype == PRIORAUTH || tempscopeid.Objecttype == STEPTHERAPY || tempscopeid.Objecttype == QTYLMT){
                Drug_List__c tempformulary = new Drug_List__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject);
                GMF_XML_DrugList_RT_Others_controller GMFcont = new GMF_XML_DrugList_RT_Others_controller(StandardCont);
                temppg = GMFcont.generateXML();  
            }
            if(tempscopeid.Objecttype == GCC){
                Generic_Code_Conversion__c tempformulary = new Generic_Code_Conversion__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject);
                GMF_XML_GCC_controller GMFcont = new GMF_XML_GCC_controller(StandardCont);
                temppg = GMFcont.generateXML();  
            }
            if(tempscopeid.Objecttype == CP){
                Clinical_Program__c tempformulary = new Clinical_Program__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject);
                GMF_XML_ClinicalProgram_V2 GMFcont = new GMF_XML_ClinicalProgram_V2(StandardCont);
                temppg = GMFcont.generateXML();  
            }
            if(tempscopeid.Objecttype == CPG){
                Clinical_Program_Group__c tempformulary = new Clinical_Program_Group__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject);
                GMF_XML_ClinicalProgramGroup GMFcont = new GMF_XML_ClinicalProgramGroup(StandardCont);
                temppg = GMFcont.generateXML();      
            }
            if(tempscopeid.Objecttype == DG){
                Drug_Group__c tempformulary = new Drug_Group__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject);
                GMF_XML_DrugGroup_controller GMFcont = new GMF_XML_DrugGroup_controller(StandardCont);
                temppg = GMFcont.generateXML();  
            }
            if(tempscopeid.Objecttype == FORMULARY){
                Formulary__C tempformulary = new Formulary__C(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject );
                GMF_XML_Formulary_controller GMFcont = new GMF_XML_Formulary_controller(StandardCont);
                temppg = GMFcont.generateXML();
            }
            if(tempscopeid.Objecttype == FL){
                Formulary_List__c tempformulary = new Formulary_List__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject );
                GMF_XML_FormularyList_controller GMFcont = new GMF_XML_FormularyList_controller(StandardCont);
                temppg = GMFcont.generateXML();      
            }
            if(tempscopeid.Objecttype == OC){
                Option_Code__c tempformulary = new Option_Code__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject );
                GMF_XML_OptionCode  GMFcont = new GMF_XML_OptionCode (StandardCont);
                temppg = GMFcont.generateXML();  
            }
            if(tempscopeid.Objecttype == OL){
                Object_List__c tempformulary = new Object_List__c(id =scopeid);
                tempsObject = tempformulary;
                objectupdate.add(tempsObject);
                ApexPages.StandardController StandardCont = new ApexPages.StandardController(tempsObject );
                GMF_XML_ObjectList_controller GMFcont = new GMF_XML_ObjectList_controller(StandardCont);
                temppg = GMFcont.generateXML();  
            }
            tempsObject.put(EXTERNALCASE ,temppg.getUrl().substring(1));
            tempsObject.put(XML , True);
            tempsObject.put(SENDERROR , null);
            tempsObject.put(PDF , False);
            tempsObject.put(CVS , False);
            tempsObject.put(LASTSENT , system.Now());
        }

    }
    catch (Exception ex){
        tempsObject.put(SENDERROR , ex.getmessage());
        tempsObject.put(CVS , False);
        tempsObject.put(PDF , False);
        tempsObject.put(XML , False);
    }
    Database.update (objectupdate,false) ;
    
  }
    
/**
* Method :- finish(Database.BatchableContext BC)
* Description :- Finish Method for the batch Process
**/
    global void finish(Database.BatchableContext BC) {

    }
}