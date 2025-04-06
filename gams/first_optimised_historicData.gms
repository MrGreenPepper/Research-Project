*$include loadFullSet
*$include loadTestSet

$include loadHistoricSet

*$include convertData.gms
*$include loadData_historic_Q1.gms
$include loadData_historic_Q18.gms
*$include loadData_historic_Q36.gms


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
	wcInCosts		/100/
	wcOutCosts		/300/
	probRA
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
;

Positive Variables 
workingCosts
BatStat(t_quarter)
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

*testEQ1
*testEQ2
*testEQ3
*testEQ4


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
;


*obj function:
profitEQ..      Profit  =e= 
                - (BatCap * batCosts)
				- workingCosts
                + sum(t_quarter, 
				+ sum(t_block$map_quarter_block(t_quarter, t_block),
				+ sum(t_hour$map_quarter_hour(t_quarter, t_hour),
* accepted  RL\ in \ out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (
                        + (0.25 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                       
                        + (0.25 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + (0.25 * ((Q_rB_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour)  )))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))       
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  )) 
*accepted RL in     \ declined out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (
                        + (0.25 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
                        + (0.25 * ((Q_rI_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour))))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))      
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  ))                      
*declined RL in     \ accepted out:
                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (
                        + (0.25 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + (0.25 * ((Q_rO_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour))))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))       
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  ))
*declined RL in\ out:
                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (
                        + (0.25 * ((Q_rN_DA(t_hour, s_in_RL, s_out_RL)              * DA_expV(t_hour))))
                        + (sum(s_RA, probRA * RA_price_neg(t_quarter, s_RA) * Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))        
                        + (sum(s_RA, probRA * RA_price_pos(t_quarter, s_RA) * Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)))  )  ))
                )));
 
*testEQ1(s_in_RL, s_out_RL)..                       testV1(s_in_RL, s_out_RL) =e=  sum(t_block, omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))* (sum(t_quarter, RA_price_neg(t_quarter, s_RA) * Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * omega_RA_in_call(t_quarter, s_RA)));
*testEQ2(s_in_RL, s_out_RL)..                       testV2(s_in_RL, s_out_RL) =e= sum(t_quarter, Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
*testEQ3(s_in_RL, s_out_RL)..                       testV3(s_in_RL, s_out_RL) =e= sum(t_quarter, omega_RA_in_call(t_quarter, s_RA));
*testEQ4(s_in_RL, s_out_RL)..                       testV4(s_in_RL, s_out_RL) =e= sum(t_quarter, RA_price_neg(t_quarter, s_RA));

workingCostsEQ..						workingCosts =e= sum(t_quarter,
				sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))           * (
                                                    
                        + sum(s_RA, emerg_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcInCosts * probRA))
                        + sum(s_RA, emerg_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcOutCosts * probRA)  		))        
*
*accepted RL in     \ declined out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))       * (
                                                     
                        + sum(s_RA, emerg_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcInCosts * probRA))
                        + sum(s_RA, emerg_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcOutCosts * probRA)		))
                            
*declined RL in     \ accepted out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL)))       * (
                                                    
                        + sum(s_RA, emerg_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcInCosts * probRA))
                        + sum(s_RA, emerg_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcOutCosts * probRA)		))    
*
*declined RL in\ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))))       * (
                                                        
                        + sum(s_RA, emerg_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcInCosts * probRA))
                        + sum(s_RA, emerg_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) * wcOutCosts * probRA) 		))
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
sum_Q_in_RL_EQ..                                sum_Q_in_RL =e= sum((t_block, s_in_RL), Q_in_RL(t_block, s_in_RL));
sum_Q_out_RL_EQ..                               sum_Q_out_RL =e= sum((t_block, s_out_RL), Q_out_RL(t_block, s_out_RL));
sum_Q_rB_DA_EQ(s_in_RL, s_out_RL)..                               sum_Q_rB_DA(s_in_RL, s_out_RL) =e= sum((t_hour), Q_rB_DA(t_hour, s_in_RL, s_out_RL));
sum_Q_outrB_RA_EQ..                             sum_Q_outrB_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrB_RA_EQ..                              sum_Q_inrB_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rB_reload_EQ..                                sum_Q_rB_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_rB_reload(t_hour, s_in_RL, s_out_RL));

*accepted RL in     \ declined out:
sum_Q_outrI_RA_EQ..                             sum_Q_outrI_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrI_RA_EQ..                              sum_Q_inrI_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rI_DA_EQ(s_in_RL, s_out_RL)..                               sum_Q_rI_DA(s_in_RL, s_out_RL) =e= sum((t_hour), Q_rI_DA(t_hour, s_in_RL, s_out_RL)                            );
sum_Q_rI_reload_EQ..                                sum_Q_rI_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_rI_reload(t_hour, s_in_RL, s_out_RL)                         );

*declined RL in\ accepted out:
sum_Q_outrO_RA_EQ..                             sum_Q_outrO_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrO_RA_EQ..                              sum_Q_inrO_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rO_DA_EQ(s_in_RL, s_out_RL)..                               sum_Q_rO_DA(s_in_RL, s_out_RL) =e= sum((t_hour), Q_rO_DA(t_hour, s_in_RL, s_out_RL)                            );
sum_Q_rO_reload_EQ..                                sum_Q_rO_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_rO_reload(t_hour, s_in_RL, s_out_RL)                         );

