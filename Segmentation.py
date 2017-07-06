# Author: James Timotiwu
# Image Processing 
# For Icing Impacts Research

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button, RadioButtons
#scikit-image imports
import skimage.util as skutil
import skimage.io as io
import skimage.exposure as expo
from skimage import img_as_ubyte #to convert to 8-bit uint
from skimage.filters import threshold_otsu
#from pandas import DataFrame, read_csv
#import imageadj as ij
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

#Main definition for program
def main():


    cropped = openimage(os.path.join(os.getcwd(), 'data', '5 psi Runs', '5psi_1.tiff'))
   #write cropped
   
#Brightness Adjust Image
#I = imadjust(I, [0 0.04], []); #Brightness Adj? Save as I2 here as original
#imwrite brightness adj
#    Iadj = ij.imadjust(cropped)

    p1, p2 = np.percentile(cropped, (97, 99.994))
    Iadj = expo.rescale_intensity(cropped, in_range=(p1,p2))
#    Iadj = expo.rescale_intensity(cropped)
#    I8 = img_as_ubyte(cropped)
#imread Baseline.tif, Crop, Adjust Brightness, write

    bgimg = openimage(os.path.join(os.getcwd(), 'data', '5 psi Runs', '5psi baseline.tiff')) 
#    bgadj = ij.imadjust(bgimg)
    p3, p4 = np.percentile(bgimg, (0,100))
    bgadj = expo.rescale_intensity(bgimg, in_range = (p1,p2))

#    b8 = img_as_ubyte(bgimg)

#    io.imsave(os.path.join(os.getcwd(), 'data', '5 psi Runs', '5psi_ADJ.tif'),

#    io.imsave(os.path.join(os.getcwd(), 'data', '5 psi Runs', 'BG_ADJ.tif'), b8)
#    B8 = img_as_ubyte(bgadj)
#subtract I8 and Background imsubtract(I, Background), convert to I8, write
#imwrite(I8, '05-I8 After Crop-ImAdj-BkgndSubt.tif', 'compression', 'none')
#    isubt = Iadj - bgadj
    isubt = cropped - bgimg 
    print(isubt)
#    isubt = ropped - bgimg
#InvertIm(I) to get inverted image, convert to I8, write as '06-I8 After Cro
#-ImAdj-BkgndSubt-Invert.tif'

    isubt = skutil.invert(isubt)

#    isubt8 = img_as_ubyte(isubt) #Image as UINT8
#DO thresholding, level = graythresh(I) - Otsu to determine threshold number, =
#to thresholdused = level
#DO segmentation, I = im2bw(I, level<- threshold used), imwrite as '07-I After
#Crop-ImAdj-BkgndSubt-Thresh.tif'
    threshed = threshold_otsu(isubt)
    print(threshed)
#    threshed8 = img_as_ubyte(threshed) 
#Use I2 as Ior, invert final segmented I and write as '08-bwf Ready for
#Segmentation.tif'

#cc = bwconncomp(bw5, connectivity) to find objects using a connectivity of 8?
#r = cc.NumObjects to find number of framgents, print r
    binary = isubt > threshed

    binaryinverted = skutil.invert(binary)
    fig, axes = plt.subplots(ncols=3, figsize=(8, 2.5))
    ax = axes.ravel()
    ax[0] = plt.subplot(1, 3, 1, adjustable='box-forced')
#    ax[1] = plt.subplot(1, 3, 2)
    ax[1] = plt.subplot(1, 3, 2, sharex=ax[0], sharey=ax[0], adjustable='box-forced')
    ax[2] = plt.subplot(1, 3, 3, sharex=ax[0], sharey=ax[0], adjustable='box-forced')
    
    ax[0].imshow(Iadj)#, cmap=plt.cm.gray)
    ax[0].set_title('Original')
    ax[0].axis('off')

    ax[1].imshow(isubt, cmap=plt.cm.gray)
    ax[1].set_title('Original/Adjusted')
    ax[1].axis('off')
#    ax[1].hist(isubt.ravel(), bins=40)
#    ax[1].set_title('Histogram')
#    ax[1].axvline(threshed, color='r')
    
    ax[2].imshow(binary,cmap=plt.cm.gray)
    ax[2].set_title('Thresholded')
    ax[2].axis('off')

    plt.show()
#    plt.imshow(cropped)
#    plt.show()

#Read Image, Crop, Convert to I8
def openimage(image):
    I8 = io.imread(image).astype(np.float32)
#    I8 = img_as_ubyte(io.imread(image)) #Image as UINT8
    return I8[1:4380, 1:6250] #Crop Image [1 1 6250 4380]
    #imwrite(I8, '01-18 Original_Cropped.tif', 'compression', 'none')


main()
