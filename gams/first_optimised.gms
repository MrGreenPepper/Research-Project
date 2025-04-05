*$include loadFullSet
$include loadTestSet

*$include convertData.gms
$include loadData.gms


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
    a           /3/
    rBat        /0.95/
    batCosts    /60000/
    parkCap     /3/
    BatCap     /3/
    m           /10000000/
	wcIn		/100/
	wcOut		/300/
;


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
;



Variable

omega_RA_outrN_call
omega_RA_outrB_call
omega_RA_outrI_call
omega_RA_outrO_call
omega_RA_inrN_call
omega_RA_inrB_call
omega_RA_inrI_call
omega_RA_inrO_call

probMod1_Q_outrN
probMod2_Q_outrN
probMod3_Q_outrN
probMod4_Q_outrN
probMod5_Q_outrN
probMod6_Q_outrN
probMod7_Q_outrN
probMod8_Q_outrN

probMod1_Q_outrB
probMod2_Q_outrB
probMod3_Q_outrB
probMod4_Q_outrB
probMod5_Q_outrB
probMod6_Q_outrB
probMod7_Q_outrB
probMod8_Q_outrB

probMod1_Q_outrI
probMod2_Q_outrI
probMod3_Q_outrI
probMod4_Q_outrI
probMod5_Q_outrI
probMod6_Q_outrI
probMod7_Q_outrI
probMod8_Q_outrI

probMod1_Q_outrO
probMod2_Q_outrO
probMod3_Q_outrO
probMod4_Q_outrO
probMod5_Q_outrO
probMod6_Q_outrO
probMod7_Q_outrO
probMod8_Q_outrO

probMod1_Q_inrN
probMod2_Q_inrN
probMod3_Q_inrN
probMod4_Q_inrN
probMod5_Q_inrN
probMod6_Q_inrN
probMod7_Q_inrN
probMod8_Q_inrN

probMod1_Q_inrB
probMod2_Q_inrB
probMod3_Q_inrB
probMod4_Q_inrB
probMod5_Q_inrB
probMod6_Q_inrB
probMod7_Q_inrB
probMod8_Q_inrB

probMod1_Q_inrI
probMod2_Q_inrI
probMod3_Q_inrI
probMod4_Q_inrI
probMod5_Q_inrI
probMod6_Q_inrI
probMod7_Q_inrI
probMod8_Q_inrI

probMod1_Q_inrO
probMod2_Q_inrO
probMod3_Q_inrO
probMod4_Q_inrO
probMod5_Q_inrO
probMod6_Q_inrO
probMod7_Q_inrO
probMod8_Q_inrO
;

Positive Variables 
workingCosts
BatStat(t_quarter)
r


* accepted  RL\ in \ out:
Q_in_RL(t_block, s_in_RL)
Q_out_RL(t_block, s_out_RL)
Q_rB_DA(t_hour, s_in_RL, s_out_RL)
Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
Q_rB_reload(t_hour, s_in_RL, s_out_RL)

*accepted RL in     \ declined out:
Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
Q_rI_DA(t_hour, s_in_RL, s_out_RL)
Q_rI_reload(t_hour, s_in_RL, s_out_RL)

*declined RL in\ accepted out:
Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
Q_rO_DA(t_hour, s_in_RL, s_out_RL)
Q_rO_reload(t_hour, s_in_RL, s_out_RL)

*declined RL in\ out:
Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
Q_rN_DA(t_hour, s_in_RL, s_out_RL)
Q_reload(t_hour, s_in_RL, s_out_RL)

*reload
Q_rB_reload(t_hour, s_in_RL, s_out_RL)
Q_rI_reload(t_hour, s_in_RL, s_out_RL)
Q_rO_reload(t_hour, s_in_RL, s_out_RL)
Q_rN_reload(t_hour, s_in_RL, s_out_RL)

*fakeReload
fakeReload_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
fakeReload_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
fakeReload_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
fakeReload_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
fakeReload_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
fakeReload_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
fakeReload_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
fakeReload_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) 

emerg_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
emerg_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
emerg_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
emerg_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
emerg_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
emerg_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
emerg_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)
emerg_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)
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


*market restrictions:
marketCon_outrB_RA
*marketCon_outrI_RA
marketCon_outrO_RA
*marketCon_out_RA

marketCon_inrB_RA
marketCon_inrI_RA
*marketCon_inrO_RA
*marketCon_in_RA

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

*testEQ1
*testEQ2
*testEQ3
*testEQ4

