$include testData.gms 


Parameter
storageCapacity         /100/
;


Positive Variables
StorageUnload(t)
StorageLoad(t)
StorageLoadingStatus(t)
;

Variable
profit
;


Equations
powerBalancePos(t)
powerBalanceNeg(t)

storageManagement(t)
storageManagement2(t)
revenue
;


powerBalancePos(t)..    StorageUnload(t) =l= posDemand(t);
powerBalanceNeg(t)..    StorageLoad(t) =l= negDemand(t);


storageManagement(t)..  StorageLoadingStatus(t) =e= StorageLoadingStatus(t-1) - StorageUnload(t-1) + StorageLoad(t-1);
storageManagement2(t)..  StorageLoadingStatus(t) =l= storageCapacity;

revenue..               profit =e= sum(t,  StorageLoad(t)*10 + StorageUnload(t)*10);

model test / all / ;
solve test maximising profit using lp;