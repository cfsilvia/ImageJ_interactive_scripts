'''
18/12/2023
written by Silvia G. Chuartzman
Counting of labels  on a brain slice over sectors defined by the atlas

'''
#External libraries
from __future__ import print_function, unicode_literals, absolute_import, division
import sys
import numpy as np
import matplotlib
matplotlib.rcParams["image.interpolation"] = 'none'
import matplotlib.pyplot as plt
#%matplotlib inline
#%config InlineBackend.figure_format = 'retina'

from  Postprocessing import  Postprocessing
#from Plotprocessing import Plotprocessing
from read_roi import read_roi_zip


#imagej library
import imagej

#internal library
from ManagerData import ManagerData
from ManagerData import ManagerCounting
from ManagerData import ManagerCountingWithoutAtlas

import tkinter as tk
from tkinter import filedialog
from tkinter import ttk  # Import ttk module for Combobox

from tkinter import messagebox


def select_file():
    file_path = filedialog.askdirectory(title="Folder with folders of the images and RoiAtlas folder")
    entry_path.delete(0, tk.END)  # Clear previous text
    entry_path.insert(0, file_path)  # Insert new file path

# Function to handle the selection from the dropdown list
def select_data(event):
    selected_data.set(data_combobox.get())
    
def OK_action():
    #get variables
    Folder_with_data = entry_path.get() + '/'
    Type_of_stain = selected_data.get()
    scale = text_box.get("1.0", tk.END)
    
    if check_var1.get() and check_var2.get() == False and check_var3.get():
    #find the labels
      ManagerDataAll(Folder_with_data, Type_of_stain,scale)
    #count the labels
      ManagerCountingAll(Folder_with_data, Type_of_stain,scale,check_var4.get())
      
    elif check_var2.get() and check_var1.get() == False and check_var3.get() == False:
    #order each brain sector in another sheet  and plot
      '''
      input 1)_Folder_with_data
          2)_ Type_of_stain
          3)_ Separation  the _ or p or that separate the first number of slice from the rest
       '''
      Postprocessing(Folder_with_data, Type_of_stain,'_')
    elif check_var2.get() and check_var1.get() and check_var3.get():
     #find the labels
     ManagerDataAll(Folder_with_data, Type_of_stain,scale)
     #count the labels
     ManagerCountingAll(Folder_with_data, Type_of_stain,scale,check_var4.get())
     Postprocessing(Folder_with_data, Type_of_stain,'_')
    elif check_var1.get() and check_var2.get() == False and check_var3.get() == False:
    #find the labels
      ManagerDataAll(Folder_with_data, Type_of_stain,scale)
    elif check_var1.get() == False and check_var2.get() == False and check_var3.get(): 
      #count the labels
      ManagerCountingAll(Folder_with_data, Type_of_stain,scale,check_var4.get())
    elif check_var1.get() == False and check_var2.get()  and check_var3.get(): 
      ManagerCountingAll(Folder_with_data, Type_of_stain,scale, check_var4.get())
      Postprocessing(Folder_with_data, Type_of_stain,'_')
      
    messagebox.showinfo("Finish", "Task Completed!")
    app.destroy()

'''
if there are more than one stain
the functions are repeated
'''
def ManagerDataAll(Folder_with_data, Type_of_stain,scale):
    if Type_of_stain == "Cfos+Oxytocin":
        stains = Type_of_stain.split("+") #convert into a list
        for s in stains:
            ManagerData(Folder_with_data, s,scale)
    else:
       ManagerData(Folder_with_data, Type_of_stain,scale)
       
def ManagerCountingAll(Folder_with_data, Type_of_stain,scale,use_atlas_roi):
    if Type_of_stain == "Cfos+Oxytocin" and use_atlas_roi:
        stains = Type_of_stain.split("+") #convert into a list
        for s in stains:
            ManagerCounting(Folder_with_data, s,scale)
    elif Type_of_stain == "Cfos+Oxytocin" and use_atlas_roi == False:#without atlas
            ManagerCountingWithoutAtlas(Folder_with_data, Type_of_stain,scale)
    else:
       ManagerCounting(Folder_with_data, Type_of_stain,scale)
    

