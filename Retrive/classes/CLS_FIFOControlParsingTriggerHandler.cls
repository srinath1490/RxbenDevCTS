/*Purpose: Class to Handle the Control and Parse multiple controls for FIFO Report Object
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    SUSHANT SETHI          11/17/2015           Class to Handle the Control and Parse multiple controls for FIFO Report Object
======================================================================== */
public class CLS_FIFOControlParsingTriggerHandler{
    /* Flag to check the Recursiveness of Trigger TRG_FIFOControlParsing*/
    private static boolean run = true;
    /*Boolean to Check the validity of the incoming PSS Control*/
    private static boolean validPSSControl;
    /* Method to set the Recursive Check Flag to True/False to make the Trigger Run only once */
    public static boolean runOnce(){
    /*Initial state to set the Flag*/
    if(run){
     run=false;
     return true;
    }else{
        return run;
    }
    }
    
    public static void triggerLogicMethod(map<id,FIFO_Report__c> fIFOMap){
        
                            /*List to hold the FIFO Report Objects to be Inserted*/
                    list<FIFO_Report__c> recList = new list<FIFO_Report__c>();
                    
                    /*For Loop to Iterate for all the FIFO Report Records in Scope*/
                    for(FIFO_Report__c fIFOObj : fIFOMap.values()){
                            
                            /* check for PSS Control field to have NULL or Blank value */
                            if(fIFOObj.PSS_Control__c != NULL && fIFOObj.PSS_Control__c != ''){
/*Validate the pattern of the incoming PSS Control to have exactly 7 Digit Comma Separated Controls*/
                                string controlValue = string.valueof(fIFOObj.PSS_Control__c);
                                if(pattern.matches('([0-9]{1,7})?(,[0-9]{1,7})*', (controlValue))){
                                    validPSSControl = true;
                                }else{
                                    validPSSControl = false;
                                }
                            
                        if(validPSSControl){
                    
                            /* Convert PSS Control field to String Array and note it's size to determine the number of records which will be inserted */
                            string pss = string.valueof(fIFOObj.PSS_Control__c);     
                            string[] pssControls = pss.split(',');
                            /* Flag to hold the size */
                            integer controlCount = pssControls.size(); 
                            FIFO_Report__c fIFOInstance = new FIFO_Report__c(id = fIFOObj.id,key__c = fIFOObj.key__c);
                            
                            /* In case of numeric PSS, just update the incoming record to have the Control field populated as PSS Control Field */
                            fIFOInstance.control__c = integer.valueof(pssControls[0]);
                            recList.add(fIFOInstance);
                                /* For loop to iterate n number of times, inserting n-1 records of FIFO Report object, each having a different PSS Control from the string */
                                for(integer i=1; i<controlCount;i++){
                                    /*Clone the first record n times */
                                    FIFO_Report__c fIFORec = fIFOObj.clone();
                                    /*Put value of control from the incoming PSS Controls*/
                                    fIFORec.control__c = integer.valueof(pssControls[i]);
                    
                                    /*Replace the Control characters in the Key with the Control of the FIFO Rec*/

                                    string recControl = string.valueof(fIFORec.control__c);
                                    string keyInitial = fIFORec.key__c;
                                    string newKey = keyInitial.replaceFirst(string.valueof(fIFOInstance.Control__c),recControl);
                                    fIFORec.key__c = newKey;
                                    /* Add the new records to the List */
                                    recList.add(fIFORec); 
                            
                            }
                            /* Insert the list of FIFO Report Object */  
                            Database.upsertresult[] upsertresults= Database.upsert(reclist,FIFO_Report__c.Fields.key__c,false); 
                            /*In case of failure, log the error message in the Error Log Object*/
                            list<Error_log__c> errorLogRecList = new list<Error_log__c>();
                            for(Database.UpsertResult resultRec : upsertresults){
                            /*Check for Error Entries*/
                                if(!resultRec.isSuccess()){
                                    Error_log__c errorLogEntry = new Error_log__c();
                                    errorLogEntry.subject__c = 'FIFO Control Parsing Error';
                                    for(Database.error s : resultRec.geterrors()){
                                        errorLogEntry.Error_Description__c = errorLogEntry.Error_Description__c +  ',' + s;  //handle multiple errors
                                    }
                                    errorLogRecList.add(errorLogEntry);
                                }
                            }
                            if(!errorLogRecList.isempty()){
                                Database.insert(errorLogRecList);
                            }
                }else if(!validPSSControl){
                                fIFOObj.addError('Invalid PSS Control Format');
                            
                            }
                        }
                    }
                     }                 
    }