*series probabilty modifications
RA_probMod1_Q_outrN
RA_probMod2_Q_outrN
RA_probMod3_Q_outrN
RA_probMod4_Q_outrN
RA_probMod5_Q_outrN
RA_probMod6_Q_outrN
RA_probMod7_Q_outrN
RA_probMod8_Q_outrN
RA_probMod1_Q_outrB
RA_probMod2_Q_outrB
RA_probMod3_Q_outrB
RA_probMod4_Q_outrB
RA_probMod5_Q_outrB
RA_probMod6_Q_outrB
RA_probMod7_Q_outrB
RA_probMod8_Q_outrB
RA_probMod1_Q_outrI
RA_probMod2_Q_outrI
RA_probMod3_Q_outrI
RA_probMod4_Q_outrI
RA_probMod5_Q_outrI
RA_probMod6_Q_outrI
RA_probMod7_Q_outrI
RA_probMod8_Q_outrI
RA_probMod1_Q_outrO
RA_probMod2_Q_outrO
RA_probMod3_Q_outrO
RA_probMod4_Q_outrO
RA_probMod5_Q_outrO
RA_probMod6_Q_outrO
RA_probMod7_Q_outrO
RA_probMod8_Q_outrO
RA_probMod1_Q_inrN
RA_probMod2_Q_inrN
RA_probMod3_Q_inrN
RA_probMod4_Q_inrN
RA_probMod5_Q_inrN
RA_probMod6_Q_inrN
RA_probMod7_Q_inrN
RA_probMod8_Q_inrN
RA_probMod1_Q_inrB
RA_probMod2_Q_inrB
RA_probMod3_Q_inrB
RA_probMod4_Q_inrB
RA_probMod5_Q_inrB
RA_probMod6_Q_inrB
RA_probMod7_Q_inrB
RA_probMod8_Q_inrB
RA_probMod1_Q_inrI
RA_probMod2_Q_inrI
RA_probMod3_Q_inrI
RA_probMod4_Q_inrI
RA_probMod5_Q_inrI
RA_probMod6_Q_inrI
RA_probMod7_Q_inrI
RA_probMod8_Q_inrI
RA_probMod1_Q_inrO
RA_probMod2_Q_inrO
RA_probMod3_Q_inrO
RA_probMod4_Q_inrO
RA_probMod5_Q_inrO
RA_probMod6_Q_inrO
RA_probMod7_Q_inrO
RA_probMod8_Q_inrO

calc_omega_RA_outrN_callEQ(t_quarter, s_out_RA)
calc_omega_RA_outrB_callEQ(t_quarter, s_out_RA)
calc_omega_RA_outrI_callEQ(t_quarter, s_out_RA)
calc_omega_RA_outrO_callEQ(t_quarter, s_out_RA)
calc_omega_RA_inrN_callEQ(t_quarter, s_in_RA)
calc_omega_RA_inrB_callEQ(t_quarter, s_in_RA)
calc_omega_RA_inrI_callEQ(t_quarter, s_in_RA)
calc_omega_RA_inrO_callEQ(t_quarter, s_in_RA)

;


*obj function:
profitEQ..      Profit  =e= 
                - (BatCap * batCosts)
				- workingCosts
                + sum(t_block, 
* accepted  RL\ in \ out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (
                        + (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
                        + (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rB_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)  ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV * sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_inrB_call(t_quarter, s_in_RA)))        
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrB_call(t_quarter, s_out_RA))    )  ) ) )
*accepted RL in     \ declined out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (
                        + (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rI_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)    ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV * sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_inrI_call(t_quarter, s_in_RA)))      
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrI_call(t_quarter, s_out_RA))    )  ) ) )                          
*declined RL in     \ accepted out:
                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (
                        + (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rO_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)    ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV * sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_inrO_call(t_quarter, s_in_RA)))       
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * omega_RA_outrO_call(t_quarter, s_out_RA))    )  ) ) )
*declined RL in\ out:
                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rN_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)    ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV * sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_inrN_call(t_quarter, s_in_RA)))        
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * omega_RA_outrN_call(t_quarter, s_out_RA)))  ) ) )
                );
 
*testEQ1(s_in_RL, s_out_RL)..                       testV1(s_in_RL, s_out_RL) =e=  sum(t_block, omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))* (sum(t_quarter, RA_in_expV * Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_in_call(t_quarter, s_in_RA)));
*testEQ2(s_in_RL, s_out_RL)..                       testV2(s_in_RL, s_out_RL) =e= sum(t_quarter, Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL));
*testEQ3(s_in_RL, s_out_RL)..                       testV3(s_in_RL, s_out_RL) =e= sum(t_quarter, omega_RA_in_call(t_quarter, s_in_RA));
*testEQ4(s_in_RL, s_out_RL)..                       testV4(s_in_RL, s_out_RL) =e= sum(t_quarter, RA_in_expV);

workingCostsEQ..						workingCosts =e= sum(t_quarter,
				sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))           * (
                                                    
                        + sum(s_in_RA, emerg_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * wcIn * omega_RA_inrB_call(t_quarter, s_in_RA))
                        + sum(s_out_RA, emerg_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * wcOut * omega_RA_outrB_call(t_quarter, s_out_RA)))   ))     
*
*accepted RL in     \ declined out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))       * (
                                                     
                        + sum(s_in_RA, emerg_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * wcIn * omega_RA_inrI_call(t_quarter, s_in_RA))
                        + sum(s_out_RA, emerg_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * wcOut * omega_RA_outrI_call(t_quarter, s_out_RA)))   ))
                            
*declined RL in     \ accepted out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL)))       * (
                                                    
                        + sum(s_in_RA, emerg_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * wcIn * omega_RA_inrO_call(t_quarter, s_in_RA))
                        + sum(s_out_RA, emerg_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * wcOut * omega_RA_outrO_call(t_quarter, s_out_RA)))   ))    
