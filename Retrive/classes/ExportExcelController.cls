/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class ExportExcelController {

    public List<CustomObjects__c> getCustomObjects() 
    {
      List<CustomObjects__c> CustomObjects=new List<CustomObjects__c>([select Id,Name,OwnerId,Add_Notes_and_Attachment__c,    Allow_Activities__c,Allow_Reports__c,Configuration_Environment__c,Deployment_Status__c,Description__c,Development_Environment__c,Enable_History__c,Label__c,Object_Name__c,Plural_Label__c,Production_Environment__c,Record_Name__c,Refrence_No__c,UAT_Environment__c from CustomObjects__c ]);
     
        return CustomObjects;
    }

}