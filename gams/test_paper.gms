Set
scenariosDA         /sDA1*sDA3/
scenariosRT         /sRT1*sRT3/
timesteps           /t1*t10/
;

Parameter
pricesDA(scenariosDA)           /sDA1 80, sDA2 90, sDA3 100/
probDA(scenariosDA)             /sDA1 0.8, sDA2 0.5, sDA3 0.3/

pricesRT(scenariosRT)           /sRT1 80, sRT2 90, sRT3 100/
probRT(scenariosRT)             /sRT1 0.8, sRT2 0.5, sRT3 0.3/
;

Scalars
transmissionRate        /100/
storageCapacity         /1000/
;

Positive Variable
StorageState
Charge
Discharge
;

Variable
ProfitVar
;

Binary Variable
ScenarioBin
ChargeBin
DisChargeBin
;

Equations
storage_min
storage_max

storage_chargeRate
storage_discchargeRate

profit
;



