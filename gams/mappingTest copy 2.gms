Sets
	t_block / b1*b2 /
    t_hour / h1*h8 /   
    t_quarter / q1*q32 /
    map_quarter_hour(t_quarter, t_hour)
    map_quarter_block(t_quarter, t_block)
    map_hour_block(t_hour, t_block); 
    
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

Parameter
p_DA(t_hour)                    / h1 1, h2 15, h3 1, h4 1, h5 1, h6 1, h7 1, h8 1/
p_RL(t_block)   				/ b1 2, b2 17/
;
Variables
    obj "Zielfunktion"
;

Positive Variable
    q_DA(t_hour)   "Entscheidung auf Stundenebene"
    q_RA(t_quarter) "Entscheidung auf Viertelstundenebene"
	q_RL(t_block)
;

Scalar
storCap         /100/
parkCap         /100/
r               /100/
p_RA            /4/
a			   	/125/
;

Equation
 cost_eq
 marketCon_RLRA
 parkCap_con

 storageCap_con_RL
 storageCap_con_RA
 anschluss_con
 conRLr
;
 


cost_eq..                                                      obj =e=  sum(t_hour, p_DA(t_hour) * q_DA(t_hour)) + sum(t_quarter, p_RA * q_RA(t_quarter)) + sum(t_block, p_RL(t_block) * q_RL(t_block) * 4);
    
anschluss_con(t_quarter)..										a =g= sum(t_hour$map_quarter_hour(t_quarter, t_hour), q_DA(t_hour)) + ( q_RA(t_quarter) * 4 );
*das storage cap wird quasi magisch einfach einmal pro stunde auf 100 MWh aufgefüllt
storageCap_con_RL(t_block)..                                     q_RL(t_block) =l= storCap;
storageCap_con_RA(t_quarter)..                                   q_RA(t_quarter) =l= r/4;
parkCap_con(t_hour).. 										q_DA(t_hour) =l= parkCap;

marketCon_RLRA(t_quarter)..                                       q_RA(t_quarter) * 4 =g= sum(t_block$map_quarter_block(t_quarter, t_block), q_RL(t_block));
conRLr(t_quarter)..                                               q_RA(t_quarter) =l= r/4;

Model myModel /all/;
Solve myModel using lp maximizing obj;

