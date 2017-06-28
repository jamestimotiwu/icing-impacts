# Author: James Timotiwu
# Image Processing 
# For Icing Impacts Research

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#scikit-image imports
import skimage.io as io
from skimage import img_as_ubyte #to convert to 8-bit uint
from skimage.filters import threshold_otsu
#from pandas import DataFrame, read_csv
import imageadj as ij
#runNumber = '010615_Run_n_psi'
#thresholdUsed = 0.72156862745098
#connectivity = 8
#res = 48.46
#framerate = 96000
#DT = (1/framerate)*1000000
#P = 1
#outputdata = 'Segmentation psi.xlsx'
#histogram = '6-Segmentation-Histograms for Each Frame/Histogram'
#frame = '7-Segmentation-Original mOvie Frames Images/frame'
#movieframes = '8-Segmentation-Movie Frames Thresholded Images/frame'
#OutputTxt01 = 'Segmentation_and_Parameters_Output_01.txt'
#OutputTxt02 = 'Segmentation_and_Parameters_Output_02.txt'
#WedgeAngle = 45
#k=1?

def main():
    cropped = openimage(os.path.join(os.getcwd(), 'data', '5 psi Runs', '5psi_1.tiff'))
    #write cropped
#    Iadj = ij.imadjust(cropped, [0, 0.04], [])
    
    bgimg = openimage(os.path.join(os.getcwd(), 'data', '5 psi Runs', '5psi baseline.tiff')) 
#    bgadj = ij.imadjust(bgimg, [0, 0.04], [])
    isubt = cropped - bgimg
    
    isubt = np.invert(isubt)

    threshed = threshold_otsu(isubt)
    binary = isubt > threshed
    fig, axes = plt.subplots(ncols=3, figsize=(8, 2.5))
    ax = axes.ravel()
    ax[0] = plt.subplot(1, 3, 1, adjustable='box-forced')
    ax[1] = plt.subplot(1, 3, 2)
    ax[2] = plt.subplot(1, 3, 3, sharex=ax[0], sharey=ax[0], adjustable='box-forced')
    
    ax[0].imshow(isubt, cmap=plt.cm.gray)
    ax[0].set_title('Original')
    ax[0].axis('off')
    
    ax[1].hist(isubt.ravel(), bins=256)
    ax[1].set_title('Histogram')
    ax[1].axvline(threshe, color='r')
    
    ax[2].imshow(binary, cmap=plt.cm.gray)
    ax[2].set_title('Thresholded')
    ax[2].axis('off')

    plt.show()
#    plt.imshow(cropped)
#    plt.show()

#Read Image, Crop, Convert to I8
def openimage(image):
    I8 = img_as_ubyte(io.imread(image)) #Image as UINT8
    return I8[1:4380, 1:6250] #Crop Image [1 1 6250 4380]
    #imwrite(I8, '01-18 Original_Cropped.tif', 'compression', 'none')


#Brightness Adjust Image
#I = imadjust(I, [0 0.04], []); #Brightness Adj? Save as I2 here as original
#imwrite brightness adj

#imread Baseline.tif, Crop, Adjust Brightness, write

#subtract I8 and Background imsubtract(I, Background), convert to I8, write
#imwrite(I8, '05-I8 After Crop-ImAdj-BkgndSubt.tif', 'compression', 'none')

#InvertIm(I) to get inverted image, convert to I8, write as '06-I8 After Crop
#-ImAdj-BkgndSubt-Invert.tif'

#DO thresholding, level = graythresh(I) - Otsu to determine threshold number, =
#to thresholdused = level

#DO segmentation, I = im2bw(I, level<- threshold used), imwrite as '07-I After
#Crop-ImAdj-BkgndSubt-Thresh.tif'

#Use I2 as Ior, invert final segmented I and write as '08-bwf Ready for
#Segmentation.tif'

#cc = bwconncomp(bw5, connectivity) to find objects using a connectivity of 8?
#r = cc.NumObjects to find number of framgents, print r
main()
