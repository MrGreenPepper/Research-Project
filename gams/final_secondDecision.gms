Sets
s_in_RL             /s_in_RL1*s_in_RL3/
s_out_RL            /s_out_RL1*s_out_RL3/
s_DA                /s_DA1*s_DA3/
s_in_RA             /s_in_RA1*s_in_RA3/
s_out_RA            /s_out_RA1*s_out_RA3/
;

Scalars
a           		/150/
r           		/100/
M           		/1000000/
useFactorIn			/0.5/
useFactorOut		/0.5/
BatteryCap			/100/
ParkCap				/100/
;

Parameters
omega_RL_in(t, s_in_RL)                        /s_in_RL1 	0.7,  	s_in_RL2 	0.5,	s_in_RL3 	0.3/
omega_RL_out(t, s_out_RL)                      /s_out_RL1 	0.7, 	s_out_RL2 	0.5,	s_out_RL3 	0.3/
omega_DA(t, s_DA)                              /s_DA1 		0.7,    s_DA2 		0.5,	s_DA3 		0.3/
omega_RA_in(t, s_in_RA)                        /s_in_RA1 	0.7,  	s_in_RA2 	0.5,	s_in_RA3 	0.3/
omega_RA_out(t, s_out_RA)                      /s_out_RA1 	0.7, 	s_out_RA2 	0.5,	s_out_RA3 	0.3/
p_in_RL(t, s_in_RL)                            /s_in_RL1 	90,   	s_in_RL2 	100,   	s_in_RL3 	110/
p_out_RL(t, s_out_RL)                          /s_out_RL1 	90,  	s_out_RL2 	100,  	s_out_RL3 	110/
p_DA(t, s_DA)                                  /s_DA1 		90,     s_DA2 		100,    s_DA3 		110/
p_in_RA(t, s_in_RA)                            /s_in_RA1 	90,   	s_in_RA2 	100,   	s_in_RA3 	110/
p_out_RA(t, s_out_RA)                          /s_out_RA1 	90,  	s_out_RA2 	100,  	s_out_RA3 	110/

q_in_RL(t, s_in_RL)                            /s_in_RL1 	100,  	s_in_RL2 	0,     	s_in_RL3 	0/
q_out_RL(t, s_out_RL)                          /s_out_RL1 	100, 	s_out_RL2 	0,    	s_out_RL3 	0/

c_in_RL                                     /50/
c_out_RL                                    /50/
;

Variables
Profit
* accepted  RL\ in \ out:
;

Positive Variables
batteryState(t)
reload(s_DA)

Q_rRL_DA
Q_outrRLDA_RA
Q_inrRLDA_RA
Q_outrRL_RA
Q_inrRL_RA

*accepted RL in     \ declined out:
Q_outrDA_RA

*declined RL in\ accepted out:
Q_inrDA_RA
Q_outrRL_RA

*declined RL in\ out:
Q_DA(t, s_DA)
Q_in_RA(t, s_in_RA)
Q_out_RA(t, s_out_RA)
;

Binary Variables
B_in_RL(t, s_in_RL)
B_out_RL(t, s_out_RL) 
;


Equations
profitEQ

*   Nebenbedingungen
*Anschlusspunkt:
conConst_Q_outrRLDA_RA
conConst_Q_outrDA_RA
conConst_Q_out_RA

*Batterie Restriktionen:
storCon_Q_out_RL
storCon_Q_in_RL
storCon_Q_DA
storCon_Q_out_RA
storCon_Q_in_RA
storCon_Q_outrRL_RA
storCon_Q_inrRL_RA
storCon_Q_outrDA_RA
storCon_Q_inrDA_RA
storCon_Q_outrRLDA_RA
storCon_Q_inrRLDA_RA

*Markt Restriktionen:
marketCon_Q_outrRL_RA
marketCon_Q_inrRL_RA
marketCon_Q_outrRLDA_RA
marketCon_Q_inrRLDA_RA

marketBidCon_c_in_RL1
marketBidCon_c_in_RL2
marketBidCon_c_out_RL1
marketBidCon_c_out_RL2
;
 