*
*declined RL in\ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))))       * (
                                                        
                        + sum(s_in_RA, emerg_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * wcIn * omega_RA_inrN_call(t_quarter, s_in_RA))
                        + sum(s_out_RA, emerg_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * wcOut * omega_RA_outrN_call(t_quarter, s_out_RA) ))   )));

*profits
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
profit_RAin_EQ..                       profitRAin =e= sum(t_block,
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV * sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)  * omega_RA_inrB_call(t_quarter, s_in_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  RA_in_expV * sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_inrI_call(t_quarter, s_in_RA) )      )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  RA_in_expV * sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_inrO_call(t_quarter, s_in_RA) )      )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  RA_in_expV * sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * omega_RA_inrN_call(t_quarter, s_in_RA) )      )
                                                )))
                                                );
profit_RAout_EQ..                        profitRAout =e= sum(t_block,
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrB_call(t_quarter, s_out_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrI_call(t_quarter, s_out_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * omega_RA_outrO_call(t_quarter, s_out_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV * sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * omega_RA_outrN_call(t_quarter, s_out_RA) )    )
                                                )))
                                                );

* accepted  RL\ in \ out:
sum_Q_in_RL_EQ..                                sum_Q_in_RL =e= sum((t_block, s_in_RL), Q_in_RL(t_block, s_in_RL));
sum_Q_out_RL_EQ..                               sum_Q_out_RL =e= sum((t_block, s_out_RL), Q_out_RL(t_block, s_out_RL));
sum_Q_rB_DA_EQ(s_in_RL, s_out_RL)..                               sum_Q_rB_DA(s_in_RL, s_out_RL) =e= sum((t_hour), Q_rB_DA(t_hour, s_in_RL, s_out_RL));
sum_Q_outrB_RA_EQ..                             sum_Q_outrB_RA =e= sum((t_quarter, s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));
sum_Q_inrB_RA_EQ..                              sum_Q_inrB_RA =e= sum((t_quarter, s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL));
sum_Q_rB_reload_EQ..                                sum_Q_rB_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_rB_reload(t_hour, s_in_RL, s_out_RL));

*accepted RL in     \ declined out:
sum_Q_outrI_RA_EQ..                             sum_Q_outrI_RA =e= sum((t_quarter, s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));
sum_Q_inrI_RA_EQ..                              sum_Q_inrI_RA =e= sum((t_quarter, s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL));
sum_Q_rI_DA_EQ(s_in_RL, s_out_RL)..                               sum_Q_rI_DA(s_in_RL, s_out_RL) =e= sum((t_hour), Q_rI_DA(t_hour, s_in_RL, s_out_RL)                            );
sum_Q_rI_reload_EQ..                                sum_Q_rI_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_rI_reload(t_hour, s_in_RL, s_out_RL)                         );

*declined RL in\ accepted out:
sum_Q_outrO_RA_EQ..                             sum_Q_outrO_RA =e= sum((t_quarter, s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));
sum_Q_inrO_RA_EQ..                              sum_Q_inrO_RA =e= sum((t_quarter, s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL));
sum_Q_rO_DA_EQ(s_in_RL, s_out_RL)..                               sum_Q_rO_DA(s_in_RL, s_out_RL) =e= sum((t_hour), Q_rO_DA(t_hour, s_in_RL, s_out_RL)                            );
sum_Q_rO_reload_EQ..                                sum_Q_rO_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_rO_reload(t_hour, s_in_RL, s_out_RL)                         );

*declined RL in\ out:
sum_Q_outrN_RA_EQ..                             sum_Q_outrN_RA =e= sum((t_quarter, s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));
sum_Q_inrN_RA_EQ..                              sum_Q_inrN_RA =e= sum((t_quarter, s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL));
sum_Q_rN_DA_EQ..                                sum_Q_rN_DA =e= sum((t_hour, s_in_RL, s_out_RL), Q_rN_DA(t_hour, s_in_RL, s_out_RL)                         );
sum_Q_reload_EQ..                               sum_Q_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_reload(t_hour, s_in_RL, s_out_RL));
*   constraints
*battery cap
**batCapCalc..                        BatCap =g= max(Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA);
*batCapCalc..                       BatCap =g= max( Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA,
*                                                   Q_in_RL * 4, Q_out_RL * 4);


*access point:
accPointCon_a_B(t_quarter)..        a + sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)) =g= sum((s_DA,s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_DA(t_hour, s_in_RL, s_out_RL))) + sum((s_out_RA, s_in_RL, s_out_rl), Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));
accPointCon_a_I(t_quarter)..        a + sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)) =g= sum((s_DA,s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_DA(t_hour, s_in_RL, s_out_RL))) + sum((s_out_RA, s_in_RL, s_out_rl), Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));
accPointCon_a_O(t_quarter)..        a + sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)) =g= sum((s_DA,s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_DA(t_hour, s_in_RL, s_out_RL))) + sum((s_out_RA, s_in_RL, s_out_rl), Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));
accPointCon_a_N(t_quarter)..        a + sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)) =g= sum((s_DA,s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_DA(t_hour, s_in_RL, s_out_RL))) + sum((s_out_RA, s_in_RL, s_out_rl), Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL));

