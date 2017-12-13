/*
Purpose: Apex Class for sending AI request for CRD Medicare record.
===================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL
------------------------------------------------------------------------------------------------------
1.0         rakesh          03/22/2013          Requst 00931.
                                                This class is responsible for sending AI request for
                                                CRD Medicare record.
                                                This class is called by OnClick javascript by custom
                                                button 'Send to AI' on 'CRD Medicare' Object.
*/

global class VFP_CRDMedicareSendToAI {
    
    global static List<String> calloutResult;
    global static CRD_Medicare__c crdMedicare;
    global static CRD_Medicare_AI_Request__c aiRequest;
    
    /**
     * This method is called from the javascript of custom button 'Send to AI' on 'CRD Medicare'
     * object.
     *
     * @param crdMedicareId
     *      the Salesforce Id for which the AI Request is being sent. The value equals the
     *      Id of the object from which the button is clicked.
     *
     * @return
     *      The Id of the AI_Request object created for the callout
     */
    webservice static String sendAiRequest(Id crdMedicareId) {
    	calloutResult = new List<String>();
        crdMedicare = [SELECT Custom_BEN_ID__c, Do_mandates_apply_to_all_states__c, Funding_Type__c,
                               Remove_States_List_for_Mandate__c, Request_Type__c, Risk_Indicator__c,
                               State_List_for_Mandate__c, Y_Schedule__c
                       FROM CRD_Medicare__c
                       WHERE Id = :crdMedicareId];
                       
        return sendBenid();
    }
    
    /**
     * Method to validate the CRD Medicare fields. After validating the method creates a record
     * of 'CRD_Medicare_AI_Request__c' object which.
     *
     * @return
     *      The Id of the AI_Request object created for the callout
     */
    webservice static String sendBenId() {
        calloutResult.clear();
        aiRequest = new CRD_Medicare_AI_Request__c();
        aiRequest.CRD_Medicare_Id__c = crdMedicare.Id;
        aiRequest.Request_Type__c = system.Label.CL0000038;

        Integer currentBenidSize = crdMedicare.Custom_BEN_ID__c.length();
        Integer trailing0Needs = 10 - currentBenidSize;
        
        if (trailing0Needs > 0) {
            String trailingBenIdString = '0';
            for (integer i = 1; i < trailing0Needs; i++) {
                trailingBenIdString = trailingBenIdString + '0';
            }
            crdMedicare.Custom_BEN_ID__c = trailingBenIdString + crdMedicare.Custom_BEN_ID__c;
        }
        
        aiRequest.Benefit__c = crdMedicare.Custom_BEN_ID__c;
        aiRequest.Pricing_Schedule__c = crdMedicare.Y_Schedule__c;
        aiRequest.Risk_Indicator__c = crdMedicare.Risk_Indicator__c;
        
        if (crdMedicare.State_List_for_Mandate__c != null) {
            aiRequest.States_List_for_Mandate__c = crdMedicare.State_List_for_Mandate__c.replaceAll(';', ',');
        }
        
        if (crdMedicare.Do_mandates_apply_to_all_states__c == 'Yes') {
            aiRequest.State_Mandates_Apply__c = True;
            aiRequest.States_List_for_Mandate__c = '';
        } else {
            aiRequest.State_Mandates_Apply__c = False;
        }
        
        if (crdMedicare.Remove_States_List_for_Mandate__c != Null && crdMedicare.Remove_States_List_for_Mandate__c != '') { // fnf
            aiRequest.StateList_to_Remove__c = crdMedicare.Remove_States_List_for_Mandate__c.replaceAll(';', ',');
        }
        insert aiRequest;
        
        return aiRequest.Id;
    }
    
    /**
     * This method actually makes actual callout to the AI Request web-service
     *
     * @return
     *      The response from the web-sevice callout
     */
    webservice static String callout(Id aiRequestId) {
        
        CRD_Medicare_AI_Request__c request = [SELECT Name, Benefit__c, Benefits_String_Extn__c, CRD_Medicare_Id__c, Integration_1__c,
												        Plan_ID__c, Pricing_Schedule__c, Request_Type__c, Risk_Indicator__c,
												        StateList_to_Remove__c, State_Mandates_Apply__c, States_List_for_Mandate__c
									       	  FROM CRD_Medicare_AI_Request__c
											  WHERE Id = :aiRequestId];
        
        calloutResult = new List<String>();
        
        system.debug('######## CRD Medicare ######### Callout: ' + request);
        WSDL_CRDDetail.CRDNotification integrationClass = new WSDL_CRDDetail.CRDNotification();
        WSDL_CRDDetail.CRDDetails crdDetail = new WSDL_CRDDetail.CRDDetails();
        
        if (request != null) {
            try {
                crdDetail.requestId = request.Id;
                crdDetail.crdId = request.CRD_Medicare_Id__c;
                crdDetail.requestType = request.Request_Type__c;
                
                if (request.Plan_ID__c != null) {
                    crdDetail.planId = request.Plan_ID__c;
                }
                if (request.Benefit__c != null) {
                    crdDetail.benefitsString = request.Benefit__c;
                }
                if (request.Benefits_String_Extn__c != null) {
                    crdDetail.benefitsStringExtension = request.Benefits_String_Extn__c;
                }
                if (request.Integration_1__c != null) {
                    crdDetail.traditionalControlNumberPlanSummaryDetails = request.Integration_1__c;
                }
                if (request.Pricing_Schedule__c != null) {
                    crdDetail.pricingSchedule = request.Pricing_Schedule__c;
                }
                if (request.Risk_Indicator__c != null) {
                    crdDetail.riskIndicator = request.Risk_Indicator__c;
                }
                if (request.StateList_to_Remove__c != null) {
                    crdDetail.listOfStatesToRemoveFromPlan = request.StateList_to_Remove__c;
                }
                if (request.Request_Type__c.contains(system.label.CL0000035)) {
                    crdDetail.benefitsApplyToAllStates = string.valueof(request.State_Mandates_Apply__c);
                    crdDetail.benefitsStateList = request.States_List_for_Mandate__c;
                }
                
                integrationClass.SessionId = Userinfo.getsessionId();
                integrationClass.CRDDetails = crdDetail;
                WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort sendData = new WSDL_SendToAI.SalesForceCRDNotification_WS_EXP_CRDNotificationHttpPort();
                sendData.endpoint_x = system.label.CL0000034;
                sendData.timeout_x = 30000;
                
                system.debug('######## CRD Medicare ######### integration Class: ' + integrationClass);
                
                Boolean result = sendData.createRxPlan(integrationClass);
                system.debug('######## CRD Medicare ######### Callout: ' + result);
                
                if (result) {
                    calloutResult.add(system.label.ERR00106);
                }
            } catch (exception e) {
                calloutResult.add(system.label.ERR00127);
            }
        } else {
            calloutResult.add(system.label.ERR00128);
        }
        
        String message = '';
        for (String str : calloutResult)
            message += str + '\n';

        System.debug('######## CRD Medicare ######### calloutResult: ' + calloutResult);
        System.debug('######## CRD Medicare ######### message: ' + message);
        return message;
    }
}