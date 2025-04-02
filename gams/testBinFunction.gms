Set t /t1*t3/;

Parameter
callProb(t)                 /t1 0.2, t2 0.2, t3 0.2/

;


Positive Variable
q(t)
;

Variable
Profit
w(t)
save(t)
;

Equation
uplimit

profiteq
test
saveeq
;

uplimit(t)..        q(t) =l= 100;
test(t)..           w(t) =e= callProb(t) - callProb(t-1)* (1-(1/((q(t-1)*100000)+1)));
saveeq(t)..            save(t) =e= 1-(1-(1/((q(t)*100000)+1)));

profiteq..           Profit =e= sum(t,q(t) * w(t));


Model asdf /all/;
Solve asdf maximizing Profit using NLP;

display w.l;

execute 'gdxxrw.exe test.gdx o=test.xlsx var=w.l log=log_test.txt'
Execute_unload 'test.gdx', w;