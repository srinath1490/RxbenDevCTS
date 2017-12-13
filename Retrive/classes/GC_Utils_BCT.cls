/*Purpose: Utility class GC_Utils_BCT
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Amit            10/9/2013           Utility class GC_Utils_BCT    

======================================================================== */
public class GC_Utils_BCT {
       public user currentLoggedInUser {
        get;
        set;
       }
       
       public string crdId {
        get;
        set;
       }
       
       public list < String > errorMessages {
        get;
        set;
       }
       
       private string subSegmentValue;      
       Public AI_Request__c aiRequest;
        GC_Utils_Method gcUtilsMethod = new GC_Utils_Method();       
                        
       //Method to create AI Request
       public  void sendToAi1(CRD__c crd) {
        errorMessages = new list < String > ();
        errorMessages.clear();
        currentLoggedInUser = [select id, profile.name from user where id = : UserInfo.getUserId()];
        crdId = crd.id;
        Boolean isValidAccum = True;
        GC_Validation_Methods checkAccum = new GC_Validation_Methods();
        if (!checkAccum.checkChangeCopay(crd.id)) {
            isValidAccum = False;
            errorMessages.add(system.Label.ERR00147);
        }
        overrideSubSegmentValue(crd);
        if (crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == 'No' && crd.Full_Control_Group__c == null) {
            errorMessages.add(system.label.ERR00134);
        } else if ((crd.Insured_Type__c == 'Split Funded' || crd.Insured_Type__c == 'Fully Insured') && crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == 'Yes' && crd.Full_Control_Group__c != null) {
            errorMessages.add(system.label.ERR00135);
        } else {
            VFP_SendToAIButtonController sendToAI = new VFP_SendToAIButtonController();
            crd.Integrating_User__c = currentLoggedInUser.Id;

            if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                crd.Platform_Information__c = 'H';
            } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                crd.Platform_Information__c = 'T';
            }
            
            overrideSubSegmentValue(crd);
            
            Boolean hasError = false;
            if ((crd.Are_you_creating_a_Package_Plan__c != null) && crd.Are_you_creating_a_Package_Plan__c == 'Yes' && crd.Which_system_will_the_plan_be_installed__c == null) {
                errorMessages.add(system.label.ERR00196);
            }

            overrideSubSegmentValue(crd);
            List<String> yScheduleList = GC_Utils_Method.calculateYSchedule(crd, subSegmentValue);
            system.debug('#############################Abhay##################'+yScheduleList);
            if (yScheduleList != null) {
                crd.Y_Schd__c = yScheduleList[0];
                crd.Pricing_Schedule__c = yScheduleList[0];
                crd.Mail_Y_Schedule__c = yScheduleList[1];
            } else {
                System.debug('############## NO YSCHEDULE CALCULATED ##############');
            }
            