*battery performance restrictions:
calc_r..                                        r =e= BatCap * rBat;
storCon_Q_out_RL(t_block)..                     sum(s_out_RL, Q_out_RL(t_block, s_out_RL))          =l= r;
storCon_Q_in_RL(t_block)..                      sum(s_in_RL, Q_in_RL(t_block, s_in_RL))             =l= r;


storCon_Q_outrB_RA(t_quarter)..                 sum((s_out_RA, s_in_RL, s_out_rl), Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrI_RA(t_quarter)..                 sum((s_out_RA, s_in_RL, s_out_rl), Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrO_RA(t_quarter)..                 sum((s_out_RA, s_in_RL, s_out_rl), Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrN_RA(t_quarter)..                 sum((s_out_RA, s_in_RL, s_out_rl), Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= r/4;

storCon_Q_inrB_RA(t_quarter)..                  sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrI_RA(t_quarter)..                  sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrO_RA(t_quarter)..                  sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrN_RA(t_quarter)..                  sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= r/4;

*batter cap restrictions
batStatCap(t_quarter)..                         BatStat(t_quarter) =l= BatCap;  
batCap_Q_out_RL(t_block)..                      sum(s_out_RL, Q_out_RL(t_block, s_out_RL)) * 4      =l= BatCap;
batCap_Q_in_RL(t_block)..                       sum(s_in_RL, Q_in_RL(t_block, s_in_RL)) * 4         =l= BatCap;

batCap_Q_outrB_RA(t_quarter)..                  sum((s_out_RA, s_in_RL, s_out_rl), Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrI_RA(t_quarter)..                  sum((s_out_RA, s_in_RL, s_out_rl), Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrO_RA(t_quarter)..                  sum((s_out_RA, s_in_RL, s_out_rl), Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrN_RA(t_quarter)..                  sum((s_out_RA, s_in_RL, s_out_rl), Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL))      =l= BatCap;

batCap_Q_inrB_RA(t_quarter)..                   sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrI_RA(t_quarter)..                   sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrO_RA(t_quarter)..                   sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrN_RA(t_quarter)..                   sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL))         =l= BatCap;

*battery status restrictions
*expectet battery value in t+1:
batStatcon_(t_quarter)..                    BatStat(t_quarter + 1) =e= BatStat(t_quarter)         
*accepted  RL\ in \ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))           * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                         
                        + sum(s_in_RA, fakeReload_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) + (Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)    * omega_RA_inrB_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, fakeReload_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) + (Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrB_call(t_quarter, s_out_RA)))   )))     
*
*accepted RL in     \ declined out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + sum(s_in_RA, fakeReload_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) + (Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)    * omega_RA_inrI_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, fakeReload_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) + (Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrI_call(t_quarter, s_out_RA)))   )))
                            
*declined RL in     \ accepted out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL)))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + sum(s_in_RA, fakeReload_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) + (Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)    * omega_RA_inrO_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, fakeReload_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) + (Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrO_call(t_quarter, s_out_RA)))   )))     
*
*declined RL in\ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + sum(s_in_RA, fakeReload_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) + (Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)        * omega_RA_inrN_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, fakeReload_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) + (Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * omega_RA_outrN_call(t_quarter, s_out_RA) ))   )));
*

