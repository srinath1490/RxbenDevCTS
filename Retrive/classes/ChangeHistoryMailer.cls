/**
 * @author mistry, rakesh - 'inspire'
 * @date 2011-09-28
 * ----------------
 * Apex batch to mail all the changes made to records to email addresses
 * specified in custom setting list - 'Email_List__c'.
 * It uses classes:
 *     1. HistoryDetail: which contains all the history related fields
 *     2. ChangeHistoryController which actually creates all
 *        HistoryDetail objects.
 *
 * @see HistoryDetail
 */
global class ChangeHistoryMailer implements Database.Batchable<sObject> {

    ChangeHistoryController chc;
    
    /**
     * Method to create a html body for the email to be sent.
     * Accesses all HistoryDetail objects and creates a table.
     * Changes are highlighted (bold text) in the table.
     *
     * @return body of email message
     */
    private String createHtmlMessageBody() {
        ChangeHistoryController chc = new ChangeHistoryController();
        String msg = '';
        msg += '<head>';
        msg += '<style type=\"text/css\">' +
                    'table,th,td' +
                    '{' +
                        'border:1px solid #C0C0C0;' +
                        'border-collapse: collapse;' +
                        'padding: 5px;' +
                        'font-family: Calibri, Arial, sans-serif;' +
                        'font-size: 12px;' +
                    '}' +
                '</style>' +
                '</head>';
                
        msg += '<body style=\"font-family: Calibri, Arial, sans-serif;\">';
        msg += '<h3>Autogenerated mail: Change History - Details</h3>';
        msg += '<p>The following are the changes made to the data of CWB automation application</p>';
        msg += '<table><tr>';
//        msg += '<th>Object Name</th><th>Field</th><th>Created Date</th><th>Is Deleted</th><th>New Value</th><th>Old Value</th><th>Modified By</th>'; //<th>Parent Id</th><th>CreatedBy Id</th><th>Id</th>';
        msg += '<th>Object Name</th><th>Field</th><th>Created Date</th><th>New Value</th><th>Old Value</th><th>Modified By</th>'; //<th>Parent Id</th><th>CreatedBy Id</th><th>Id</th>';
        msg += '</tr><caption>Changes made to data from ' + toHtmlBold(String.valueOf(Date.today() - 1)) + ' to ' + toHtmlBold(String.valueOf(Date.today())) + '</caption>';
        
        List<HistoryDetail> historyList= chc.getHistoryDetails();
        if(historyList.size() == 0) return null;
        
        for(HistoryDetail hd: historyList) {
            msg += '<tr>';
            msg += '<td>' + hd.getObjectName() + '</td>';
            
            // set created field as bold if the field is created
            String field = hd.getField();
            if(field == 'created') field = toHtmlBold(field);
            msg += '<td>' + field + '</td>';
            
            msg += '<td>' + hd.getCreatedDate() + '</td>';
            
            // set isDeleted field as bold if the field is deleted
            String isDeleted = hd.getIsDeleted();
            if(isDeleted == 'true') isDeleted = toHtmlBold(isDeleted);
           // msg += '<td>' + hd.getIsDeleted() + '</td>';
            
            // set oldValue, newValue fields as bold if the field value is changed
            String oldValue = hd.getOldValue();
            String newValue = hd.getNewValue();
            //filtering those values which are changed and whose oldValue and newValue are null as well
            //if(((oldValue != null && oldValue != newValue))          
            //filtering those values which are changed  and oldValue is not null
            //if((oldValue != null && newValue != null) || (oldValue != null)) {
            //filtering those values which are created and the changes made to the values of the fields  
            if(oldValue != newValue){
                oldValue = toHtmlBold(oldValue);
                newValue = toHtmlBold(newValue);
            }
            
            msg += '<td>' + newValue + '</td>';
            msg += '<td>' + oldValue + '</td>';
            
            msg += '<td>' + hd.getUserName() + '</hd>';
            // msg += '<td>' + hd.getParentId() + '</td>';
            // msg += '<td>' + hd.getCreatedById() + '</td>';
            // msg += '<td>' + hd.getId() + '</td>';
            msg += '</tr>';
        }
        
        msg += '</table></body>';
        
        return msg;
    }
    
    /**
     * Method to convert a string to its html bold format by adding
     * <b> and </b> at the start and end of the string
     *
     * @param 'str' the string to be boldified
     * @return String with <b> and </b> added to front and end
     */
    private String toHtmlBold(String str) {
        return ('<b>' + str + '</b>');
    }
    
    /**
     * Method that returns a list of addresses of recipients.
     * The addresses are retrieved from a Custom Setting List - 'Email_List__c'
     *
     * @return list of strings containing email addresses of recipients
     */
    private List<String> getSenderAddresses() {
        List<String> strList = new List<String>();
    
        List<Email_List__c> addrList = Email_List__c.getAll().values();
        
        for(Email_List__c addr: addrList)
            strList.add(addr.Email__c);
            
        return strList;
    }

    /**
     * Implementation of interface method start()
     * Contains a bogus query which is not used. It was necessary to put a
     * query, else it was giving error.
     * (Someone may simplify it as I find it unnecessary to put a bogus query)
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    
    /**
     * Implementation of interface method execute() - does nothing
     */
    global void execute(Database.BatchableContext bc, List<sObject> slist) {
    }
    
    /**
     * Implementation of interface method finish()
     * Sends email to all recipients.
     */
    global void finish(Database.BatchableContext bc) {
        
        String msg = createHtmlMessageBody();
        if(msg == null) return;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = getSenderAddresses();
        mail.setToAddresses(toAddresses);
        // mail.setToAddresses(new String[] {'rakesh.mistry@accenture.com'}); // testing by mailing myself
        mail.setSubject('CWBAutomation [autogenerated Message]: Change History Details');
        mail.setHtmlBody(msg);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}