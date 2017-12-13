@isTest(SeeAllData=true)
public class NPLTracker_TRG_Helper_TEST {
//TEST CLASS FOR NPLTracker_TRG_Helper which is a helper class for NPLMasterTrigger a trigger on NPL PA Tracker object.
//verion 1.0 
    static BusinessHours    		b;
    static NPL_PA_Tracker__c		npl;
	static Controlling_State__c	    cstate;
    
    static private void datagenerator(){
        b=[SELECT Id FROM BusinessHours WHERE Name='NPL'];
        //create NPL_PA_Tracker__c, create Controlling_State__c
        npl=new NPL_PA_Tracker__c();
        cstate=new Controlling_State__c();
        
    }
    
    //testing add period method
    static testMethod void Test_addPeriodTest(){
        NPLTracker_TRG_Helper_TEST.datagenerator();
        NPLTracker_TRG_Helper obj=new NPLTracker_TRG_Helper();
        dateTime dt=system.now();
        obj.b=b;
        system.assertEquals(obj.addPeriod(3,dt,'Hours'),dt.addHours(3));
        system.assertEquals(obj.addPeriod(3,dt,'Calendar Days'),dt.addDays(3));
        system.assertEquals(obj.addPeriod(3,dt,'Business Hours'),BusinessHours.addGMT(b.id,dt,3*60 * 60 * 1000));
        system.assertEquals(obj.addPeriod(3,dt,'Business Days'),BusinessHours.nextStartDate(b.id,dt.addDays(3)));

    }
	
    
    static testMethod void Test_getFaxReceivedTest(){

        string estDateTime='07/20/2017 01:00:00';
        NPLTracker_TRG_Helper obj=new NPLTracker_TRG_Helper();
        system.assert(obj.getFaxReceived(estDateTime)!=null);
    }

    
    static testMethod void Test_getTTO(){
      // Arguments: NPL PA tracker in context and controlling state connected to the record.
      // Return: total time to outreach as Date time in GMT.
      // 
      NPLTracker_TRG_Helper obj=new NPLTracker_TRG_Helper();
      NPLTracker_TRG_Helper_TEST.datagenerator();
      npl.Fax_Received__c=obj.getFaxReceived('07/20/2017 01:00:00');

      //TEST CASE 1: urgent
      		npl.STAT_or_Urgent__c=true;
            cstate.Time_to_Outreach_Period_Urgent__c='Hours';
        	cstate.Time_to_Outreach_Urgent__c=2;
        	system.assertEquals(obj.getTTO(npl,cstate),DateTime.valueOf('2017-07-20 03:00:00'));
      //TEST CASE 2: non-urgent
            npl.STAT_or_Urgent__c=false;
            cstate.Time_to_Outreach_Period__c='Hours';
        	cstate.Time_to_Outreach__c=3;
        	system.assertEquals(obj.getTTO(npl,cstate),DateTime.valueOf('2017-07-20 04:00:00'));
      //TEST CASE 3: negative 
     	    npl.STAT_or_Urgent__c=true;
            cstate.Time_to_Outreach_Period_Urgent__c='';
            cstate.Time_to_Outreach_Urgent__c=2;
        	system.assertEquals(obj.getTTO(npl,cstate),null);
        
    }
   
