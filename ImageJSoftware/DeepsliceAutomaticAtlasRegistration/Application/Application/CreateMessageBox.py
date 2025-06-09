# -*- coding: utf-8 -*-
"""
Created on Fri Jan  5 23:06:32 2024

@author: Administrator
"""

import tkinter as tk
from tkinter import messagebox

def show_info_and_close():
    messagebox.showinfo("Note","1- Open ABBA in imagej and align with DeepSlice \n 2- Click create images\n 3 left open this image folder\n 4-Continue")
    root.destroy()  # Close the Tkinter window after showing the info message


def CreateMessageBox():
  global root
  # Create the Tkinter root window
  root = tk.Tk()

  # Create a button that will trigger the show_info_and_close function
  button = tk.Button(root, text="Follow the instructions", command=show_info_and_close)
  button.pack()

# Run the Tkinter event loop
  root.mainloop()# -*- coding: utf-8 -*-

