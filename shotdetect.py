import os
import numpy as np
import argparse
import pandas as pd
import cv2
from matplotlib import pyplot as plt

def openimage(image):
    I8 = cv2.imread(image)
#    I8 = img_as_ubyte(io.imread(image)) #Image as UINT8
    return I8[925:2200, 1:1265] #img[y:y+h, x:x+w]
#imwrite(I8, '01-18 Original_Cropped.tif', 'compression', 'none')

def main():

    path = os.path.join(os.getcwd() , 'data', 'Shots', 'S1705713417071412450.tiff')
    bgr_img = openimage(path)
    
    if bgr_img.shape[-1] == 3:           # color image
        b,g,r = cv2.split(bgr_img)       # get b,g,r
        rgb_img = cv2.merge([r,g,b])     # switch it to rgb
        gray_img = cv2.cvtColor(bgr_img, cv2.COLOR_BGR2GRAY)
    else:
        gray_img = bgr_img


    ret2,gray_img = cv2.threshold(gray_img,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
    img = cv2.medianBlur(gray_img, 7)
    cimg = cv2.cvtColor(img,cv2.COLOR_GRAY2BGR)
    
    circles = cv2.HoughCircles(img,cv2.HOUGH_GRADIENT,1,20,
                                param1=50,param2=30,minRadius=0,maxRadius=0)
    
    circles = np.uint16(np.around(circles))
    
    for i in circles[0,:]:
        # draw the outer circle
        cv2.circle(cimg,(i[0],i[1]),i[2],(0,255,0),2)
        # draw the center of the circle
        cv2.circle(cimg,(i[0],i[1]),2,(0,0,255),3)
    

    plt.subplot(121),plt.imshow(rgb_img)
    plt.title('Input Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(122),plt.imshow(cimg)
    plt.title('Output'), plt.xticks([]), plt.yticks([])

    plt.show()

main()