*working
*sum(s_in_RL, sum(s_out_RL, omega_RL_out(t, s_out_RL)) * (Q_in_RL(t, s_in_RL)));
*sum(s_in_RL, sum(s_out_RL, (omega_RL_in(t, s_in_RL) * omega_RL_out(t, s_out_RL) * (Q_in_RL(t, s_in_RL)))));

profitEQ..      Profit  =e=

                sum(s_in_RL, q_in_RL(t, s_in_RL) * p_in_RL(t, s_in_RL) * B_in_RL(t, s_in_RL)) +
                sum(s_out_RL, q_out_RL(t, s_out_RL) * p_out_RL(t, s_out_RL) * B_out_RL(t, s_out_RL)) 
              
                        + sum(s_DA, omega_DA(t, s_DA)   *(
                                Q_DA(t, s_DA) * p_DA(t, s_DA) 
                                + sum(s_in_RA, Q_inrDA_RA(t, s_in_RA) * p_in_RA(t, s_in_RA) * omega_RA_in(t, s_in_RA))
                                + sum(s_out_RA, Q_outrDA_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))
                        + sum(s_DA,(1-omega_DA(t, s_DA)) * (
                                sum(s_in_RA, Q_in_RA(t, s_in_RA) * p_in_RA(t, s_in_RA) * omega_RA_in(t, s_in_RA))
                                + sum(s_out_RA, Q_out_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))));
 


 
*Nebenbedingungen

*Anschlusspunkt:
conConst_Q_outrDA_RA(t)..			a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_outrDA_RA(t, s_out_RA)) + sum(s_DA, Q_DA(t, s_DA));
conConst_Q_out_RA(t)..			 	a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_out_RA(t, s_out_RA)); 
*Batterie laden/entladen
batteryState_con(t)..				batteryState(t) =e= batteryState_con(t-1) 
														+ sum(s_DA, omega_DA(t, s_DA)   *(
                                								Q_DA(t, s_DA) * p_DA(t, s_DA) 
               									                - sum(s_in_RA, Q_inrDA_RA(t, s_in_RA) * omega_RA_in(t, s_in_RA))
               									                + sum(s_out_RA, Q_outrDA_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))
               									        + sum(s_DA,(1-omega_DA(t, s_DA)) * (
               									                - sum(s_in_RA, Q_in_RA(t, s_in_RA) * omega_RA_in(t, s_in_RA))
               									                + sum(s_out_RA, Q_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))));

*														 		+ sum(s_in_RA, Q_in_RA(t-1, s_in_RA) * omega_RA_in(t-1, s_in_RA)) 
*														 		+ sum(s_DA, reload(t, s_DA) * omega_DA(t, s_DA))
*														 		- (sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA)) + sum(s_DA, Q_rRL_DA(t, s_DA) * omega_DA(t, s_DA))
*														 			+ sum(s_out_RA, Q_outrDA_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA)) + sum(s_DA, Q_DA(t, s_DA) * omega_DA(t, s_DA))
*														 			+ sum(s_out_RA, Q_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA)));
batteryState_con2(t)..				batteryState(t) =l= BatteryCap;
																																
*Batterie Restriktionen:
storCon_Q_out_RL(t)..				sum(s_out_RL, Q_out_RL(t, s_out_RL)) =l= r;
storCon_Q_in_RL(t)..				sum(s_in_RL, Q_in_RL(t, s_in_RL)) =l= r;
storCon_Q_out_RA(t)..			 	sum(s_out_RA, Q_out_RA(t, s_out_RA)) =l= r;
storCon_Q_in_RA(t)..			 	sum(s_in_RA, Q_in_RA(t, s_in_RA)) =l= r;
storCon_Q_outrRL_RA(t)..			sum(s_out_RA, Q_outrRL_RA(t, s_out_RA)) =l= r;
storCon_Q_inrRL_RA(t)..				sum(s_in_RA, Q_inrRL_RA(t, s_in_RA)) =l= r;
storCon_Q_outrDA_RA(t)..			sum(s_out_RA, Q_outrDA_RA(t, s_out_RA)) =l= r;
storCon_Q_inrDA_RA(t)..			 	sum(s_in_RA, Q_inrDA_RA(t, s_in_RA)) =l= r;
storCon_Q_outrRLDA_RA(t)..			sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) =l= r;
storCon_Q_inrRLDA_RA(t)..			sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA)) =l= r;

