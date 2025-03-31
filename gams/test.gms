Set t /t1*t100/;
Parameter
Coef(t)
dir(t)
;
scalar
switchFactor / 50 /;


Equation
uplimit
downlimit
;

uplimit(t)..        coef(t) =l= 100;
downlimit(t)..       coef(t) =g= -100;
* set the seed in some random way, based on the time
execseed = gmillisec(jnow);
coef("t1") = 0;
coef(t) = coef(t-1) + Round(Uniform(-50, 50)) + (switchFactor * coef(t-1));
dir(t) = 1$(coef(t) > 0) + (-1)$(coef(t) < 0);

display coef, dir;