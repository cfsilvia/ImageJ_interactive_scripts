# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 09:28:31 2024

@author: Administrator
"""
from glob  import glob
import os
from GetCountingInParallel import GetCounting

def ManagerCounting(Folder_with_data, Type_of_stain,scale):     
    Total_inputs = list()
    X_file = sorted(glob(Folder_with_data + '/' + 'Oxytocin' + '/' +'*.tif'))
    for index in range(len(X_file)):
        # # file name with extension
        file_name = os.path.basename(X_file[index])
        # # file name without extension
        filename = os.path.splitext(file_name)[0]
        #%% Create list of inputs for future counting
        InputsString = CreateListInputs(Folder_with_data, Type_of_stain,scale,filename)
        #Create list for each filename
        Total_inputs.append(InputsString)  
    #%%Applied function to get counting in parallel
    GetCounting(Total_inputs,Type_of_stain)
    
#%%
def Create_folder(path):
    isExist = os.path.exists(path)
    if not isExist:
       # Create a new directory because it does not exist
       os.makedirs(path)
       

    
    
#%% Create a list of inputs

def CreateListInputs(Folder_with_data, Type_of_stain,scale,filename):
    #%%
    image_input_2 = Folder_with_data + '/' + 'Oxytocin' + '/' + filename + '.tif';
    image_input_1 = Folder_with_data + '/' + 'Cfos' + '/' + filename + '.tif';
    roi_input_2 = Folder_with_data + '/' + 'Roi_all_image_Oxytocin' +'/' + filename +".zip";
    roi_input_1 = Folder_with_data + '/' + 'Roi_all_image_Cfos' + '/' + filename +".zip";
    roi_user = Folder_with_data + '/' + 'ROI' + '/' + 'RoiSet' + filename +".zip";
    outputDir =  Folder_with_data + '/' + 'CountingResultOf' + Type_of_stain + '/'
    Create_folder(outputDir)
    outputImages = Folder_with_data + '/' + 'LabeledImagesOf' + Type_of_stain + '/'
    Create_folder(outputImages)
#%%Create list
    Inputs = [roi_input_1,roi_input_2, roi_user, outputDir, outputImages, image_input_1,image_input_2, Type_of_stain ,str(scale)]
    #Convert into string
    InputsString = '%'.join(Inputs)
    return InputsString