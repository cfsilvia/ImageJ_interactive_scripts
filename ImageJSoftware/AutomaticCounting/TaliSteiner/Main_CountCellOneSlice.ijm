//Main program of CountCellOneSlice

///Create dialog box/////////////
inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
title = "Choose the staining type";
Dialog.create(title);
Dialog.addChoice("Staining of the cell (as oxytocin):", newArray("Cherry", "Oxytocin","Vasopresin","TH","Others")); //this is the name of the folder
Dialog.addNumber("Add scale factor nm per pixel (as 648.4 for 10x):", 648.4);
Dialog.show();
StainCell = Dialog.getChoice();
scale = Dialog.getNumber();

//create the needed directories
File.makeDirectory(inputDir + "/CountingResultsOf" + StainCell  + "/");
File.makeDirectory(inputDir + "/LabeledImagesOf" + StainCell + "/");//to save one type of cell
File.makeDirectory(inputDir + "/ROICells_" + StainCell + "/");

list = getFileList(inputDir+ StainCell +"/");
for( s= 2; s < list.length; s++){

image_input = inputDir+ StainCell +"/" + list[s];
//print(image_input);
//waitForUser("stop");
variable = image_input + "$" + scale  + "$" + "Oxytocin";
print(image_input);
//waitForUser("stop");
runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/TaliSteiner/CountCellOneSlice_.ijm",variable);

}
showMessage("FINISHED");