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
;


Variables
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
Positive Variables 

BatStat(t_quarter)
r


* accepted  RL\ in \ out:
Q_in_RL(t_block, s_in_RL)
Q_out_RL(t_block, s_out_RL)
Q_rB_DA(t_hour)
Q_outrB_RA(t_quarter, s_out_RA)
Q_inrB_RA(t_quarter, s_in_RA)
Q_rB_reload(t_hour)

*accepted RL in     \ declined out:
Q_outrI_RA(t_quarter, s_out_RA)
Q_inrI_RA(t_quarter, s_in_RA)
Q_rI_DA(t_hour)
Q_rI_reload(t_hour)

*declined RL in\ accepted out:
Q_outrO_RA(t_quarter, s_out_RA)
Q_inrO_RA(t_quarter, s_in_RA)
Q_rO_DA(t_hour)
Q_rO_reload(t_hour)

*declined RL in\ out:
Q_outrN_RA(t_quarter, s_out_RA)
Q_inrN_RA(t_quarter, s_in_RA)
Q_rN_DA(t_hour)
Q_reload(t_hour)

*reload
Q_rB_reload(t_hour)
Q_rI_reload(t_hour)
Q_rO_reload(t_hour)
Q_rN_reload(t_hour)
;

Equations
profitEQ

*   constraints:
*battery cap
*batCapCalc
*batter cap restrictions
batStatCap  

batCap_Q_out_RL(t_block)
batCap_Q_in_RL(t_block)

batCap_Q_outrB_RA(t_quarter)
batCap_Q_outrI_RA(t_quarter)
batCap_Q_outrO_RA(t_quarter)
batCap_Q_outrN_RA(t_quarter)

batCap_Q_inrB_RA(t_quarter)
batCap_Q_inrI_RA(t_quarter)
batCap_Q_inrO_RA(t_quarter)
batCap_Q_inrN_RA(t_quarter)

*access point:
accPointCon_a_B
accPointCon_a_I
accPointCon_a_O
accPointCon_a_N

*battery status restrictions
batStatcon_(t_quarter)

*battery performance restrictions:
calc_r
storCon_Q_out_RL(t_block)
storCon_Q_in_RL(t_block)

storCon_Q_outrB_RA(t_quarter)
storCon_Q_outrI_RA(t_quarter)
storCon_Q_outrO_RA(t_quarter)
storCon_Q_outrN_RA(t_quarter)

storCon_Q_inrB_RA(t_quarter)
storCon_Q_inrI_RA(t_quarter)
storCon_Q_inrO_RA(t_quarter)
storCon_Q_inrN_RA(t_quarter)

*market restrictions:
marketCon_outrB_RA(t_quarter)
*marketCon_outrI_RA(t_quarter)
marketCon_outrO_RA(t_quarter)
*marketCon_out_RA(t_quarter)

marketCon_inrB_RA(t_quarter)
marketCon_inrI_RA(t_quarter)
*marketCon_inrO_RA(t_quarter)
*marketCon_in_RA(t_quarter)

*park restrictions:
parkCon_Q_rB_DA(t_hour)
parkCon_Q_rI_DA(t_hour)
parkCon_Q_rO_DA(t_hour)
parkCon_Q_rN_DA(t_hour)

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

testEQ1
testEQ2
testEQ3
testEQ4
;


*obj function:
profitEQ..      Profit  =e=
                - (BatCap * batCosts)
                + sum(t_block, 
* accepted  RL\ in \ out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (
                        + (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
                        + (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rB_DA(t_hour)              * DA_expV(t_hour)  ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV(t_quarter) * sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA)))        
				        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA))    )  ) ) )

*accepted RL in     \ declined out:
                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (
                        + (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rI_DA(t_hour)              * DA_expV(t_hour)    ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV(t_quarter) * sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA)))      
						+ 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA))    )  ) ) )
                            
*declined RL in     \ accepted out:
                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (
                        + (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rO_DA(t_hour)              * DA_expV(t_hour)    ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV(t_quarter) * sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA)))       
						+ 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA) * omega_RA_out_call(t_quarter, s_out_RA))    )  ) ) )

