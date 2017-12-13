/* Purpose : Apex Class to Apply tagging FIFO rules for Middle Market,National and Public Labor
======================================================================================
History
------
VERSION    AUTHOR        DATE        DETAIL
1.0-       Ayushi Agrawal 8/6/2015    Implemented Request 05981,05982 and 05996
1.1-       Richa Gupta    10/12/2015  Implemented Request 6124 - Tagging on success case
1.2-       Richa Gupta    10/23/2015  Implemented Request 6159 - Membership Count
1.3-       Abhishek Goel  9/7/2016    Implemented a Request 1299 - FIFO tag should be General when Field ' Has Custom Network' 
                                      on the External Case is set to 'True'.
1.4-       Sushant Sethi  9/21/2016   Modified Logic in accordance to Request 6662
====================================================================================== */

/** 
*Class:- CB_FIFO_Tag
*Description:- Apex Class to Apply tagging FIFO rules for Middle Market,National and Public Labor
**/
public without sharing class CB_FIFO_Tag    //Apex Class to Apply tagging FIFO rules for Middle Market,National and Public Labor
{
 private map <String,List<FIFO_Report__c>> fIFOReportMap_MM = new map<String,List<FIFO_Report__c>>();
 private map <String,List<FIFO_Report__c>> fIFOReportMap_NPL = new map<String,List<FIFO_Report__c>>();
 private Map<String,List<CRDBuildOrder__c>> cBONMap = new Map<String,List<CRDBuildOrder__c>>();
 private Map<id,String> caseMap = new Map<id,String>();
 private Map<id,String> casefIFORecordMap = new Map<id,String>();
 private Map<id,String> casetransactypeMap = new Map<id,String>();
 private List<case> casetoupdate = new list<case>();
 private set<string> CBONcpsKey = new set<string>();
 private static final string MMARKET = 'MM';
 private static final string NAPLMARKET = 'NAPL';
 private static final string CRDMM = 'Key';
 private static final string CRDMMAR = 'Select';
 private static final string CRDNAPL = 'National'; 
 private static final string CRDNAPLMAR = 'Government/Labor';
 private static final string REWORK = 'Rework';
 private static final string GENERAL = 'General';
 private static final string ESCALATED = 'Escalated';
 private static final string DEFAULTVAL = 'Default';
 private static final string VNF = 'Value not found'; // Request 06662
 private date psu_Date= null;
 private String derivedFIFOtag = null;
 private String fIFORec = null;
 private String transactypeFIFO = VNF; //Request 06662
 List<FIFO_Report__c> lstFIFONPL;
 List<FIFO_Report__c> lstFIFOMM;
 List<CRDBuildOrder__c> lstCBON;
 private set<id> MSCupdate = new set<id>();
 private Map<id,integer> CBONkey = new Map<id,integer>();
 private Map<string,integer> MSCkey = new Map<string,integer>();

/**
* Method :- fIFO_Flag_Execute 
* Description :- Function for FIFO Tagging
*                #ST1299:- Set FIFO tag to General when Has Custom Network is set to True on Case.
**/  
public void fIFO_Flag_Execute(List<CRDBuildOrder__c> CBONlist)    //Method for FIFO Tagging logic
 {
    try{
    for(CRDBuildOrder__c CBONrecord : CBONlist)
    {
      if(CBONrecord.FalloutCase__c!=null || CBONrecord.Success_Case__c != null){
          CBONcpsKey.add(String.valueOf(Integer.valueof(CBONrecord.Control__c)) + CBONrecord.Plan__c + CBONrecord.Subsegment__c);
      }      
      if(((CBONrecord.Case__c!=null)&&(CBONrecord.Case__r.FIFO_Tag__c==null))||((CBONrecord.FalloutCase__c!=null)&&(CBONrecord.FalloutCase__r.FIFO_Tag__c==null)) || ((CBONrecord.Success_Case__c!=null)&&(CBONrecord.Success_Case__r.FIFO_Tag__c==null)))
      {
          if(cBONMap.containsKey(String.valueof(Integer.valueof(CBONrecord.Control__c))+String.valueof(CBONrecord.Effective_date__c))){
               cBONMap.get(String.valueof(Integer.valueof(CBONrecord.Control__c))+String.valueof(CBONrecord.Effective_date__c)).add(CBONrecord);    
           }else{
               lstCBON=new List<CRDBuildOrder__c>{CBONrecord};
               cBONMap.put(String.valueof(Integer.valueof(CBONrecord.Control__c))+String.valueof(CBONrecord.Effective_date__c), lstCBON );
             }
      } 
      else{
        //Donot add to CBON list to be tagged
      }
    }   
    
    for(Membership_Counts__c msc : [Select Control__c,Plan_Summary__c,SubSegment__c,Membership_Count__c,Key__c from Membership_Counts__c where Key__c IN :CBONcpsKey LIMIT 50000]){
        MSCkey.put(msc.Key__c,Integer.valueOf(msc.Membership_Count__c));
    }
    for(CRDBuildOrder__c CBONrecord : CBONlist)
    {
      if(CBONrecord.Success_Case__c != null){
          CBONkey.put(CBONrecord.Success_Case__c,MSCkey.get(String.valueOf(Integer.valueof(CBONrecord.Control__c)) + CBONrecord.Plan__c + CBONrecord.Subsegment__c));
          MSCupdate.add(CBONrecord.Success_Case__c);
      }
      if(CBONrecord.FalloutCase__c != null){
          CBONkey.put(CBONrecord.FalloutCase__c,MSCkey.get(String.valueOf(Integer.valueof(CBONrecord.Control__c)) + CBONrecord.Plan__c + CBONrecord.Subsegment__c));
          MSCupdate.add(CBONrecord.FalloutCase__c); 
      }
    }  
    //Creating a Map of FIFO Report records for Middle Market 
    for(FIFO_Report__c FIFOReport : [select id,name,Key_FIFO__c,FIFO_Tag__c,Plan_Setup_Completed__c,Transaction_Type__c from FIFO_Report__c where FIFO_Segment__c=:MMARKET and Key_FIFO__c IN: cBONMap.keyset() order by Plan_Setup_Completed__c desc LIMIT 90000])
    {
        if(fIFOReportMap_MM.containsKey(FIFOReport.Key_FIFO__c)){
               fIFOReportMap_MM.get(FIFOReport.Key_FIFO__c).add(FIFOReport);    
           }else{
               lstFIFOMM=new List<FIFO_Report__c>{FIFOReport};
               fIFOReportMap_MM.put(FIFOReport.Key_FIFO__c, lstFIFOMM );
             } 
    }  
    
    
   //Creating a Map of FIFO Report records for National and Public Labor 
   for(FIFO_Report__c FIFOReport : [Select id,name,Key_FIFO__c,FIFO_Tag__c,Plan_Setup_Completed__c,Transaction_Type__c from FIFO_Report__c where FIFO_Segment__c=:NAPLMARKET and (Key_FIFO__c IN: cBONMap.keyset()) and Plan_Setup_Completed__c=null LIMIT 90000])
   {      
       if(fIFOReportMap_NPL.containsKey(FIFOReport.Key_FIFO__c))
       {  
           fIFOReportMap_NPL.get(FIFOReport.Key_FIFO__c).add(FIFOReport);
       }else{
           lstFIFONPL=new list<FIFO_Report__c>{FIFOReport};
           fIFOReportMap_NPL.put(FIFOReport.Key_FIFO__c,lstFIFONPL);
       }  
   }    
    //Logic for tagging MM and NAPL FIFO tags on Cases : Request 05981 and 05996
    for(String KeytoProc : cBONMap.Keyset())
    {
        for(CRDBuildOrder__c CBONrec : cBONMap.get(KeytoProc))
        {
            if((CRDMM.equalsIgnoreCase(CBONrec.CRD__r.National__c))||(CRDMMAR.equalsIgnoreCase(CBONrec.CRD__r.National__c))) {
                fIFO_Flag_MM(KeytoProc,CBONrec);
            } else if((CRDNAPL.equalsIgnoreCase(CBONrec.CRD__r.National__c))||(CRDNAPLMAR.equalsIgnoreCase(CBONrec.CRD__r.National__c))) {
                fIFO_Flag_NAPL(KeytoProc,CBONrec);
            }else{
                    derivedFIFOtag=GENERAL;
                    fIFORec=DEFAULTVAL;
                    transactypeFIFO=VNF; // Modified logic to replace null value with VNF in the sceanrio for Request 06662
                    if((CBONrec.FalloutCase__c!=null)&&(CBONrec.FalloutCase__r.FIFO_Tag__c==null))
                    {
                        caseMap.put(CBONrec.FalloutCase__c,derivedFIFOtag);
                        casefIFORecordMap.put(CBONrec.FalloutCase__c,fIFORec);
                        casetransactypeMap.put(CBONrec.FalloutCase__c,transactypeFIFO);
                    }
                    else { // Do nothing 
                    }
                    if((CBONrec.Case__c!=null)&&(CBONrec.Case__r.FIFO_Tag__c==null))
                    {
                        if((CBONrec.FalloutCase__c!=null)&&(CBONrec.FalloutCase__r.FIFO_Tag__c!=null))
                        {
                            //#1299 Add logic below set the FIFO tag to 'General' by Abhishek Goel
                            if(CBONrec.Case__r.Has_Custom_Network__c)
                            {
                                caseMap.put(CBONrec.Case__c,derivedFIFOtag);
                            }else{
                                caseMap.put(CBONrec.Case__c,CBONrec.FalloutCase__r.FIFO_Tag__c);
                            }
                            casefIFORecordMap.put(CBONrec.Case__c,CBONrec.FalloutCase__r.FIFO_record_name__c);
                            casetransactypeMap.put(CBONrec.Case__c,CBONrec.FalloutCase__r.Transaction_Type__c);
                        }
                        else
                        {
                            caseMap.put(CBONrec.Case__c,derivedFIFOtag);
                            casefIFORecordMap.put(CBONrec.Case__c,fIFORec);                          
                            casetransactypeMap.put(CBONrec.Case__c,transactypeFIFO);
                        }
                    } 
                    else { // Do Nothing 
                    }
                    //Richa added below if block as per Req 6124
                    if((CBONrec.Success_Case__c!=null)&&(CBONrec.Success_Case__r.FIFO_Tag__c==null))
                    {
                        if((CBONrec.FalloutCase__c!=null)&&(CBONrec.FalloutCase__r.FIFO_Tag__c!=null))
                        {
                            caseMap.put(CBONrec.Success_Case__c,CBONrec.FalloutCase__r.FIFO_Tag__c);
                            casefIFORecordMap.put(CBONrec.Success_Case__c,CBONrec.FalloutCase__r.FIFO_record_name__c);
                            casetransactypeMap.put(CBONrec.Success_Case__c,CBONrec.FalloutCase__r.Transaction_Type__c);
                        }
                        else
                        {
                            caseMap.put(CBONrec.Success_Case__c,derivedFIFOtag);
                            casefIFORecordMap.put(CBONrec.Success_Case__c,fIFORec);                          
                            casetransactypeMap.put(CBONrec.Success_Case__c,transactypeFIFO);
                        }
                    } 
                    else { // Do Nothing 
                    }
                }
        }
    }
    
    //Updating Fallout and External Cases linked to the tagged CBONs
    
    for(case c : [Select id,FIFO_Tag__c,FIFO_record_name__c,Transaction_Type__c from case where id in:caseMap.keyset() LIMIT 90000])
    {
        c.FIFO_Tag__c=caseMap.get(c.id);
        c.FIFO_record_name__c=casefIFORecordMap.get(c.id);
        c.Transaction_Type__c=casetransactypeMap.get(c.id);
        if(CBONkey.get(c.id) != null){
          c.Membership_Count__c = CBONkey.get(c.id);
        }
        casetoupdate.add(c);
    } 
    if(MSCupdate.size()>0){
        MSCupdate.removeAll(caseMap.keyset());
        for(case c : [Select id,Membership_Count__c from case where id IN :MSCupdate LIMIT 90000]){
            c.Membership_Count__c = CBONkey.get(c.id);
            casetoupdate.add(c);
        }        
    }
    if(casetoupdate.size() > 0){   
        Database.update (casetoupdate,false); 
    }
    }
    catch(exception e)
    {
        throw e;
    }
}

/**
* Method :- fIFO_Flag_MM
* Description :- MM records FIFO Tagging
               :- ST#1299 logic written here by abhishek
**/
private void fIFO_Flag_MM(String KeytoProcess, CRDBuildOrder__c CBONrecord)  //Method for MM records FIFO Tagging
{
    if(fIFOReportMap_MM.containskey(KeytoProcess)){
    psu_Date = date.newinstance(0001,1,1);
    derivedFIFOtag =null;
    fIFORec=null;
    transactypeFIFO=VNF; // Modified logic to replace null value with VNF in the sceanrio for Request 06662
    for (FIFO_Report__c FIFOReportRec : fIFOReportMap_MM.get(KeytoProcess))
    {
        if((derivedFIFOtag==null)&&(FIFOReportRec.Plan_Setup_Completed__c<=CBONrecord.PERS_timestamp__c))
        {
            derivedFIFOtag=FIFOReportRec.FIFO_Tag__c;
            psu_Date= FIFOReportRec.Plan_Setup_Completed__c;
            fIFORec=FIFOReportRec.name;
            if(FIFOReportRec.Transaction_Type__c != Null){
            transactypeFIFO=FIFOReportRec.Transaction_Type__c;
            }else{
            	transactypeFIFO = VNF;
            }
        }
        
        else if((derivedFIFOtag==null)&&(FIFOReportRec.Plan_Setup_Completed__c>CBONrecord.PERS_timestamp__c))
        {
            derivedFIFOtag=GENERAL;
            fIFORec=DEFAULTVAL;
            transactypeFIFO=VNF; // Modified logic to replace null value with VNF in the sceanrio for Request 06662
        }
        
        else if((derivedFIFOtag!=null)&&(FIFOReportRec.Plan_Setup_Completed__c<=CBONrecord.PERS_timestamp__c))
        {                   
            If(FIFOReportRec.Plan_Setup_Completed__c>psu_Date)
             {
                 derivedFIFOtag=FIFOReportRec.FIFO_Tag__c;
                 psu_Date = FIFOReportRec.Plan_Setup_Completed__c;
                 fIFORec=FIFOReportRec.name;
                 if(FIFOReportRec.Transaction_Type__c != Null){
		            transactypeFIFO=FIFOReportRec.Transaction_Type__c;
		         }else{
		            transactypeFIFO = VNF;
		         }
            }
            else if((FIFOReportRec.Plan_Setup_Completed__c==psu_Date)&&(derivedFIFOtag!=FIFOReportRec.FIFO_Tag__c))
            {
                if((GENERAL.equalsIgnoreCase(derivedFIFOtag))||((REWORK.equalsIgnoreCase(derivedFIFOtag))&&(ESCALATED.equalsIgnoreCase(FIFOReportRec.FIFO_Tag__c)))) 
                {
                    derivedFIFOtag=FIFOReportRec.FIFO_Tag__c;
                    psu_Date= FIFOReportRec.Plan_Setup_Completed__c;
                    fIFORec=FIFOReportRec.name;
                    if(FIFOReportRec.Transaction_Type__c != Null){
		            	transactypeFIFO=FIFOReportRec.Transaction_Type__c;
		            }else{
		            	transactypeFIFO = VNF;
		            }
                }  
                else{
                // Donot change the tag if above condition not met
                }
            } 
            else {
             // Donot change the tag
            }
        }
        else {
          // No action required.
        }
    }
    }  
    else if(!(fIFOReportMap_MM.containskey(KeytoProcess)))
    {
        derivedFIFOtag=GENERAL;
        fIFORec=DEFAULTVAL;
        transactypeFIFO=VNF;
    }
    else{
    // No Tagging to be done
    }
   
    if((CBONrecord.FalloutCase__c!=null)&&(CBONrecord.FalloutCase__r.FIFO_Tag__c==null))
    {
        caseMap.put(CBONrecord.FalloutCase__c,derivedFIFOtag);
        casefIFORecordMap.put(CBONrecord.FalloutCase__c,fIFORec);
        casetransactypeMap.put(CBONrecord.FalloutCase__c,transactypeFIFO);
        
    } 
    else{
        //No tagging required as either Fallout case doesnot exist or Fallout case already has a FIFO Tag
    }
    
    if((CBONrecord.Case__c!=null)&&(CBONrecord.Case__r.FIFO_Tag__c==null))
    {
        if((CBONrecord.FalloutCase__c!=null)&&(CBONrecord.FalloutCase__r.FIFO_Tag__c!=null))
        {
            //#1299 Add logic below set the FIFO tag to 'General' by Abhishek Goel
            if(CBONrecord.Case__r.Has_Custom_Network__c){
                caseMap.put(CBONrecord.Case__c,GENERAL);
            }
            else{
                caseMap.put(CBONrecord.Case__c,CBONrecord.FalloutCase__r.FIFO_Tag__c);
            }   
            casefIFORecordMap.put(CBONrecord.Case__c,CBONrecord.FalloutCase__r.FIFO_record_name__c);
            casetransactypeMap.put(CBONrecord.Case__c,CBONrecord.FalloutCase__r.Transaction_Type__c);
        }
        else
        {
            if(CBONrecord.Case__r.Has_Custom_Network__c){
                caseMap.put(CBONrecord.Case__c,GENERAL);
            }
            else{
                caseMap.put(CBONrecord.Case__c,derivedFIFOtag);
            }   
            casefIFORecordMap.put(CBONrecord.Case__c,fIFORec);
            casetransactypeMap.put(CBONrecord.Case__c,transactypeFIFO);
        }
    } 
    else{
        //No tagging required as either External case doesnot exist or External case already has a FIFO Tag
    }
    
    if((CBONrecord.Success_Case__c!=null)&&(CBONrecord.Success_Case__r.FIFO_Tag__c==null))
    {
        if((CBONrecord.FalloutCase__c!=null)&&(CBONrecord.FalloutCase__r.FIFO_Tag__c!=null))
        {
            caseMap.put(CBONrecord.Success_Case__c,CBONrecord.FalloutCase__r.FIFO_Tag__c);
            casefIFORecordMap.put(CBONrecord.Success_Case__c,CBONrecord.FalloutCase__r.FIFO_record_name__c);
            casetransactypeMap.put(CBONrecord.Success_Case__c,CBONrecord.FalloutCase__r.Transaction_Type__c);
        }
        else
        {
            caseMap.put(CBONrecord.Success_Case__c,derivedFIFOtag);
            casefIFORecordMap.put(CBONrecord.Success_Case__c,fIFORec);
            casetransactypeMap.put(CBONrecord.Success_Case__c,transactypeFIFO);
        }
    } 
    else{
        //No tagging required as either External case doesnot exist or External case already has a FIFO Tag
    }
}

/**
* Method :- fIFO_Flag_NAPL
* Description :- NAPL records FIFO Tagging
              :- ST#1299 logic written here by abhishek
**/
private void fIFO_Flag_NAPL(String KeyNLPL,CRDBuildOrder__c CBONrecord)   //Method for NAPL records FIFO Tagging
{
    if(fIFOReportMap_NPL.containskey(KeyNLPL)){
    derivedFIFOtag =null;
    fIFORec=null;
    transactypeFIFO=VNF; // Modified logic to replace null value with VNF in the sceanrio for Request 06662
    for (FIFO_Report__c FIFO : fIFOReportMap_NPL.get(KeyNLPL))
    {
          if(derivedFIFOtag == NULL)
            {
                derivedFIFOtag=FIFO.FIFO_Tag__c;
                fIFORec=FIFO.name;
                if(FIFO.Transaction_Type__c != Null){
	            	transactypeFIFO=FIFO.Transaction_Type__c;
	            }else{
	            	transactypeFIFO = VNF;
	            }
            }  
            else if(derivedFIFOtag!=FIFO.FIFO_Tag__c) 
                {
                    if((GENERAL.equalsIgnoreCase(derivedFIFOtag))||((REWORK.equalsIgnoreCase(derivedFIFOtag))&&(ESCALATED.equalsIgnoreCase(FIFO.FIFO_Tag__c))))
                    {
                        derivedFIFOtag=FIFO.FIFO_Tag__c;
                        fIFORec=FIFO.name;
                        if(FIFO.Transaction_Type__c != Null){
	            			transactypeFIFO=FIFO.Transaction_Type__c;
			            }else{
			            	transactypeFIFO = VNF;
			            }
                    }    
                    else {
                        //Donot change the FIFO Tag
                    }
                } 
                else {
                    //Donot chnage FIFO Tag
                }   
    }
    }  
    else if(!(fIFOReportMap_NPL.containskey(KeyNLPL)))
    {
        derivedFIFOtag=GENERAL;
        fIFORec=DEFAULTVAL;
        transactypeFIFO=VNF; // Modified logic to replace null value with VNF in the sceanrio for Request 06662
    }
    else{
    // No Tagging to be done
    }
   
    if((CBONrecord.FalloutCase__c!=null)&&(CBONrecord.FalloutCase__r.FIFO_Tag__c==null))
    {
        caseMap.put(CBONrecord.FalloutCase__c,derivedFIFOtag);
        casefIFORecordMap.put(CBONrecord.FalloutCase__c,fIFORec);
        casetransactypeMap.put(CBONrecord.FalloutCase__c,transactypeFIFO);
    }
    else{
        //No tagging required as either Fallout case doesnot exist or Fallout case already has a FIFO Tag
    }
    
    if((CBONrecord.Case__c!=null)&&(CBONrecord.Case__r.FIFO_Tag__c==null))
    {
        if((CBONrecord.FalloutCase__c!=null)&&(CBONrecord.FalloutCase__r.FIFO_Tag__c!=null))
        {
            //#1299 Add logic below set the FIFO tag to 'General' by Abhishek Goel
            if(CBONrecord.Case__r.Has_Custom_Network__c){
                caseMap.put(CBONrecord.Case__c,GENERAL);
            }
            else{
                caseMap.put(CBONrecord.Case__c,CBONrecord.FalloutCase__r.FIFO_Tag__c);
            }   
            casefIFORecordMap.put(CBONrecord.Case__c,CBONrecord.FalloutCase__r.FIFO_record_name__c);
            casetransactypeMap.put(CBONrecord.Case__c,CBONrecord.FalloutCase__r.Transaction_Type__c);
        }
        else
        {
            //#1299 Add logic below set the FIFO tag to 'General' by Abhishek Goel
            if(CBONrecord.Case__r.Has_Custom_Network__c){
                caseMap.put(CBONrecord.Case__c,GENERAL);
            }
            else{
                  caseMap.put(CBONrecord.Case__c,derivedFIFOtag);
            }   
            casefIFORecordMap.put(CBONrecord.Case__c,fIFORec);           
            casetransactypeMap.put(CBONrecord.Case__c,transactypeFIFO);
        }
    } 
    else{
        //No tagging required as either External case doesnot exist or External case already has a FIFO Tag
    }
    
    if((CBONrecord.Success_Case__c!=null)&&(CBONrecord.Success_Case__r.FIFO_Tag__c==null))
    {
        if((CBONrecord.FalloutCase__c!=null)&&(CBONrecord.FalloutCase__r.FIFO_Tag__c!=null))
        {
            caseMap.put(CBONrecord.Success_Case__c,CBONrecord.FalloutCase__r.FIFO_Tag__c);
            casefIFORecordMap.put(CBONrecord.Success_Case__c,CBONrecord.FalloutCase__r.FIFO_record_name__c);
            casetransactypeMap.put(CBONrecord.Success_Case__c,CBONrecord.FalloutCase__r.Transaction_Type__c);
        }
        else
        {
            caseMap.put(CBONrecord.Success_Case__c,derivedFIFOtag);
            casefIFORecordMap.put(CBONrecord.Success_Case__c,fIFORec);           
            casetransactypeMap.put(CBONrecord.Success_Case__c,transactypeFIFO);
        }
    } 
    else{
        //No tagging required as either External case doesnot exist or External case already has a FIFO Tag
    }
}

}