*Park Restriktionen:
storCon_Q_DA(t)..			 		sum(s_DA, Q_DA(t, s_DA)) =l= parkProfile(t) * parkCapacity - sum(s_DA, reload(s_DA));
storCon_Q_DA(t)..			 		sum(s_DA, Q_rRL_DA(t, s_DA)) =l= parkProfile(t) * parkCapacity - sum(s_DA, reload(s_DA));
*Markt Restriktionen:
marketCon_Q_outrRL_RA(t)..			sum(s_out_RA, Q_outrRL_RA(t, s_out_RA)) =g= sum(s_out_RL, Q_out_RL(t, s_out_RL));
marketCon_Q_inrRL_RA(t)..			sum(s_in_RA, Q_inrRL_RA(t, s_in_RA)) =g= sum(s_in_RL, Q_in_RL(t, s_in_RL));
marketCon_Q_outrRLDA_RA(t)..		sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) =g= sum(s_out_RL, Q_out_RL(t, s_out_RL));
marketCon_Q_inrRLDA_RA(t)..			sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA)) =g= sum(s_in_RL, Q_in_RL(t, s_in_RL));
*Modell Restriktionen:
*   (Linearität)
*X_out_RL =l= B_out_RL * r;
*Q_out_RL - X_out_RL =l= (1-B_out_RL) * r;
*Q_out_RL =g= 0;
*X_in_RL =l= B_in_RL * r;
*Q_in_RL - X_in_RL =l= (1-B_in_RL) * r;
*Q_in_RL =g= 0;
*X_DA =l= B_DA * r;
*Q_DA - X_DA =l= (1-B_DA) * r;
*Q_DA =g= 0;
*   (Angenommene/Abgelehnte Gebote)
marketBidCon_c_in_RL1(t, s_in_RL).. c_in_RL =l= p_in_RL(t, s_in_RL) + M * B_in_RL(t, s_in_RL);
marketBidCon_c_in_RL2(t, s_in_RL).. c_in_RL =g= p_in_RL(t, s_in_RL) - M * (1 - B_in_RL(t, s_in_RL));
marketBidCon_c_out_RL1(t, s_out_RL).. c_out_RL =l= p_out_RL(t, s_out_RL) + M * B_out_RL(t, s_out_RL);
marketBidCon_c_out_RL2(t, s_out_RL).. c_out_RL =g= p_out_RL(t, s_out_RL) - M * (1 - B_out_RL(t, s_out_RL));
*c_DA =l= p(t, s_DA) + M * B_DA(t, s_DA)\quad\forall s_DA;
*c_DA =g= p(t, s_DA) - M * (1 - B_DA(t, s_DA))\quad\forall s_DA;

Model testSecondDecision /all/;
Solve testSecondDecision maximising Profit using MIP;





Sets
s_in_RL             /s_in_RL1*s_in_RL3/
s_out_RL            /s_out_RL1*s_out_RL3/
s_DA                /s_DA1*s_DA3/
s_in_RA             /s_in_RA1*s_in_RA3/
s_out_RA            /s_out_RA1*s_out_RA3/
;

Scalars
a           /150/
r           /100/
M           /100000/
;