*declined RL in\ out:
                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (
                        + sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rN_DA(t_hour)              * DA_expV(t_hour)    ))
                        + 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_in_expV(t_quarter) * sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA)))        
						+ 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA) * omega_RA_out_call(t_quarter, s_out_RA)))  ) ) )
                );
 
testEQ1(s_in_RA)..                       testV1(s_in_RA) =e=  sum(t_block, sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))* (sum(t_quarter, RA_in_expV(t_quarter) * Q_inrB_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA))))));
testEQ2(s_in_RA)..                       testV2(s_in_RA) =e= sum(t_quarter, Q_inrB_RA(t_quarter, s_in_RA));
testEQ3(s_in_RA)..                       testV3(s_in_RA) =e= sum(t_quarter, omega_RA_in_call(t_quarter, s_in_RA));
testEQ4(s_in_RA)..                       testV4(s_in_RA) =e= sum(t_quarter, RA_in_expV(t_quarter));

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
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rB_DA(t_hour)              * DA_expV(t_hour)  ))
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rI_DA(t_hour)              * DA_expV(t_hour)    ))
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rO_DA(t_hour)              * DA_expV(t_hour)    ))
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rN_DA(t_hour)              * DA_expV(t_hour)    ))
                                                )))
                                                );
profit_RAout_EQ..                       profitRAout =e= sum(t_block,
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  RA_in_expV(t_quarter) * sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA) )      )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  RA_in_expV(t_quarter) * sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA) )      )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  RA_in_expV(t_quarter) * sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA) )      )
                                                )))
                                                );
profit_RAin_EQ..                        profitRAin =e= sum(t_block,
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA) * omega_RA_out_call(t_quarter, s_out_RA) )    )
                                                )))
                                                + sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))  * (0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block), RA_out_expV(t_quarter) * sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA) * omega_RA_out_call(t_quarter, s_out_RA) )    )
                                                )))
                                                );

* accepted  RL\ in \ out:
sum_Q_in_RL_EQ..								sum_Q_in_RL =e= sum((t_block, s_in_RL), Q_in_RL(t_block, s_in_RL));
sum_Q_out_RL_EQ..								sum_Q_out_RL =e= sum((t_block, s_out_RL), Q_out_RL(t_block, s_out_RL));
sum_Q_rB_DA_EQ..								sum_Q_rB_DA =e= sum((t_hour), Q_rB_DA(t_hour)							);
sum_Q_outrB_RA_EQ..								sum_Q_outrB_RA =e= sum((t_quarter, s_out_RA), Q_outrB_RA(t_quarter, s_out_RA));
sum_Q_inrB_RA_EQ..								sum_Q_inrB_RA =e= sum((t_quarter, s_in_RA), Q_inrB_RA(t_quarter, s_in_RA));
sum_Q_rB_reload_EQ..								sum_Q_rB_reload =e= sum((t_hour), Q_rB_reload(t_hour)							);

*accepted RL in     \ declined out:
sum_Q_outrI_RA_EQ..								sum_Q_outrI_RA =e= sum((t_quarter, s_out_RA), Q_outrI_RA(t_quarter, s_out_RA));
sum_Q_inrI_RA_EQ..								sum_Q_inrI_RA =e= sum((t_quarter, s_in_RA), Q_inrI_RA(t_quarter, s_in_RA));
sum_Q_rI_DA_EQ..								sum_Q_rI_DA =e= sum((t_hour), Q_rI_DA(t_hour)							);
sum_Q_rI_reload_EQ..								sum_Q_rI_reload =e= sum((t_hour), Q_rI_reload(t_hour)							);

