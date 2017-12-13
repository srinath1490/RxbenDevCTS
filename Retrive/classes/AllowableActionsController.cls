/*
This is web services class.
*/
without sharing global class AllowableActionsController
{
/*
  This method is using to get piclist values for Alllowable Action field 
  on Drug list and  Drug group object.
*/
webservice static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

    List<String> lstPickvals=new List<String>();
    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
    Sobject object_name = targetType.newSObject();
    Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
    List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
    Set<String> str=new Set<String>();
    for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
    str.add(a.getValue());
    lstPickvals.addAll(str);
    system.debug('Picklistvalue----->'+lstPickvals);
    //lstPickvals.addAll(a.getValue());//add the value  to our final list
}

  return lstPickvals;

}


}