            try {
                string truncIntegration1;
                truncIntegration1 = IntegrationCtrlPlanExtractor.getString(crdId);
                crd.Integration_1__c = gcUtilsMethod.truncateString(truncIntegration1,5000);
                update crd;
            } catch (exception e) {
                errorMessages.add(e.getMessage());
            }
            
            
            system.debug('**Y-schedule***' + crd.Y_Schd__c + crd.Subsegment__c + crd.Insured_Type__c + crd.Rating_ERB__c);
            boolean isCriteriaSet;
            isCriteriaSet = true;
            if (isCriteriaSet == false) {

                errorMessages.add(system.label.ERR00100);
            } else if (crd.Platform_Information__c != Null && crd.Platform_Information__c != '' && crd.TP_ID__c == Null && crd.Rx_PP_ID__c == Null && crd.Y_Schd__c != '' && isValidAccum) {
                aiRequest = new AI_Request__c();
                aiRequest.CRD_ID__c = crd.Id;
                aiRequest.Request_Type__c = system.label.CL0000033;
                aiRequest.Pricing_Schedule__c = crd.Pricing_Schedule__c;
                aiRequest.Risk_Indicator__c = crd.Risk_Indicator__c;
                aiRequest.Integration_1__c = crd.Integration_1__c;
                aiRequest.Created_by_BCT_Mass_Cloning__c = True;

                List < string > RxPlanData;
                RxPlanData = sendToAI.SendToAI(crdId);
                crd.RxPlanData__c = RxPlanData[0];
                if (RxPlanData.size() > 1) {
                    crd.RxPlanDataExp__c = RxPlanData[1];
                    aiRequest.Benefits_String_Extn__c = RxPlanData[1];
                }
                crd.Integration_Status__c = 'Send to AI';
                aiRequest.Benefit__c = RxPlanData[0];
                  system.debug('...Pricing1...' + crd.Pricing_Schedule__c);
                   system.debug('...Pricing2...' + aiRequest.Pricing_Schedule__c);

                update crd;
                insert aiRequest;
            } else if (crd.TP_ID__c != Null || crd.Rx_PP_ID__c != Null) {
                errorMessages.add(system.label.ERR00101);
            } else {
                errorMessages.add(system.label.ERR00102);
            }
        }
    }
    
       // Method for override y schedule
       public void overideYscheduleValues(CRD__c crd) {
            if (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c == 'Yes') {
                crd.Y_Schd__c = crd.Retail_Y_Schedule_Override__c;
                crd.Pricing_Schedule__c = crd.Retail_Y_Schedule_Override__c;
            }
        }
        
        //method to override values provided by user
       public void overrideSubSegmentValue(CRD__c crd) {
            if (crd.Sub_segment__c != null) {
                subSegmentValue = crd.Sub_segment__c;
            } else {
                subSegmentValue = crd.Subsegment__c;
            }
       }
      
       //Method for Callout 
       public static void callout(AI_Request__c aiRequest) {
        WSDL_CRDDetail.CRDNotification integrationClass = new WSDL_CRDDetail.CRDNotification();
        WSDL_CRDDetail.CRDDetails crdDetail = new WSDL_CRDDetail.CRDDetails();
        if (aiRequest != null) {
            try {
                if (aiRequest.Id != null) {
                    crdDetail.requestId = aiRequest.Id;
                }
                if (aiRequest.CRD_ID__c != null) {
                    crdDetail.crdId = aiRequest.CRD_ID__c;
                }
                if (aiRequest.Request_Type__c != null) {
                    crdDetail.requestType = aiRequest.Request_Type__c;
                }
                if (aiRequest.Plan_ID__c != null) {
                    crdDetail.planId = aiRequest.Plan_ID__c;
                }
                if (aiRequest.Benefit__c != null) {
                    crdDetail.benefitsString = aiRequest.Benefit__c;
                }
                if (aiRequest.Benefits_String_Extn__c != null) {
                    crdDetail.benefitsStringExtension = aiRequest.Benefits_String_Extn__c;
                }
                if (aiRequest.Integration_1__c != null) {
                    crdDetail.traditionalControlNumberPlanSummaryDetails = aiRequest.Integration_1__c;
                }
                if (aiRequest.Pricing_Schedule__c != null) {
                    crdDetail.pricingSchedule = aiRequest.Pricing_Schedule__c;
                }
                if (aiRequest.Risk_Indicator__c != null) {
                    crdDetail.riskIndicator = aiRequest.Risk_Indicator__c;
                }
                if (aiRequest.StateList_to_Remove__c != null) {
                    crdDetail.listOfStatesToRemoveFromPlan = aiRequest.StateList_to_Remove__c;
                }
                if (aiRequest.Request_Type__c.contains(system.label.CL0000035)) {
                    crdDetail.benefitsApplyToAllStates = string.valueof(aiRequest.State_Mandates_Apply__c);
                    crdDetail.benefitsStateList = aiRequest.States_List_for_Mandate__c;
                }

                integrationClass.SessionId = Userinfo.getsessionId();
                integrationClass.CRDDetails = crdDetail;
                WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort sendData = new WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort();
                sendData.endpoint_x = system.label.CL0000034;
                system.debug('**integrationClass**' + integrationClass);
                Boolean result = sendData.createRxPlan(integrationClass);
                system.debug('####Result' +result);
                if (result) {
                    aiRequest.Description__c = 'Successfully sent to AI';
                    update aiRequest;
                } else {
                    aiRequest.Description__c = 'Error When sending to AI';
                    update aiRequest;
                }
            } catch (exception e) {
                aiRequest.Description__c = 'Message: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString();
                update aiRequest;
            }
        }

       }
}