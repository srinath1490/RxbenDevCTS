/**
*Purpose: Apex Batch Class for creating XML for GMF objects
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*   1.0 -    Ankur           22 July 2015       Wrapper  for GMF XML objects
*======================================================================== 
**/
global class GMF_XMLWrapperUtil{
    //List of wrapper to contain information of more than one record
    public list<GMF_XMLWrapper> GMF_XMLWrapperlist = new list<GMF_XMLWrapper>();
    //Wrapper class to bind Objecttype with recordId Also in case of drug list it will contain recordtype instead of object api
    //Constructor of util class to instantiate GMF_XMLWrapperlist
    public GMF_XMLWrapperUtil(map<string,set<id>> recordidsMap){
        //In case this map contain drug list record we have to group on basis of record type as Different record type of drug coverage has different type of xml to be generated.     
        //Iterate over differnt object names to populate list of wrappers
        for(String objecttype : recordidsMap.keyset()){                 
            set<id> recordidlist = recordidsMap.get(objectType);
            //Iterate over different record ids to create different wrapper records
            GMF_XMLWrapper tempwrap;
            for(id recordid : recordidlist){
                tempwrap = new GMF_XMLWrapper();
                //Drug list Records need to be categorised using record types
                tempwrap.ObjectType = objectType;
                tempwrap.RecordID = RecordID;
                //Add Temporary wrapper record to list.
                GMF_XMLWrapperlist.add(tempwrap);
            }                   
        }
    }
}