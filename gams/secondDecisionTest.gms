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
omega_RL_in(s_in_RL)                        /s_in_RL1 	0.7,  	s_in_RL2 	0.5,	s_in_RL3 	0.3/
omega_RL_out(s_out_RL)                      /s_out_RL1 	0.7, 	s_out_RL2 	0.5,	s_out_RL3 	0.3/
omega_DA(s_DA)                              /s_DA1 		0.7,    s_DA2 		0.5,	s_DA3 		0.3/
omega_RA_in(s_in_RA)                        /s_in_RA1 	0.7,  	s_in_RA2 	0.5,	s_in_RA3 	0.3/
omega_RA_out(s_out_RA)                      /s_out_RA1 	0.7, 	s_out_RA2 	0.5,	s_out_RA3 	0.3/
p_in_RL(s_in_RL)                            /s_in_RL1 	90,   	s_in_RL2 	100,   	s_in_RL3 	110/
p_out_RL(s_out_RL)                          /s_out_RL1 	90,  	s_out_RL2 	100,  	s_out_RL3 	110/
p_DA(s_DA)                                  /s_DA1 		90,     s_DA2 		100,    s_DA3 		110/
p_in_RA(s_in_RA)                            /s_in_RA1 	90,   	s_in_RA2 	100,   	s_in_RA3 	110/
p_out_RA(s_out_RA)                          /s_out_RA1 	90,  	s_out_RA2 	100,  	s_out_RA3 	110/

q_in_RL(s_in_RL)                            /s_in_RL1 	100,  	s_in_RL2 	0,     	s_in_RL3 	0/
q_out_RL(s_out_RL)                          /s_out_RL1 	100, 	s_out_RL2 	0,    	s_out_RL3 	0/

c_in_RL                                     /50/
c_out_RL                                    /50/
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
Q_DA(s_DA)
Q_in_RA(s_in_RA)
Q_out_RA(s_out_RA)
;

Binary Variables
B_in_RL(s_in_RL)
B_out_RL(s_out_RL) 
;


Equations
profitEQ

*   Nebenbedingungen
*Anschlusspunkt:
conConst_Q_outrRLDA_RA
conConst_Q_outrDA_RA
conConst_Q_out_RA

*Batterie Restriktionen:
storConQ_out_RL
storConQ_in_RL
storConQ_DA
storConQ_out_RA
storConQ_in_RA
storConQ_outrRL_RA
storConQ_inrRL_RA
storConQ_outrDA_RA
storConQ_inrDA_RA
storConQ_outrRLDA_RA
storConQ_inrRLDA_RA

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
*sum(s_in_RL, sum(s_out_RL, omega_RL_out(s_out_RL)) * (Q_in_RL(s_in_RL)));
*sum(s_in_RL, sum(s_out_RL, (omega_RL_in(s_in_RL) * omega_RL_out(s_out_RL) * (Q_in_RL(s_in_RL)))));

profitEQ..      Profit  =e=

                sum(s_in_RL, q_in_RL(s_in_RL) * p_in_RL(s_in_RL) * B_in_RL(s_in_RL)) +
                sum(s_out_RL, + q_out_RL(s_out_RL) * p_out_RL(s_out_RL) * B_out_RL(s_out_RL)) 
                +sum(s_out_RL,sum(s_in_RL, (1-(omega_RL_in(s_in_RL)*omega_RL_out(s_out_RL)))    *(
                        sum(s_DA, omega_DA(s_DA)   *(
                                Q_DA(s_DA) * p_DA(s_DA) 
                                + sum(s_in_RA, Q_inrDA_RA(s_in_RA) * p_in_RA(s_in_RA) * omega_RA_in(s_in_RA))
                                + sum(s_out_RA, Q_outrDA_RA(s_out_RA) * p_out_RA(s_out_RA) * omega_RA_out(s_out_RA))))
                        + sum(s_DA,(1-omega_DA(s_DA)) * (
                                sum(s_in_RA, Q_in_RA(s_in_RA) * p_in_RA(s_in_RA) * omega_RA_in(s_in_RA))
                                + sum(s_out_RA, Q_out_RA(s_out_RA) * p_out_RA(s_out_RA) * omega_RA_out(s_out_RA)))))));
 


 
