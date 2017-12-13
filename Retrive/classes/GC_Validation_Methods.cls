/*Purpose: Global apex class for common apex validation methods .                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ANUJ                08/25/2011       Global apex class for common apex validation methods 
   1.1 -    ANUJ                01/19/2012       commented the accumulation section to remove an obolete validation  
   1.2 -    SOURABH             02/22/2012       New Validation method for DC Drug List/Group Object
   1.3 -    Abhishek            07/17/2015       Fixed error of CPU Time limit excedded for support ticket 216 
   1.4      Vikram              12/01/2015       Modified to implement request 06211
======================================================================== */
public  Class GC_Validation_Methods{

    PRIVATE STATIC FINAL STRING ALLOWOVERRIDE = 'Allow Rule to be overridden';
    PRIVATE STATIC FINAL STRING DRUGSPECIFICACCUM = 'Drug Specific Accum';
    PRIVATE STATIC FINAL STRING DRUGSPECIFICCOPAY = 'Drug Specific Copay'; 
    
    public list<String> errorMessages=new list<String>();
    
    /**
    * Method :- GC_Validation_Methods
    * Description :- This method acts as an constuctor
    **/
    public GC_Validation_Methods(){
         try{
        }
        catch(exception ex){
            string error = ex.getMessage();
        }
    }
    
    /**
    * Method :- validateAccums4thQuarter
    * Description :- This method checks Deuductible_Accumulation_from_4th_Qtr__c should not be null when we habe value in  Deuductible_Accumulation_from_4th_Qtr__c
    **/    
        public Boolean validateAccums4thQuarter(Accumulations__c accumulation){
        boolean isValid = true; 
        try{
            
            if((accumulation.Deuductible_Accumulation_from_4th_Qtr__c!=null)&&(accumulation.Deuductible_Accumulation_from_4th_Qtr__c==null)){
                accumulation.Deuductible_Accumulation_from_4th_Qtr__c.addError(system.Label.ERR00128);             
                isValid=false;
                
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid ;
        }
    
      Public Boolean formularyDateRangeValid(list<Formulary_List_Entry__c> formularyEntryList){       
        boolean isCorrect = True;
        for(Integer i=0;i<formularyEntryList.size()-1;i++){
            Date termdate = formularyEntryList[i].Termination_Date__c;
            
            String mainString =formularyEntryList[i].GPI__c+formularyEntryList[i].MS_Code_M__c+formularyEntryList[i].MS_Code_N__c+formularyEntryList[i].MS_Code_O__c+formularyEntryList[i].MS_Code_Y__c+formularyEntryList[i].NDC__c+formularyEntryList[i].Formulary_List__c+String.valueOf(formularyEntryList[i].Action__c);
            
            for(Integer j=i+1;j<formularyEntryList.size();j++){
                if(mainString == formularyEntryList[j].GPI__c+formularyEntryList[j].MS_Code_M__c+formularyEntryList[j].MS_Code_N__c+formularyEntryList[j].MS_Code_O__c+formularyEntryList[j].MS_Code_Y__c+formularyEntryList[j].NDC__c+formularyEntryList[j].Formulary_List__c+String.valueOf(formularyEntryList[j].Action__c)){
                    if(formularyEntryList[i].Effective_Date__c>=formularyEntryList[j].Effective_Date__c && formularyEntryList[i].Effective_Date__c<=formularyEntryList[j].Termination_Date__c){
                         isCorrect = false;
                     }
                     else if(formularyEntryList[i].Termination_Date__c>=formularyEntryList[j].Effective_Date__c && formularyEntryList[i].Termination_Date__c<=formularyEntryList[j].Termination_Date__c){
                        isCorrect = false; 
                     }/*Commented by Amit for ST# 978 on 4 Feb, 2016      
                     else if(formularyEntryList[j].Effective_Date__c <= formularyEntryList[i].Effective_Date__c && formularyEntryList[j].Effective_Date__c <=formularyEntryList[i].Termination_Date__c){
                            isCorrect = false;
                      }
                     else if(formularyEntryList[j].Effective_Date__c <= formularyEntryList[i].Termination_Date__c && formularyEntryList[j].Termination_Date__c <=formularyEntryList[i].Termination_Date__c){
                            isCorrect = false;      
                         system.debug('****2****');            
                    }*/
                   /* if(formularyEntryList[j].Effective_Date__c <= formularyEntryList[i].Effective_Date__c && formularyEntryList[i].Effective_Date__c <=formularyEntryList[j].Termination_Date__c){
                        isCorrect = false;
                        system.debug('****1****');
                    }
                    else if(formularyEntryList[j].Effective_Date__c <= formularyEntryList[i].Termination_Date__c && formularyEntryList[i].Termination_Date__c <=formularyEntryList[j].Termination_Date__c){
                        isCorrect = false;      
                         system.debug('****2****');            
                    }*/
                  
                } 
            } 
        }
        return isCorrect;     
    }
    
    
    
    
    
    
    Public Boolean dateRangeValid(list<Drug_List_Criteria__c> drugcriterialist){       
        boolean isCorrect = True;
        for(Integer i=0;i<drugcriterialist.size()-1;i++){
            Date termdate = drugcriterialist[i].Term__c;
            /* Rakesh 10/17 (req. 00919) - Added *drugcriterialist[i].Funding_Type__c* and *drugcriterialist[j].Funding_Type__c* to strings below*/
            String mainString =String.valueof(drugcriterialist[i].Drug_Type_Code__c)+String.valueof(drugcriterialist[i].Drug_Code_Value__c)+drugcriterialist[i].MS_Code_M__c+drugcriterialist[i].MS_Code_N__c+drugcriterialist[i].MS_Code_O__c+drugcriterialist[i].MS_Code_Y__c+drugcriterialist[i].Rx__c+drugcriterialist[i].OTC__c+drugcriterialist[i].Repack__c+drugcriterialist[i].DESI__c+drugcriterialist[i].Maintenance__c+drugcriterialist[i].Non_Maintenance__c+drugcriterialist[i].Route__c+ drugcriterialist[i].DAW_Code__c+ drugcriterialist[i].NDC__c + drugcriterialist[i].Funding__c;
            for(Integer j=i+1;j<drugcriterialist.size();j++){
                //assigned a string into a variable than compare with mainstring.
                String subString = String.valueof(drugcriterialist[j].Drug_Type_Code__c)+String.valueof(drugcriterialist[j].Drug_Code_Value__c)+drugcriterialist[j].MS_Code_M__c+drugcriterialist[j].MS_Code_N__c+drugcriterialist[j].MS_Code_O__c+drugcriterialist[j].MS_Code_Y__c+drugcriterialist[j].Rx__c+drugcriterialist[j].OTC__c+drugcriterialist[j].Repack__c+drugcriterialist[j].DESI__c+drugcriterialist[j].Maintenance__c+drugcriterialist[j].Non_Maintenance__c+drugcriterialist[j].Route__c+drugcriterialist[j].DAW_Code__c + drugcriterialist[j].NDC__c + drugcriterialist[j].Funding__c;
                if(mainString == subString){
                    if (drugcriterialist[j].Effective__c > termdate) {
                        termdate = drugcriterialist[j].Term__c;                   
                    } else {
                        isCorrect = false;
                    }   
                } 
            } 
        }
       return isCorrect;     
    }
    
   
    /**
    * Method :- validateNDC
    * Description :- This method validates the data on the New Druglist Screen
    **/    
    public boolean validateNDC(list<VFP_DrugListController.wrapperclass> drugcriterialist){       
        errorMessages.clear();
        boolean isCriteraMet = true; 
        for(VFP_DrugListController.wrapperclass wrap: drugcriterialist){
            //Validating the NDC code now
            if(wrap.criterialist.Drug_Type_Code__c!=null && wrap.criterialist.Drug_Type_Code__c== system.Label.CL0000003){
                if(wrap.criterialist.Drug_Code_Value__c!=null){             
                    if(wrap.criterialist.Drug_Code_Value__c.length()!=6 && wrap.criterialist.Drug_Code_Value__c.length()!=10 && wrap.criterialist.Drug_Code_Value__c.length()!=11){
                        isCriteraMet = false;
                        errorMessages.add(system.Label.ERR00040); 
                    }               
                    if(wrap.criterialist.Drug_Code_Value__c.length()==6){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=5){
                            isCriteraMet = false;                       
                            errorMessages.add(system.Label.ERR00036); 
                        }
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==10){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=9){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00031);                         
                        }                   
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==11){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=-1){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00048); 
                        }                   
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.contains('*')){
                        string drugCodeValue = wrap.criterialist.Drug_Code_Value__c;
                        drugCodeValue = drugCodeValue.substring(0,drugCodeValue.lastIndexof('*'));
                        try{
                            double.valueof(drugCodeValue);
                        }
                        catch(exception e){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00018);     
                        } 
                    }
                }  
            }
            
            //Validating the GPI code now/
            if(wrap.criterialist.Drug_Type_Code__c!=null && wrap.criterialist.Drug_Type_Code__c==system.Label.CL0000004){
                if(wrap.criterialist.Drug_Code_Value__c!=null){             
                    if(wrap.criterialist.Drug_Code_Value__c.length()!=3 && wrap.criterialist.Drug_Code_Value__c.length()!=5 && wrap.criterialist.Drug_Code_Value__c.length()!=7 && wrap.criterialist.Drug_Code_Value__c.length()!=9 && wrap.criterialist.Drug_Code_Value__c.length()!=11&& wrap.criterialist.Drug_Code_Value__c.length()!=13 && wrap.criterialist.Drug_Code_Value__c.length()!=14){
                        isCriteraMet = false;
                        errorMessages.add(system.Label.ERR00041); 
                    }               
                    if(wrap.criterialist.Drug_Code_Value__c.length()==3){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=2){
                            isCriteraMet = false;                       
                            errorMessages.add(system.Label.ERR00034); 
                        }
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==5){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=4){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00035);                      
                        }                   
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==7){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=6){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00037);                      
                        }                   
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==9){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=8){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00038);                      
                        }                   
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==11){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=10){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00032);                         
                        }                   
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==13){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')==-1 || wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=12){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00033);                         
                        }                   
                    }
                    if(wrap.criterialist.Drug_Code_Value__c.length()==14){
                        if(wrap.criterialist.Drug_Code_Value__c.indexOf('*')!=-1){
                            isCriteraMet = false;
                            errorMessages.add(system.Label.ERR00049); 
                        }                   
                    }
                }
            }
            
            //Validating the MNT code now/
            if(!wrap.criterialist.Non_Maintenance__c  && !wrap.criterialist.Maintenance__c){
                isCriteraMet = false;   
                errorMessages.add(system.Label.ERR00005);
            }
            //Validating the MS code now
            if(!wrap.criterialist.MS_Code_M__c&& !wrap.criterialist.MS_Code_N__c&& !wrap.criterialist.MS_Code_O__c&& !wrap.criterialist.MS_Code_Y__c){
                isCriteraMet = false;   
                errorMessages.add(system.Label.ERR00006);
            }
            //Validating the RX and OTC code now
            if(!wrap.criterialist.Rx__c  && !wrap.criterialist.OTC__c){
                isCriteraMet = false;   
                errorMessages.add(system.Label.ERR00023);
            }
        }        
        return isCriteraMet;
    }
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for the validation of NDC
     **/               
    Public static Boolean valiadteNDC(String NDC){
        boolean nDCvalid= false;
        if((NDC.length() ==5 || NDC.length()==9) && !NDC.contains('.')){
            NDCvalid = true;
        }
        try{
           double.valueOf(NDC);
        }
        catch(exception e){
            NDCvalid = false;
        } 
        return NDCvalid;          
    }
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for the validation of GPI
     **/               
    Public  static Boolean valiadteGPI(String GPI){         
        boolean gPIvalid = false;
        try{
            if((GPI.length() ==2 || GPI.length()==4 || GPI.length()==6 || GPI.length() ==8  || GPI.length()==10 || GPI.length()==12) && !GPI.contains('.')){
                GPIvalid = true;
            }
        }
        catch(exception ex){
            GPIvalid = false;
        }
                     
        return GPIvalid;     
    } 
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for the validation of drug list junction 
     **/          
    Public Boolean validateDrugListJunction(List<VFP_NewDrugGroupController.GroupWrapper> GroupWrapper){  
        boolean isValid = true;
        try{
            set<Decimal> priority = new set<Decimal>();
            for(VFP_NewDrugGroupController.GroupWrapper  drugGroupwrap: GroupWrapper){
                if((drugGroupwrap.JunctionWrapper.Priority__c ==null)||(drugGroupwrap.JunctionWrapper.Drug_List__c == Null)){
                               isValid = false;
                }else if(drugGroupwrap.JunctionWrapper.Priority__c != null){
                    priority.add(drugGroupwrap.JunctionWrapper.Priority__c);
                }
            }
            if(priority.size() != GroupWrapper.size()){
                isValid = false;
            }  
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
     } 
     
   /*  Public Boolean validateDrugGroup(List<VFP_NewDrugGroupController.GroupWrapper> GroupWrapper,string recordType){
        Map<Id,Drug_Group__c> drugGroupMap = new Map<Id,Drug_Group__c>();
        Map<Id,Drug_List__c> drugListMap = new Map<Id,Drug_List__c>();
        set<Id> drugListId = new set<Id>();
        set<Id> drugGroupId = new set<Id>();
        for(VFP_NewDrugGroupController.GroupWrapper  drugGroupwrap: GroupWrapper){
            if(drugGroupwrap.JunctionWrapper.Drug_List__c != Null)
                drugListId.add(drugGroupwrap.JunctionWrapper.Drug_List__c);
            if(drugGroupwrap.JunctionWrapper.Drug_Group__c != Null)
                drugGroupId.add(drugGroupwrap.JunctionWrapper.Drug_Group__c);      
        }
        List<Drug_Group__c> drugGroupList = new List<Drug_Group__c>([Select Id,Name,RecordType.Name  from Drug_Group__c where Id IN: drugGroupId]);
        List<Drug_List__c> drugListList = new List<Drug_List__c>([Select Id,Name,RecordType.Name  from Drug_List__c where Id IN: drugListId]);
        for(Drug_Group__c drugGroup :drugGroupList){
            drugGroupMap.put(drugGroup.Id,drugGroup);
        }
        for(Drug_List__c drugList :drugListList){
            drugListMap.put(drugList.Id,drugList);
        }   
        boolean isValid = true;
        for(VFP_NewDrugGroupController.GroupWrapper  drugGroupwrap: GroupWrapper){           
            if(drugGroupwrap.JunctionWrapper.Drug_List__c != Null && drugListMap.get(drugGroupwrap.JunctionWrapper.Drug_List__c).RecordType.Name != recordType){     
                isValid = false;
            }
            else if(drugGroupwrap.JunctionWrapper.Drug_Group__c != Null && drugGroupMap.get(drugGroupwrap.JunctionWrapper.Drug_Group__c).RecordType.Name != recordType){
                isValid = false;
            }   
        }
         boolean isValid = true;

        return isValid;     
     }
     */
     Public boolean validateDrugList(Drug_List__c drugList){
        boolean isValid = true;
        try{
            if(drugList.Account__c ==Null && !drugList.Standard__c){
                isValid = false;
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
     }
     /**
      * Method :- validateAccums4thQuarter
      * Description :- This Method check for thevalidation of formulary list
      **/               
     Public boolean validateFormularyList(Formulary__c formuilaryList){
        boolean isValid = true;
        try{
            if(formuilaryList.Account__c ==Null && !formuilaryList.Standard__c){
                isValid = false;
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }
     /**
      * Method :- validateAccums4thQuarter
      * Description :- This Method check for the validation of formulary list MS code
      **/                   
    Public boolean validateFormularyListMsCode(list<Formulary_List_Entry__c> formuilaryList){
        boolean isValid = true;
        for(Formulary_List_Entry__c formLst:formuilaryList){
            //Valiadte MS Code
            if(!formLst.MS_Code_M__c  && !formLst.MS_Code_N__c && !formLst.MS_Code_O__c&& !formLst.MS_Code_Y__c){
                isValid = false;
                errorMessages.add(system.Label.ERR00006);
            }
            //Validate NDC   
            if(formLst.NDC__c!=null ){           
                if(formLst.NDC__c.length()!=6 && formLst.NDC__c.length()!=10 && formLst.NDC__c.length()!=11){
                    isValid = false;
                    errorMessages.add(system.Label.ERR00042); 
                }               
                if(formLst.NDC__c.length()==6){
                    if(formLst.NDC__c.indexOf('*')==-1 || formLst.NDC__c.indexOf('*')!=5){
                        isValid = false;                       
                        errorMessages.add(system.Label.ERR00036); 
                    }
                }
                if(formLst.NDC__c.length()==10){
                    if(formLst.NDC__c.indexOf('*')==-1 || formLst.NDC__c.indexOf('*')!=9){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00031);                         
                    }                   
                }
                if(formLst.NDC__c.length()==11){
                    if(formLst.NDC__c.indexOf('*')!=-1){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00048); 
                    }                   
                }
                if(formLst.NDC__c.contains('*')){
                    string drugCodeValue = formLst.NDC__c;
                    drugCodeValue = drugCodeValue.substring(0,drugCodeValue.lastIndexof('*'));
                    try{
                        Double.valueof(drugCodeValue);
                    }
                    catch(exception e){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00047);      
                    } 
                }
            }
            //Valiadte Action
            if(formLst.Action__c =='Message Only' && formLst.Message__c ==''){
                isValid = false;
                errorMessages.add(system.Label.ERR00050); 
            } 
            //Validate GPI
            if(formLst.GPI__c!=null ){           
                if(formLst.GPI__c.length()!=3 && formLst.GPI__c.length()!=5 && formLst.GPI__c.length()!=7 && formLst.GPI__c.length()!=9 && formLst.GPI__c.length()!=11&& formLst.GPI__c.length()!=13 && formLst.GPI__c.length()!=14){
                    isValid = false;
                    errorMessages.add(system.Label.ERR00039); 
                }               
                if(formLst.GPI__c.length()==3){
                    if(formLst.GPI__c.indexOf('*')==-1 || formLst.GPI__c.indexOf('*')!=2){
                        isValid = false;                      
                        errorMessages.add(system.Label.ERR00034); 
                    }
                }                
                if(formLst.GPI__c.length()==5){
                    if(formLst.GPI__c.indexOf('*')==-1 || formLst.GPI__c.indexOf('*')!=4){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00035);                      
                    }                   
                }   
                if(formLst.GPI__c.length()==7){
                    if(formLst.GPI__c.indexOf('*')==-1 || formLst.GPI__c.indexOf('*')!=6){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00037);                      
                    }                   
                }
                if(formLst.GPI__c.length()==9){
                    if(formLst.GPI__c.indexOf('*')==-1 || formLst.GPI__c.indexOf('*')!=8){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00038);                      
                    }                   
                }
                if(formLst.GPI__c.length()==11){
                    if(formLst.GPI__c.indexOf('*')==-1 || formLst.GPI__c.indexOf('*')!=10){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00032);                         
                    }                   
                }
                
                if(formLst.GPI__c.length()==13){
                    if(formLst.GPI__c.indexOf('*')==-1 || formLst.GPI__c.indexOf('*')!=12){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00033);                         
                    }                   
                }       
                if(formLst.GPI__c.length()==14){
                    if(formLst.GPI__c.indexOf('*')!=-1){
                        isValid = false;
                        errorMessages.add(system.Label.ERR00049); 
                    }                   
                }
            }
        }
        return isValid;
     }
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for theValidation methods For CRD wizard 
     **/          
    public boolean validatePlanPlateform(CRD__c crd){
        boolean isValid = true;
        try{
            if((crd.Plan_Platform__c=='HMO' || crd.Plan_Platform__c=='HNO')&& crd.Include_Kit_Logic__c){
                crd.addError(system.Label.ERR00068);
                isValid=false;            
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }   
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for the validation of web access user
                  
    public boolean validateWebAccessUser(list<VFP_CRDClientInfoController.webAccesUserWrapper> webAccessUsers){
        boolean isValid = true;
        try{
            for(VFP_CRDClientInfoController.webAccesUserWrapper usr:webAccessUsers){                                         
                if(usr.webuser.Web_Acces_User_Name__c==null){
                    usr.webuser.Web_Acces_User_Name__c.addError(system.Label.ERR00062);
                    isValid=false;
                }
                if(usr.webuser.Last_4_digits_of_SSN__c==null){
                    usr.webuser.Last_4_digits_of_SSN__c.addError(system.Label.ERR00043);
                    isValid=false;
                }
                if(usr.webuser.Client_Access__c==null){
                    usr.webuser.Client_Access__c.addError(system.Label.ERR00009);
                    isValid=false;
                }
                if(usr.webuser.RxNav__c==null){
                    usr.webuser.RxNav__c.addError(system.Label.ERR00055);
                    isValid=false;
                }
                if(usr.webuser.Client_Acces_Security__c==null){
                    usr.webuser.Client_Acces_Security__c.addError(system.Label.ERR00010);
                    isValid=false;
                }               
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }
    **/    
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for the validation of drug specific copay
     **/            
    public boolean validateDrugSpecificCopay(list<VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper> wrappedList){
        boolean isValid = true;
        errorMessages.clear(); 
        set<Id> setMsCodeM=new set<Id>();
        set<Id> setMsCodeN=new set<Id>();
        set<Id> setMsCodeO=new set<Id>();
        set<Id> setMsCodeY=new set<Id>();
        try{
        
            // added by Vikram for request 06211
            Set<Id> druglistGroupIds = new Set<Id>();
            for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper wrap:wrappedList){
                druglistGroupIds.add(wrap.drugSpecificCopayItem.Drug_List__c);
                druglistGroupIds.add(wrap.drugSpecificCopayItem.Drug_Group__c);
            }
            
            Map<id,string> addedDLs = new Map<id,string>();
            for(Drug_List__c drugList : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_List__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs.put(drugList.id,drugList.Allowable_Actions__c);
            }
            
            Map<Id,String> addedDLs1 = new Map<Id,String>();
            for(Drug_Group__c drugGroup : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_Group__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs1.put(drugGroup.id,drugGroup.Allowable_Actions__c);
            }
                
            set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }
            // 06211 ends 
        
            for(VFP_CRDNewDrugSpecificCopay.DrugSpecificCopayWrapper wrap:wrappedList){
                if(!wrap.drugSpecificCopayItem.Stepped_Copay__c){
                    // added by Toshi Story no: 06694
                    if((wrap.drugSpecificCopayItem.Drug_List__c==null && wrap.drugSpecificCopayItem.Drug_Group__c==null)){
                        errorMessages.add(system.Label.ERR0317);                 
                        isValid=false;
                    }
                    if((wrap.drugSpecificCopayItem.Drug_List__c!=null && wrap.drugSpecificCopayItem.Drug_Group__c!=null)){
                        errorMessages.add(system.Label.ERR0318);                 
                        isValid=false;
                    }
                    if(wrap.drugSpecificCopayItem.Dollar_Amount__c==null && wrap.drugSpecificCopayItem.Percent__c==null){
                        errorMessages.add(system.Label.ERR00051);                 
                        isValid=false;
                    }
                    if(wrap.drugSpecificCopayItem.Dollar_Amount__c!=null && wrap.drugSpecificCopayItem.Percent__c!=null){
                        if(wrap.drugSpecificCopayItem.Copay_Calculation__c==null){
                            wrap.drugSpecificCopayItem.Copay_Calculation__c.addError(system.Label.ERR00011);            
                            isValid=false;
                        }
                     }
                }else{
                    if(wrap.drugSpecificCopayItem.Dollar_Amount__c!=null || wrap.drugSpecificCopayItem.Percent__c!=null){
                        if(wrap.drugSpecificCopayItem.Copay_Calculation__c==null){
                            wrap.drugSpecificCopayItem.Copay_Calculation__c.addError(system.Label.ERR00063);            
                            isValid=false;
                        }
                        if(wrap.drugSpecificCopayItem.Copay_Calculation__c!=null && wrap.drugSpecificCopayItem.Copay_Calculation__c!='Greatest of All' && wrap.drugSpecificCopayItem.Copay_Calculation__c!='Least of All'){
                             wrap.drugSpecificCopayItem.Copay_Calculation__c.addError(system.Label.ERR00064);            
                             isValid=false;                         
                        }
                    }
                    if(wrap.drugSpecificCopayItem.Drug_Group__c==null && wrap.drugSpecificCopayItem.Drug_List__c==null) {
                        errorMessages.add(system.Label.ERR00022);               
                        isValid=false;                    
                    }
                    if(wrap.drugSpecificCopayItem.Drug_Group__c!=null && wrap.drugSpecificCopayItem.Drug_List__c!=null) {
                        errorMessages.add(system.Label.ERR00022);
                        isValid=false;                    
                    }
                }
                
                // added by vikram for request 06211
                if (wrap.drugSpecificCopayItem.Drug_Group__c!=null){
                    if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs1.get(wrap.drugSpecificCopayItem.Drug_Group__c)) && addedDLs1.get((wrap.drugSpecificCopayItem.Drug_Group__c)).contains(ALLOWOVERRIDE)){ 
                    }else{    
                        if(String.isBlank(addedDLs1.get(wrap.drugSpecificCopayItem.Drug_Group__c)) || !addedDLs1.get(wrap.drugSpecificCopayItem.Drug_Group__c).contains(DRUGSPECIFICCOPAY)){
                            errorMessages.add(system.Label.ERR0298);
                            isValid=false;
                        }
                    }
                }else if(wrap.drugSpecificCopayItem.Drug_List__c!=null){
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs.get(wrap.drugSpecificCopayItem.Drug_List__c)) && addedDLs.get((wrap.drugSpecificCopayItem.Drug_List__c)).contains(ALLOWOVERRIDE)){
                        }else{    
                            if(String.isBlank(addedDLs.get(wrap.drugSpecificCopayItem.Drug_List__c)) || !addedDLs.get(wrap.drugSpecificCopayItem.Drug_List__c).contains(DRUGSPECIFICCOPAY)){
                            errorMessages.add(system.Label.ERR0298);
                            isValid=false;
                            }
                        }
                      }
                // 06211 ends    
                
                if(!wrap.drugSpecificCopayItem.M__c && !wrap.drugSpecificCopayItem.N__c && !wrap.drugSpecificCopayItem.O__c && !wrap.drugSpecificCopayItem.Y__c){
                    wrap.drugSpecificCopayItem.addError(system.Label.ERR00006);
                    isValid=false;
                }
                //for unique MNOY and Daw code combination  
                //Added by Sourabh            
                if(wrap.drugSpecificCopayItem.M__c!=null && wrap.drugSpecificCopayItem.M__c){
                    if(setMsCodeM!=null && wrap.drugSpecificCopayItem.Drug_List__c!=Null && setMsCodeM.contains(wrap.drugSpecificCopayItem.Drug_List__c)){
                        wrap.drugSpecificCopayItem.addError(system.Label.ERR00065);
                        isValid=false;
                    }else{                          
                        setMsCodeM.add(wrap.drugSpecificCopayItem.Drug_List__c);
                    }
                }
                if(wrap.drugSpecificCopayItem.N__c!=null &&wrap.drugSpecificCopayItem.N__c){
                    if(setMsCodeN!=null && wrap.drugSpecificCopayItem.Drug_List__c!=Null && setMsCodeN.contains(wrap.drugSpecificCopayItem.Drug_List__c)){
                        wrap.drugSpecificCopayItem.addError(system.Label.ERR00065);
                        isValid=false;
                    }else{                          
                        setMsCodeN.add(wrap.drugSpecificCopayItem.Drug_List__c);
                    }
                }
                if(wrap.drugSpecificCopayItem.O__c!=null &&wrap.drugSpecificCopayItem.O__c){
                    if(setMsCodeO!=null && wrap.drugSpecificCopayItem.Drug_List__c!=Null && setMsCodeO.contains(wrap.drugSpecificCopayItem.Drug_List__c)){
                        wrap.drugSpecificCopayItem.addError(system.Label.ERR00065);
                        isValid=false;
                    }else{                          
                        setMsCodeO.add(wrap.drugSpecificCopayItem.Drug_List__c);
                    }
                }
                if(wrap.drugSpecificCopayItem.Y__c!=null &&wrap.drugSpecificCopayItem.Y__c){
                    if(setMsCodeY!=null && wrap.drugSpecificCopayItem.Drug_List__c!=Null && setMsCodeY.contains(wrap.drugSpecificCopayItem.Drug_List__c)){
                        wrap.drugSpecificCopayItem.addError(system.Label.ERR00065);
                        isValid=false;
                    }else{                          
                        setMsCodeY.add(wrap.drugSpecificCopayItem.Drug_List__c);
                    }
                }
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }   
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for the validation of copay tier type
     **/        
    public boolean checkTierType(List<Copay_Tier__c> wrappedList){
        boolean isBrandAvailable=false;
        boolean isBrandChileAvailable=false;
        boolean isgenericAvailable=false;
        boolean isgenericSpecialAvailable=false;
        boolean isSpecialAvailable=false;
        boolean isSpecialtyPBPGAvailable = false; //Added for ST#1137
        boolean isSpecialChileAvailable=false;
        boolean isSpecialtyPBPGChildAvailable = false; //Added for ST#1137
        errorMessages.clear();         
        boolean isValid = true;
        try{
            for(Copay_Tier__c ct:wrappedList){
                if(ct.Tier_Type__c!=null){
                    if(ct.Tier_Type__c=='Brand (SSB & MSB)'){
                        isBrandAvailable=true;
                    }
                    if(ct.Tier_Type__c=='Specialty (Preferred & Non-Preferred)'){
                        isSpecialAvailable=true;
                    }
                    //Added for ST#1137 --Start--
                    if(ct.Tier_Type__c=='Specialty (Preferred Brand & Preferred Generic)'){
                        isSpecialtyPBPGAvailable = true;
                    } // --End--
                    if(ct.Tier_Type__c=='Generic (SSG & MSG)'){
                        isgenericAvailable=true;
                    }
                }
            }
            if(isBrandAvailable){
                for(Copay_Tier__c ct:wrappedList){
                    if(ct.Tier_Type__c=='Single Source Brand (SSB)' || ct.Tier_Type__c=='Multi Source Brand (MSB)'){
                        errorMessages.add(system.Label.ERR00028);
                        isBrandChileAvailable = true;
                        break;
                    }
                }
            }
            if(isSpecialAvailable){
                for(Copay_Tier__c ct:wrappedList){
                    if(ct.Tier_Type__c=='Preferred Specialty' || ct.Tier_Type__c=='Non-Preferred Specialty'){
                        errorMessages.add(system.Label.ERR00030);
                        isSpecialChileAvailable= true;
                        break;
                    }
                }
            }
            //Added for ST#1137 --Start--
            if(isSpecialtyPBPGAvailable){
                for(Copay_tier__c ct:wrappedList){
                    if(ct.Tier_Type__c == 'Preferred Brand Specialty' || ct.Tier_Type__c == 'Preferred Generic Specialty'){
                        errorMessages.add(system.Label.ERR00300);
                        isSpecialtyPBPGChildAvailable = true;
                        break;
                    }
                }
            }// --End--
                 
            if(isgenericAvailable){
                for(Copay_Tier__c ct:wrappedList){
                    if(ct.Tier_Type__c=='Single Source Generic (SSG)' || ct.Tier_Type__c=='Multi Source Generic (MSG)'){
                        errorMessages.add(system.Label.ERR00029);
                        isgenericSpecialAvailable= true;
                        break;
                    }
                }
            }
            if(isBrandChileAvailable || isSpecialChileAvailable || isgenericSpecialAvailable || isSpecialtyPBPGChildAvailable){
                isValid =false;
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
   }
    /**
     * Method :- validateAccums4thQuarter
     * Description :- This Method check for the validation of Paper Out of network copay
     **/            
   public boolean validatePaperOutOfNetworkCopay(CRD__c currentCrd){
        errorMessages.clear();         
        boolean isValid = true;
        try{
            if(currentCrd.Penalty_Type__c!=null && currentCrd.Penalty_Type__c=='Percent' && currentCrd.Percentage_Applied__c==null){
                errorMessages.add(system.Label.ERR00052);                 
                isValid=false;
            } 
            if(currentCrd.Apply_Penalty__c!=null && currentCrd.Apply_Penalty__c=='Yes'){
                if(currentCrd.Penalty_Type__c==null || currentCrd.Penalty_Amount__c==null){
                    errorMessages.add(system.Label.ERR00027);                
                    isValid=false;                             
                }
            }
            //Added by Amit Jain for Request 4366
            if(currentCrd.Apply_Penalty_to_Specialty_OON__c!=null && currentCrd.Apply_Penalty_to_Specialty_OON__c=='Yes'){
                if(currentCrd.Penalty_Type_Specialty_OON__c==null || currentCrd.Penalty_Amount_Specialty_OON__c==null){
                    errorMessages.add(system.Label.ERR0230);                
                    isValid=false;                             
                }
            }
            if(currentCrd.Penalty_Type_Specialty_OON__c!=null && currentCrd.Penalty_Type_Specialty_OON__c=='Percent' && currentCrd.Percentage_Applied_Specialty_OON__c==null){
                errorMessages.add(system.Label.ERR0231);                 
                isValid=false;
            } 
            //ends
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }
   /**
    * Method :- validateAccums4thQuarter
    * Description :- This Method check for the validate copay
    **/        
        public boolean validateCopay(List<Copay_Tier__c> wrappedList){ 
        errorMessages.clear();         
        boolean isValid = true;
        try{
            isValid =  checkTierType(wrappedList);
            for(Copay_Tier__c ct:wrappedList){
                if(!ct.Stepped_Copay__c){
                    if(ct.Tier_Type__c==null){
                        errorMessages.add(system.Label.ERR00012);                
                        isValid=false;
                    }
                    if(ct.Dollar_Amount__c==null && ct.Percent__c==null){
                        errorMessages.add(system.Label.ERR00051);                 
                        isValid=false;
                    }
                    if(ct.Dollar_Amount__c!=null && ct.Percent__c!=null){
                        if(ct.Copay_Calc__c==null){
                             ct.Copay_Calc__c.addError(system.Label.ERR00011);
                             isValid=false;
                        }
                    }  
                }else{
                    if(ct.Dollar_Amount__c!=null || ct.Percent__c!=null){
                        if(ct.Copay_Calc__c==null){
                             ct.Copay_Calc__c.addError(system.Label.ERR00063);
                             isValid=false;
                        }
                        if(ct.Copay_Calc__c!=null && ct.Copay_Calc__c!='Greatest of All' && ct.Copay_Calc__c!='Least of All'){
                            ct.Copay_Calc__c.addError(system.Label.ERR00064);
                            isValid=false;                        
                        }
                    }
                    if(ct.Tier_Type__c==null){
                        errorMessages.add(system.Label.ERR00012); 
                        isValid=false;
                    }
                }
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }
        /**
         * Method :- validateAccums4thQuarter
         * Description :- This Method check for the validation of stepped Copay Range
         **/                    
    public boolean checkCopayRange(list<SteppedCopay__c>steppedCopayItemList){
        boolean isValid = true;
        try{
            Decimal previousMaxRange=0.00; 
            //previousMaxRange=0.00;
            if(steppedCopayItemList.size()>1){
                for(integer i=0;i<steppedCopayItemList.size();i++){
                    if(steppedCopayItemList.get(i).Max_Range__c!=null && i==0){                         
                        previousMaxRange=steppedCopayItemList.get(i).Max_Range__c;
                    }else{                        
                        previousMaxRange=steppedCopayItemList.get(i-1).Max_Range__c;                         
                    }
                    if(i!=0 && steppedCopayItemList.get(i).Min_Range__c!=null && previousMaxRange >= steppedCopayItemList.get(i).Min_Range__c){
                        isValid=false;                       
                    }
                    if(!isValid){
                        break;
                    }
                }
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid; 
    }
    /**
    * Method :- validateAccums4thQuarter
    * Description :- This Method check for the validation of Drug_Specific_Stepped_Copay__c's Copay Range
    **/                    
    public boolean checkDrugSpecificCopayRange(list<Drug_Specific_Stepped_Copay__c>steppedCopayItemList){
        boolean isValid = true;
        try{
            Decimal previousMaxRange=0.00;  
            //previousMaxRange=0.00;
            if(steppedCopayItemList.size()>1){
                for(integer i=0;i<steppedCopayItemList.size();i++){
                    if(steppedCopayItemList.get(i).End_Range__c!=null && i==0){                         
                        previousMaxRange=steppedCopayItemList.get(i).End_Range__c;
                    }else{                        
                        previousMaxRange=steppedCopayItemList.get(i-1).End_Range__c;                         
                    }
                    if(i!=0 && steppedCopayItemList.get(i).Beginning_Range__c!=null && previousMaxRange >= steppedCopayItemList.get(i).Beginning_Range__c){
                        isValid=false;                       
                    }
                    if(!isValid){
                        break;
                    }
                }
            }   
        }
        catch(exception ex){
            isValid = false;
        }
        return  isValid; 
    }
    /**
    * Method :- validateAccums4thQuarter
    * Description :- This Method check for the validation of Drug_Specific_Stepped_Copay__c
    **/           
    public boolean validateDrugSpecificSteppedCopay(LIST<VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper> wrappedList){
        boolean isValid = true;
        try{
            errorMessages.clear();         
            for(VFP_CRDDrugSpecificSteppedCoPay.drugSpecificCopayWrapper wrap:wrappedList){ 
                if(wrap.drugSpecificSteppedCopayItemList!= null && wrap.drugSpecificSteppedCopayItemList.size()>0){
                    isValid = checkDrugSpecificCopayRange(wrap.drugSpecificSteppedCopayItemList);
                    if(!isvalid){
                        errorMessages.add(system.Label.ERR00059);            
                        break;                    
                    }      
                }
                for(Drug_Specific_Stepped_Copay__c ct:wrap.drugSpecificSteppedCopayItemList){  
                        //loop starts
                    if(ct.Beginning_Range__c==null){
                        ct.Beginning_Range__c.addError(system.Label.ERR00077);
                        isValid=false;
                    }
                    if(ct.End_Range__c==null){
                        ct.End_Range__c.addError(system.Label.ERR00046);
                        isValid=false;
                    }
                    if(ct.Beginning_Range__c!=null && ct.End_Range__c!=null){
                        if(ct.Beginning_Range__c > ct.End_Range__c){
                            ct.Beginning_Range__c.addError(system.Label.ERR00008);
                            isValid=false;
                        }
                    }
                    if(ct.Dollar_Amount__c==null && ct.Percent__c==null){                 
                         ct.Percent__c.addError(system.Label.ERR00074);             
                         ct.Dollar_Amount__c.addError(system.Label.ERR00074);                                 
                         isValid=false;
                    }
                    if(ct.Dollar_Amount__c!=null && ct.Percent__c!=null){
                        if(ct.Copay_Calculation__c==null){
                            ct.Copay_Calculation__c.addError(system.Label.ERR00071);            
                            isValid=false;
                        }
                    }
                    //loop ends  
                }
            } 
        }
        catch(exception ex){
            isValid = false;
        }
        return  isValid;          
    }   
    /**
    * Method :- validateAccums4thQuarter
    * Description :- This Method check for the validation of SteppedCopay__c
    **/                      
    public boolean validateSteppedCopay(LIST<VFP_CRDNewSteppedCoPayController.steppedCopayWrapper> wrappedList){          
        boolean isValid = true;
        try{
            //integer previousValue;
            errorMessages.clear();         
            for(VFP_CRDNewSteppedCoPayController.steppedCopayWrapper wrap:wrappedList){            
                if(wrap.steppedCopayItemList!= null && wrap.steppedCopayItemList.size()>0){
                    isValid = checkCopayRange(wrap.steppedCopayItemList);
                    if(!isvalid){
                        errorMessages.add(system.Label.ERR00059);            
                        break;                    
                    }
                    for(SteppedCopay__c ct:wrap.steppedCopayItemList){                          
                        if(ct.Min_Range__c==null){
                            ct.Min_Range__c.addError(system.Label.ERR00077);
                            isValid=false;
                        }
                        if(ct.Max_Range__c==null){
                            ct.Max_Range__c.addError(system.Label.ERR00046);
                            isValid=false;
                        }
                        if(ct.Min_Range__c!=null && ct.Max_Range__c!=null){
                            if(ct.Min_Range__c > ct.Max_Range__c){
                                ct.Min_Range__c.addError(system.Label.ERR00008);
                                isValid=false;
                            }
                        }
                        if(ct.Dollar_Amount__c==null && ct.Percent_Amount__c==null){                 
                             ct.Percent_Amount__c.addError(system.Label.ERR00074);            
                             ct.Dollar_Amount__c.addError(system.Label.ERR00074);                                 
                             isValid=false;
                        }
                        if(ct.Dollar_Amount__c!=null && ct.Percent_Amount__c!=null){
                            if(ct.Copay_Calc__c==null){
                                ct.Copay_Calc__c.addError(system.Label.ERR00071);            
                                isValid=false;
                            }
                        }
                    }
                }
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }
    // Added by JR for request no 4550
    /**
    * Method :- validateAccums4thQuarter
    * Description :- This Method check for the validation of Accumulation Drug List for MNOY
    **/         
public boolean validateAccumulationDrugListMNOY(LIST<VFP_AccumulationController.AccumsDruglistWrapper> wrappedList, String recordTypeName){
    
    boolean isValid = true;
    try{
        errorMessages.clear();
        
        set<Id> setMsCodeM=new set<Id>();
        set<Id> setMsCodeN=new set<Id>();
        set<Id> setMsCodeO=new set<Id>();
        set<Id> setMsCodeY=new set<Id>();
        
        set<Id> setMsCodeMdG=new set<Id>();
        set<Id> setMsCodeNdG=new set<Id>();
        set<Id> setMsCodeOdG=new set<Id>();
        set<Id> setMsCodeYdG=new set<Id>();

        if(wrappedList!=null && wrappedList.size()>0){          
                for(VFP_AccumulationController.AccumsDruglistWrapper wrap:wrappedList){
                    if(!wrap.accumsDrugList.M__c && !wrap.accumsDrugList.N__c && !wrap.accumsDrugList.O__c && !wrap.accumsDrugList.Y__c){
                        wrap.accumsDrugList.addError(system.Label.ERR00006);
                        isValid=false;
                    }
                    
                    // For Unique MNOY
                    
                    if(wrap.accumsDrugList.M__c!=null && wrap.accumsDrugList.M__c){
                        if(setMsCodeM!=null && wrap.accumsDrugList.Drug_List__c!=Null && setMsCodeM.contains(wrap.accumsDrugList.Drug_List__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeM.add(wrap.accumsDrugList.Drug_List__c);
                        }
                        
                        if(setMsCodeMdG!=null && wrap.accumsDrugList.Drug_Group__c!=Null && setMsCodeMdG.contains(wrap.accumsDrugList.Drug_Group__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeMdG.add(wrap.accumsDrugList.Drug_Group__c);
                        }
                    }
                    if(wrap.accumsDrugList.N__c!=null &&wrap.accumsDrugList.N__c){
                        if(setMsCodeN!=null && wrap.accumsDrugList.Drug_List__c!=Null && setMsCodeN.contains(wrap.accumsDrugList.Drug_List__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeN.add(wrap.accumsDrugList.Drug_List__c);
                        }
                        
                        if(setMsCodeNdG!=null && wrap.accumsDrugList.Drug_Group__c!=Null && setMsCodeNdG.contains(wrap.accumsDrugList.Drug_Group__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeNdG.add(wrap.accumsDrugList.Drug_Group__c);
                        }
                    }
                    if(wrap.accumsDrugList.O__c!=null &&wrap.accumsDrugList.O__c){
                        if(setMsCodeO!=null && wrap.accumsDrugList.Drug_List__c!=Null && setMsCodeO.contains(wrap.accumsDrugList.Drug_List__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeO.add(wrap.accumsDrugList.Drug_List__c);
                        }
                        if(setMsCodeOdG!=null && wrap.accumsDrugList.Drug_Group__c!=Null && setMsCodeOdG.contains(wrap.accumsDrugList.Drug_Group__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeOdG.add(wrap.accumsDrugList.Drug_Group__c);
                        }
                    }
                    if(wrap.accumsDrugList.Y__c!=null &&wrap.accumsDrugList.Y__c){
                        if(setMsCodeY!=null && wrap.accumsDrugList.Drug_List__c!=Null && setMsCodeY.contains(wrap.accumsDrugList.Drug_List__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeY.add(wrap.accumsDrugList.Drug_List__c);
                        }
                        if(setMsCodeYdG!=null && wrap.accumsDrugList.Drug_Group__c!=Null && setMsCodeYdG.contains(wrap.accumsDrugList.Drug_Group__c)){
                            wrap.accumsDrugList.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeYdG.add(wrap.accumsDrugList.Drug_Group__c);
                        }
                    }
                
                }
                }
            }
            catch(exception ex){
                isValid = false;
            }
            return isValid;

}
/** Added by Richa for Req - 4731
    * Method :- validate unique MNOY for Waiver of deductible
    * Description :- This Method check for the uniqueness of MNOY in Waiver of Deductible object
    **/    
public boolean validateWaiverOfDeductible(LIST<VFP_WaiverOfDeductible.WaiverDeductible> wrappedList){
    
    boolean isValid = true;
    try{
        errorMessages.clear();
        
        set<Id> setMsCodeM=new set<Id>();
        set<Id> setMsCodeN=new set<Id>();
        set<Id> setMsCodeO=new set<Id>();
        set<Id> setMsCodeY=new set<Id>();
        
        set<Id> setMsCodeMdG=new set<Id>();
        set<Id> setMsCodeNdG=new set<Id>();
        set<Id> setMsCodeOdG=new set<Id>();
        set<Id> setMsCodeYdG=new set<Id>();

        if(wrappedList!=null && wrappedList.size()>0){          
                for(VFP_WaiverOfDeductible.WaiverDeductible wrap : wrappedList){
                    if(!wrap.waiverDeductibleobj.M__c && !wrap.waiverDeductibleobj.N__c && !wrap.waiverDeductibleobj.O__c && !wrap.waiverDeductibleobj.Y__c){
                        wrap.waiverDeductibleobj.addError(system.Label.ERR00006);
                        isValid=false;
                    }/*
                    if(wrap.waiverDeductibleobj.Drug_list__c == null && wrap.waiverDeductibleobj.Drug_Group__c == null){
                         wrap.waiverDeductibleobj.addError(system.Label.ERR00022);
                        isValid=false;                      
                    }*/
                    if(wrap.waiverDeductibleobj.M__c!=null && wrap.waiverDeductibleobj.M__c){
                        if(setMsCodeM!=null && wrap.waiverDeductibleobj.Drug_List__c!=Null && setMsCodeM.contains(wrap.waiverDeductibleobj.Drug_List__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeM.add(wrap.waiverDeductibleobj.Drug_List__c);
                        }
                        
                        if(setMsCodeMdG!=null && wrap.waiverDeductibleobj.Drug_Group__c!=Null && setMsCodeMdG.contains(wrap.waiverDeductibleobj.Drug_Group__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeMdG.add(wrap.waiverDeductibleobj.Drug_Group__c);
                        }
                    }
                    if(wrap.waiverDeductibleobj.N__c!=null && wrap.waiverDeductibleobj.N__c){
                        if(setMsCodeN!=null && wrap.waiverDeductibleobj.Drug_List__c!=Null && setMsCodeN.contains(wrap.waiverDeductibleobj.Drug_List__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeN.add(wrap.waiverDeductibleobj.Drug_List__c);
                        }
                        
                        if(setMsCodeNdG!=null && wrap.waiverDeductibleobj.Drug_Group__c!=Null && setMsCodeNdG.contains(wrap.waiverDeductibleobj.Drug_Group__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeNdG.add(wrap.waiverDeductibleobj.Drug_Group__c);
                        }
                    }
                    if(wrap.waiverDeductibleobj.O__c!=null && wrap.waiverDeductibleobj.O__c){
                        if(setMsCodeO!=null && wrap.waiverDeductibleobj.Drug_List__c!=Null && setMsCodeO.contains(wrap.waiverDeductibleobj.Drug_List__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeO.add(wrap.waiverDeductibleobj.Drug_List__c);
                        }
                        if(setMsCodeOdG!=null && wrap.waiverDeductibleobj.Drug_Group__c!=Null && setMsCodeOdG.contains(wrap.waiverDeductibleobj.Drug_Group__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeOdG.add(wrap.waiverDeductibleobj.Drug_Group__c);
                        }
                    }
                    if(wrap.waiverDeductibleobj.Y__c!=null && wrap.waiverDeductibleobj.Y__c){
                        if(setMsCodeY!=null && wrap.waiverDeductibleobj.Drug_List__c!=Null && setMsCodeY.contains(wrap.waiverDeductibleobj.Drug_List__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeY.add(wrap.waiverDeductibleobj.Drug_List__c);
                        }
                        if(setMsCodeYdG!=null && wrap.waiverDeductibleobj.Drug_Group__c!=Null && setMsCodeYdG.contains(wrap.waiverDeductibleobj.Drug_Group__c)){
                            wrap.waiverDeductibleobj.addError(system.Label.ERR00065);
                            isValid=false;
                        }else{                          
                            setMsCodeYdG.add(wrap.waiverDeductibleobj.Drug_Group__c);
                        }
                    }
                
                }
                }
            }
            catch(exception ex){
                isValid = false;
            }
            return isValid;

}
/**
* Method :- validateAccums4thQuarter
* Description :- This Method check for the validation of Accumulation Drug List
**/ 
    public boolean validateAccumulationDrugListDeductible(LIST<VFP_AccumulationController.AccumsDruglistWrapper> wrappedList, String recordTypeName){
        boolean isValid = true; 
        try{        
            errorMessages.clear();
            
            // added by Vikram for request 06211
            Set<Id> druglistGroupIds = new Set<Id>();
            for(VFP_AccumulationController.AccumsDruglistWrapper wrap:wrappedList){
                druglistGroupIds.add(wrap.accumsDrugList.Drug_List__c);
                druglistGroupIds.add(wrap.accumsDrugList.Drug_Group__c);
            }
            
            map<id,string> addedDLs = new map<id,string>();
            for(Drug_List__c drugList : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_List__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs.put(drugList.id,drugList.Allowable_Actions__c);
            }
            
            Map<Id,String> addedDLs1 = new Map<Id,String>();
            for(Drug_Group__c drugGroup : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_Group__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs1.put(drugGroup.id,drugGroup.Allowable_Actions__c);
            }
            
            set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }
            // 06211 ends 
            
            if(wrappedList!=null && wrappedList.size()>0){   
                
                
                for(VFP_AccumulationController.AccumsDruglistWrapper wrap:wrappedList){

                    if(wrap.accumsDrugList.Drug_List__c==null && wrap.accumsDrugList.Drug_Group__c==null){
                        wrap.accumsDrugList.Drug_List__c.addError(system.Label.ERR00019);
                        isValid=false;
                    }
                    if(wrap.accumsDrugList.Drug_List__c!=null && wrap.accumsDrugList.Drug_Group__c!=null){
                        wrap.accumsDrugList.Drug_List__c.addError(system.Label.ERR00069);
                        isValid=false;
                    }   
                    
                    // added by Vikram for request 06211
                    if (wrap.accumsDrugList.Drug_Group__c!=null){
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs1.get(wrap.accumsDrugList.Drug_Group__c)) && addedDLs1.get(wrap.accumsDrugList.Drug_Group__c).contains(ALLOWOVERRIDE)){
                        }else{    
                            if(String.isBlank(addedDLs1.get(wrap.accumsDrugList.Drug_Group__c)) || !addedDLs1.get(wrap.accumsDrugList.Drug_Group__c).contains(DRUGSPECIFICACCUM)){
                                errorMessages.add(system.Label.ERR0298);
                                isValid=false;
                            }
                        }
                    }else if(wrap.accumsDrugList.Drug_List__c!=null){
                             if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs.get(wrap.accumsDrugList.Drug_List__c)) && addedDLs.get(wrap.accumsDrugList.Drug_List__c).contains(ALLOWOVERRIDE)){
                             }else{   
                                if(String.isBlank(addedDLs.get(wrap.accumsDrugList.Drug_List__c)) || !addedDLs.get(wrap.accumsDrugList.Drug_List__c).contains(DRUGSPECIFICACCUM)){
                                    errorMessages.add(system.Label.ERR0298);
                                    isValid=false;
                                }
                             }
                        }
                    // 06211 ends 
                    
                    if(wrap.accumsDrugList.Deductible_Amount__c==null){
                        wrap.accumsDrugList.Deductible_Amount__c.addError(system.Label.ERR00024);
                        isValid=false;                      
                    }   
                    if(wrap.accumsDrugList.Deductible_Period__c==null){
                        wrap.accumsDrugList.Deductible_Period__c.addError(system.Label.ERR00024);
                        isValid=false;
                    }
                    if(wrap.accumsDrugList.Deuductible_Accumulation_from_4th_Qtr__c==null){
                        wrap.accumsDrugList.Deuductible_Accumulation_from_4th_Qtr__c.addError(system.Label.ERR00024);
                        isValid=false;
                    } 

                    
                /*    if(recordTypeName.contains('Family')){
                        if(wrap.accumsDrugList.Family_Members_to_meet_Family_Deduct__c==null){
                           wrap.accumsDrugList.Family_Members_to_meet_Family_Deduct__c.addError(system.Label.ERR00024);
                            isValid=false;
                                                    
                        }                                     
                    }  */  
                }
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;          
    }
    /**
    * Method :- validateAccums4thQuarter
    * Description :- This Method check for the validation of Accumulation Drug List
    **/        
    public boolean validateAccumulationDrugListMab(LIST<VFP_AccumulationController.AccumsDruglistWrapper> wrappedList,String recordTypeName){    
        boolean isValid = true; 
        try{
            errorMessages.clear(); 
            
            // added by Vikram for request 06211
            Set<Id> druglistGroupIds = new Set<Id>();
            for(VFP_AccumulationController.AccumsDruglistWrapper wrap:wrappedList){
                druglistGroupIds.add(wrap.accumsDrugList.Drug_List__c);
                druglistGroupIds.add(wrap.accumsDrugList.Drug_Group__c);
            }
            
            map<id,string> addedDLs = new map<id,string>();
            for(Drug_List__c drugList : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_List__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs.put(drugList.id,drugList.Allowable_Actions__c);
            }
            
            Map<Id,String> addedDLs1 = new Map<Id,String>();
            for(Drug_Group__c drugGroup : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_Group__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs1.put(drugGroup.id,drugGroup.Allowable_Actions__c);
            }
            
            set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }
            // 06211 ends 
                
            if(wrappedList!=null && wrappedList.size()>0){          
                for(VFP_AccumulationController.AccumsDruglistWrapper wrap:wrappedList){            
                   if(wrap.accumsDrugList.Drug_List__c==null && wrap.accumsDrugList.Drug_Group__c==null){
                        wrap.accumsDrugList.Drug_List__c.addError(system.Label.ERR00020);
                        isValid=false;
                    }                        
                    if(wrap.accumsDrugList.Drug_List__c!=null && wrap.accumsDrugList.Drug_Group__c!=null){
                        wrap.accumsDrugList.Drug_List__c.addError(system.Label.ERR00069);
                        isValid=false;
                    } 
                    
                    // added by Vikram for request 06211
                    if (wrap.accumsDrugList.Drug_Group__c!=null){
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs1.get(wrap.accumsDrugList.Drug_Group__c)) && addedDLs1.get(wrap.accumsDrugList.Drug_Group__c).contains(ALLOWOVERRIDE)){
                        }else{    
                            if(String.isBlank(addedDLs1.get(wrap.accumsDrugList.Drug_Group__c)) || !addedDLs1.get(wrap.accumsDrugList.Drug_Group__c).contains(DRUGSPECIFICACCUM)){
                                errorMessages.add(system.Label.ERR0298);
                                isValid=false;
                            }
                        }
                    }else if(wrap.accumsDrugList.Drug_List__c!=null){
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs.get(wrap.accumsDrugList.Drug_List__c)) && addedDLs.get(wrap.accumsDrugList.Drug_List__c).contains(ALLOWOVERRIDE)){
                            }else{    
                                if(String.isBlank(addedDLs.get(wrap.accumsDrugList.Drug_List__c)) || !addedDLs.get(wrap.accumsDrugList.Drug_List__c).contains(DRUGSPECIFICACCUM)){
                                    errorMessages.add(system.Label.ERR0298);
                                    isValid=false;
                                }
                            }
                          }
                    // 06211 ends 
                    
                    /* added by Nitish Request No 4751 */
                    if(!wrap.accumsDrugList.Exclude_from_Accumulation__c){
                        if(wrap.accumsDrugList.MAB_Dedictible_Amount__c==null||wrap.accumsDrugList.MAB_Period__c==null||wrap.accumsDrugList.What_happens_when_MAB_is_met__c== null){
                            wrap.accumsDrugList.addError(system.Label.ERR0284);
                            isValid=false;                
                        }
                    }     
                   /* added by Nitish Request No 4751 */
                    if(wrap.accumsDrugList.Exclude_from_Accumulation__c){
                        if(wrap.accumsDrugList.MAB_Dedictible_Amount__c!=null||wrap.accumsDrugList.MAB_Period__c!=null||wrap.accumsDrugList.What_happens_when_MAB_is_met__c!=null){
                            wrap.accumsDrugList.addError(system.Label.ERR0285);
                            isValid=false;                
                        }
                    }      
                    /* Commented By Nitish Request No 4751 
                    if(wrap.accumsDrugList.What_happens_when_MAB_is_met__c==null){
                        wrap.accumsDrugList.What_happens_when_MAB_is_met__c.addError(system.Label.ERR00024);
                        isValid=false;
                    }    
                    if(wrap.accumsDrugList.MAB_Dedictible_Amount__c==null){
                        wrap.accumsDrugList.MAB_Dedictible_Amount__c.addError(system.Label.ERR00024);
                        isValid=false;  
                    }
                    if(wrap.accumsDrugList.MAB_Period__c==null){
                        wrap.accumsDrugList.MAB_Period__c.addError(system.Label.ERR00024);
                        isValid=false;
                    }*/
                }          
            }
        }
        catch(exception ex){
            isValid =false;
        }
        return isValid;          
    }
    /* 
     * Method :- validateAccumulationDrugListMoop
     * Description :- This Method check for the validation of Accumulation Drug List
     */ 
    public boolean validateAccumulationDrugListMoop(Accumulations__c accumulation, LIST<VFP_AccumulationController.AccumsDruglistWrapper> wrappedList,String recordTypeName){
        boolean isValid = true; 
        try{
            errorMessages.clear(); 
            
            // added by Vikram for request 06211
            Set<Id> druglistGroupIds = new Set<Id>();
            for(VFP_AccumulationController.AccumsDruglistWrapper wrap:wrappedList){
                druglistGroupIds.add(wrap.accumsDrugList.Drug_List__c);
                druglistGroupIds.add(wrap.accumsDrugList.Drug_Group__c);
            }
            
            map<id,string> addedDLs = new map<id,string>();
            for(Drug_List__c drugList : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_List__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs.put(drugList.id,drugList.Allowable_Actions__c);
            }
            
            Map<Id,String> addedDLs1 = new Map<Id,String>();
            for(Drug_Group__c drugGroup : [Select 
                                            Id, Description__c, Allowable_Actions__c 
                                         From 
                                            Drug_Group__c
                                          Where 
                                            id in:druglistGroupIds LIMIT 80000]){
                
                addedDLs1.put(drugGroup.id,drugGroup.Allowable_Actions__c);
            }
            
            set<String> restrictedProfiles = new set<String>();
            for(Allowable_Actions_Excluded_Profiles__c exProf : Allowable_Actions_Excluded_Profiles__c.getall().values()){
                restrictedProfiles.add(exProf.Profile_ID__c);
            }
            // 06211 ends 
            
            if(wrappedList!=null && wrappedList.size()>0){          
                for(VFP_AccumulationController.AccumsDruglistWrapper wrap:wrappedList){
                    if(wrap.accumsDrugList.Drug_List__c==null && wrap.accumsDrugList.Drug_Group__c==null){                
                        wrap.accumsDrugList.Drug_List__c.addError(system.Label.ERR00021);
                        isValid=false;
                    }  
                    if(wrap.accumsDrugList.Drug_List__c!=null && wrap.accumsDrugList.Drug_Group__c!=null){
                        wrap.accumsDrugList.Drug_List__c.addError(system.Label.ERR00069);
                        isValid=false;
                    }   
                    
                    // added by Vikram for request 06211
                    if (wrap.accumsDrugList.Drug_Group__c!=null){
                        if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs1.get(wrap.accumsDrugList.Drug_Group__c)) && addedDLs1.get(wrap.accumsDrugList.Drug_Group__c).contains(ALLOWOVERRIDE)){
                        }else{    
                            if(String.isBlank(addedDLs1.get(wrap.accumsDrugList.Drug_Group__c)) || !addedDLs1.get(wrap.accumsDrugList.Drug_Group__c).contains(DRUGSPECIFICACCUM)){
                                errorMessages.add(system.Label.ERR0298);
                                isValid=false;
                            }
                        }
                    }else if(wrap.accumsDrugList.Drug_List__c!=null){
                            if(restrictedProfiles.contains(userinfo.getProfileId()) && !String.isBlank(addedDLs.get(wrap.accumsDrugList.Drug_List__c)) && addedDLs.get(wrap.accumsDrugList.Drug_List__c).contains(ALLOWOVERRIDE)){
                            }else{    
                                if(String.isBlank(addedDLs.get(wrap.accumsDrugList.Drug_List__c)) || !addedDLs.get(wrap.accumsDrugList.Drug_List__c).contains(DRUGSPECIFICACCUM)){
                                    errorMessages.add(system.Label.ERR0298);
                                    isValid=false;
                                }
                            }
                        }
                    // 06211 ends 
                    
                    /* added by Nitish Request No 4751 */
                    if(!wrap.accumsDrugList.Exclude_from_Accumulation__c){
                        if(wrap.accumsDrugList.MOOP_Period__c==null||wrap.accumsDrugList.MOOP_Dedictible_Amount__c==null||wrap.accumsDrugList.What_happens_when_MOOP_is_met__c==null||wrap.accumsDrugList.Deductible_Applies_towards_the_MOOP__c==null||wrap.accumsDrugList.DAW_Differential_Penalty_Applies_to_MOOP__c==null){
                            wrap.accumsDrugList.addError(system.Label.ERR0286);
                            isValid=false;                
                        }
                    }      
                     /* added by Nitish Request No 4751 */
                    if(wrap.accumsDrugList.Exclude_from_Accumulation__c){
                        if(wrap.accumsDrugList.MOOP_Period__c!=null||wrap.accumsDrugList.MOOP_Dedictible_Amount__c!=null||wrap.accumsDrugList.What_happens_when_MOOP_is_met__c!= null||wrap.accumsDrugList.Deductible_Applies_towards_the_MOOP__c!=null || wrap.accumsDrugList.DAW_Differential_Penalty_Applies_to_MOOP__c!=null){
                            wrap.accumsDrugList.addError(system.Label.ERR0287);
                            isValid=false;                
                        }
                    }      
                    /*if(wrap.accumsDrugList.MOOP_Dedictible_Amount__c==null){
                        wrap.accumsDrugList.MOOP_Dedictible_Amount__c.addError(system.Label.ERR00024);
                        isValid=false;
                    }*/
                    /* Commented By Nitish Request No 4751
                    if(wrap.accumsDrugList.MOOP_Period__c==null){
                        wrap.accumsDrugList.MOOP_Period__c.addError(system.Label.ERR00024);
                        isValid=false;                
                    }  
                    if(wrap.accumsDrugList.Deductible_Applies_towards_the_MOOP__c==null){
                        wrap.accumsDrugList.Deductible_Applies_towards_the_MOOP__c.addError(system.Label.ERR00024);
                        isValid=false;                
                    }*/
               /*     if(recordTypeName.contains('Family')){
                        if(wrap.accumsDrugList.Noof_Family_Members_to_Meet_Maximum_MOOP__c==null){
                            wrap.accumsDrugList.Noof_Family_Members_to_Meet_Maximum_MOOP__c.addError(system.Label.ERR00024);
                            isValid=false;                
                        }
                    }
                    
                    if(accumulation.Are_there_any_drug_specifc_MOOP__c && wrap.accumsDrugList.What_happens_when_MOOP_is_met__c==null){
                        wrap.accumsDrugList.What_happens_when_MOOP_is_met__c.addError(system.Label.ERR00024);
                        isValid=false;                
                    }    */
                    
                }
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;          
    }
    /* 
     * Method :- validateFamilyFields
     * Description :- This method check for the validation of fields of Accumulation
     */  
    public Boolean validateFamilyFields(Accumulations__c accumulation,String userSelectionRecordTypeName){
        boolean isValid = true; 
        try{
            if(accumulation.Carry_Balance_when_member_moves__c==null){
                accumulation.Carry_Balance_when_member_moves__c.addError(system.Label.ERR00024);             
                isValid=false;
            }
            //Uncommented by Rahul Nasa , Request No. 01092
            if(accumulation.Start_Month_New__c==null){
                accumulation.Start_Month_New__c.addError(system.Label.ERR00024);             
                isValid=false;
            }
            if(accumulation.Start_Day__c==null){
                accumulation.Start_Day__c.addError(system.Label.ERR00024);             
                isValid=false;
            }
            //Added by Rahul Nasa , Request No. 01149
            if(accumulation.Is_there_a_Maximum_Allowable_Benefit__c==null){
                accumulation.Is_there_a_Maximum_Allowable_Benefit__c.addError(system.Label.ERR00024);             
                isValid=false;
            }
            if(accumulation.Is_there_a_Maximum_Out_of_Pocket__c==null){
                accumulation.Is_there_a_Maximum_Out_of_Pocket__c.addError(system.Label.ERR00024);             
                isValid=false;
            }
            //Added by Rahul Nasa , Request No. 01149
            if(accumulation.Is_there_a_Maximum_Allowable_Benefit__c=='Yes' && accumulation.MAB_Dedictible_Amount__c==null){
                accumulation.MAB_Dedictible_Amount__c.addError(system.Label.ERR00024);             
                isValid=false;
            }
            //Commented by Amit Jain for request 1129 on 8/6/2013
            /*if(accumulation.Is_there_a_Maximum_Out_of_Pocket__c==true && accumulation.MOOP_Dedictible_Amount__c==null){
                accumulation.MOOP_Dedictible_Amount__c.addError(system.Label.ERR00024);             
                isValid=false;
            }*/
             
            if(accumulation.Is_there_a_Maximum_Allowable_Benefit__c=='Yes' && accumulation.What_happens_when_the_MAB_is_met__c==null){
                accumulation.What_happens_when_the_MAB_is_met__c.addError(system.Label.ERR00024);             
                isValid=false;
            } 
            
            if(accumulation.Is_there_a_Maximum_Out_of_Pocket__c=='Yes' && accumulation.Deductible_Applies_towards_the_MOOP__c==null){
                accumulation.Deductible_Applies_towards_the_MOOP__c.addError(system.Label.ERR00024); 
                isValid=false;
            } 
            if(accumulation.Is_there_a_Maximum_Out_of_Pocket__c=='Yes' && accumulation.MOOP_Dedictible_Amount__c!=null && double.valueOf(accumulation.MOOP_Dedictible_Amount__c)>0.00){
                if(accumulation.MOOP_Period__c==null){
                    accumulation.MOOP_Period__c.addError(system.Label.ERR00058);             
                    isValid=false;
                }
            }
            
         /*   if(accumulation.Is_this_an_HDHP_plan__c!=null && accumulation.Is_this_an_HDHP_plan__c=='Yes' && accumulation.What_is_the_fund_type__c==null){
                accumulation.What_is_the_fund_type__c.addError(system.Label.ERR00025);
                isValid=false;
            }  */
             
            if(accumulation.Is_there_a_Maximum_Allowable_Benefit__c=='Yes' && accumulation.MAB_Dedictible_Amount__c!=null && double.valueOf(accumulation.MAB_Dedictible_Amount__c)>0){
                if(accumulation.MAB_Period__c==null){
                    accumulation.MAB_Period__c.addError(system.Label.ERR00057);             
                    isValid=false;
                }
            }
          /*  if(userSelectionRecordTypeName.contains('Family')){
                if(accumulation.Family_Members_to_meet_Family_Deduct__c==null){
                    accumulation.Family_Members_to_meet_Family_Deduct__c.addError(system.Label.ERR00001);                 
                    isvalid=false;
                }
               if(accumulation.Is_there_a_Maximum_Out_of_Pocket__c==true && accumulation.Noof_Family_Members_to_Meet_Family_MOOP__c==null){
                    accumulation.Noof_Family_Members_to_Meet_Family_MOOP__c.addError(system.Label.ERR00003);      
                    isvalid=false;
                }   
            } */
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid ;
    }
    /*
     * Method :- validateClientInfoPhoneNumber
     * Description :- This method check for validation of client phone number
     */  
    public Boolean validateClientInfoPhoneNumber(CRD__c crd){
        boolean isValid = true; 
        try{
            if(crd.Client_Contact_Phone__c!=null){
                pattern phoneNumberPattern = pattern.compile('\\D*?(\\d\\D*?){10}');
                Matcher phoneNumberMatcher = phoneNumberPattern.matcher(crd.Client_Contact_Phone__c);
                if(!phoneNumberMatcher.matches()){
                    crd.Client_Contact_Phone__c.addError(system.Label.ERR00007);
                    isValid =false;
                }
            }
        }
        catch(exception ex){
            isvalid = false;
        }
        return isValid ;
    }
    
    /* 
     * Method :- checkUniqueMNOY
     * Description :- This Method check for validation unique DAW specific Copay
     */ 
    public boolean checkUniqueMNOY(list<VFP_CRDNewDAWSpecificCopay.DAWSpecificCopayWrapper> wrappedList){
        boolean isValid = true;
        try{
            errorMessages.clear();  
            set<String> setMsCodeM=new set<String>();
            set<String> setMsCodeN=new set<String>();
            set<String> setMsCodeO=new set<String>();
            set<String> setMsCodeY=new set<String>();
            for(VFP_CRDNewDAWSpecificCopay.DAWSpecificCopayWrapper wrap:wrappedList){
            //for unique MNOY and Daw code combination              
                if(wrap.dawSpecificCopayItem.MS_Code_M__c!=null && wrap.dawSpecificCopayItem.MS_Code_M__c){
                    if(setMsCodeM!=null && setMsCodeM.contains(wrap.dawSpecificCopayItem.DAW_Code__c)){
                        wrap.dawSpecificCopayItem.addError(system.Label.ERR00066);
                        isValid=false;
                    }else{
                        setMsCodeM.add(wrap.dawSpecificCopayItem.DAW_Code__c);
                    }
                }
                if(wrap.dawSpecificCopayItem.MS_Code_N__c!=null &&wrap.dawSpecificCopayItem.MS_Code_N__c){
                    if(setMsCodeN!=null && setMsCodeN.contains(wrap.dawSpecificCopayItem.DAW_Code__c)){
                        wrap.dawSpecificCopayItem.addError(system.Label.ERR00066);
                        isValid=false;
                    }else{                      
                        setMsCodeN.add(wrap.dawSpecificCopayItem.DAW_Code__c);
                    }
                }
                if(wrap.dawSpecificCopayItem.MS_Code_O__c!=null &&wrap.dawSpecificCopayItem.MS_Code_O__c){
                    if(setMsCodeO!=null && setMsCodeO.contains(wrap.dawSpecificCopayItem.DAW_Code__c)){
                        wrap.dawSpecificCopayItem.addError(system.Label.ERR00066);
                        isValid=false;
                    }else{                      
                        setMsCodeO.add(wrap.dawSpecificCopayItem.DAW_Code__c);
                    }
                }
                if(wrap.dawSpecificCopayItem.MS_Code_Y__c!=null &&wrap.dawSpecificCopayItem.MS_Code_Y__c){
                    if(setMsCodeY!=null && setMsCodeY.contains(wrap.dawSpecificCopayItem.DAW_Code__c)){
                        wrap.dawSpecificCopayItem.addError(system.Label.ERR00066);
                        isValid=false;
                    }else{                          
                        setMsCodeY.add(wrap.dawSpecificCopayItem.DAW_Code__c);
                    }
                }
                if(!wrap.dawSpecificCopayItem.MS_Code_M__c && !wrap.dawSpecificCopayItem.MS_Code_N__c && !wrap.dawSpecificCopayItem.MS_Code_O__c && !wrap.dawSpecificCopayItem.MS_Code_Y__c){
                    wrap.dawSpecificCopayItem.addError(system.Label.ERR00006);
                    isValid=false;
                }                        
            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }
    /* 
     * Method :- validatedawSpecificCopay
     * Description :- This Method check for validation of new DAW specific copay
     */   
    public boolean validatedawSpecificCopay(list<VFP_CRDNewDAWSpecificCopay.DAWSpecificCopayWrapper> wrappedList){
        boolean isValid = true;
        try{
            errorMessages.clear(); 
            for(VFP_CRDNewDAWSpecificCopay.DAWSpecificCopayWrapper wrap:wrappedList){
                if(!wrap.dawSpecificCopayItem.Stepped__c){
                    if(wrap.dawSpecificCopayItem.Dollar_Amount__c==null && wrap.dawSpecificCopayItem.Percent__c==null){
                        errorMessages.add(system.Label.ERR00051);                 
                        isValid=false;
                    }
                    if(wrap.dawSpecificCopayItem.Dollar_Amount__c!=null && wrap.dawSpecificCopayItem.Percent__c!=null){
                        if(wrap.dawSpecificCopayItem.Copay_Calculation__c==null){
                            wrap.dawSpecificCopayItem.Copay_Calculation__c.addError(system.Label.ERR00011);            
                            isValid=false;
                        }
                    }
                    if(wrap.dawSpecificCopayItem.Maximum_Dollar__c!=null && wrap.dawSpecificCopayItem.Minimum_Dollar__c!=null){
                        if(wrap.dawSpecificCopayItem.Minimum_Dollar__c > wrap.dawSpecificCopayItem.Maximum_Dollar__c){
                            wrap.dawSpecificCopayItem.Minimum_Dollar__c.addError(system.Label.ERR00060);
                            isValid=false;
                        }
                    }   
                }else{
                    if(wrap.dawSpecificCopayItem.Dollar_Amount__c!=null || wrap.dawSpecificCopayItem.Percent__c!=null){
                        if(wrap.dawSpecificCopayItem.Copay_Calculation__c==null){
                            wrap.dawSpecificCopayItem.Copay_Calculation__c.addError(system.Label.ERR00011);            
                            isValid=false;
                        }
                        if(wrap.dawSpecificCopayItem.Copay_Calculation__c!=null && wrap.dawSpecificCopayItem.Copay_Calculation__c!='Greatest of All' && wrap.dawSpecificCopayItem.Copay_Calculation__c!='Least of All'){
                            wrap.dawSpecificCopayItem.Copay_Calculation__c.addError(system.Label.ERR00064);
                            isValid=false;                        
                        }
                    }
                }
            }
            isValid = checkUniqueMNOY(wrappedList);
            }
            catch(exception ex){
                isValid = false;
            }
            return isValid;
    }
    
      /* 
       * Method :- checkDawCopayRange
       * Description :- This method check for validation of range of CRD DAW specific stepped Copay
       */      
      public boolean checkDawCopayRange(list<DAW_Specific_Stepped_Copay__c>steppedCopayItemList){
         boolean isValid = true;
         try{
             Decimal previousMaxRange=0.00;  
               // previousMaxRange=0.00;
                 if(steppedCopayItemList.size()>1){
                 for(integer i=0;i<steppedCopayItemList.size();i++){
                     if(steppedCopayItemList.get(i).End_Range__c!=null && i==0){                         
                         previousMaxRange=steppedCopayItemList.get(i).End_Range__c;
                     }else{                        
                             previousMaxRange=steppedCopayItemList.get(i-1).End_Range__c;                         
                     }
                     if(i!=0 && steppedCopayItemList.get(i).Beginning_Range__c!=null && previousMaxRange >= steppedCopayItemList.get(i).Beginning_Range__c){
                       isValid=false;                       
                     }
                     if(!isValid){
                         break;
                     }
                 }
                 }
        }
        catch(exception ex){
            isValid = false;
        }
         return  isValid; 
     }    
     /* 
      * Method :- validatedawSpecificSteppedCopay
      * Description :- This method check for the validation of CRDDAWSpecificSteppedCopay and display error message accordingly
      */   
     public boolean validatedawSpecificSteppedCopay(list<VFP_CRDDAWSpecificSteppedCopay.dawSpecificCopayWrapper> wrappedList){
        boolean isValid = true;
        try{
            errorMessages.clear();
            for(VFP_CRDDAWSpecificSteppedCopay.dawSpecificCopayWrapper wrap:wrappedList){
                if(wrap.dawSpecificSteppedCopayItemList!=null && wrap.dawSpecificSteppedCopayItemList.size()>0){
                    isValid = checkDawCopayRange(wrap.dawSpecificSteppedCopayItemList);
                    if(!isvalid){
                        errorMessages.add(system.Label.ERR00059);            
                        break;                    
                    }
                    
                    for(DAW_Specific_Stepped_Copay__c steppedCopay:wrap.dawSpecificSteppedCopayItemList){
                        if(steppedCopay.Dollar_Amount__c==null && steppedCopay.Percent__c==null){
                            steppedCopay.addError(system.Label.ERR00074);
                            isValid=false;
                        }   
                        
                        if(steppedCopay.Dollar_Amount__c!=null && steppedCopay.Percent__c!=null){
                            if(steppedCopay.Copay_Calculation__c==null){
                                steppedCopay.Copay_Calculation__c.addError(system.Label.ERR00011);            
                                 isValid=false;
                            }
                         }
                          if(steppedCopay.Maximum_Dollar__c!=null && steppedCopay.Minimum_Dollar__c!=null){
                            if(steppedCopay.Minimum_Dollar__c > steppedCopay.Maximum_Dollar__c){
                              steppedCopay.Minimum_Dollar__c.addError(system.Label.ERR00060);
                              isValid=false;
                            }
                          }   
                        
                        if(steppedCopay.Beginning_Range__c!=null && steppedCopay.End_Range__c!=null){
                         if(steppedCopay.Beginning_Range__c > steppedCopay.End_Range__c){
                           steppedCopay.Beginning_Range__c.addError(system.Label.ERR00008);
                          isValid=false;
                         }
                        }                    
                            
                    }
                }

            }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
        
        
     }
     /* 
      * Method :- CRDThirdScreenValidations 
      * Description :- This method check for validation of third screen CRD fields and display error messages accordingly
      */  
     public list<string> cRDThirdScreenValidations (crd__c crd){
     list<string> thirdScreenErrors = new list<string>();
     try{
         if(ThirdScreenErrors.size()>0){
             ThirdScreenErrors.clear();
         }
         boolean hasError = False;

     /* if(crd.Toll_Free_Number__c == 'Custom'){
                 if(crd.Custom_TFN__c == NULL){
                     ThirdScreenErrors.add(system.label.ERR00215);
                 }
            } */

          /*if(crd.Does_plan_have_an_Open_Enrollment_Date__c){
              if(crd.Open_Enrollment_Date__c == NULL){
                  ThirdScreenErrors.add(system.label.ERR00216);
                 }
             }*/
           if(crd.POS_Rebate_for_Plan__c == 'Yes'){
               if(crd.RTMD_Effective_Date__c == NULL || crd.RTMD_Client_Share_Percent__c== NULL ){
                   ThirdScreenErrors.add(system.label.ERR00217);
                  }
              }
            if(crd.POS_Rebate_for_Plan__c == 'No'){
               if(crd.RTMD_Effective_Date__c != NULL || crd.RTMD_Client_Share_Percent__c!= NULL ){
                   ThirdScreenErrors.add(system.label.ERR00218);
                  }
              }
             if(crd.In_Network_claims_are_reimbursed__c){
                 if(crd.In_Network_Discount_Rate__c == NULL){
                     ThirdScreenErrors.add(system.label.ERR00219);
                  }
              }
              if(crd.Out_of_Network_claims_are_reimbused__c){
                 if(crd.Out_of_Network_Discount_Rate__c == NULL){
                     ThirdScreenErrors.add(system.label.ERR00220);
                  }
              }
              if(crd.Does_the_client_want_to_do_COB__c == 'No'){
                  if(crd.COB_or_MOB__c != Null || crd.Process_Point_of_Sales_COB__c != False || crd.Reimbursement_Levels__c != Null|| crd.In_Network__c != False || crd.In_Network_Reimbursement_Level__c != Null|| crd.Out_of_Network__c != False || crd.Out_of_Network_Reimbursement_Level__c != Null){  
                         ThirdScreenErrors.add(system.label.ERR0241);    
                  }
              }
              if(crd.Does_the_client_want_to_do_COB__c == 'Yes'){
                   if(crd.COB_or_MOB__c == NULL){
                       ThirdScreenErrors.add(system.label.ERR00221);
                   }
                   if(crd.COB_or_MOB__c == 'COB'){        //27-02-2014 : Richa added for Request 4551
                       if(crd.Process_Point_of_Sales_COB__c &&crd.Reimbursement_Levels__c != '100% of submitted charges less ZERO copay'){
                          ThirdScreenErrors.add(system.label.ERR0235);
                       }
                       if(crd.In_Network__c && crd.In_Network_Reimbursement_Level__c != '100% submitted less ZERO copay'){
                          ThirdScreenErrors.add(system.label.ERR0236);
                       }
                       if(crd.Out_of_Network__c && crd.Out_of_Network_Reimbursement_Level__c != '100% submitted less ZERO copay'){
                          ThirdScreenErrors.add(system.label.ERR0237);
                       }
                  }
                   if(crd.COB_or_MOB__c == 'MOB'){        //27-02-2014 : Richa added for Request 4551
                       if(crd.Process_Point_of_Sales_COB__c && crd.Reimbursement_Levels__c != '100% of submitted charges less copay'){
                          ThirdScreenErrors.add(system.label.ERR0238);
                       }
                       if(crd.In_Network__c  && crd.In_Network_Reimbursement_Level__c != '100% submitted charges less copay'){
                          ThirdScreenErrors.add(system.label.ERR0239);
                       }
                       if(crd.Out_of_Network__c  && crd.Out_of_Network_Reimbursement_Level__c != '100% submitted charges less copay'){
                          system.debug('##$$%%'+crd.Out_of_Network__c);
                          ThirdScreenErrors.add(system.label.ERR0240);
                       }
                  }

               }
            /*if(crd.Process_Point_of_Sales_COB__c){
                  if(crd.Reimbursement_Levels__c == NULL){
                      ThirdScreenErrors.add(system.label.ERR00222);
                     }
                }
              if(crd.In_Network__c){
                  if(crd.In_Network_Reimbursement_Level__c == NULL){
                      ThirdScreenErrors.add(system.label.ERR00223);
                     }
                 }
              if(crd.Out_of_Network__c){
                   if(crd.Out_of_Network_Reimbursement_Level__c == NULL){
                      ThirdScreenErrors.add(system.label.ERR00224);
                     }
              }
              if(crd.Does_the_client_want_to_do_COB__c == 'Yes' && crd.COB_or_MOB__c == 'MOB'){
                   if(crd.Process_Point_of_Sales_COB__c != False || crd.Reimbursement_Levels__c != Null|| crd.In_Network__c != False || crd.In_Network_Reimbursement_Level__c != Null|| crd.Out_of_Network__c != False || crd.Out_of_Network_Reimbursement_Level__c != Null){
                       ThirdScreenErrors.add(system.label.ERR00225);
                   }
              }    27-02-2014 : Richa commented for Request 4551*/
        }
        catch(exception ex){
            ThirdScreenErrors = ThirdScreenErrors;
        }
        return ThirdScreenErrors ;
     }
     /* 
      * Method :- programScreenValidation
      * Description :- This method check for validation of crd fields and display error message accordingly
      */    
     public list<String> programScreenValidation(crd__C crd){
     list<String> customErrorMessages = new list<String>();
     try{
         if(customErrorMessages.size()>0){
            customErrorMessages.clear();
         }
         boolean hasError = False;
         if (crd.Pharmacy_Advisor__c ) {
                    if (!crd.Adherence_to_Drug_Therapy__c  || !crd.Aetna_Autofill__c   ) {
                        customErrorMessages.add(system.Label.ERR00148);
                        
                    }
                }

                if (crd.Is_DM_vendor_the_same_for_each_condition__c == 'Yes' && (crd.Implementation_Type__c == null || string.isblank(crd.Implementation_Type__c))) {
                    customErrorMessages.add(System.Label.ERR00144);
                    
                } 

       
                if (crd.Disease_Management_Referral_Messaging__c != NULL && crd.Disease_Management_Referral_Messaging__c == 'Yes')
                    {
                        if(crd.Disease_Management_Messaging_for__c == NULL || crd.Is_DM_vendor_the_same_for_each_condition__c == NULL )
                        {
                            customErrorMessages.add(system.label.ERR00190);
                    
                        }
                    }
                    
                 if (crd.Pharmacy_Advisor__c != NULL && crd.Pharmacy_Advisor__c)
                     {
                      if(crd.Implementation_Type__c == NULL || crd.Enrolled_in_PA_for_other_condition__c == NULL 
                      || crd.Participate_in_CVS_mail_pharmacy_service__c == NULL ||
                      crd.Disease_Management_Referral_Messaging__c == NULL)
                       {
                           customErrorMessages.add(system.label.ERR00191);
                    
                       }
                                
                     }
                     
                 if (crd.Is_DM_vendor_the_same_for_each_condition__c != NULL && crd.Is_DM_vendor_the_same_for_each_condition__c == 'No')
                  {
                    if(crd.PA_Disease_Vendor_1__c == NULL || crd.PA_Condition_1__c == NULL ||
                    crd.PA_Custom_Disease_Vendor_Phone_1__c == NULL || 
                    crd.PA_DM_Vendor_Contract_End_Date_1__c == NULL || 
                    crd.PA_Disease_Vendor_2__c == NULL || crd.PA_Condition_2__c == NULL || 
                    crd.PA_Custom_Disease_Vendor_Phone_2__c == NULL || 
                    crd.PA_DM_Vendor_Contract_End_Date_2__c == NULL)
                    {
                       customErrorMessages.add(system.label.ERR00192);
                    
                    }
                 }
                  if(crd.Implementation_Type__c != NULL && 
                  crd.Implementation_Type__c == 'Pharmacy Advisor All Conditions Complete Buy-Up Option')
                  {
                   if((crd.PA_Condition_1__c != NULL && crd.PA_Condition_1__c != 'All Other Conditions') || 
                   (crd.PA_Condition_2__c != NULL && crd.PA_Condition_2__c != 'All Other Conditions') || 
                   (crd.PA_Condition_3__c != NULL && crd.PA_Condition_3__c != 'All Other Conditions') || 
                   (crd.PA_Condition_4__c != NULL && crd.PA_Condition_4__c != 'All Other Conditions') || 
                   (crd.PA_Condition_5__c != NULL && crd.PA_Condition_5__c != 'All Other Conditions') || 
                   (crd.PA_Condition_6__c != NULL && crd.PA_Condition_6__c != 'All Other Conditions') || 
                   (crd.PA_Condition_7__c != NULL && crd.PA_Condition_7__c != 'All Other Conditions'))
                        {
                            customErrorMessages.add(system.label.ERR00195);
                    
                        }
                  }
                   List<String> condition_List = New List<String>();
                  
                  If(crd.PA_Condition_1__c != NULL)
                      {
                      Condition_List.add(crd.PA_Condition_1__c);
                      }
                  If(crd.PA_Condition_2__c != NULL)
                      {
                      Condition_List.add(crd.PA_Condition_2__c);
                      }
                  If(crd.PA_Condition_3__c != NULL)
                      {
                      Condition_List.add(crd.PA_Condition_3__c);
                      }
                  If(crd.PA_Condition_4__c != NULL)
                      {
                      Condition_List.add(crd.PA_Condition_4__c);
                      }
                  If(crd.PA_Condition_5__c != NULL)
                      {
                      Condition_List.add(crd.PA_Condition_5__c);
                      }
                  If(crd.PA_Condition_6__c != NULL)
                      {
                      Condition_List.add(crd.PA_Condition_6__c);
                      }
                  If(crd.PA_Condition_7__c != NULL)
                      {
                      Condition_List.add(crd.PA_Condition_7__c);
                      }
                      
                  integer sizeOfList = Condition_List.Size();
                  
                  for(integer i=0; i<SizeOfList ; i++)
                      {  for(integer j=i+1; j<SizeOfList ; j++)
                          {    
                              if(Condition_List[i] == Condition_List[j])
                              {   customErrorMessages.add(system.label.ERR00194);
                    
                               
                              }
                          }
                      }
             }
            catch(exception ex){
                customErrorMessages = customErrorMessages;
            }
                  return customErrorMessages;
     }
     
     
    
     
     
     
     
     //Added by Sourabh
     
    /* public boolean validateDCDrugList(List<DC_Drug_List_Group__c> wrappedList){ 
         errorMessages.clear();         
         boolean isValid = true;
         for(DC_Drug_List_Group__c dcdl:wrappedList){
                if((dcdl.Drug_Group__c!=NULL && dcdl.Drug_List__c!=NULL) || (dcdl.Drug_Group__c==Null && dcdl.Drug_List__c ==Null)){
                        errorMessages.add(system.Label.ERR00051);                 
                        isValid=false;   
                } 
              
            }
            return isValid;
        }*/
        
        /* 
         * Added by Rishabh Kushagra Bansal on 18th Oct'12
         * Method :- checkChangeCopay
         * Description :- This method check for validation of Accumulation
         */     
       public boolean checkChangeCopay(Id CRDID){
            List<Accumulations__c> accumList = new List<Accumulations__c>([Select id, CRD_ID__c, What_happens_when_MOOP_is_met__c, 
            What_happens_when_the_MAB_is_met__c, Total_Change_Copays__c FROM Accumulations__c WHERE CRD_ID__c =: CRDID]);
            Boolean isValid = True;
            try{
                if( AccumList != Null && AccumList.size()>0){
                    for(Accumulations__c accum : AccumList){
                       //  if(((accum.What_happens_when_MOOP_is_met__c != NULL && accum.What_happens_when_MOOP_is_met__c == 'Change Copay to $0') - Commented by Sourabh to modify the value
                         if(((accum.What_happens_when_MOOP_is_met__c != NULL && accum.What_happens_when_MOOP_is_met__c == 'Change Copay')
                         ||(accum.What_happens_when_the_MAB_is_met__c != NULL && accum.What_happens_when_the_MAB_is_met__c == 'Change Copay' ))
                         &&(accum.Total_Change_Copays__c == 0)){                         
                                
                                isValid = False;
                             
                                
                        }
                    }
                }
        }
        catch(exception ex){
            isValid = false;
        }
        return isValid;
    }    
    /*
     * Method :- matchAccount
     * Description :- This Method check for validation of account name
     */ 
    public boolean matchAccount(CRD__c crd){
        boolean isAccountMapped=true;
        try{
             Full_Control_Group__c objFCG = null;        // Instantiation of FCG type object
                    if(crd.Full_Control_Group__c != NULL)
                    {
                        objFCG=[Select Id,Account_Name__c from Full_Control_Group__c where Id=: crd.Full_Control_group__c];
                        if(objFCG!=null)
                        {
                            if (crd.account__c != objFCG.Account_name__c)
                            {
                            
                             isAccountMapped=false;
                            } 
                        }
                    }
        }
        catch(exception ex){
            isAccountMapped = false;
        }
           return isAccountMapped;     
                
    }
      /* 
     
     Commented By Sushant : Req 04937
      *Added by Amit Jain on 07/31/2013
      *for request 01129
      * Method :- validateMOOpBypass
      * Description :- This method checking validation
      
     public boolean validateMOOPBypass(List<VFP_CRDStep3Controller.moopbypassWrapper > moopBypassRecord ){ 
         errorMessages.clear();         
         boolean isValid = true;
         try{
             for(VFP_CRDStep3Controller.moopbypassWrapper moop:moopBypassRecord ){
                    if((moop.mooprec.MOOP_Bypass_Drug_Group__c!=NULL && moop.mooprec.MOOP_Bypass_Drug_List__c!=NULL) ||
                        (moop.mooprec.MOOP_Bypass_Drug_Group__c==Null && moop.mooprec.MOOP_Bypass_Drug_List__c==Null)){                 
                            isValid=false;   
                    } 
                  
                }
        }
        catch(exception ex){
            isValid = false;
        }
            return isValid;
        } */   
}