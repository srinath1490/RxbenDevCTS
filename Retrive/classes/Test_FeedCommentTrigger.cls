/*
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR          DATE                DETAIL                                
   1.0 -    Jenna Vuong     03-31-15            Test_FeedCommentTrigger(), prevent users from commenting on tracked feed posts
======================================================================== */

@isTest
public class Test_FeedCommentTrigger {

    static testMethod void Test_IfTrackedFeedPreventComment() {
        
        // create test account
        Account testAcct = new Account(Name = 'account');
        insert testAcct;
        
        // create test opportunity
        Opportunity testOpp = new Opportunity(AccountId = testAcct.Id, Name = 'Test Opp', StageName = 'Qualification', CloseDate = System.today());
        insert testOpp;

        Test.startTest();
        
        // change opportunity stage to trigger a tracked feed post
        testOpp.StageName = 'Closed Won';
        testOpp.APM_WonFrom__c = 'Medco';
        testOpp.APM_WonReason__c = 'Consolidation';
        testOpp.Sales_Strategy__c = 'Aetna One';//Richa added since the test class was failing on 12/18/2015
        testOpp.Value_Sold__c = true; //Ayushi added since the test class was failing 5/10/2016
        update testOpp;

        FeedItem oppFeedObj = new FeedItem();
        oppFeedObj.ParentId = testOpp.Id;
        oppFeedObj.body = 'This is a test FeedItem.';
        insert oppFeedObj;

        Test.stopTest();        

        List<FeedItem> feedItemList = [ Select Id, ParentId From FeedItem ]; 
       
        System.assertEquals(1, feedItemList.size());

        // find the feedItem Id of tracked feed post
        FeedItem oppFeedItem = new FeedItem();
        oppFeedItem = [ Select Id, ParentId From FeedItem Where ParentId = :testOpp.Id LIMIT 1 ];  
        
        // test in bulk by posting 200 comments on tracked feed post
        List<FeedComment> testComments = new List<FeedComment>();
        
        for (Integer i = 0; i < 200; i++) {
            
            FeedComment a = new FeedComment();
            //a.Type = 'TrackedChange'; //jenna-cannot insert FeedItem of 'TrackedChange' Type
            a.FeedItemId = oppFeedItem.Id;
            a.CommentBody = 'Helloz';
            testComments.add(a);
        }
        insert testComments;
        
        List<FeedItem> getItems = new List<FeedItem>();
        getItems = [ Select Id, ParentId, Type From FeedItem ];
        
        System.assertEquals(1, getItems.size());
        //System.assertEquals('TrackedChange', getItems[0].Type); //jenna-cannot insert FeedItem of 'TrackedChange' Type
        
        List<FeedComment> getComments = new List<FeedComment>();
        getComments = [ Select Id, FeedItemId From FeedComment ];
        
        System.assertEquals(200, getComments.size());
    
    }
    
}