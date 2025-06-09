# -*- coding: utf-8 -*-
"""
Created on Wed Dec 27 09:45:26 2023

@author: Administrator
Use: https://github.com/PolarBean/DeepSlice
to use together with abba 
"""

from DeepSlice import DSModel
import SaveFilesAsJpeg 
from CreateMessageBox import CreateMessageBox
import tkinter as tk
from tkinter import messagebox, filedialog
from tkinter import ttk 

def select_file():
    file_path = filedialog.askdirectory(title="Folder with folders of the images and RoiAtlas folder")
    entry_path.delete(0, tk.END)  # Clear previous text
    entry_path.insert(0, file_path)  # Insert new file path

def select_data(event):
    selected_data.set(data_combobox.get())
    
def OK_action():
    #get variables
    folderpath = entry_path.get() + '/'
    species = selected_data.get()
    
    deepslice(folderpath,species)

    messagebox.showinfo("Finish", "Task Completed!")
    app.destroy()

def deepslice(folderpath,species):
 

 # SaveFilesAsJpeg.call_class_to_Save(folderpath, output)
 
  species = species  #available species are 'mouse' and 'rat'

  Model = DSModel(species)

#here you run the model on your folder
#try with and without ensemble to find the model which best works for you
#if you have section numbers included in the filename as _sXXX specify this :)
  Model.predict(folderpath, ensemble=True, section_numbers=True)    
  
  #If you would like to normalise the angles (you should)
  Model.propagate_angles()                     
#To reorder your sections according to the section numbers 
  Model.enforce_index_order()    
#alternatively if you know the precise spacing (ie; 1, 2, 4, indicates that section 3 has been left out of the series) Then you can use      
#Furthermore if you know the exact section thickness in microns this can be included instead of None
#if your sections are numbered rostral to caudal you will need to specify a negative section_thickness      
  Model.enforce_index_spacing(section_thickness = None)
  

#now we save which will produce a json file which can be placed in the same directory as your images and then opened with QuickNII. 
  Model.save_predictions(folderpath + 'results')                    


if __name__ == '__main__':
    ###############
    #define variable
    global entry_path
    global selected_data
 
    global data_combobox
    global app 
   
    
    # Create the main application window
    app = tk.Tk()
    app.title("Menu for creating files for automatic registration")
    app.geometry("500x200")  # Set the initial size of the window


    # Create a button to select a file and pack it to the top-left
    button_select = tk.Button(app, text="Select directory with data", command=select_file)
    button_select.grid(row=0, column=0, padx=5, pady=10)

    # Create a text box to display the selected file path and pack it to the top-center
    entry_path = tk.Entry(app, width=50)
    entry_path.grid(row=0, column=1, padx=5, pady=10)

    # Label above the Combobox to display text
    label_data = tk.Label(app, text="Select Data:")
    label_data.grid(row=1, column=0, columnspan=1, pady=5)

    # List of titles
    titles = ["mouse", "rat"]

    # Variable to store the selected data
    selected_data = tk.StringVar(app)

    # Create a dropdown list (Combobox) for selecting data and place it in the third row
    data_combobox = ttk.Combobox(app, textvariable=selected_data, values=titles)
    data_combobox.grid(row=2, column=0, columnspan=1, padx=5, pady=5, sticky="ew")  # Use columnspan to span both columns
    data_combobox.config(width=15)  # Set the width of the dropdown list

   

    # OK button at the bottom
    ok_button = tk.Button(app, text="OK",command = OK_action)
    ok_button.grid(row=5, column=0, columnspan=2, pady=10)
    
    # Start the GUI application
    app.mainloop()
    
    
   