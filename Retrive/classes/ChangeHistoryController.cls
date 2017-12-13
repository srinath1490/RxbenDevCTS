/**
 * @author mistry, rakesh - 'inspire'
 * @date 2011-09-28
 * ----------------
 * Controller to find the history of changes made to all objects.
 * This file is used both as a contoller for VF page as well as while sending
 * emails.
 */
public class ChangeHistoryController {

    /* Contacts created just to use date fields as input of startdate and enddate */
    private Contact toDate;
    private Contact fromDate;

    /**
     * List of 'HistoryDetail' objects which contains all the history in an
     * object format.
     *
     * @see 'HistoryDetail'
     */
    List<HistoryDetail> historyDetails;
    
    /**
     * List of history in String format.
     * Used to generate 'HistoryDetail' objects.
     */
    List<String> historyList;
    
    /**
     * A map for mapping user Id's with their corresponding names.
     * The user Id's are initially returned by querying history details.
     * These user Id's are then used to find corresponding usernames by a
     * single query.
     */
    Map<String, String> userIdNameMap;
    
    /**
     * Default Constructor
     * -------------------
     * Sets toDate to today and fromDate to yesterday.
     * Calls history() to calculate all values at the start.
     */
    public ChangeHistoryController() {
        toDate = new Contact();
        toDate.birthDate = Date.today();
        fromDate = new Contact();
        fromDate.birthDate = Date.today() - 1;
        
        history();
    }
    
    /**
     * Parameterized Constructor
     * -------------------------
     * Sets toDate and fromDate as specified.
     */
    public ChangeHistoryController(Date dateFrom, Date dateTo) {
        toDate = new Contact();
        toDate.birthDate = dateTo;
        fromDate = new Contact();
        fromDate.birthDate = dateFrom;
        
        history();
    }
    
    /**
     * Getter for 'fromDate' contact
     * -----------------------------
     * @return the 'fromDate' Contact
     */
    public Contact getPastDate() {
        return fromDate;
    }
    
    /**
     * Getter for 'toDate' contact
     * --------------------------------
     * @return the 'toDate' Contact
     */
    public Contact getCurrentDate() {
        return toDate;
    }
    
    /**
     * Getter for 'history'
     * --------------------
     * @return list of history for all objects in String format
     */
    public List<String> getHistory() {
        return historyList;
    }
    
    /**
     * Getter for 'historyDetails'
     * ---------------------------
     * @return list of 'historyDetail' objects
     */
    public List<HistoryDetail> getHistoryDetails() {
        return historyDetails;
    }
    
    /**
     * Method to create HistoryDetail objects from list of strings of history.
     *
     * It basically tokenizes the string representation of history containing
     * all the information into an object of 'HistoryDetail'.
     */
    public void createHistoryDetailList() {
        
        for(String strHist: getHistory()) {
        
            userIdNameMap = new Map<String, String>();
        
            Integer si = 0;
            Integer ei = 0;
            Integer oi = 0;
            
            while(true) {

                if(strHist.indexOf('OBJECT:', si) == -1) break;
                HistoryDetail hd = new HistoryDetail();

                si = strHist.indexOf('OBJECT:', si) + 'OBJECT:'.length();
                ei = strHist.indexOf(':', si);
                hd.setObjectName(strHist.substring(si, ei));
                
                si = strHist.indexOf('ParentId=', si) + 'ParentId='.length();
                ei = strHist.indexOf(',', si);
                hd.setParentId(strHist.substring(si, ei));
                
                si = strHist.indexOf('Field=', si) + 'Field='.length();
                ei = strHist.indexOf(',', si);
                hd.setField(strHist.substring(si, ei));
                
                si = strHist.indexOf('CreatedById=', si) + 'CreatedById='.length();
                ei = strHist.indexOf(',', si);
                hd.setCreatedById(strHist.substring(si, ei));

                // put user Id's in map later to be used to find user names
                userIdNameMap.put(strHist.substring(si, ei), null);
                
                si = strHist.indexOf('CreatedDate=', si) + 'CreatedDate='.length();
                ei = strHist.indexOf(',', si);
                hd.setCreatedDate(strHist.substring(si, ei));

                si = strHist.indexOf('IsDeleted=', si) + 'IsDeleted='.length();
                ei = strHist.indexOf(',', si);
                hd.setIsDeleted(strHist.substring(si, ei));

                si = strHist.indexOf('NewValue=', si) + 'NewValue='.length();
                ei = strHist.indexOf(',', si);
                hd.setNewValue(strHist.substring(si, ei));

                si = strHist.indexOf('Id=', si) + 'Id='.length();
                ei = strHist.indexOf(',', si);
                hd.setId(strHist.substring(si, ei));

                si = strHist.indexOf('OldValue=', si) + 'OldValue='.length();
                ei = strHist.indexOf('}', si);
                hd.setOldValue(strHist.substring(si, ei));
                
                //added for filtering of records 
                     // to show the fields whose old value was not null and whose old as well as new value can't be null
            
                    //if(((hd.getNewValue()!='null')&&(hd.getOldValue()!='null'))||((hd.getOldValue()!='null'))){ 
                    // to show those values whose  oldValue and newValue fields cannot be null        
                     // if((hd.getOldValue() != hd.getNewValue())&&(hd.getOldValue()!= null)){
                  if(hd.getOldValue() != hd.getNewValue()){                 
                    historyDetails.add(hd);
                    retrieveUserName(userIdNameMap);
                    
                }
            }
        }
    }
    
