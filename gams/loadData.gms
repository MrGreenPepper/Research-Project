

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

Scalars

RA_out_expV         /169.19651581508515/
RA_in_expV          /-15.332207041895279/
;


$call gdxxrw.exe RApriceDown_scenarioPerc.xlsx par=omega_RA_in_call rng=Sheet1!A1:B102 dim=1 rdim=1 log=log_omega_RA_in.txt
Parameter omega_RA_in_call(s_in_RA)
$gdxIn RApriceDown_scenarioPerc.gdx
$load omega_RA_in_call 
$gdxIn
;

$call gdxxrw.exe RApriceUP_scenarioPerc.xlsx par=omega_RA_out_call rng=Sheet1!A1:B102 dim=1 rdim=1 log=log_omega_RA_out.txt
Parameter omega_RA_out_call(s_out_RA)
$gdxIn RApriceUP_scenarioPerc.gdx
$load omega_RA_out_call 
$gdxIn
;


$call gdxxrw.exe RA_probMods_pos.xlsx par=RA_probMod_pos rng=Sheet1!A2:B100 dim=1 rdim=1 log=log_RA_probMods_pos.txt
Parameter RA_probMod_pos(ser)
$gdxIn RA_probMods_pos.gdx
$load RA_probMod_pos 
$gdxIn
;

$call gdxxrw.exe RA_probMods_neg.xlsx par=RA_probMod_neg rng=Sheet1!A2:B100 dim=1 rdim=1 log=log_RA_probMods_neg.txt
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