fakeReload_inrB_RAEQ(t_quarter, s_in_RA, s_in_RL, s_out_RL).. 	fakeReload_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) =e= emerg_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)  *     		(1 / ((Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
fakeReload_outrB_RAEQ(t_quarter, s_out_RA, s_in_RL, s_out_RL).. 	fakeReload_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) =e= emerg_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * 	(1 / ((Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
fakeReload_inrI_RAEQ(t_quarter, s_in_RA, s_in_RL, s_out_RL).. 	fakeReload_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) =e= emerg_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)  *     		(1 / ((Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
fakeReload_outrI_RAEQ(t_quarter, s_out_RA, s_in_RL, s_out_RL).. 	fakeReload_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) =e= emerg_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * 	(1 / ((Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
fakeReload_inrO_RAEQ(t_quarter, s_in_RA, s_in_RL, s_out_RL).. 	fakeReload_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) =e= emerg_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)  *     		(1 / ((Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
fakeReload_outrO_RAEQ(t_quarter, s_out_RA, s_in_RL, s_out_RL).. 	fakeReload_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) =e= emerg_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * 	(1 / ((Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
fakeReload_inrN_RAEQ(t_quarter, s_in_RA, s_in_RL, s_out_RL).. 	fakeReload_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) =e= emerg_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)  *    	 	(1 / ((Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
fakeReload_outrN_RAEQ(t_quarter, s_out_RA, s_in_RL, s_out_RL).. 	fakeReload_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) =e= emerg_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)  * 	(1 / ((Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL)*1000) + 1) ) ;
*spmOne(t_quarter, s_out_RA, s_in_RL, s_out_RL)..                         testSPM(t_quarter, s_out_RA) =e= omega_RA_out_call(t_quarter, s_out_RA) - 0.1 * seriesOne(t_quarter, s_out_RA, s_in_RL, s_out_RL);
*binconO(t_quarter, s_out_RA, s_in_RL, s_out_RL)..                         0 =l= Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) + (m * (1-seriesOne(t_quarter, s_out_RA, s_in_RL, s_out_RL)));                                         
*binconT(t_quarter, s_out_RA, s_in_RL, s_out_RL)..                         0 =g= Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) - (m * seriesOne(t_quarter, s_out_RA, s_in_RL, s_out_RL)); 


*RA dynamics 
*out
RA_probMod1_Q_outrN(t_quarter)..                         probMod1_Q_outrN(t_quarter) =e= RA_probMod_pos('ser1') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 1, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_outrN(t_quarter)..                         probMod2_Q_outrN(t_quarter) =e= RA_probMod_pos('ser2') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 2, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_outrN(t_quarter)..                         probMod3_Q_outrN(t_quarter) =e= RA_probMod_pos('ser3') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 3, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_outrN(t_quarter)..                         probMod4_Q_outrN(t_quarter) =e= RA_probMod_pos('ser4') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 4, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_outrN(t_quarter)..                         probMod5_Q_outrN(t_quarter) =e= RA_probMod_pos('ser5') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 5, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_outrN(t_quarter)..                         probMod6_Q_outrN(t_quarter) =e= RA_probMod_pos('ser6') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 6, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_outrN(t_quarter)..                         probMod7_Q_outrN(t_quarter) =e= RA_probMod_pos('ser7') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 7, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_outrN(t_quarter)..                         probMod8_Q_outrN(t_quarter) =e= RA_probMod_pos('ser8') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter - 8, s_out_RA, s_in_RL, s_out_RL)) +1 ))));

calc_omega_RA_outrN_callEQ(t_quarter, s_out_RA)..					omega_RA_outrN_call(t_quarter, s_out_RA) =e= omega_RA_out_call(s_out_RA) * (1 - probMod1_Q_outrN(t_quarter) + probMod2_Q_outrN(t_quarter) 
																														+ probMod3_Q_outrN(t_quarter) + probMod4_Q_outrN(t_quarter) + probMod5_Q_outrN(t_quarter) 
																														+ probMod6_Q_outrN(t_quarter) + probMod7_Q_outrN(t_quarter) + probMod8_Q_outrN(t_quarter)
																														- probMod1_Q_inrN(t_quarter) - probMod2_Q_inrN(t_quarter) 
																														- probMod3_Q_inrN(t_quarter) - probMod4_Q_inrN(t_quarter) - probMod5_Q_inrN(t_quarter) 
																														- probMod6_Q_inrN(t_quarter) - probMod7_Q_inrN(t_quarter) - probMod8_Q_inrN(t_quarter));


RA_probMod1_Q_outrB(t_quarter)..                         probMod1_Q_outrB(t_quarter) =e= RA_probMod_pos('ser1') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 1, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_outrB(t_quarter)..                         probMod2_Q_outrB(t_quarter) =e= RA_probMod_pos('ser2') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 2, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_outrB(t_quarter)..                         probMod3_Q_outrB(t_quarter) =e= RA_probMod_pos('ser3') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 3, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_outrB(t_quarter)..                         probMod4_Q_outrB(t_quarter) =e= RA_probMod_pos('ser4') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 4, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_outrB(t_quarter)..                         probMod5_Q_outrB(t_quarter) =e= RA_probMod_pos('ser5') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 5, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_outrB(t_quarter)..                         probMod6_Q_outrB(t_quarter) =e= RA_probMod_pos('ser6') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 6, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_outrB(t_quarter)..                         probMod7_Q_outrB(t_quarter) =e= RA_probMod_pos('ser7') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 7, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_outrB(t_quarter)..                         probMod8_Q_outrB(t_quarter) =e= RA_probMod_pos('ser8') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter - 8, s_out_RA, s_in_RL, s_out_RL)) +1 ))));

calc_omega_RA_outrB_callEQ(t_quarter, s_out_RA)..					omega_RA_outrB_call(t_quarter, s_out_RA) =e= omega_RA_out_call(s_out_RA) * (1 - probMod1_Q_outrB(t_quarter) + probMod2_Q_outrB(t_quarter) 
																														+ probMod3_Q_outrB(t_quarter) + probMod4_Q_outrB(t_quarter) + probMod5_Q_outrB(t_quarter) 
																														+ probMod6_Q_outrB(t_quarter) + probMod7_Q_outrB(t_quarter) + probMod8_Q_outrB(t_quarter)
																														- probMod1_Q_inrB(t_quarter) - probMod2_Q_inrB(t_quarter) 
																														- probMod3_Q_inrB(t_quarter) - probMod4_Q_inrB(t_quarter) - probMod5_Q_inrB(t_quarter) 
																														- probMod6_Q_inrB(t_quarter) - probMod7_Q_inrB(t_quarter) - probMod8_Q_inrB(t_quarter));


