Sets
    t_hour / h1*h2 /   
    t_quarter / q1*q8 / 
    map_quarter_hour(t_quarter, t_hour); 
    
Loop(t_hour, 
    Loop(t_quarter$(ord(t_quarter) > 4 * (ord(t_hour) - 1) and ord(t_quarter) <= 4 * ord(t_hour)), 
        map_quarter_hour(t_quarter, t_hour) = YES;
    );
);

Variables
    obj "Zielfunktion"
;

Positive Variable
    x_hour(t_hour)   "Entscheidung auf Stundenebene"
    x_quarter(t_quarter) "Entscheidung auf Viertelstundenebene"
;

Equation
 cost_eq
 quarter_def
 conx
 cony
;

quarter_def(t_quarter)..                                        x_quarter(t_quarter) =g= sum(t_hour$map_quarter_hour(t_quarter, t_hour), x_hour(t_hour));
cost_eq..                                                       obj =e= sum(t_hour, x_hour(t_hour)) + sum(t_quarter, x_quarter(t_quarter));
    
conx(t_hour).. x_hour(t_hour) =l= 150;
cony(t_quarter).. x_quarter(t_quarter) =l= 110;

Model myModel /all/;
Solve myModel using lp maximizing obj;





quarter_def(t_quarter)..                                        Q_outrRL_RA(t_quarter) =g= sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_out_RL(t_hour));
quarter_def(t_quarter)..                                        Q_inrRL_RA(t_quarter) =g= sum(t_hour$map_quarter_hour(t_quarter, t_hour), Q_in_RL(t_hour));