    /**
     * The method fills up the usernames in the map.
     *
     * @param 'userIdNameMap' map containing key values as user Ids.
     */
    public void retrieveUserName(Map<String, String> userIdNameMap) {
        String query = userIdNameQuery(userIdNameMap);
        
        userIdNameMap.clear();
        for(SObject sobj: Database.query(query)) {
            User usr = (User)sobj;
            userIdNameMap.put(String.valueOf(usr.Id), String.valueOf(usr.name));
        }
        
        setUserNameInHistoryDetails(userIdNameMap);
    }
    
    /**
     * Creates query for retrieving User objects using their Id's
     *
     * @param 'userIdNameMap' map containing key values as user Ids.
     */
    private String userIdNameQuery(Map<String, String> userIdNameMap) {
        String query = 'SELECT Id, name from USER WHERE Id IN(\'\', '; // Equivalent to: SELECT Id, name from USER WHERE Id IN('', 
                                                                       // Put an initial blank entry to avoid SOQL exception
        
        for(String key: userIdNameMap.keySet())
            query += '\'' + key + '\', ';
        
        query = query.substring(0, query.length() - 2); //remove last ', '
        query += ')';

        return query;
    }
    
    /**
     * Puts usernames for corresponding user id's in 'historyDetails' list.
     *
     * @param 'userIdNameMap' map containing key values as user Ids.
     */
    private void setUserNameInHistoryDetails(Map<String, String> userIdNameMap) {
        for(HistoryDetail hd: historyDetails)
            hd.setUserName(userIdNameMap.get(hd.getCreatedById()));
    }
    
    /**
     * retrieves history based on dates provided
     */
    public void history() {
        List<SObjectType> sObjList;
        Map<String, List<SObjectField>> objectFieldMap;
        historyDetails = new List<HistoryDetail>();
        
        sObjList = getHistoryObjectList();
        objectFieldMap = createObjectFieldMap(sObjList);
        
        Date cd = toDate.birthDate; // current date
        Date pd = fromDate.birthDate; // past date
        
        List<String> strList = new List<String>();
        for(SObjectType sobjType: sObjList) {
            String str = '';
        
            try {
                for(SObject sobj: Database.query(getQuery(sobjType, objectFieldMap)))
                    str += 'OBJECT:' + String.valueOf(sobj);
            } catch (Exception ex) {
                System.debug(ex);
            }
            
            strList.add(str);
        }
        
        historyList = strList;
        createHistoryDetailList();
    }
    
    /**
     * @param 'sobj' the SObjectType whose fields are to be retrieved
     * @param 'objectFieldMap' map from where the fields would be retrieved
     *
     * @return query to get history records from salesforce.com
     */
     private String getQuery(SObjectType sobj, Map<String, List<SObjectField>> objectFieldMap) {
     
         String query = 'SELECT ';
         for(SObjectField field: objectFieldMap.get(String.valueOf(sobj))) {
             query += String.valueOf(field) + ', ';
         }
         
         query = query.subString(0, query.length() - 2); // remove last ', '
         query += ' FROM ' + String.valueOf(sobj);
         query += ' WHERE CreatedDate <= :cd AND CreatedDate >= :pd';
         query += ' ORDER BY CreatedDate DESC';
         
         return query;
     }
    
    /**
     * @param 'sobj' the SObjectType whose fields are to be retrieved
     * @param 'objectFieldMap' map from where the fields would be retrieved
     *
     * @return the list of SObjectField for a specific SObject
     */
    public List<SObjectField> getFields(sObject sobj, Map<String, List<SObjectField>> objectFieldMap) {
        return objectFieldMap.get(String.valueOf(sobj));
    }
    
    /**
     * creates a map of SObjectType as key and list of its corresponding SObjectField's as value
     *
     * @param 'sObjList' a list of 'SObjectsType' objects
     *
     * @return a map of 'SObjectType' and 'list of SObjectField' for related SObject
     */
    private Map<String, List<SObjectField>> createObjectFieldMap(List<SObjectType> sObjList) {
    
        Map<String, List<SObjectField>> objectFieldMap = new Map<String, List<SObjectField>>();
    
        for(SObjectType sot: sObjList) {
            List<SObjectField> sFldList = new List<SObjectField>();
            sFldList = sot.getDescribe().fields.getMap().values();
            objectFieldMap.put(String.valueOf(sot), sFldList);
        }
        
        return objectFieldMap;
    }
    
    /**
     * @return list of object whose history tracking is enabled
     */
    private List<SObjectType> getHistoryObjectList() {
    
        List<SObjectType> sObjList = new List<SObjectType>();
        
        for(SObjectType sot: Schema.getGlobalDescribe().Values()) {
            if(String.valueOf(sot).endsWith('__History')) {
                sObjList.add(sot);
            }
        }
        
        return sObjList;
    }
}