import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

import math


def remove_repetitions(df: pd.DataFrame) -> pd.DataFrame:
    """
    Entfernt wiederholte Werte in einem DataFrame, wenn sich jeder Wert 4-mal wiederholt.
    Beibehaltung nur jeder vierten Zeile.
    """
    return df.iloc[::4].reset_index(drop=True)


da_prices2023 = remove_repetitions(pd.read_excel('./data/da_prices2023.xlsx', sheet_name='Sheet1'))


def generateLine(dataSet, wMeanDay, wMeanWeek, wMeanMonth, meanFactor, fitFactor):
	monthLength = math.floor(dataSet.shape[0] / 12)
	weekLength = math.floor(dataSet.shape[0]  / 52)
	dayLength = math.floor(dataSet.shape[0]  / 365)


	loopStartPoint = monthLength
	loopEndPoint = dataSet.shape[0]

	forecast = []

	for h in range(loopStartPoint, loopEndPoint):
		currentHour = dataSet[h-1]
		trueValue = dataSet[h]
		dayBeforeHour = dataSet[h-dayLength]
		weekBeforeHour = dataSet[h-weekLength]
		monthBeforeHour = dataSet[h-monthLength]

		slopeDay = currentHour/dayBeforeHour
		slopeWeek = currentHour/weekBeforeHour
		slopeMonth = currentHour/monthBeforeHour

		forecast.append(hourValue(dayBeforeHour, slopeDay, slopeWeek, slopeMonth, wMeanDay, wMeanWeek, wMeanMonth, meanFactor, trueValue, fitFactor))

	return forecast


def hourValue(lastDaySameHour, slopeDay, slopeWeek, slopeMonth, wMeanDay, wMeanWeek, wMeanMonth, meanFactor, trueValue,  fitFactor):

	wMean = ((slopeDay * wMeanDay * lastDaySameHour) + (slopeWeek * wMeanWeek * lastDaySameHour) + (slopeMonth * wMeanMonth * lastDaySameHour))  
	dampDirection = np.sign(wMean - (lastDaySameHour +  slopeDay))
	rawPoint = lastDaySameHour + slopeDay
	dampedSlope =  meanFactor * (rawPoint / wMean) * dampDirection
	newValue = fitFactor * trueValue + (1-fitFactor) * (lastDaySameHour +  (slopeDay + dampedSlope))

	return newValue


line = generateLine(da_prices2023['Day-ahead (EUR/MWh)'], 2, 0.1, 0.05, 1.2, 0.9)

plt.plot(line)
plt.show()