

*RL
Parameter omega_RL_in(t_block, s_in_RL)
$gdxIn negCap_scenarioPerc.gdx
$load omega_RL_in 
$gdxIn
;


Parameter p_in_RL(t_block, s_in_RL)
$gdxIn negCap_scenarioValues.gdx
$load p_in_RL 
$gdxIn
;


Parameter omega_RL_out(t_block, s_out_RL)
$gdxIn posCap_scenarioPerc.gdx
$load omega_RL_out 
$gdxIn
;


Parameter p_out_RL(t_block, s_out_RL)
$gdxIn posCap_scenarioValues.gdx
$load p_out_RL 
$gdxIn
;


*DA
$call gdxxrw.exe da_expValues.xlsx par=DA_expV rng=Sheet1!A2:B8569 dim=1 rdim=1 log=log_RA_out_expV.txt
Parameter DA_expV(t_hour)
$gdxIn da_expValues.gdx
$load DA_expV 
$gdxIn
;



Parameter omega_DA(t_hour, s_DA)
$gdxIn da_prices_scenarioPerc.gdx
$load omega_DA 
$gdxIn
;


Parameter p_DA(t_hour, s_DA)
$gdxIn da_prices_scenarioValues.gdx
$load p_DA 
$gdxIn
;


*RA

Parameter RA_out_expV(t_quarter)
$gdxIn posEnAvg_expValues.gdx
$load RA_out_expV 
$gdxIn
;

Parameter RA_in_expV(t_quarter)
$gdxIn negEnAvg_expValues.gdx
$load RA_in_expV 
$gdxIn
;


Parameter omega_RA_in_call(t_quarter, s_in_RA)
$gdxIn negEnAverage_scenarioPerc_call.gdx
$load omega_RA_in_call 
$gdxIn
;

Parameter omega_RA_out_call(t_quarter, s_out_RA)
$gdxIn posEnAverage_scenarioPerc_call.gdx
$load omega_RA_out_call 
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

*$call gdxxrw.exe windOnProfil_hour.xlsx par=parkProfile rng=Sheet1!A2:B8761 dim=1 rdim=1  log=log_capacityFactorWindOn.txt
*$call gdxxrw.exe windOffProfil_hour.xlsx par=parkProfile rng=Sheet1!A2:B8761 dim=1 rdim=1 log=log_capacityFactorWindOff.txt
*$call gdxxrw.exe solarProfil_hour.xlsx par=parkProfile rng=Sheet1!A2:B8761 dim=1 rdim=1 log=log_capacityFactorSolar.txt
Parameter parkProfile(t_hour)

$gdxIn windOnProfil_hour.gdx
*$gdxIn windOffProfil_hour.gdx
*$gdxIn solarProfil_hour.gdx

$load parkProfile
$gdxIn
;


