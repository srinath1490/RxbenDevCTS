/*
Purpose: Apex Class for Global Utility Method  
===============================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE        DETAIL
-------------------------------------------------------------------------------                                 
1.0         Anuj            7/23/2011   Apex Class for Global Utility Method
1.1         rakesh          3/28/2013   Req. 00483:
                                        Added method 'getPricingSchedule()'to get Y-Schedule from
                                        'Y_Schedule_Pricing_Override' object.
1.2         Rishabh         4/2/2013    Added criteria for CRD indicator.
1.3         rakesh          4/4/2013    Added method 'logSaveresult()'
1.4         rakesh          4/9/2013    Updated logic to save 'AI_Request' and perform callouts from
                                        another batch by using flag 'Pers_Ready_for_Callout'
1.5         rakesh          4/16/2013   Added method 'calculateYSchedule()' to calculate Y-Schedule
2.0         Amit            5 jan,2015  Added method calculateControl() to correct the control pplan of crd or PCG which is used 
                                        for calculation of Y-Schedule and Sending CRD to AI
3.0         Amit            29 Feb 2016 Modified by Amit for ST# 1040 on 29 Feb, 2016. Changed field Subsgement__c to Rating_ERB__c.
4.0         Nitish          12 December 2016 Modified by Nitish for Request 06765. Added a method checkManagementUser()  
5.0         Nitish          24 March 2017 Implemented Request 06902                              
===============================================================================
*/

public class GC_Utils_Method {
    Public AI_Request__c aiRequest;
    Public static boolean batchRun = false;
    public list < Batch_Logger__c > listlogger;
    Public string managementUser = 'false';
    public boolean stopPreviousLogic = false;
    public string subSegmentValue {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    Private Static Final string SEMICOLON = ';';
    Private Static Final string PARENTAPI = 'Parent__c';
    Private Static Final string FIELDNAMEAPI = 'Field_Name__c';
    Private Static Final string MODIFIEDBYAPI = 'Modified_By__c';
    Private Static Final string NEWVALUEAPI = 'New_Value__c';
    Private Static Final string OLDVALUEAPI = 'Old_Value__c';
    Private Static Final string SELFINSURED = 'Self Insured';
    Private Static Final string SPLITFUNDED = 'Split Funded';
    Private Static Final string FULLYINSURED = 'Fully Insured';
    Private Static Final string YES = 'Yes';
    Private Static Final string NO = 'No';
    Private Static Final string ALPHABETH = 'H';
    Private Static Final string ALPHABETT = 'T';
    Private Static Final string Y4 = 'Y4';
    Private Static Final string BLANKVALUE = '';
    Private Static Final string Y6 = 'Y6';
    Private Static Final string SENDTOAISTATUS = 'Send to AI'; 
    Private Static Final string TRADITIONALPACKAGE = 'Traditional_Packaged';
    Private Static Final string SUCCESSFULLYSENTTOAI = 'Successfully sent to AI';
    Private Static Final string ERRORWHENSENDINGTOAI = 'Error When sending to AI';
    Private Static Final string MESSAGE = 'Message: ';
    Private Static Final string STACKTRACE = '\nStack Trace: ';
    Private Static Final string CLONINGHIX = 'Cloning a HIX plan from existing CRD';
    Private Static Final string CREATINGHIX = 'Creating a HIX plan';
    Private Static Final string TRADITIONAL = 'Traditional';
    Private Static Final string HRP = 'HRP'; 
    Private Static Final string CREATINGCONSUMERPLAN = 'Creating a packaged consumer business plan';
    Private Static Final string CLONINGCONSUMERPLAN = 'Cloning a packaged consumer business plan from an existing CRD';
    Private Static Final string HMO = 'HMO';
    Private Static Final string DISCOUNTCARDVAR = 'Discount Card';
    Private Static Final string Y13= 'Y13';
    Private Static Final string ALPHABETR= 'R';
    Private Static Final string RETRO = 'Retrospective';
    Private Static Final string NOTRETRO = 'Not Retrospective';
    Private Static Final string NUMZERO = '0';
    Private Static Final string ALPHABETC = 'C';
    Private Static Final string STAR = '*';
    Private Static Final string CRDMANAGEMENTUSER = 'CRD Management Users';
    Private Static Final string TRUESTRING = 'true';
    Private Static Final string ALPHABETN = 'N';
    Private Static Final string ALPHABETS= 'S';
    Private Static Final string NUMONE = '1';
    Private Static Final string ALPHABETY = 'Y';
    
    
    /* Method to truncate string */
        public string truncateString(string s,integer size){
        if(s != NULL && s.length()>size){
            s = s.substring(0,size-1);
            }        
        return s;
        } 
        
    /* Method to match a string from a multiSelect field */
        public boolean compareWithMultiSelect(string multiSelectField,string tempField){ 
            boolean matchFound = false;
            String[] multiValues = multiSelectField.split(SEMICOLON);
            for(string val : multiValues){
                if(val.equals(tempField) && matchFound != true){
                    matchFound = true;
                    break;
                }
            }
            return matchFound; 
        }          
    
    public static List < Drug_List_Criteria__c > mergeLists(List < Drug_List_Criteria__c > left, List < Drug_List_Criteria__c > right) {
        List < Drug_List_Criteria__c > result = new List < Drug_List_Criteria__c > ();
        while (left.size() > 0 && right.Size() > 0) {
            if (left.get(0).Effective__c < right.get(0).Effective__c) {
                result.add(left.get(0));
                left.remove(0);
            } else {
                result.add(right.get(0));
                right.remove(0);
            }
        }
        if (left.size() > 0) result.addall(left);
        else result.addall(right);
        return result;
    }

    // Sorting of Drug List Criteria on the basis of Effective date 
    public static List < Drug_List_Criteria__c > merge_sort(List < Drug_List_Criteria__c > m) {
        if (m.Size() <= 1) return m;

        List < Drug_List_Criteria__c > left, right, result;
        left = new List < Drug_List_Criteria__c > ();
        right = new List < Drug_List_Criteria__c > ();
        result = new List < Drug_List_Criteria__c > ();
        integer middle = m.Size() / 2;

        for (integer x = 0; x < middle; x++)
        left.add(m[x]);
        for (integer y = middle; y < m.Size(); y++)
        right.add(m[y]);
        left = merge_sort(left);
        right = merge_sort(right);
        result = mergeLists(left, right);
        return result;
    }

    Public sobject historyData(sobject history, Id parentId, string fieldName, string modifiedBy, string oldValue, string newValue) {
        history.put(PARENTAPI, parentId);
        history.put(FIELDNAMEAPI, fieldName);
        history.put(MODIFIEDBYAPI, modifiedBy);
        history.put(NEWVALUEAPI, newValue);
        history.put(OLDVALUEAPI, oldValue);
        return history;
    }
    
    // Added new method for generic parent API- 6666
    Public sobject historyDatasObject(sobject history, Id parentId, string fieldName, string modifiedBy, string oldValue, string newValue) {
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(string.ValueOf(history.getSObjectType())).getDescribe().fields.getMap();
        
        String fieldAPIName;
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            schema.describefieldresult dfield = sfield.getDescribe();
            DisplayType fieldType= dfield.getType();
            Boolean customField = dfield.isCustom();
             
            if(fieldType == Schema.DisplayType.Reference && customField == TRUE)
            {
                fieldAPIName = dfield.getLocalName();
            }
        }
        
        history.put(fieldAPIName, parentId);
        history.put(FIELDNAMEAPI, fieldName);
        history.put(MODIFIEDBYAPI, modifiedBy);
        history.put(NEWVALUEAPI, newValue);
        history.put(OLDVALUEAPI, oldValue);
        return history;
    }


