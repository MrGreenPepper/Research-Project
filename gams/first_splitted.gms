Sets
*scenario sets
s_in_RL                / s0*s51/
s_out_RL            / s0*s51/
s_DA                   / s0*s51/
s_in_RA             / s0*s51/
s_out_RA            / s0*s51/
t_block                / b1*b2000 /
sub_t_block(t_block)
t_hour             / h1*h8000 /
sub_t_hour(t_hour)  
t_quarter          / q1*q32000 /
sub_t_quarter(t_quarter)
;

Scalar
batchSizeB		/6/
batchSizeH		/24/
batchSizeQ		/96/
;

Sets
*time mapping
map_quarter_hour(t_quarter, t_hour)
map_quarter_block(t_quarter, t_block)
map_hour_block(t_hour, t_block); 
;


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
Parameter omega_RA_in(t_quarter, s_in_RA)
$gdxIn negEnAverage_scenarioPerc.gdx
$load omega_RA_in 
$gdxIn
;


Parameter omega_RA_in_call(t_quarter, s_in_RA)
$gdxIn negEnAverage_scenarioPerc_call.gdx
$load omega_RA_in_call 
$gdxIn
;


Parameter p_in_RA(t_quarter, s_in_RA)
$gdxIn negEnAverage_scenarioValues.gdx
$load p_in_RA 
$gdxIn
;


Parameter omega_RA_out(t_quarter, s_out_RA)
$gdxIn posEnAverage_scenarioPerc.gdx
$load omega_RA_out 
$gdxIn
;


Parameter omega_RA_out_call(t_quarter, s_out_RA)
$gdxIn posEnAverage_scenarioPerc_call.gdx
$load omega_RA_out_call 
$gdxIn
;


Parameter p_out_RA(t_quarter, s_out_RA)
$gdxIn posEnAverage_scenarioValues.gdx
$load p_out_RA 
$gdxIn
;

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
;


Variables
Profit
;
Positive Variables 
BatCap
BatStat(t_quarter)
r

|
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
Q_rB_reload
Q_rI_reload
Q_rO_reload
Q_rN_reload
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
;

loop((startI = 1 to card(t_block) by batchSizeB),
    loop((startJ = 1 to card(t_hour) by batchSizeH),
        loop((startK = 1 to card(t_quarter) by batchSizeQ),
            I_sub(I) = no; J_sub(J) = no; K_sub(K) = no;
			*obj function:
			profitEQ..      Profit  =e=
							- (BatCap * batCosts)
							+ sum(t_block, 
			* accepted  RL\ in \ out:
							+ sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))      * (
									+ (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
									+ (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
									+ sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rB_DA(t_hour)              * sum(s_DA, omega_DA(t_hour, s_DA) * p_DA(t_hour, s_DA))  ))
									+ 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  sum(s_in_RA, Q_inrB_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA))      * sum(s_in_RA, p_in_RA(t_quarter, s_in_RA) * omega_RA_in(t_quarter, s_in_RA))  
																							+ sum(s_out_RA, Q_outrB_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA))    * sum(s_out_RA, p_out_RA(t_quarter, s_out_RA) * omega_RA_out(t_quarter, s_out_RA)))  ) ) )

			*accepted RL in     \ declined out:
							+ sum(s_out_RL, sum(s_in_RL, (omega_RL_in(t_block, s_in_RL) * (1-omega_RL_out(t_block, s_out_RL)))   * (
									+ (4 * (Q_in_RL(t_block, s_in_RL)        * p_in_RL(t_block, s_in_RL)))                        
									+ sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rI_DA(t_hour)              * sum(s_DA, omega_DA(t_hour, s_DA) * p_DA(t_hour, s_DA))    ))
									+ 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  sum(s_in_RA, Q_inrI_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA))      * sum(s_in_RA, p_in_RA(t_quarter, s_in_RA) * omega_RA_in(t_quarter, s_in_RA))
																							+ sum(s_out_RA, Q_outrI_RA(t_quarter, s_out_RA)  * omega_RA_out_call(t_quarter, s_out_RA))    * sum(s_out_RA, p_out_RA(t_quarter, s_out_RA) * omega_RA_out(t_quarter, s_out_RA)))  ) ) )
										
			*declined RL in     \ accepted out:
							+ sum(s_out_RL, sum(s_in_RL, ((1-omega_RL_in(t_block, s_in_RL)) * omega_RL_out(t_block, s_out_RL))   * (
									+ (4 * (Q_out_RL(t_block, s_out_RL)      * p_out_RL(t_block, s_out_RL)))
									+ sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rO_DA(t_hour)              * sum(s_DA, omega_DA(t_hour, s_DA) * p_DA(t_hour, s_DA))    ))
									+ 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  sum(s_in_RA, Q_inrO_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA))      * sum(s_in_RA, p_in_RA(t_quarter, s_in_RA) * omega_RA_in(t_quarter, s_in_RA)) 
																							+ sum(s_out_RA, Q_outrO_RA(t_quarter, s_out_RA) * omega_RA_out_call(t_quarter, s_out_RA))    * sum(s_out_RA, p_out_RA(t_quarter, s_out_RA) * omega_RA_out(t_quarter, s_out_RA)))  ) ) )

			*declined RL in\ out:
							+ sum(s_out_RL, sum(s_in_RL, (1-(omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL)))  * (
									+ sum(t_hour$map_hour_block(t_hour, t_block),           (Q_rN_DA(t_hour)              * sum(s_DA, omega_DA(t_hour, s_DA) * p_DA(t_hour, s_DA))    ))
									+ 0.25 * sum(t_quarter$map_quarter_block(t_quarter, t_block),  sum(s_in_RA, Q_inrN_RA(t_quarter, s_in_RA) * omega_RA_in_call(t_quarter, s_in_RA))      * sum(s_in_RA, p_in_RA(t_quarter, s_in_RA) * omega_RA_in(t_quarter, s_in_RA))   
																							+ sum(s_out_RA, Q_outrN_RA(t_quarter, s_out_RA) * omega_RA_out_call(t_quarter, s_out_RA))    * sum(s_out_RA, p_out_RA(t_quarter, s_out_RA) * omega_RA_out(t_quarter, s_out_RA)))  ) ) )
							);
			


			
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
							+sum(s_out_RL, sum(s_in_RL, sum(t_block$map_quarter_block(t_quarter, t_block), (1-(omega_RL_in(t_block, s_in_RL) * omega_RL_out(t_block, s_out_RL))))       * (
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
        );
    );
);