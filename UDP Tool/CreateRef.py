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

## Aim of this... create a ref baseline for the behavior of the transducer, without any signal

with open(startingpoint, 'r') as echOpenLog:
	for line in echOpenLog:
		if (i==4):
			#print MegaLine
			Tableau.append(MegaLine)
			i=0
		if (i==0):
			line = line.split('\t')
			del line[0]
			del line[0]
			del line[0]
			del line[2]
			del line[2]
			del line[1]
			del line[-1]
			MegaLine = line
		else:
			line = line.split('\t')
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[0]
			del line[-1]
			MegaLine += line
		i=i+1

Tableau.append(MegaLine)
data = np.array(Tableau).astype(int)

PointsPerLine = len(data[0])
NbOfPoints = len(data)
print "Points per line: ", PointsPerLine, "\n"
print "Number of samples: ", NbOfPoints, "\n"

BaseLine = []
for x in range(PointsPerLine):
	tmp = 0
	for y in range(NbOfPoints):
		tmp += data[y][x]
	tmp = int(tmp/NbOfPoints)
	BaseLine.append(tmp)

targetFile = open("Baseline.conf", 'w')
for x in range(PointsPerLine):
	targetFile.write(str(BaseLine[x])+"\t")

print "Baseline.conf a ete cree avec succes"
