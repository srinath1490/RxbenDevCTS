public without sharing class CRDBuildOrchestration{
    integer BATCHSIZE; 
    Integer BATCHSIZEDefault;
    Integer BATCHSIZEBuild;
    Integer BATCHSIZEValidation;
    Integer BATCHSIZEcompletion;
    Integer BATCHSIZEDAIlogs;
    Integer BATCHSIZEaisend;
    Integer BATCHSIZExml;
    Integer BATCHSIZEpdf;
    Integer BATCHSIZEDcvs;
    
    
    
    public CRDBuildOrchestration(){
        BATCHSIZEDefault=Integer.valueOf(system.label.CRDBuilder_DefaultBatchsize);
        BATCHSIZEBuild=Integer.valueOf(system.label.CRDBuilder_BuildBatchsize);
        BATCHSIZEValidation=Integer.valueOf(system.label.CRDBuilder_ValidationBatchsize);
        BATCHSIZEcompletion=Integer.valueOf(system.label.CRDBuilder_CompleteBatchsize);
        BATCHSIZEDAIlogs=Integer.valueOf(system.label.CRDBuilder_AIlogsBatchsize);
        BATCHSIZEaisend=Integer.valueOf(system.label.CRDBuilder_AIcallBatchsize);
        BATCHSIZExml=Integer.valueOf(system.label.CRDBuilder_XMLBatchsize);
        BATCHSIZEpdf=Integer.valueOf(system.label.CRDBuilder_PDFBatchsize);
        BATCHSIZEDcvs=Integer.valueOf(system.label.CRDBuilder_CVSBatchsize);


    }
    public void callNext(string callerName){
        if(callerName!=NULL&&callerName!=''&&!System.Label.BypassCRDAutoLinking.equalsIgnoreCase('true')){
                 string cname=callerName.trim();
                 if(cname.equalsIgnoreCase('Batch_CRDBuildStep')){
                        callBatch_Validate();
                 }
                 else if(cname.equalsIgnoreCase('Batch_ValidateStep')){
                        callBatch_CheckCompletion();
                 }
                 else if(cname.equalsIgnoreCase('Batch_CompleteStep')&&system.label.CRDBuilder_fullAuto.equalsIgnoreCase('true')){ //else BCT will send ALL crds to AI.
                        callBatch_sendtoAI();
                 }
                 else if(cname.equalsIgnoreCase('Batch_AIlogs')&&system.label.CRDBuilder_fullAuto.equalsIgnoreCase('true')){ //else BCT will send ALL crds to AI.
                        callBatch_sendtoAI();
                 }
        }
   }

   public Id callBatch_Validate(){
       String batchprocessid = '';
         /*select CRD use schema classes to build query.
         where validate,complete,aicallout=false and automated=true and validDone=false
        Batch_customValidation bch=new Batch_customValidation(query string);
        ID batchprocessid = Database.executeBatch(bch,BATCHSIZEValidation);
        also create a joblog using joblogger class
        */
        return batchprocessid;
   }

   public Id callBatch_CheckCompletion(){
        String batchprocessid = '';
         /*bch=new Batch_CompleteStep(query string);
        ID batchprocessid = Database.executeBatch(bch,BATCHSIZEcompletion);
        also create a joblog using joblogger class*/
        return batchprocessid;
   }

   public Id callBatch_AIlogs(){
        String batchprocessid = '';
          /*select CRD use schema classes to build query. where validate, complete,automated=true and aicallout=false and CalloutDone=false
        Batch_AIlogs bch=new Batch_AIlogs(query string);
        ID batchprocessid = Database.executeBatch(bch,BATCHSIZEDAIlogs);
        also create a joblog using joblogger class
        */
        return batchprocessid;
   }

   public Id callBatch_sendtoAI(){
       String batchprocessid = '';
         /*select AIlogs and use schema classes to build query.  where createdDate=today and sent=false
        Batch_sendtoAI bch=new Batch_sendtoAI(query string);
        ID batchprocessid = Database.executeBatch(bch,BATCHSIZEaisend);
        also create a joblog using joblogger class
        */
        return batchprocessid;
   }
}