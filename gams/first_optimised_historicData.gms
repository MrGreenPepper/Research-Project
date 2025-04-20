*$include loadFullSet
*$include loadTestSet

$include loadHistoricSet

*$include convertData.gms
*$include loadData_historic_Q1.gms
*$include loadData_historic_Q18.gms
$include loadData_historic_Q36.gms


*assign correct mapping
Loop(t_hour, 
    Loop(t_quarter$(ord(t_quarter) > 4 * (ord(t_hour) - 1) and ord(t_quarter) <= 4 * ord(t_hour)), 
        map_quarter_hour(t_quarter, t_hour) = YES;
    );
);

Loop(t_block, 
    Loop(t_quarter$(ord(t_quarter) > 16 * (ord(t_block) - 1) and ord(t_quarter) <= 16 * ord(t_block)), 
        map_quarter_block(t_quarter, t_block) = YES;
    );
);

Loop(t_block, 
    Loop(t_hour$(ord(t_hour) > 4 * (ord(t_block) - 1) and ord(t_hour) <= 4 * ord(t_block)), 
        map_hour_block(t_hour, t_block) = YES;
    );
);


Scalars
    a           /12/
    rBat        /0.95/
    batCosts    /60/
    parkCap     /6/
	rl_factor 	/0.25/
    m           /10000000/
	workingPointFactor /3/
	probRA

	BatCap         /10/
	strict_aCon    /1/
    strict_BatCon  /1/
;
 

probRA = (1 / card(s_RA));

Variables
seriesOne

Profit
profitRLout
profitRLin
profitDA
profitRAout
profitRAin

*sum
sum_Q_in_RL
sum_Q_out_RL
sum_Q_rB_DA
sum_Q_outrB_RA
sum_Q_inrB_RA
sum_Q_rB_reload
sum_Q_outrI_RA
sum_Q_inrI_RA
sum_Q_rI_DA
sum_Q_rI_reload
sum_Q_outrO_RA
sum_Q_inrO_RA
sum_Q_rO_DA
sum_Q_rO_reload
sum_Q_outrN_RA
sum_Q_inrN_RA
sum_Q_rN_DA
sum_Q_reload

testV1
testV2
testV3
testV4
testV5
testV6
testV7
;



Variable
meanQRA_max_in
meanQRA_max_out

priceMean_RLin
priceMean_RLout
priceMean_DA
priceMean_RAin
priceMean_RAout


omega_RA_outrN_call
omega_RA_outrB_call
omega_RA_outrI_call
omega_RA_outrO_call
omega_RA_inrN_call
omega_RA_inrB_call
omega_RA_inrI_call
omega_RA_inrO_call

testV
sumRLOut
sumRLin

sumSum_Q_RL_in
sumSum_Q_RL_out
sumSum_Q_DA
sumSum_Q_RA_in
sumSum_Q_RA_out
;

Positive Variables
     
workingCosts
BatStat(t_quarter, s_RA)
r


* accepted  RL\ in \ out:
Q_in_RL(t_block, s_in_RL)
Q_out_RL(t_block, s_out_RL)
Q_rB_DA(t_hour, s_in_RL, s_out_RL)
Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_rB_reload(t_hour, s_in_RL, s_out_RL)

*accepted RL in     \ declined out:
Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_rI_DA(t_hour, s_in_RL, s_out_RL)
Q_rI_reload(t_hour, s_in_RL, s_out_RL)

*declined RL in\ accepted out:
Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_rO_DA(t_hour, s_in_RL, s_out_RL)
Q_rO_reload(t_hour, s_in_RL, s_out_RL)

*declined RL in\ out:
Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
Q_rN_DA(t_hour, s_in_RL, s_out_RL)
Q_reload(t_hour, s_in_RL, s_out_RL)

*reload
Q_rB_reload(t_hour, s_in_RL, s_out_RL)
Q_rI_reload(t_hour, s_in_RL, s_out_RL)
Q_rO_reload(t_hour, s_in_RL, s_out_RL)
Q_rN_reload(t_hour, s_in_RL, s_out_RL)

*fakeReload
fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 

emerg_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
emerg_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
emerg_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
emerg_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
emerg_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
emerg_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
emerg_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
emerg_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)
;

