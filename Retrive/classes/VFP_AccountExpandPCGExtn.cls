/*Purpose: Apex Class for displaying PCGs associated with  CRD for a Account.                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Sourabh Jain         07/25/2012       Apex Class for displaying PCGs associated with  CRD for a Account.   
======================================================================== */

public class VFP_AccountExpandPCGExtn {
    public List<TreeModel> nodeList {get;set;}
    public id accid{get;set;}
    public id AccountId{get;set;}
    public boolean BCTGroup{set;}
    
    //public Account acc{get{ return acc=[select id,name from account where id=:accid limit 1];}set;}
    public Account acc{get;set;}
    public VFP_AccountExpandPCGExtn(ApexPages.StandardController controller)
    {
        nodeList = new List<TreeModel>();
        AccountId = controller.getrecord().id;
        system.debug('--------Account Id------------'+AccountId);
        
        map<Id, List<CSAP_CGLP_Junction__c>> crd_JunList = new map<Id, List<CSAP_CGLP_Junction__c>>();
        
        list<CRD__c> crdLst = [SELECT Id, Name from CRD__c  where Account__c=:AccountId];
        system.debug('crdLst -- '+crdLst.size());
        for(CSAP_CGLP_Junction__c junTemp :[Select CRD__c,id,GLP_Group_Number__c,GLP_Plan_ID__c from CSAP_CGLP_Junction__c where CRD__c IN : crdLst])        
        {
            list<CSAP_CGLP_Junction__c> junTempLst = new list<CSAP_CGLP_Junction__c>();
            if(crd_JunList.ContainsKey(junTemp.CRD__c))
            {                
                junTempLst = crd_JunList.get(junTemp.CRD__c);
                junTempLst.add(junTemp);
            }else{               
                junTempLst.add(junTemp);
                crd_JunList.put(junTemp.CRD__c, junTempLst);
            }
        }
                
                for(CRD__c crd : crdLst){                
                    if(crd_JunList.ContainsKey(crd.Id) && (crd_JunList.get(crd.Id)).size() > 0)
                    {
                        TreeModel tm = new TreeModel();
                        tm.id = crd.Id;
                        tm.name = crd.name;
                        system.debug('crd  crd  -- '+crd.Name);
                        system.debug('Childs -- '+(crd_JunList.get(crd.Id)).size());
                        for(CSAP_CGLP_Junction__c cnt: crd_JunList.get(crd.Id))
                        {
                            TreeModel tmChild = new TreeModel();
                            tmChild.id = cnt.Id;
                            tmChild.name = cnt.GLP_Group_Number__c + ',' + cnt.GLP_Plan_ID__c;
                            tm.children.add(tmChild);                            
                        }
                        
                        nodeList.add(tm);                        
                    }
                }
                
    }
    
   
    
    public class TreeModel{
        public string id {get;set;}
        public string name {get;set;}
        public List<TreeModel> children {get;set;}
        
        public TreeModel(){
            children  = new List<TreeModel>();
        }
    
    }
    
     //Modification done by Rishabh Kushagra Bansal @ 16/7/2012 fo request 254
 
    Public boolean getBCTGroup(){
    boolean check = false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        system.debug('-----------------Profile----------- '+usrProfileName);
        if(usrProfileName =='BCT Manager'){
            check = true;
        }
        else if(usrProfileName =='BCT Consultant'){
            check=true;
        }
        else if(usrProfileName =='BCT Supervisor'){
            check=true;
        }
        else if(usrProfileName =='BCT Management'){
            check=true;
        }
        else if(usrProfileName =='System Administrator Primary'){
            check=true;
        }
        else if(usrProfileName =='System Administrator'){
            check=true;
        }
        else{
            check = false;
        } 
        return check;
    }
    
}