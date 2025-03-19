Sets
s_in_RL         /s_in_RL1*s_in_RL3/
s_out_RL            /s_out_RL1*s_out_RL3/
s_DA            /s_DA1*s_DA3/
s_in_RA         /s_in_RA1*s_in_RA3/
s_out_RA            /s_out_RA1*s_out_RA3/
;

Scalars
a           /150/
r           /100/
;

Parameters
omega_RL_in(t, s_in_RL)                        /s_in_RL1 0.7, s_in_RL2 0.5, s_in_RL3 0.3/
omega_RL_out(t, s_out_RL)                      /s_out_RL1 0.7, s_out_RL2 0.5, s_out_RL3 0.3/
omega_DA(t, s_DA)                              /s_DA1 0.7, s_DA2 0.5, s_DA3 0.3/
omega_RA_in(t, s_in_RA)                         /s_in_RA1 0.7, s_in_RA2 0.5, s_in_RA3 0.3/
omega_RA_out(t, s_out_RA)                      /s_out_RA1 0.7, s_out_RA2 0.5, s_out_RA3 0.3/
p_in_RL(t, s_in_RL)                            /s_in_RL1 90, s_in_RL2 100, s_in_RL3 110/
p_out_RL(t, s_out_RL)                          /s_out_RL1 90, s_out_RL2 100, s_out_RL3 110/
p_DA(t, s_DA)                                  /s_DA1 90, s_DA2 100, s_DA3 110/
p_in_RA(t, s_in_RA)                             /s_in_RA1 90, s_in_RA2 100, s_in_RA3 110/
p_out_RA(t, s_out_RA)                          /s_out_RA1 90, s_out_RA2 100, s_out_RA3 110/
;

Variables
Profit
;
Positive Variables
* accepted  RL\ in \ out:
Q_in_RL(t, s_in_RL)
Q_out_RL(t, s_out_RL)
Q_rRL_DA(t, s_DA)
Q_outrRLDA_RA(t, s_out_RA)
Q_inrRLDA_RA(t, s_in_RA)
Q_outrRL_RA(t, s_out_RA)
Q_inrRL_RA(t, s_in_RA)

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
;
 

*Obj function:
profitEQ..      Profit  =e=
* accepted  RL\ in \ out:
                sum(s_out_RL,sum(s_in_RL, (omega_RL_in(s_in_RL)*omega_RL_out(s_out_RL))   *(
                        (Q_in_RL(t, s_in_RL) *p_in_RL(t, s_in_RL)  + Q_out_RL(t, s_out_RL) * p_out_RL(s_out_RL))
                        + sum(s_DA, omega_DA(t, s_DA)   *(
                            Q_rRL_DA(t, s_DA) * p_DA(t, s_DA) 
                            + sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA) * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                            + sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))
                        + sum(s_DA, (1-omega_DA(t, s_DA))  *(
                            sum(s_in_RA, Q_inrRL_RA(t, s_in_RA) * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                            + sum(s_out_RA, Q_outrRL_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA)))))))
