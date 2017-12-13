/*Purpose: Apex Class to Monitor Batch Health
========================================================================
History                                                            
-------                                                            
VERSION       AUTHOR               DATE                DETAIL                                 
 1.0          Saklani Sandeep      11/08/2014          Apex Class to Monitor Batch Health
======================================================================== */

Public Class CB_CRDBMonitor{

    Public static void CalculateStatus(Id batchId){
        boolean Delay;
        datetime cdate;
        String stat;
        string ApexClassName;
        
        List<AsyncApexJob> jobDet = new List<AsyncApexJob>();
        CB_CRDBMonitor CB = new CB_CRDBMonitor();
        
        jobDet = [Select Id, Status, createddate, ApexClassId, ApexClass.name from AsyncApexJob where id=:batchId];
        system.debug('SOQL'+jobDet);
        
        For(AsyncApexJob ajb: jobDet){
        
            cdate = ajb.createddate;
            stat = ajb.Status;
            ApexClassName = ajb.ApexClass.name;
        }

        If (cdate+(1/48) > system.now()){
            CB.sendEmailmethod(ApexClassName,'Delay');
        }
        
        If (stat=='Aborted'){
            CB.sendEmailmethod(ApexClassName,'Aborted');
        }

        If (stat=='Completed'){
            CB.sendEmailmethod(ApexClassName,'Completed');
        }
        
        If (stat=='Failed'){
            CB.sendEmailmethod(ApexClassName,'Failed');
        }
    }
    

    Public void sendEmailmethod(String ApexClassName, string Status){   
        
        If (Status == 'Completed'){
        system.debug('sending email on completion');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = system.label.BatchNotifDL.split(',');
            mail.setToAddresses(toAddresses);
            mail.setOrgWideEmailAddressId(system.label.StorageOrgWideAddressID);
            mail.setSubject(ApexClassName+' Batch Execution Completed.');
            mail.setHtmlBody('Hi All, <br/><br/>This is to notify you that '+ApexClassName+' batch has completed its execution .<br/><br/>Thanks<br/>RxBen Production Support Team');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } Else if(Status == 'Delay' ){
                system.debug('sending email date logic');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = system.label.BatchNotifDL.split(',');
                mail.setToAddresses(toAddresses);
                mail.setOrgWideEmailAddressId(system.label.StorageOrgWideAddressID);
                mail.setSubject(ApexClassName+' Batch Delayed Execution.');
                mail.setHtmlBody('Hi All, <br/><br/>This is to notify you that '+ApexClassName+' batch has delayed its execution .<br/><br/>Thanks<br/>RxBen Production Support Team');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }Else if(Status == 'Failed'){
        system.debug('sending email on failure');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = system.label.BatchNotifDL.split(',');
            mail.setToAddresses(toAddresses);
            mail.setOrgWideEmailAddressId(system.label.StorageOrgWideAddressID);
            mail.setSubject(ApexClassName+' Batch Execution Failed.');
            mail.setHtmlBody('Hi All, <br/><br/>This is to notify you that '+ApexClassName+' batch has failed its execution .<br/><br/>Thanks<br/>RxBen Production Support Team');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }Else if(Status == 'Aborted'){
        system.debug('sending email on abort');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = system.label.BatchNotifDL.split(',');
            mail.setToAddresses(toAddresses);
            mail.setOrgWideEmailAddressId(system.label.StorageOrgWideAddressID);
            mail.setSubject(ApexClassName+' Batch Execution Aborted.');
            mail.setHtmlBody('Hi All, <br/><br/>This is to notify you that '+ApexClassName+' batch execution has been aborted .<br/><br/>Thanks<br/>RxBen Production Support Team');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }Else if(Status == 'NA'){
        system.debug('sending email when batch didnt execute');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = system.label.BatchNotifDL.split(',');
            mail.setToAddresses(toAddresses);
            mail.setOrgWideEmailAddressId(system.label.StorageOrgWideAddressID);
            mail.setSubject(ApexClassName+' Batch Did not Executed.');
            mail.setHtmlBody('Hi All, <br/><br/>This is to notify you that '+ApexClassName+' batch did not execute.<br/><br/>Thanks<br/>RxBen Production Support Team');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}