Equations
profitEQ
workingCostsEQ
*   constraints:
*battery cap
*batCapCalc
*batter cap restrictions
batStatCap  

batCap_Q_out_RL
batCap_Q_in_RL

batCap_Q_outrB_RA
batCap_Q_outrI_RA
batCap_Q_outrO_RA
batCap_Q_outrN_RA

batCap_Q_inrB_RA
batCap_Q_inrI_RA
batCap_Q_inrO_RA
batCap_Q_inrN_RA

*access point:
accPointCon_a_B
accPointCon_a_I
accPointCon_a_O
accPointCon_a_N

accPointCon_a_B_in
accPointCon_a_I_in
accPointCon_a_O_in
accPointCon_a_N_in

accPointCon_RLout
accPointCon_RLin

accPointCon_a_B_strict
accPointCon_a_I_strict
accPointCon_a_O_strict
accPointCon_a_N_strict
accPointCon_a_B_in_strict
accPointCon_a_I_in_strict
accPointCon_a_O_in_strict
accPointCon_a_N_in_strict

*battery status restrictions
batStatcon_

fakeReload_inrB_RAEQ
fakeReload_outrB_RAEQ
fakeReload_inrI_RAEQ
fakeReload_outrI_RAEQ
fakeReload_inrO_RAEQ
fakeReload_outrO_RAEQ
fakeReload_inrN_RAEQ
fakeReload_outrN_RAEQ

*battery performance restrictions:
calc_r
storCon_Q_out_RL
storCon_Q_in_RL

storCon_Q_outrB_RA
storCon_Q_outrI_RA
storCon_Q_outrO_RA
storCon_Q_outrN_RA

storCon_Q_inrB_RA
storCon_Q_inrI_RA
storCon_Q_inrO_RA
storCon_Q_inrN_RA


*park restrictions:
parkCon_Q_rB_DA
parkCon_Q_rI_DA
parkCon_Q_rO_DA
parkCon_Q_rN_DA

*profits
profit_RLout_EQ
profit_RLin_EQ
profit_DA_EQ
profit_RAout_EQ
profit_RAin_EQ

*sums
sum_Q_in_RL_EQ
sum_Q_out_RL_EQ
sum_Q_rB_DA_EQ
sum_Q_outrB_RA_EQ
sum_Q_inrB_RA_EQ
sum_Q_rB_reload_EQ
sum_Q_outrI_RA_EQ
sum_Q_inrI_RA_EQ
sum_Q_rI_DA_EQ
sum_Q_rI_reload_EQ
sum_Q_outrO_RA_EQ
sum_Q_inrO_RA_EQ
sum_Q_rO_DA_EQ
sum_Q_rO_reload_EQ
sum_Q_outrN_RA_EQ
sum_Q_inrN_RA_EQ
sum_Q_rN_DA_EQ
sum_Q_reload_EQ



Q_inrB_RA_EQ
Q_inrO_RA_EQ
Q_inrI_RA_EQ
Q_inrN_RA_EQ
Q_outrB_RA_EQ
Q_outrI_RA_EQ
Q_outrO_RA_EQ
Q_outrN_RA_EQ

Q_in_RL_EQ
Q_out_RL_EQ

BatCapEQ
Q_in_RL_max
Q_out_RL_max
Q_in_RL_max_a
Q_out_RL_max_a

*analyse
priceMean_RLin_EQ
priceMean_RLout_EQ
priceMean_DA_EQ
priceMean_RAin_EQ
priceMean_RAout_EQ

testEQ1
testEQ2
testEQ3
testEQ4
testEQ5
testEQ6
testEQ7

meanQRA_max_in_EQ
meanQRA_max_out_EQ

sumSum_Q_RL_in_EQ
sumSum_Q_RL_out_EQ
sumSum_Q_DA_EQ
sumSum_Q_RA_in_EQ
sumSum_Q_RA_out_EQ
;



*analyse
*testEQ1(t_quarter)..                       testV1(t_quarter) =e=  sum(t_block$map_quarter_block(t_quarter, t_block),sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)) * (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))));
*testEQ2(t_block)..                       sumRLout(t_block) =e= sum((s_out_RL), Q_out_RL(t_block, s_out_RL));
*testEQ3(t_block)..                       sumRLin(t_block) =e= sum((s_in_RL), Q_in_RL(t_block, s_in_RL));
*testEQ4..                                testV4 =e= sum(t_block, sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (             
*                                                            + (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))))));
testEQ5..                       testV5 =e= sum(t_quarter, sum(t_block$map_quarter_block(t_quarter, t_block), sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (             
                                                            + (0.25 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL))))))));
