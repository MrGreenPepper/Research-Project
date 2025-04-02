Set t /t1*t100/;
Parameter
Coef(t)
dir(t)
;
scalar
switchFactor / 0.2 /;

Binary Variable
input(t)
;

Variable

Profit
;

Equation
uplimit
downlimit
profiteq
;

uplimit(t)..        coef(t) =l= 100;
downlimit(t)..       coef(t) =g= -100;
profiteq..           Profit =e= sum(t, coef(t)*input(t));
* set the seed in some random way, based on the time
execseed = gmillisec(jnow);
coef("t1") = 20;
coef(t) = coef(t-1) + Round(Uniform(-10, 10)) + (switchFactor * coef(t-1));
*dir(t) = 1$(coef(t) > 0) + (-1)$(coef(t) < 0);
dir(t) =1- (coef(t)/ (coef(t)+100));

Model asdf /all/;
Solve asdf maximizing Profit using MIP;

display coef, dir;

execute 'gdxxrw.exe test.gdx o=test.xlsx par=Coef.l log=log_test.txt'
Execute_unload 'test.gdx', Coef;