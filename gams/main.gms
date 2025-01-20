*test Modell: freie Mengen in EnergiePark, Kapazität und Arbeit. Preise sind diskret.


$include testData.gms 


Parameter
storageCapacity         /100/
;


Positive Variables
StoragePosE(t, st)
StorageNegE(t, st)
StoragePosC(t, so)
StorageNegC(t, so)

StorageLoading(t, st)
StorageLoadingStatus(t, st)
ParkProduction(t, st)
;

Variable
StorageRevenue(t)
ParkRevenue(t)
EnergyRevenuePos(t)
EnergyRevenueNeg(t)
CapacityRevenuePos(t)
CapacityRevenueNeg(t)
profit
;

Binary Variable
ParkSwitch(t)
StorageSwitch(t)
;

Scalar
PowerConnectionCapacity     /100/
;

Equations

*power capacity   
capacityConst1(t, st)
capacityConst2(t, st, so)

*storage
storageManagement1(t, st)
storageManagement2(t, st)

storageConst1
storageConst2
storageConst3
storageConst4
storageConst5
storageConst6

*revenues
revenueP(t)
revenueEnergyPos(t)
revenueEnergyNeg(t)
revenueCapacityPos(t)
revenueCapacityNeg(t)
revenue
;


*power capacity                                         
capacityConst1(t, st)..             PowerConnectionCapacity =g= ParkProduction(t, st) + StoragePosE(t, st);
capacityConst2(t, st, so)..         PowerConnectionCapacity =g= ParkProduction(t, st) + StoragePosC(t, so);

*storage
storageManagement1(t, st)..         StorageLoadingStatus(t, st) =e= StorageLoadingStatus(t-1, st) - StoragePosE(t-1, st) + StorageNegE(t-1, st) + StorageLoading(t-1, st);
storageManagement2(t, st)..         StorageLoadingStatus(t, st) =l= storageCapacity;

storageConst1(t, st)..              StoragePosE(t, st) =l= storageCapacity;
storageConst2(t, st)..              StorageNegE(t, st) =l= storageCapacity;
storageConst3(t, so)..              StoragePosC(t, so) =l= storageCapacity;
storageConst4(t, so)..              StorageNegC(t, so) =l= storageCapacity;
storageConst5(t, st, so )..         StoragePosE(t, st) =g= StoragePosC(t, so);
storageConst6(t, st, so)..          StorageNegE(t, st) =g= StorageNegC(t, so);

*revenues
revenueP(t)..                       ParkRevenue(t) =e= sum(st, (ParkProduction(t, st) * regularMarketPrices(t) * (1-ScenarioTwoProp(st))));
revenueCapacityNeg(t)..             CapacityRevenueNeg(t) =e= sum(so, StorageNegC(t, so) * monthAvgNegC(t) * ScenarioOneFactor(so) * ScenarioOneProp(so));
revenueCapacityPos(t)..             CapacityRevenuePos(t) =e=  sum(so, StoragePosC(t, so) * monthAvgPosC(t) * ScenarioOneFactor(so) * ScenarioOneProp(so));
revenueEnergyPos(t)..               EnergyRevenuePos(t) =e= sum(st, (StoragePosE(t, st) * monthAvgPosE(t) * ScenarioTwoFactor(st) * ScenarioTwoProp(st) - StorageLoading(t, st) * regularMarketPrices(t)));
revenueEnergyNeg(t)..               EnergyRevenueNeg(t) =e= sum(st, StorageNegE(t, st) * monthAvgPosE(t) * ScenarioTwoFactor(st) * ScenarioTwoProp(st));

                                        
                                                    
revenue..                           profit =e= sum(t,  ParkRevenue(t)
                                                + EnergyRevenuePos(t) + EnergyRevenueNeg(t)
                                                + CapacityRevenueNeg(t) + CapacityRevenuePos(t));

model test / all / ;
solve test maximising profit using MIP;