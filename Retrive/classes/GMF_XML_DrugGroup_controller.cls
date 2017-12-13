/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
    1.0 -   Allen, Becca            05/30/2012               Created the file 
    1.1 -   Allen, Becca            12/06/2012               updates for Last Modified Date, LastSent Date, etc. 
    1.2 -   Allen, Becca            09/26/2013               updated to add HIX field auto-population on created case
======================================================================== */
public with sharing class GMF_XML_DrugGroup_controller {
    public boolean batchContext = false;
    Drug_Group__c DGrecord;
    List<Drug_List_Junction__c>  DLJRecord = new List<Drug_List_Junction__c>();
    Map<String,String> DGmap = new Map<String,String>();
    Map<String,String> DLJmap_2 = new Map<String,String>();
    List<Map<String,String>> DLJmap = new List<Map<String,String>>();
  
    Id parentId;
  
    public GMF_XML_DrugGroup_controller(ApexPages.StandardController controller) {
        batchContext = GMFBuilderUtil.batchContext;
        parentId=controller.getId();
        

         //Hix field added as per Request 01100, By Rahul Nasa
        DGrecord=[SELECT 
                        Effective_Date__c,Termination_Date__c,Hix__c,Name,RecordType.Name,Description__c,Sent_To_CVS_Date__c,Drug_Group_Name__c,Funding__c,LastModifiedDate,LastSent__c,Special_Use__c,Platform__c,Segment__c,Standard__c,State__c,Inactive__c
                    FROM Drug_Group__c 
                    WHERE Id=:parentId LIMIT 1];
        DLJrecord=[SELECT   
                        Name,/* Drug_Group__r.RecordType.Name,*/ Drug_List__r.RecordType.Name, Sequence__c,
                        /* Drug_Group__r.Name, Drug_Group__r.Description__c,Drug_Group__r.Drug_Group_Name__c, */
                        Drug_List__r.Name, Priority__c, Drug_List__r.LastSent__c, Drug_List__r.Sent_To_CVS_Date__c,Drug_List__r.CVS_Caremark_Drug_List_ID__c, Drug_List__r.Non_GPI_Non_NDC_Check__c, LastModifiedDate, Drug_List__r.LastModifiedDate, Drug_List__r.Drug_List_Name__c, Drug_List__r.Description__c, Inactive__c
                    FROM Drug_List_Junction__c 
                    WHERE Inactive__c = False AND Parent_Drug_Group__c=:DGrecord.Id AND isDeleted = false ];
                    
        //Build MAPs
        DGmap.put('DrugGroupID',String.valueOf(DGrecord.Name));
        DGmap.put('DrugGroupName',String.valueOf(DGrecord.Drug_Group_Name__c));
        DGmap.put('DrugGroupDescription',String.valueOf(DGrecord.Description__c));
        DGmap.put('RecordType',String.valueOf(DGrecord.RecordType.Name));
        DGmap.put('Inactive',String.valueOf(DGrecord.Inactive__c));
        DGmap.put('EffectiveDate',String.valueOf(DGrecord.Effective_Date__c));
        DGmap.put('TerminationDate',String.valueOf(DGrecord.Termination_Date__c));        
        //Hix field added as per Request 01100, By Rahul Nasa
        DGmap.put('HIX',String.valueOf(DGrecord.Hix__c));        
        //Hix field added as per Request 01100, By Rahul Nasa
        DGmap.put('SpecialUse',String.valueOf(DGrecord.Special_Use__c));
        DGmap.put('LastModifiedDate',String.valueOf(DGrecord.LastModifiedDate));
        //DGmap.put('LastSent',String.valueOf(DGrecord.LastSent__c));
        DGmap.put('SentToCVSDate',String.valueOf(DGrecord.Sent_To_CVS_Date__c));
        DGmap.put('TimeStamp',String.valueOf(system.now()));
        
        for(Drug_List_Junction__c dlj : DLJrecord){
            DLJmap_2 = new Map<String,String>();
            DLJmap_2.put('DrugListJunctionID',String.valueOf(dlj.Name));
            DLJmap_2.put('DrugListJunctionPriority',String.valueOf(dlj.Priority__c));
            DLJmap_2.put('DLJunctionLastModified',String.valueOf(dlj.LastModifiedDate));
          //  DLJmap_2.put('DrugGroupId',String.valueOf(dlj.Drug_Group__r.Name));
          //  DLJmap_2.put('DrugGroupName',String.valueOf(dlj.Drug_Group__r.Drug_Group_Name__c));   
           // DLJmap_2.put('DrugGroupRecordType',String.valueOf(dlj.Drug_Group__r.RecordType.Name));  
          //  DLJmap_2.put('DrugGroupDescription',String.valueOf(dlj.Drug_Group__r.Description__c));
            DLJmap_2.put('DrugListId',String.valueOf(dlj.Drug_List__r.Name));
            DLJmap_2.put('DrugListName',String.valueOf(dlj.Drug_List__r.Drug_List_Name__c));
            DLJmap_2.put('DrugListRecordType',String.valueOf(dlj.Drug_List__r.RecordType.Name));   
            DLJmap_2.put('DrugListDescription',String.valueOf(dlj.Drug_List__r.Description__c));
            DLJmap_2.put('DrugListLastModified',String.valueOf(dlj.Drug_List__r.LastModifiedDate));
            DLJmap_2.put('DrugListSentToCVSDate',String.valueOf(dlj.Drug_List__r.Sent_To_CVS_Date__c));
            DLJmap_2.put('DrugListNonGPINonNDCCheck',String.valueOf(dlj.Drug_List__r.Non_GPI_Non_NDC_Check__c));
            DLJmap_2.put('DrugListCVSCaremarkDrugListID',String.valueOf(dlj.Drug_List__r.CVS_Caremark_Drug_list_ID__c));
            DLJmap.add(DLJmap_2);
        }
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
        String CurrentVersion='1.1';
        
        String s=gmfwriter.getparentXml(CurrentVersion,'DrugGroup','DrugListJunction',DGmap,DLJmap);
        
        //updating record for custom history tracking.Added 12/27/11-Saraag
        DGrecord.LastSent__c=system.now();
        
        //end
        
        Case c=new Case();
        c.Aetna_Case_Type__c = 'GMF Case';
        c.GMF_Drug_Group__c = true;
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=DGrecord.Effective_Date__c;
        c.Subject=String.valueOf(DGrecord.Name)+' '+'-'+' '+String.valueOf(DGrecord.Drug_Group_Name__c);
        if (DGrecord.HIX__c == true) {
                c.HIX__c = true;
            } else {
                c.HIX__c = false;
            }
        GMFBuilderUtil.updateExternalCase(c,DGrecord);//Richa added for Req 6012    
        insert c;
        //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
        if(!batchContext){
          DGrecord.Sent_To_CVS_Date__c=system.now();
          DGrecord.PDF_Date__c=system.now();
          DGrecord.External_Case__c = c.id;
        }
        update DGrecord;
        
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=DGrecord.Name+' '+system.now()+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
        insert xmlAttach;
        
        String urlStr = '/'+String.valueOf(c.Id);
        PageReference MyObjectPR = new 
        PageReference(urlStr);
    
        return MyObjectPR;
    }
    
    /** 
    * =====================================================================
    *                          TEST CASE(S)
    * =====================================================================
    **/
    static testMethod void testXMLGeneration(){
        Account a = new Account();
        a.Name = 'test Account';
        insert a;
        
        Drug_Group__c dg = new Drug_Group__c();
        dg.Account__c = a.Id;
        dg.Description__c = 'test';
        dg.Drug_Group_Name__c = 'new drug group';
        dg.Effective_Date__c=system.today();
        dg.Termination_Date__c=system.today().addDays(3);
        //dg.Drug_Group_Name__c='sample';
        //dg.Description__c='sample2';
        insert dg;
        
        Drug_Group__c dg2 = new Drug_Group__c();
        dg2.Account__c = a.Id;
        dg2.Description__c = 'test';
        dg2.Drug_Group_Name__c = 'new drug group';
        dg2.Effective_Date__c=system.today();
        dg2.Termination_Date__c=system.today().addDays(3);
        insert dg2;
        
        Drug_List_Junction__c dlj = new Drug_List_Junction__c();
        dlj.Parent_Drug_Group__c = dg.Id;
        //dlj.Drug_Group__c = dg2.Id;
        insert dlj;     
        
        ApexPages.StandardController dgsc = new ApexPages.StandardController(dg);
        GMF_XML_DrugGroup_controller drc = new GMF_XML_DrugGroup_controller(dgsc);
        drc.generateXML();
    }
    
}