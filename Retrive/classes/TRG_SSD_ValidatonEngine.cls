public class TRG_SSD_ValidatonEngine{

    public TRG_SSD_ValidatonEngine(){
    
    }
    
    public void executeValidation(list<SSD_Project__c> lstNewValues,list<SSD_Project__c> lstOldValues){
       for(SSD_Project__c project:lstNewValues){
           
           if(project.Acne_All__c == 'Include' || project.Acne_All__c == 'Exclude' || project.Acne_All__c == 'Prior Authorization'){ 
                project.Acne_All_ID__c = 'DCA-0000626';         
           }
           if(project.Bulk_Chem_Exclu_3rd_party_Rest_Thera__c == 'Exclude'){
                project.Bulk_Chem_Rest_Thera_ID__c = 'DL-0031948';
            }

           if(project.Bulk_Chem_Exclu_for_3rd_Party_Exception__c == 'Exclude'){
                project.Bulk_Chem_Excl_3rd_Party_ID__c = 'DCA-0027899';
            }

            if(project.NSA_Exclusion_Rx_only__c == 'Exclude'){
                  project.NSA_Exclusion_Rx_only_ID__c = 'DL-0016576';
            }

            if(project.Pharmaceutical_Aid_Exclusion_AHFS__c == 'Exclude'){
              project.Pharmaceutical_Aid_Exclusion_AHFS_ID__c = 'DL-0000665';
            }

            if(project.Rx_wOTC_equivalents__c == 'Exclude'){
                  project.Rx_wOTC_equivalents_ID__c = 'DL-0026717';
            }

if(project.Anabolic_Steriods__c == 'Include' || project.Anabolic_Steriods__c == 'Exclude'){project.Anabolic_Steriods_ID__c = 'DL-0000862';}
if(project.Bioidenticals__c == 'Include' || project.Bioidenticals__c == 'Exclude'){project.Bio_Identical_drug_ID__c = 'DL-0001497';}
if(project.Chemotherapy_Oral__c == 'Include' || project.Chemotherapy_Oral__c == 'Exclude'){project.Chemotherapy_Oral_ID__c = 'DL-0027079 ';}
if(project.Compounds__c == 'Include' || project.Compounds__c == 'Exclude'){project.Compounds_ID__c = 'DL-0001617';}
if(project.Diabetic_Inj_Amylin_Analogs__c == 'Include' || project.Diabetic_Inj_Amylin_Analogs__c == 'Exclude'){project.Diabetic_Inj_Amylin_Analogs_ID__c = 'DL-0001530';}
if(project.Diabetic_Inj_Incretin_Mimetics__c == 'Include' || project.Diabetic_Inj_Incretin_Mimetics__c == 'Exclude'){project.Diabetic_Inj_Incretin_Mimetics_ID__c = 'DL-0001531';}
if(project.Diabetic_bundle__c == 'Include' || project.Diabetic_bundle__c == 'Exclude'){project.Diabetic_bundle_ID__c = 'DL-0015729';}
if(project.Diabetic_Drugs_Inj_All__c == 'Include' || project.Diabetic_Drugs_Inj_All__c == 'Exclude'){project.Diabetic_Drugs_Inj_All_ID__c = 'DCA-0000704';}
if(project.Diabetic_Drugs_Inj_Insulin__c == 'Include' || project.Diabetic_Drugs_Inj_Insulin__c == 'Exclude'){project.Diabetic_Drugs_Inj_Insulin_ID__c = 'DL-0001529';}
if(project.Diabetic_Drugs_All_orals__c == 'Include' || project.Diabetic_Drugs_All_orals__c == 'Exclude'){project.Diabetic_Drugs_All_orals_ID__c = 'DL-0001532';}
if(project.Diabetic_supp_acetone_test_strips__c == 'Include' || project.Diabetic_supp_acetone_test_strips__c == 'Exclude'){project.Diabetic_supp_acetone_test_strips_ID__c = 'DL-0001559';}
if(project.Diabetic_supp_albumin_test_strips__c == 'Include' || project.Diabetic_supp_albumin_test_strips__c == 'Exclude'){project.Diabetic_supp_albumin_test_strips_ID__c = 'DL-0001546';}
if(project.Diabetic_supp_calibration_liquid__c == 'Include' || project.Diabetic_supp_calibration_liquid__c == 'Exclude'){project.Diabetic_supp_calibration_liquid_ID__c = 'DL-0001534';}
if(project.Diabetic_supp_glucose_test_strips__c == 'Include' || project.Diabetic_supp_glucose_test_strips__c == 'Exclude'){project.Diabetic_supp_glucose_test_strips_ID__c = 'DL-0001537';}
if(project.Diabetic_supp_insulin_wneedle__c == 'Include' || project.Diabetic_supp_insulin_wneedle__c == 'Exclude'){project.Diabetic_supp_insulin_wneedle_ID__c = 'DL-0001540';}
if(project.Diabetic_supp_ketone_test_strips__c == 'Include' || project.Diabetic_supp_ketone_test_strips__c == 'Exclude'){project.Diabetic_supp_ketone_test_strips_ID__c = 'DL-0001538';}
if(project.Diabetic_supp_urine_glucose_strips__c == 'Include' || project.Diabetic_supp_urine_glucose_strips__c == 'Exclude'){project.Diabetic_supp_urine_glucose_strips_ID__c = 'DL-0001547';}
if(project.Diabetic_supp_urine_multi_test_strips__c == 'Include' || project.Diabetic_supp_urine_multi_test_strips__c == 'Exclude'){project.Diabetic_supp_urine_multi_strips_ID__c = 'DL-0001548';}
if(project.Diabetic_supplies_glucose_meters__c == 'Include' || project.Diabetic_supplies_glucose_meters__c == 'Exclude'){project.Diabetic_supplies_glucose_meters_ID__c = 'DL-0001535';}
if(project.Diabetic_supplies_alcohol_swabs__c == 'Include' || project.Diabetic_supplies_alcohol_swabs__c == 'Exclude'){project.Diabetic_supplies_alcohol_swabs_ID__c = 'DL-0001533';}
if(project.Diabetic_supplies_All_except_meters__c == 'Include' || project.Diabetic_supplies_All_except_meters__c == 'Exclude'){project.Diabetic_supp_All_except_meters_ID__c = 'DCA-0000705';}
if(project.Diabetic_supplies_injection_devices__c == 'Include' || project.Diabetic_supplies_injection_devices__c == 'Exclude'){project.Diabetic_supp_injection_devices_ID__c = 'DCA-0000705';}
if(project.Diabetic_supplies_lancet_devices__c == 'Include' || project.Diabetic_supplies_lancet_devices__c == 'Exclude'){project.Diabetic_supplies_lancets_ID__c = 'DL-0001541';}
if(project.Diabetic_supplies_lancet_kits__c == 'Include' || project.Diabetic_supplies_lancet_kits__c == 'Exclude'){project.Diabetic_supplies_lancet_kits_ID__c = 'DL-0001542';}
if(project.Diabetic_supplies_lancets__c == 'Include' || project.Diabetic_supplies_lancets__c == 'Exclude'){project.Diabetic_supplies_lancets_ID__c = 'DL-0001543';}
if(project.Diabetic_supplies_needles__c == 'Include' || project.Diabetic_supplies_needles__c == 'Exclude'){project.Diabetic_supplies_needles_ID__c = 'DL-0001544';}
if(project.Durable_Medical_Equipment__c == 'Include' || project.Durable_Medical_Equipment__c == 'Exclude'){project.Durable_Medical_Equipment_ID__c = 'DL-0000831';}
if(project.EmergencyAnaphylaxis_Kits__c == 'Include' || project.EmergencyAnaphylaxis_Kits__c == 'Exclude'){project.EmergencyAnaphylaxis_Kits_ID__c = 'DL-0000860';}
if(project.Erectile_Dysfunction_All__c == 'Include' || project.Erectile_Dysfunction_All__c == 'Exclude'){project.Erectile_Dysfunction_All_ID__c = 'DL-0000858';}
if(project.Erectile_Dysfunction_CIALIS_daily__c == 'Include' || project.Erectile_Dysfunction_CIALIS_daily__c == 'Exclude'){project.Erectile_Dysfunction_CIALIS_daily_ID__c = 'DL-0012076';}
if(project.Erectile_Dysfunction_CIALIS_monthly__c == 'Include' || project.Erectile_Dysfunction_CIALIS_monthly__c == 'Exclude'){project.Erectile_Dysfunction_CIALIS_monthly_ID__c = 'DL-0012077';}
if(project.Erectile_Dysfunction_inj__c == 'Include' || project.Erectile_Dysfunction_inj__c == 'Exclude'){project.Erectile_Dysfunction_inj_ID__c = 'DL-0000854';}
if(project.Erectile_Dysfunction_LEVITRA__c == 'Include' || project.Erectile_Dysfunction_LEVITRA__c == 'Exclude'){project.Erectile_Dysfunction_LEVITRA_ID__c = 'DL-0012078';}
if(project.Erectile_Dysfunction_Oral_only__c == 'Include' || project.Erectile_Dysfunction_Oral_only__c == 'Exclude'){project.Erectile_Dysfunction_Oral_only_ID__c = 'DL-0000852';}
if(project.Erectile_Dysfunction_STAXYN__c == 'Include' || project.Erectile_Dysfunction_STAXYN__c == 'Exclude'){project.Erectile_Dysfunction_STAXYN_ID__c = 'DL-0012079';}
if(project.Erectile_Dysfunction_suppos__c == 'Include' || project.Erectile_Dysfunction_suppos__c == 'Exclude'){project.Erectile_Dysfunction_suppos_ID__c = 'DL-0000856';}
if(project.Erectile_Dysfunction_VIAGRA__c == 'Include' || project.Erectile_Dysfunction_VIAGRA__c == 'Exclude'){project.Erectile_Dysfunction_VIAGRA_ID__c = 'DL-0012080';}
if(project.Fertility_Oral__c == 'Include' || project.Fertility_Oral__c == 'Exclude'){project.Fertility_Oral_ID__c = 'DL-0000846';}
if(project.Flouride_Dental_Products__c == 'Include' || project.Flouride_Dental_Products__c == 'Exclude'){project.Flouride_Dental_Products_ID__c = 'DL-0001369';}
if(project.Immuno_Serums_Toxoids_Vaccines__c == 'Include' || project.Immuno_Serums_Toxoids_Vaccines__c == 'Exclude'){project.Immuno_Serums_Toxoids_Vaccines_ID__c = 'DL-0000679';}
if(project.Immunologicals_Blood_Derivatives__c == 'Include' || project.Immunologicals_Blood_Derivatives__c == 'Exclude'){project.Immunologicals_Blood_Derivatives_ID__c = 'DL-0000675';}
if(project.Immunologicals_Serums__c == 'Include' || project.Immunologicals_Serums__c == 'Exclude'){project.Immunologicals_Serums_ID__c = 'DL-0000682';}
if(project.Immunologicals_Toxoids__c == 'Include' || project.Immunologicals_Toxoids__c == 'Exclude'){project.Immunologicals_Toxoids_ID__c = 'DL-0000683';}
if(project.Immunologicals_Monoclonal_Antibodies__c == 'Include' || project.Immunologicals_Monoclonal_Antibodies__c == 'Exclude'){project.Immuno_Monoclonal_Antibodies_ID__c = 'DL-0000678';}
if(project.Injectables_All__c == 'Include' || project.Injectables_All__c == 'Exclude'){project.Injectables_All_ID__c = 'DL-0026716';}
if(project.Injectables_Estrogen_inj__c == 'Include' || project.Injectables_Estrogen_inj__c == 'Exclude'){project.Injectables_Estrogen_inj_ID__c = 'DL-0012689';}
if(project.Injectables_Influenza_Vaccines__c == 'Include' || project.Injectables_Influenza_Vaccines__c == 'Exclude'){project.Injectables_Influenza_Vaccines_ID__c = 'DL-0016966';}
if(project.Injectables_Methotrexate_Inj__c == 'Include' || project.Injectables_Methotrexate_Inj__c == 'Exclude'){project.Injectables_Methotrexate_Inj_ID__c = 'DL-0016965';}
if(project.Injectables_Needles_Syringes_all__c == 'Include' || project.Injectables_Needles_Syringes_all__c == 'Exclude'){project.Inject_Needles_Syringes_all_ID__c = 'DL-0013611';}
if(project.Injectables_Progesterone_inj__c == 'Include' || project.Injectables_Progesterone_inj__c == 'Exclude'){project.Injectables_Progesterone_inj_ID__c = 'DL-0014197';}
if(project.Injectables_Testosterone_inj__c == 'Include' || project.Injectables_Testosterone_inj__c == 'Exclude'){project.Injectables_Testosterone_inj_ID__c = 'DL-0012202';}
if(project.Injectables_Vitamin_B12_inj__c == 'Include' || project.Injectables_Vitamin_B12_inj__c == 'Exclude'){project.Injectables_Vitamin_B12_inj_ID__c = 'DL-0014198';}
if(project.Injectables_Vitamin_inj__c == 'Include' || project.Injectables_Vitamin_inj__c == 'Exclude'){project.Injectables_Vitamin_inj_ID__c = 'DL-0012690';}
if(project.Local_Anesthetics_Covered__c == 'Include' || project.Local_Anesthetics_Covered__c == 'Exclude'){project.Local_Anesthetics_Covered_ID__c = 'DL-0000671';}
if(project.Nutritional_Medical_Foods__c == 'Include' || project.Nutritional_Medical_Foods__c == 'Exclude'){project.Nutritional_Medical_Foods_ID__c = 'DL-0000867';}
if(project.Nutritional_Supplements_metabolic__c == 'Include' || project.Nutritional_Supplements_metabolic__c == 'Exclude'){project.Nutritional_Supplements_metabolic_ID__c = 'DL-0000865';}
if(project.Nutritional_Supplements_ALL__c == 'Include' || project.Nutritional_Supplements_ALL__c == 'Exclude'){project.Nutritional_Supplements_ALL_ID__c = 'DL-0001597';}
if(project.OTCs_All__c == 'Include' || project.OTCs_All__c == 'Exclude'){project.OTCS_All_ID__c = 'DL-0026718';}
if(project.Smoking_Cessation_Rx_only__c == 'Include' || project.Smoking_Cessation_Rx_only__c == 'Exclude'){project.Smoking_Cessation_Rx_only_ID__c = 'DL-0000657';}
if(project.Smoking_Cessation_OTC_only__c == 'Include' || project.Smoking_Cessation_OTC_only__c == 'Exclude'){project.Smoking_Cessation_OTC_only_ID__c = 'DL-0000659';}
if(project.Smoking_Cessation_Rx_and_OTC__c == 'Include' || project.Smoking_Cessation_Rx_and_OTC__c == 'Exclude'){project.Smoking_Cessation_Rx_and_OTC_ID__c = 'DL-0000660';}
if(project.Vitamins_All__c == 'Include' || project.Vitamins_All__c == 'Exclude'){project.Vitamins_All_ID__c = 'DL-0001371';}
if(project.Vitamins_Multi__c == 'Include' || project.Vitamins_Multi__c == 'Exclude'){project.Vitamins_Multi_ID__c = 'DL-0001373';}
if(project.Vitamins_Pediatric__c == 'Include' || project.Vitamins_Pediatric__c == 'Exclude'){project.Vitamins_Pediatric_ID__c = 'DL-0001375';}
if(project.Vitamins_Prenatal__c == 'Include' || project.Vitamins_Prenatal__c == 'Exclude'){project.Vitamins_Prenatal_ID__c = 'DL-0001377';}
if(project.Vitamins_Single_entity__c == 'Include' || project.Vitamins_Single_entity__c == 'Exclude'){project.Vitamins_Single_entity_ID__c = 'DL-0001399';}

if(project.Acne_All__c == 'Include' || project.Acne_All__c == 'Exclude' || project.Acne_All__c == 'Prior Authorization'){project.Acne_All_ID__c = 'DCA-0000626';}
if(project.Acne_Differin__c == 'Include' || project.Acne_Differin__c == 'Exclude' || project.Acne_Differin__c == 'Prior Authorization'){project.Acne_Differin_ID__c = 'DL-0001361';}
if(project.Acne_Epiduo__c == 'Include' || project.Acne_Epiduo__c == 'Exclude' || project.Acne_Epiduo__c == 'Prior Authorization'){project.Acne_Epiduo_ID__c = 'DL-0001362';}
if(project.Acne_Retin_A__c == 'Include' || project.Acne_Retin_A__c == 'Exclude' || project.Acne_Retin_A__c == 'Prior Authorization'){project.Acne_Retin_A_tretinoin_ID__c = 'DL-0001363';}
if(project.Acne_Tazorac__c == 'Include' || project.Acne_Tazorac__c == 'Exclude' || project.Acne_Tazorac__c == 'Prior Authorization'){project.Acne_Tazorac_ID__c = 'DL-0001365';}
if(project.Veltin_Ziana__c == 'Include' || project.Veltin_Ziana__c == 'Exclude' || project.Veltin_Ziana__c == 'Prior Authorization'){project.Acne_Veltin_Ziana_ID__c = 'DL-0001367';}
if(project.Contraceptives_Oral__c == 'Include' || project.Contraceptives_Oral__c == 'Exclude' || project.Contraceptives_Oral__c == 'Prior Authorization'){project.Contraceptives_Oral_ID__c = 'DL-0001423';}
if(project.Contraceptives_All_Drugs__c == 'Include' || project.Contraceptives_All_Drugs__c == 'Exclude' || project.Contraceptives_All_Drugs__c == 'Prior Authorization'){project.Contraceptive_All_Drugs_ID__c = 'DCA-0000646';}
if(project.Contraceptives_All_types__c == 'Include' || project.Contraceptives_All_types__c == 'Exclude' || project.Contraceptives_All_types__c == 'Prior Authorization'){project.Contraceptives_All_Drugs_Devices_ID__c = 'DCA-0000648';}
if(project.Contraceptive_Devices_All__c == 'Include' || project.Contraceptive_Devices_All__c == 'Exclude' || project.Contraceptive_Devices_All__c == 'Prior Authorization'){project.Contraceptives_Devices_All_ID__c = 'DL-0001415';}
if(project.Contraceptives_devices_diaphragm__c == 'Include' || project.Contraceptives_devices_diaphragm__c == 'Exclude' || project.Contraceptives_devices_diaphragm__c == 'Prior Authorization'){project.Contraceptives_Devices_Diaphragm_ID__c = 'DL-0001411';}
if(project.Contraceptives_devices_IUD_and_diaphr__c == 'Include' || project.Contraceptives_devices_IUD_and_diaphr__c == 'Exclude' || project.Contraceptives_devices_IUD_and_diaphr__c == 'Prior Authorization'){project.Contraceptives_Devices_IUD_Diaphragm_ID__c = 'DCA-0000643';}
if(project.Contraceptives_devices_IUD__c == 'Include' || project.Contraceptives_devices_IUD__c == 'Exclude' || project.Contraceptives_devices_IUD__c == 'Prior Authorization'){project.Contraceptives_devices_IUD_ID__c = 'DL-0001413';}
if(project.Contraceptive_Emergency__c == 'Include' || project.Contraceptive_Emergency__c == 'Exclude' || project.Contraceptive_Emergency__c == 'Prior Authorization'){project.Contraceptives_Emergency_ID__c = 'DL-0001417';}
if(project.Contraceptive_Implants__c == 'Include' || project.Contraceptive_Implants__c == 'Exclude' || project.Contraceptive_Implants__c == 'Prior Authorization'){project.Contraceptives_Implants_ID__c = 'DL-0001419';}
if(project.Contraceptive_Injectable__c == 'Include' || project.Contraceptive_Injectable__c == 'Exclude' || project.Contraceptive_Injectable__c == 'Prior Authorization'){project.Contraceptives_Injectable_ID__c = 'DL-0001421';}
if(project.Contraceptives_Oral_Extended_Cycle__c == 'Include' || project.Contraceptives_Oral_Extended_Cycle__c == 'Exclude' || project.Contraceptives_Oral_Extended_Cycle__c == 'Prior Authorization'){project.Oral_Extended_Cycle_ID__c = 'DL-0001425';}
if(project.Contraceptives_Transdermal__c == 'Include' || project.Contraceptives_Transdermal__c == 'Exclude' || project.Contraceptives_Transdermal__c == 'Prior Authorization'){project.Contraceptives_Transdermal_ID__c = 'DL-0001426';}
if(project.Contraceptive_vaginal_ring__c == 'Include' || project.Contraceptive_vaginal_ring__c == 'Exclude' || project.Contraceptive_vaginal_ring__c == 'Prior Authorization'){project.Contraceptives_Vaginal_Ring_ID__c = 'DL-0001428';}
if(project.Fertility_All__c == 'Include' || project.Fertility_All__c == 'Exclude' || project.Fertility_All__c == 'Prior Authorization'){project.Fertility_All_ID__c = 'DL-0000850';}
if(project.Fertility_Injectable__c == 'Include' || project.Fertility_Injectable__c == 'Exclude' || project.Fertility_Injectable__c == 'Prior Authorization'){project.Fertility_Injectable_ID__c = 'DL-0000848';}
if(project.Growth_Hormone__c == 'Include' || project.Growth_Hormone__c == 'Exclude' || project.Growth_Hormone__c == 'Prior Authorization'){project.Growth_Hormone_ID__c = 'DL-0000843';}
if(project.Weight_Loss__c == 'Include' || project.Weight_Loss__c == 'Exclude' || project.Weight_Loss__c == 'Prior Authorization'){project.Weight_Loss_ID__c = 'DL-0001368';}


if(project.Bulk_Powder_exceptions_to_System_List__c == 'Include'){project.Bulk_Powder_ID__c= 'DL-0013659';}
if(project.HCR_GPIIRONSUP__c == 'Include'){project.HCR_GPIIRONSUP_ID__c = 'DL-0003135';}
if(project.HCR_aspirin__c == 'Include'){project.HCR_aspirin_ID__c = 'DL-0016962';}
if(project.HCR_contracep_coverage_Expan_PLUS__c == 'Include'){project.HCR_contracep_coverage_Expan_PLUS_ID__c = 'DL-0031048';}
if(project.HCR_contracep_coverage_Expanded__c == 'Include'){project.HCR_contracep_coverage_Expanded_ID__c = 'DL-0027703';}
if(project.HCR_contracep_coverage_Stan_PLUS__c == 'Include'){project.HCR_contracep_coverage_Stan_PLUS_ID__c = 'DL-0031047 ';}
if(project.HCR_contracep_coverage_Standard__c == 'Include'){project.HCR_contracep_coverage_Standard_ID__c = 'DL-0016570';}
if(project.HCR_folic_acid__c == 'Include'){project.HCR_folic_acid_ID__c = 'DL-0016963';}
if(project.HCR_oral_fluoride__c == 'Include'){project.HCR_oral_fluoride_ID__c = 'DL-0016964';}
if(project.Imitrex__c == 'Include'){project.Imitrex_ID__c = 'DL-0001616';}
if(project.Immuno_Vaccines_Combos_Toxoids__c == 'Include'){project.Immuno_Vaccines_Combos_Toxoids_ID__c = 'DL-0031043';}
if(project.Immunologicals_Vaccines__c == 'Include' || project.Immunologicals_Vaccines__c == 'Exclude' ){project.Immunologicals_Vaccines_ID__c = 'DL-0000684';}
if(project.Immunologicals_Vaccines_Tetanus__c == 'Include'){project.Immunologicals_Vaccines_Tetanus_ID__c = 'DL-0031042';}
if(project.Immunologicals_Vaccines_ZOSTAVAX__c == 'Include'){project.Immunologicals_Vaccines_ZOSTAVAX_ID__c = 'DL-0004347';}
if(project.Invega_Sustenna__c == 'Include'){project.Invega_Sustenna_ID__c = 'DL-0031044';}
if(project.Kit_exclusion_exceptions__c == 'Include'){project.Kit_exclusion_exceptions_ID__c = 'DL-0015328';}
if(project.Kit_logic__c == 'Include'){project.Kit_logic_ID__c = 'DL-0001498';}
if(project.Medical_Injectable_List__c == 'Include'){project.Medical_Injectable_List_ID__c = 'DL-0003394';}
if(project.OTC_Allegra__c == 'Include'){project.OTC_Allegra_ID__c = 'DL-0000876';}
if(project.OTC_Allegra_products__c == 'Include'){project.OTC_Allegra_products_ID__c = 'DCA-0000386';}
if(project.OTC_AllegraD__c == 'Include'){project.OTC_AllegraD_ID__c = 'DL-0000877';}
if(project.OTC_Axid__c == 'Include'){project.OTC_Axid_ID__c = 'DL-0031034';}
if(project.OTC_Claritin__c == 'Include'){project.OTC_Claritin_ID__c = 'DL-0000872';}
if(project.OTC_Claritin_products__c == 'Include'){project.OTC_Claritin_products_ID__c = 'DCA-0000384';}
if(project.OTC_ClaritinD__c == 'Include'){project.OTC_ClaritinD_ID__c = 'DL-0000873';}
if(project.OTC_H2s__c == 'Include'){project.OTC_H2s_ID__c = 'DCA-0027260';}
if(project.OTC_NSAs__c == 'Include'){project.OTC_NSAs_ID__c = 'DCA-0000387';}
if(project.OTC_omeprazole_only__c == 'Include'){project.OTC_omeprazole_only_ID__c = 'DL-0000869';}
if(project.OTC_Pepcid__c == 'Include'){project.OTC_Pepcid_ID__c = 'DL-0031035';}
if(project.OTC_PPIs__c == 'Include'){project.OTC_PPIs_ID__c = 'DCA-0000383';}
if(project.OTC_Prevacid__c == 'Include'){project.OTC_Prevacid_ID__c = 'DL-0000870';}
if(project.OTC_Prilosec_only__c == 'Include'){project.OTC_Prilos_only_ID__c = 'DL-0000868';}
if(project.OTC_Prilosecomeprazole__c == 'Include'){project.OTC_Prilosecomeprazole_ID__c = 'DCA-0000382';}
if(project.OTC_Tagamet__c == 'Include'){project.OTC_Tagamet_ID__c = 'DL-0031045';}
if(project.OTC_Zantac__c == 'Include'){project.OTC_Zantac_ID__c = 'DL-0031036';}
if(project.OTC_Zegerid__c == 'Include'){project.OTC_Zegerid_ID__c = 'DL-0000871';}
if(project.OTC_Zyrtec__c == 'Include'){project.OTC_Zyrtec_ID__c = 'DL-0000874';}
if(project.OTC_Zyrtec_products__c == 'Include'){project.OTC_Zyrtec_products_ID__c = 'DCA-0000385';}
if(project.OTC_ZyrtecD__c == 'Include'){project.OTC_ZyrtecD_ID__c = 'DL-0000875';}
if(project.RxOTC_override_NDC_exceptions_list__c == 'Include'){project.RxOTC_override_NDC_exceptions_list_ID__c = 'DL-0001664';}
if(project.RxOTC_SYSTEM_list_overrides__c == 'Include'){project.RxOTC_SYSTEM_list_overrides_ID__c = 'DL-0016850';}
if(project.Smoking_Cessation_Chantix__c == 'Include'){project.Smoking_Cessation_Chantix_ID__c = 'DL-0031041';}


if(project.Cosmetic_Drugs__c == 'Include' || project.Cosmetic_Drugs__c == 'Exclude'){project.Cosmetic_Drugs_ID__c = 'DL-0001430';}
if(project.Cosmetic_Minoxidil_Rogaine__c == 'Include'){project.Cosmetic_Minoxidil_Rogaine_ID__c = 'DL-0031038';}
if(project.Cosmetic_Renova__c == 'Include'){project.Cosmetic_Renova_ID__c = 'DL-0031039';}
if(project.Cosmetic_Vaniga__c == 'Include'){project.Cosmetic_Vaniga_ID__c = 'DL-0031040';}


if(project.DEA_C_I__c == 'Include' || project.DEA_C_I__c == 'Exclude'){project.DEA_C_I_ID__c = 'DL-0026719';}
if(project.DEA_C_II__c == 'Include' || project.DEA_C_II__c == 'Exclude'){project.DEA_C_II_ID__c = 'DL-0026720';}
if(project.DEA_C_III__c == 'Include' || project.DEA_C_III__c == 'Exclude'){project.DEA_C_III_ID__c = 'DL-0026721';}
if(project.DEA_C_IV__c == 'Include' || project.DEA_C_IV__c == 'Exclude'){project.DEA_C_IV_ID__c = 'DL-0026722';}
if(project.DEA_C_V__c == 'Include' || project.DEA_C_V__c == 'Exclude'){project.DEA_C_V_ID__c = 'DL-0026723';}


        }
    }
}