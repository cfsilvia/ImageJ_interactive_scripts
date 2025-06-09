# -*- coding: utf-8 -*-
"""
Created on Wed Dec 27 10:51:28 2023

@author: Administrator
Class to save as jpeg
"""
from glob  import glob
import cv2
import os



class SaveFilesAsJpeg:
    '''
    Fields1: Folder with images in tif format
    Fields2: List of images that read
    Fields3:filenames
    Methods-1: Open pictures and create a list of all pictures
    Methods-2: save pictures in jpeg format.
    
    '''
    def  __init__(self, Folder_with_data,Folder_to_save):
        self.Folder_with_data = Folder_with_data
        self.Folder_to_save = Folder_to_save
        
        self.X_file = []
        
    def OpenData(self):
        #list the images files in the folder/read the images
        self.X_file = sorted(glob(self.Folder_with_data + '*.tif'))
      
        
        
    def SaveData(self):
        for f in self.X_file:
            img = cv2.imread(f)
            #resized
            scale_percent = 10 # percent of original size
            width = int(img.shape[1] * scale_percent / 100)
            height = int(img.shape[0] * scale_percent / 100)
            dim = (width, height)
  
            # resize image
            resized = cv2.resize(img, dim, interpolation = cv2.INTER_AREA)
            
            # file name without extension
            filename = f.split('\\')[1]
            filename = filename.split('.')[0]
            output = self.Folder_to_save + filename + '.jpg'
            cv2.imwrite(output,resized)
            
'''
function to call the class
'''
            
def call_class_to_Save(Folder_with_data,Folder_to_save):
        #create instance
        obj = SaveFilesAsJpeg(Folder_with_data,Folder_to_save)
        #apply methods
        obj.OpenData()
        obj.SaveData()
        
        