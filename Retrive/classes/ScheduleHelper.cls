/*Purpose: Apex Class to generate Y-Schedule value based on input parameters                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ANUJ                21/10/2011       Apex Class to generate Y-Schedule value based on input parameters
======================================================================== */

public with sharing class ScheduleHelper {
   /**
        @param 1 : SubsegmentCode
        @param 2 : FundingType 
        @param 3 : Rating
   */
   // To calculate Retail Y Schedule Value
   public static String fetchRetailYScheduleValue(String subsegmentCode,String fundingType,String rating,boolean checkHighValue)  {
          String ySchedule;
          if(!checkHighValue){
               String key = subsegmentCode+'#'+fundingType + '#' + rating;
                ySchedule = scheduleRetailMap.get(key);
           }else{
                ySchedule ='HV';
            }
            if(ySchedule==null)
                 return '';
           return ySchedule;
   }              
    public static String fetchYScheduleForHMO(String subsegmentCode,String fundingType,boolean checkHighValue)  {
          String ySchedule;
          if(!checkHighValue){
                String key = subsegmentCode+'#'+fundingType;
                ySchedule = scheduleHMOMap.get(key);
           }else{
                ySchedule ='HV';
            }
            if(ySchedule==null)
                 return '';
           return ySchedule;
   }    
   // To calculate Mail Y Schedule Value
   public static String fetchMailYScheduleValue(String subsegmentCode,String fundingType,String rating,boolean checkHighValue)  {
          String ySchedule;
          if(!checkHighValue){
                String key = subsegmentCode+'#'+fundingType + '#' + rating;
                ySchedule = scheduleMailMap.get(key);
           }else{
                ySchedule ='HV';
          }
          if(ySchedule==null)
                 return '';
          return ySchedule;                
   } 
   
   // Retail Y-Schedule Map
   public static Map<String,String> scheduleRetailMap = new Map<String,String>{      
        //Map Entries with Funding type = Self Insured          
        'AAM#Self Insured#Not Retrospective'=>'Y2','CRC#Self Insured#Not Retrospective'=>'Y3','BOA#Self Insured#Not Retrospective'=>'Y3',
        'AES#Self Insured#Not Retrospective'=>'Y2','JCA#Self Insured#Not Retrospective'=>'Y3','NA#Self Insured#Not Retrospective'=>'Y3',
        'AGB#Self Insured#Not Retrospective'=>'Y3','NAG#Self Insured#Not Retrospective'=>'Y3','ONA#Self Insured#Not Retrospective'=>'Y3',
        'IHM#Self Insured#Not Retrospective'=>'Y2','OSE#Self Insured#Not Retrospective'=>'Y3','OMM#Self Insured#Not Retrospective'=>'Y2',
        'AH#Self Insured#Not Retrospective'=>'Y2','HIT#Self Insured#Not Retrospective'=>'Y2','ORB#Self Insured#Not Retrospective'=>'Y2',
        'ASA#Self Insured#Not Retrospective'=>'Y2','ARP#Self Insured#Not Retrospective'=>'Y4','OTH#Self Insured#Not Retrospective'=>'Y2',
        'KEY#Self Insured#Not Retrospective'=>'Y3','ICV#Self Insured#Not Retrospective'=>'Y4','PET#Self Insured#Not Retrospective'=>'Y2',
        'OKA#Self Insured#Not Retrospective'=>'Y4','IPP#Self Insured#Not Retrospective'=>'Y4','MDR#Self Insured#Not Retrospective'=>'Y5',
        'SEL#Self Insured#Not Retrospective'=>'Y2','IVL#Self Insured#Not Retrospective'=>'Y4','SG#Self Insured#Not Retrospective'=>'Y4',
        'AWC#Self Insured#Not Retrospective'=>'Y2','OID#Self Insured#Not Retrospective'=>'Y2','SH#Self Insured#Not Retrospective'=>'Y3',
        'AHM#Self Insured#Not Retrospective'=>'Y2','LCP#Self Insured#Not Retrospective'=>'Y2','SRC#Self Insured#Not Retrospective'=>'Y3',
        'AHP#Self Insured#Not Retrospective'=>'Y2','MDC#Self Insured#Not Retrospective'=>'Y2','VOL#Self Insured#Not Retrospective'=>'Y2',
        'NAB#Self Insured#Not Retrospective'=>'Y2','MDD#Self Insured#Not Retrospective'=>'Y3','TRD#Self Insured#Not Retrospective'=>'Y2',
        'FED#Self Insured#Not Retrospective'=>'Y3','SDD#Self Insured#Not Retrospective'=>'Y3','TRO#Self Insured#Not Retrospective'=>'Y2',
        
         //Map Entries with Funding type = Self Insured          
        'AAM#Self Insured#Retrospective'=>'Y2','CRC#Self Insured#Retrospective'=>'Y3','BOA#Self Insured#Retrospective'=>'Y3',
        'AES#Self Insured#Retrospective'=>'Y2','JCA#Self Insured#Retrospective'=>'Y3','NA#Self Insured#Retrospective'=>'Y3',
        'AGB#Self Insured#Retrospective'=>'Y3','NAG#Self Insured#Retrospective'=>'Y3','ONA#Self Insured#Retrospective'=>'Y3',
        'IHM#Self Insured#Retrospective'=>'Y2','OSE#Self Insured#Retrospective'=>'Y3','OMM#Self Insured#Retrospective'=>'Y2',
        'AH#Self Insured#Retrospective'=>'Y2','HIT#Self Insured#Retrospective'=>'Y2','ORB#Self Insured#Retrospective'=>'Y2',
        'ASA#Self Insured#Retrospective'=>'Y2','ARP#Self Insured#Retrospective'=>'Y4','OTH#Self Insured#Retrospective'=>'Y2',
        'KEY#Self Insured#Retrospective'=>'Y3','ICV#Self Insured#Retrospective'=>'Y4','PET#Self Insured#Retrospective'=>'Y2',
        'OKA#Self Insured#Retrospective'=>'Y4','IPP#Self Insured#Retrospective'=>'Y4','MDR#Self Insured#Retrospective'=>'Y5',
        'SEL#Self Insured#Retrospective'=>'Y2','IVL#Self Insured#Retrospective'=>'Y4','SG#Self Insured#Retrospective'=>'Y4',
        'AWC#Self Insured#Retrospective'=>'Y2','OID#Self Insured#Retrospective'=>'Y2','SH#Self Insured#Retrospective'=>'Y3',
        'AHM#Self Insured#Retrospective'=>'Y2','LCP#Self Insured#Retrospective'=>'Y2','SRC#Self Insured#Retrospective'=>'Y3',
        'AHP#Self Insured#Retrospective'=>'Y2','MDC#Self Insured#Retrospective'=>'Y2','VOL#Self Insured#Retrospective'=>'Y2',
        'NAB#Self Insured#Retrospective'=>'Y2','MDD#Self Insured#Retrospective'=>'Y4','TRD#Self Insured#Retrospective'=>'Y2',
        'FED#Self Insured#Retrospective'=>'Y3','SDD#Self Insured#Retrospective'=>'Y4','TRO#Self Insured#Retrospective'=>'Y2',
        
        //Map Entries with Funding type = Split Funded
        'AAM#Split Funded#Not Retrospective'=>'Y2','CRC#Split Funded#Not Retrospective'=>'Y4','BOA#Split Funded#Not Retrospective'=>'Y4',
        'AES#Split Funded#Not Retrospective'=>'Y2','JCA#Split Funded#Not Retrospective'=>'Y4','NA#Split Funded#Not Retrospective'=>'Y4',
        'AGB#Split Funded#Not Retrospective'=>'Y4','NAG#Split Funded#Not Retrospective'=>'Y4','ONA#Split Funded#Not Retrospective'=>'Y4',
        'IHM#Split Funded#Not Retrospective'=>'Y2','OSE#Split Funded#Not Retrospective'=>'Y4','OMM#Split Funded#Not Retrospective'=>'Y2',
        'AH#Split Funded#Not Retrospective'=>'Y2','HIT#Split Funded#Not Retrospective'=>'Y2','ORB#Split Funded#Not Retrospective'=>'Y2',
        'ASA#Split Funded#Not Retrospective'=>'Y2','ARP#Split Funded#Not Retrospective'=>'Y4','OTH#Split Funded#Not Retrospective'=>'Y2',
        'KEY#Split Funded#Not Retrospective'=>'Y4','ICV#Split Funded#Not Retrospective'=>'Y4','PET#Split Funded#Not Retrospective'=>'Y2',
        'OKA#Split Funded#Not Retrospective'=>'Y4','IPP#Split Funded#Not Retrospective'=>'Y4','MDR#Split Funded#Not Retrospective'=>'Y5',
        'SEL#Split Funded#Not Retrospective'=>'Y4','IVL#Split Funded#Not Retrospective'=>'Y4','SG#Split Funded#Not Retrospective'=>'Y4',
        'AWC#Split Funded#Not Retrospective'=>'Y2','OID#Split Funded#Not Retrospective'=>'Y2','SH#Split Funded#Not Retrospective'=>'Y4',
        'AHM#Split Funded#Not Retrospective'=>'Y2','LCP#Split Funded#Not Retrospective'=>'Y2','SRC#Split Funded#Not Retrospective'=>'Y4',
        'AHP#Split Funded#Not Retrospective'=>'Y2','MDC#Split Funded#Not Retrospective'=>'Y2','VOL#Split Funded#Not Retrospective'=>'Y2',
        'NAB#Split Funded#Not Retrospective'=>'Y2','MDD#Split Funded#Not Retrospective'=>'Y4','TRD#Split Funded#Not Retrospective'=>'Y2',
        'FED#Split Funded#Not Retrospective'=>'Y4','SDD#Split Funded#Not Retrospective'=>'Y4','TRO#Split Funded#Not Retrospective'=>'Y2',
        
        //Map Entries with Funding type = Split Funded
        'AAM#Split Funded#Retrospective'=>'Y2','CRC#Split Funded#Retrospective'=>'Y4','BOA#Split Funded#Retrospective'=>'Y4',
        'AES#Split Funded#Retrospective'=>'Y2','JCA#Split Funded#Retrospective'=>'Y4','NA#Split Funded#Retrospective'=>'Y4',
        'AGB#Split Funded#Retrospective'=>'Y4','NAG#Split Funded#Retrospective'=>'Y4','ONA#Split Funded#Retrospective'=>'Y4',
        'IHM#Split Funded#Retrospective'=>'Y2','OSE#Split Funded#Retrospective'=>'Y4','OMM#Split Funded#Retrospective'=>'Y2',
        'AH#Split Funded#Retrospective'=>'Y2','HIT#Split Funded#Retrospective'=>'Y2','ORB#Split Funded#Retrospective'=>'Y2',
        'ASA#Split Funded#Retrospective'=>'Y2','ARP#Split Funded#Retrospective'=>'Y4','OTH#Split Funded#Retrospective'=>'Y2',
        'KEY#Split Funded#Retrospective'=>'Y4','ICV#Split Funded#Retrospective'=>'Y4','PET#Split Funded#Retrospective'=>'Y2',
        'OKA#Split Funded#Retrospective'=>'Y4','IPP#Split Funded#Retrospective'=>'Y4','MDR#Split Funded#Retrospective'=>'Y5',
        'SEL#Split Funded#Retrospective'=>'Y4','IVL#Split Funded#Retrospective'=>'Y4','SG#Split Funded#Retrospective'=>'Y4',
        'AWC#Split Funded#Retrospective'=>'Y2','OID#Split Funded#Retrospective'=>'Y2','SH#Split Funded#Retrospective'=>'Y4',
        'AHM#Split Funded#Retrospective'=>'Y2','LCP#Split Funded#Retrospective'=>'Y2','SRC#Split Funded#Retrospective'=>'Y4',
        'AHP#Split Funded#Retrospective'=>'Y2','MDC#Split Funded#Retrospective'=>'Y2','VOL#Split Funded#Retrospective'=>'Y2',
        'NAB#Split Funded#Retrospective'=>'Y2','MDD#Split Funded#Retrospective'=>'Y4','TRD#Split Funded#Retrospective'=>'Y2',
        'FED#Split Funded#Retrospective'=>'Y4','SDD#Split Funded#Retrospective'=>'Y4','TRO#Split Funded#Retrospective'=>'Y2',
    
        //Map Entries with Funding type = Fully Insured and Rating = Retrospective
        'AAM#Fully Insured#Retrospective'=>'Y2','CRC#Fully Insured#Retrospective'=>'Y4','BOA#Fully Insured#Retrospective'=>'Y4',
        'AES#Fully Insured#Retrospective'=>'Y2','JCA#Fully Insured#Retrospective'=>'Y4','NA#Fully Insured#Retrospective'=>'Y4',
        'AGB#Fully Insured#Retrospective'=>'Y4','NAG#Fully Insured#Retrospective'=>'Y4','ONA#Fully Insured#Retrospective'=>'Y4',
        'IHM#Fully Insured#Retrospective'=>'Y2','OSE#Fully Insured#Retrospective'=>'Y4','OMM#Fully Insured#Retrospective'=>'Y2',
        'AH#Fully Insured#Retrospective'=>'Y2','HIT#Fully Insured#Retrospective'=>'Y2','ORB#Fully Insured#Retrospective'=>'Y2',
        'ASA#Fully Insured#Retrospective'=>'Y2','ARP#Fully Insured#Retrospective'=>'Y4','OTH#Fully Insured#Retrospective'=>'Y2',
        'KEY#Fully Insured#Retrospective'=>'Y4','ICV#Fully Insured#Retrospective'=>'Y4','PET#Fully Insured#Retrospective'=>'Y2',
        'OKA#Fully Insured#Retrospective'=>'Y4','IPP#Fully Insured#Retrospective'=>'Y4','MDR#Fully Insured#Retrospective'=>'Y5',
        'SEL#Fully Insured#Retrospective'=>'Y4','IVL#Fully Insured#Retrospective'=>'Y4','SG#Fully Insured#Retrospective'=>'Y4',
        'AWC#Fully Insured#Retrospective'=>'Y2','OID#Fully Insured#Retrospective'=>'Y2','SH#Fully Insured#Retrospective'=>'Y4',
        'AHM#Fully Insured#Retrospective'=>'Y2','LCP#Fully Insured#Retrospective'=>'Y2','SRC#Fully Insured#Retrospective'=>'Y4',
        'AHP#Fully Insured#Retrospective'=>'Y2','MDC#Fully Insured#Retrospective'=>'Y2','VOL#Fully Insured#Retrospective'=>'Y2',
        'NAB#Fully Insured#Retrospective'=>'Y2','MDD#Fully Insured#Retrospective'=>'Y4','TRD#Fully Insured#Retrospective'=>'Y2',
        'FED#Fully Insured#Retrospective'=>'Y4','SDD#Fully Insured#Retrospective'=>'Y4','TRO#Fully Insured#Retrospective'=>'Y2',
    
        //Map Entries with Funding type = Fully Insured and Rating = Not Retrospective
        'AAM#Fully Insured#Not Retrospective'=>'Y2','CRC#Fully Insured#Not Retrospective'=>'Y3','BOA#Fully Insured#Not Retrospective'=>'Y3',
        'AES#Fully Insured#Not Retrospective'=>'Y2','JCA#Fully Insured#Not Retrospective'=>'Y3','NA#Fully Insured#Not Retrospective'=>'Y3',
        'AGB#Fully Insured#Not Retrospective'=>'Y3','NAG#Fully Insured#Not Retrospective'=>'Y3','ONA#Fully Insured#Not Retrospective'=>'Y3',
        'IHM#Fully Insured#Not Retrospective'=>'Y2','OSE#Fully Insured#Not Retrospective'=>'Y3','OMM#Fully Insured#Not Retrospective'=>'Y2',
        'AH#Fully Insured#Not Retrospective'=>'Y2','HIT#Fully Insured#Not Retrospective'=>'Y2','ORB#Fully Insured#Not Retrospective'=>'Y2',
        'ASA#Fully Insured#Not Retrospective'=>'Y2','ARP#Fully Insured#Not Retrospective'=>'Y4','OTH#Fully Insured#Not Retrospective'=>'Y2',
        'KEY#Fully Insured#Not Retrospective'=>'Y3','ICV#Fully Insured#Not Retrospective'=>'Y4','PET#Fully Insured#Not Retrospective'=>'Y2',
        'OKA#Fully Insured#Not Retrospective'=>'Y4','IPP#Fully Insured#Not Retrospective'=>'Y4','MDR#Fully Insured#Not Retrospective'=>'Y5',
        'SEL#Fully Insured#Not Retrospective'=>'Y4','IVL#Fully Insured#Not Retrospective'=>'Y4','SG#Fully Insured#Not Retrospective'=>'Y4',
        'AWC#Fully Insured#Not Retrospective'=>'Y2','OID#Fully Insured#Not Retrospective'=>'Y2','SH#Fully Insured#Not Retrospective'=>'Y3',
        'AHM#Fully Insured#Not Retrospective'=>'Y2','LCP#Fully Insured#Not Retrospective'=>'Y2','SRC#Fully Insured#Not Retrospective'=>'Y4',
        'AHP#Fully Insured#Not Retrospective'=>'Y2','MDC#Fully Insured#Not Retrospective'=>'Y2','VOL#Fully Insured#Not Retrospective'=>'Y2',
        'NAB#Fully Insured#Not Retrospective'=>'Y2','MDD#Fully Insured#Not Retrospective'=>'Y3','TRD#Fully Insured#Not Retrospective'=>'Y2',
        'FED#Fully Insured#Not Retrospective'=>'Y3','SDD#Fully Insured#Not Retrospective'=>'Y3','TRO#Fully Insured#Not Retrospective'=>'Y2'
   };
   
   
     // Retail Y-Schedule Map
     public static Map<String,String> scheduleHMOMap = new Map<String,String>{      
        'AAM#Self Insured'=>'Y2',
        'AES#Self Insured'=>'Y2',
        'AGB#Self Insured'=>'Y3',
        'IHM#Self Insured'=>'Y2',
        'AH#Self Insured'=>'Y2',
        'ASA#Self Insured'=>'Y2',
        'KEY#Self Insured'=>'Y3',
        'OKA#Self Insured'=>'Y4',
        'SEL#Self Insured'=>'Y2',
        'AWC#Self Insured'=>'Y2',
        'AHM#Self Insured'=>'Y2',
        'AHP#Self Insured'=>'Y2',
        'NAB#Self Insured'=>'Y2',
        'FED#Self Insured'=>'Y3',
        'CRC#Self Insured'=>'Y3',
        'JCA#Self Insured'=>'Y3',
        'NAG#Self Insured'=>'Y3',
        'OSE#Self Insured'=>'Y3',
        'HIT#Self Insured'=>'Y2',
        'ARP#Self Insured'=>'Y4',
        'ICV#Self Insured'=>'Y4',
        'IPP#Self Insured'=>'Y4',
        'IVL#Self Insured'=>'Y4',
        'OID#Self Insured'=>'Y2',
        'LCP#Self Insured'=>'Y2',
        'MDC#Self Insured'=>'Y2',
        'MDD#Self Insured'=>'Y3',
        'SDD#Self Insured'=>'Y3',
        'BOA#Self Insured'=>'Y3',
        'NA#Self Insured'=>'Y3',
        'ONA#Self Insured'=>'Y3',
        'OMM#Self Insured'=>'Y2',
        'ORB#Self Insured'=>'Y2',
        'OTH#Self Insured'=>'Y2',
        'PET#Self Insured'=>'Y2',
        'MDR#Self Insured'=>'Y5',
        'SG#Self Insured'=>'Y4',
        'SH#Self Insured'=>'Y3',
        'SRC#Self Insured'=>'Y3',
        'VOL#Self Insured'=>'Y2',
        'TRD#Self Insured'=>'Y2',
        'TRO#Self Insured'=>'Y2',
        'AAM#Fully Insured'=>'Y2',
        'AES#Fully Insured'=>'Y2',
        'AGB#Fully Insured'=>'Y3',
        'IHM#Fully Insured'=>'Y2',
        'AH#Fully Insured'=>'Y2',
        'ASA#Fully Insured'=>'Y2',
        'KEY#Fully Insured'=>'Y3',
        'OKA#Fully Insured'=>'Y4',
        'SEL#Fully Insured'=>'Y4',
        'AWC#Fully Insured'=>'Y2',
        'AHM#Fully Insured'=>'Y2',
        'AHP#Fully Insured'=>'Y2',
        'NAB#Fully Insured'=>'Y2',
        'FED#Fully Insured'=>'Y3',
        'CRC#Fully Insured'=>'Y3',
        'JCA#Fully Insured'=>'Y3',
        'NAG#Fully Insured'=>'Y3',
        'OSE#Fully Insured'=>'Y3',
        'HIT#Fully Insured'=>'Y2',
        'ARP#Fully Insured'=>'Y4',
        'ICV#Fully Insured'=>'Y4',
        'IPP#Fully Insured'=>'Y4',
        'IVL#Fully Insured'=>'Y4',
        'OID#Fully Insured'=>'Y2',
        'LCP#Fully Insured'=>'Y2',
        'MDC#Fully Insured'=>'Y2',
        'MDD#Fully Insured'=>'Y3',
        'SDD#Fully Insured'=>'Y3',
        'BOA#Fully Insured'=>'Y3',
        'NA#Fully Insured'=>'Y3',
        'ONA#Fully Insured'=>'Y3',
        'OMM#Fully Insured'=>'Y2',
        'ORB#Fully Insured'=>'Y2',
        'OTH#Fully Insured'=>'Y2',
        'PET#Fully Insured'=>'Y2',
        'MDR#Fully Insured'=>'Y5',
        'SG#Fully Insured'=>'Y4',
        'SH#Fully Insured'=>'Y3',
        'SRC#Fully Insured'=>'Y4',
        'VOL#Fully Insured'=>'Y2',
        'TRD#Fully Insured'=>'Y2',
        'TRO#Fully Insured'=>'Y2'
    };
  
   // Mail Y-Schedule Map
   Public static Map<string,string> scheduleMailMap = new Map<String,String>{      
        //Map Entries with Funding type = Self Insured          
        'AAM#Self Insured#Not Retrospective'=>'Y4','CRC#Self Insured#Not Retrospective'=>'Y3','BOA#Self Insured#Not Retrospective'=>'Y3',
        'AES#Self Insured#Not Retrospective'=>'Y4','JCA#Self Insured#Not Retrospective'=>'Y3','NA#Self Insured#Not Retrospective'=>'Y3',
        'AGB#Self Insured#Not Retrospective'=>'Y3','NAG#Self Insured#Not Retrospective'=>'Y3','ONA#Self Insured#Not Retrospective'=>'Y3',
        'IHM#Self Insured#Not Retrospective'=>'Y4','OSE#Self Insured#Not Retrospective'=>'Y3','OMM#Self Insured#Not Retrospective'=>'Y4',
        'AH#Self Insured#Not Retrospective'=>'Y4','HIT#Self Insured#Not Retrospective'=>'Y4','ORB#Self Insured#Not Retrospective'=>'Y4',
        'ASA#Self Insured#Not Retrospective'=>'Y4','ARP#Self Insured#Not Retrospective'=>'Y4','OTH#Self Insured#Not Retrospective'=>'Y4',
        'KEY#Self Insured#Not Retrospective'=>'Y3','ICV#Self Insured#Not Retrospective'=>'Y4','PET#Self Insured#Not Retrospective'=>'Y4',
        'OKA#Self Insured#Not Retrospective'=>'Y4','IPP#Self Insured#Not Retrospective'=>'Y4','MDR#Self Insured#Not Retrospective'=>'',
        'SEL#Self Insured#Not Retrospective'=>'Y2','IVL#Self Insured#Not Retrospective'=>'Y4','SG#Self Insured#Not Retrospective'=>'Y4',
        'AWC#Self Insured#Not Retrospective'=>'Y4','OID#Self Insured#Not Retrospective'=>'Y4','SH#Self Insured#Not Retrospective'=>'Y3',
        'AHM#Self Insured#Not Retrospective'=>'Y4','LCP#Self Insured#Not Retrospective'=>'Y4','SRC#Self Insured#Not Retrospective'=>'Y3',
        'AHP#Self Insured#Not Retrospective'=>'Y4','MDC#Self Insured#Not Retrospective'=>'Y4','VOL#Self Insured#Not Retrospective'=>'Y3',
        'NAB#Self Insured#Not Retrospective'=>'Y4','MDD#Self Insured#Not Retrospective'=>'Y3','TRD#Self Insured#Not Retrospective'=>'Y4',
        'FED#Self Insured#Not Retrospective'=>'Y3','SDD#Self Insured#Not Retrospective'=>'Y3','TRO#Self Insured#Not Retrospective'=>'Y4',
        
         //Map Entries with Funding type = Self Insured          
        'AAM#Self Insured#Retrospective'=>'Y2','CRC#Self Insured#Retrospective'=>'Y3','BOA#Self Insured#Retrospective'=>'Y3',
        'AES#Self Insured#Retrospective'=>'Y2','JCA#Self Insured#Retrospective'=>'Y3','NA#Self Insured#Retrospective'=>'Y3',
        'AGB#Self Insured#Retrospective'=>'Y3','NAG#Self Insured#Retrospective'=>'Y3','ONA#Self Insured#Retrospective'=>'Y2',
        'IHM#Self Insured#Retrospective'=>'Y2','OSE#Self Insured#Retrospective'=>'Y2','OMM#Self Insured#Retrospective'=>'Y2',
        'AH#Self Insured#Retrospective'=>'Y2','HIT#Self Insured#Retrospective'=>'Y2','ORB#Self Insured#Retrospective'=>'Y2',
        'ASA#Self Insured#Retrospective'=>'Y2','ARP#Self Insured#Retrospective'=>'Y2','OTH#Self Insured#Retrospective'=>'Y2',
        'KEY#Self Insured#Retrospective'=>'Y3','ICV#Self Insured#Retrospective'=>'Y2','PET#Self Insured#Retrospective'=>'Y2',
        'OKA#Self Insured#Retrospective'=>'Y4','IPP#Self Insured#Retrospective'=>'Y2','MDR#Self Insured#Retrospective'=>'Y5',
        'SEL#Self Insured#Retrospective'=>'Y2','IVL#Self Insured#Retrospective'=>'Y2','SG#Self Insured#Retrospective'=>'Y2',
        'AWC#Self Insured#Retrospective'=>'Y2','OID#Self Insured#Retrospective'=>'Y2','SH#Self Insured#Retrospective'=>'Y3',
        'AHM#Self Insured#Retrospective'=>'Y2','LCP#Self Insured#Retrospective'=>'Y2','SRC#Self Insured#Retrospective'=>'Y4',
        'AHP#Self Insured#Retrospective'=>'Y2','MDC#Self Insured#Retrospective'=>'Y2','VOL#Self Insured#Retrospective'=>'Y2',
        'NAB#Self Insured#Retrospective'=>'Y2','MDD#Self Insured#Retrospective'=>'Y3','TRD#Self Insured#Retrospective'=>'Y2',
        'FED#Self Insured#Retrospective'=>'Y3','SDD#Self Insured#Retrospective'=>'Y3','TRO#Self Insured#Retrospective'=>'Y2',
        
        //Map Entries with Funding type = Split Funded
        'AAM#Split Funded#Not Retrospective'=>'Y4','CRC#Split Funded#Not Retrospective'=>'Y4','BOA#Split Funded#Not Retrospective'=>'Y4',
        'AES#Split Funded#Not Retrospective'=>'Y4','JCA#Split Funded#Not Retrospective'=>'Y4','NA#Split Funded#Not Retrospective'=>'Y4',
        'AGB#Split Funded#Not Retrospective'=>'Y4','NAG#Split Funded#Not Retrospective'=>'Y4','ONA#Split Funded#Not Retrospective'=>'Y4',
        'IHM#Split Funded#Not Retrospective'=>'Y4','OSE#Split Funded#Not Retrospective'=>'Y4','OMM#Split Funded#Not Retrospective'=>'Y4',
        'AH#Split Funded#Not Retrospective'=>'Y4','HIT#Split Funded#Not Retrospective'=>'Y4','ORB#Split Funded#Not Retrospective'=>'Y4',
        'ASA#Split Funded#Not Retrospective'=>'Y4','ARP#Split Funded#Not Retrospective'=>'Y4','OTH#Split Funded#Not Retrospective'=>'Y4',
        'KEY#Split Funded#Not Retrospective'=>'Y4','ICV#Split Funded#Not Retrospective'=>'Y4','PET#Split Funded#Not Retrospective'=>'Y4',
        'OKA#Split Funded#Not Retrospective'=>'Y4','IPP#Split Funded#Not Retrospective'=>'Y4','MDR#Split Funded#Not Retrospective'=>'',
        'SEL#Split Funded#Not Retrospective'=>'Y4','IVL#Split Funded#Not Retrospective'=>'Y4','SG#Split Funded#Not Retrospective'=>'Y4',
        'AWC#Split Funded#Not Retrospective'=>'Y4','OID#Split Funded#Not Retrospective'=>'Y4','SH#Split Funded#Not Retrospective'=>'Y4',
        'AHM#Split Funded#Not Retrospective'=>'Y4','LCP#Split Funded#Not Retrospective'=>'Y4','SRC#Split Funded#Not Retrospective'=>'Y4',
        'AHP#Split Funded#Not Retrospective'=>'Y4','MDC#Split Funded#Not Retrospective'=>'Y4','VOL#Split Funded#Not Retrospective'=>'Y4',
        'NAB#Split Funded#Not Retrospective'=>'Y4','MDD#Split Funded#Not Retrospective'=>'Y4','TRD#Split Funded#Not Retrospective'=>'Y4',
        'FED#Split Funded#Not Retrospective'=>'Y4','SDD#Split Funded#Not Retrospective'=>'Y4','TRO#Split Funded#Not Retrospective'=>'Y4',
    
        //Map Entries with Funding type = Fully Insured and Rating = Retrospective
        'AAM#Fully Insured#Retrospective'=>'Y4','CRC#Fully Insured#Retrospective'=>'Y4','BOA#Fully Insured#Retrospective'=>'Y4',
        'AES#Fully Insured#Retrospective'=>'Y4','JCA#Fully Insured#Retrospective'=>'Y4','NA#Fully Insured#Retrospective'=>'Y4',
        'AGB#Fully Insured#Retrospective'=>'Y4','NAG#Fully Insured#Retrospective'=>'Y4','ONA#Fully Insured#Retrospective'=>'Y4',
        'IHM#Fully Insured#Retrospective'=>'Y4','OSE#Fully Insured#Retrospective'=>'Y4','OMM#Fully Insured#Retrospective'=>'Y4',
        'AH#Fully Insured#Retrospective'=>'Y4','HIT#Fully Insured#Retrospective'=>'Y4','ORB#Fully Insured#Retrospective'=>'Y4',
        'ASA#Fully Insured#Retrospective'=>'Y4','ARP#Fully Insured#Retrospective'=>'Y4','OTH#Fully Insured#Retrospective'=>'Y4',
        'KEY#Fully Insured#Retrospective'=>'Y4','ICV#Fully Insured#Retrospective'=>'Y4','PET#Fully Insured#Retrospective'=>'Y4',
        'OKA#Fully Insured#Retrospective'=>'Y4','IPP#Fully Insured#Retrospective'=>'Y4','MDR#Fully Insured#Retrospective'=>'',
        'SEL#Fully Insured#Retrospective'=>'Y4','IVL#Fully Insured#Retrospective'=>'Y4','SG#Fully Insured#Retrospective'=>'Y4',
        'AWC#Fully Insured#Retrospective'=>'Y4','OID#Fully Insured#Retrospective'=>'Y4','SH#Fully Insured#Retrospective'=>'Y4',
        'AHM#Fully Insured#Retrospective'=>'Y4','LCP#Fully Insured#Retrospective'=>'Y4','SRC#Fully Insured#Retrospective'=>'Y4',
        'AHP#Fully Insured#Retrospective'=>'Y4','MDC#Fully Insured#Retrospective'=>'Y4','VOL#Fully Insured#Retrospective'=>'Y4',
        'NAB#Fully Insured#Retrospective'=>'Y4','MDD#Fully Insured#Retrospective'=>'Y4','TRD#Fully Insured#Retrospective'=>'Y4',
        'FED#Fully Insured#Retrospective'=>'Y4','SDD#Fully Insured#Retrospective'=>'Y4','TRO#Fully Insured#Retrospective'=>'Y4',
    
        //Map Entries with Funding type = Fully Insured and Rating = Not Retrospective
        'AAM#Fully Insured#Not Retrospective'=>'Y4','CRC#Fully Insured#Not Retrospective'=>'Y3','BOA#Fully Insured#Not Retrospective'=>'Y3',
        'AES#Fully Insured#Not Retrospective'=>'Y4','JCA#Fully Insured#Not Retrospective'=>'Y3','NA#Fully Insured#Not Retrospective'=>'Y3',
        'AGB#Fully Insured#Not Retrospective'=>'Y3','NAG#Fully Insured#Not Retrospective'=>'Y3','ONA#Fully Insured#Not Retrospective'=>'Y3',
        'IHM#Fully Insured#Not Retrospective'=>'Y4','OSE#Fully Insured#Not Retrospective'=>'Y3','OMM#Fully Insured#Not Retrospective'=>'Y4',
        'AH#Fully Insured#Not Retrospective'=>'Y4','HIT#Fully Insured#Not Retrospective'=>'Y4','ORB#Fully Insured#Not Retrospective'=>'Y4',
        'ASA#Fully Insured#Not Retrospective'=>'Y4','ARP#Fully Insured#Not Retrospective'=>'Y4','OTH#Fully Insured#Not Retrospective'=>'Y4',
        'KEY#Fully Insured#Not Retrospective'=>'Y3','ICV#Fully Insured#Not Retrospective'=>'Y4','PET#Fully Insured#Not Retrospective'=>'Y4',
        'OKA#Fully Insured#Not Retrospective'=>'Y4','IPP#Fully Insured#Not Retrospective'=>'Y4','MDR#Fully Insured#Not Retrospective'=>'',
        'SEL#Fully Insured#Not Retrospective'=>'Y4','IVL#Fully Insured#Not Retrospective'=>'Y4','SG#Fully Insured#Not Retrospective'=>'Y4',
        'AWC#Fully Insured#Not Retrospective'=>'Y4','OID#Fully Insured#Not Retrospective'=>'Y4','SH#Fully Insured#Not Retrospective'=>'Y3',
        'AHM#Fully Insured#Not Retrospective'=>'Y4','LCP#Fully Insured#Not Retrospective'=>'Y4','SRC#Fully Insured#Not Retrospective'=>'Y4',
        'AHP#Fully Insured#Not Retrospective'=>'Y4','MDC#Fully Insured#Not Retrospective'=>'Y4','VOL#Fully Insured#Not Retrospective'=>'Y4',
        'NAB#Fully Insured#Not Retrospective'=>'Y4','MDD#Fully Insured#Not Retrospective'=>'Y3','TRD#Fully Insured#Not Retrospective'=>'Y4',
        'FED#Fully Insured#Not Retrospective'=>'Y3','SDD#Fully Insured#Not Retrospective'=>'Y3','TRO#Fully Insured#Not Retrospective'=>'Y4'  
    };
}