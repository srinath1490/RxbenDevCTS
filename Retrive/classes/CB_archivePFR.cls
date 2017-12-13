/*Purpose: Apex class to Archive PFR records 
================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Richa           17 Feb 2015       Apex class to Archive PFR records for Req 5555
=================================================================================================*/
public class CB_archivePFR{

    /**
    * Method :- onAfterUpdate 
    * Description :- This method takes list of CBONs as input and archives its child PFRs
    **/
    
    public static void onAfterUpdate(List<crdbuildorder__c> listCBONs){
    Set<ID> crdbuildIDs = new Set<ID>();
    List<Attachment> attachmentlist = new List<Attachment>();
    List<crdbuildorder__c> cbonToUpdate = new list<crdbuildorder__c>();
    List<crd__c> crdToUpdate = new list<crd__c>();
    Attachment pfrAttachment = new Attachment();
    String BPLVstring;
    String error1 = 'No PFRs/Attachment present';
    String error2 = 'PFRs are already archived'; 
    String error3 = 'PFRs are already archived, they should be deleted';   

        for(crdbuildorder__c crdborecord: listCBONs){    //collecting all the valid CBON IDs to be processed
                if(crdborecord.Pers_Full_Report__r.size() == 0 && crdborecord.Attachments.size() == 0) { //Exclude CBONs who neither have PFRs nor Attachment
                    crdborecord.Description__c = (crdborecord.Description__c != null ? crdborecord.Description__c + '+' + error1 : error1);
                } else if(crdborecord.Pers_Full_Report__r.size() != 0 && crdborecord.Attachments.size() == 0){
                         try{
                                String serializePFR = JSON.Serialize(crdborecord.Pers_Full_Report__r);
                                pfrAttachment = new Attachment();
                                pfrAttachment.Body = Blob.valueOf(serializePFR);
                                pfrAttachment.Name = String.valueOf(crdborecord.Name + '-ArchivedPFRs.txt');
                                pfrAttachment.Description = 'ArchivedPFRs';               
                                pfrAttachment.ParentId = crdborecord.ID;
                                attachmentlist.add(pfrAttachment);
                                crdborecord.Ready_to_Archive__c = true;
                                BPLVstring = '';        
                                crd__c crd = new crd__c(Id = crdborecord.crd__r.id);
                                for(Pers_Full_Report__c pfrRecord : crdborecord.Pers_Full_Report__r){
                                    BPLVstring += 'P'+CB_PcgFcgAutomationUtil.appendLeadingZero(3,String.valueof(pfrRecord.WS_PROV_NUM__c),'0')+'L'+CB_PcgFcgAutomationUtil.appendLeadingZero(3,String.valueof(pfrRecord.WS_LV_NO__c),'0')+',';    
                                }
                                crd.BPLV_String__c = BPLVstring.substring(0, BPLVstring.length()-1);
                                crdToUpdate.add(crd);
                            } catch(exception e) { //in case of any exception while creating an attachment, it should be added as a desciption on CBON field 
                                       crdborecord.Description__c = crdborecord.Description__c + e.getMessage();
                              }   
                       } else if (crdborecord.Pers_Full_Report__r.size() == 0 && crdborecord.Attachments.size() != 0) {
                             crdborecord.Description__c = (crdborecord.Description__c != null ? crdborecord.Description__c + '+' + error2 : error2);          
                         } else if (crdborecord.Pers_Full_Report__r.size() != 0 && crdborecord.Attachments.size() != 0) {
                             crdborecord.Description__c = (crdborecord.Description__c != null ? crdborecord.Description__c + '+' + error3 : error3);          
                             }
                cbonToUpdate.add(crdborecord); 
        }
        
        if(attachmentlist.size() != 0){ //Insert all the attachments
            Database.Insert(attachmentlist, false);
        }
        
        if(cbonToUpdate.size() != 0){  //Update all the CBONs
            update cbonToUpdate;
        }
            
        if(crdToUpdate.size() != 0){  //Update all the attached CRDs
            update crdToUpdate;
        }    
    }
}