Set

dimOne     /d1*d2/
dimTwo     /d1*d10/
;

Variable
profit
;

Positive Variable
x(dimOne, dimTwo)

;

Equations
profitEQ
con
;


profitEQ..                  profit =e= sum(dimOne, sum(dimTwo, x(dimOne, dimTwo)));
con(dimOne, dimTwo)..       x(dimOne, dimTwo) =l= 10;

Model myModel /all/;
Solve myModel using lp maximizing profit;