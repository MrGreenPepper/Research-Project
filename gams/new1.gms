Set
sDA             /sDA1*sDA3/
sRT             /sRT1*sRT3/
t               /t1*t3/
;


Parameter
p_DA(sDA)               /sDA1 90, sDA2 100, sDA3 1100/
prob_DA(sDA)            /sDA1 0.2, sDA2 0.5, sDA3 0.3/
bid_DA(t)               /t1 90, t2 100, t3 110/
Variable
Ertrag
;

Positive Variable
X_DA(t, sDA)
Q_DA(t, sDA)
stor_state
abc(t)
;

Binary Variables
b_DA_accepted(t, sDA)
B_P_DA
B_Q_DA
;

Scalar
Cap             /100/
rate            /100/
reload          /50/
M               /1000000000000000/
;

Equations
ErtragQ
wahl1

lin1
lin2
lin3

bidDA_con1
bidDA_con2

stor1
stor2
stor_state1
stor_state2
abc_con

;

ErtragQ..                   Ertrag =e= sum(t, sum(sDA,  p_DA(sDA) * prob_DA(sDA) * Q_DA(t, sDA)));
wahl1..                     sum(sDA, B_P_DA(sDA)) =l= 1;

lin1(t, sDA)..                 X_DA(t, sDA) =l= B_Q_DA(t, sDA) * rate;
lin2(t, sDA)..                 Q_DA(t, sDA) - X_DA(t, sDA) =g= (1-B_Q_DA(t, sDA)) * rate;
lin3(t, sDA)..                 Q_DA(t, sDA) - X_DA(t, sDA) =g= 0;


bidDA_con1(t,sDA)..         bid_DA(t) =l= p_DA(sDA) + M * B_Q_DA(t, sDA);
bidDA_con2(t,sDA)..         bid_DA(t) =g= p_DA(sDA) - M * (1- B_Q_DA(t, sDA));

stor1(t)..                      sum(sDA, Q_DA(t, sDA)) =l= rate;
stor2(t)..                      sum(sDA, Q_DA(t, sDA)) =g= 0;
stor_state1(t)..              stor_state(t) =l= Cap;
stor_state2(t)..              stor_state(t+1) =e= stor_state(t) - sum(sDA, X_DA(t, sDA)) + abc(t);
abc_con(t)..                   abc(t) =l= reload;
Model Demo / all /;
solve Demo maximising Ertrag using MIP;