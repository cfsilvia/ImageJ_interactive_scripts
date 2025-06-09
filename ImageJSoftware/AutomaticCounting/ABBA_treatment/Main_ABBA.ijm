//open directory with figures 
///////////////////////////////Begin the program/////////////////////////
 inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
title = "Choose the staining type";
Dialog.create(title);
Dialog.addChoice("Staining of the cell (as oxytocin):", newArray("Cherry", "Oxytocin","Vasopresin","TH","Others")); //this is the name of the folder
Dialog.show();
StainCell = Dialog.getChoice();
////
list = getFileList(inputDir+ StainCell +"/");

for(s = 0; s < list.length; s++) { 
file = inputDir+ StainCell +"/" + list[s];
print(file);
//waitForUser("stop");

runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/ABBA_treatment/Renames_Rois.ijm",file);

}