testEQ6(t_quarter)..                       testV6(t_quarter) =e= sum(t_block$map_quarter_block(t_quarter, t_block), ord(t_quarter));
testEQ7(t_quarter)..                       testV7(t_quarter) =e= sum(t_block$map_quarter_block(t_quarter, t_block), 16 * ord(t_block) - ord(t_quarter));


testEQ1(t_quarter, s_RA)..					testV1(t_quarter, s_RA) =e=  sum(t_block$map_quarter_block(t_quarter, t_block), sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))  * (  (Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )))));
testEQ2(t_quarter, s_RA)..					testV2(t_quarter, s_RA) =e=  sum(t_block$map_quarter_block(t_quarter, t_block), sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))    * (Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))));
testEQ3(t_quarter, s_RA)..					testV3(t_quarter, s_RA) =e=  sum(t_block$map_quarter_block(t_quarter, t_block),sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))  * (Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))));
testEQ4(t_quarter, s_RA)..					testV4(t_quarter, s_RA) =e=  sum(t_block$map_quarter_block(t_quarter, t_block),sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))) * (Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))));

priceMean_RLin_EQ..						priceMean_RLin =e= sum((t_block, s_in_RL) , p_in_RL(t_block, s_in_RL))  / (card(t_block)*	card(s_in_RL))	;				
priceMean_RLout_EQ..						priceMean_RLout =e= sum((t_block, s_out_RL) , p_out_RL(t_block, s_out_RL))	 / (card(t_block)* card(s_out_RL));					
priceMean_DA_EQ..						    priceMean_DA =e= sum(t_hour , DA_expV(t_hour)) / (card(t_hour));						
priceMean_RAin_EQ..						priceMean_RAin =e= sum((t_quarter, s_RA) , RA_price_neg(t_quarter, s_RA))	/ (96*card(s_RA))	;				
priceMean_RAout_EQ..						priceMean_RAout =e= sum((t_quarter, s_RA) , RA_price_pos(t_quarter, s_RA))   / (96*card(s_RA))	;	

meanQRA_max_in_EQ..							meanQRA_max_in =e= 	sum((t_quarter, s_RA) , q_in_RAmax(t_quarter, s_RA))   / (96*card(s_RA))	;
meanQRA_max_out_EQ..							meanQRA_max_out =e= 	sum((t_quarter, s_RA) , q_out_RAmax(t_quarter, s_RA))   / (96*card(s_RA))	;
 
*obj function:
profitEQ..      Profit  =e= 
                - (BatCap * batCosts)
				- workingCosts
                + sum(t_quarter, 
				+ sum(t_block$map_quarter_block(t_quarter, t_block),
				+ sum(t_hour$map_quarter_hour(t_quarter, t_hour),
* accepted  RL\ in \ out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (
                        + (rl_factor * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                       
                        + (rl_factor * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + (0.25 * ((Q_rB_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)  )))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))       
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  )) 
*accepted RL in     \ declined out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (
                        + (rl_factor * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
                        + (0.25 * ((Q_rI_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour))))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))      
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  ))                      
*declined RL in     \ accepted out:
                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (
                        + (rl_factor * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + (0.25 * ((Q_rO_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour))))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))       
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  ))
*declined RL in\ out:
                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (
                        + (0.25 * ((Q_rN_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour))))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))        
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  ))
                )));
 

workingCostsEQ..						workingCosts =e= sum(t_quarter,
				sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))           * (
                                                    
                        + sum(s_RA, emerg_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * RA_price_pos(t_quarter, s_RA) * workingPointFactor * probRA))
                        + sum(s_RA, emerg_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) *RA_price_neg(t_quarter, s_RA) * workingPointFactor  * probRA)  		))        
*
*accepted RL in     \ declined out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))       * (
                                                     
                        + sum(s_RA, emerg_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * RA_price_pos(t_quarter, s_RA) * workingPointFactor * probRA))
                        + sum(s_RA, emerg_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) *RA_price_neg(t_quarter, s_RA) * workingPointFactor  * probRA)		))
                            
