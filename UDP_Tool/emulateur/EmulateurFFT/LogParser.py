import sys
import numpy as np
from operator import itemgetter, attrgetter
import Image
from math import *

try:
    sys.argv[1]
except NameError:
    startingpoint = 'Missing an arg'
else:
    startingpoint = sys.argv[1]

i = 0
MegaLine = []
Tableau = []
BaseData = []


#with open("Baseline.conf", 'r') as BaselineFile:
#	for line in BaselineFile:
#		line = line.split('\t')
#		del line[-1]
#		BaseData = line
#BaseData = np.array(BaseData).astype(int)

print BaseData
print "\n\n"

with open(startingpoint, 'r') as echOpenLog:
	for line in echOpenLog:
		if (i==4):
			#print MegaLine
			Tableau.append(MegaLine)
			i=0
		if (i==0):
			line = line.split(' ')
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]			
			MegaLine = line
		else:
			line = line.split(' ')
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			MegaLine += line
		i=i+1

Tableau.append(MegaLine)

data = np.array(Tableau).astype(int)
col = 0

#SortedTable = data[np.argsort(data[:,col])]
SortedTable = data
print data
PointsPerLine = len(SortedTable[0])
NbOfPoints = len(SortedTable)
print PointsPerLine
print NbOfPoints

##work in progress	
	

size = (NbOfPoints,PointsPerLine)
print size
im = Image.new('RGB',size)
pix = im.load()

for i in range(size[0]):
    for j in range(size[1]):
	value = ((int(SortedTable[i][j])))
	SortedTable[i][j] = int(value **(1/1))

#SortedTable = SortedTable[np.argsort(SortedTable[:,col])]


for i in range(size[0]):
    for j in range(size[1]):
	value = int(SortedTable[i][j])
        pix[i,j] = (value,value,value) 

outfile = startingpoint +".png"
im.save(outfile)


	
