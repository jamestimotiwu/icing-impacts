import os
import sys
from pandas import DataFrame, read_csv
import pandas as pd
import numpy as np

correcteddf = pd.read_excel(os.path.join(os.getcwd(),'5psi test data_Corrected.xlsx'), sheetname = 'Summary')

#Read and insert files
for i in range(2,20):
    if i < 10:
        matlabf = open(os.path.join(os.getcwd(),'5psi-0' +
            str(i),'One_Frame_Segmentation_Particles_JM_analysis_5psi_00' +
            str(i) +'.m'), 'w')
        #'w' is opening in truncate mode/overwrite
        
        scontent = open(os.path.join(os.getcwd(),'5psi-0' +
            str(i),'One_Frame_Segmentation_Particles_JM_analysis_5psi_00' +
            str(i) + '.m')).read()
        scontent = scontent.replace('010615_Run_01_5psi','010615_Run_0'+ str(i) + '_5psi', 1)
        #RunNumber
        scontent = scontent.replace('Segmentation 5psi-01.xlsx', 'Segmentation 5psi-0'+ str(i) + '.xlsx', 1) #str1
        scontent = scontent.replace('5psi_1.tif', '5psi_' + str(i) + '.tif', 1) #imread file to read
        scontent = scontent.replace('2.2108', str(np.round(correcteddf['Tema Mean Diameter mm'][1+i], 4)), 1)
        scontent = scontent.replace('39.4172',str(np.round(correcteddf['Projectile velocity m/s'][1+i], 4)), 1)
        matlabf.write(scontent)
        matlabf.close()
    else:
        matlabf = open(os.path.join(os.getcwd(),'5psi-' +
            str(i),'One_Frame_Segmentation_Particles_JM_analysis_5psi_0' +
            str(i) +'.m'), 'w')
        #'w' is opening in truncate mode/overwrite
        
        scontent = open(os.path.join(os.getcwd(),'5psi-' +
            str(i),'One_Frame_Segmentation_Particles_JM_analysis_5psi_0' +
            str(i) + '.m')).read()
        scontent = scontent.replace('010615_Run_1_5psi','010615_Run_'+ str(i) + '_5psi', 1)
        #RunNumber
        scontent = scontent.replace('Segmentation 5psi-1.xlsx', 'Segmentation 5psi-'+ str(i) + '.xlsx', 1) #str1
        scontent = scontent.replace('5psi_1.tif', '5psi_' + str(i) + '.tif', 1) #imread file to read
        scontent = scontent.replace('2.2108', str(np.round(correcteddf['Tema Mean Diameter mm'][1+i], 4)), 1)
        scontent = scontent.replace('39.4172',str(np.round(correcteddf['Projectile velocity m/s'][1+i], 4)), 1)
        matlabf.write(scontent)
        matlabf.close()




#segmentationcontent.find('')
#while True:
#    s = 'RunNumber'
#    if s == "":
#        continue
#    if s in split:
#        print("Matched")
#        break
#    else:
#        print("No such string found, try")
#        continue
#matlabf.close()


