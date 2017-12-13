/**
*Purpose: Apex class for controller of VF_RetailVaccineProgram Screen.                                         
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR                 DATE                    DETAIL  
 1.0         Nitish Verma           08/09/2016              This apex class is the controller of VF Page VF_RetailVaccineProgram
 *========================================================================
**/
public with sharing class VFP_RetailVaccineProgramScreenController {

        
        public string crdId {get;set;}
        public CRD__c crd {get;set;}
        public boolean seasonal{get;set;}
        public boolean preventive{get;set;}
        public boolean travel{get;set;}
        public boolean checkBoxDisability{get;set;}
        public Retail_Vaccine_Program__c rvpSeasonal{get;set;}
        public Retail_Vaccine_Program__c rvpPopulateVaccineNetwork{get;set;}
        public Retail_Vaccine_Program__c rvpPreventive{get;set;}
        public List<Retail_Vaccine_Program__C> rvpSeasonalList {get;set;}
        public List<Retail_Vaccine_Program__C> rvpPreventiveList {get;set;}
        public List<Retail_Vaccine_Program__C> rvpTravelList {get;set;}
        public Retail_Vaccine_Program__c rvpTravel{get;set;}
        public string groupMember{get;set;}
        public String editMode{get;set;}
        public boolean noError;
        public id recordTypeSeasonal;
        public id recordTypePreventive;
        public id recordTypeTravel;
        private static final string BACKBUTTON = '/apex/VF_CRDoralChemoCopay?crdid=';
        private static final string NEXTBUTTON = '/apex/VF_CRDNewCoPay?id=';
        private static final string EDITMODEPARAM = 'p1';
        private static final string GROUPMEMBERPARAM = 'p2';
        private static final string CRDID1 = 'crdid';
        private static final string TRAVELNAME = 'Travel';
        private static final string PREVENTIVENAME = 'Preventive';
        private static final string SEASONALNAME = 'Seasonal';
    
   /**
     * Method -  VFP_RetailVaccineProgramScreenController()
     * Description - Constructor of the class VFP_RetailVaccineProgramScreenController
    **/
    public VFP_RetailVaccineProgramScreenController(ApexPages.StandardController controller) {
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);        
        this.crd = [Select id,Does_Chemo_Parity_Apply__c,Chemo_Parity_Drug_List__c,Oral_Chemo_Cap__c,Dollar_Amount__c,Percent__c,Copay_Calculation__c,
                    Chemo_Drugs_Bypass_Deductible__c,Chemo_Drugs_Bypass_MAB__c,Chemo_Drugs_Bypass_OOP__c,Chemo_Drugs_In_Network_same_as_OON__c,Insured_type__c,Plan_Type_Paper__c,Name,Y_Schd__c
                     from CRD__c where id = :crdId LIMIT 80000]; 
        rvpSeasonalList =  new List<Retail_Vaccine_Program__c>();
        rvpPreventiveList = new List<Retail_Vaccine_Program__c>();
        rvpTravelList = new List<Retail_Vaccine_Program__c>();
        seasonal = FALSE;
        preventive = FALSE;
        travel = FALSE;
        recordTypeSeasonal = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get(SEASONALNAME).getRecordTypeId();
        recordTypePreventive = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get(PREVENTIVENAME).getRecordTypeId();
        recordTypeTravel = Schema.SObjectType.Retail_Vaccine_Program__C.getRecordTypeInfosByName().get(TRAVELNAME).getRecordTypeId(); 
        rvpPopulateVaccineNetwork = new Retail_Vaccine_Program__C();
        checkBoxDisability = true;
        try{
              for(Retail_Vaccine_Program__C rvp:[select Name,Applies__c,RecordTypeId,CoPay_Calculation__c,CRD__c,Dollar_Amount__c,Maximum_Dollar__c,Minimum_Dollar__c,Percent__c,Vaccine_Network__c,Waiver_of_Deductible__c,
                                                (select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc) from Retail_Vaccine_Program__C where CRD__c=:crdId 
                                                  AND 
                                                  RecordTypeId IN(:recordTypeSeasonal,:recordTypePreventive,:recordTypeTravel) Limit 100]){                                
                        if(rvp.RecordTypeId == recordTypeSeasonal){
                            seasonal = TRUE;
                            rvpPopulateVaccineNetwork.Vaccine_Network__c = rvp.Vaccine_Network__c;
                            rvpSeasonalList.add(rvp);
                            rvpSeasonal = new Retail_Vaccine_Program__C(id=rvp.id,CoPay_Calculation__c = rvp.CoPay_Calculation__c,CRD__c=rvp.CRD__c,Dollar_Amount__c=rvp.Dollar_Amount__c,Maximum_Dollar__c=rvp.Maximum_Dollar__c,Minimum_Dollar__c=rvp.Minimum_Dollar__c,Percent__c=rvp.Percent__c,Vaccine_Network__c=rvp.Vaccine_Network__c,Waiver_of_Deductible__c =rvp.Waiver_of_Deductible__c);   
                        }                               
                        if(rvp.RecordTypeId == recordTypePreventive){
                            preventive = TRUE;
                            rvpPopulateVaccineNetwork.Vaccine_Network__c = rvp.Vaccine_Network__c;
                            rvpPreventiveList.add(rvp);
                            rvpPreventive = new Retail_Vaccine_Program__C(id=rvp.id,CoPay_Calculation__c = rvp.CoPay_Calculation__c,CRD__c=rvp.CRD__c,Dollar_Amount__c=rvp.Dollar_Amount__c,Maximum_Dollar__c=rvp.Maximum_Dollar__c,Minimum_Dollar__c=rvp.Minimum_Dollar__c,Percent__c=rvp.Percent__c,Vaccine_Network__c=rvp.Vaccine_Network__c,Waiver_of_Deductible__c =rvp.Waiver_of_Deductible__c);
                        }                               
                        if(rvp.RecordTypeId == recordTypeTravel){
                            travel = TRUE;
                            rvpPopulateVaccineNetwork.Vaccine_Network__c = rvp.Vaccine_Network__c;
                            rvpTravelList.add(rvp);
                            rvpTravel = new Retail_Vaccine_Program__C(id=rvp.id,CoPay_Calculation__c = rvp.CoPay_Calculation__c,CRD__c=rvp.CRD__c,Dollar_Amount__c=rvp.Dollar_Amount__c,Maximum_Dollar__c=rvp.Maximum_Dollar__c,Minimum_Dollar__c=rvp.Minimum_Dollar__c,Percent__c=rvp.Percent__c,Vaccine_Network__c=rvp.Vaccine_Network__c,Waiver_of_Deductible__c =rvp.Waiver_of_Deductible__c);
                            system.debug('rvpTravel11+++ ' +rvpTravel);
                        }
                     
                    }
                       if(rvpSeasonalList == null || rvpSeasonalList.size()==0){
                            rvpSeasonal = new Retail_Vaccine_Program__C();
                           
                        }
                        if(rvpPreventiveList == null || rvpPreventiveList.size()==0){
                            rvpPreventive = new Retail_Vaccine_Program__C();
                           
                        }
                        if(rvpTravelList == null || rvpTravelList.size() ==0){
                            rvpTravel = new Retail_Vaccine_Program__C();
                            
                        }
                    if(rvpPopulateVaccineNetwork.Vaccine_Network__c !=null){
                        checkBoxDisability = false;
                    }
            }
         catch(Exception e){
             system.debug('exception message ' + e.getlineNumber());
         }
    
            
    }
    /**
     Method  -  backReadOnly()
     Description - Method to control functionality of back button in read only mode of CRD
    **/
    public pageReference backReadOnly(){
   try{
           Pagereference pageRef = new Pagereference(BACKBUTTON + crd.Id);
           pageRef.getParameters().put(EDITMODEPARAM,editMode);
           pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
           return pageRef;
       }catch(exception e){
                             return null;  
                           }
                           
    }
     /**
     Method  -  backEditMode()
     Description - Method to control functionality of back button in editMode only  of CRD
    **/
    public pagereference backEditMode(){
        boolean stopCreation = false;
        
        if(rvpPopulateVaccineNetwork.Vaccine_Network__c != NULL && !seasonal && !preventive && !travel){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0306);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(seasonal && rvpSeasonal.Waiver_of_Deductible__c== null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0307);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(preventive && rvpPreventive.Waiver_of_Deductible__c== null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0308);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(travel && rvpTravel.Waiver_of_Deductible__c== null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0309);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(seasonal && rvpSeasonal.Dollar_Amount__C== null && rvpSeasonal.Percent__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0310);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(preventive && rvpPreventive.Dollar_Amount__C== null && rvpPreventive.Percent__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0311);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(travel  && rvpTravel.Dollar_Amount__C== null && rvpTravel.Percent__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0312);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(seasonal  && rvpSeasonal.Dollar_Amount__C != null && rvpSeasonal.Percent__c != null && rvpSeasonal.CoPay_Calculation__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0313);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(preventive && rvpPreventive.Dollar_Amount__C != null && rvpPreventive.Percent__c != null  && rvpPreventive.CoPay_Calculation__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0314);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(travel && rvpTravel.Dollar_Amount__C!= null && rvpTravel.Percent__c != null && rvpTravel.CoPay_Calculation__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0315);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
         }               
          IF(seasonal && !stopCreation){
           rvpSeasonal.RecordTypeId = recordTypeSeasonal;
            rvpSeasonal.CRD__c = crdId;
            rvpSeasonal.Vaccine_Network__c = rvpPopulateVaccineNetwork.Vaccine_Network__c;
            upsert rvpSeasonal;
        }
         IF(preventive && !stopCreation ){
            rvpPreventive.RecordTypeId = recordTypePreventive;
            rvpPreventive.CRD__c = crdId;
            rvpPreventive.Vaccine_Network__c = rvpPopulateVaccineNetwork.Vaccine_Network__c;
            upsert rvpPreventive;
        }
         IF(travel && !stopCreation){
            rvpTravel.RecordTypeId = recordTypeTravel;
            rvpTravel.CRD__c = crdId;
            rvpTravel.Vaccine_Network__c = rvpPopulateVaccineNetwork.Vaccine_Network__c;
            upsert rvpTravel;
        }
        
        if(stopCreation){
            return null;
        }
        else{
             PageReference pageRef = new PageReference(BACKBUTTON + crdId);
             pageRef.getParameters().put(EDITMODEPARAM,editMode);
             pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
             deleteRVP();
             return pageRef;
             }
        
    }
     /**
     Method  -  nextReadOnly()
     Description - Method to control functionality of next button in read only mode of CRD
    **/
    public pageReference nextReadOnly(){
    try{
        PageReference pageRef = new PageReference(NEXTBUTTON + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;   
    }   catch(exception e){
                             return null;
                          }
    }
     
    /**
     Method  -  nextEditMode()
     Description - Method to control functionality of next button in edit mode of CRD
    **/
    public pagereference nextEditMode(){
        boolean stopCreation = false;
      
        if(rvpPopulateVaccineNetwork.Vaccine_Network__c != NULL && !seasonal && !preventive && !travel){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0306);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(seasonal && rvpSeasonal.Waiver_of_Deductible__c== null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0307);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(preventive && rvpPreventive.Waiver_of_Deductible__c== null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0308);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(travel && rvpTravel.Waiver_of_Deductible__c== null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0309);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(seasonal && rvpSeasonal.Dollar_Amount__C== null && rvpSeasonal.Percent__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0310);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(preventive && rvpPreventive.Dollar_Amount__C== null && rvpPreventive.Percent__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0311);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(travel  && rvpTravel.Dollar_Amount__C== null && rvpTravel.Percent__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0312);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(seasonal  && rvpSeasonal.Dollar_Amount__C != null && rvpSeasonal.Percent__c != null && rvpSeasonal.CoPay_Calculation__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0313);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(preventive && rvpPreventive.Dollar_Amount__C != null && rvpPreventive.Percent__c != null  && rvpPreventive.CoPay_Calculation__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0314);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
        }
        if(travel && rvpTravel.Dollar_Amount__C!= null && rvpTravel.Percent__c != null && rvpTravel.CoPay_Calculation__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0315);
                        ApexPages.addMessage(myMsg);
                        stopCreation = TRUE;
         }               
          IF(seasonal && !stopCreation){
            rvpSeasonal.RecordTypeId = recordTypeSeasonal;
            rvpSeasonal.CRD__c = crdId;
            rvpSeasonal.Vaccine_Network__c = rvpPopulateVaccineNetwork.Vaccine_Network__c;
            upsert rvpSeasonal;
        }
         IF(preventive && !stopCreation ){
            rvpPreventive.Vaccine_Network__c = rvpPopulateVaccineNetwork.Vaccine_Network__c;
            rvpPreventive.RecordTypeId = recordTypePreventive;
            rvpPreventive.CRD__c = crdId;
            upsert rvpPreventive;
        }
         IF(travel && !stopCreation){
            rvpTravel.Vaccine_Network__c = rvpPopulateVaccineNetwork.Vaccine_Network__c;
            rvpTravel.RecordTypeId = recordTypeTravel;
            rvpTravel.CRD__c = crdId;
            system.debug('rvpTravel+++ ' +rvpTravel);
            upsert rvpTravel;
        }
        
        if(stopCreation){
            return null;
        }
        else{
             PageReference pageRef = new PageReference(NEXTBUTTON + crdId);
             pageRef.getParameters().put(EDITMODEPARAM,editMode);
             pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
             deleteRVP();
             return pageRef;
             }
      
     
    
       
    }  
   /*Method: clearFields()
     Purpose: This function clears all the fields when "Clear Fields" button is clicked
    */     
    public void clearFields() {
  
        rvpSeasonal.Waiver_of_Deductible__c = null;
        rvpSeasonal.Vaccine_Network__c = null;
        rvpSeasonal.Percent__c = null;
        rvpSeasonal.Minimum_Dollar__c = null;
        rvpSeasonal.Maximum_Dollar__c = null;
        rvpSeasonal.Dollar_Amount__c = null;
        rvpSeasonal.CoPay_Calculation__c =null;
        rvpSeasonal.Applies__c = null;
        rvpPreventive.Waiver_of_Deductible__c = null;
        rvpPreventive.Vaccine_Network__c = null;
        rvpPreventive.Percent__c = null;
        rvpPreventive.Minimum_Dollar__c = null;
        rvpPreventive.Maximum_Dollar__c = null;
        rvpPreventive.Dollar_Amount__c = null;
        rvpPreventive.CoPay_Calculation__c = null;
        rvpPreventive.Applies__c = null;
        rvpTravel.Waiver_of_Deductible__c = null;
        rvpTravel.Vaccine_Network__c = null;
        rvpTravel.Percent__c = null;
        rvpTravel.Minimum_Dollar__c = null;
        rvpTravel.Maximum_Dollar__c = null;
        rvpTravel.Dollar_Amount__c = null;
        rvpTravel.CoPay_Calculation__c = null;
        rvpTravel.Applies__c = null;
        rvpPopulateVaccineNetwork.Vaccine_Network__c = null;
        checkBoxDisability = TRUE;
        seasonal = false;
        preventive = false;
        travel = false;
       }
      
   
    /**
     Method  -  reRenderCheckbox()
     Description -  To render seasonal,preventive,travel checkboxes on the Retail Vaccine program screen
    **/    
    public pageReference reRenderCheckbox(){
     
        if(rvpPopulateVaccineNetwork.Vaccine_Network__c !=null){
            checkBoxDisability = false;
        }
        
        return null;
    }
    /**
     Method  -  deleteRVP()
     Description -  To delete Retail Vaccine Program if checkboxes are unchecked.
    **/
    public void deleteRVP(){
       try{
        if(!seasonal && rvpSeasonal.id != null){
            delete rvpSeasonal;
            
        }
        if(!preventive && rvpPreventive.id != null){
            delete rvpPreventive;
            
        }
        if(!travel && rvpTravel.id !=null){
            delete rvpTravel;
            
        }
    }
    catch(Exception e){
    //Do Nothing
    }
    
   }
    

}