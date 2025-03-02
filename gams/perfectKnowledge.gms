Set
s_RL_in         /s_RL_in1*s_RL_in3/
s_RL_out            /s_RL_out1*s_RL_out3/
s_DA            /s_DA1*s_DA3/
s_RA_in         /s_RA_in1*s_RA_in3/
s_RA_out            /s_RA_out1*s_RA_out3/
;

Scalar
*storage properties
r               /100/
stor_cap        /1000/
*port capacity
a               /150/
*usability
m               /10000000/
;

Variables
Profit_RL_in
Profit_RL_out
Profit_DA
Profit_RA_in
Profit_RA_out
Profit_RL
Profit_RA
Profit_G
;

Positive Variables
X_RL_in
X_RL_out
X_DA
X_RA_in
X_RA_out
Q_RL_in
Q_RL_out
Q_DA
Q_RA_in
Q_RA_out
;

Binary Variables
B_RL_in
B_RL_out
B_DA
B_RA_in
B_RA_out
;

Parameter
*forecast prices
p_RL_in(s_RL_in)                    /s_RL_in1 900, s_RL_in2 100, s_RL_in3 110/
p_RL_out(s_RL_out)                  /s_RL_out1 90, s_RL_out2 100, s_RL_out3 110/
p_DA(s_DA)                  /s_DA1 90, s_DA2 100, s_DA3 110/
p_RA_in(s_RA_in)                    /s_RA_in1 90, s_RA_in2 100, s_RA_in3 110/
p_RA_out(s_RA_out)                  /s_RA_out1 90, s_RA_out2 100, s_RA_out3 110/
*forecast probabilities
w_RL_in                             /s_RL_in1 0.3, s_RL_in2 0.5, s_RL_in3 0.20/
w_RL_out                                /s_RL_out1 0.3, s_RL_out2 0.5, s_RL_out3 0.20/
w_DA                                /s_DA1 0.3, s_DA2 0.5, s_DA3 0.20/
w_RA_in                             /s_RA_in1 0.3, s_RA_in2 0.5, s_RA_in3 0.20/
w_RA_out                                /s_RA_out1 0.3, s_RA_out2 0.5, s_RA_out3 0.20/
*market data - clearing prices
c_RL_in                             /s_RL_in1 100, s_RL_in2 100, s_RL_in3 100/                    
c_RL_out                                /s_RL_out1 100, s_RL_out2 100, s_RL_out3 100/                   
c_DA                                /s_DA1 100, s_DA2 100, s_DA3 100/
c_RA_in                             /s_RA_in1 100, s_RA_in2 100, s_RA_in3 100/
c_RA_out                                /s_RA_out1 100, s_RA_out2 100, s_RA_out3 100/
*storage properties
;

Equations
*profits
eq_profit_RL_in_
eq_profit_RL_out_
eq_profit_DA_
eq_profit_RA_in_
eq_profit_RA_out_
eq_profit_RL
eq_profit_RA
eq_profit_g

*general constraints
a_con

*NLP in NL constraints1
bq_RL_in_lin1
bq_RL_out_lin1
bq_DA1
bq_RA_in1
bq_RA_out1

*NLP in NL constraints2
bq_RL_in_lin2
bq_RL_out_lin2
bq_DA2
bq_RA_in2
bq_RA_out2

*NLP in NL constraints3
bq_RL_in_lin3
bq_RL_out_lin3
bq_DA3
bq_RA_in3
bq_RA_out3

*clearing prices
clearing_RL_in_up(s_RL_in)
clearing_RL_out_up(s_RL_out)
clearing_RA_in_up(s_RA_in)
clearing_RA_out_up(s_RA_out)
clearing_DA_up(s_DA)

clearing_RL_in_down(s_RL_in)
clearing_RL_out_down(s_RL_out)
clearing_RA_in_down(s_RA_in)
clearing_RA_out_down(s_RA_out)
clearing_DA_down(s_DA)

*storage const
store_RL_in1
store_RL_out1
store_RA_in1
store_RA_out1
store_DA1

store_RL_in2
store_RL_out2
store_RA_in2
store_RA_out2
store_DA2
;


eq_profit_RL_in_..                      Profit_RL_in =e= sum(s_RL_in, p_RL_in(s_RL_in) * Q_RL_in(s_RL_in) * w_RL_in(s_RL_in));
eq_profit_RL_out_..                     Profit_RL_out =e= sum(s_RL_out, p_RL_out(s_RL_out) * Q_RL_out(s_RL_out) * w_RL_out(s_RL_out));
eq_profit_DA_..                         Profit_DA =e= sum(s_DA, p_DA(s_DA) * X_DA(s_DA) * w_DA(s_DA));
eq_profit_RA_in_..                      Profit_RA_in =e= sum(s_RA_in, p_RA_in(s_RA_in) * X_RA_in(s_RA_in) * w_RA_in(s_RA_in));
eq_profit_RA_out_..                     Profit_RA_out =e= sum(s_RA_out, p_RA_out(s_RA_out) * X_RA_out(s_RA_out) * w_RA_out(s_RA_out));
eq_profit_RL..                          Profit_RL =e= profit_RL_in + profit_RL_out;
eq_profit_RA..                          Profit_RA =e= profit_RA_in + profit_RA_out;
eq_profit_g..                           Profit_G =e= profit_RL + profit_RA;