Parameters
omega_RL_in(t, s_in_RL)                        /s_in_RL1 0.7,  s_in_RL2 0.5,   s_in_RL3 0.3/
omega_RL_out(t, s_out_RL)                      /s_out_RL1 0.7, s_out_RL2 0.5,  s_out_RL3 0.3/
omega_DA(t, s_DA)                              /s_DA1 0.7,     s_DA2 0.5,      s_DA3 0.3/
omega_RA_in(t, s_in_RA)                        /s_in_RA1 0.7,  s_in_RA2 0.5,   s_in_RA3 0.3/
omega_RA_out(t, s_out_RA)                      /s_out_RA1 0.7, s_out_RA2 0.5,  s_out_RA3 0.3/
p_in_RL(t, s_in_RL)                            /s_in_RL1 90,   s_in_RL2 100,   s_in_RL3 110/
p_out_RL(t, s_out_RL)                          /s_out_RL1 90,  s_out_RL2 100,  s_out_RL3 110/
p_DA(t, s_DA)                                  /s_DA1 90,      s_DA2 100,      s_DA3 110/
p_in_RA(t, s_in_RA)                            /s_in_RA1 90,   s_in_RA2 100,   s_in_RA3 110/
p_out_RA(t, s_out_RA)                          /s_out_RA1 90,  s_out_RA2 100,  s_out_RA3 110/

q_in_RL(t, s_in_RL)                            /s_in_RL1 100,  s_in_RL2 0,     s_in_RL3 0/
q_out_RL(t, s_out_RL)                          /s_out_RL1 100, s_out_RL2 0,    s_out_RL3 0/
q_DA(t, s_DA)                                  /s_DA1 100,     s_DA2 0,        s_DA3 0/

c_in_RL                                     /100/
c_out_RL                                    /100/
c_DA                                        /100/
;

Variables
Profit
* accepted  RL\ in \ out:
;

Positive Variables
Q_rRL_DA
Q_outrRLDA_RA
Q_inrRLDA_RA
Q_outrRL_RA
Q_inrRL_RA

*accepted RL in     \ declined out:
Q_outrDA_RA

*declined RL in\ accepted out:
Q_inrDA_RA
Q_outrRL_RA

*declined RL in\ out:
Q_in_RA(t, s_in_RA)
Q_out_RA(t, s_out_RA)
;

Binary Variables
B_in_RL(t, s_in_RL)
B_out_RL(t, s_out_RL) 
B_DA(t, s_DA)
;


Equations
profitEQ

*Nebenbedingungen
*Anschlusspunkt:
conConst_Q_outrRLDA_RA
conConst_Q_outrDA_RA
conConst_Q_out_RA

*Batterie Restriktionen:
storCon_Q_out_RL
storCon_Q_in_RL
storCon_Q_DA
storCon_Q_out_RA
storCon_Q_in_RA
storCon_Q_outrRL_RA
storCon_Q_inrRL_RA
storCon_Q_outrDA_RA
storCon_Q_inrDA_RA
storCon_Q_outrRLDA_RA
storCon_Q_inrRLDA_RA

*Markt Restriktionen:
marketCon_Q_outrRL_RA
marketCon_Q_inrRL_RA
marketCon_Q_outrRLDA_RA
marketCon_Q_inrRLDA_RA

marketBidCon_c_in_RL1
marketBidCon_c_in_RL2
marketBidCon_c_out_RL1
marketBidCon_c_out_RL2

marketBidCon_c_out_DA1
marketBidCon_c_out_DA2
;
 

*working
*sum(s_in_RL, sum(s_out_RL, omega_RL_out(t, s_out_RL)) * (Q_in_RL(t, s_in_RL)));
*sum(s_in_RL, sum(s_out_RL, (omega_RL_in(t, s_in_RL) * omega_RL_out(t, s_out_RL) * (Q_in_RL(t, s_in_RL)))));

profitEQ..      Profit  =e=

                sum(s_in_RL, q_in_RL(t, s_in_RL) * p_in_RL(t, s_in_RL) * B_in_RL(t, s_in_RL))
                + sum(s_out_RL, + q_out_RL(t, s_out_RL) * p_out_RL(t, s_out_RL) * B_out_RL(t, s_out_RL))
                + sum(s_DA, q_DA(t, s_DA) * p_DA(t, s_DA) * B_DA(t, s_DA) )
                + sum(s_in_RA, Q_in_RA(t, s_in_RA) * p_in_RA(t, s_in_RA) * omega_RA_in(t, s_in_RA))
                + sum(s_out_RA, Q_out_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA));

 


 
*Nebenbedingungen

