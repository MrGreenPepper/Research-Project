Sets
    t_hour / h1*h2 /   
    t_quarter / q1*q8 /
    sRL           /sRL1*sRL3/
    sRA           /sRA1*sRA3/
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
    x_hour(t_hour, sRL)   "Entscheidung auf Stundenebene"
    x_quarter(t_quarter, sRA) "Entscheidung auf Viertelstundenebene"
;

Equation
 cost_eq
 quarter_def
 conx
 cony
;

quarter_def(t_quarter)..                                        sum(sRA, x_quarter(t_quarter, sRA)) =g= sum((sRL, (t_hour$map_quarter_hour(t_quarter, t_hour))), x_hour(t_hour, sRL));
*sum(t_hour$map_quarter_hour(t_quarter, t_hour) --> ist nur für eine stunde wahr --> also aufsummierung über 1
cost_eq..                                                       obj =e= sum((t_hour, sRL), x_hour(t_hour, sRL)) + sum((t_quarter, sRA), x_quarter(t_quarter, sRA));
    
conx(t_hour)..                                             sum(sRL, x_hour(t_hour, sRL)) =l= 150;
cony(t_quarter)..                                          sum(sRA, x_quarter(t_quarter, sRA)) =l= 110;

Model myModel /all/;
Solve myModel using lp maximizing obj;