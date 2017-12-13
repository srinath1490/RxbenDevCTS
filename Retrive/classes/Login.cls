public with sharing class Login {

    private static final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static final String NS_SF = 'urn:partner.soap.sforce.com';

    public static String login(String user, String password)
    {
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');   
        req.setTimeout(60000);

        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/38.0');
        system.debug('===>endpoint '+URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/29.0');
        
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
        req.setHeader('SOAPAction', '""');
        req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +user+ '</username><password>' + password + '</password></login></Body></Envelope>');        
        try{
            HttpResponse res =  new Http().send(req);
                // As per http://wiki.developerforce.com/page/Enterprise_Login
            if(!Test.isRunningTest()){
                Dom.Document responseDocument = res.getBodyDocument();
                Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
                Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
                Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
                Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result
                Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
                return sessionIdElm.getText();
            }else{
                return null;
            }
            }
        catch(exception e){
            return null;
        }
    }

    public class LoginException extends Exception {}
}