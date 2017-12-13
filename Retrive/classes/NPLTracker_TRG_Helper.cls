public class NPLTracker_TRG_Helper {
    //=============================
   // Meta Information
   //=============================  
   // Namespace or Enhancement: Precert project
   // Description:helper class for NPLMasterTrigger on object:NPL_PA_Tracker__c. 
   // 			  As of 7/21/17- calculates Fax_Received__c,Time_to_Outreach__c,Due_Date__c,Total_Age_in_Business_Hours_Number__c
   // Called by: NPLMasterTrigger - Trigger on NPL_PA_Tracker__c
  
   /*==================================================================================
   Version                  Author      Date                                Reason
   1.0                      Saraag      July21,2017                         Created 
   ====================================================================================*/
    
    //=============================
    // CLASS VARIABLES  
    //=============================
    //DataType                                                Name      Description
    @TestVisible BusinessHours                                b;        //Stores NPL business hours after querying
    integer												      dayHours;	//number hours in a business day.
    //=============================
    // MEMBER METHODS  
    //=============================
  
   // Method Name:updatNPLT
   // Arguments:
   // Return:
   // Description:
     @TestVisible public void updatNPLT(List<NPL_PA_Tracker__c> NPLTList){
        
        b=[SELECT Id,MondayStartTime,MondayEndTime FROM BusinessHours WHERE Name='NPL'];
        dayHours=b.MondayEndTime.hour()-b.MondayStartTime.hour();
        set<id> cstateIds=new set<id>();
        for(NPL_PA_Tracker__c nprec:NPLTList){
            if(nprec.Fax_Received_Date_Time__c!=NULL&&nprec.Fax_Received_Date_Time__c!='')
            	cstateIds.add(nprec.Controlling_State_LU__c);
        }
         
         Map<Id,Controlling_State__c> cstateMap = new Map<Id,Controlling_State__c>([select Id,Add_time_Outreach_Received_Urgent__c ,Add_time_Outreach_Received_Period_Urgent__c ,Add_time_Outreach_Received_Period__c ,Add_time_Outreach_Received__c ,Overall_TAT_Period_Urgent__c,Overall_TAT_Period__c,Overall_TAT_Urgent__c,Overall_TAT__c,Time_to_Outreach_Urgent__c,Time_to_Outreach__c,Time_to_Outreach_Period_Urgent__c,Time_to_Outreach_Period__c from Controlling_State__c where Id IN :cstateIds]);
        
        for(NPL_PA_Tracker__c nprec:NPLTList){

                Controlling_State__c  cstate=cstateMap.get(nprec.Controlling_State_LU__c);
                if(cstate!=null){
                	nprec.Fax_Received__c=getFaxReceived(nprec.Fax_Received_Date_Time__c );
                	nprec.Total_Age_in_Business_Hours_Number__c=getTotalAgeinBH(nprec); 
                    nprec.Time_to_Outreach__c=getTTO(nprec,cstate);
                    nprec.Due_Date__c=getDueDate(nprec,cstate);
                }
        }
    } //END: updatNPLT
    
   // Method Name:getTotalAgeinBH
   // Invocation: through updatNPLT()
   // Arguments:NPL PA Tracker record in context
   // Return: decimal hours 
   // Description:code for Total_Age_In_Business_Hours__c
   
    @TestVisible private decimal getTotalAgeinBH(NPL_PA_Tracker__c npt) {
         long result;
        if(npt.Complete_Status_Selected__c!=NULL){
              result=BusinessHours.diff(b.Id,npt.Fax_Received__c,npt.Complete_Status_Selected__c);
        }else{
              result=BusinessHours.diff(b.Id,system.now(),npt.Fax_Received__c);
        }
        
        if(result<0)
            result=result*-1;
        
        system.debug('total age in business hours:'+result);
        return result/(1000.0*60.0*60.0); //changing to hours.
    }//END : getTotalAgeinBH   
    
   // Method Name:updatNPLT
   // Invocation: through updatNPLT()
   // Arguments:fax Received time in String, Assumes the string is stored in EST.MM/DD/YYYY HH:MM:SS
   // Return: fax received datetime in GMT.
   // Description: code for FaxReceived
   
    @TestVisible private dateTime getFaxReceived(string faxRec){
      //Know issues:  ssue 1: When DST starts, code will incorrectly translates  between 2am-7am on that day by adding +1hr. 
      //When DST ends, code will incorrectly translates 2am-6am on that day by incorrectly removing 1hr.
	  //When clock moves to 1AM, incorrectly translates time between 1am-2am. 
	  //System cannot tell the difference between as an example 1:30 am before clock moved back vs 1:30am after.       
		
        Timezone tz = Timezone.getTimeZone('America/New_York');
        string s=faxRec;
        string month=s.left(2);
        string day=s.mid(3,2);
        string year=s.mid(6,4);       
        string stringDate = year + '-' + month + '-' + day + ' ' + s.right(9);      
        Datetime dt=Datetime.valueofGMT(stringDate); //string is actually in EST. 
        integer offs=tz.getOffset(dt)*-1; //reversing the offset.
        dt=dt.addSeconds(offs/1000);//converting into GMT.
		return dt;
    }//END: getFaxReceived
    
   // Method Name:getTTO
   // Invocation: through updatNPLT()
   // Arguments: NPL PA tracker in context and controlling state connected to the record.
   // Return: total time to outreach as Date time in GMT.
   // Description: calculates time to outreach

    @TestVisible private DateTime getTTO(NPL_PA_Tracker__c NPT,Controlling_State__c cstate){
    If(NPT.STAT_or_Urgent__c) //urgent
        return addPeriod(Integer.valueOf(cstate.Time_to_Outreach_Urgent__c),NPT.Fax_Received__c,cstate.Time_to_Outreach_Period_Urgent__c);
    else //not urgent
        return addPeriod(Integer.valueOf(cstate.Time_to_Outreach__c),NPT.Fax_Received__c,cstate.Time_to_Outreach_Period__c);
    }//END: getTTO

   // Method Name:getDueDate
   // Invocation: through updatNPLT()
   // Arguments:NPL PA tracker in context and controlling state connected to the record
   // Return: calculates due date as datetime in GMT.
   // Description: calcualtes due date.

    @TestVisible private dateTime getDueDate(NPL_PA_Tracker__c NPT,Controlling_State__c cstate){
        If(NPT.STAT_or_Urgent__c){ //urgent
             DateTime temp1=addPeriod(Integer.valueOf(cstate.Overall_TAT_Urgent__c),NPT.Fax_Received__c,cstate.Overall_TAT_Period_Urgent__c);  	   
             
            if(NPT.Outbound_Call__c) //add outreach urgent time
                return addPeriod(Integer.valueOf(cstate.Add_time_Outreach_Received_Urgent__c),temp1,cstate.Add_time_Outreach_Received_Period_Urgent__c);  	   
             else //outbound false, do not add outreach urgent
                 return temp1;
        }else{ //not urgent
             DateTime temp1=addPeriod(Integer.valueOf(cstate.Overall_TAT__c),NPT.Fax_Received__c,cstate.Overall_TAT_Period__c);
             
             if(NPT.Outbound_Call__c) //add outreach time
                return addPeriod(Integer.valueOf(cstate.Add_time_Outreach_Received__c),NPT.Fax_Received__c,cstate.Add_time_Outreach_Received_Period__c);
             else //outbound false, do not add outreach
                 return temp1;
        }
    }//END: getDueDate
    
    
   // Method Name:addPeriod
   // Invocation: multiple. 3rd level.
   // Arguments: periodselected identifies the type of offset (hours, days, businesshours etc). Offset is the actual
   // value. Base DT is the original datetime.
   // Return: adds offset as indicated by periodselected and returns the new original date time value.
   // Description:utility method to add offset by period selected

    @TestVisible private DateTime addPeriod(Integer offset,Datetime BaseDT,String PeriodSelected){
        
        Datetime TAT;
        If(PeriodSelected=='Hours')
            TAT=BaseDT.addHours(offset);
        else If(PeriodSelected=='Calendar Days')
            TAT=BaseDT.addDays(offset);
        else If(PeriodSelected=='Business Hours'){
            TAT=BusinessHours.addGMT(b.id,BaseDT,offset*60 * 60 * 1000);
        }
        else If(PeriodSelected=='Business Days'){
            TAT=BusinessHours.nextStartDate(b.id,BaseDT.addDays(offset));
        }
        return TAT;
    } //END: addPeriod
    
    
    
}