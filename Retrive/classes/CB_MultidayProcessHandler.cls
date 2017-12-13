/*
Project: Aetna.8380

Requires: CRD__c, Task, Case,IntegrationLog__c,IntegrationLogger.cls
Description: Test_MultidayProcessHandler
*/
public without sharing class CB_MultidayProcessHandler{
   // Variables
   Map<String, CRDBuildOrder__c> mapCbonCPE;
   public List<CRD_BuilderFallout__c> failureRecords = new List<CRD_BuilderFallout__c>();
   public map<string,boolean> CP_overridden{get;set;}
   public Set<id> crdIdSet = new Set<id>();
   public Set<id> caseUpdate = new set<id>();
   public list<case> opencaseList = new list<case>();
   public map<string,CSAP_CGLP_Junction__c >  cpPCGMap= new map<string,CSAP_CGLP_Junction__c>();
   public map<string,CSAP_CGLP_Junction__c> cpFCGMap= new map<string,CSAP_CGLP_Junction__c>();
   public List<CRDBuildOrder__c> cbonWithoutRxplan = new List<CRDBuildOrder__c>();
   public map<id,CRD__c> oldToNewCRDMap = new map<id,CRD__C>();
   public map<id,crdbuildorder__c> newCRDToNewCBONMap = new map<id,crdbuildorder__c>();
   public map<id,CRD__c> manualCRDProcess= new map<id,CRD__c>();
   public set<String> setOfCPE = new set<String>();
   public map<String,CRDBuildOrder__c> mapOfCPECBON = new map<string,CRDBuildOrder__c>();
   public Set<id> crdSetofId = new set<id>();
   public boolean pcgCleared = FALSE;
   public boolean stopCRDFromIgnore = False;
   PRIVATE STATIC FINAL STRING PLANCHANGE = 'Plan Change';
   PRIVATE STATIC FINAL STRING SENTTOCVS = 'Sent To CVS';
   PRIVATE STATIC FINAL STRING CLOSED = 'Closed';
   PRIVATE STATIC FINAL STRING SUBJECT1 = 'CRD Builder fallout';
   PRIVATE STATIC FINAL STRING SUBJECT2 = 'CRD Success';
   PRIVATE STATIC FINAL STRING CASEOBJ = 'Case';
   PRIVATE STATIC FINAL STRING INTERNALRT = 'Internal CRD/GMF Process';
   PRIVATE STATIC FINAL STRING CSAPCGLP = 'CSAP_CGLP_Junction__c';
   PRIVATE STATIC FINAL STRING V1 = 'CRDB';
   PRIVATE STATIC FINAL STRING V2 = 'Newer CRD Case Received. CBON/CRD:';
   PRIVATE STATIC FINAL STRING V3 = 'CRD Name:';
   PRIVATE STATIC FINAL STRING V4 = 'CRD with newer plans for same CPE. CBON/CRD:';
   PRIVATE STATIC FINAL STRING V5 = 'This is an existing Rxplan CRD with newer plans for same CPE. CBON/CRD:';
   PRIVATE STATIC FINAL STRING BREAKLINE = '\r';
   PRIVATE STATIC FINAL STRING SPACE = ' ';
   PRIVATE STATIC FINAL STRING COLON = ':';
   PRIVATE STATIC FINAL STRING PLANDESCRIPTION = 'CBON with New Rxplanid waiting Archival';
   PRIVATE STATIC FINAL STRING IGNOREDDESCRIPTION = 'Ignored.Exisiting RxPlanId CBON with newer plans';
   PRIVATE STATIC FINAL STRING IGNORED = 'Ignored';
   PRIVATE STATIC FINAL STRING FALLOUTDESCRIBE = 'Newer Plans Found.RxPlanId was blank.';
   PRIVATE STATIC FINAL STRING ARCHIVED = 'Archived';
   PRIVATE STATIC FINAL STRING CRDTOPCG = 'CRD to Partial CG';
   PRIVATE STATIC FINAL STRING CRDTOFCG = 'CRD to Full CG';
   PRIVATE STATIC FINAL STRING DEDUPEDESCRIBE = 'Ignored by de-duping';
   PRIVATE STATIC FINAL STRING INDIVIDUAL = 'Individual';
   PRIVATE STATIC FINAL STRING DUPLICATE = 'Duplicate';
   PRIVATE STATIC FINAL STRING COMMA = ', ';
   PRIVATE STATIC FINAL STRING NULLOREMPTY = '';
   PRIVATE STATIC FINAL STRING ACCOUNTMISMATCHMESSAGE = 'The Account on the FCG/PCG does not match the Account on the CRD. Please correct.';
   PRIVATE STATIC FINAL STRING PCGDOESNOTEXIST = 'PCG does not exist with the matching Control Plan';
   PRIVATE STATIC FINAL STRING CAGRESTRUCTUREFAILURE = 'CAG Restructure Failure';
   PRIVATE STATIC FINAL STRING CBCAG = 'CB_CAG';
   
   
   public List<CVSRxPlanId__c> existingrxplaindsGlobal{get;set;}
  
   
   /*Method: processCBONs()*/
   public void processCBONs(List<CRDBuildOrder__c> listCRDBuildOrder){
      try{
        map<Id,String> crdControlPlanMap = new map<ID,String>();
        
       // STEP-1 : Query All CBONS where BUILD, Valid , Complete , AI Callout = TRUE and PERS, CAG , XML, PDF, CVS = FALSE  
       // Mark all older CBONS and CRD as ignored 
       //string queryString = 'SELECT Account_Name__c,Age__c,Aicallout__c,AIRealtime__c,Audit_UI_Link__c,Build__c,builtRealTime__c,CAGRealtime__c,CAG__c,Carrier_ID__c,Case__c,completeChkRealTime__c,complete__c,Conga_Solution_URL__c,ConnectionReceivedId,ConnectionSentId,ControlPlanEffective__c,ControlPlan__c,Control_Plan_Effective__c,Control__c,CRD_RxPlan_ID__c,CRD_Salesforce_ID__c,CRD__c,CreatedById,CreatedDate,CurrentStatusCRD__c,CVS__c,Daysforcompletion__c,Description__c,DirectSuccess__c,Effective_date__c,ExistingRxplan__c,FalloutCase__c,Id,Ignored__c,Invalid__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,PDFRealtime__c,PDF__c,PERSTimeStamp__c,Pers_Full__c,Pers_Key__c,PERS_timestamp__c,PERS__c,Plan__c,Processed__c,Ready_to_Archive__c,Sent_AI_request__c,Sent_to_CVS_Date__c,Status__c,Subsegment__c,Success_Case__c,SystemModstamp,validatedRealTime__c,valid__c,What_is_the_carrier__c,XMLRealtime__c,XML__c FROM CRDBuildOrder__c WHERE Build__c = true AND valid__c = true AND complete__c != true AND Aicallout__c = true AND PERS__c = false AND CAG__c = false AND XML__c = false AND PDF__c = false AND CVS__c = false order by Control_Plan_Effective__c , PERSTimeStamp__c , createddate desc';
       mapCbonCPE = queryOrderedCBONS(listCRDBuildOrder);
        map<string,recordtype> rtNameMap = new map<string,recordtype>();
        for(recordtype tempRT : [select id,sobjecttype,name from recordtype where sobjecttype = :CSAPCGLP LIMIT 100000]){
            rtNameMap.put(tempRT.name,tempRT);
        }
         
       Map<String, List<CRDBuildOrder__c>> mapControlPlansToBuilders = new Map<String, List<CRDBuildOrder__c>>();
         
    //Consildate all the controlplan strings
       set<string> populateCP_Set = new set<string>();
       for(CRDBuildOrder__c cbon : mapCbonCPE.values()){
            String control=NULLOREMPTY;
            
            Control = String.valueOf(cbon.Control__c.round());   
                   
            populateCP_Set.add(GC_Utils_Method.calculateControl(Control)+SPACE+cbon.Plan__c);  
                 
       }
       
    //get all the existing rxplanids
       /*
        existingrxplaindsGlobal = [select id,RxPlanId__c,CRD_Name__c from CVSRxPlanId__c where RxPlanId__c in :rxplanids LIMIT 100000];
        
        map<string,CVSRxPlanId__c> rxplanCVSMAP = new map<string,CVSRxPlanId__c>();
        for(CVSRxPlanId__c temprxplanrec : existingrxplaindsGlobal ){
            rxplanCVSMAP.put(temprxplanrec.RxPlanId__c,temprxplanrec);
        }   
       */
       
       map<string,list<CSAP_CGLP_Junction__c>> pcgs_ControlPlan = new map<string,list<CSAP_CGLP_Junction__c>>();
    
    //Get all the CSAP records for the controlpllan to find FOUND CRD ( these can be created manually or through CRB builder)
       pcgs_ControlPlan = fetchPCGsbyCP(populateCP_Set);
       
    //Get all the FCG linked to the fetched PCGs from CSAP junction having record type PCG to FCG
       Map<string,map<id,List<CSAP_CGLP_Junction__c>>> fCG_PCG_ControlPlanMASTER = fetchFCGsbyPCG(populateCP_Set);
       
       list<Partial_Control_Group__c> pcgs = [select id,CSAP_control_plan__c,account__C from Partial_Control_Group__c where CSAP_control_plan__c in :populateCP_Set LIMIT 100000];
       map<string,Partial_Control_Group__c> cP_PCG = new map<string,Partial_Control_Group__c>();
       for(Partial_Control_Group__c temppcg : pcgs){
            cP_PCG.put(temppcg.CSAP_control_plan__c,temppcg);
       }
       //get ids for all the pcgs
       set<id> crdids = new set<id>();
       CP_overridden = new map<string,boolean>();
       
       for(list<CSAP_CGLP_Junction__c> csapPCGlist : pcgs_ControlPlan.values()){
            for(CSAP_CGLP_Junction__c tempcsap : csapPCGlist){
                if(!crdids.contains(tempcsap.crd__c)){
                    crdids.add(tempcsap.crd__c);
                }
                    
            }
       }
       
       
       //List of found CRDs
       list<crd__C> crdlist = [select id,Effective_Date__c,PERS_timestamp__c,Partial_Control_Group__c,Full_Control_Group__c from crd__c where id in :crdids LIMIT 100000];
       //Archive CRD list
       list<crd__C> crdArchivelist = new list<crd__C>();
       //Collect fcgs based on PCG per CP
       Map<string,List<CSAP_CGLP_Junction__c>> fCG_PCG_ControlPlan = new Map<string,List<CSAP_CGLP_Junction__c>>();
       map<string,Crd__C> cP_currentcrd = new map<string,crd__C>();
       //Check if currentCRD needs to be overridden
       Set<String> falloutControlPlan = new Set<String>();
       list<CSAP_CGLP_Junction__c> todeleterecords = new list<CSAP_CGLP_Junction__c>();
       //captures current CRDid for which CSAPs(CRD-PCG & CRD-FCG) are to be deleted
       set<Id> currentCRDidSet = new Set<Id>();

    //Run For loop on the latest CBONs in the current batch
       CSAP_CGLP_Junction__c temppcg;
        list<CSAP_CGLP_Junction__c> templist;
        
       for(string CPE : mapCbonCPE.keyset()){
       
            //getCurrent CBON and CRD and populate local variables
            crdbuildorder__c currentcbon = mapCbonCPE.get(cpe);
                      
           
        //get current crd from cbon
            crd__c currentcrd = currentcbon.crd__r; 
                  
            string controlplan = GC_Utils_Method.calculateControl(String.valueOf(currentcbon.control__c.round())) + SPACE + currentcbon.plan__c ;
            boolean local_crdovverriddent = false;
            CP_overridden.put(CPE,false);
            CP_currentcrd.put(CPE,Currentcrd);
        //get the found PCGs , this is equivalent to found CRDs as we find found CRDs based on CSAP junctions
            
            list<CSAP_CGLP_Junction__c> foundPCGs = pcgs_ControlPlan.get(controlplan);
            //Iterate on the found CRDs
            
            if(foundPCGs != null && foundPCGs.size() > 0){
                
                for(CSAP_CGLP_Junction__c tempPCS :foundPCGs){
            //Check if the Effective date is same and the csap records is attached to crd other than current crd
                 
                    
                    if(tempPCS.crd__r!= null && tempPCS.crd__r.Effective_Date__c == Currentcrd.Effective_date__c && tempPCS.crd__c != currentcrd.id){
            //check which CRD has latest PERSTIMESTAMP
                        if(tempPCS.crd__r.PERS_timestamp__c >= Currentcrd.PERS_timestamp__c ){
                            //Archive current crd
                //If current crd is not the latest CRD for that CPE and perstimestamp we should archive it and set crd_override to true.
                            local_crdovverriddent = true;
                            CP_overridden.put(CPE,true);
                            
                                                        //CP_currentcrd.put(CPE,Currentcrd);
                            
                //Add current crd to archive list
                            crdArchivelist.add(Currentcrd);
                            crdControlPlanMap.put(Currentcrd.id,GC_Utils_Method.calculateControl(tempPCS.crd__r.control__c)+SPACE+tempPCS.crd__r.plan__c);
                           
                            if(tempPCS.crd__r.id != NULL && currentCRD.id != NULL ){
                                oldToNewCRDMap.put(Currentcrd.id,tempPCS.crd__r); // this will relate old CRD to New CRD
                                crdSetofId.add(tempPCS.CRD__r.id);
                            }
                            currentcrd = tempPCS.crd__r;
                            
                        }
                        else{                            
                            //Archive found crd
                //In case found crd is not the latest one we need to add the found crd to Archive list  
                            crdArchivelist.add(tempPCS.crd__r);
                            crdControlPlanMap.put(tempPCS.crd__r.id,GC_Utils_Method.calculateControl(Currentcrd.control__c)+SPACE+Currentcrd.plan__c);
                            if(tempPCS.crd__r.id != NULL && currentCRD.id != NULL ){
                                oldToNewCRDMap.put(tempPCS.crd__r.id,currentCRD);
                                crdSetofId.add(currentCRD.id);
                            }
                            
                             // to check more crd we have or not
                            
                        }
                    }
                    else{       
            //In case of manual CRDs we will have CSAP junctions already created, delete the already created CSAP junction and create new linkages  
                        
                        
                        if(tempPCS.crd__c == currentcrd.id){
                            todeleterecords.add(tempPCS);
                            currentCRDIDSet.add(tempPCS.crd__c);
                        }
                        
                        //Consolidate FCGs based on PCGs
                        list<CSAP_CGLP_Junction__c> tempFCGs = new list<CSAP_CGLP_Junction__c>();
                        //Consolidate all the PCG and FCG of the archiving CRD
                        if(FCG_PCG_ControlPlan.containskey(controlplan)){
                            tempFCGs = FCG_PCG_ControlPlan.get(controlplan);
                        }
                            
                        if(FCG_PCG_ControlPlanMASTER.containskey(controlplan) && FCG_PCG_ControlPlanMASTER.get(controlplan).containskey(tempPCS.Partial_Control_Group__c)){
                            tempFCGs.addall(FCG_PCG_ControlPlanMASTER.get(controlplan).get(tempPCS.Partial_Control_Group__c));
                        }
                            
                        FCG_PCG_ControlPlan.put(controlplan,tempFCGs);
                        
                        
                    }
                }
                for(crdbuildorder__c cbonRec : [select id,name,crd__c,CRD__r.name from crdbuildorder__c where crd__c IN :crdSetofId limit 10000]){
                    
                    if(cbonRec != null){
                        if(!newCRDToNewCBONMap.containsKey(cbonRec.crd__c)){
                            newCRDToNewCBONMap.put(cbonRec.crd__c,cbonRec);
                        }
                    }
                }
            }
            else{
                controlplan = GC_Utils_Method.calculateControl(String.valueOf(currentcbon.control__c.round())) + SPACE + currentcbon.plan__c ;
                
                if(cP_PCG.containskey(controlplan)){
            //in case no junction record is created in case its a new PCG , Add a dummy record to the found PCG , this will be used to create actual PCGs and FCGs
                    temppcg = new CSAP_CGLP_Junction__c();
                    //CP_overridden.put(CPE,true);
                    temppcg.Partial_Control_Group__c = cP_PCG.get(controlplan).id;
                    temppcg.Partial_Control_Group__r = cP_PCG.get(controlplan);
                    temppcg.crd__C = Currentcrd.id;
                    templist = new list<CSAP_CGLP_Junction__c>();
                    templist.add(temppcg);
                    pcgs_ControlPlan.put(controlplan,templist);
                    
                }
                else{
                    //TODO add a fallout case
            //In case no PCG is found either attached to older CBONs or throgh  ControlPLan create a fallout case
                    falloutControlPlan.add(controlplan);
                    mapCbonCPE.remove(controlplan);
                    if(mapControlPlansToBuilders.containsKey(controlplan)){
                        mapControlPlansToBuilders.get(controlplan).add(Currentcbon);
                    }else{
                        mapControlPlansToBuilders.put(controlplan, new List<CRDBuildOrder__c>{ Currentcbon});
                    }
                                  
                }

            }
       }

    //Create crdbuildfallout records
       if(! falloutControlPlan.isEmpty()){
            this.createFallout(mapControlPlansToBuilders, falloutControlPlan, PCGDOESNOTEXIST);
       }
       mapControlPlansToBuilders = new Map<String, List<CRDBuildOrder__c>>();
        falloutControlPlan = new set<string>();

    
        //Attach junctions to currentcrd
        list<CSAP_CGLP_Junction__c> foundPCGsnew = new list<CSAP_CGLP_Junction__c>();
        list<crdbuildorder__C> toUpdateCBONs = new list<crdbuildorder__C>();
        List<CRDBuildOrder__c> cagUpdateCBON = new List<CRDBuildOrder__c>();
         set<id> crdId = new set<id>();
         if(crdArchivelist.size()>0 || crdArchivelist!=null){
              for(CRD__c cr : crdArchivelist){
                    crdId.add(cr.id);
              }
          }
    //Iterate throgh latest cbons.
        set<id> pCGattached ;
        list<CSAP_CGLP_Junction__c> tempPCGsnew;
       for(string CPE : mapCbonCPE.keyset()){
            if(!CP_overridden.get(CPE)){
                
            crdbuildorder__c currentcbon = mapCbonCPE.get(cpe);
            crd__c currentcrd = CP_currentcrd.get(CPE);
            setOfCPE.add(currentcbon.ControlPlanEffective__c);
            string controlplan = GC_Utils_Method.calculateControl(String.valueOf(currentcbon.control__c.round())) + SPACE + currentcbon.plan__c ;
            mapOfCPECBON.put(currentcbon.ControlPlanEffective__c,currentcbon);
            list<CSAP_CGLP_Junction__c> foundPCGs = pcgs_ControlPlan.get(controlplan);
            tempPCGsnew = new list<CSAP_CGLP_Junction__c>();
            

        //By now we have consildate the PCGs and FCGs. WE need to create CSAP records to link to the latest CBON/CRD
            if(foundPCGs != null && foundPCGs.size() != 0){
                pCGattached = new set<id>();
                Boolean pCGErrorFound = false;
                
                for(CSAP_CGLP_Junction__c tempcsapjunc :foundPCGs){
                        //Create CSAP record of type CRD to Partial CG
                CSAP_CGLP_Junction__c pCGnewrec = tempcsapjunc.clone(false,true);
                        PCGnewrec .crd__C = Currentcrd.id;
                        PCGnewrec.recordtypeid = rtNameMap.get(CRDTOPCG).id;
                        if(!PCGattached.contains(tempcsapjunc.partial_Control_Group__c)){
                            tempPCGsnew.add(PCGnewrec);
                            PCGattached.add(tempcsapjunc.partial_Control_Group__c);
                        }
                        if(tempcsapjunc.Full_Control_Group__c != null){
                            Currentcrd.Full_Control_Group__c = tempcsapjunc.Full_Control_Group__c;
                        }
                            
                        if(tempcsapjunc.partial_Control_Group__c != null){
                            Currentcrd.partial_Control_Group__c = tempcsapjunc.partial_Control_Group__c;
                        }
                            
                        
                        if(currentcrd.account__C != tempcsapjunc.partial_Control_Group__r.account__C){
                            falloutControlPlan.add(controlplan);
                            PCGErrorFound = true;
                            
                            if(mapControlPlansToBuilders.containsKey(controlplan)){
                                mapControlPlansToBuilders.get(controlplan).add(Currentcbon);
                            }else{
                                mapControlPlansToBuilders.put(controlplan, new List<CRDBuildOrder__c>{ Currentcbon});
                            }
                            
                        }
                            
                    }

                    
                    if(Currentcrd.partial_Control_Group__c == null && cP_PCG.containskey(controlplan)){
                        Currentcrd.partial_Control_Group__c  = cP_PCG.get(controlplan).id;
                        
                    }
                    //Create CSAP record of type CRD to Partial CG
                    if(FCG_PCG_ControlPlanMASTER.containskey(controlplan) && FCG_PCG_ControlPlanMASTER.get(controlplan).containskey(Currentcrd.partial_Control_Group__c )){
                        list<CSAP_CGLP_Junction__c> foundFCGs = FCG_PCG_ControlPlanMASTER.get(controlplan).get(Currentcrd.partial_Control_Group__c );
                        for(CSAP_CGLP_Junction__c tempcsapjunc :foundFCGs){
                            CSAP_CGLP_Junction__c fCGnewrec = tempcsapjunc.clone(false,true);
                            FCGnewrec .crd__C = Currentcrd.id;
                            FCGnewrec .partial_control_group__C = null;
                            FCGnewrec.recordtypeid = rtNameMap.get(CRDTOFCG).id;
                            tempPCGsnew.add(FCGnewrec );
                            if(tempcsapjunc.Full_Control_Group__c != null){
                                Currentcrd.Full_Control_Group__c = tempcsapjunc.Full_Control_Group__c;
                            }
                                
                            if(tempcsapjunc.partial_Control_Group__c != null){
                                Currentcrd.partial_Control_Group__c = tempcsapjunc.partial_Control_Group__c;
                            }
                                
                                
                            
                            if(currentcrd.account__C != tempcsapjunc.full_Control_Group__r.account_name__C){
                                falloutControlPlan.add(controlplan);
                                PCGErrorFound = true;
                                
                                if(mapControlPlansToBuilders.containsKey(controlplan)){
                                    mapControlPlansToBuilders.get(controlplan).add(Currentcbon);
                                }else{
                                    mapControlPlansToBuilders.put(controlplan, new List<CRDBuildOrder__c>{ Currentcbon});
                                }
                                
                            }                               
                        }
                    }
            //In case we dont have any PCG to attach create a fallout records.
                    if(PCGErrorFound){
                        mapCbonCPE.remove(controlplan);
                    }
                    else{
                        foundPCGsnew.addall(tempPCGsnew);
                        if(!CP_overridden.get(CPE))
                            toUpdateCBONs.add(currentcbon);
                    }
                    
                    
                    //TO DO Create junction records using FCG_PCG_ControlPlan variable based on controlplan
                    //TO DO Also need to set screen 2 variables based on FCG_PCG_ControlPlan
                }
                    
                //}
                if(currentcbon.cag__c == False && !crdId.contains(currentcbon.crd__c)){
                   currentcbon.cag__c = true;
                   
                   cagUpdateCBON.add(currentcbon);
                 
                }
                
           
        }
    }
    
   
       if(! falloutControlPlan.isEmpty()){
            this.createFallout(mapControlPlansToBuilders, falloutControlPlan, ACCOUNTMISMATCHMESSAGE);
       }     
        
       
       List<CSAP_CGLP_Junction__c> csapRecordForDeletion;
       if(currentCRDIDSet.size()>0) {
           csapRecordForDeletion = [SELECT id,CRD__c,Full_Control_Group__c,Partial_Control_Group__c from CSAP_CGLP_Junction__c 
                                    where CRD__c IN :currentCRDIDSet LIMIT 100000];
          
            if(csapRecordForDeletion.size() > 0 ){
                database.delete (csapRecordForDeletion);
            }
       }
       
       database.insert(foundPCGsnew);
       
       database.update(toUpdateCBONs);
       //if(todeleterecords.size() > 0)
       //    delete todeleterecords;
       

        
       //update mapCbonCPE.values();
       
       database.Update(CP_currentcrd.values());
       database.update(cagUpdateCBON);
       //Archive the CRDs( other than latest CBON either in current batch or exiting in system)
       if(crdArchivelist!= null || crdArchivelist.size()>0){
           
           subprocessArchive(crdArchivelist,crdControlPlanMap,newCRDToNewCBONMap);
       }
        List<CRDBuildOrder__c> cbonwithoutRxplanId = [select name,Control__c,plan__c,CRD__r.Pers_timestamp__c,CRD__r.name,ControlPlanEffective__c,FalloutCase__c,
                                                   FalloutCase__r.Reason,FalloutCase__r.Review_Notes__c,crd__r.status__c,crd__r.ignored__c,
                                                   crd__r.Partial_Control_Group__c,crd__r.Full_Control_Group__c,Success_Case__c,Success_Case__r.Status
                                                   from 
                                                   CRDBuildOrder__c where 
                                                       ControlPlanEffective__c IN: setOfCPE AND 
                                                       CRD_RxPlan_ID__c = Null AND Ignored__c = False limit 10000];                                             
    List<CRDBuildOrder__c> cbonWithoutRxplanToBeIgnored = new List<CRDBuildOrder__c>();
        if(cbonwithoutRxplanId.size()>0 && mapOfCPECBON.size()>0){
            for(CRDBuildOrder__c crdBO:cbonwithoutRxplanId){
                if(crdBO.CRD__r.Pers_timestamp__c < mapOfCPECBON.get(crdBO.ControlPlanEffective__c).CRD__r.Pers_timestamp__c){
                    cbonWithoutRxplanToBeIgnored.add(crdBO);
                }
            }
        
            string FailureDescription = FALLOUTDESCRIBE;
            if(cbonWithoutRxplanToBeIgnored.size()>0){
                markignored(cbonWithoutRxplanToBeIgnored,mapOfCPECBON,FailureDescription);
            }
        }
    }
         catch (Exception e){
             throw e;
         }  
    }
  
    //Find FCG by PCG
    /*Method: fetchFCGsbyPCG()*/
    public Map<string,map<id,List<CSAP_CGLP_Junction__c>>> fetchFCGsbyPCG(Set<String> populateCP_Set){
        // Set<String> populateCP_Set = new set<string>();
        
            Map<string,map<id,List<CSAP_CGLP_Junction__c>>> csapcglpMap = new Map<string,map<id,List<CSAP_CGLP_Junction__c>>>();
            
            map<id,List<CSAP_CGLP_Junction__c>> newCsapCglpmap;
            List<CSAP_CGLP_Junction__c> newCsapCglplist;
        //Fetch all the CSAP records of type PArtial To full CG
           
        //Group then by Control plan and PCG
        try{
            for(CSAP_CGLP_Junction__c cg: [SELECT id,CRD__c,CRD__r.name,CRD__r.Effective_Date__c,crd__r.PERS_timestamp__c,crd__r.Plan__c,crd__r.control__c,Full_Control_Group__c,
                                          Partial_Control_Group__c,Partial_Control_Group__r.CSAP_control_plan__c ,crd__r.account_name__C,Partial_Control_Group__r.account__C,
                                          full_Control_Group__r.account_name__c
                                          From 
                                            CSAP_CGLP_Junction__c 
                                         Where 
                                            Partial_Control_Group__r.CSAP_control_plan__c IN :populateCP_Set 
                                         AND
                                            Partial_Control_Group__c != null 
                                         AND 
                                            Full_Control_Group__c != null 
                                         AND 
                                            CRD__r.Ignored__c = FALSE limit 10000])
            {
                newCsapCglpmap = new map<id,List<CSAP_CGLP_Junction__c>>();
                newCsapCglplist = new List<CSAP_CGLP_Junction__c>();
                if(csapcglpMap.containsKey(cg.Partial_Control_Group__r.CSAP_control_plan__c))
                {               
                    newCsapCglpmap = csapcglpMap.get(cg.Partial_Control_Group__r.CSAP_control_plan__c);
                }
                if(newCsapCglpmap.containskey(cg.Partial_Control_Group__c)){
                    newCsapCglplist = newCsapCglpmap.get(cg.Partial_Control_Group__c);
                }
                newCsapCglplist.add(cg);
                newCsapCglpmap.put(cg.Partial_Control_Group__c,newCsapCglplist);
                csapcglpMap.put(cg.Partial_Control_Group__r.CSAP_control_plan__c,newCsapCglpmap);
            } 
         }
         
         catch(Exception e){
             throw e;
         }   
         return csapcglpMap;
    }   

   //Query ORdered CBON 
   // This method marks older CBON based on control plan effective to ignore
   // Also it will only process only the latest CBON in the current batch
   /*Method:queryOrderedCBONS()*/
   public Map<String,CRDBuildOrder__c> queryOrderedCBONS(list<CRDBuildOrder__c> queryOrderedCBONSlst){
       
           
            Map<String,CRDBuildOrder__c> queryOrderedCBONSMAP = new Map<String,CRDBuildOrder__c>();
            map<String,crdBuildOrder__c> blankCBONMap = new map<String,crdBuildOrder__c>();
            list<CRDBuildOrder__c> ignoreCBONS = new list<CRDBuildOrder__c>();
            // Commented to convert it to Batch process
            //list<CRDBuildOrder__c> queryOrderedCBONSlst = database.query(qs);
            set<String> rxplanids = new set<string>();
            try{
            for(CRDBuildOrder__c cb: queryOrderedCBONSlst){
                
                if(!rxplanids.contains(cb.CRD_RxPlan_ID__c) && cb.CRD_RxPlan_ID__c !=null && cb.CRD_RxPlan_ID__c != NULLOREMPTY){
                    rxplanids.add(cb.CRD_RxPlan_ID__c);
                }
                
                if(cb.CRD_RxPlan_ID__c == null || cb.CRD_RxPlan_ID__c == NULLOREMPTY){
                    cbonWithoutRxplan.add(cb);
                    
                }
                
            }
            
            map<string,CVSRxPlanId__c> rxplanCVSMAP = new map<string,CVSRxPlanId__c>();
            for(CVSRxPlanId__c temprxplanrec : [select id,RxPlanId__c,CRD_Name__c from CVSRxPlanId__c where RxPlanId__c in :rxplanids limit 10000]){
                rxplanCVSMAP.put(temprxplanrec.RxPlanId__c,temprxplanrec);
            }
            
            /*for(CRDBuildOrder__c cb: queryOrderedCBONSlst){
                if(rxplanCVSMAP.containskey(cb.CRD_RxPlan_ID__c)){
                    ignoreCBONS1.add(cb);
                
                }
            }*/
            //iterate on cbons ordered by their created date
            for(CRDBuildOrder__c tempCBON: queryOrderedCBONSlst ){
                string control = String.valueOf(tempCBON.Control__c.round());   
                // Added RxplanId to Group by CBON based on CPE, RxPlan ID        
                String controlPlanEffectiveRxPlanId = GC_Utils_Method.calculateControl(Control) + tempCBON.Plan__c + tempCBON.effective_date__C + tempCBON.CRD_RxPlan_ID__c;
                
                if(!queryOrderedCBONSMAP.containskey(ControlPlanEffectiveRxPlanId)){
                    //Add it to map in case it is the latest
                    queryOrderedCBONSMAP.put(ControlPlanEffectiveRxPlanId,tempCBON);
                }
                else{
                    //in case we have already found a matching cbon based on CPE we need to add this cbon to ignore list
                    ignoreCBONS.add(tempCBON);
                    //To DO Ignore cbons and their repective CRD's
                }
            }
            string dedupedescription = DEDUPEDESCRIBE;
            markignored(ignoreCBONS,blankCBONMap,dedupedescription);
           
           // markignored(ignoreCBONS1);
           
       }
       catch(Exception e){
           throw e;
       }
        return queryOrderedCBONSMAP;
   }  
  
    /*Method:fetchPCGsbyCP()*/
   public Map<string,List<CSAP_CGLP_Junction__c>> fetchPCGsbyCP(Set<String> populateCP_Set){
       
           // Set<String> populateCP_Set = new set<string>();
            map<string,List<CSAP_CGLP_Junction__c>> csapcglpMap = new map<string,List<CSAP_CGLP_Junction__c>>();
            List<CSAP_CGLP_Junction__c> newCsapCglpList;              
            for(CSAP_CGLP_Junction__c cg: [SELECT id,CRD__c,full_Control_Group__c,crd__r.control__c,crd__r.plan__c,CRD__r.name,CRD__r.Partial_Control_Group__c,CRD__r.full_Control_Group__c,
                                          CRD__r.Effective_Date__c,crd__r.PERS_timestamp__c,crd__r.RxPlanID__c,Partial_Control_Group__c,Partial_Control_Group__r.CSAP_control_plan__c ,crd__r.account_name__C,
                                          Partial_Control_Group__r.account__C,full_Control_Group__r.account_name__c
                                          From 
                                            CSAP_CGLP_Junction__c 
                                          Where 
                                            Partial_Control_Group__r.CSAP_control_plan__c IN :populateCP_Set 
                                          AND 
                                            Partial_Control_Group__c != null 
                                          AND 
                                            Full_Control_Group__c = null 
                                          AND 
                                            CRD__r.Ignored__c = FALSE limit 10000]){
                             
            try
           {
              newCsapCglpList = new List<CSAP_CGLP_Junction__c>();
              if(!csapcglpMap.containsKey(cg.Partial_Control_Group__r.CSAP_control_plan__c))
                {
                    newCsapCglpList.add(cg);
                    csapcglpMap.put(cg.Partial_Control_Group__r.CSAP_control_plan__c,newCsapCglpList);
                }
               else
               {
                    newCsapCglpList = csapcglpMap.get(cg.Partial_Control_Group__r.CSAP_control_plan__c);
                    newCsapCglpList.add(cg);
                    csapcglpMap.put(cg.Partial_Control_Group__r.CSAP_control_plan__c,newCsapCglpList);
                    }
           } 
           
       catch(Exception e){
           throw e;
       }
     }
       return csapcglpMap;
  }
    //This method marks the older CBONs to ignore and set all the flags to true so that the older cbons are not picked by any sufficing batches
    /*Method:markIgnored()*/
    Public void markIgnored(List<CRDBuildOrder__c> cbonList,map<String,CRDBuildOrder__c> currentCBON,string description){
        try{
            
        
            set<id> caseCloseId = new set<id>();
            set<id> ignoredCRDId = new set<id>();
            List<case> closeFalloutcase = new List<case>();
            //list<CRDBuildOrder__c> cbonList = new list<CRDBuildOrder__c>();
            list<crd__c> crdList = new list<crd__c>();
              //Set<ID> idSet = new Set<Id>();
             //CRDBuildOrder__c cbon = new CRDBuildOrder__c();
            //cbonList = [SELECT id,crd__c,crd__r.ignored__c from CRDBuildOrder__c where Name IN ('CBON-055229','CBON-055217')];
           //Set all the processing flags to true
            set<String> controlPlanString = new set<String>();
            for(CRDBuildOrder__c cb: cbonList){
                cb.Ignored__c = TRUE;
                cb.Aicallout__c = TRUE;
                cb.AIRealtime__c = TRUE;
                cb.Build__c = TRUE;
                cb.builtRealTime__c = TRUE;
                cb.CAG__c = TRUE;
                cb.CAGRealtime__c = TRUE;
                cb.complete__c = TRUE;
                cb.completeChkRealTime__c = TRUE;
                cb.CVS__c = TRUE;
                // cb.ExistingRxplan__c = TRUE;
                cb.PDF__c = TRUE;
                cb.PDFRealtime__c = TRUE;
                cb.PERS__c = TRUE;
               //cb.PostBuildOnly__c = TRUE;
                cb.Processed__c = TRUE;
                //cb.Ready_to_Archive__c = TRUE;
                cb.Sent_AI_request__c = TRUE;
                cb.valid__c = TRUE;// need to check this to know that the CBON is valid or not
                cb.validatedRealTime__c = TRUE;
                cb.XML__c = TRUE;
                cb.XMLRealtime__c = TRUE;
                cb.Description__c = description;
               // Added for Story 06244
               String controlplan = GC_Utils_Method.calculateControl(String.valueOf(cb.control__c.round())) + SPACE + cb.plan__c ;
               controlPlanString.add(controlplan);
               if(cb.Success_Case__c != null){
               
                    caseCloseId.add(cb.Success_Case__c);
                    }
                if(cb.FalloutCase__c !=null){
                    cb.FalloutCase__r.status = CLOSED;

                    if(currentCBON.size()>0 ){
                         cb.FalloutCase__r.Reason = DUPLICATE;
                         string newCBONName = currentCBON.get(cb.ControlPlanEffective__c).Name;
                         string newCRDName = currentCBON.get(cb.ControlPlanEffective__c).CRD__r.name;
                         if(cb.FalloutCase__r.Review_Notes__c != null && cb.FalloutCase__r.Review_Notes__c !=NULLOREMPTY){
                             
                             cb.FalloutCase__r.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON+SPACE + V4 +SPACE+ newCBONName  +SPACE+COMMA+ V3 + newCRDName  + BREAKLINE + cb.FalloutCase__r.Review_Notes__c ;
                         }
                        else{
                              cb.FalloutCase__r.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON+SPACE + V4 +SPACE+ newCBONName  +SPACE+COMMA+ V3 + newCRDName ;
                        }
                    }
                    closeFalloutcase.add(cb.FalloutCase__r);
                }
               if(cb.crd__r != null && !stopCRDFromIgnore){
                    cb.crd__r.status__c = IGNORED;
                    cb.crd__r.ignored__c = TRUE;
                    if(cb.crd__r.Partial_Control_Group__c != null || cb.crd__r.Full_Control_Group__c != null){
                       cb.crd__r.Partial_Control_Group__c = null;
                       cb.crd__r.Full_Control_Group__c = null;
                    }
                    crdList.add(cb.crd__r);
                    ignoredCRDId.add(cb.CRD__c);// Added for Story 06371
               }
            }
           List<CSAP_CGLP_Junction__c> deleteCSAPAttachedToIgnoredCRD = [select name,CRD__c from CSAP_CGLP_Junction__c where CSAP_Control_Plan__c IN : controlPlanString AND CRD__c IN:ignoredCRDId limit 10000];// Added for Story 06371
            List<case> listofCasetoClose = new List<Case>();
                for(case cs : [select id,status from case where id in:caseCloseId limit 10000])
                {
                    cs.Status = CLOSED;
                    ListofCasetoClose.add(cs);
                } 
            database.update(closeFalloutcase);
            database.update(ListofCasetoClose);
            database.update(cbonList);
            database.update(crdList);
            database.delete(deleteCSAPAttachedToIgnoredCRD); 
        }
        catch (Exception e){
            throw e;
        }
    }
    /** Method :- subprocessArchive()
      * Description :- This method will be used to mark crd's to aarchive state.While archiving , we only archive the CBONs which are already share
                      to CVS, in case the crd is not shared to CVS we mark them ignore..
     **/
    Public void subprocessArchive(List<CRD__c> crdList,map<ID,String> crdidPlan,map<id,crdbuildorder__c> newCRDNewCBONMap){
    try{        
        map<id,crd__c> crdMonitorMap = new map<id,crd__c>();
        Map<crdbuildorder__c,crd__c> ignoredCBONSCRDMap = new Map<crdbuildorder__c,CRD__c>();
        map<String,CRDBuildOrder__c> blankCBONInstance = new map<String,CRDBuildOrder__c>();
        list<crdbuildorder__c> ignoredCBONS = new list<crdbuildorder__c>();
        list<case> caseList = new list<case>();
        map<string,crd__c> crdRxplanId = new map<string,crd__c>();
        set<id> ignoredCRDId = new set<id>();// set to delete CSAP junction record in case of CRD being ignored due to existing RxplanId
        List<Case> ignoreCBONFalloutCase = new List<case>();
        if(crdList!=null || crdList.size()>0){
          for(CRD__c crdRecord : crdList){
            crdMonitorMap.put(crdRecord.id,crdRecord);
            crdRxplanId.put(crdRecord.RxPlanID__c,crdRecord);
          }
        }
        List<CVSRxPlanId__c> existingrxplaindsGlobal = [select id,RxPlanId__c,CRD_Name__c from CVSRxPlanId__c where RxPlanId__c in :crdRxplanId.keyset() Limit 10000];
        set<string> rxplanids = new set<string>();
        list<CSAP_CGLP_Junction__c> toDeleteCsapCglpList = new list<CSAP_CGLP_Junction__c>();
        // map of CRD with a check to identifyarchive action to be taken on CRD/CBON 
        map<id,boolean> crdArchiveChk = new map<id,boolean>();
        map<id,List<String>> crdPCGControlPlanMap = new map<id,List<string>>();
        map<id,List<String>> crdFCGControlPlanMap = new map<id,List<String>>();
        //match control plan
        
        list<crdbuildorder__C> crdcbon = [select id,name,crd__c,crd__r.name,cvs__c,ExistingRxplan__c,CRD_RxPlan_ID__c,falloutcase__c,FalloutCase__r.Review_Notes__c,FalloutCase__r.Status,case__r.Review_Notes__c,case__r.Event_Notification_Review_Results__c,case__r.status,Control__c,Plan__c,Success_Case__c from crdbuildorder__C where crd__c in :crdMonitorMap.keyset() LIMIT 100000];
        map<id,crdbuildorder__C> crdcbonmap= new map<id,crdbuildorder__C>();
        for(crdbuildorder__C tempcbon :crdcbon){
            crdcbonmap.put(tempcbon.crd__c,tempcbon);
           }
           
           
            //Delete all the CSAP junctions for the archived/Ignored CRDs
        for(CSAP_CGLP_Junction__c csapCglpRecord: [SELECT id,Partial_Control_Group__c ,Full_Control_Group__c,crd__C,CRD__r.name,CRD__r.Partial_Control_Group__c,
                                                  CRD__r.Full_Control_Group__c,Full_Control_Group__r.account_name__C,Partial_Control_Group__r.account__C,crd__r.account__c,
                                                  Full_Control_Group__r.CSAP_Plan_ID__c,Full_Control_Group__r.CSAP_Control_ID__c,CSAP_Control_Plan__c,Partial_Control_Group__r.CSAP_Control_ID__c,
                                                  Partial_Control_Group__r.CSAP_Plan_ID__c 
                                                  from 
                                                    CSAP_CGLP_Junction__c 
                                                  where 
                                                    CRD__c IN :crdMonitorMap.keyset() Limit 10000]){
            
            crd__C currentcrd = crdMonitorMap.get(csapCglpRecord.crd__C);
            if(!crdArchiveChk.containsKey(currentcrd.id)){
                crdArchiveChk.put(currentcrd.id,false);
            }
                
            //Code for Observation 11
            if(csapCglpRecord.Partial_Control_Group__c != NULL){

                String csapControlPlan = GC_Utils_Method.calculateControl(csapCglpRecord.Partial_Control_Group__r.CSAP_Control_ID__c)+SPACE+csapCglpRecord.Partial_Control_Group__r.CSAP_Plan_ID__c;
                
                if(csapControlPlan.equals(crdidPlan.get(currentcrd.id))){
                    toDeleteCsapCglpList.add(csapCglpRecord);               
                    if(currentcrd.Partial_Control_Group__c == csapCglpRecord.Partial_Control_Group__c){
                        currentcrd.Partial_Control_Group__c = null; 
                                               
                    }
                }
                else{
                    cpPCGMap.put(csapCglpRecord.Partial_Control_Group__r.CSAP_Control_ID__c+csapCglpRecord.Partial_Control_Group__r.CSAP_Plan_ID__c,csapCglpRecord);
                    crdArchiveChk.put(currentcrd.id,true);
                    if(crdPCGControlPlanMap.containsKey(currentcrd.id)){
                        crdPCGControlPlanMap.get(currentcrd.id).add(csapCglpRecord.Partial_Control_Group__r.CSAP_Control_ID__c+csapCglpRecord.Partial_Control_Group__r.CSAP_Plan_ID__c);
                    }
                    else{
                        crdPCGControlPlanMap.put(currentcrd.id, new List<String>{csapCglpRecord.Partial_Control_Group__r.CSAP_Control_ID__c+csapCglpRecord.Partial_Control_Group__r.CSAP_Plan_ID__c});
                    }
                    
                }
            }
            else{
                   // do nothing for PCG == NULL 
            }
          //Code for Observation 11
            if(csapCglpRecord.Full_Control_Group__c != NULL){
                
                String csapFCGControlPlan = GC_Utils_Method.calculateControl(csapCglpRecord.Full_Control_Group__r.CSAP_Control_ID__c)+SPACE+csapCglpRecord.Full_Control_Group__r.CSAP_Plan_ID__c;
                
                if(csapFCGControlPlan.equals(crdidPlan.get(currentcrd.id))){
                    toDeleteCsapCglpList.add(csapCglpRecord);
                  
                    if(currentcrd.Full_Control_Group__c == csapCglpRecord.Full_Control_Group__c){
                        currentcrd.Full_Control_Group__c = null;
                    }
                       
                }
                else{
                    cpFCGMap.put(csapCglpRecord.Full_Control_Group__r.CSAP_Control_ID__c+csapCglpRecord.Full_Control_Group__r.CSAP_Plan_ID__c,csapCglpRecord);
                    if(crdFCGControlPlanMap.containsKey(currentcrd.id)){
                            crdFCGControlPlanMap.get(currentcrd.id).add(csapCglpRecord.Full_Control_Group__r.CSAP_Control_ID__c+csapCglpRecord.Full_Control_Group__r.CSAP_Plan_ID__c);
                    }
                    else{
                         crdFCGControlPlanMap.put(currentcrd.id, new List<String>{csapCglpRecord.Full_Control_Group__r.CSAP_Control_ID__c+csapCglpRecord.Full_Control_Group__r.CSAP_Plan_ID__c});
                    }
                }
            }
        }
        list<String> cpPCGMapKeyset;
        for(Id crdMapVal : crdArchiveChk.keyset())
        {
            string pcgControlPlanKey = NULLOREMPTY;
            if(crdArchiveChk.get(crdMapVal)){
                
                    cpPCGMapKeyset = new list<string>();
                    cpPCGMapKeyset.addAll(cpPCGMap.keyset());
                    if(cpPCGMapKeyset.size()>0){
                        //pcgControlPlanKey = cpPCGMapKeyset.get(0);
                        //system.debug('pcgControlPlanKey'+ pcgControlPlanKey);
                        crd__C currentcrd = crdMonitorMap.get(crdMapVal);
                        if(crdPCGControlPlanMap.containsKey(crdMapVal)){
                            if(cpPCGMap.keyset().size()>0 && cpPCGMap.containsKey(crdPCGControlPlanMap.get(crdMapVal)[0])){
                                currentCRD.Partial_Control_Group__c =  cpPCGMap.get(crdPCGControlPlanMap.get(crdMapVal)[0]).Partial_Control_Group__c;
                            }
                        }
                        if(crdFCGControlPlanMap.containsKey(crdMapVal)){
                            if(cpFCGMap.keyset().size()>0 && cpFCGMap.containsKey(crdFCGControlPlanMap.get(crdMapVal)[0])){
                                currentCRD.Full_Control_Group__c =  cpFCGMap.get(crdFCGControlPlanMap.get(crdMapVal)[0]).Full_Control_Group__c;
                            }
                        }
                    }
            }
        }  
           
           
           
           
    //Iterate through the crd to be marked archive, they may have a cbon with it.
        set<string> crdName;
        set<string> rxplanIdName;
        CVSRxPlanId__c cvsEntry;
        for(crd__C currentcrd : crdMonitorMap.values()){
        //In case we dont have a cbon for crd to be archived/Ignore it needs to be marked archived       
                if((crdArchiveChk.containskey(currentcrd.id) && crdArchiveChk.get(currentcrd.id) && !crdcbonmap.containskey(currentcrd.id)) || (crdArchiveChk.containskey(currentcrd.id) && crdArchiveChk.get(currentcrd.id) && (crdcbonmap.get(currentcrd.id).ExistingRxplan__c || crdcbonmap.get(currentcrd.id).CVS__c)))
                {
                    system.debug('!##!!');
                }
                
            else{
            
            if(!crdcbonmap.containskey(currentcrd.id)){
                currentcrd.status__c = ARCHIVED;
                currentcrd.Archived__c = true;
                crdIdSet.add(currentcrd.id);//Collect all CRDIDs here for Request 06263. These CRDIDs will be used to collect all the Cases which are Open Plan Change Cases
            }
            else{
                crdbuildorder__c cb =crdcbonmap.get(currentcrd.id);
                    //In case we have a cbon for the crd, it will be marked archived only if the rxplanid is already shared to CVS
                if(cb.cvs__c || cb.ExistingRxplan__c){
                    currentcrd.status__c = ARCHIVED;
                    currentcrd.Archived__c = true;
                    cb.PERS__c = TRUE;
                    cb.XML__c = TRUE;
                    //cb.Ready_to_Archive__c = TRUE;
                    cb.Aicallout__c = TRUE;
                    cb.AIRealtime__c = TRUE;
                    cb.Build__c = TRUE;
                    cb.builtRealTime__c = TRUE;
                    cb.CAG__c = TRUE;
                    cb.CAGRealtime__c = TRUE;
                    cb.complete__c = TRUE;
                    cb.completeChkRealTime__c = TRUE;
                    cb.CVS__c = TRUE;
                    crdIdSet.add(currentcrd.id);//Collect all CRDIDs here for Request 06263. These CRDIDs will be used to collect all the Cases which are Open Plan Change Cases
                }               
                else{
                    if(cb.CRD_RxPlan_ID__c != null){
                        crdName = new set<string>();
                        rxplanIdName = new set<string>();
                        for(CVSRxPlanId__c cv : existingrxplaindsGlobal){
                            crdName.add(cv.CRD_Name__c);
                            RxplanIdName.add(cv.RxPlanId__c);
                        }
                        if(existingrxplaindsGlobal.size()>0 && !crdName.contains(cb.CRD__r.name) && RxplanIdName.contains(cb.CRD_RxPlan_ID__c)){
                            //In case we have cbon for the CRD and it has not been shared to CVS we mark it ignored.
                           
                            cb.Aicallout__c = TRUE;
                            cb.AIRealtime__c = TRUE;
                            cb.Build__c = TRUE;
                            cb.builtRealTime__c = TRUE;
                            cb.CAG__c = TRUE;
                            cb.CAGRealtime__c = TRUE;
                            cb.complete__c = TRUE;
                            cb.completeChkRealTime__c = TRUE;
                            cb.CVS__c = TRUE;
                            cb.Description__c = IGNOREDDESCRIPTION;
                            cb.PDF__c = TRUE;
                            cb.PDFRealtime__c = TRUE;
                            cb.PERS__c = TRUE;
                           // cb.PostBuildOnly__c = TRUE;
                            cb.Processed__c = TRUE;
                           //    cb.Ready_to_Archive__c = TRUE;
                            cb.Sent_AI_request__c = TRUE;
                            cb.valid__c = TRUE;// need to check this to know that the CBON is valid or not
                            cb.validatedRealTime__c = TRUE;
                            cb.XML__c = TRUE;
                            cb.XMLRealtime__c = TRUE; 
                            cb.Ignored__c = true;
                            ignoredCRDId.add(currentcrd.id);
                            if(cb.FalloutCase__c !=null && newCRDNewCBONMap.containsKey(oldToNewCRDMap.get(currentcrd.id).id)){
                                string newCBONName = newCRDNewCBONMap.get(oldToNewCRDMap.get(currentcrd.id).id).name;
                                string newCRDName = newCRDNewCBONMap.get(oldToNewCRDMap.get(currentcrd.id).id).crd__r.name;
                                cb.FalloutCase__r.status = CLOSED;
                                 if(cb.FalloutCase__r.Review_Notes__c != null && cb.FalloutCase__r.Review_Notes__c !=NULLOREMPTY){
                                     
                                     cb.FalloutCase__r.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON+SPACE + V5 + SPACE+ newCBONName +SPACE+ COMMA+ V3 + newCRDName + BREAKLINE + cb.FalloutCase__r.Review_Notes__c ;
                                    }
                                else{
                                      cb.FalloutCase__r.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON+SPACE + V5  + SPACE+ newCBONName +SPACE+ COMMA + V3 + newCRDName;
                                    }
                                ignoreCBONFalloutCase.add(cb.FalloutCase__r);
                            
                            }
                            else if(cb.FalloutCase__c !=null){
                                string newCRDName = oldToNewCRDMap.get(currentcrd.id).name;
                                cb.FalloutCase__r.status = CLOSED;
                                 if(cb.FalloutCase__r.Review_Notes__c != null && cb.FalloutCase__r.Review_Notes__c !=NULLOREMPTY){
                                     cb.FalloutCase__r.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON+SPACE + V5 +SPACE  + V3 + newCRDName + BREAKLINE + cb.FalloutCase__r.Review_Notes__c ;
                                    }
                                else{
                                      cb.FalloutCase__r.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON+SPACE + V5 +SPACE + V3 + newCRDName;
                                    }
                                ignoreCBONFalloutCase.add(cb.FalloutCase__r);
                            }
                            
                        }
                        else{
                            cb.Archive_after_CVS__c = TRUE;
                            cb.Description__c = PLANDESCRIPTION;
                            if(!RxplanIdName.contains(cb.CRD_RxPlan_ID__c)){
                                RxplanIdName.add(cb.CRD_RxPlan_ID__c);
                                cvsEntry = new CVSRxPlanId__c();
                                cvsEntry.CRD_Name__c = cb.CRD__r.name;
                                cvsEntry.RxPlanId__c = cb.CRD_RxPlan_ID__c;
                                database.insert(cvsEntry);
                           } 
                        }       
                    }
                    else{
                        if(cb.FalloutCase__c != NULL && newCRDNewCBONMap.containsKey(oldToNewCRDMap.get(currentcrd.id).id)){
                            string newCBONName = newCRDNewCBONMap.get(oldToNewCRDMap.get(currentcrd.id).id).name;
                            string newCRDName = newCRDNewCBONMap.get(oldToNewCRDMap.get(currentcrd.id).id).crd__r.name;
                            case c = new case(id=cb.FalloutCase__c);
                            c.Status = CLOSED;
                            if(cb.FalloutCase__r.Review_Notes__c != NULL && cb.FalloutCase__r.Review_Notes__c != NULLOREMPTY){
                                c.Review_Notes__c = V1+SPACE+ SYSTEM.TODAY()+COLON+SPACE+ V2+SPACE + newCBONName +SPACE+ COMMA + V3 + newCRDName + BREAKLINE + cb.FalloutCase__r.Review_Notes__c ;
                            }
                            else{
                                  c.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON + V2 +SPACE+ newCBONName +SPACE+ COMMA +V3 + newCRDName;
                            }                
                            ignoredCBONS.add(cb);
                            stopCRDFromIgnore = True;
                            caseList.add(c);
                        }
                        else if(cb.FalloutCase__c !=null){
                            string newCRDName = oldToNewCRDMap.get(currentcrd.id).name;
                            case c = new case(id=cb.FalloutCase__c);
                            c.Status = CLOSED;
                            if(cb.FalloutCase__r.Review_Notes__c != NULL && cb.FalloutCase__r.Review_Notes__c != NULLOREMPTY){
                                c.Review_Notes__c = V1+SPACE+ SYSTEM.TODAY()+COLON+SPACE+ V2  +  SPACE + V3 + newCRDName + BREAKLINE + cb.FalloutCase__r.Review_Notes__c ;
                            }
                            else{
                                  c.Review_Notes__c = V1 +SPACE+ SYSTEM.TODAY()+COLON + V2  +SPACE+ V3 + newCRDName;
                            }                 
                            ignoredCBONS.add(cb);
                            stopCRDFromIgnore = True;
                            caseList.add(c);
                        }
                    }
          
                }    
            }
        }
    }
    openPlanChangeCase(crdIdSet);
   string falloutDescription = FALLOUTDESCRIBE;
   
   
   
        
        database.delete(toDeleteCsapCglpList);
        markIgnored(ignoredCBONS,blankCBONInstance,falloutDescription);
        database.update(crdMonitorMap.values());
        database.update(crdcbonmap.values());
        database.update(caseList);
        database.update(ignoreCBONFalloutCase);
        ignoreCRD(ignoredCRDId);
    }catch(exception e){
        throw e;
    }
    }
    /* Method :ignoreCRD()
       Description : This method will ignore all those CRD without CSAP if CBON ignored due to Existing RxplanId
    */
    public void ignoreCRD(set<id> crdId)
    {
     try{
        List<CSAP_CGLP_Junction__c> csapList = [select name from CSAP_CGLP_Junction__c where CRD__c IN: crdId Limit 10000];
        if(csapList.size()>0){
        system.debug('Do Nothing');
        }
        else{
            List<CRD__c> crdToBeIgnored = new List<CRD__c>();
            for(CRD__c cr : [select name,Status__c,Ignored__c from CRD__c where id IN: crdId limit 10000]){
                cr.Status__c = IGNORED;
                cr.Ignored__c = TRUE;
                crdToBeIgnored.add(cr);
            }
            
            database.update(crdToBeIgnored);
          }
        }
            catch (exception e){
            throw e;
        }
        
    }
    /*
        Method:openPlanChangeCase()
        Description: This method will receive all the CRDIDs and collect all the Cases which are Open Plan Change Cases. They are filtered on the basis of:
        1. Record Type - Internal CRD/GMF, 2. Status != Closed/Sent TO CVS, 3. Event Notification Review Result - Plan Change, 4. Subject != Fallout/Success Case Subject
    */
    public void openPlanChangeCase(set<id> idSet){
        try{
        list<string> caseSubjectList = new list<string>{SUBJECT1,SUBJECT2};
        list<string> caseStatusList = new list<string>{CLOSED,SENTTOCVS};
        for(case c : [Select id,status,review_notes__c,type,Event_Notification_Review_Results__c,subject,RecordType.Name,crd_id__c,crd_name__c 
                    FROM 
                        Case 
                    WHERE 
                        recordtypeid in (Select Id From RecordType where sobjecttype =: CASEOBJ and Name in (:INTERNALRT)) 
                    AND 
                        crd_name__c IN :idSet 
                    AND 
                        status NOT IN :caseStatusList 
                    AND
                        Event_Notification_Review_Results__c = :PlanChange 
                    AND 
                        subject NOT IN :caseSubjectList limit 10000]){
            case c2 = new case(id=c.id);
            c2.review_notes__c = SYSTEM.LABEL.OpenPlanStatus;        
            c2.status = CLOSED;   
            openCaseList.add(c2);
        }
        database.update(openCaseList);
    }catch(exception e){
            throw e;
        }
    }
    //Create crdbuildfallout records for the crds, attach them to fallot cases if they already exist.
    /*Method:createFallout()*/
    @TestVisible private void createFallout(Map<String, List<CRDBuildOrder__c>> mapControlPlansToBuilders, Set<String> setOfControlPlan, String errorMessage){
        Map<Id,Case> mapbuilderIdWithCase = new Map<Id,Case>();
        Map<Id,CRD_BuilderFallout__c> mapbuilderIdWithFallout = new Map<Id,CRD_BuilderFallout__c>();
        Map<Id,CRDBuildOrder__c> mapCrdBuilder = new Map<Id,CRDBuildOrder__c>();
        CRD_BuilderFallout__c falloutRecord;
        for(String controlPlan : setOfControlPlan){
            for(CRDBuildOrder__c builder : mapControlPlansToBuilders.get(controlPlan)){
                  Case falloutCase;
               
              if(builder.FalloutCase__c != null){
                    //initiate fallout record with existing record Id 
                    falloutcase = CB_CaseLogger.CreateCaseBuilder(builder.falloutcase__c, CAGRESTRUCTUREFAILURE
                                                                    , errorMessage
                                                                    ,CBCAG
                                                                    ,builder.PERS_timestamp__c
                                                                    ,builder.ControlPlanEffective__c
                                                                    ,builder.crd__r.Account__c
                                                                    ,builder.crd__r.Effective_Start_Date__c
                                                                    ,builder.crd__c);
                  }else{
                    //Create new instance of fallout record
                    falloutcase = CB_CaseLogger.CreateCaseBuilder(CAGRESTRUCTUREFAILURE
                                                                    ,errorMessage
                                                                    ,CBCAG
                                                                    ,builder.PERS_timestamp__c
                                                                    ,builder.ControlPlanEffective__c
                                                                    ,builder.crd__r.Account__c
                                                                    ,builder.crd__r.Effective_Start_Date__c
                                                                    ,builder.crd__c);
                    
                  }
                  mapbuilderIdWithCase.put(builder.id, falloutCase);
                  
                  falloutRecord = new CRD_BuilderFallout__c();
                  falloutRecord.Error_Description__c = errorMessage;
                  falloutRecord.Type__c = INDIVIDUAL;
                  falloutRecord.CRD_Id__c = builder.crd__c;
                  falloutRecord.PERS_Timestamp__c = builder.PERS_timestamp__c;
                  mapbuilderIdWithFallout.put(builder.id, falloutRecord);
                  failureRecords.add(falloutRecord);
                  mapCrdBuilder.put(builder.id, builder);
            }
            
        }
        
        database.upsert(mapbuilderIdWithCase.values());
        for(String builderId : mapbuilderIdWithCase.keyset()){
            //Amit set the PDF,XML,CVS,ExistingRxPlan to false and remove the RxPlanId from CVS list.
            //Modified on 2 Jan, 2014 to resolve issue where CAG was unchecked and rest flags were checked
            CRDBuildOrder__c builder  = mapCrdBuilder.get(builderId);
            builder.CAG__c = False;
            builder.PDF__c = False;
            builder.XML__c = False;
            builder.CVS__c = False;
            builder.ExistingRxplan__c = False;
           // setRxplanid.remove(builder.CRD_RxPlan_ID__c);
            builder.FalloutCase__c = mapbuilderIdWithCase.get(builderId).id;
            mapbuilderIdWithFallout.get(builderId).CaseId__c = mapbuilderIdWithCase.get(builderId).id;
            
        }
        insert mapbuilderIdWithFallout.values();
       
        database.update(mapCrdBuilder.values());
        
    }
}