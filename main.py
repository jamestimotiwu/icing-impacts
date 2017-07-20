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

# Fn name: load_dataf
# load data frame for corrected velocity data
def load_dataf(psilevel, sheetname):

    #load correct velocity and particle size data based on psi
    xlsxname = str(psilevel) + 'psi test data.xlsx' 
    #check for corrected data
    if os.path.isfile(os.path.join(os.getcwd(), str(psilevel) + 'psi' ,(str(psilevel) + 'psi test data_Corrected.xlsx'))):
        xlsxname = str(psilevel) + 'psi test data_Corrected.xlsx'
    #full path of data
    path = os.path.join(os.getcwd(), str(psilevel) + 'psi' ,xlsxname)

    return pd.read_excel(path, sheetname)

#Read and insert files
def correctFiles(psilevel, sheetname): 
   
    for i in range(1,27): 
        runnum = str(i) #experiment case number
        correcteddf = load_dataf(psilevel, sheetname) #loading full data frame with corrected velocity
        
        #catch index error when index goes beyond # files
        try:
            correcteddia = str(np.round(correcteddf['Tema Mean Diameter mm'][1+i], 4)) 
            correctedv = str(np.round(correcteddf['Projectile velocity m/s'][1+i], 4)) 

        except IndexError:
            break

        if i < 10: 
            runnum = '0' + str(i) 
     
        #open and replace each file detail 
        path = os.path.join(os.getcwd(),str(psilevel)+'psi', str(psilevel)+'psi-' + 
            runnum,'One_Frame_Segmentation_Particles_JM_analysis_'+str(psilevel)+'psi_0' + 
            runnum + '.m') 
         
        if os.path.isfile(path): 
            
            img_ext = '.tiff'

            scontent = open(path).read() 
            scontent = scontent.replace('010615_Run_01_5psi','010615_Run_'+ 
                    runnum + 
                    '_'+str(psilevel)+'psi', 1)  #RunNumber 
            scontent = scontent.replace('Segmentation 5psi-01.xlsx', 
                    'Segmentation '+str(psilevel)+'psi-'+ runnum + '.xlsx', 1) #str1 
            scontent = scontent.replace('5psi_1.tif', str(psilevel)+'psi_' +
                    str(i) + img_ext, 1) #imread file to read 

            scontent = scontent.replace('5psi baseline.tif', 
                    str(psilevel)+'psi_' + 'baseline' + img_ext, 1) #imread file to read 
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
    
    chlogname = os.path.join(os.getcwd(), 'Data Set Modification Log.txt')

    if os.path.isfile(chlogname) == False:
        open(chlogname, mode='w')

    with open(chlogname, 'a') as log:
        log_info = "\nOpening ... " + path + "\n" + "Run Number: " + runnum + "\n"+ "Corrected TEMA Mean Diameter mm: " + correcteddia + "\n" + "Corrected Projectile velocity m/s " + correctedv
        print(log_info)
        log.write(log_info)

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

    try:

        shutil.copy2(os.path.join(dirname, 'Copy_of_Segmentation ' +
        str(psilevel)+'psi-'+ runnum +
        '.xlsx'), os.path.join(dirname, 'Segmentation '+str(psilevel) +'psi-' +
        runnum + '.xlsx'))

    except FileNotFoundError:
        pass

def hist_dir(path):
    
    os.mkdir(os.path.join(path, '6-Segmentation-Histograms for Each Frame'))
    os.mkdir(os.path.join(path, '7-Segmentation-Original Movie Frames Images'))
    os.mkdir(os.path.join(path, '8-Segmentation-Movie Frames Thresholded Images'))

