# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 09:36:09 2024

@author: Administrator
"""

import tkinter as tk
from tkinter import filedialog
import Manager

def main():
    #%% data
    scale = 648.4
    Type_of_stain = "Cfos+Oxytocin"
    
    #%%
    root = tk.Tk()
    root.withdraw()  # Hide the root window
    Folder_with_data = filedialog.askdirectory(title="Select a Folder with all the data")
    Manager.ManagerCounting(Folder_with_data, Type_of_stain,scale)

if __name__ == "__main__":
    main()