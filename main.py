import os
import sys
from pandas import DataFrame, read_csv
import pandas as pd
import numpy as np

#open excel file with corrected vales
correcteddf = pd.read_excel(os.path.join(os.getcwd(),'5psi test data_Corrected.xlsx'), sheetname = 'Summary')

#Read and insert files
for i in range(2,21):
    runnum = str(i)
    if i < 10:
        runnum = '0' + str(i)

    #open and replace each file detail
    path = os.path.join(os.getcwd(),'5psi-' +
        runnum,'One_Frame_Segmentation_Particles_JM_analysis_5psi_0' +
        runnum + '.m')

    if os.path.isfile(path):
        scontent = open(path).read()
        print('Opening ... ' + path)
        scontent = scontent.replace('010615_Run_01_5psi','010615_Run_'+ runnum +
                '_5psi', 1)  #RunNumber
        print('Run Number: ' + runnum)
        scontent = scontent.replace('Segmentation 5psi-01.xlsx', 'Segmentation 5psi-'+ runnum + '.xlsx', 1) #str1
        scontent = scontent.replace('5psi_1.tif', '5psi_' + str(i) + '.tif', 1) #imread file to read
        #replace diameter from excel sheet with real one and round to 4
        correcteddia = str(np.round(correcteddf['Tema Mean Diameter mm'][1+i], 4))
        print('Corrected TEMA Mean Diameter mm: ' + correcteddia)
        scontent = scontent.replace('2.2108', correcteddia, 1)
        correctedv = str(np.round(correcteddf['Projectile velocity m/s'][1+i], 4))
        print('Corrected Projectile velocity m/s ' + correctedv)
        #replace velocity round to 4
        scontent = scontent.replace('39.4172',correctedv, 1)
        
        #Write on original file
        matlabf = open(os.path.join(os.getcwd(),'5psi-' +
            runnum,'One_Frame_Segmentation_Particles_JM_analysis_5psi_0' +
            runnum  +'.m'), mode = 'w')
        #'w' is opening in truncate mode/overwrite
        matlabf.write(scontent)
        matlabf.close()

