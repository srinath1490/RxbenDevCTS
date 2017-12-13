@isTest
private class TEST_BCTNotificationService{
    static testMethod void testBlankResultData(){
       
          
          BCTNotificationService.RxPlanDetail rxDetail=new BCTNotificationService.RxPlanDetail('','','','');
          list<BCTNotificationService.RxPlanDetail> lstDetail=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail.add(rxDetail);
          BCTNotificationService.RxPlanBlock rxBlock=new BCTNotificationService.RxPlanBlock(lstDetail,lstDetail);
        
          BCTNotificationService.traditionalControlNumberPlanSummary tradPlanSummary=new BCTNotificationService.traditionalControlNumberPlanSummary(0,'');
          list<BCTNotificationService.traditionalControlNumberPlanSummary> lstControlPlanSummary=new list<BCTNotificationService.traditionalControlNumberPlanSummary>();
          
          BCTNotificationService.custmoHierarchy hmoHierarcy=new BCTNotificationService.custmoHierarchy('','','','');
         
          
          BCTNotificationService.tradHierarchy tradHierarcy=new BCTNotificationService.tradHierarchy(0,0,0,'');
         
           
          CRD__c testCrd=new CRD__c();
          testCrd.TP_ID__c='testTPId';
          testCrd.Pricing_Schedule__c='Y4';
          insert testCrd;
          BCTNotificationService.ReturnData testdate = new BCTNotificationService.ReturnData(); //Richa added since BCTNotificationService.BctNotification(null) is not possible
          boolean result1 = BCTNotificationService.BctNotification(testdate);        
          BCTNotificationService.ReturnData rData= new BCTNotificationService.ReturnData();
          boolean result2 = BCTNotificationService.BctNotification(rData);
          BCTNotificationService.ReturnData rData1= new BCTNotificationService.ReturnData();
          boolean result3 = BCTNotificationService.BctNotification(rData1);          
          BCTNotificationService.ReturnData rData2= new BCTNotificationService.ReturnData();
          boolean result4 = BCTNotificationService.BctNotification(rData2);          
          BCTNotificationService.ReturnData rData3= new BCTNotificationService.ReturnData();
          boolean result5 = BCTNotificationService.BctNotification(rData3);                                     
          
          BCTNotificationService.ReturnData rData4= new BCTNotificationService.ReturnData();
          boolean result6 = BCTNotificationService.BctNotification(rData4);  
            
    }
  
    static testMethod void testTraditionalResultData(){
          boolean result;
          BCTNotificationService.traditionalControlNumberPlanSummary tradPlanSummary=new BCTNotificationService.traditionalControlNumberPlanSummary(0,'');
          list<BCTNotificationService.traditionalControlNumberPlanSummary> lstControlPlanSummary=new list<BCTNotificationService.traditionalControlNumberPlanSummary>();
          
          BCTNotificationService.custmoHierarchy hmoHierarcy=new BCTNotificationService.custmoHierarchy('','','','');
          BCTNotificationService.tradHierarchy tradHierarcy=new BCTNotificationService.tradHierarchy(0,0,0,'');
           
          CRD__c testCrd=new CRD__c();
          testCrd.TP_ID__c='testTPId';
          testCrd.Pricing_Schedule__c='Y4';
          insert testCrd;
        
          BCTNotificationService.RxPlanDetail rxDetail1=new BCTNotificationService.RxPlanDetail('rxPlanId','E','TN','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail1=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail1.add(rxDetail1);
          BCTNotificationService.RxPlanBlock rxBlock1=new BCTNotificationService.RxPlanBlock(lstDetail1,lstDetail1);           
          BCTNotificationService.ReturnData rData5= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData5);    
          
          BCTNotificationService.RxPlanDetail rxDetail2=new BCTNotificationService.RxPlanDetail('rxPlanId','E','NP','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail2=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail2.add(rxDetail2);
          BCTNotificationService.RxPlanBlock rxBlock2=new BCTNotificationService.RxPlanBlock(lstDetail2,lstDetail2); 
          
          
          BCTNotificationService.ReturnData rData6= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData6);
          
          
          BCTNotificationService.ReturnData rData7= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData7); 
          
          BCTNotificationService.RxPlanDetail rxDetail3=new BCTNotificationService.RxPlanDetail(null,'E','NP','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail3=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail3.add(rxDetail3);
          BCTNotificationService.RxPlanBlock rxBlock3=new BCTNotificationService.RxPlanBlock(lstDetail3,lstDetail3); 
                    
          BCTNotificationService.ReturnData rData8= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData8);                   
        
