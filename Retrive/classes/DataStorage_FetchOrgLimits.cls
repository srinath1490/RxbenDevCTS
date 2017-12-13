Public class DataStorage_FetchOrgLimits{

    @future(callout=true)
    public static void StorageDetails(){
    
    String requestUrl = '/services/data/v37.0/limits';

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        string sid = login.login(system.label.StorageLoginUser,system.label.StorageUserCred);
        
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + requestUrl);
        System.debug(URL.getSalesforceBaseUrl().toExternalForm()+ requestUrl);
        
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + sid);
        
        HTTPResponse res = http.send(req);
        String output = res.getBody();
        System.debug(output);
        
        Map<String, Object> m = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        Map<String, Object> dataStorage = (Map<String,Object>)m.get('DataStorageMB');
        Map<String, Object> fileStorage = (Map<String,Object>)m.get('FileStorageMB');
        
        System.debug('Current Storage: ' + dataStorage.get('Remaining'));
        System.debug('Max Storage: ' + dataStorage.get('Max'));
        
        string DataStorageMB = 'DataStorageMB';
        string FileStorageMB = 'FileStorageMB';

        Decimal DMax = Integer.valueOf(dataStorage.get('Max')); 
        Decimal DRem = Integer.valueOf(dataStorage.get('Remaining'));
        Integer FMax = Integer.valueOf(fileStorage.get('Max'));
        Integer FRem = Integer.valueOf(fileStorage.get('Remaining'));
        Integer DUsed = Integer.valueOf(MATH.Ceil(((DMax - DRem)*100)/DMax)); 
        Integer FUsed = Integer.valueOf(MATH.Ceil(((FMax - FRem)*100)/FMax));
        

        System.debug('Data Used: '+DUsed);
        System.debug('File Used: '+FUsed);
        
         If( DUsed > 80 || FUsed > 80) {
            //Email to notify Data Storage Limit 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] splittedEmails = system.label.StorageAlertNotification.split(',');
            system.debug('===>email addresses '+splittedEmails);
            mail.setToAddresses(splittedEmails);
            mail.setOrgWideEmailAddressId(system.label.StorageOrgWideAddressID);
            mail.setSubject('Data Storage Alert.');
            mail.setHtmlBody('Hi Team, <br/><br/>The Data Storage Limit in production has exceeded the threshold value. <br/><br/> Current Data Storage Used as of ' + SYSTEM.TODAY().format() + ' is ' + DUsed + '%.<br/><br/>Current File Storage Used as of ' + SYSTEM.TODAY().format() + ' is ' + FUsed + '%.<br/><br/>Thanks<br/>RxBen Production Support Services');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}