*declined RL in     \ accepted out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL)))       * (
                                                    
                        + sum(s_RA, emerg_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * RA_price_pos(t_quarter, s_RA) * workingPointFactor * probRA))
                        + sum(s_RA, emerg_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) *RA_price_neg(t_quarter, s_RA) * workingPointFactor  * probRA)		))    
*
*declined RL in\ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))))       * (
                                                        
                        + sum(s_RA, emerg_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * RA_price_pos(t_quarter, s_RA) * workingPointFactor * probRA))
                        + sum(s_RA, emerg_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) *RA_price_neg(t_quarter, s_RA) * workingPointFactor  * probRA) 		))
				);

*profits
*profit RL
profit_RLout_EQ..                       profitRLout =e= + sum(t_block,
                                        + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (             
                                            + (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL))))))
                                        + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))  * (
                                            + (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))))));
                                        
profit_RLin_EQ..                        profitRLin =e= + sum(t_block,
                                        + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (
                                            + (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL))))))                        
                                            
                                        + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))  * (
                                            + (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL))))))
                                            );

*profit DA
profit_DA_EQ..                          profitDA =e= sum(t_block,
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rB_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)  ))
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rI_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)    ))
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rO_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)    ))
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rN_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)    ))
                                                )))
                                                );

*profit RA
profit_RAin_EQ..                       profitRAin =e= sum(t_block,
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), sum(s_RA, RA_price_neg(t_quarter, s_RA) * Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)  * probRA )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  sum(s_RA, RA_price_neg(t_quarter, s_RA) * Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * probRA )      )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  sum(s_RA, RA_price_neg(t_quarter, s_RA) * Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * probRA )      )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  sum(s_RA, RA_price_neg(t_quarter, s_RA) * Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * probRA )      )
                                                )))
                                                );
profit_RAout_EQ..                        profitRAout =e= sum(t_block,
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), sum(s_RA, RA_price_pos(t_quarter, s_RA) * Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)  * probRA )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), sum(s_RA, RA_price_pos(t_quarter, s_RA) * Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)  * probRA )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), sum(s_RA, RA_price_pos(t_quarter, s_RA) * Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * probRA )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), sum(s_RA, RA_price_pos(t_quarter, s_RA) * Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * probRA )    )
                                                )))
                                                );

* accepted  RL\ in \ out:
sum_Q_in_RL_EQ(t_block)..                                sum_Q_in_RL(t_block) =e= sum((s_in_RL), Q_in_RL(t_block, s_in_RL));
sum_Q_out_RL_EQ(t_block)..                               sum_Q_out_RL(t_block) =e= sum((s_out_RL), Q_out_RL(t_block, s_out_RL));
sum_Q_rB_DA_EQ(t_hour)..                      			sum_Q_rB_DA(t_hour) =e= sum((s_in_RL, s_out_RL), Q_rB_DA(t_hour, s_in_RL, s_out_RL));
sum_Q_outrB_RA_EQ(t_quarter)..                             sum_Q_outrB_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrB_RA_EQ(t_quarter)..                              sum_Q_inrB_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rB_reload_EQ(t_hour)..                                sum_Q_rB_reload(t_hour) =e= sum((s_in_RL, s_out_RL), Q_rB_reload(t_hour, s_in_RL, s_out_RL));

*accepted RL in     \ declined out:
sum_Q_outrI_RA_EQ(t_quarter)..                             sum_Q_outrI_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrI_RA_EQ(t_quarter)..                              sum_Q_inrI_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rI_DA_EQ(t_hour)..                               sum_Q_rI_DA(t_hour) =e= sum((s_in_RL, s_out_RL), Q_rI_DA(t_hour, s_in_RL, s_out_RL)                            );
sum_Q_rI_reload_EQ(t_hour)..                                sum_Q_rI_reload(t_hour) =e= sum((s_in_RL, s_out_RL), Q_rI_reload(t_hour, s_in_RL, s_out_RL)                         );