# Fn name: generate_dir
# Use: generates entire directories based on tiff file
def generate_dir(psilevel):
    
    dirname = os.path.join(os.getcwd(), str(psilevel)+'psi')

    for root, dirs, files in os.walk(dirname):

        runnum = 1
        start = str(psilevel) + 'psi_'
        end = '.tiff'
        newdir = str(psilevel) + 'psi_' + str(runnum)

        for f in files:

            if f.startswith(str(psilevel)+'psi_'):

                if f.endswith('baseline.tiff') or f.endswith('cal.tiff'):
                    continue

                runnum = f[f.find(start)+len(start):f.rfind(end)]

                try: 
                    checkruninrange = int(runnum) in range (0, 30)

                #can use suppress
                except ValueError:
                    continue

                if checkruninrange:
                    fixednum = str(runnum)

                    if int(runnum) < 10:
                        fixednum = '0' + str(runnum)

                    newdir = str(psilevel) + 'psi-' + fixednum

                    os.mkdir(os.path.join(os.getcwd(),str(psilevel)+'psi',newdir))
                    hist_dir(os.path.join(os.getcwd(),str(psilevel)+'psi',newdir))
                    copyfilesfromsrc(os.path.join(os.getcwd(),
                        str(psilevel)+'psi', newdir), psilevel, newdir,
                        fixednum, f)
                    
                    copy_segmentation_file(psilevel, os.path.join(os.getcwd(),
                    str(psilevel)+'psi'), fixednum)

# Fn name: copyfilesfromsrc
# Use: copies files from source
def copyfilesfromsrc(target, psilevel, newdir, fixednum, filename):

    seg = 'Segmentation ' + str(psilevel) +'psi' + '-' + fixednum+'.xlsx'
    mlab = 'One_Frame_Segmentation_Particles_JM_analysis_'+str(psilevel)+'psi_0'+fixednum+'.m'

    for fi in os.listdir(os.path.join(os.getcwd(), 'src')):
        shutil.copy2(os.path.join('src', fi),
        os.path.join(target))

    #move image file
    shutil.move(os.path.join(os.getcwd(),str(psilevel)+'psi',
    filename), os.path.join(os.getcwd(), str(psilevel) +'psi',
    newdir))

    #rename xlsx file
    os.rename(os.path.join(os.getcwd(),
    str(psilevel)+'psi',newdir,'Segmentation 0psi-0.xlsx'),os.path.join(os.getcwd(),
    str(psilevel)+'psi',newdir,seg))

    #rename matlab file 
    os.rename(os.path.join(os.getcwd(),
    str(psilevel)+'psi',newdir,'One_Frame_Segmentation_Particles_JM_analysis_5psi_001.m'),os.path.join(os.getcwd(),
    str(psilevel)+'psi',newdir,mlab))
                    
    #copy baseline
    try:
        shutil.copy2(os.path.join(os.getcwd(), str(psilevel) +
        'psi', str(psilevel) + 'psi_baseline.tiff'),
        os.path.join(os.getcwd(), str(psilevel) + 'psi', newdir))

    except FileNotFoundError:
        print('Baseline file not found at '+ str(psilevel) +'psi')
        pass

# Fn name: copy_segmentation_file
# Creates a copy of the segmentation excel file
def copy_segmentation_file(psilevel, dirname, fixednum):

    try:
        seg = 'Segmentation ' + str(psilevel) +'psi' + '-' + fixednum+'.xlsx'
        newdir = str(psilevel) + 'psi-' + fixednum

        shutil.copy2(os.path.join(dirname,newdir,seg),os.path.join(dirname,newdir, 'Copy_of_'+seg))

    except FileNotFoundError:
        pass

#generate_dir(3)
#correctFiles(3, 'Summary')

for i in range(1,21):

    if i < 10: 
        runnum = '0' + str(i) 
    cleanFolder(runnum, '20')

#generate_dir(7)
#correctFiles(7, '7psi summary')
#
#generate_dir(9)
#correctFiles(9, '9psi Summary')
#
#generate_dir(11)
#correctFiles(11, '11psiSummary')
#
#generate_dir(13)
#correctFiles(13, '13psiSummary')
#
#generate_dir(15)
#correctFiles(15, '15psiSummary')
#
#generate_dir(17)
#correctFiles(17, '17 summary')

#generate_dir(9)
        