*declined RL in\ accepted out:
sum_Q_outrO_RA_EQ..								sum_Q_outrO_RA =e= sum((t_quarter, s_out_RA), Q_outrO_RA(t_quarter, s_out_RA));
sum_Q_inrO_RA_EQ..								sum_Q_inrO_RA =e= sum((t_quarter, s_in_RA), Q_inrO_RA(t_quarter, s_in_RA));
sum_Q_rO_DA_EQ..								sum_Q_rO_DA =e= sum((t_hour), Q_rO_DA(t_hour)							);
sum_Q_rO_reload_EQ..								sum_Q_rO_reload =e= sum((t_hour), Q_rO_reload(t_hour)							);

*declined RL in\ out:
sum_Q_outrN_RA_EQ..								sum_Q_outrN_RA =e= sum((t_quarter, s_out_RA), Q_outrN_RA(t_quarter, s_out_RA));
sum_Q_inrN_RA_EQ..								sum_Q_inrN_RA =e= sum((t_quarter, s_in_RA), Q_inrN_RA(t_quarter, s_in_RA));
sum_Q_rN_DA_EQ..								sum_Q_rN_DA =e= sum((t_hour), Q_rN_DA(t_hour)							);
sum_Q_reload_EQ..								sum_Q_reload =e= sum((t_hour), Q_reload(t_hour)							);
*   constraints
*battery cap
**batCapCalc..                        BatCap =g= max(Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA);
*batCapCalc..                       BatCap =g= max( Q_inrB_RA, Q_inrI_RA, Q_inrO_RA, Q_inrN_RA, Q_outrB_RA, Q_outrI_RA, Q_outrO_RA, Q_outrN_RA,
*                                                   Q_in_RL * 4, Q_out_RL * 4);


*access point:
accPointCon_a_B(t_quarter)..        a + sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA)) =g= sum(s_DA, sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_DA(t_hour))) + sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA));
accPointCon_a_I(t_quarter)..        a + sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA)) =g= sum(s_DA, sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_DA(t_hour))) + sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA));
accPointCon_a_O(t_quarter)..        a + sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA)) =g= sum(s_DA, sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_DA(t_hour))) + sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA));
accPointCon_a_N(t_quarter)..        a + sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA)) =g= sum(s_DA, sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_DA(t_hour))) + sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA));

*battery performance restrictions:
calc_r..                                        r =e= BatCap * rBat;
storCon_Q_out_RL(t_block)..                     sum(s_out_RL, Q_out_RL(t_block, s_out_RL))          =l= r;
storCon_Q_in_RL(t_block)..                      sum(s_in_RL, Q_in_RL(t_block, s_in_RL))             =l= r;


storCon_Q_outrB_RA(t_quarter)..                 sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA))      =l= r/4;
storCon_Q_outrI_RA(t_quarter)..                 sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA))      =l= r/4;
storCon_Q_outrO_RA(t_quarter)..                 sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA))      =l= r/4;
storCon_Q_outrN_RA(t_quarter)..                 sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA))      =l= r/4;

storCon_Q_inrB_RA(t_quarter)..                  sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA))         =l= r/4;
storCon_Q_inrI_RA(t_quarter)..                  sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA))         =l= r/4;
storCon_Q_inrO_RA(t_quarter)..                  sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA))         =l= r/4;
storCon_Q_inrN_RA(t_quarter)..                  sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA))         =l= r/4;

*batter cap restrictions
batStatCap(t_quarter)..                         BatStat(t_quarter) =l= BatCap;  
batCap_Q_out_RL(t_block)..                      sum(s_out_RL, Q_out_RL(t_block, s_out_RL)) * 4      =l= BatCap;
batCap_Q_in_RL(t_block)..                       sum(s_in_RL, Q_in_RL(t_block, s_in_RL)) * 4         =l= BatCap;

batCap_Q_outrB_RA(t_quarter)..                  sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA))      =l= BatCap;
batCap_Q_outrI_RA(t_quarter)..                  sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA))      =l= BatCap;
batCap_Q_outrO_RA(t_quarter)..                  sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA))      =l= BatCap;
batCap_Q_outrN_RA(t_quarter)..                  sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA))      =l= BatCap;

