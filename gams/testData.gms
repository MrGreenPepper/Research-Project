Set
t       /t0*t360/
so       /so1*so5/
st       /st1*st5/
;

Parameters
posDemand(t)
negDemand(t)
monthAvgNegC(t)
monthAvgNegE(t)
monthAvgPosC(t)
monthAvgPosE(t)
regularMarketPrices(t)
* ist sum prop 1?
scenarioOneProp(so)                /so1 0.9, so2 0.8, so3 0.5, so4 0.2, so5 0.1/
scenarioOneFactor(so)              /so1 0.6, so2 0.8, so3 1, so4 1.2, so5 1.4/
scenarioTwoProp(st)                /st1 0.9, st2 0.8, st3 0.5, st4 0.2, st5 0.1/
scenarioTwoFactor(st)              /st1 0.6, st2 0.8, st3 1, st4 1.2, st5 1.4/
;



        


$onEmbeddedCode Connect:
- PandasExcelReader:
    file: testData.xlsx
    symbols:
      - name: negDemand
        range: negDemand!A1
        columnDimension: 0
        rowDimension: 1
      - name: posDemand
        range: posDemand!A1
        columnDimension: 0
        rowDimension: 1
- GAMSWriter:
    symbols:
      - name: negDemand
      - name: posDemand
$offEmbeddedCode

$onEmbeddedCode Connect:
- PandasExcelReader:
    file: GAMStest_regMarketPrice.xlsx
    symbols:
      - name: regularMarketPrices
        range: regMarketPrice!A1
        columnDimension: 0
        rowDimension: 1
- GAMSWriter:
    symbols:
      - name: regularMarketPrices
$offEmbeddedCode


*$call gdxxrw.exe testData.xlsx par=posDemand rng=posDemand!A2:B25 dim=1 cdim=0 rdim=1 log=posDemand.txt
*Parameter posDemand(t)
*$gdxIn testData.gdx
*$load posDemand
*$gdxIn;

*$call gdxxrw.exe testData.xlsx par=negDemand rng=negDemand!A2:B25 dim=1 cdim=0 rdim=1 log=negDemand.txt
*Parameter negDemand(t)
*$gdxIn testData.gdx
*$load negDemand
*$gdxIn;

$onEmbeddedCode Connect:
- PandasExcelReader:
    file: GAMStest_monthAvgNegC.xlsx
    symbols:
      - name: monthAvgNegC
        range: monthAvgNegC!B1
        columnDimension: 0
        rowDimension: 1
- GAMSWriter:
    symbols:
      - name: monthAvgNegC
$offEmbeddedCode

$onEmbeddedCode Connect:
- PandasExcelReader:
    file: GAMStest_monthAvgNegE.xlsx
    symbols:
      - name: monthAvgNegE
        range: monthAvgNegE!B1
        columnDimension: 0
        rowDimension: 1
- GAMSWriter:
    symbols:
      - name: monthAvgNegE
$offEmbeddedCode

$onEmbeddedCode Connect:
- PandasExcelReader:
    file: GAMStest_monthAvgPosC.xlsx
    symbols:
      - name: monthAvgPosC
        range: monthAvgPosC!B1
        columnDimension: 0
        rowDimension: 1
- GAMSWriter:
    symbols:
      - name: monthAvgPosC
$offEmbeddedCode

$onEmbeddedCode Connect:
- PandasExcelReader:
    file: GAMStest_monthAvgPosE.xlsx
    symbols:
      - name: monthAvgPosE
        range: monthAvgPosE!B1
        columnDimension: 0
        rowDimension: 1
- GAMSWriter:
    symbols:
      - name: monthAvgPosE
$offEmbeddedCode