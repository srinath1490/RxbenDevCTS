/*Purpose: Apex Class to generate Drug List Criteria Description                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ANUJ                07/21/2011       Apex Class to generate Drug List Criteria Description 
======================================================================== */

Public Class TRG_DrugDescriptionMapping {

    Public TRG_DrugDescriptionMapping() {
	}
    Public string selectDrug(string drugTypeCode, string drugCodeValue) {
        string description = '';
        if (drugTypeCode == system.Label.CL0000003) {
            if (drugCodeValue != Null && drugCodeValue.length() == 11) {
                List < Drug__c > tempDrugList = new List < Drug__c > ([select Id, Name, NDC__c, Label_Name__c from Drug__c where NDC__c = :drugCodeValue LIMIT 1]);
                if (tempDrugList.size() != 0) {
                    Drug__c tempDrug = tempDrugList[0];
                    description = tempDrug.Label_Name__c;
                }
            } else if (drugCodeValue != Null && drugCodeValue.length() == 10) {
                string codevalue = drugCodeValue.substring(0, 9);
                string searchString = 'select Id,Name,NDC__c,Label_Name__c from Drug__c where NDC__c Like' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
                try {
                    List < Drug__c > tempDrugList = database.query(searchString);
                    if (tempDrugList.size() != 0) {
                        Drug__c tempDrug = tempDrugList[0];
                        description = 'All pack sizes of ' + tempDrug.Label_Name__c;
                    }
                } catch(exception e) {}
            } else if (drugCodeValue != Null && drugCodeValue.length() == 6) {
                string codevalue = drugCodeValue.substring(0, 5);
                string searchString = 'select Id,Name,NDC__c,Label_Name__c,Manufacturer_Labeler_Name__c from Drug__c where NDC__c Like' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
                try {
                    List < Drug__c > tempDrugList = database.query(searchString);
                    if (tempDrugList.size() != 0) {
                        Drug__c tempDrug = tempDrugList[0];
                        description = 'All products made by ' + tempDrug.Manufacturer_Labeler_Name__c;
                    }
                } catch(exception e) {}
            }
        } else if (drugTypeCode == system.Label.CL0000004) {
            if (drugCodeValue != Null && drugCodeValue.length() == 14) {
                List < Drug__c > tempDrugList = new List < Drug__c > ([select Id, Name, GPI__c, GPI_Generic_Name__c from Drug__c where GPI__c = :drugCodeValue LIMIT 1]);
                if (tempDrugList.size() != 0) {
                    Drug__c tempDrug = tempDrugList[0];
                    description = tempDrug.GPI_Generic_Name__c;
                }
            } else if (drugCodeValue != Null && drugCodeValue.length() == 13) {
                string codevalue = drugCodeValue.substring(0, 12);
                string searchString = 'select Id,Name,NDC__c,GPI_Generic_Name__c from Drug__c where GPI__c Like' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
                try {
                    List < Drug__c > tempDrugList = database.query(searchString);
                    if (tempDrugList.size() != 0) {
                        Drug__c tempDrug = tempDrugList[0];
                        description = tempDrug.GPI_Generic_Name__c;
                    }
                } catch(exception e) {}
            } else if (drugCodeValue != Null && drugCodeValue.length() == 11) {
                string codevalue = drugCodeValue.substring(0, 10);
                string searchString = 'select Id,Name,Therapeutic_Classification_Code__c,TC_GPI_Name__c,Record_Type_Code__c from TCRF_File__c where Record_Type_Code__c =' + '\'' + '4' + '\'' + ' AND Therapeutic_Classification_Code__c Like' + '\'' + codevalue + '%' + '\'' + ' LIMIT 1';
                try {
                    List < TCRF_File__c > tempTCRFList = database.query(searchString);
                    if (tempTCRFList.size() != 0) {
                        TCRF_File__c tempTCRF = tempTCRFList[0];
                        description = tempTCRF.TC_GPI_Name__c;
                    }
                } catch(exception e) {}
            } else if (drugCodeValue != Null && drugCodeValue.length() == 9) {
                string codevalue = drugCodeValue.substring(0, 8);
                string searchString = 'select Id,Name,Therapeutic_Classification_Code__c,TC_GPI_Name__c,Record_Type_Code__c from TCRF_File__c where Record_Type_Code__c =' + '\'' + '4' + '\'' + ' AND Therapeutic_Classification_Code__c Like' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
                try {
                    List < TCRF_File__c > tempTCRFList = database.query(searchString);
                    if (tempTCRFList.size() != 0) {
                        TCRF_File__c tempTCRF = tempTCRFList[0];
                        description = tempTCRF.TC_GPI_Name__c;
                    }
                } catch(exception e) {}
            } else if (drugCodeValue != Null && drugCodeValue.length() == 7) {
                string codevalue = drugCodeValue.substring(0, 6);
                string searchString = 'select Id,Name,Therapeutic_Classification_Code__c,TC_GPI_Name__c,Record_Type_Code__c from TCRF_File__c where Record_Type_Code__c =' + '\'' + '3' + '\'' + ' AND Therapeutic_Classification_Code__c Like ' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
                try {
                    List < TCRF_File__c > tempTCRFList = database.query(searchString);
                    if (tempTCRFList.size() != 0) {
                        TCRF_File__c tempTCRF = tempTCRFList[0];
                        description = tempTCRF.TC_GPI_Name__c;
                    }
                } catch(exception e) {}
            } else if (drugCodeValue != Null && drugCodeValue.length() == 5) {
                string codevalue = drugCodeValue.substring(0, 4);
                string searchString = 'select Id,Name,Therapeutic_Classification_Code__c,TC_GPI_Name__c,Record_Type_Code__c from TCRF_File__c where Record_Type_Code__c =' + '\'' + '2' + '\'' + ' AND Therapeutic_Classification_Code__c Like ' + '\'' + codevalue + '%' + '\'' + ' LIMIT 1';
                try {
                    List < TCRF_File__c > tempTCRFList = database.query(searchString);
                    if (tempTCRFList.size() != 0) {
                        TCRF_File__c tempTCRF = tempTCRFList[0];
                        description = tempTCRF.TC_GPI_Name__c;
                    }
                } catch(exception e) {}
            } else if (drugCodeValue != Null && drugCodeValue.length() == 3) {
                string codevalue = drugCodeValue.substring(0, 2);
                string searchString = 'select Id,Name,Therapeutic_Classification_Code__c,TC_GPI_Name__c,Record_Type_Code__c from TCRF_File__c where Record_Type_Code__c =' + '\'' + '1' + '\'' + ' AND Therapeutic_Classification_Code__c Like ' + '\'' + codevalue + '%' + '\'' + ' LIMIT 1';
                try {
                    List < TCRF_File__c > tempTCRFList = database.query(searchString);
                    if (tempTCRFList.size() != 0) {
                        TCRF_File__c tempTCRF = tempTCRFList[0];
                        description = tempTCRF.TC_GPI_Name__c;
                    }
                } catch(exception e) {}
            } else if (drugCodeValue != Null && drugCodeValue.length() == 1) {
                description = 'All Drugs';
            }
        }
        // Third party Restriction 
        else if (drugTypeCode == system.Label.CL0000008) {
            string fieldIdentifier = 'A068';
            List < M25VAL__c > tempDrugList = new List < M25VAL__c > ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        }
         // AHFS Therapeutic Class Code
        else if (drugTypeCode == system.Label.CL0000009) {
            description = '';
        }
        // DEA Class Code
        else if (drugTypeCode == system.Label.CL0000010) {
            //decimal fieldIdentifier = double.valuof('A039');
            string fieldIdentifier = 'A039';
            List < M25VAL__c > tempDrugList = new List < M25VAL__c > ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        } 
        //  Labeler Code
        else if (drugTypeCode == system.Label.CL0000011) {
            List < Drug__c > tempDrugList = new List < Drug__c > ([select Id, Name, NDC__c, Labeler_Code__c, Manufacturer_Labeler_Name__c from Drug__c where Labeler_Code__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                Drug__c tempDrug = tempDrugList[0];
                description = tempDrug.Manufacturer_Labeler_Name__c;
            }
        }
		// Dosage Form
		else if (drugTypeCode == system.Label.CL0000012) {
            string fieldIdentifier = 'L040';
            List < M25VAL__c > tempDrugList = new List < M25VAL__c > ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        } 
        // Repack Code
        else if (drugTypeCode == system.Label.CL0000013) {
            string fieldIdentifier = 'L059';
            List < M25VAL__c > tempDrugList = new List < M25VAL__c > ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        }
        //  DESI Code
         else if (drugTypeCode == system.Label.CL0000014) {
            string fieldIdentifier = 'L072';
            List < M25VAL__c > tempDrugList = new List < M25VAL__c > ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        } 
        //  Maintenance drug code
        else if (drugTypeCode == system.Label.CL0000015) {
            string fieldIdentifier = 'A069';
            List < M25VAL__c > tempDrugList = new List < M25VAL__c > ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        }else if (drugTypeCode == 'Rx/OTC') {
            string fieldIdentifier = 'A067';
            List <M25VAL__c> tempDrugList = new List <M25VAL__c> ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        }else if (drugTypeCode == 'Route of Administration') {
            string fieldIdentifier = 'A072';
            List <M25VAL__c> tempDrugList = new List <M25VAL__c> ([select Id, Name, Field_Value__c, Field_Identifier__c, Value_Description__c from M25VAL__c where Field_Identifier__c = :fieldIdentifier AND Field_Value__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                M25VAL__c tempDrug = tempDrugList[0];
                description = tempDrug.Value_Description__c;
            }
        } else {
            description = '';
        }

        return description;
    }
    Public string drugNDC(string NDC) {
        string description = '';
        if(NDC !=null && NDC.length() >=6){     
        string codevalue = NDC.substring(0, 5);
        string searchString = 'select Id,Name,NDC__c,Label_Name__c,Manufacturer_Labeler_Name__c from Drug__c where NDC__c Like' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
        try {
            List < Drug__c > tempDrugList = database.query(searchString);
            if (tempDrugList.size() != 0) {
                Drug__c tempDrug = tempDrugList[0];
                description = tempDrug.Manufacturer_Labeler_Name__c + ' Products ';
            }
        } catch(exception e) {}
    }
        return description;
    }
    Public string ndcDescription(string drugCodeValue) {
        string description = '';
        if (drugCodeValue != Null && drugCodeValue.length() == 11) {
            List < Drug__c > tempDrugList = new List < Drug__c > ([select Id, Name, NDC__c, Label_Name__c from Drug__c where NDC__c = :drugCodeValue LIMIT 1]);
            if (tempDrugList.size() != 0) {
                Drug__c tempDrug = tempDrugList[0];
                description = tempDrug.Label_Name__c;
            }
        } else if (drugCodeValue != Null && drugCodeValue.length() == 10) {
            string codevalue = drugCodeValue.substring(0, 9);
            string searchString = 'select Id,Name,NDC__c,Label_Name__c from Drug__c where NDC__c Like' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
            try {
                List < Drug__c > tempDrugList = database.query(searchString);
                if (tempDrugList.size() != 0) {
                    Drug__c tempDrug = tempDrugList[0];
                    description = 'All pack sizes of ' + tempDrug.Label_Name__c;
                }
            } catch(exception e) {}
        } else if (drugCodeValue != Null && drugCodeValue.length() == 6) {
            string codevalue = drugCodeValue.substring(0, 5);
            string searchString = 'select Id,Name,NDC__c,Label_Name__c,Manufacturer_Labeler_Name__c from Drug__c where NDC__c Like' + '\'' + codevalue + '%' + '\'' + 'LIMIT 1';
            try {
                List < Drug__c > tempDrugList = database.query(searchString);
                if (tempDrugList.size() != 0) {
                    Drug__c tempDrug = tempDrugList[0];
                    description = 'All products made by ' + tempDrug.Manufacturer_Labeler_Name__c;
                }
            } catch(exception e) {}
        }
        return description;
    }
}