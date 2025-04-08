

*RL
$call gdxxrw.exe matchingRLData_RL_scenarioProbs_neg_Q36.xlsx par=omega_RL_in rng=Sheet1!A1:BA7 dim=2 rdim=1 cdim=1 log=log_omega_RL_in.txt
Parameter omega_RL_in(t_block, s_in_RL)
$gdxIn matchingRLData_RL_scenarioProbs_neg_Q36.gdx
$load omega_RL_in 
$gdxIn
;

$call gdxxrw.exe matchingRLData_RL_scenarioProbs_pos_Q36.xlsx par=omega_RL_out rng=Sheet1!A1:BA7 dim=2 rdim=1 cdim=1 log=log_omega_RL_out.txt
Parameter omega_RL_out(t_block, s_out_RL)
$gdxIn matchingRLData_RL_scenarioProbs_pos_Q36.gdx
$load omega_RL_out 
$gdxIn
;

$call gdxxrw.exe matchingRLData_RL_scenarioValues_pos_Q36.xlsx par=p_out_RL rng=Sheet1!A1:BA7 dim=2 rdim=1 cdim=1 log=log_p_out_RL.txt
Parameter p_out_RL(t_block, s_out_RL)
$gdxIn matchingRLData_RL_scenarioValues_pos_Q36.gdx
$load p_out_RL 
$gdxIn
;

$call gdxxrw.exe matchingRLData_RL_scenarioValues_neg_Q36.xlsx par=p_in_RL rng=Sheet1!A1:BA7 dim=2 rdim=1 cdim=1 log=log_p_in_RL.txt
Parameter p_in_RL(t_block, s_in_RL)
$gdxIn matchingRLData_RL_scenarioValues_neg_Q36.gdx
$load p_in_RL 
$gdxIn
;


*DA
$call gdxxrw.exe matchingDAData_prices_Q36.xlsx par=DA_expV rng=Sheet1!A2:B25 dim=1 rdim=1 log=log_DA_expV.txt
Parameter DA_expV(t_hour)
$gdxIn matchingDAData_prices_Q36.gdx
$load DA_expV 
$gdxIn
;



*RA
$call gdxxrw.exe matchingRAData_priceNeg_Q36.xlsx par=RA_price_neg rng=Sheet1!A1:K97 dim=2 cdim=1 rdim=1 log=log_RA_price_neg.txt
Parameter RA_price_neg(t_quarter, s_RA)
$gdxIn matchingRAData_priceNeg_Q36.gdx
$load RA_price_neg 
$gdxIn
;

$call gdxxrw.exe matchingRAData_pricePos_Q36.xlsx par=RA_price_pos rng=Sheet1!A1:K97 dim=2 cdim=1 rdim=1 log=log_RA_price_pos.txt
Parameter RA_price_pos(t_quarter, s_RA)
$gdxIn matchingRAData_pricePos_Q36.gdx
$load RA_price_pos 
$gdxIn
;

$call gdxxrw.exe matchingRAData_qMax_Neg_Q36.xlsx par=q_in_RAmax rng=Sheet1!A1:K97 dim=2 cdim=1 rdim=1 log=log_q_in_RAmax.txt
Parameter q_in_RAmax(t_quarter, s_RA)
$gdxIn matchingRAData_qMax_Neg_Q36.gdx
$load q_in_RAmax 
$gdxIn
;

$call gdxxrw.exe matchingRAData_qMax_Pos_Q36.xlsx par=q_out_RAmax rng=Sheet1!A1:K97 dim=2 cdim=1 rdim=1 log=log_q_out_RAmax.txt
Parameter q_out_RAmax(t_quarter, s_RA)
$gdxIn matchingRAData_qMax_Pos_Q36.gdx
$load q_out_RAmax 
$gdxIn
;






*$call gdxxrw.exe RA_probMods_pos.xlsx par=RA_probMod_pos rng=Sheet1!A2:B100 dim=1 rdim=1 log=log_RA_probMods_pos.txt
Parameter RA_probMod_pos(ser)
$gdxIn RA_probMods_pos.gdx
$load RA_probMod_pos 
$gdxIn
;

*$call gdxxrw.exe RA_probMods_neg.xlsx par=RA_probMod_neg rng=Sheet1!A2:B100 dim=1 rdim=1 log=log_RA_probMods_neg.txt
Parameter RA_probMod_neg(ser)
$gdxIn RA_probMods_neg.gdx
$load RA_probMod_neg 
$gdxIn
;

*Parameter p_in_RA(t_quarter, s_in_RA)
*$gdxIn negEnAverage_scenarioValues.gdx
*$load p_in_RA 
*$gdxIn
*;


*Parameter omega_RA_out(t_quarter, s_out_RA)
*$gdxIn posEnAverage_scenarioPerc.gdx
*$load omega_RA_out 
*$gdxIn
*;

*Parameter p_out_RA(t_quarter, s_out_RA)
*$gdxIn posEnAverage_scenarioValues.gdx
*$load p_out_RA 
*$gdxIn
*; 
*
*Parameter omega_RA_in(t_quarter, s_in_RA)
*$gdxIn negEnAverage_scenarioPerc.gdx
*$load omega_RA_in 
*$gdxIn
*;

$call gdxxrw.exe matchingDAData_prod_Q36.xlsx par=parkProfile rng=Sheet1!A2:B25 dim=1 rdim=1  log=log_capacityFactorWindOn.txt
**$call gdxxrw.exe windOffProfil_hour.xlsx par=parkProfile rng=Sheet1!A2:B8761 dim=1 rdim=1 log=log_capacityFactorWindOff.txt
**$call gdxxrw.exe solarProfil_hour.xlsx par=parkProfile rng=Sheet1!A2:B8761 dim=1 rdim=1 log=log_capacityFactorSolar.txt
Parameter parkProfile(t_hour)
$gdxIn matchingDAData_prod_Q36.gdx
*$gdxIn windOffProfil_hour.gdx
*$gdxIn solarProfil_hour.gdx

$load parkProfile
$gdxIn
;

