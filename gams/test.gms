Set i 'canning plants', j 'markets';

Parameter d(i<,j<)  'distance in thousands of miles'
          a(i)      'capacity of plant i in cases'
          b(j)      'demand at market j in cases';

$onEmbeddedCode Connect:
- ExcelReader:
    file: input.xlsx
    symbols:
      - name: d
        range: distance!A1
      - name: a
        range: capacity!A1
        columnDimension: 0
      - name: b
        range: demand!A1
        rowDimension: 0
- GAMSWriter:
    symbols: all
$offEmbeddedCode

Scalar f 'freight in dollars per case per thousand miles' / 90 /;

Parameter c(i,j) 'transport cost in thousands of dollars per case';
c(i,j) = f*d(i,j)/1000;

Variable
   x(i,j) 'shipment quantities in cases'
   z      'total transportation costs in thousands of dollars';

Positive Variable x;

Equation
   cost      'define objective function'
   supply(i) 'observe supply limit at plant i'
   demand(j) 'satisfy demand at market j';

cost..      z =e= sum((i,j), c(i,j)*x(i,j));

supply(i).. sum(j, x(i,j)) =l= a(i);

demand(j).. sum(i, x(i,j)) =g= b(j);

Model transport / all /;

solve transport using lp minimizing z;

display x.l, x.m;