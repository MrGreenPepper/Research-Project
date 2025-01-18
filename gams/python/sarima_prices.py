import pandas as pd
from os import listdir
from os.path import isfile, join

datadir = "./data/"
onlyfiles = [f for f in listdir(datadir) if isfile(join(datadir, f))]

energyFiles = []
capacityFiles = []
test = onlyfiles[0].find('capacity')
for file in onlyfiles:
	if (file.find('CAPACITY') > 0):
		capacityFiles.append(file)

	if (file.find('ENERGY') > 0):
		energyFiles.append(file)


energyData = pd.DataFrame()
energyDataList = []
for efile in energyFiles:
	filePath = datadir + efile
	importData = pd.read_excel(filePath, sheet_name=None)
	test = next(iter(importData.values()))
	energyDataList.append(test)
	
energyData = pd.concat(energyDataList,axis=0, ignore_index= True)

capacityData = pd.DataFrame()
capacityDataList = []
for cFile in capacityFiles:
	filePath = datadir + cFile
	importData = pd.read_excel(filePath, sheet_name=None)
	test = next(iter(importData.values()))
	capacityDataList.append(test)
	
capacityData = pd.concat(capacityDataList,axis=0, ignore_index= True)

print()