*declined RL in\ out:
sum_Q_outrN_RA_EQ..                             sum_Q_outrN_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_inrN_RA_EQ..                              sum_Q_inrN_RA =e= sum((t_quarter, s_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
sum_Q_rN_DA_EQ..                                sum_Q_rN_DA =e= sum((t_hour, s_in_RL, s_out_RL), Q_rN_DA(t_hour, s_in_RL, s_out_RL)                         );
sum_Q_reload_EQ..                               sum_Q_reload =e= sum((t_hour, s_in_RL, s_out_RL), Q_reload(t_hour, s_in_RL, s_out_RL));
*   constraints
*battery cap
**batCapCalc..                        BatCap =g= max(Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA);
*batCapCalc..                       BatCap =g= max( Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA,
*                                                   Q_in_RL * 4, Q_out_RL * 4);


*access point:
accPointCon_a_B(t_quarter)..        a + sum((s_RA, s_in_RL, s_out_RL), fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_RA, s_in_RL, s_out_RL), fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_I(t_quarter)..        a + sum((s_RA, s_in_RL, s_out_RL), fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_RA, s_in_RL, s_out_RL), fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_O(t_quarter)..        a + sum((s_RA, s_in_RL, s_out_RL), fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_RA, s_in_RL, s_out_RL), fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL));
accPointCon_a_N(t_quarter)..        a + sum((s_RA, s_in_RL, s_out_RL), fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL)) =g= sum((s_DA, s_in_RL, s_out_RL), sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_DA(t_hour, s_in_RL, s_out_RL)) * 0.25) + sum((s_RA, s_in_RL, s_out_RL), fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL));

*battery performance restrictions:
calc_r..                                        r =e= BatCap * rBat;
storCon_Q_out_RL(t_block)..                     sum(s_out_RL, Q_out_RL(t_block, s_out_RL))          =l= r;
storCon_Q_in_RL(t_block)..                      sum(s_in_RL, Q_in_RL(t_block, s_in_RL))             =l= r;


storCon_Q_outrB_RA(t_quarter)..                 sum((s_RA, s_in_RL, s_out_rl), Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrI_RA(t_quarter)..                 sum((s_RA, s_in_RL, s_out_rl), Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrO_RA(t_quarter)..                 sum((s_RA, s_in_RL, s_out_rl), Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;
storCon_Q_outrN_RA(t_quarter)..                 sum((s_RA, s_in_RL, s_out_rl), Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= r/4;

storCon_Q_inrB_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrI_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrO_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;
storCon_Q_inrN_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= r/4;

*batter cap restrictions
batStatCap(t_quarter)..                         BatStat(t_quarter) =l= BatCap;  
batCap_Q_out_RL(t_block)..                      sum(s_out_RL, Q_out_RL(t_block, s_out_RL)) * 4      =l= BatCap;
batCap_Q_in_RL(t_block)..                       sum(s_in_RL, Q_in_RL(t_block, s_in_RL)) * 4         =l= BatCap;

batCap_Q_outrB_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_rl), Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrI_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_rl), Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrO_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_rl), Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;
batCap_Q_outrN_RA(t_quarter)..                  sum((s_RA, s_in_RL, s_out_rl), Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))      =l= BatCap;

batCap_Q_inrB_RA(t_quarter)..                   sum((s_RA, s_in_RL, s_out_RL), Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrI_RA(t_quarter)..                   sum((s_RA, s_in_RL, s_out_RL), Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrO_RA(t_quarter)..                   sum((s_RA, s_in_RL, s_out_RL), Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;
batCap_Q_inrN_RA(t_quarter)..                   sum((s_RA, s_in_RL, s_out_RL), Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))         =l= BatCap;

*battery status restrictions
*expectet battery value in t+1:
batStatcon_(t_quarter)..                    BatStat(t_quarter + 1) =e= BatStat(t_quarter)         
*accepted  RL\ in \ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))           * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                         
                        + sum(s_RA, fakeReload_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - sum(s_RA, fakeReload_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )))     
*
*accepted RL in     \ declined out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + sum(s_RA, fakeReload_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - sum(s_RA, fakeReload_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )))
                            
*declined RL in     \ accepted out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL)))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + sum(s_RA, fakeReload_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - sum(s_RA, fakeReload_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )))     
*
*declined RL in\ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_reload(t_hour, s_in_RL, s_out_RL) / 4)                                                        
                        + sum(s_RA, fakeReload_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))
                        - sum(s_RA, fakeReload_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) + ((1/card(s_RA)) * (Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL))))   )));
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
Q_inrB_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 						Q_inrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_inrO_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 						Q_inrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_inrI_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 						Q_inrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_inrN_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 						Q_inrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_in_RAmax(t_quarter, s_RA);
Q_outrB_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 					Q_outrB_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_out_RAmax(t_quarter, s_RA);
Q_outrI_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 					Q_outrI_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_out_RAmax(t_quarter, s_RA);
Q_outrO_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 					Q_outrO_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_out_RAmax(t_quarter, s_RA);
Q_outrN_RA_EQ(t_quarter, s_RA, s_in_RL, s_out_RL).. 					Q_outrN_RA(t_quarter, s_RA, s_in_RL, s_out_RL) 	=l= q_out_RAmax(t_quarter, s_RA);


Q_in_RL_EQ(t_quarter, s_in_RL)..										sum(t_block$map_quarter_block(t_quarter, t_block), Q_in_RL(t_block, s_in_RL))	* 0.25	=l= BatCap - BatStat(t_quarter);
Q_out_RL_EQ(t_quarter, s_out_RL)..										sum(t_block$map_quarter_block(t_quarter, t_block), Q_out_RL(t_block, s_out_RL))	* 0.25	=l= BatStat(t_quarter);
*accepted RL in     \ declined out:
*declined RL in\ accepted out:
*declined RL in\ out:

Model testFirstDecision /all/;
Solve testFirstDecision maximising Profit using MIP;

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