batCap_Q_inrB_RA(t_quarter)..                   sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA))         =l= BatCap;
batCap_Q_inrI_RA(t_quarter)..                   sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA))         =l= BatCap;
batCap_Q_inrO_RA(t_quarter)..                   sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA))         =l= BatCap;
batCap_Q_inrN_RA(t_quarter)..                   sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA))         =l= BatCap;

*battery status restrictions
*expectet battery value in t+1:
batStatcon_(t_quarter)..                    BatStat(t_quarter + 1) =e= BatStat(t_quarter)         
*accepted  RL\ in \ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))           * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rB_reload(t_hour) / 4)                                                         
                        + sum(s_in_RA, (Q_inrB_RA(t_quarter, s_in_RA)    * omega_RA_in_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, (Q_outrB_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA)))   )))     
*
*accepted RL in     \ declined out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rI_reload(t_hour) / 4)                                                        
                        + sum(s_in_RA, (Q_inrI_RA(t_quarter, s_in_RA)    * omega_RA_in_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, (Q_outrI_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA)))   )))
                            
*declined RL in     \ accepted out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL)))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rO_reload(t_hour) / 4)                                                        
                        + sum(s_in_RA, (Q_inrO_RA(t_quarter, s_in_RA)    * omega_RA_in_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, (Q_outrO_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA)))   )))     
*
*declined RL in\ out:
                +sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))))       * (
                        + sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_rN_reload(t_hour) / 4)                                                        
                        + sum(s_in_RA, (Q_inrN_RA(t_quarter, s_in_RA)        * omega_RA_in_call(t_quarter, s_in_RA)))
                        - sum(s_out_RA, (Q_outrN_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA)))   )));
*
                    
                            

*park restrictions:
parkCon_Q_rB_DA(t_hour)..                   sum(s_DA, Q_rB_DA(t_hour)) =l= parkCap * parkProfile(t_hour) - Q_rB_reload(t_hour);
parkCon_Q_rI_DA(t_hour)..                   sum(s_DA, Q_rI_DA(t_hour)) =l= parkCap * parkProfile(t_hour) - Q_rI_reload(t_hour);
parkCon_Q_rO_DA(t_hour)..                   sum(s_DA, Q_rO_DA(t_hour)) =l= parkCap * parkProfile(t_hour) - Q_rO_reload(t_hour);
parkCon_Q_rN_DA(t_hour)..                   sum(s_DA, Q_rN_DA(t_hour)) =l= parkCap * parkProfile(t_hour) - Q_rN_reload(t_hour);




*market restrictions:
marketCon_outrB_RA(t_quarter)..                 sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block),sum(s_out_RL, Q_out_RL(t_block, s_out_RL)));
*marketCon_outrI_RA(t_quarter)..                sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block),sum(s_out_RL, Q_out_RL(t_block, s_out_RL)));
marketCon_outrO_RA(t_quarter)..                 sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block),sum(s_out_RL, Q_out_RL(t_block, s_out_RL)));
*marketCon_out_RA(t_quarter)..                  sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA) * 4)      =g= sum(t_block$map_quarter_block(t_quarter, t_block),sum(s_out_RL, Q_out_RL(t_block, s_out_RL)));

marketCon_inrB_RA(t_quarter)..                  sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), sum(s_in_RL, Q_in_RL(t_block, s_in_RL)));
marketCon_inrI_RA(t_quarter)..                  sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), sum(s_in_RL, Q_in_RL(t_block, s_in_RL)));
*marketCon_inrO_RA(t_quarter)..                 sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), sum(s_in_RL, Q_in_RL(t_block, s_in_RL)));
*marketCon_in_RA(t_quarter)..                   sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA) * 4)         =g= sum(t_block$map_quarter_block(t_quarter, t_block), sum(s_in_RL, Q_in_RL(t_block, s_in_RL)));


Model testFirstDecision /all/;
Solve testFirstDecision maximising Profit using LP;

execute_unload "Result_Miehle.gdx" BatStat.l
execute 'gdxxrw.exe Result_Miehle.gdx rng=a1:e160 par=BatStat log=log_exe_test.txt'