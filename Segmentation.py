# Author: James Timotiwu
# Image Processing 
# For Icing Impacts Research

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#scikit-image imports
import skimage.util as skutil
import skimage.io as io
import skimage.exposure as expo
from skimage.filters import threshold_otsu
from skimage import img_as_ubyte

#Open/Crop Image
def openimage(image):
    I8 = io.imread(image).astype(np.float32)
#    I8 = img_as_ubyte(io.imread(image)) #Image as UINT8
    return I8[1:4380, 1:6250] #Crop Image [1 1 6250 4380]
    #imwrite(I8, '01-18 Original_Cropped.tif', 'compression', 'none')

def imthresh(imsubtracted):
    threshed = threshold_otsu(imsubtracted)
    return imsubtracted > threshed

def tofloat(image):
    float_isubt = expo.rescale_intensity(image)
    return img_as_ubyte(float_isubt)

def imadjust(image):
    #Adjust Image with range of intensities
    p1, p2 = np.percentile(cropped, (5, 99.994))
    Iadj = expo.rescale_intensity(cropped, in_range=(p1,p2))

#Main definition for program
def main():
    #Grab original image
    cropped = openimage(os.path.join(os.path.abspath('..'), 'data', '5 psi Runs', '5psi_1.tiff'))

    #Get Background Image
    bgimg = openimage(os.path.join(os.path.abspath('..'), 'data', '5 psi Runs',
        '5psi baseline.tiff'))

    #Subtract Image and Invert
    isubt = np.subtract(cropped, bgimg)

    isubt = skutil.invert(isubt)

main()
