#Correct values of MATLAB data analysis software
#Author: James Timotiwu
import os
import shutil 
from pandas import DataFrame, read_csv
import pandas as pd
import numpy as np

#open excel file with corrected vales
#correcteddf = pd.read_excel(os.path.join(os.getcwd(),'5psi test data_Corrected.xlsx'), sheetname = 'Summary')

#Read and insert files
def correctFiles():
    
    for i in range(6,21):
        runnum = str(i)
        if i < 10:
            runnum = '0' + str(i)
    
        #open and replace each file detail
        path = os.path.join(os.getcwd(),'5psi-' +
            runnum,'One_Frame_Segmentation_Particles_JM_analysis_5psi_0' +
            runnum + '.m')
    
        correcteddia = str(np.round(correcteddf['Tema Mean Diameter mm'][1+i], 4))
        correctedv = str(np.round(correcteddf['Projectile velocity m/s'][1+i], 4))
        
        if os.path.isfile(path):
    
            scontent = open(path).read()
            scontent = scontent.replace('010615_Run_01_5psi','010615_Run_'+ runnum +
                    '_5psi', 1)  #RunNumber
            scontent = scontent.replace('Segmentation 5psi-01.xlsx', 'Segmentation 5psi-'+ runnum + '.xlsx', 1) #str1
            scontent = scontent.replace('5psi_1.tif', '5psi_' + str(i) + '.tif', 1) #imread file to read
            #replace diameter from excel sheet with real one and round to 4
            scontent = scontent.replace('2.2108', correcteddia, 1)
            #replace velocity round to 4
            scontent = scontent.replace('39.4172',correctedv, 1)
            #Write on original file
            matlabf = open(path, mode = 'w')
            #'w' is opening in truncate mode/overwrite
            matlabf.write(scontent)
            matlabf.close()
            chlog(path, runnum, correcteddia, correctedv) #log all parameters changed  

        cleanFolder(runnum)

#Fn name: chlog
#Use: Tracks changes among runs
def chlog(path, runnum, correcteddia, correctedv):

    print('Opening ... ' + path)
    print('Run Number: ' + runnum)
    print('Corrected TEMA Mean Diameter mm: ' + correcteddia)
    print('Corrected Projectile velocity m/s ' + correctedv)

#Fn name: cleanFolder
#Use: cleans the folder of the directory
def cleanFolder(runnum):

    dirname = os.path.join(os.getcwd(), '5psi-'+runnum)
    
    for root, dirs, files in os.walk(dirname):
        for d in dirs:
            for filename in os.listdir(os.path.join(root, d)):
                os.remove(os.path.join(root, d, filename))
        for f in files: 
            if f.startswith('Frame') or f.startswith('figure1') or f.startswith('Segmentation'):
                os.remove(os.path.join(dirname, f ))
    
    print('Dataset 5psi-'+runnum+' cleaned!')
    shutil.copy2(os.path.join(dirname, 'Copy_of_Segmentation 5psi-'+ runnum +
        '.xlsx'), os.path.join(dirname, 'Segmentation 5psi-' + runnum +
            '.xlsx')) 

def generateDir(psilevel):
    
    runnum = 0 

    for root, dirs, files in os.walk(os.getcwd(), str(psilevel)+'psi'):
        newdir = str(psilevel) + 'psi-' + str(runnum)

        for f in files:
            if f.startswith(str(psilevel) + 'psi') and f.endswith('.tiff'):
                os.makedirs(os.path.join(os.getcwd(),str(psilevel)+'psi',newdir),exist_ok=True)
                runnum += 1
        for fi in os.listdir(os.path.join(os.getcwd(), 'src')):
            shutil.copy2(os.path.join('src', fi),
                    os.path.join(os.getcwd(),str(psilevel)+'psi',newdir))

    print(runnum)
generateDir(9)


#correctFiles()