*declined RL in\ accepted out:
sum_Q_outrO_RA_EQ(t_quarter)..                             sum_Q_outrO_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrO_RA_EQ(t_quarter)..                              sum_Q_inrO_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rO_DA_EQ(t_hour)..                               sum_Q_rO_DA(t_hour) =e= sum((s_in_RL, s_out_RL), Q_rO_DA(t_hour, s_in_RL, s_out_RL)                            );
sum_Q_rO_reload_EQ(t_hour)..                                sum_Q_rO_reload(t_hour) =e= sum((s_in_RL, s_out_RL), Q_rO_reload(t_hour, s_in_RL, s_out_RL)                         );

*declined RL in\ out:
sum_Q_outrN_RA_EQ(t_quarter)..                             sum_Q_outrN_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrN_RA_EQ(t_quarter)..                              sum_Q_inrN_RA(t_quarter) =e= sum((s_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rN_DA_EQ(t_hour)..                                sum_Q_rN_DA(t_hour) =e= sum((s_in_RL, s_out_RL), Q_rN_DA(t_hour, s_in_RL, s_out_RL)                         );
sum_Q_reload_EQ(t_hour)..                               sum_Q_reload(t_hour) =e= sum((s_in_RL, s_out_RL), Q_reload(t_hour, s_in_RL, s_out_RL));

sumSum_Q_RL_in_EQ..										  sumSum_Q_RL_in =e= sum(t_block,  sum_Q_in_RL(t_block));
sumSum_Q_RL_out_EQ..										sumSum_Q_RL_out =e= sum(t_block, sum_Q_out_RL(t_block));
sumSum_Q_DA_EQ..										sumSum_Q_DA =e= sum(t_hour, sum_Q_rN_DA(t_hour) + sum_Q_rO_DA(t_hour) + sum_Q_rI_DA(t_hour) + sum_Q_rB_DA(t_hour));
sumSum_Q_RA_in_EQ..										sumSum_Q_RA_in =e= sum(t_quarter, sum_Q_inrN_RA(t_quarter) + sum_Q_inrO_RA(t_quarter) + sum_Q_inrI_RA(t_quarter) + sum_Q_inrB_RA(t_quarter));
sumSum_Q_RA_out_EQ..										sumSum_Q_RA_out =e= sum(t_quarter, sum_Q_outrN_RA(t_quarter) + sum_Q_outrO_RA(t_quarter) + sum_Q_outrI_RA(t_quarter) + sum_Q_outrB_RA(t_quarter));
*   constraints
*battery cap
**batCapCalc..                        BatCap =g= max(Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA);
*batCapCalc..                       BatCap =g= max( Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA,
*                                                   Q_in_RL * 4, Q_out_RL * 4);


*access point:
accPointCon_a_B(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_I(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_O(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_N(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));


accPointCon_a_B_in(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))  =g= sum((s_in_RL, s_out_RL), fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_I_in(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))  =g= sum((s_in_RL, s_out_RL), fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_O_in(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))  =g= sum((s_in_RL, s_out_RL), fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_N_in(t_quarter, s_RA)..        a*0.25 + sum((s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))  =g= sum((s_in_RL, s_out_RL), fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));

accPointCon_RLout(t_quarter)..						a =g= sum((s_out_RL), sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL)));
accPointCon_RLin(t_quarter)..						a =g= sum((s_in_RL), sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL)));

accPointCon_a_B_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_I_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_O_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_N_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_in_RL, s_out_RL), fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_B_in_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_in_RL, s_out_RL), fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_I_in_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_in_RL, s_out_RL), fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_O_in_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_in_RL, s_out_RL), fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_N_in_strict(t_quarter, s_RA)..        a*0.25 =g= strict_aCon * sum((s_in_RL, s_out_RL), fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));

*battery performance restrictions:
calc_r..                                        r =e= BatCap * 0.168 * rBat;
storCon_Q_out_RL(t_block)..                     sum(s_out_RL, Q_out_RL(t_block, s_out_RL))          =l= r;
storCon_Q_in_RL(t_block)..                      sum(s_in_RL, Q_in_RL(t_block, s_in_RL))             =l= r;


