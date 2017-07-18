#
#
#Correct values of MATLAB data analysis software
#Author: James Timotiwu
#
#

import os
import shutil 
from pandas import DataFrame, read_csv
import pandas as pd
import numpy as np

#open excel file with corrected vales
#correcteddf = pd.read_excel(os.path.join(os.getcwd(),'5psi test data_Corrected.xlsx'), sheetname = 'Summary')

def load_dataf(psilevel, sheetname):
    
    return pd.read_excel(os.path.join(os.getcwd(), str(psilevel) + 'psi' ,
        str(psilevel) + 'psi test data.xlsx'), sheetname)

#Read and insert files
def correctFiles(psilevel, sheetname):
    
    for i in range(1,21):
        runnum = str(i)
        if i < 10:
            runnum = '0' + str(i)
    
        #open and replace each file detail
        path = os.path.join(os.getcwd(),str(psilevel)+'psi', str(psilevel)+'psi-' +
            runnum,'One_Frame_Segmentation_Particles_JM_analysis_'+str(psilevel)+'psi_0' +
            runnum + '.m')
    
        correcteddf = load_dataf(psilevel, sheetname)

        correcteddia = str(np.round(correcteddf['Tema Mean Diameter mm'][1+i], 4))
        correctedv = str(np.round(correcteddf['Projectile velocity m/s'][1+i], 4))
        
        if os.path.isfile(path):
    
            scontent = open(path).read()
            scontent = scontent.replace('010615_Run_01_5psi','010615_Run_'+
                    runnum +
                    '_'+str(psilevel)+'psi', 1)  #RunNumber
            scontent = scontent.replace('Segmentation 5psi-01.xlsx',
                    'Segmentationi '+str(psilevel)+'psi-'+ runnum + '.xlsx', 1) #str1
            scontent = scontent.replace('5psi_1.tif', str(psilevel)+'psi_' + str(i) + '.tif', 1) #imread file to read

            scontent = scontent.replace('5psi baseline.tif',
                    str(psilevel)+'psi_' + 'baseline.tif', 1) #imread file to read
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

        cleanFolder(runnum, psilevel)

#Fn name: chlog
#Use: Tracks changes among runs
def chlog(path, runnum, correcteddia, correctedv):

    print('Opening ... ' + path)
    print('Run Number: ' + runnum)
    print('Corrected TEMA Mean Diameter mm: ' + correcteddia)
    print('Corrected Projectile velocity m/s ' + correctedv)

#Fn name: cleanFolder
#Use: cleans the folder of the directory
def cleanFolder(runnum, psilevel):

    dirname = os.path.join(os.getcwd(),str(psilevel)+'psi', str(psilevel) + 'psi-'+runnum)
    
    for root, dirs, files in os.walk(dirname):
        for d in dirs:
            for filename in os.listdir(os.path.join(root, d)):
                os.remove(os.path.join(root, d, filename))

        for f in files: 
            if f.startswith('Frame') or f.startswith('figure1') or f.startswith('Segmentation'):
                os.remove(os.path.join(dirname, f ))
    
    print('Dataset '+str(psilevel)+'psi-'+runnum+' cleaned!')

    if os.path.isfile(os.path.join(dirname, 'Copy_of_Segmentation ' +
        str(psilevel)+'psi-'+ runnum + '.xlsx')) == False:
   
        copy_segmentation_file(psilevel, dirname, runnum) 

    shutil.copy2(os.path.join(dirname, 'Copy_of_Segmentation ' +
    str(psilevel)+'psi-'+ runnum +
        '.xlsx'), os.path.join(dirname, 'Segmentation '+str(psilevel) +'psi-' + runnum +
            '.xlsx')) 

def generate_dir(psilevel):
    
    dirname = os.path.join(os.getcwd(), str(psilevel)+'psi')

    for root, dirs, files in os.walk(dirname):

        runnum = 1
        start = str(psilevel) + 'psi_'
        end = '.tiff'
        newdir = str(psilevel) + 'psi_' + str(runnum)

        for f in files:

            if f.startswith('9psi_'):

                if f.endswith('baseline.tiff') or f.endswith('cal.tiff'):
                    continue

                runnum = f[f.find(start)+len(start):f.rfind(end)]

                if int(runnum) in range(0, 21):
                    fixednum = str(runnum)

                    if int(runnum) < 10:
                        fixednum = '0' + str(runnum)


                    newdir = str(psilevel) + 'psi-' + fixednum
                    os.mkdir(os.path.join(os.getcwd(),str(psilevel)+'psi',newdir))
                    copyfilesfromsrc(os.path.join(os.getcwd(),
                        str(psilevel)+'psi', newdir))
                    
                    #move image file
                    shutil.move(os.path.join(os.getcwd(),str(psilevel)+'psi',
                        f), os.path.join(os.getcwd(), str(psilevel) +'psi',
                            newdir))

                    #rename xlsx file
                    seg = 'Segmentation ' + str(psilevel) +'psi' + '-' + fixednum+'.xlsx'

                    os.rename(os.path.join(os.getcwd(),
                        str(psilevel)+'psi',newdir,'Segmentation 0psi-0.xlsx'),os.path.join(os.getcwd(),
                        str(psilevel)+'psi',newdir,seg))

                    #copy segmentation file
                    copy_segmentation_file(psilevel, os.path.join(os.getcwd(),
                        str(psilevel)+'psi'), fixednum)

                    mlab = 'One_Frame_Segmentation_Particles_JM_analysis_'+str(psilevel)+'psi_0'+fixednum+'.m'
                    #rename matlab file 
                    os.rename(os.path.join(os.getcwd(),
                        str(psilevel)+'psi',newdir,'One_Frame_Segmentation_Particles_JM_analysis_5psi_001.m'),os.path.join(os.getcwd(),
                        str(psilevel)+'psi',newdir,mlab))
                    
                    #copy baseline
                    shutil.copy2(os.path.join(os.getcwd(), str(psilevel) +
                    'psi', str(psilevel) + 'psi_baseline.tiff'),
                    os.path.join(os.getcwd(), str(psilevel) + 'psi', newdir))

def copyfilesfromsrc(target):

    for fi in os.listdir(os.path.join(os.getcwd(), 'src')):
        shutil.copy2(os.path.join('src', fi),
        os.path.join(target))

def copy_segmentation_file(psilevel, dirname, fixednum):
    seg = 'Segmentation ' + str(psilevel) +'psi' + '-' + fixednum+'.xlsx'
    newdir = str(psilevel) + 'psi-' + fixednum

    shutil.copy2(os.path.join(dirname,newdir,seg),os.path.join(dirname,newdir, 'Copy_of_'+seg))

generate_dir(9)
correctFiles(9, '9psi Summary')
#generate_dir(9)
        