*general constraints
a_con..                                 a + sum(s_RA_in, X_RA_in(s_RA_in)) =g= sum(s_DA, X_DA(s_DA)) + sum(s_RA_out, X_RA_out(s_RA_out));

*NLP in NL constraints1
bq_RL_in_lin1(s_RL_in)..                X_RL_in(s_RL_in) =l= B_RL_in(s_RL_in) * r;
bq_RL_out_lin1(s_RL_out)..              X_RL_out(s_RL_out) =l= B_RL_out(s_RL_out) * r;
bq_RA_in1(s_RA_in)..                    X_RA_in(s_RA_in) =l= B_RA_in(s_RA_in) * r;
bq_RA_out1(s_RA_out)..                  X_RA_out(s_RA_out) =l= B_RA_out(s_RA_out) * r;
bq_DA1(s_DA)..                          X_DA(s_DA) =l= B_DA(s_DA) * r;

*NLP in NL constraints2
bq_RL_in_lin2(s_RL_in)..                Q_RL_in(s_RL_in) - X_RL_in(s_RL_in) =l= (1 -  B_RL_in(s_RL_in)) * r;
bq_RL_out_lin2(s_RL_out)..              Q_RL_out(s_RL_out) - X_RL_out(s_RL_out) =l= (1 - B_RL_out(s_RL_out)) * r;
bq_RA_in2(s_RA_in)..                    Q_RA_in(s_RA_in) - X_RA_in(s_RA_in)  =g= (1 - B_RA_in(s_RA_in)) * r;
bq_RA_out2(s_RA_out)..                  Q_RA_out(s_RA_out) - X_RA_out(s_RA_out)  =g= (1 - B_RA_out(s_RA_out)) * r;
bq_DA2(s_DA)..                          Q_DA(s_DA) - X_DA(s_DA)  =g= (1 - B_DA(s_DA)) * r;

*NLP in NL constraints3
bq_RL_in_lin3(s_RL_in)..                Q_RL_in(s_RL_in) - X_RL_in(s_RL_in) =g= 0; 
bq_RL_out_lin3(s_RL_out)..              Q_RL_out(s_RL_out) - X_RL_out(s_RL_out) =g= 0; 
bq_RA_in3(s_RA_in)..                    Q_RA_in(s_RA_in) - X_RA_in(s_RA_in) =g= 0; 
bq_RA_out3(s_RA_out)..                  Q_RA_out(s_RA_out) - X_RA_out(s_RA_out) =g= 0; 
bq_DA3(s_DA)..                          Q_DA(s_DA) - X_DA(s_DA) =g= 0; 

*clearing prices
clearing_RL_in_up(s_RL_in)..            c_RL_in(s_RL_in) =l= p_RL_in(s_RL_in) + m * B_RL_in(s_RL_in);
clearing_RL_out_up(s_RL_out)..          c_RL_out(s_RL_out) =l= p_RL_out(s_RL_out) + m * B_RL_out(s_RL_out);
clearing_RA_in_up(s_RA_in)..            c_RA_in(s_RA_in) =l= p_RA_in(s_RA_in) + m * B_RA_in(s_RA_in);
clearing_RA_out_up(s_RA_out)..          c_RA_out(s_RA_out) =l= p_RA_out(s_RA_out) + m * B_RA_out(s_RA_out);
clearing_DA_up(s_DA)..                  c_DA(s_DA) =l= p_DA(s_DA) + m * B_DA(s_DA);

clearing_RL_in_down(s_RL_in)..          c_RL_in(s_RL_in) =g= p_RL_in(s_RL_in) - m * (1 - B_RL_in(s_RL_in));
clearing_RL_out_down(s_RL_out)..        c_RL_out(s_RL_out) =g= p_RL_out(s_RL_out) - m * (1 - B_RL_out(s_RL_out));
clearing_RA_in_down(s_RA_in)..          c_RA_in(s_RA_in) =g= p_RA_in(s_RA_in) - m * (1 - B_RA_in(s_RA_in));
clearing_RA_out_down(s_RA_out)..        c_RA_out(s_RA_out) =g= p_RA_out(s_RA_out) - m * (1 - B_RA_out(s_RA_out));
clearing_DA_down(s_DA)..                c_DA(s_DA) =g= p_DA(s_DA) - m * (1 - B_DA(s_DA));

*storage const
store_RL_in1..                sum(s_RL_in, Q_RL_in(s_RL_in)) =g= 0;
store_RL_out1..              sum(s_RL_out, Q_RL_out(s_RL_out)) =g= 0;
store_RA_in1..                    sum(s_RA_in, X_RA_in(s_RA_in)) =g= 0;
store_RA_out1..                  sum(s_RA_out, X_RA_out(s_RA_out)) =g= 0;
store_DA1..                          sum(s_DA, X_DA(s_DA)) =g= 0;

store_RL_in2..                sum(s_RL_in, Q_RL_in(s_RL_in)) =l= r;
store_RL_out2..              sum(s_RL_out, Q_RL_out(s_RL_out)) =l= r;
store_RA_in2..                    sum(s_RA_in, X_RA_in(s_RA_in)) =l= r;
store_RA_out2..                  sum(s_RA_out, X_RA_out(s_RA_out)) =l= r;
store_DA2..                          sum(s_DA, X_DA(s_DA)) =l= r;
Model full_modell_test / all /;
Solve full_modell_test maximising profit_g using MIP;