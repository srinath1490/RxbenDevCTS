/*Purpose: Apex  Class to parse the XML which is coming from the External system.
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Abhishek Goel         6th Jan 2014          Parse XML 
======================================================================== */
global class SCH_OrgborIntegration implements Schedulable {

    /**
     * Method :- execute
     * Description:- this method will be called via Schedular
     **/
    global void execute(SchedulableContext SC) {
        SCH_OrgborIntegration.doOrgborIntegration();
    }

    /**
     * Method:- doCallOut
     * Description:- This method call orgbor system and refresh Orgbor table.    
     **/
    @future(callout = true)
    public static void doOrgborIntegration() {
        SCH_OrgborIntegration obj = new SCH_OrgborIntegration();
        obj.callOrgborSystem();
    }


    /**
     * Method :- callOrgborSystem
     * Description:- By using this method will send a HTTP request.
     **/
    public Void callOrgborSystem() {
        string responsebody;
        Joblog__c jobLog = new Joblog__c();
        joblog.Start_time__c = system.now();
        joblog.transactionid__c = 'Aetna_SFDC_' + joblog.Start_time__c.format('yyyy_MM_dd_hh_mm_ss');
        String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aisb="http://schema.aetna.com/2008/05/ws/aisb/" xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:org="http://schema.aetna.com/2012/11/ws/oRG/organizationInq" xmlns:org1="http://schema.aetna.com/2012/11/oRG/organizationInq">' + '   <soapenv:Header>' + '   <aisb:consumerRequest add:IsReferenceParameter="true">' + '   <aisb:reporting>' + '   <aisb:loggingLevel>error</aisb:loggingLevel>' + '   <aisb:instrumentation>N</aisb:instrumentation>' + '   </aisb:reporting>' + '   </aisb:consumerRequest>' + '   <add:MessageID>' + joblog.transactionid__c + '</add:MessageID>' + '   <add:Action>http://service.registry.aetna.com/OrganizationInq/getOrganizationAndArrIdsByType/1.0</add:Action>' + '   <add:From>' + '   <add:Address>http://consumer.registry.aetna.com/SalesForceOBOR/1.0</add:Address>' + '   </add:From>' + '   <add:To>http://service.registry.aetna.com/OrganizationInq/</add:To>' + '   </soapenv:Header>' + '   <soapenv:Body>' + '  <org:getOrganizationAndArrIdsByType>' + '  <org1:organizationTypeCriterion>' + '  <org1:orgType>MEHUS</org1:orgType>' + '  </org1:organizationTypeCriterion>' + '  </org:getOrganizationAndArrIdsByType>' + '   </soapenv:Body>' + '</soapenv:Envelope>';
        try {
            string endpoint = Label.OrgBorEndPoint;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setHeader('content-type', 'text/xml; charset=utf-8');
            req.setHeader('SOAPAction', 'http://service.registry.aetna.com/OrganizationInq/getOrganizationAndArrIdsByType/1.0');
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(body);
            req.setClientCertificateName(System.Label.OrgBorCertificate);
            if(!test.isRunningTest()){
            HttpResponse response = (new Http()).send(req);
            responsebody = response.getBody();
            }else{
                responsebody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsa="http://www.w3.org/2005/08/addressing"><soapenv:Header><wsa:To>http://www.w3.org/2005/08/addressing/anonymous</wsa:To><wsa:Action>http://schema.aetna.com/2012/11/ws/oRG/organizationInq/OrganizationInq/getOrganizationAndArrIdsByTypeResponse</wsa:Action><wsa:MessageID>uuid:90E610FE-0144-4000-E000-007FA7451A18</wsa:MessageID><wsa:RelatesTo>Aetna_SFDC_2014_03_05_11_50_00</wsa:RelatesTo></soapenv:Header><soapenv:Body><p22:getOrganizationAndArrIdsByTypeResponse xmlns:p22="http://schema.aetna.com/2012/11/ws/oRG/organizationInq"><p37:orgAndArrIdResp xmlns:p37="http://schema.aetna.com/2012/11/oRG/organizationInq"><p37:orgArrIdSet><p37:orgAndAssociatedArrIds><p37:orgIds><p37:orgId>6678</p37:orgId><p37:name>Joint Venture #2</p37:name><p37:orgType>MEHUS</p37:orgType><p37:typeDesc>Carrier</p37:typeDesc></p37:orgIds><p37:arrIdSet><p37:arrangementIdentifier><p37:arrId>4859188</p37:arrId><p37:arrName>Aetna License Rental</p37:arrName><p37:expDt>2048-12-19</p37:expDt><p37:effDt>2012-12-19</p37:effDt></p37:arrangementIdentifier><p37:arrangementIdentifier><p37:arrId>79147097</p37:arrId><p37:arrName>Licensed Entity</p37:arrName><p37:expDt>2048-01-11</p37:expDt><p37:effDt>2013-01-11</p37:effDt></p37:arrangementIdentifier><p37:arrangementIdentifier><p37:arrId>60227954</p37:arrId><p37:arrName>Licensed Entity, claim processing outsourced</p37:arrName><p37:expDt>9999-12-31</p37:expDt><p37:effDt>2013-12-13</p37:effDt></p37:arrangementIdentifier></p37:arrIdSet></p37:orgAndAssociatedArrIds><p37:orgAndAssociatedArrIds><p37:orgIds><p37:orgId>15832676</p37:orgId><p37:name>Aetna</p37:name><p37:orgType>MEHUS</p37:orgType><p37:typeDesc>Carrier</p37:typeDesc></p37:orgIds><p37:arrIdSet><p37:arrangementIdentifier><p37:arrId>80869880</p37:arrId><p37:arrName>Default Arrangement</p37:arrName><p37:expDt>2048-11-01</p37:expDt><p37:effDt>2012-11-01</p37:effDt></p37:arrangementIdentifier></p37:arrIdSet></p37:orgAndAssociatedArrIds><p37:orgAndAssociatedArrIds><p37:orgIds><p37:orgId>85752754</p37:orgId><p37:name>Innovation Health</p37:name><p37:orgType>MEHUS</p37:orgType><p37:typeDesc>Carrier</p37:typeDesc></p37:orgIds><p37:arrIdSet><p37:arrangementIdentifier><p37:arrId>15256401</p37:arrId><p37:arrName>Reinsurance Agreement (Phase  1)</p37:arrName><p37:expDt>2048-11-19</p37:expDt><p37:effDt>2012-11-19</p37:effDt></p37:arrangementIdentifier><p37:arrangementIdentifier><p37:arrId>58825157</p37:arrId><p37:arrName>Licensed Entity (Phase 2)</p37:arrName><p37:expDt>2048-11-19</p37:expDt><p37:effDt>2012-11-19</p37:effDt></p37:arrangementIdentifier></p37:arrIdSet></p37:orgAndAssociatedArrIds></p37:orgArrIdSet></p37:orgAndArrIdResp></p22:getOrganizationAndArrIdsByTypeResponse></soapenv:Body></soapenv:Envelope>';
            }
            processOrgBorResponse(responsebody);


        } catch (Exception ex) {
            //Handling the error and inserting the error into the Error field
            joblog.error__c = ex.getmessage();

        } finally {
            joblog.End_Time__c = system.now();
            joblog.RequestedBy__c = userinfo.getuserid();
            if (joblog.Error__c == null) {
                joblog.Success__c = true;
            }
            insert joblog;
            //Creating the attachment for the error recorded
            if (joblog.Error__c != null) {
                if(test.isRunningTest())
                    responsebody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsa="http://www.w3.org/2005/08/addressing"><soapenv:Header><wsa:To>http://www.w3.org/2005/08/addressing/anonymous</wsa:To><wsa:Action>http://schema.aetna.com/2012/11/ws/oRG/organizationInq/OrganizationInq/getOrganizationAndArrIdsByTypeResponse</wsa:Action><wsa:MessageID>uuid:90E610FE-0144-4000-E000-007FA7451A18</wsa:MessageID><wsa:RelatesTo>Aetna_SFDC_2014_03_05_11_50_00</wsa:RelatesTo></soapenv:Header><soapenv:Body><p22:getOrganizationAndArrIdsByTypeResponse xmlns:p22="http://schema.aetna.com/2012/11/ws/oRG/organizationInq"><p37:orgAndArrIdResp xmlns:p37="http://schema.aetna.com/2012/11/oRG/organizationInq"><p37:orgArrIdSet><p37:orgAndAssociatedArrIds><p37:orgIds><p37:orgId>6678</p37:orgId><p37:name>Joint Venture #2</p37:name><p37:orgType>MEHUS</p37:orgType><p37:typeDesc>Carrier</p37:typeDesc></p37:orgIds><p37:arrIdSet><p37:arrangementIdentifier><p37:arrId>4859188</p37:arrId><p37:arrName>Aetna License Rental</p37:arrName><p37:expDt>2048-12-19</p37:expDt><p37:effDt>2012-12-19</p37:effDt></p37:arrangementIdentifier><p37:arrangementIdentifier><p37:arrId>79147097</p37:arrId><p37:arrName>Licensed Entity</p37:arrName><p37:expDt>2048-01-11</p37:expDt><p37:effDt>2013-01-11</p37:effDt></p37:arrangementIdentifier><p37:arrangementIdentifier><p37:arrId>60227954</p37:arrId><p37:arrName>Licensed Entity, claim processing outsourced</p37:arrName><p37:expDt>9999-12-31</p37:expDt><p37:effDt>2013-12-13</p37:effDt></p37:arrangementIdentifier></p37:arrIdSet></p37:orgAndAssociatedArrIds><p37:orgAndAssociatedArrIds><p37:orgIds><p37:orgId>15832676</p37:orgId><p37:name>Aetna</p37:name><p37:orgType>MEHUS</p37:orgType><p37:typeDesc>Carrier</p37:typeDesc></p37:orgIds><p37:arrIdSet><p37:arrangementIdentifier><p37:arrId>80869880</p37:arrId><p37:arrName>Default Arrangement</p37:arrName><p37:expDt>2048-11-01</p37:expDt><p37:effDt>2012-11-01</p37:effDt></p37:arrangementIdentifier></p37:arrIdSet></p37:orgAndAssociatedArrIds><p37:orgAndAssociatedArrIds><p37:orgIds><p37:orgId>85752754</p37:orgId><p37:name>Innovation Health</p37:name><p37:orgType>MEHUS</p37:orgType><p37:typeDesc>Carrier</p37:typeDesc></p37:orgIds><p37:arrIdSet><p37:arrangementIdentifier><p37:arrId>15256401</p37:arrId><p37:arrName>Reinsurance Agreement (Phase  1)</p37:arrName><p37:expDt>2048-11-19</p37:expDt><p37:effDt>2012-11-19</p37:effDt></p37:arrangementIdentifier><p37:arrangementIdentifier><p37:arrId>58825157</p37:arrId><p37:arrName>Licensed Entity (Phase 2)</p37:arrName><p37:expDt>2048-11-19</p37:expDt><p37:effDt>2012-11-19</p37:effDt></p37:arrangementIdentifier></p37:arrIdSet></p37:orgAndAssociatedArrIds></p37:orgArrIdSet></p37:orgAndArrIdResp></p22:getOrganizationAndArrIdsByTypeResponse></soapenv:Body></soapenv:Envelope>';
                Blob xmlResblob = Blob.valueOf(responsebody);
                Blob xmlReqblob = Blob.valueOf(body);
                List < Attachment > attachmentsList = new List < Attachment > ();
                Attachment attachRes = new attachment();
                attachRes.name = 'JobLog_Response' + '' + system.now() + '.xml';
                if (xmlResblob != null){
                     attachRes.body = xmlResblob;
                }
                attachRes.parentid = joblog.id;
                attachmentsList.add(attachRes);

                Attachment attachReq = new attachment();
                attachReq.name = 'JobLog_Request' + '' + system.now() + '.xml';
                if (xmlReqblob != null){
                     attachReq.body = xmlReqblob;
                }
                attachReq.parentid = joblog.id;
                attachmentsList.add(attachReq);

                insert attachmentsList;
            }
        }
    }

    /**
     * Method :- processOrgBorResponse
     * Description:- By using this method will received  a HTTP Response and Parse it.
     **/
    public void processOrgBorResponse(String response) {
        Map<String,OrgandArrangement__c> orgArgmtId = new Map < String,OrgandArrangement__c > ();
        List < OrgandArrangement__c > orgArgmtIds = new List < OrgandArrangement__c > ();
        XmlStreamReader reader = new XmlStreamReader(response);
        OrgandArrangement__c orgArr = new OrgandArrangement__c();
        while (reader.hasNext()) {
            reader.next();
            if (reader.getLocalName() == 'orgAndAssociatedArrIds' && reader.isStartElement()) {
                String orgId, orgType, orgName;
                while (!(reader.isEndElement() && reader.getLocalName() == 'orgAndAssociatedArrIds')) {
                    reader.next();
                    if (reader.getLocalName() == 'orgIds' && reader.isStartElement()) {
                        while (!(reader.isEndElement() && reader.getLocalName() == 'orgIds')) {
                            reader.next();
                            if (reader.getLocalName() == 'orgId' && reader.isStartElement()) {
                                reader.next();
                                orgId = reader.getText();
                            } else if (reader.getLocalName() == 'orgType' && reader.isStartElement()) {
                                reader.next();
                                orgType = reader.getText();
                            } else if (reader.getLocalName() == 'name' && reader.isStartElement()) {
                                reader.next();
                                orgName = reader.getText();
                            }
                        }
                    } else if (reader.getLocalName() == 'arrangementIdentifier' && reader.isStartElement()) {
                        orgArr = new OrgandArrangement__c();
                        orgArr.OrgType__c = orgtype;
                        orgArr.Orgid__c = orgId;
                        orgArr.OrgName__c = orgName;
                        while (!(reader.isEndElement() && reader.getLocalName() == 'arrangementIdentifier')) {
                            reader.next();
                            if (reader.getLocalName() == 'arrId' && reader.isStartElement()) {
                                reader.next();
                                orgArr.ArrangmentId__c = reader.getText();
                            } else if (reader.getLocalName() == 'arrName' && reader.isStartElement()) {
                                reader.next();
                                orgArr.ArrangmentName__c = reader.getText();
                            }
                        }
                        if (orgArr.ArrangmentId__c != null) {
                            orgArr.JoinKey__c = orgArr.orgId__c + orgArr.ArrangmentId__c;
                            orgArgmtId.put(orgArr.JoinKey__c ,orgArr);
                        }
                    }
                }

            }

        }        
        upsert orgArgmtId.values() JoinKey__c ;
        delete[Select id from OrgandArrangement__c where LastModifiedDate <> Today];        
        CB_CRDBMonitor CB = new CB_CRDBMonitor();
        CB.sendEmailmethod('SCH_OrgborIntegration','Completed');
    }


    /*
     * Method:- testMe 
     * Description:- This method is only created for testing purpose
     */
    public static void testMe() {
        SCH_OrgborIntegration obj = new SCH_OrgborIntegration();
        obj.callOrgborSystem();
    }
}