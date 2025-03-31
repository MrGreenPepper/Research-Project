$call gdxxrw.exe negCap_scenarioPerc.xlsx par=omega_RL_in rng=Sheet1!A1:BA2143 dim=2 rdim=1 cdim=1 log=log_omega_RL_in.txt
$call gdxxrw.exe negCap_scenarioValues.xlsx par=p_in_RL rng=Sheet1!A1:BA2143 dim=2 rdim=1 cdim=1 log=log_p_in_RL.txt
$call gdxxrw.exe posCap_scenarioPerc.xlsx par=omega_RL_out rng=Sheet1!A1:BA2143 dim=2 rdim=1 cdim=1 log=log_omega_RL_out.txt
$call gdxxrw.exe posCap_scenarioValues.xlsx par=p_out_RL rng=Sheet1!A1:BA2143 dim=2 rdim=1 cdim=1 log=log_p_out_RL.txt

$call gdxxrw.exe da_prices_scenarioPerc.xlsx par=omega_DA rng=Sheet1!A1:BA8569 dim=2 rdim=1 cdim=1 log=log_omega_DA.txt
$call gdxxrw.exe da_prices_scenarioValues.xlsx par=p_DA rng=Sheet1!A1:BA8569 dim=2 rdim=1 cdim=1 log=log_p_DA.txt

$call gdxxrw.exe negEnAverage_scenarioPerc.xlsx par=omega_RA_in rng=Sheet1!A1:BA34945 dim=2 rdim=1 cdim=1 log=log_omega_RA_in.txt
$call gdxxrw.exe negEnAverage_scenarioPerc_call.xlsx par=omega_RA_in_call rng=Sheet1!A1:BA34945  dim=2 rdim=1 cdim=1 log=log_omega_RA_in_call.txt
$call gdxxrw.exe negEnAverage_scenarioValues.xlsx par=p_in_RA rng=Sheet1!A1:BA34945 dim=2 rdim=1 cdim=1 log=log_p_in_RA.txt
$call gdxxrw.exe posEnAverage_scenarioPerc.xlsx par=omega_RA_out rng=Sheet1!A1:BA34945 dim=2 rdim=1 cdim=1 log=log_omega_RA_out.txt
$call gdxxrw.exe posEnAverage_scenarioPerc_call.xlsx par=omega_RA_out_call rng=Sheet1!A1:BA34945 dim=2 rdim=1 cdim=1 log=log_omega_RA_out.txt
$call gdxxrw.exe posEnAverage_scenarioValues.xlsx par=p_out_RA rng=Sheet1!A1:BA34945 dim=2 rdim=1 cdim=1 log=log_p_out_RA.txt

$call gdxxrw.exe posEnAvg_expValues.xlsx par=RA_out_expV rng=Sheet1!A2:B34945 dim=1 rdim=1 log=log_RA_out_expV.txt
$call gdxxrw.exe negEnAvg_expValues.xlsx par=RA_in_expV rng=Sheet1!A2:B34945 dim=1 rdim=1 log=log_RA_in_expV.txt