    static testMethod void Test_getDueDate(){
        // Arguments:NPL PA tracker in context and controlling state connected to the record
  		 // Return: calculates due date as datetime in GMT.
          NPLTracker_TRG_Helper obj=new NPLTracker_TRG_Helper();
          NPLTracker_TRG_Helper_TEST.datagenerator();
          npl.Fax_Received__c=obj.getFaxReceived('07/20/2017 01:00:00');
        
        //TEST CASE 1: urgent and outbound
      		system.debug('T1:'+npl.Fax_Received__c);
        	npl.STAT_or_Urgent__c=true;
            npl.Outbound_Call__c=true;	
			cstate.Overall_TAT_Period_Urgent__c='Hours';
        	cstate.Overall_TAT_Urgent__c=3;   
        	cstate.Add_time_Outreach_Received_Urgent__c=2;
        	cstate.Add_time_Outreach_Received_Period_Urgent__c='Hours';
        	system.assertEquals(obj.getDueDate(npl,cstate),DateTime.valueOf('2017-07-20 06:00:00'));
        
        //TEST CASE 2: urgent and non-outbound
        	system.debug('T2:'+npl.Fax_Received__c);
      		npl.STAT_or_Urgent__c=true;
        	npl.Outbound_Call__c=false;	
			cstate.Overall_TAT_Period_Urgent__c='Hours';
        	cstate.Overall_TAT_Urgent__c=3;            
        	system.assertEquals(obj.getDueDate(npl,cstate),DateTime.valueOf('2017-07-20 04:00:00'));

        
      //TEST CASE 3: non-urgent and outbound
      		system.debug('T3:'+npl.Fax_Received__c);
            npl.STAT_or_Urgent__c=false;
            npl.Outbound_Call__c=true;	
            cstate.Overall_TAT_Period__c='Hours';
        	cstate.Overall_TAT__c=3;
        	cstate.Add_time_Outreach_Received__c=2;
        	cstate.Add_time_Outreach_Received_Period__c='Hours';
        	dateTime dtresult=obj.getDueDate(npl,cstate);
        	system.assertEquals(dtresult,DateTime.valueOf('2017-07-20 03:00:00'));
        
      //TEST CASE 4: non-urgent and non-outbound
      		system.debug('T4:'+npl.Fax_Received__c);
        	npl.STAT_or_Urgent__c=false;
            npl.Outbound_Call__c=false;	
            cstate.Overall_TAT_Period__c='Hours';
        	cstate.Overall_TAT__c=3;
        	system.assertEquals(obj.getDueDate(npl,cstate),DateTime.valueOf('2017-07-20 04:00:00'));

        
      //TEST CASE 3: negative 
			npl.STAT_or_Urgent__c=true;
        	npl.Outbound_Call__c=false;	
			cstate.Overall_TAT_Period_Urgent__c='';
        	cstate.Overall_TAT_Urgent__c=3;            
        	system.assertEquals(obj.getDueDate(npl,cstate),null);
        
    }
    
    static testMethod void Test_getTotalAgeinBH(){
        // Arguments:NPL PA Tracker record in context
  	    // Return: decimal hours 
          NPLTracker_TRG_Helper obj=new NPLTracker_TRG_Helper();
          NPLTracker_TRG_Helper_TEST.datagenerator();
          npl.Fax_Received__c=obj.getFaxReceived('07/20/2017 11:00:00');
          obj.b=b;
      //TEST CASE 1: complete status 
          npl.Complete_Status_Selected__c=DateTime.valueOf('2017-07-20 12:00:00');
          decimal result=obj.getTotalAgeinBH(npl);
          system.assertEquals(result, 1);
     //TEST CASE 2: non-complete status
          npl.Complete_Status_Selected__c=null;
          npl.Fax_Received__c=system.now().addHours(2);
          result=obj.getTotalAgeinBH(npl).round(system.roundingMode.CEILING);
          //system.assertEquals(result, 2);
          decimal expectedValue=BusinessHours.diff(b.Id,system.now(),system.now().addHours(2))/(1000.0*60.0*60.0);
          expectedValue=expectedValue.round(system.roundingMode.CEILING);
          system.assertEquals(expectedValue, result);
    }
    
 static testMethod void Test_updatNPLT(){
        NPLTracker_TRG_Helper obj=new NPLTracker_TRG_Helper();
        NPLTracker_TRG_Helper_TEST.datagenerator();

        obj.b=b;
         /*  cstate.Time_to_Outreach_Urgent__c=2;
        cstate.Time_to_Outreach_Period__c='Hours';
        cstate.Time_to_Outreach__c=3;
        cstate.Time_to_Outreach_Period_Urgent__c='';
        cstate.Overall_TAT_Period_Urgent__c='Hours';
        cstate.Overall_TAT_Urgent__c=3;
        cstate.Add_time_Outreach_Received_Urgent__c=2;
        cstate.Add_time_Outreach_Received_Period_Urgent__c='Hours';
        cstate.Overall_TAT_Period__c='Hours';
        cstate.Overall_TAT__c=3;
        cstate.Add_time_Outreach_Received__c=2;
        cstate.Add_time_Outreach_Received_Period__c='Hours';
        cstate.Overall_TAT_Period_Urgent__c='Hours';
        insert cstate; */
        
    	npl.Fax_Received_Date_Time__c='07/20/2017 11:00:00';
        npl.STAT_or_Urgent__c=false;
        npl.Outbound_Call__c=false;
        
        List<NPL_PA_Tracker__c> npllist=new list<NPL_PA_Tracker__c>();
     	npllist.add(npl);
        obj.updatNPLT(npllist);
        
    }    
    
    
}