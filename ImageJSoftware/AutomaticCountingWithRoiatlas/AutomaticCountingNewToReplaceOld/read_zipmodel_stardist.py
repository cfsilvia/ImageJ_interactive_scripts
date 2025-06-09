# -*- coding: utf-8 -*-
"""
Created on Tue Mar  5 10:23:56 2024

@author: Administrator
"""

import numpy as np
import tensorflow as tf
from stardist.models import StarDist2D
from stardist import fill_label_holes, random_label_cmap, calculate_extents, gputools_available
from stardist import random_label_cmap, _draw_polygons, export_imagej_rois
from stardist.models import Config2D, StarDist2D, StarDistData2D

 # 32 is a good default choice (see 1_data.ipynb)
n_rays = 128

# Use OpenCL-based computations for data generator during training (requires 'gputools')
use_gpu = False and gputools_available()

 # Predict on subsampled grid for increased efficiency and larger field of view
grid = (2,2)
n_channel = 1
conf = Config2D (
     n_rays       = n_rays,
     grid         = grid,
     use_gpu      = True,
     n_channel_in = n_channel,
     
 )

# Load the model
model = StarDist2D(None,name='Oxytocin_model', basedir= 'X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting')
model.keras_model.load_weights('X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/Oxytocin_model/saved_model.pb')  # Load weights

# Prepare your input image (assuming you have it stored as 'input_image.npy')

#input_image = np.load('input_image.npy')

# Perform inference
#instances = model.predict_instances(input_image)