storCon_Q_outrB_RA(t_quarter, s_RA)..                 sum((s_in_RL, s_out_rl), Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrI_RA(t_quarter, s_RA)..                 sum((s_in_RL, s_out_rl), Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrO_RA(t_quarter, s_RA)..                 sum((s_in_RL, s_out_rl), Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrN_RA(t_quarter, s_RA)..                 sum((s_in_RL, s_out_rl), Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;

storCon_Q_inrB_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrI_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrO_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrN_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;

*batter cap restrictions
batStatCap(t_quarter, s_RA)..                         BatStat(t_quarter, s_RA) =l= BatCap;  
batCap_Q_out_RL(t_block)..                      sum(s_out_RL, Q_out_RL(t_block, s_out_RL)) * 4      =l= BatCap;
batCap_Q_in_RL(t_block)..                       sum(s_in_RL, Q_in_RL(t_block, s_in_RL)) * 4         =l= BatCap;

batCap_Q_outrB_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_rl), Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrI_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_rl), Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrO_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_rl), Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrN_RA(t_quarter, s_RA)..                  sum((s_in_RL, s_out_rl), Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;

batCap_Q_inrB_RA(t_quarter, s_RA)..                   sum((s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrI_RA(t_quarter, s_RA)..                   sum((s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrO_RA(t_quarter, s_RA)..                   sum((s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrN_RA(t_quarter, s_RA)..                   sum((s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;

*battery status restrictions
*expectet battery value in t+1:
batStatcon_(t_quarter, s_RA)..                    BatStat(t_quarter + 1, s_RA) =e= BatStat(t_quarter, s_RA)         
*accepted  RL\ in \ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))           * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                         
                        + (probRA * (fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - (probRA * (fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )))     
*
*accepted RL in     \ declined out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + (probRA * (fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - (probRA * (fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )))
                            
*declined RL in     \ accepted out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL)))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + (probRA * (fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - (probRA * (fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )))     
*
*declined RL in\ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + (probRA * (fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - (probRA * (fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )));
*

fakeReload_inrB_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 		fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 		=e= emerg_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)  ;
fakeReload_outrB_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 	fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=e= emerg_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) ;
fakeReload_inrI_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 		fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 		=e= emerg_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)  ;
fakeReload_outrI_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 	fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=e= emerg_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) ;
fakeReload_inrO_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 		fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 		=e= emerg_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)  ;
fakeReload_outrO_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 	fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=e= emerg_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) ;
fakeReload_inrN_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 		fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 		=e= emerg_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)  ;
fakeReload_outrN_RAEQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 	fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=e= emerg_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) ;
*spmOne(t_quarter, s_RA, s_in_RL, s_out_RL)..                         testSPM(t_quarter, s_RA) =e= omega_RA_out_call(t_quarter, s_RA) - 0.1 * seriesOne(t_quarter, s_RA, s_in_RL, s_out_RL);
*binconO(t_quarter, s_RA, s_in_RL, s_out_RL)..                         0 =l= Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + (m * (1-seriesOne(t_quarter, s_RA, s_in_RL, s_out_RL)));                                         
*binconT(t_quarter, s_RA, s_in_RL, s_out_RL)..                         0 =g= Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) - (m * seriesOne(t_quarter, s_RA, s_in_RL, s_out_RL)); 


*RA dynamics 
*out


*park restrictions:
parkCon_Q_rB_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rB_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rB_reload(t_hour, s_in_RL, s_out_RL));
parkCon_Q_rI_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rI_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rI_reload(t_hour, s_in_RL, s_out_RL));
parkCon_Q_rO_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rO_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rO_reload(t_hour, s_in_RL, s_out_RL));
parkCon_Q_rN_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rN_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rN_reload(t_hour, s_in_RL, s_out_RL));




*market restrictions:
*marketCon_outrB_RA(t_quarter, s_in_RL, s_out_RL)..                 ( Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));
*marketCon_outrO_RA(t_quarter, s_in_RL, s_out_RL)..                 ( Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));
*marketCon_inrI_RA(t_quarter, s_in_RL, s_out_RL)..                  ( Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));
*marketCon_inrB_RA(t_quarter, s_in_RL, s_out_RL)..                  ( Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));

*marketCon_outrI_RA(t_quarter)..                ( Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));
*marketCon_out_RA(t_quarter)..                  ( Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));

*marketCon_inrO_RA(t_quarter)..                 ( Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));
*marketCon_in_RA(t_quarter)..                   ( Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) )         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));