*Nebenbedingungen

*Anschlusspunkt:
conConst_Q_outrRLDA_RA.. a + sum(s_in_RA, Q_in_RA(s_in_RA)) =g= sum(s_out_RA, Q_outrRLDA_RA(s_out_RA)) +sum(s_DA, Q_rRL_DA(s_DA));
conConst_Q_outrDA_RA.. a + sum(s_in_RA, Q_in_RA(s_in_RA)) =g= sum(s_out_RA, Q_outrDA_RA(s_out_RA)) +sum(s_DA, Q_DA(s_DA));
conConst_Q_out_RA.. a + sum(s_in_RA, Q_in_RA(s_in_RA)) =g= sum(s_out_RA, Q_out_RA(s_out_RA));
*Batterie Restriktionen:
storConQ_out_RL.. sum(s_out_RL, Q_out_RL(s_out_RL)) =l= r;
storConQ_in_RL.. sum(s_in_RL, Q_in_RL(s_in_RL)) =l= r;
storConQ_DA.. sum(s_DA, Q_DA(s_DA)) =l= r;
storConQ_out_RA.. sum(s_out_RA, Q_out_RA(s_out_RA)) =l= r;
storConQ_in_RA.. sum(s_in_RA, Q_in_RA(s_in_RA)) =l= r;
storConQ_outrRL_RA.. sum(s_out_RA, Q_outrRL_RA(s_out_RA)) =l= r;
storConQ_inrRL_RA.. sum(s_in_RA, Q_inrRL_RA(s_in_RA)) =l= r;
storConQ_outrDA_RA.. sum(s_out_RA, Q_outrDA_RA(s_out_RA)) =l= r;
storConQ_inrDA_RA.. sum(s_in_RA, Q_inrDA_RA(s_in_RA)) =l= r;
storConQ_outrRLDA_RA.. sum(s_out_RA, Q_outrRLDA_RA(s_out_RA)) =l= r;
storConQ_inrRLDA_RA.. sum(s_in_RA, Q_inrRLDA_RA(s_in_RA)) =l= r;
*Markt Restriktionen:
marketCon_Q_outrRL_RA.. sum(s_out_RA, Q_outrRL_RA(s_out_RA)) =g= sum(s_out_RL, Q_out_RL(s_out_RL));
marketCon_Q_inrRL_RA.. sum(s_in_RA, Q_inrRL_RA(s_in_RA)) =g= sum(s_in_RL, Q_in_RL(s_in_RL));
marketCon_Q_outrRLDA_RA.. sum(s_out_RA, Q_outrRLDA_RA(s_out_RA)) =g= sum(s_out_RL, Q_out_RL(s_out_RL));
marketCon_Q_inrRLDA_RA.. sum(s_in_RA, Q_inrRLDA_RA(s_in_RA)) =g= sum(s_in_RL, Q_in_RL(s_in_RL));
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
marketBidCon_c_in_RL1(s_in_RL).. c_in_RL =l= p_in_RL(s_in_RL) + M * B_in_RL(s_in_RL);
marketBidCon_c_in_RL2(s_in_RL).. c_in_RL =g= p_in_RL(s_in_RL) - M * (1 - B_in_RL(s_in_RL));
marketBidCon_c_out_RL1(s_out_RL).. c_out_RL =l= p_out_RL(s_out_RL) + M * B_out_RL(s_out_RL);
marketBidCon_c_out_RL2(s_out_RL).. c_out_RL =g= p_out_RL(s_out_RL) - M * (1 - B_out_RL(s_out_RL));
*c_DA =l= p(s_DA) + M * B_DA(s_DA)\quad\forall s_DA;
*c_DA =g= p(s_DA) - M * (1 - B_DA(s_DA))\quad\forall s_DA;

Model testSecondDecision /all/;
Solve testSecondDecision maximising Profit using MIP;
