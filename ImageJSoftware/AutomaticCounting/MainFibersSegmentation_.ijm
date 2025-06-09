
Dialog.create("This scripts is doing the segmentation of fibers");


Dialog.addCheckbox("	Set up the parameters to detect fibers - ", false);
Dialog.addMessage(" ");

Dialog.addCheckbox("	Do the segmentation of the fibers - ", false);

Dialog.addMessage(" ");

Dialog.addCheckbox("	Do Montage with the  fibers - ", false);

Dialog.show();
a = Dialog.getCheckbox();
b = Dialog.getCheckbox();
c = Dialog.getCheckbox();
    
if (a){
    runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SetUpFibersvs1_.ijm");} 
     
if (b){
    runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/DetectFibersvs5_.ijm");} 

     
if (c){
    runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/MontagetifLabel_.ijm");}     .