#%%
def main():
   ###############
   #define variable
   global entry_path
   global selected_data
   global text_box
   global data_combobox
   global app 
   global check_var1, check_var2, check_var3, check_var4
   
   # Create the main application window
   app = tk.Tk()
   app.title("Menu for get counting labels")
   app.geometry("600x600")  # Set the initial size of the window


   # Create a button to select a file and pack it to the top-left
   button_select = tk.Button(app, text="Select directory with data", command=select_file)
   button_select.grid(row=0, column=0, padx=5, pady=10)

   # Create a text box to display the selected file path and pack it to the top-center
   entry_path = tk.Entry(app, width=50)
   entry_path.grid(row=0, column=1, padx=5, pady=10)

   # Label above the Combobox to display text
   label_data = tk.Label(app, text="Select Data:")
   label_data.grid(row=1, column=0, columnspan=2, pady=5)

   # List of titles
   titles = ["P16", "Oxytocin", "Cfos", "Vasopresin" , "Cfos+Oxytocin"]

   # Variable to store the selected data
   selected_data = tk.StringVar(app)

   # Create a dropdown list (Combobox) for selecting data and place it in the third row
   data_combobox = ttk.Combobox(app, textvariable=selected_data, values=titles)
   data_combobox.grid(row=2, column=0, columnspan=2, padx=5, pady=10, sticky="ew")  # Use columnspan to span both columns
   data_combobox.config(width=15)  # Set the width of the dropdown list

   # Label for the text box
   label_text_box = tk.Label(app, text="Scale(nm per pixel \n 648.4 for a x10 lens):")
   label_text_box.grid(row=3, column=0, pady=5)

   # Text box to enter text
   text_box = tk.Text(app,height=1, width=10)
   text_box.grid(row=3, column=1, padx=1, pady=10)
   text_box.insert(tk.END, "648.4") 
   
   
  

   
   #add two checkboxes
   check_var1 = tk.BooleanVar()
   check_var2 = tk.BooleanVar()
   check_var3 = tk.BooleanVar()
   check_var4 = tk.BooleanVar()
   
   # Create three checkbuttons with a custom font size
   checkbutton1 = tk.Checkbutton(app, text="Finding the labels of each slice", variable=check_var1, font=('Helvetica', 12,'bold'), bg='lightblue', fg='black')
   checkbutton2 = tk.Checkbutton(app, text="Join excel files after the  counting", variable=check_var2, font=('Helvetica', 12,'bold'), bg='lightgreen', fg='black')
   checkbutton3 = tk.Checkbutton(app, text="Counting the labels of each slice", variable=check_var3, font=('Helvetica', 12,'bold'), bg='lightyellow', fg='black')
   checkbutton4 = tk.Checkbutton(app, text="ROI From Atlas", variable=check_var4, font=('Helvetica', 10,'bold'), bg='lightsalmon', fg='black')
   
   checkbutton4.grid(row=5, column=1, sticky='w',pady =10)
   
   label_text_box = tk.Label(app, text="Choose one or both of the following options:", font=('Helvetica', 12,'bold'))
   label_text_box.grid(row=6, column=1, pady=5)
   # Pack the checkbuttons
   checkbutton1.grid(row=7, column=1, sticky='w',pady =20)
   checkbutton3.grid(row=8, column=1, sticky='w',pady =20)
   checkbutton2.grid(row=9, column=1, sticky='w',pady =20)
   
   # OK button at the bottom
   ok_button = tk.Button(app, text="OK",command = OK_action)
   ok_button.grid(row=10, column=0, columnspan=2, pady=30)
   
   # Start the GUI application
   app.mainloop()
   

############################
   
    
  #  Plotprocessing(file_to_plot)
    
    #%%

if __name__ == "__main__":
    main()