RA_probMod1_Q_outrI(t_quarter)..                         probMod1_Q_outrI(t_quarter) =e= RA_probMod_pos('ser1') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 1, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_outrI(t_quarter)..                         probMod2_Q_outrI(t_quarter) =e= RA_probMod_pos('ser2') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 2, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_outrI(t_quarter)..                         probMod3_Q_outrI(t_quarter) =e= RA_probMod_pos('ser3') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 3, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_outrI(t_quarter)..                         probMod4_Q_outrI(t_quarter) =e= RA_probMod_pos('ser4') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 4, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_outrI(t_quarter)..                         probMod5_Q_outrI(t_quarter) =e= RA_probMod_pos('ser5') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 5, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_outrI(t_quarter)..                         probMod6_Q_outrI(t_quarter) =e= RA_probMod_pos('ser6') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 6, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_outrI(t_quarter)..                         probMod7_Q_outrI(t_quarter) =e= RA_probMod_pos('ser7') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 7, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_outrI(t_quarter)..                         probMod8_Q_outrI(t_quarter) =e= RA_probMod_pos('ser8') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter - 8, s_out_RA, s_in_RL, s_out_RL)) +1 ))));

calc_omega_RA_outrI_callEQ(t_quarter, s_out_RA)..					omega_RA_outrI_call(t_quarter, s_out_RA) =e= omega_RA_out_call(s_out_RA) * (1 - probMod1_Q_outrI(t_quarter) + probMod2_Q_outrI(t_quarter) 
																														+ probMod3_Q_outrI(t_quarter) + probMod4_Q_outrI(t_quarter) + probMod5_Q_outrI(t_quarter) 
																														+ probMod6_Q_outrI(t_quarter) + probMod7_Q_outrI(t_quarter) + probMod8_Q_outrI(t_quarter)
																														- probMod1_Q_inrI(t_quarter) - probMod2_Q_inrI(t_quarter) 
																														- probMod3_Q_inrI(t_quarter) - probMod4_Q_inrI(t_quarter) - probMod5_Q_inrI(t_quarter) 
																														- probMod6_Q_inrI(t_quarter) - probMod7_Q_inrI(t_quarter) - probMod8_Q_inrI(t_quarter));



RA_probMod1_Q_outrO(t_quarter)..                         probMod1_Q_outrO(t_quarter) =e= RA_probMod_pos('ser1') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 1, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_outrO(t_quarter)..                         probMod2_Q_outrO(t_quarter) =e= RA_probMod_pos('ser2') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 2, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_outrO(t_quarter)..                         probMod3_Q_outrO(t_quarter) =e= RA_probMod_pos('ser3') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 3, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_outrO(t_quarter)..                         probMod4_Q_outrO(t_quarter) =e= RA_probMod_pos('ser4') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 4, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_outrO(t_quarter)..                         probMod5_Q_outrO(t_quarter) =e= RA_probMod_pos('ser5') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 5, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_outrO(t_quarter)..                         probMod6_Q_outrO(t_quarter) =e= RA_probMod_pos('ser6') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 6, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_outrO(t_quarter)..                         probMod7_Q_outrO(t_quarter) =e= RA_probMod_pos('ser7') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 7, s_out_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_outrO(t_quarter)..                         probMod8_Q_outrO(t_quarter) =e= RA_probMod_pos('ser8') * (1- (1/((10000 * sum((s_out_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter - 8, s_out_RA, s_in_RL, s_out_RL)) +1 ))));

calc_omega_RA_outrO_callEQ(t_quarter, s_out_RA)..					omega_RA_outrO_call(t_quarter, s_out_RA) =e= omega_RA_out_call(s_out_RA) * (1 - probMod1_Q_outrO(t_quarter) + probMod2_Q_outrO(t_quarter) 
																														+ probMod3_Q_outrO(t_quarter) + probMod4_Q_outrO(t_quarter) + probMod5_Q_outrO(t_quarter) 
																														+ probMod6_Q_outrO(t_quarter) + probMod7_Q_outrO(t_quarter) + probMod8_Q_outrO(t_quarter)
																														- probMod1_Q_inrO(t_quarter) - probMod2_Q_inrO(t_quarter)
																														- probMod3_Q_inrO(t_quarter) - probMod4_Q_inrO(t_quarter) - probMod5_Q_inrO(t_quarter) 
																														- probMod6_Q_inrO(t_quarter) - probMod7_Q_inrO(t_quarter) - probMod8_Q_inrO(t_quarter));


*in
RA_probMod1_Q_inrN(t_quarter)..                         probMod1_Q_inrN(t_quarter) =e= RA_probMod_neg('ser1') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 1, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_inrN(t_quarter)..                         probMod2_Q_inrN(t_quarter) =e= RA_probMod_neg('ser2') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 2, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_inrN(t_quarter)..                         probMod3_Q_inrN(t_quarter) =e= RA_probMod_neg('ser3') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 3, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_inrN(t_quarter)..                         probMod4_Q_inrN(t_quarter) =e= RA_probMod_neg('ser4') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 4, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_inrN(t_quarter)..                         probMod5_Q_inrN(t_quarter) =e= RA_probMod_neg('ser5') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 5, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_inrN(t_quarter)..                         probMod6_Q_inrN(t_quarter) =e= RA_probMod_neg('ser6') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 6, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_inrN(t_quarter)..                         probMod7_Q_inrN(t_quarter) =e= RA_probMod_neg('ser7') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 7, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_inrN(t_quarter)..                         probMod8_Q_inrN(t_quarter) =e= RA_probMod_neg('ser8') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 8, s_in_RA, s_in_RL, s_out_RL)) +1 )))); 