*accepted RL in     \ declined out:
                +sum(s_out_RL,sum(s_in_RL,(omega_RL_in(s_in_RL)*(1-omega_RL_out(s_out_RL))   *(
                        (Q_in_RL(t, s_in_RL) * p_in_RL(s_in_RL))
                        + sum(s_DA, omega_DA(t, s_DA) *(
                            Q_rRL_DA(t, s_DA) * p_DA(t, s_DA) 
                            + sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA) * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                            + sum(s_out_RA, Q_outrDA_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))
                        + sum(s_DA,(1-omega_DA(t, s_DA)) 
                            * ( sum(s_in_RA, Q_inrRL_RA(t, s_in_RA) * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                            + sum(s_out_RA, Q_out_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))))))
*declined RL in\ accepted out:
                +sum(s_out_RL,sum(s_in_RL,(1-omega_RL_in(s_in_RL))*omega_RL_out(s_out_RL))   *(
                        (Q_out_RL(t, s_out_RL) * p_out_RL(s_out_RL))
                        + sum(s_DA, omega_DA(t, s_DA)  *(
                                (Q_rRL_DA(t, s_DA) * p_DA(t, s_DA))
                                + sum(s_in_RA, Q_inrDA_RA(t, s_in_RA)  * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                                + sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))
                        + sum(s_DA,(1-omega_DA(t, s_DA)) * (
                                sum(s_in_RA, Q_in_RA(t, s_in_RA)  * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                                + sum(s_out_RA, Q_outrRL_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))))
*declined RL in\ out:
                +sum(s_out_RL,sum(s_in_RL, (1-(omega_RL_in(s_in_RL)*omega_RL_out(s_out_RL)))    *(
                        sum(s_DA, omega_DA(t, s_DA)   *(
                                Q_DA(t, s_DA) * p_DA(t, s_DA) 
                                + sum(s_in_RA, Q_inrDA_RA(t, s_in_RA)  * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                                + sum(s_out_RA, Q_outrDA_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA))))
                        + sum(s_DA,(1-omega_DA(t, s_DA)) * (
                                sum(s_in_RA, Q_in_RA(t, s_in_RA)  * p_in_RA(t, s_in_RA)  * omega_RA_in(t, s_in_RA))
                                + sum(s_out_RA, Q_out_RA(t, s_out_RA) * p_out_RA(t, s_out_RA) * omega_RA_out(t, s_out_RA)))))));
 


 
*   Nebenbedingungen

*Anschlusspunkt:
conConst_Q_outrRLDA_RA.. 			a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) +sum(s_DA, Q_rRL_DA(t, s_DA));
conConst_Q_outrDA_RA..	 			a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_outrDA_RA(t, s_out_RA)) +sum(s_DA, Q_DA(t, s_DA));
conConst_Q_out_RA..		 			a + sum(s_in_RA, Q_in_RA(t, s_in_RA)) =g= sum(s_out_RA, Q_out_RA(t, s_out_RA));
*Batterie Restriktionen:
storCon_Q_out_RL..		 			sum(s_out_RL, Q_out_RL(t, s_out_RL)) 		=l= r;
storCon_Q_in_RL..		 			sum(s_in_RL, Q_in_RL(t, s_in_RL)) 			=l= r;
storCon_Q_out_RA..		 			sum(s_out_RA, Q_out_RA(t, s_out_RA)) 		=l= r;
storCon_Q_in_RA..		 			sum(s_in_RA, Q_in_RA(t, s_in_RA)) 			=l= r;
storCon_Q_outrRL_RA..	 			sum(s_out_RA, Q_outrRL_RA(t, s_out_RA)) 	=l= r;
storCon_Q_inrRL_RA..		 	 	sum(s_in_RA, Q_inrRL_RA(t, s_in_RA)) 		=l= r;
storCon_Q_outrDA_RA..	 			sum(s_out_RA, Q_outrDA_RA(t, s_out_RA)) 	=l= r;
storCon_Q_inrDA_RA..	 			sum(s_in_RA, Q_inrDA_RA(t, s_in_RA)) 		=l= r;
storCon_Q_outrRLDA_RA..	 			sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) 	=l= r;
storCon_Q_inrRLDA_RA..	 			sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA)) 		=l= r;

*Park Restriktionen:
parkCon_Q_DA(t)..					sum(s_DA, Q_DA(t, s_DA)) =l= parkCap * parkProfile;
parkCon_Q_rRL_DA(t)..				sum(s_DA, Q_rRL_DA(t, s_DA)) =l= parkCap * parkProfile;

*Markt Restriktionen:
*	estricted RL
marketCon_Q_outrRL_RA.. 			sum(s_out_RA, Q_outrRL_RA(t, s_out_RA)) 	=g= sum(s_out_RL, Q_out_RL(t, s_out_RL));
marketCon_Q_inrRL_RA.. 				sum(s_in_RA, Q_inrRL_RA(t, s_in_RA)) 		=g= sum(s_in_RL, Q_in_RL(t, s_in_RL));
*	restricted RL&DA
marketCon_Q_outrRLDA_RA.. 			sum(s_out_RA, Q_outrRLDA_RA(t, s_out_RA)) 	=g= sum(s_out_RL, Q_out_RL(t, s_out_RL));
marketCon_Q_inrRLDA_RA.. 			sum(s_in_RA, Q_inrRLDA_RA(t, s_in_RA)) 		=g= sum(s_in_RL, Q_in_RL(t, s_in_RL));
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
*c_in_RL =l= p(t, s_in_RL) + M * B_in_RL(s_in_RL)\quad\forall s_in_RL;
*c_in_RL =g= p(t, s_in_RL) - M * (1 - B_in_RL(s_in_RL))\quad\forall s_in_RL;
*c_out_RL =l= p(t, s_out_RL) + M * B_out_RL(s_out_RL)\quad\forall s_out_RL;
*c_out_RL =g= p(t, s_out_RL) - M * (1 - B_out_RL(s_out_RL))\quad\forall s_out_RL;
*c_DA =l= p(t, s_DA) + M * B_DA(t, s_DA)\quad\forall s_DA;
*c_DA =g= p(t, s_DA) - M * (1 - B_DA(t, s_DA))\quad\forall s_DA;

Model testFirstDecision /all/;
Solve testFirstDecision maximising Profit using LP;