    //SendtoAi1 method created for PERS Mass Change
    public void sendToAi1(crd__c crd, Id currentLoggedInUser, Batch_Logger__c batchlogger) {
        errorMessages = new list < String > ();
        errorMessages.clear();

        Boolean isValidAccum = True;
        crdId = crd.id;
        GC_Validation_Methods checkAccum = new GC_Validation_Methods();
        
            if (!checkAccum.checkChangeCopay(crd.id)) {
                isValidAccum = False;
                errorMessages.add(system.Label.ERR00147);
            }
        overrideSubSegmentValue(crd);
        if (crd.IsDummyCRD__c==false && crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == NO && (crd.Partial_Control_Group__c == null || crd.Full_Control_Group__c == null)) {
            errorMessages.add(system.label.ERR00134);
        } else if (crd.IsDummyCRD__c==false && (crd.Insured_Type__c == SPLITFUNDED || crd.Insured_Type__c == FULLYINSURED) && crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == YES && (crd.Partial_Control_Group__c != null || crd.Full_Control_Group__c != null)) {
            errorMessages.add(system.label.ERR00135);
        } else {
  
            VFP_SendToAIButtonController sendToAI = new VFP_SendToAIButtonController();
            crd.Integrating_User__c = currentLoggedInUser;
            if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                crd.Platform_Information__c = ALPHABETH;
            } else if (crd.Which_system_will_the_plan_be_installed__c != Null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                crd.Platform_Information__c = ALPHABETT;
            }

            if (crd.Partial_Control_Group__c == null || crd.Account__c == null) {
                crd.Y_Schd__c = Y4;
            } else if (subSegmentValue != null && subSegmentValue != BLANKVALUE && crd.Insured_Type__c != null && crd.Insured_Type__c != BLANKVALUE && crd.Rating_ERB__c != Null && crd.Rating_ERB__c != BLANKVALUE && crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                crd.Y_Schd__c = ScheduleHelper.fetchRetailYScheduleValue(subSegmentValue, crd.Insured_Type__c, crd.Rating_ERB__c, crd.High_Value_Client__c);
                crd.Pricing_Schedule__c = crd.Y_Schd__c;
            } else if (subSegmentValue != null && subSegmentValue != BLANKVALUE && crd.Insured_Type__c != null && crd.Insured_Type__c != BLANKVALUE && crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                crd.Y_Schd__c = ScheduleHelper.fetchYScheduleForHMO(subSegmentValue, crd.Insured_Type__c, crd.High_Value_Client__c);
                crd.Pricing_Schedule__c = crd.Y_Schd__c;
            } else if (crd.Are_you_creating_a_Package_Plan__c == YES) {
                crd.Y_Schd__c = Y4;
            }
            crd.Pricing_Schedule__c = crd.Y_Schd__c;
            crd.Mail_Y_Schedule__c = Y6;

            overideYscheduleValues(crd);
            try {
                string truncIntegration1;
                truncIntegration1 = IntegrationCtrlPlanExtractor.getString(crdId);
                crd.Integration_1__c = truncateString(truncIntegration1,5000);
                update crd;
            } catch (exception e) {
                errorMessages.add(e.getMessage());
            }
            boolean isCriteriaSet;
            if ((crd.Platform_Information__c != Null && crd.Platform_Information__c != BLANKVALUE && crd.TP_ID__c == Null && crd.Rx_PP_ID__c == Null && crd.Y_Schd__c != BLANKVALUE && isValidAccum) || crd.IsDummyCRD__c==true) {//crd.IsDummyCRD__c is used only for PERS DUMMY CRD
                aiRequest = new AI_Request__c();
                aiRequest.CRD_ID__c = crd.Id;
                //aiRequest.Request_Type__c = system.label.CL0000039;
                aiRequest.Pricing_Schedule__c = crd.Pricing_Schedule__c;
                aiRequest.Risk_Indicator__c = crd.Risk_Indicator__c;
                
                List < string > RxPlanData;
                if(crd.IsDummyCRD__c==false){
                RxPlanData = sendToAI.SendToAI(crdId);
                crd.RxPlanData__c = RxPlanData[0];
                if (RxPlanData.size() > 1) {
                    crd.RxPlanDataExp__c = RxPlanData[1];
                    aiRequest.Benefits_String_Extn__c = RxPlanData[1];
                    aiRequest.Benefit__c = RxPlanData[0];
                }
                }
                crd.Integration_Status__c = SENDTOAISTATUS;
                

                /* rakesh - 4/9 - Added new field and set to true for use from another batch */
                crd.Effective_Start_Date__c=batchlogger.PERS_Effective_Date_of_New_Benefits__c;
                aiRequest.Batch_Logger_ID__c = batchlogger.Id;
                aiRequest.Created_by_Batch_Process__c = true;                        
                if(batchlogger.For_NPP__c==True){
                aiRequest.Request_Type__c = system.label.CL0000047;
                aiRequest.Integration_1__c = crd.Integration_1__c;//moved to prevent benefit String in Traditional_Packaged request                 
                }else if(batchlogger.For_Out_State__c==True || batchlogger.For_In_State__c==True){
                aiRequest.Request_Type__c = system.label.CL0000039; 
                aiRequest.Plan_ID__c=batchlogger.TPID_From_PERS__c;                 
                }             
                update crd;
                insert aiRequest;
            } else if (crd.TP_ID__c != Null || crd.Rx_PP_ID__c != Null) {
                errorMessages.add(system.label.ERR00101);
            } else {
                errorMessages.add(system.label.ERR00102);
            }
        }
    }

    //Method created for PERS Mass Change
    public void overrideSubSegmentValue(crd__c crd) {
        if (crd.Sub_segment__c != null) {
            subSegmentValue = crd.Sub_segment__c;
        } else {
            subSegmentValue = crd.Subsegment__c;
        }
    }

    //Method created for PERS Mass Change
    public void overideYscheduleValues(crd__c crd) {
        if (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c == YES) {
            crd.Y_Schd__c = crd.Retail_Y_Schedule_Override__c;
            crd.Pricing_Schedule__c = crd.Retail_Y_Schedule_Override__c;
        }
    }

    //Callout Method created for PERS Mass Change
    public static void callout(Id batchLoggerId, AI_Request__c aiRequest) {

        Batch_Logger__c loggerrecord = [SELECT Cloned_CRD_ID__c, CRD__c, CSAP_CGLP__c, Description__c, Dummy_CRD__c, EffectiveDate_Greater_Than_CRD__c, For_In_State__c, For_NPP__c, For_Out_State__c, Full_CSAP__c, Has_AI_Error__c, Has_Error__c, NoCRDForInStatePP__c, Pers_Data_Storage__c, Processed__c, Ready_For_AI__c, RxPlanId__c, Successfully_Sent_To_AI__c, TimeStamp__c
        FROM Batch_Logger__c
        WHERE Id = : batchLoggerId];
        WSDL_CRDDetail.CRDNotification integrationClass = new WSDL_CRDDetail.CRDNotification();
        WSDL_CRDDetail.CRDDetails crdDetail = new WSDL_CRDDetail.CRDDetails();

        if (aiRequest != null) {
            try {
                crdDetail.requestId = aiRequest.Id;
                crdDetail.crdId = aiRequest.CRD_ID__c;
                crdDetail.requestType = aiRequest.Request_Type__c;
                if (aiRequest.Plan_ID__c != null) {
                    crdDetail.planId = aiRequest.Plan_ID__c;
                }
                if(aiRequest.Request_Type__c!= TRADITIONALPACKAGE){
                if (aiRequest.Benefit__c != null) {
                    crdDetail.benefitsString = aiRequest.Benefit__c;
                }
                if (aiRequest.Benefits_String_Extn__c != null) {
                    crdDetail.benefitsStringExtension = aiRequest.Benefits_String_Extn__c;
                }
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
                Boolean result = sendData.createRxPlan(integrationClass);
                
                if (result) {
                    loggerrecord.Successfully_Sent_To_AI__c = True;
                    loggerrecord.Description__c = SUCCESSFULLYSENTTOAI;
                    update loggerrecord;
                } else {
                    loggerrecord.Has_AI_Error__c = True;
                    loggerrecord.Description__c = ERRORWHENSENDINGTOAI;
                    update loggerrecord;
                }
            } catch (exception e) {
                loggerrecord.Has_AI_Error__c = True;
                loggerrecord.Description__c = MESSAGE + e.getMessage() + STACKTRACE + e.getStackTraceString();
                update loggerrecord;
            }
        }
    }
    
    /*
     * This method calculates the Y-Schedule for a given CRD.
     *
     * @requirement 00483
     * @author      mistry, rakesh - 'inspire'
     * @date        2013-04-16
     * @param crd
     *      The CRD for which Y-Schedule is to be calculated. It is expected to have all the field values
     *      that are being used in the method.
     * @return
     *      List of string containing 2 values - first is the Retail Y-Schedule, second is Mail Y-Schedule
     */
    public static List<String> calculateYSchedule(CRD__c crd, String subSegmentValue) {
        String controlPlan;
         if(crd.control__c!= Null && crd.plan__c!=Null){
                    controlPlan = calculateControl(crd.control__c) + crd.plan__c;
         }
         Partial_Control_Group__c pcgRecord =  new Partial_Control_Group__c();
         if(controlPlan!= Null && controlPlan!= BLANKVALUE){
            pcgRecord = [Select Id,Subsegment__c,Rating_ERB__c, name from Partial_Control_Group__c where PCGKey__c =: controlPlan limit 1];
         }
        //Added by Amit on 15th Nov 2013
        
        if(crd.Standard_or_Custom_Plan__c == CLONINGHIX || crd.Standard_or_Custom_Plan__c == CREATINGHIX){
                return new List<String>{Y4, Y6};
        }
        //ends
        
        if (crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == YES) {
            if (crd.Which_system_will_the_plan_be_installed__c != null && (crd.Which_system_will_the_plan_be_installed__c == TRADITIONAL || crd.Which_system_will_the_plan_be_installed__c == HRP)) { 
            if((crd.Standard_or_Custom_Plan__c == CREATINGCONSUMERPLAN || crd.Standard_or_Custom_Plan__c == CLONINGCONSUMERPLAN)  && (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c != BLANKVALUE && crd.Override_Retail_Y_Schedule__c == YES)){
                    return new List<String>{crd.Retail_Y_Schedule_Override__c, Y6};
            }else{
                return new List<String>{Y4, Y6};
            }
            }
            else if(crd.Which_system_will_the_plan_be_installed__c != null && (crd.Which_system_will_the_plan_be_installed__c == HMO)){
                if((crd.Standard_or_Custom_Plan__c == CREATINGCONSUMERPLAN || crd.Standard_or_Custom_Plan__c == CLONINGCONSUMERPLAN)  && (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c != BLANKVALUE && crd.Override_Retail_Y_Schedule__c == YES)){
                    return new List<String>{crd.Retail_Y_Schedule_Override__c, Y6};
            }
            }
            else{
                return new List<String>{Y4,Y6};
            }
            
            if (crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == HMO) {
                
                if (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c != BLANKVALUE && crd.Override_Retail_Y_Schedule__c == YES) {
                    String retailYSchedule = crd.Retail_Y_Schedule_Override__c;
                    return new List<String>{retailYSchedule, Y6};
                } else if (crd.Override_Retail_Y_Schedule__c != null && crd.Override_Retail_Y_Schedule__c == NO) {
                    if (crd.Sub_segment__c != null) {
                        // calculate as previously
                        String ySchedule;
                        
                        if (crd.Partial_Control_Group__c == null || crd.Account__c == null) {
                            ySchedule = Y4;
                        } else if (subSegmentValue != null && subSegmentValue != BLANKVALUE && crd.Insured_Type__c != null && crd.Insured_Type__c != BLANKVALUE && crd.Rating_ERB__c != Null && crd.Rating_ERB__c != BLANKVALUE && crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                        
                            ySchedule = ScheduleHelper.fetchRetailYScheduleValue(subSegmentValue, crd.Insured_Type__c, crd.Rating_ERB__c, crd.High_Value_Client__c);
                            system.debug(ySchedule );
                        } else if (subSegmentValue != null && subSegmentValue != BLANKVALUE && crd.Insured_Type__c != null && crd.Insured_Type__c != BLANKVALUE && crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                            ySchedule = ScheduleHelper.fetchYScheduleForHMO(subSegmentValue, crd.Insured_Type__c, crd.High_Value_Client__c);
                            system.debug(ySchedule );                            
                        } else if (crd.Are_you_creating_a_Package_Plan__c == YES) {
                            ySchedule = Y4;
                        }
                        
                        if (ySchedule != null) {
                            return new List<String>{ySchedule, Y6};
                        }
                    } else {
                            return new List<String>{Y4, Y6};
                    }
                } else if (crd.Override_Retail_Y_Schedule__c == null) {
                    return new List<String>{Y4, Y6};
                }
            }
        } else if (crd.Are_you_creating_a_Package_Plan__c == NO) {
            System.debug('@@@@@@@@@@@@@@@@1');
           if (crd.Full_Control_Group__c != null) {
                System.debug('@@@@@@@@@@@@@@@@2');
                // get from override table
                String retailYSchedule = getPricingSchedule(crd);
                
                if (retailYSchedule != null) {
                    return new List<String>{retailYSchedule, Y6};
                } 
                //Added By Nitish 6902
                else {
                    List<string> narrowNetYsch = getNarrowNetworkYschedule(crd,pcgRecord);
                    if(narrowNetYsch != null && narrowNetYsch.size()>0){
                        return narrowNetYsch;
                    }
                    else if(narrowNetYsch == null){
                          if (crd.Plan_Platform__c == DISCOUNTCARDVAR) {
                            return new List<String>{Y13, Y6};
                          }
                        //Exisiting Logic No change in this corresponding to 6902
                        else{
                            String ySchedule;
                            if (crd.Partial_Control_Group__c == null || crd.Account__c == null) {
                                ySchedule = Y4;
                            } else if (subSegmentValue != null && subSegmentValue != BLANKVALUE && crd.Insured_Type__c != null && crd.Insured_Type__c != BLANKVALUE && crd.Rating_ERB__c != Null && crd.Rating_ERB__c != BLANKVALUE && crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000036) {
                                ySchedule = ScheduleHelper.fetchRetailYScheduleValue(subSegmentValue, crd.Insured_Type__c, crd.Rating_ERB__c, crd.High_Value_Client__c);
                                    system.debug(ySchedule );                        
                            } else if (subSegmentValue != null && subSegmentValue != BLANKVALUE && crd.Insured_Type__c != null && crd.Insured_Type__c != BLANKVALUE && crd.Which_system_will_the_plan_be_installed__c != null && crd.Which_system_will_the_plan_be_installed__c == system.label.CL0000035) {
                                ySchedule = ScheduleHelper.fetchYScheduleForHMO(subSegmentValue, crd.Insured_Type__c, crd.High_Value_Client__c);
                                    system.debug(ySchedule );                        
                            } else if (crd.Are_you_creating_a_Package_Plan__c == YES) {
                                ySchedule = Y4;
                            }
                            system.debug(yschedule);
                            if (ySchedule != null) {
                                return new List<String>{ySchedule, Y6};
                            }
                        } 
                    }
                }
            }else{//Added for CRD Builder
                // get from override table
                System.debug('##############1223');
                String retailYSchedule = getPricingSchedule(crd);
               
                if (retailYSchedule != null) {
                    System.debug('##############1224');
                    return new List<String>{retailYSchedule,Y6};
                } else {
                    System.debug('##############1225');
                    //Added By Nitish 6902
                    List<string> narrowNetYsch2 = getNarrowNetworkYschedule(crd,pcgRecord);
                    if(narrowNetYsch2!= null && narrowNetYsch2.size()>0){
                        return narrowNetYsch2;
                    }
                    // calculate as previously
                    else{
                        if (crd.Plan_Platform__c == DISCOUNTCARDVAR) {
                            crd.Platform_Information__c = ALPHABETH;
                            return new List<String>{Y13,Y6};
                          }
                       else{
                            String ySchedule;
                            String Rating;
                            if (pcgRecord.Subsegment__c != null && pcgRecord.Subsegment__c != BLANKVALUE && crd.Insured_Type__c != null && crd.Insured_Type__c != BLANKVALUE && pcgRecord.Rating_ERB__c != Null && pcgRecord.Rating_ERB__c != BLANKVALUE) {
                                //Modified by Amit for ST# 1040 on 29 Feb, 2016. Changed field Subsgement__c to Rating_ERB__c.
                                if(pcgRecord.Rating_ERB__c == ALPHABETR){
                                    Rating = RETRO;
                                }else{
                                    Rating = NOTRETRO;
                                }
                             ySchedule = ScheduleHelper.fetchRetailYScheduleValue(pcgRecord.Subsegment__c, crd.Insured_Type__c, Rating, crd.High_Value_Client__c);
                             System.debug('##############yschedule' +ySchedule);
                            }
                            
                            if (ySchedule != null) {
                                System.debug('##############1226');
                                return new List<String>{ySchedule,Y6};
                            }
                       }
                    }
                }
            }
        }
    
     return null;
  }

    /*
     * This method is responsible for returning the Pricing schedule based on
     * the provided 'CRD'. For details on the criteria for getting the
     * pricing schedule please refer to the doc attached with the requirement.
     *
     * 'YSchedulesFilteredMap' contains map of 'Y_Schedule_Pricing_Override'
     * after filtering. It is updated after every 'YSchedulePricingOverrideFilter()'
     * call.
     *
     * 'filterCriteria' is used a create criteria for calling 'YSchedulePricingOverrideFilter()'.
     * Reinitialize it everytime for new criteria or clear fields from previous use.
     *
     * @requirement 00483
     * @author      mistry, rakesh - 'inspire'
     * @date        2013-03-28
     * @dependency  YSchedulePricingOverrideFilter()
     * @param       crd
     *      the crd which is compared to get the Pricing Schedule
     * @return
     *      returns the Pricing schedule of the any arbitrary matching record based on
     *      the criteria, 'null' if no records match.
     */
    public static String getPricingSchedule(CRD__c crd) {
        
        /* get all the Y_Schedule_Pricing_Override records based on initial conditions matching:
           Platform_Indicator__c, Control_Group__c and crd.Effective_Start_Date__c.
           Map returned is 'null' if no records are fetched. */
        Map < Id, Y_Schedule_Pricing_Override__c > YScheduleInitialMap = new Map < Id, Y_Schedule_Pricing_Override__c >();
            System.debug('##############1221');
            String controlGroup;
            String leadingChar = NUMZERO;
            if(crd.Full_Control_Group__r.CSAP_Control_ID__c!= Null){
                controlGroup = crd.Full_Control_Group__r.CSAP_Control_ID__c;
            }else{
                controlGroup = crd.Control__c;
            }
            //Added by Amit for request 5391           
                controlGroup = calculateControl(controlGroup);
            //Ends
        YScheduleInitialMap = new Map < Id, Y_Schedule_Pricing_Override__c > ([SELECT Name, Account_Plan__c, Control_Group__c, Effective_Date__c, Plan_Summary_Company_Code__c, Platform_Indicator__c, Price_Schedule__c, Suffix_Location__c, Termination_Date__c, CRD_Indicator__c
            FROM Y_Schedule_Pricing_Override__c
            WHERE Platform_Indicator__c = : crd.Platform_Information__c
            AND Control_Group__c = : controlGroup
            AND Effective_Date__c <= : crd.Effective_Start_Date__c AND Termination_Date__c >= : crd.Effective_Start_Date__c
            AND CRD_Indicator__c = :ALPHABETC]);
        Y_Schedule_Pricing_Override__c filterCriteria;
system.debug(YScheduleInitialMap);
        /* Filter map based on 'Plan Information' */
        Map < Id, Y_Schedule_Pricing_Override__c > planInfoFilteredMap;
        filterCriteria = new Y_Schedule_Pricing_Override__c();
        filterCriteria.Plan_Summary_Company_Code__c = crd.Full_Control_Group__r.CSAP_Plan_ID__c;
        planInfoFilteredMap = YSchedulePricingOverrideFilter(YScheduleInitialMap, filterCriteria);
system.debug(planInfoFilteredMap );
        /* Filter map based on 'Suffix Location' */
        Map < Id, Y_Schedule_Pricing_Override__c > suffixLocFilteredMap;
        filterCriteria = new Y_Schedule_Pricing_Override__c();
        filterCriteria.Suffix_Location__c = crd.Full_Control_Group__r.CSAP_Suffix_ID__c;
        suffixLocFilteredMap = YSchedulePricingOverrideFilter(planInfoFilteredMap, filterCriteria);
system.debug(suffixLocFilteredMap);
        /* Filter map based on 'Account Plan' */
        Map < Id, Y_Schedule_Pricing_Override__c > accountPlanFilteredMap;
        filterCriteria = new Y_Schedule_Pricing_Override__c();
        filterCriteria.Account_Plan__c = crd.Full_Control_Group__r.CSAP_Account_ID__c;
        accountPlanFilteredMap = YSchedulePricingOverrideFilter(suffixLocFilteredMap, filterCriteria);
system.debug(accountPlanFilteredMap );
        if (accountPlanFilteredMap != null) return accountPlanFilteredMap.values()[0].Price_Schedule__c;
        return null;
    }

    /*
     * Method responsible for filtering out 'overrideMap' of 'Y_Schedule_Pricing_Override'
     * records based on criteria provided in 'filterCriteria'
     *
     * @pre-condition
     *      Only SINGLE field of 'filterCriteria' should be populated
     * @calledBy    getPricingSchedule()
     * @param       overrideMap
     *      map on which filtering is to be done
     * @param       filterCriteria
     *      record of ' Y_Schedule_Pricing_Override'. You need to set the fields
     *      of filterCriteria based on which the filtering would be done AND
     *      leave other fields 'null' which needs to be ignored.
     * @return
     *      map of 'Y_Schedule_Pricing_Override' if records are present,
     *      'null' otherwise.
     */
    public static Map < Id, Y_Schedule_Pricing_Override__c > YSchedulePricingOverrideFilter(Map < Id, Y_Schedule_Pricing_Override__c > overrideMap, Y_Schedule_Pricing_Override__c filterCriteria) {

        if (overrideMap == null || overrideMap.size() == 0) return null;

        /* map containing 'Y_Schedule_Pricing_Override' records MATCHING the criteria */
        Map < Id, Y_Schedule_Pricing_Override__c > matchMap = new Map < Id, Y_Schedule_Pricing_Override__c > ();

        /* map containing 'Y_Schedule_Pricing_Override' records NOT matching the criteria */
        Map < Id, Y_Schedule_Pricing_Override__c > wildcardMap = new Map < Id, Y_Schedule_Pricing_Override__c > ();

        /* the below for loop takes one 'Y_Schedule_Pricing_Override' at a time
           and matches its fields with the non-null fields of 'filterCriteria'.
           The flag 'match' is used to track if filter criteria is satisfied (match = true)
           or not satisfied (match = false) */
        for (Id overrideId: overrideMap.keySet()) {
            Boolean match = true;
            Y_Schedule_Pricing_Override__c pricingOverride = overrideMap.get(overrideId);

            if (match && filterCriteria.Account_Plan__c != null && filterCriteria.Account_Plan__c != pricingOverride.Account_Plan__c) match = false;
            else if (match && filterCriteria.Suffix_Location__c != null && filterCriteria.Suffix_Location__c != pricingOverride.Suffix_Location__c) match = false;
            else if (match && filterCriteria.Plan_Summary_Company_Code__c != null && filterCriteria.Plan_Summary_Company_Code__c != pricingOverride.Plan_Summary_Company_Code__c) match = false;

            if (match) matchMap.put(pricingOverride.Id, pricingOverride);
            else {
                if (pricingOverride.Account_Plan__c != null && pricingOverride.Account_Plan__c == STAR) wildcardMap.put(pricingOverride.Id, pricingOverride);
                else if (pricingOverride.Suffix_Location__c != null && pricingOverride.Suffix_Location__c == STAR) wildcardMap.put(pricingOverride.Id, pricingOverride);
                else if (pricingOverride.Plan_Summary_Company_Code__c != null && pricingOverride.Plan_Summary_Company_Code__c == STAR) wildcardMap.put(pricingOverride.Id, pricingOverride);
            }
        }

        /* If any record is matching then return map of those records else return all the other records
           with '*' in the criteria field, else return 'null' */
        if (matchMap.size() != 0) return matchMap;
        else if (wildcardMap.size() != 0) return wildcardMap;
        else return null;
    }

    /**
     * Method to save the errors while saving the list of 'Batch_Logger'.
     *
     * @requirement Pers
     * @author      mistry, rakesh - 'inspire'
     * @date        2013-04-04
     * @param       batchLoggerList
     *      List of 'Batch_Logger' object whose save result is to be logged
     * @param       saveResultList
     *      List of 'Database.Saveresult' returned after saving 'batchLoggerList'
     * @return
     *      'true' if error logs get saved successfully
     *      'false' otherwise
     */
    public static Boolean logSaveresult(List < Batch_Logger__c > batchLoggerList, List < Database.Saveresult > saveResultList) {

        List < Batch_Logger__c > errBatchLoggerList = new List < Batch_Logger__c > ();
        for (Integer i = 0; i < saveResultList.size(); ++i) {
            Database.Saveresult sr = saveResultList[i];
            if (!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];
                Batch_Logger__c bl = new Batch_Logger__c();
                bl.Has_Error__c = true;
                bl.Pers_Data_Storage__c = batchLoggerList[i].Pers_Data_Storage__c;
                bl.Description__c = err.getMessage();
                errBatchLoggerList.add(bl);
            }
        }

        try {
            insert errBatchLoggerList;
            return true;
        } catch (Exception ex) {
            return false;
        }

        return false;
    }

    /**
     * Method that takes a Batch_Logger record and an Exception while making a callout, marks
     * the Batch_Logger as Error and its description as the exception. 
     *
     * @requirement Pers
     * @author      mistry, rakesh - 'inspire'
     * @date        2013-04-05
     * @param       batchLogger
     *      'Batch_Logger' object on which the exception was raised
     * @param       ex
     *      Exception while handling batchLogger
     * @return
     *      same BatchLogger with hasError set to 'true' and its description as the Exception message
     */
    public static Batch_Logger__c logBatchLoggerError(Batch_Logger__c batchLogger, Exception ex) {
        batchLogger.Has_AI_Error__c = true;
        batchLogger.Has_Error__c = true;
        batchLogger.Description__c = MESSAGE + ex.getMessage() + STACKTRACE + ex.getStackTraceString();

        return batchLogger;
    }

    /**
     * Method to save the errors while saving the list of 'CRD'.
     *
     * @requirement Pers
     * @author      mistry, rakesh - 'inspire'
     * @date        2013-04-05
     * @param       crdList
     *      Map of <Pers_Data_Storage.TPID, Pers_Data_Storage>
     * @param       tpidPersMap
     *      Map of <Pers_Data_Storage.TPID, Pers_Data_Storage>
     * @param       saveResultList
     *      List of 'Database.Saveresult' returned after saving 'crdList'
     * @return
     *      'true' if error logs get saved successfully
     *      'false' otherwise
     */
    public static Boolean logSaveresult(List < CRD__c > crdList, Map < String, Pers_Data_Storage__c > tpidPersMap, List < Database.Saveresult > saveResultList) {
        List < Batch_Logger__c > errBatchLoggerList = new List < Batch_Logger__c > ();
        for (Integer i = 0; i < saveResultList.size(); ++i) {
            Database.Saveresult sr = saveResultList[i];
            if (!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];
                Batch_Logger__c bl = new Batch_Logger__c();
                bl.Has_Error__c = true;
                bl.Pers_Data_Storage__c = tpidPersMap.get(crdList[i].TP_ID__c).Id;
                bl.Description__c = err.getMessage();
                errBatchLoggerList.add(bl);
            }
        }

        try {
            insert errBatchLoggerList;
            return true;
        } catch (Exception ex) {
            return false;
        }

        return false;
    }
     /**
     * Method to save the errors while updating Crd with business rules'.
     *
     * @requirement Pers
     * @author      Abhay Arora
     * @date        2013-06-26
     * @param       crdList
     *      Set of <id>
     * @param       IsError
     *     Boolean to identify the type of update
     * @return
     *      'Void' Nothing is being returned from this method
     */   
    public static void saveBusinessRuleResults(list<Drug_Coverage__c> listDrugCoverageRecords,list < Database.Saveresult > saveResultList){
        
       list<Batch_Logger__c> lstBatchlogger = new list<Batch_Logger__c>();
       list<Batch_Logger__c> listBatchLoggerUpdated = new list<Batch_Logger__c>();
       map<String,String> mapDrugCoverage2CrdID = new map<String,String>();
       map<String,Batch_Logger__c> mapCRDID2BatchLogger = new map<String,Batch_Logger__c>();              
       for(Drug_Coverage__c DCR : listDrugCoverageRecords){
         mapDrugCoverage2CrdID.put(DCR.id,DCR.CRD_ID__c);
       }
       
       if(mapDrugCoverage2CrdID!=null && mapDrugCoverage2CrdID.size()>0){
           lstBatchlogger= [select id,CRD__c,Cloned_CRD_ID__c,Description__c,Updated_By_Business_Rule__c from Batch_Logger__c where CRD__c in :mapDrugCoverage2CrdID.values() or Cloned_CRD_ID__c in :mapDrugCoverage2CrdID.values()];
       }
       if(lstBatchlogger!=null && lstBatchlogger.size()>0){
          for(Batch_Logger__c log:lstBatchlogger){
            mapCRDID2BatchLogger.put(log.Cloned_CRD_ID__c,log);
          }
       }         
       
        for (Integer i = 0; i < saveResultList.size(); ++i) {
            Database.Saveresult sr = saveResultList[i];
            Batch_Logger__c b2= new Batch_Logger__c();
            if(sr.getId()!=null){                           
            b2=mapCRDID2BatchLogger.get(mapDrugCoverage2CrdID.get(sr.getId()));            
            b2.Updated_By_Business_Rule__c = true;
            }  
        }   
        update lstBatchlogger;  
   }
   //Richa added the new method for Req-5003 to update the MAC At Mail Applies field on CRD
    public void setMACatMailApplies(CRD__c crd, list<Copay_Tier__c> copayTier, list<Accumulations__c> acumltn){
       /*if(crd.Integrate_with_Medical__c != null){  Richa commented on 17/9 temporarily
       try{
            String mac = null;
            Boolean checkAcumltn = false;
            mac = [Select MAC_at_Mail_Applies__c from Provision_32_Crosswalk__c where Provision_32_LineValue_Description__c = :crd.Integrate_with_Medical__c LIMIT 1][0].MAC_at_Mail_Applies__c;
            if(mac == 'Yes'){
                crd.Mac_at_Mail_Applies__c = 'Yes';
            }else if(copayTier.isempty()){
                    crd.Mac_at_Mail_Applies__c = 'No';
            }else if (!copayTier.isempty()){
                for(Copay_Tier__c ct:copayTier){
                    if(ct.Tier_Type__c == 'Generic (SSG & MSG)' || ct.Tier_Type__c == 'Single Source Generic (SSG)' || 
                       ct.Tier_Type__c == 'Multi Source Generic (MSG)' || ct.Tier_Type__c == 'Non-Preferred Generics' || 
                       ct.Tier_Type__c == 'All Drugs' || ct.Tier_Type__c == 'Preferred Generics' || 
                       ct.Tier_Type__c == 'Non-Preferred Brand & Generic (all)' || ct.Tier_Type__c == 'Non-Preferred Generic, Brand and Specialty'){
                            if(ct.Percent__c != null && ct.Percent__c > 0){
                                crd.Mac_at_Mail_Applies__c = 'Yes';
                                break;
                            }else{
                                if(ct.Dollar_Amount__c > 0){
                                    checkAcumltn = true;
                                    break;
                                }
                                else
                                    crd.Mac_at_Mail_Applies__c = 'No';
                            }
                            
                    }else{
                        crd.Mac_at_Mail_Applies__c = 'No';
                     }
                }
            }
            if(checkAcumltn && !acumltn.isempty()){
                for(Accumulations__c acm:acumltn){  
                    if(acm.Deductible_Amount__c > 0 || acm.What_is_the_In_Network_Deductible_Amount__c > 0 || acm.What_is_the_OON_Deductible_Amount__c > 0){
                        crd.Mac_at_Mail_Applies__c = 'Yes';
                        break;  
                    }else
                        crd.Mac_at_Mail_Applies__c = 'No';
                } 
                
            } else if(checkAcumltn && acumltn.isempty()){crd.Mac_at_Mail_Applies__c = 'No';}  
        }catch(exception e){
        }
       }*/
     }
     /*
     * Method to calculate Control Plan in case control is less than 7 digits for CRD Builder
       Added by Amit on 5 jan, 2015
     */
     public static String calculateControl(String Control){
        String correctedControl;
        String leadingZero = NUMZERO;
        if(Control!= Null){
            if(Control.length() == 7){
                correctedControl = Control;
            }else if(Control.length() == 6){
                correctedControl = leadingZero + Control;
            }else if(Control.length() == 5){
                correctedControl = leadingZero+ leadingZero + Control;
            }else if(Control.length() == 4){
                correctedControl = leadingZero + leadingZero + leadingZero + Control;
            }else if(Control.length() == 3){
                correctedControl = leadingZero + leadingZero + leadingZero + leadingZero + Control;
            }else if(Control.length() == 2){
                correctedControl = leadingZero + leadingZero + leadingZero + leadingZero + leadingZero + Control;
            }else if(Control.length() == 1){
                correctedControl = leadingZero + leadingZero + leadingZero + leadingZero + leadingZero + leadingZero + Control;
            }
        }else{
            correctedControl = BLANKVALUE;
        }
        System.debug(correctedControl);
        return correctedControl;
    }
    
    /*Method for Checking CRD Management User */
    public void checkManagementUser(){
        String managementUserID = UserInfo.getUserId();
        List<string> managementGroupUserIds = new List<string>();
        List<group> managementGroupCheck = [Select m.Id,m.Name from Group m where Name = :CRDMANAGEMENTUSER LIMIT 1];
        string managementgroupID = managementGroupCheck[0].id;
        
        for(GroupMember gm : [Select m.UserOrGroupId, m.Id, m.GroupId From GroupMember m where GroupId =: managementgroupID ]){
            managementGroupUserIds.add(string.valueOf(gm.UserOrGroupId));
        }
        for(string s : managementGroupUserIds){
            if(s.contains(managementUserID)){
                managementUser = TRUESTRING;
            }
        }
        
    }
    /**
     * Method :- getNarrowNetworkYschedule()
     * Description - This method calculated Yschedule for NarrowNetwork
    **/
    public static List<string> getNarrowNetworkYschedule(CRD__c crd, Partial_Control_Group__c pcgRec){
        String ySchedule;
        //Added By Nitish Request 6902
        decimal provNum;
        decimal lineNum;
        string fundingType;
        string erb;
        string discountCard;
        string narrowYsch;
        if(crd.Insured_Type__c != null && crd.Insured_Type__c.equalsIgnoreCase(SELFINSURED)){
            fundingType = ALPHABETN;
        }
        else if(crd.Insured_Type__c != null && crd.Insured_Type__c.equalsIgnoreCase(FULLYINSURED)){
            fundingType = ALPHABETR;
        }
        else if(crd.Insured_Type__c != null && crd.Insured_Type__c.equalsIgnoreCase(SPLITFUNDED)){
            fundingType = ALPHABETS;
        }
        if(pcgRec!=null && (pcgRec.Rating_ERB__c == ALPHABETR || pcgRec.Rating_ERB__c == NUMONE )){
            erb = ALPHABETR;
        }else{
            erb = ALPHABETN;
        }
        if(crd.Plan_Platform__c.equalsIgnoreCase(DISCOUNTCARDVAR)){
            discountCard = ALPHABETY;
        }
        else{
            discountCard = ALPHABETN;
        }
        if(crd.CRD_Automated__c){
            for(Pers_Full_Report__c pfr : [select WS_LV_NO__c,WS_PROV_NUM__c from Pers_Full_Report__c where CRD__c =:crd.id AND WS_PROV_NUM__c =: 73 limit 1000]){
                provNum = pfr.WS_PROV_NUM__c;
                lineNum = pfr.WS_LV_NO__c;
            }
            if(provNum == 73){
                
                system.debug('%%%%$$$$ ');
                for(Y_Schedule_Pricing_Override__c ySCH : [select Name,Discount_Card__c,ERB__c,Price_Schedule__c,Funding_Type__c,Sub_Segment__c,Retail_Network__c from Y_Schedule_Pricing_Override__c]){
                    if(ySCH.Discount_Card__c != null && ySCH.ERB__c != null && ySCH.Funding_Type__c != null && ySCH.Retail_Network__c != null && ySCH.Sub_Segment__c != null && 
                        ySCH.Discount_Card__c.equalsIgnoreCase(discountCard) && ySCH.ERB__c.equalsIgnoreCase(erb) && ySCH.Funding_Type__c.equalsIgnoreCase(fundingType) &&
                        ySCH.Retail_Network__c == lineNum && ySCH.Sub_Segment__c.equalsIgnoreCase(crd.Sub_Segment__c)){
                        narrowYsch = ySCH.Price_Schedule__c; 
                        system.debug('****YSCHNAME**** '+ ySCH.Name);                 
                    }
                }
            }
        }
        if(narrowYsch != null){
        system.debug('####YSCH#### ' + narrowYsch);
        return new List<string>{narrowYsch,Y6};
        }
        else{
            return null;
        }

    }
}