          BCTNotificationService.ReturnData rData9= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData9);                    
          
          
          BCTNotificationService.ReturnData rData10= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData10);
          
          BCTNotificationService.ReturnData rData11= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData11);
                    
    }   
 
    static testMethod void testOtherResultData(){
      boolean result;
        CRD__c testCrd=new CRD__c();
          testCrd.TP_ID__c='testTPId';
          testCrd.Pricing_Schedule__c='Y4';
          insert testCrd; 
          BCTNotificationService.traditionalControlNumberPlanSummary tradPlanSummary=new BCTNotificationService.traditionalControlNumberPlanSummary(0,'');
          list<BCTNotificationService.traditionalControlNumberPlanSummary> lstControlPlanSummary=new list<BCTNotificationService.traditionalControlNumberPlanSummary>();
          
          BCTNotificationService.custmoHierarchy hmoHierarcy=new BCTNotificationService.custmoHierarchy('','','','');
          BCTNotificationService.tradHierarchy tradHierarcy=new BCTNotificationService.tradHierarchy(0,0,0,'');
                      
          BCTNotificationService.RxPlanDetail rxDetail2=new BCTNotificationService.RxPlanDetail('rxPlanId','E','NP','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail2=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail2.add(rxDetail2);
          
          BCTNotificationService.RxPlanBlock rxBlock2=new BCTNotificationService.RxPlanBlock(lstDetail2,lstDetail2);             
          BCTNotificationService.ReturnData rData7= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData7);                               

          BCTNotificationService.ReturnData rData8= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData8);
         
          BCTNotificationService.ReturnData rData9= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData9); 
 
          BCTNotificationService.ReturnData rData10= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData10);      
          
          BCTNotificationService.ReturnData rData11= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData11);                                                                  

          BCTNotificationService.ReturnData rData12= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData12);
         
          BCTNotificationService.ReturnData rData13= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData13);   
    }
     static testMethod void testCustomHMOResultData(){
          boolean result;
          CRD__c testCrd=new CRD__c();
          testCrd.TP_ID__c='testTPId';
          testCrd.Pricing_Schedule__c='Y4';
          insert testCrd;  
          
          test.startTest();
          BCTNotificationService.traditionalControlNumberPlanSummary tradPlanSummary=new BCTNotificationService.traditionalControlNumberPlanSummary(0,'');
          list<BCTNotificationService.traditionalControlNumberPlanSummary> lstControlPlanSummary=new list<BCTNotificationService.traditionalControlNumberPlanSummary>();
          
          BCTNotificationService.custmoHierarchy hmoHierarcy=new BCTNotificationService.custmoHierarchy('','','','');
          BCTNotificationService.tradHierarchy tradHierarcy=new BCTNotificationService.tradHierarchy(0,0,0,'');
                      
          BCTNotificationService.RxPlanDetail rxDetail2=new BCTNotificationService.RxPlanDetail('rxPlanId','E','NP','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail2=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail2.add(rxDetail2);
          
          BCTNotificationService.RxPlanBlock rxBlock2=new BCTNotificationService.RxPlanBlock(lstDetail2,lstDetail2); 
    
          BCTNotificationService.ReturnData rData13= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData13);   
          
          BCTNotificationService.ReturnData rData14= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData14);                   
        
          BCTNotificationService.ReturnData rData15= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData15);  
            test.stopTest();
          testCrd.Custom_Ben_ID__c='benefitString';
          testCrd.Benefits_State_List__c='NY;YN';
         // testCrd.Do_mandates_apply_to_all_states__c='N';
          update testCrd;
          BCTNotificationService.ReturnData rData16= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData16);            
          
          BCTNotificationService.RxPlanDetail rxDetail3=new BCTNotificationService.RxPlanDetail('rxPlanId','K','NP','states');
          list<BCTNotificationService.RxPlanDetail> lstDetail3=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail3.add(rxDetail3);
          
          BCTNotificationService.RxPlanBlock rxBlock3=new BCTNotificationService.RxPlanBlock(lstDetail3,lstDetail3);
          BCTNotificationService.ReturnData rData17= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData17);    
          
          BCTNotificationService.RxPlanDetail rxDetail4=new BCTNotificationService.RxPlanDetail('rxPlanId','K',null,'states');
          list<BCTNotificationService.RxPlanDetail> lstDetail4=new list<BCTNotificationService.RxPlanDetail>();
          lstDetail4.add(rxDetail4);  
          BCTNotificationService.RxPlanBlock rxBlock4=new BCTNotificationService.RxPlanBlock(lstDetail4,lstDetail4);                          

          BCTNotificationService.ReturnData rData18= new BCTNotificationService.ReturnData();
          result = BCTNotificationService.BctNotification(rData18);            
          
      }   
}