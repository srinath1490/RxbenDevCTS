/**
*Purpose: Apex Class for wrapping ObjectType with RecordId
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*   1.0 -    Ankur           22 July 2015       Apex Class for wrapping ObjectType with RecordId
*======================================================================== 
**/
Global class GMF_XMLWrapper{
    Public String ObjectType{get;set;}
    Public id RecordID{get;set;}
    Public GMF_XMLWrapper(){
        ObjectType = '';
        RecordID = null;
    }
}