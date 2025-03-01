Sets
t 				/t1*t1/
s				/s1*s3/	
dtOne			/dtOne1 * dtOne4/	
dtTwo			/dtTwo * dtTwo/	
dtThree			/dtThree1 * dtThree4/	
;


Parameter
pricePower(dtOne)						/dtOne1 0.8, dtOne2 1, dtOne3 1.2, dtOne4 0/
pricePowerProb(dtOne)					/dtOne1 0.8, dtOne2 0.5, dtOne3 0.2, dtOne4 1/
priceWind(dtTwo)						/dtTwo1 0.8, dtTwo2 1, dtTwo3 1.2, dtTwo4 0/
priceWindProb(dtTwo)					/dtTwo1 0.8, dtTwo2 0.5, dtTwo3 0.2, dtTwo4 1/
priceEnergy(dtThree)					/dtone1 0.8, dtone2 1, dtone3 1.2, dtone4 0/
priceEnergyProb(dtThree)				/dtone1 0.8, dtone2 0.5, dtone3 0.2, dtone4 1/
;

Binary Variable
StrategyDecision1(dtOne)
StrategyDecision2(dtTwo)
StrategyDecision3(dtThree)
profit
;

Positive Variable
capacityPowerQ(dt)
capacityEnergyQ(dttwo)

Equations
ProfitDTOne						
ProfitDTTwo
profitDThree						

singleTreeConstraint

binConOne
binConTwo
binConThree
;


profitEQ..					ProfitDTOne =e=	sum(dtOne, StrategyDecision1(dtOne) * priceCapacity(dtOne) * priceCapProb(dtOne));
profitEQ..					ProfitDTTwo =e=	sum(dtTwo, StrategyDecision2(dtTwo) * priceWind(dtTwo) * priceWindProb(dtTwo));
profitEQ..					ProfitDThree =e=	sum(dtThree, StrategyDecision3(dtThree) * priceEnergy(dtThree) * priceEnergyProb(dtThree));

binConOne..					1 =e= sum(dtOne, StrategyDecision1(dtOne))				
binConTwo..					1 =e= sum(dtTwo, StrategyDecision2(dtTwo))				
binConThree..					1 =e= sum(dtThree, StrategyDecision3(dtThree))				
profitEQ..					profit  =e= ProfitDTOne + ProfitDTTwo + ProfitDThree;