*Anschlusspunkt:
conConst_Q_outrRLDA_RA(t)..    a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) +sum(s_DA, Q_rRL_DA(t, s_DA));
conConst_Q_outrDA_RA(t)..      a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_outrDA_RA(t, s_out_RA)) +sum(s_DA, Q_DA(t, s_DA));
conConst_Q_out_RA(t)..         a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_out_RA(t, s_out_RA));
*Batterie Restriktionen:
storCon_Q_out_RL(t)..           sum(s_out_RL, Q_out_RL(t, s_out_RL)) =l= r;
storCon_Q_in_RL(t)..            sum(s_in_RL, Q_in_RL(t, s_in_RL)) =l= r;
storCon_Q_DA(t)..               sum(s_DA, Q_DA(t, s_DA)) =l= windProfile(t) * parkCapacity;
storCon_Q_out_RA(t)..           sum(s_out_RA, Q_out_RA(t, s_out_RA)) =l= r;
storCon_Q_in_RA(t)..            sum(s_in_RA, Q_in_RA(t, s_in_RA)) =l= r;
storCon_Q_outrRL_RA(t)..        sum(s_out_RA, Q_outrRL_RA(t, s_out_RA)) =l= r;
storCon_Q_inrRL_RA(t)..         sum(s_in_RA, Q_inrRL_RA(t, s_in_RA)) =l= r;
storCon_Q_outrDA_RA(t)..        sum(s_out_RA, Q_outrDA_RA(t, s_out_RA)) =l= r;
storCon_Q_inrDA_RA(t)..         sum(s_in_RA, Q_inrDA_RA(t, s_in_RA)) =l= r;
storCon_Q_outrRLDA_RA(t)..      sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) =l= r;
storCon_Q_inrRLDA_RA(t)..       sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA)) =l= r;
*Markt Restriktionen:
marketCon_Q_outrRL_RA(t)..     sum(s_out_RA, Q_outrRL_RA(t, s_out_RA)) =g= sum(s_out_RL, Q_out_RL(t, s_out_RL));
marketCon_Q_inrRL_RA(t)..      sum(s_in_RA, Q_inrRL_RA(t, s_in_RA)) =g= sum(s_in_RL, Q_in_RL(t, s_in_RL));
marketCon_Q_outrRLDA_RA(t)..   sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) =g= sum(s_out_RL, Q_out_RL(t, s_out_RL));
marketCon_Q_inrRLDA_RA(t)..    sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA)) =g= sum(s_in_RL, Q_in_RL(t, s_in_RL));
*Modell Restriktionen:
*   (Linearität)
*X_out_RL =l= B_out_RL * r;
*Q_out_RL - X_out_RL =l= (1-B_out_RL) * r;
*Q_out_RL =g= 0;
*X_in_RL =l= B_in_RL * r;
*Q_in_RL - X_in_RL =l= (1-B_in_RL) * r;
*Q_in_RL =g= 0;
*X_DA =l= B_DA * r;
*Q_DA - X_DA =l= (1-B_DA) * r;
*Q_DA =g= 0;
*   (Angenommene/Abgelehnte Gebote)
marketBidCon_c_in_RL1(t, s_in_RL)..    yc_in_RL =l= p_in_RL(t, s_in_RL) + M * B_in_RL(t, s_in_RL);
marketBidCon_c_in_RL2(t, s_in_RL)..    c_in_RL =g= p_in_RL(t, s_in_RL) - M * (1 - B_in_RL(t, s_in_RL));
marketBidCon_c_out_RL1(t, s_out_RL)..  c_out_RL =l= p_out_RL(t, s_out_RL) + M * B_out_RL(t, s_out_RL);
marketBidCon_c_out_RL2(t, s_out_RL)..  c_out_RL =g= p_out_RL(t, s_out_RL) - M * (1 - B_out_RL(t, s_out_RL));
marketBidCon_c_out_DA1(t, s_DA)..      c_DA =l= p_DA(t, s_DA) + M * B_DA(t, s_DA);
marketBidCon_c_out_DA2(t, s_DA)..      c_DA =g= p_DA(t, s_DA) - M * (1 - B_DA(t, s_DA));

Model testThirdDecision /all/;
Solve testThirdDecision maximising Profit using MIP;