calc_omega_RA_inrN_callEQ(t_quarter, s_in_RA).. 					omega_RA_inrN_call(t_quarter, s_in_RA) =e= omega_RA_in_call(s_in_RA) * (1 - probMod1_Q_inrN(t_quarter) + probMod2_Q_inrN(t_quarter) 
																														+ probMod3_Q_inrN(t_quarter) + probMod4_Q_inrN(t_quarter) + probMod5_Q_inrN(t_quarter) 
																														+ probMod6_Q_inrN(t_quarter) + probMod7_Q_inrN(t_quarter) + probMod8_Q_inrN(t_quarter)
																														- probMod1_Q_outrN(t_quarter) - probMod2_Q_outrN(t_quarter) 
																														- probMod3_Q_outrN(t_quarter) - probMod4_Q_outrN(t_quarter) - probMod5_Q_outrN(t_quarter) 
																														- probMod6_Q_outrN(t_quarter) - probMod7_Q_outrN(t_quarter) - probMod8_Q_outrN(t_quarter));

RA_probMod1_Q_inrB(t_quarter)..                         probMod1_Q_inrB(t_quarter) =e= RA_probMod_neg('ser1') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 1, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_inrB(t_quarter)..                         probMod2_Q_inrB(t_quarter) =e= RA_probMod_neg('ser2') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 2, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_inrB(t_quarter)..                         probMod3_Q_inrB(t_quarter) =e= RA_probMod_neg('ser3') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 3, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_inrB(t_quarter)..                         probMod4_Q_inrB(t_quarter) =e= RA_probMod_neg('ser4') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 4, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_inrB(t_quarter)..                         probMod5_Q_inrB(t_quarter) =e= RA_probMod_neg('ser5') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 5, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_inrB(t_quarter)..                         probMod6_Q_inrB(t_quarter) =e= RA_probMod_neg('ser6') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 6, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_inrB(t_quarter)..                         probMod7_Q_inrB(t_quarter) =e= RA_probMod_neg('ser7') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 7, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_inrB(t_quarter)..                         probMod8_Q_inrB(t_quarter) =e= RA_probMod_neg('ser8') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter - 8, s_in_RA, s_in_RL, s_out_RL)) +1 ))));

calc_omega_RA_inrB_callEQ(t_quarter, s_in_RA).. 					omega_RA_inrB_call(t_quarter, s_in_RA) =e= omega_RA_in_call(s_in_RA) * (1 - probMod1_Q_inrB(t_quarter) + probMod2_Q_inrB(t_quarter) 
																														+ probMod3_Q_inrB(t_quarter) + probMod4_Q_inrB(t_quarter) + probMod5_Q_inrB(t_quarter) 
																														+ probMod6_Q_inrB(t_quarter) + probMod7_Q_inrB(t_quarter) + probMod8_Q_inrB(t_quarter)
																														- probMod1_Q_outrB(t_quarter) - probMod2_Q_outrB(t_quarter) 
																														- probMod3_Q_outrB(t_quarter) - probMod4_Q_outrB(t_quarter) - probMod5_Q_outrB(t_quarter) 
																														- probMod6_Q_outrB(t_quarter) - probMod7_Q_outrB(t_quarter) - probMod8_Q_outrB(t_quarter));

RA_probMod1_Q_inrI(t_quarter)..                         probMod1_Q_inrI(t_quarter) =e= RA_probMod_neg('ser1') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 1, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_inrI(t_quarter)..                         probMod2_Q_inrI(t_quarter) =e= RA_probMod_neg('ser2') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 2, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_inrI(t_quarter)..                         probMod3_Q_inrI(t_quarter) =e= RA_probMod_neg('ser3') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 3, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_inrI(t_quarter)..                         probMod4_Q_inrI(t_quarter) =e= RA_probMod_neg('ser4') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 4, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_inrI(t_quarter)..                         probMod5_Q_inrI(t_quarter) =e= RA_probMod_neg('ser5') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 5, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_inrI(t_quarter)..                         probMod6_Q_inrI(t_quarter) =e= RA_probMod_neg('ser6') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 6, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_inrI(t_quarter)..                         probMod7_Q_inrI(t_quarter) =e= RA_probMod_neg('ser7') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 7, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_inrI(t_quarter)..                         probMod8_Q_inrI(t_quarter) =e= RA_probMod_neg('ser8') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter - 8, s_in_RA, s_in_RL, s_out_RL)) +1 ))));

