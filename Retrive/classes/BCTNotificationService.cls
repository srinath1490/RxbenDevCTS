/*Purpose: Apex Batch Class for populating the Step Thereapy Prerequiste Description    
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj               7/24/2012      Apex Batch Class for populating the Step Thereapy Prerequiste Description  
   2.0-     Abhishek            12/03/2014    Added new field for BctNotification.
======================================================================== */
Global class BCTNotificationService{  
        
/*
     * Method :- RxPlanBlock
     * Description :- Its a Webservice callout class
*/  
   Global class RxPlanBlock {
        Webservice List<RxPlanDetail>  RxPlanDetail=new list<RxPlanDetail>();
        Webservice List<RxPlanDetail>  errorRxPlanDetails=new list<RxPlanDetail>();
/*
     * Method :- RxPlanBlock
     * Description :- constructor of  Webservice  class RxPlanBlock
*/

        Public RxPlanBlock(list<RxPlanDetail> arg_data,list<RxPlanDetail> arg_Error_data){
            for(RxPlanDetail rxdetail:arg_data){
                RxPlanDetail.add(rxdetail);
            }
            this.RxPlanDetail= RxPlanDetail;
            
            for(RxPlanDetail rxdetail:arg_Error_data){
                errorRxPlanDetails.add(rxdetail);
            }
            this.errorRxPlanDetails= errorRxPlanDetails;
        }
    }
/*
    * Method :- RxPlanDetail
    * Description :- Its a Webservice callout class
*/    
    Global class RxPlanDetail{
        Webservice String RxPlanID;
        Webservice String status;
        Webservice String tieringType;
        Webservice String states;
    /*
    * Constructor of webservice class RxPlanDetail
    */  
        Public RxPlanDetail(string arg_RxPlanID,string arg_status,string arg_tieringType,string arg_states){
          this.RxPlanID=Arg_RxPlanID;
          this.status=Arg_status;
          this.tieringType=Arg_tieringType; 
          this.states=arg_states;
        }        
    } 
/*
     * Method :- ErrRxPlanBlock
     * Description :- Its a Webservice callout class
*/   
     Global class errRxPlanBlock {
        Webservice List<RxPlanDetail>  errorRxPlanDetails;
    /* 
     * Constructor of webservice class errRxPlanBlock
     */ 
        Public errRxPlanBlock (list<RxPlanDetail> arg_data){
            for(RxPlanDetail rxdetail:arg_data){
                errorRxPlanDetails.add(rxdetail);
            }
            this.errorRxPlanDetails= errorRxPlanDetails;
        }
    }

    /*
    * Its a Webservice callout class
    */
    Global class traditionalControlNumberPlanSummary{
        webservice integer controlNumber;
        Webservice String planSummary;
    /*
     * Constructor of webservice class  traditionalControlNumberPlanSummary
     */
        Public traditionalControlNumberPlanSummary(integer arg_controlNumber,string arg_planSummary){
          this.controlNumber=arg_controlNumber;
          this.planSummary=arg_planSummary;           
        } 
    }
     /*
    * Its a Webservice callout class
    */
    Global class tradHierarchy{
        webservice Long control;
        Webservice integer suffix;
        Webservice integer account;
        Webservice String planSummary;
    /* 
     * Constructor of webservice class tradHierarchy
     */ 
        Public tradHierarchy(integer arg_controlNumber,integer arg_suffix,integer arg_account,string arg_planSummary){
          this.control=arg_controlNumber;
          this.suffix=arg_suffix;
          this.account=arg_account;
          this.planSummary=arg_planSummary;           
        } 
    }
    /*
    * Its a Webservice callout class
    */
   Global class custmoHierarchy{        
        Webservice String company;
        Webservice String groups;
        Webservice String location;
        Webservice String plan;
        /*
       * Constructor of webservice class customHierarchy
       */ 
        Public custmoHierarchy(string arg_company,string arg_group,string arg_location,string arg_plan){
          this.company=arg_company;
          this.groups=arg_group;
          this.location=arg_location;
          this.plan=arg_plan;           
        } 
    }
    /*
     * Its a webservice callout class
     */
    Global class ReturnData{
      Webservice String RequestId;
      WebService integer notificationCount;
      WebService String crdId;
      WebService String requestType;
      WebService String pricingSchedule;
      WebService String riskIndicator;
      WebService String fundingType;
      WebService String planId;
      WebService RxPlanBlock tieredRxPlanBlock;
      WebService RxPlanBlock rxPlanBlock;     
     // WebService errRxPlanBlock ErrtieredRxPlanBlock;
     // WebService errRxPlanBlock errRxPlanBlock;
      WebService String errorType;
      WebService String errorDescription;
      WebService string benefitsString;
      WebService string AcquisitionIndicator;
      WebService string benefitsStringExtension;
      WebService list<traditionalControlNumberPlanSummary> traditionalControlNumberPlanSummaryDetails;
      WebService string effectiveDate;
      WebService string termDate;
      WebService string erb;
      WebService String subSegment;      
      WebService boolean benefitsApplyToAllStates;
      WebService string benefitsStateList;
      WebService string listOfStatesToRemoveFromPlan;
      WebService custmoHierarchy hmoHierarchy;
      WebService tradHierarchy traditionalHierarchy;
      
      //Added by Ankur
      WebService string OrgId;
      WebService string OrgArrangementId;
      WebService string OrgType;
      WebService string CarrierId;
      WebService string PSUID;
      WebService string TypeofPlan;      
     // WebService string RowID; 
     //added by abhishek
      WebService string changeLevelIndicator;
      WebService string acquisitionCode;
     // added by Sushant
     
      WebService string accountName;     
      // added by Abhishek 
      WebService string Marketsegment;
      WebService string CFO;  
      
    }
    

    
     WebService Static Boolean BctNotification(ReturnData requestData){
            boolean isRequestSuccessFull=false;
         system.debug('----requestData ' + requestData);
          if(requestData!=NULL){
           try{              	          
            isRequestSuccessFull = BCTServiceHandler.execute(requestData);
            isRequestSuccessFull=true;
           }catch(exception e){
            IntegrationLogger logger=new IntegrationLogger(); 
            logger.logme(false,'Exception In call','There is an exception thrown on the request',system.now(),Userinfo.getName(),'BCTnotification','Exception details'+e,'Exception is:'+e);
                system.debug('#######Exception######'+e);
            isRequestSuccessFull=false;
           }
           return isRequestSuccessFull;
           }else{
            return isRequestSuccessFull;
          }
         
          
        }
     
}