* accepted  RL\ in \ out:
Q_inrB_RA_EQ(t_quarter, s_RA).. 						sum((s_in_RL, s_out_RL),Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_inrO_RA_EQ(t_quarter, s_RA).. 						sum((s_in_RL, s_out_RL),Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_inrI_RA_EQ(t_quarter, s_RA).. 						sum((s_in_RL, s_out_RL),Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_inrN_RA_EQ(t_quarter, s_RA).. 						sum((s_in_RL, s_out_RL),Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_outrB_RA_EQ(t_quarter, s_RA).. 					sum((s_in_RL, s_out_RL),Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_out_RAmax(t_quarter, s_RA);
Q_outrI_RA_EQ(t_quarter, s_RA).. 					sum((s_in_RL, s_out_RL),Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_out_RAmax(t_quarter, s_RA);
Q_outrO_RA_EQ(t_quarter, s_RA).. 					sum((s_in_RL, s_out_RL),Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_out_RAmax(t_quarter, s_RA);
Q_outrN_RA_EQ(t_quarter, s_RA).. 					sum((s_in_RL, s_out_RL),Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) 	=l= q_out_RAmax(t_quarter, s_RA);


Q_in_RL_EQ(t_quarter, s_in_RL, s_RA)..				sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL)	* 0.25 * ( strict_BatCon * (16 * ord(t_block) - ord(t_quarter)))) =l= BatCap - BatStat(t_quarter, s_RA);
Q_out_RL_EQ(t_quarter, s_out_RL, s_RA)..			sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL)	* 0.25 * ( strict_BatCon * (16 * ord(t_block) - ord(t_quarter)))) =l= BatStat(t_quarter, s_RA);
*accepted RL in     \ declined out:
*declined RL in\ accepted out:
*declined RL in\ out:

BatCapEQ..                                          BatCap =g= 0;
Q_in_RL_max(t_block)..								sum( s_in_RL, Q_in_RL(t_block, s_in_RL)) =l= 5;
Q_out_RL_max(t_block)..								sum( s_out_RL, Q_out_RL(t_block, s_out_RL)) =l= 5;
Q_in_RL_max_a(t_block)..                              sum( s_in_RL, Q_in_RL(t_block, s_in_RL)) =l= a;
Q_out_RL_max_a(t_block)..                             sum( s_out_RL, Q_out_RL(t_block, s_out_RL)) =l= a;


Model testFirstDecision /all/;
Solve testFirstDecision maximising Profit using MIP;


execute_unload "res_sum_Q_in_RL.gdx" sum_Q_in_RL.l
execute 'gdxxrw.exe res_sum_Q_in_RL.gdx o=res_sum_Q_in_RL.xlsx var=sum_Q_in_RL.L'				
execute_unload "res_sum_Q_out_RL.gdx" sum_Q_out_RL.l
execute 'gdxxrw.exe res_sum_Q_out_RL.gdx o=res_sum_Q_out_RL.xlsx var=sum_Q_out_RL.L'				
execute_unload "res_sum_Q_rB_DA.gdx" sum_Q_rB_DA.l
execute 'gdxxrw.exe res_sum_Q_rB_DA.gdx o=res_sum_Q_rB_DA.xlsx var=sum_Q_rB_DA.L'				
execute_unload "res_sum_Q_outrB_RA.gdx" sum_Q_outrB_RA.l
execute 'gdxxrw.exe res_sum_Q_outrB_RA.gdx o=res_sum_Q_outrB_RA.xlsx var=sum_Q_outrB_RA.L'				
execute_unload "res_sum_Q_inrB_RA.gdx" sum_Q_inrB_RA.l
execute 'gdxxrw.exe res_sum_Q_inrB_RA.gdx o=res_sum_Q_inrB_RA.xlsx var=sum_Q_inrB_RA.L'				
execute_unload "res_sum_Q_rB_reload.gdx" sum_Q_rB_reload.l
execute 'gdxxrw.exe res_sum_Q_rB_reload.gdx o=res_sum_Q_rB_reload.xlsx var=sum_Q_rB_reload.L'				
execute_unload "res_sum_Q_outrI_RA.gdx" sum_Q_outrI_RA.l
execute 'gdxxrw.exe res_sum_Q_outrI_RA.gdx o=res_sum_Q_outrI_RA.xlsx var=sum_Q_outrI_RA.L'				
execute_unload "res_sum_Q_inrI_RA.gdx" sum_Q_inrI_RA.l
execute 'gdxxrw.exe res_sum_Q_inrI_RA.gdx o=res_sum_Q_inrI_RA.xlsx var=sum_Q_inrI_RA.L'				
execute_unload "res_sum_Q_rI_DA.gdx" sum_Q_rI_DA.l
execute 'gdxxrw.exe res_sum_Q_rI_DA.gdx o=res_sum_Q_rI_DA.xlsx var=sum_Q_rI_DA.L'				
execute_unload "res_sum_Q_rI_reload.gdx" sum_Q_rI_reload.l
execute 'gdxxrw.exe res_sum_Q_rI_reload.gdx o=res_sum_Q_rI_reload.xlsx var=sum_Q_rI_reload.L'				
execute_unload "res_sum_Q_outrO_RA.gdx" sum_Q_outrO_RA.l
execute 'gdxxrw.exe res_sum_Q_outrO_RA.gdx o=res_sum_Q_outrO_RA.xlsx var=sum_Q_outrO_RA.L'				
execute_unload "res_sum_Q_inrO_RA.gdx" sum_Q_inrO_RA.l
execute 'gdxxrw.exe res_sum_Q_inrO_RA.gdx o=res_sum_Q_inrO_RA.xlsx var=sum_Q_inrO_RA.L'				
execute_unload "res_sum_Q_rO_DA.gdx" sum_Q_rO_DA.l
execute 'gdxxrw.exe res_sum_Q_rO_DA.gdx o=res_sum_Q_rO_DA.xlsx var=sum_Q_rO_DA.L'				
execute_unload "res_sum_Q_rO_reload.gdx" sum_Q_rO_reload.l
execute 'gdxxrw.exe res_sum_Q_rO_reload.gdx o=res_sum_Q_rO_reload.xlsx var=sum_Q_rO_reload.L'				
execute_unload "res_sum_Q_outrN_RA.gdx" sum_Q_outrN_RA.l
execute 'gdxxrw.exe res_sum_Q_outrN_RA.gdx o=res_sum_Q_outrN_RA.xlsx var=sum_Q_outrN_RA.L'				
execute_unload "res_sum_Q_inrN_RA.gdx" sum_Q_inrN_RA.l
execute 'gdxxrw.exe res_sum_Q_inrN_RA.gdx o=res_sum_Q_inrN_RA.xlsx var=sum_Q_inrN_RA.L'				
execute_unload "res_sum_Q_rN_DA.gdx" sum_Q_rN_DA.l
execute 'gdxxrw.exe res_sum_Q_rN_DA.gdx o=res_sum_Q_rN_DA.xlsx var=sum_Q_rN_DA.L'				
execute_unload "res_sum_Q_reload.gdx" sum_Q_reload.l
execute 'gdxxrw.exe res_sum_Q_reload.gdx o=res_sum_Q_reload.xlsx var=sum_Q_reload.L'				


execute_unload "res_sumSum_Q_RL_in.gdx" sumSum_Q_RL_in.l 
execute 'gdxxrw.exe res_sumSum_Q_RL_in.gdx o=sumSum_Q_RL_in.xlsx var=sumSum_Q_RL_in.L'
execute_unload "res_sumSum_Q_RL_out.gdx" sumSum_Q_RL_out.l 
execute 'gdxxrw.exe res_sumSum_Q_RL_out.gdx o=sumSum_Q_RL_out.xlsx var=sumSum_Q_RL_out.L'
execute_unload "res_sumSum_Q_DA.gdx" sumSum_Q_DA.l 
execute 'gdxxrw.exe res_sumSum_Q_DA.gdx o=sumSum_Q_DA.xlsx var=sumSum_Q_DA.L'
execute_unload "res_sumSum_Q_RA_in.gdx" sumSum_Q_RA_in.l 
execute 'gdxxrw.exe res_sumSum_Q_RA_in.gdx o=sumSum_Q_RA_in.xlsx var=sumSum_Q_RA_in.L'
execute_unload "res_sumSum_Q_RA_out.gdx" sumSum_Q_RA_out.l 
execute 'gdxxrw.exe res_sumSum_Q_RA_out.gdx o=sumSum_Q_RA_out.xlsx var=sumSum_Q_RA_out.L'