calc_omega_RA_inrI_callEQ(t_quarter, s_in_RA).. 					omega_RA_inrI_call(t_quarter, s_in_RA) =e= omega_RA_in_call(s_in_RA) * (1 - probMod1_Q_inrI(t_quarter) + probMod2_Q_inrI(t_quarter) 
																														+ probMod3_Q_inrI(t_quarter) + probMod4_Q_inrI(t_quarter) + probMod5_Q_inrI(t_quarter) 
																														+ probMod6_Q_inrI(t_quarter) + probMod7_Q_inrI(t_quarter) + probMod8_Q_inrI(t_quarter)
																														- probMod1_Q_outrI(t_quarter) - probMod2_Q_outrI(t_quarter) 
																														- probMod3_Q_outrI(t_quarter) - probMod4_Q_outrI(t_quarter) - probMod5_Q_outrI(t_quarter) 
																														- probMod6_Q_outrI(t_quarter) - probMod7_Q_outrI(t_quarter) - probMod8_Q_outrI(t_quarter));

RA_probMod1_Q_inrO(t_quarter)..                         probMod1_Q_inrO(t_quarter) =e= RA_probMod_neg('ser1') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter - 1, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod2_Q_inrO(t_quarter)..                         probMod2_Q_inrO(t_quarter) =e= RA_probMod_neg('ser2') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter - 2, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod3_Q_inrO(t_quarter)..                         probMod3_Q_inrO(t_quarter) =e= RA_probMod_neg('ser3') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter - 3, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod4_Q_inrO(t_quarter)..                         probMod4_Q_inrO(t_quarter) =e= RA_probMod_neg('ser4') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter - 4, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod5_Q_inrO(t_quarter)..                         probMod5_Q_inrO(t_quarter) =e= RA_probMod_neg('ser5') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter - 5, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod6_Q_inrO(t_quarter)..                         probMod6_Q_inrO(t_quarter) =e= RA_probMod_neg('ser6') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter - 6, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod7_Q_inrO(t_quarter)..                         probMod7_Q_inrO(t_quarter) =e= RA_probMod_neg('ser7') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter - 7, s_in_RA, s_in_RL, s_out_RL)) +1 ))));
RA_probMod8_Q_inrO(t_quarter)..                         probMod8_Q_inrO(t_quarter) =e= RA_probMod_neg('ser8') * (1- (1/((10000 * sum((s_in_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter - 8, s_in_RA, s_in_RL, s_out_RL)) +1 ))));

calc_omega_RA_inrO_callEQ(t_quarter, s_in_RA)..					omega_RA_inrO_call(t_quarter, s_in_RA) =e= omega_RA_in_call(s_in_RA) * (1 - probMod1_Q_inrO(t_quarter) + probMod2_Q_inrO(t_quarter) 
																														+ probMod3_Q_inrO(t_quarter) + probMod4_Q_inrO(t_quarter) + probMod5_Q_inrO(t_quarter) 
																														+ probMod6_Q_inrO(t_quarter) + probMod7_Q_inrO(t_quarter) + probMod8_Q_inrO(t_quarter)
																														- probMod1_Q_outrO(t_quarter) - probMod2_Q_outrO(t_quarter) 
																														- probMod3_Q_outrO(t_quarter) - probMod4_Q_outrO(t_quarter) - probMod5_Q_outrO(t_quarter) 
																														- probMod6_Q_outrO(t_quarter) - probMod7_Q_outrO(t_quarter) - probMod8_Q_outrO(t_quarter));


*park restrictions:
parkCon_Q_rB_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rB_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rB_reload(t_hour, s_in_RL, s_out_RL));
parkCon_Q_rI_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rI_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rI_reload(t_hour, s_in_RL, s_out_RL));
parkCon_Q_rO_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rO_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rO_reload(t_hour, s_in_RL, s_out_RL));
parkCon_Q_rN_DA(t_hour)..                   sum((s_DA, s_in_RL, s_out_RL), Q_rN_DA(t_hour, s_in_RL, s_out_RL)) =l= parkCap * parkProfile(t_hour) - sum((s_DA, s_in_RL, s_out_RL), Q_rN_reload(t_hour, s_in_RL, s_out_RL));




*market restrictions:
marketCon_outrB_RA(t_quarter, s_in_RL, s_out_RL)..                 sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));
*marketCon_outrI_RA(t_quarter)..                sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));
marketCon_outrO_RA(t_quarter, s_in_RL, s_out_RL)..                 sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));
*marketCon_out_RA(t_quarter)..                  sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA, s_in_RL, s_out_RL) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL));

marketCon_inrB_RA(t_quarter, s_in_RL, s_out_RL)..                  sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));
marketCon_inrI_RA(t_quarter, s_in_RL, s_out_RL)..                  sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));
*marketCon_inrO_RA(t_quarter)..                 sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));
*marketCon_in_RA(t_quarter)..                   sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA, s_in_RL, s_out_RL) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL));


Model testFirstDecision /all/;
Solve testFirstDecision maximising Profit using NLP;

execute_unload "Result_Miehle.gdx" BatStat.l
execute 'gdxxrw.exe Result_Miehle.gdx rng=a1:e160 par=BatStat log=log_exe_test.txt'

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