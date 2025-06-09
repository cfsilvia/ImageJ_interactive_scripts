
//////////////////////////////////////////////////////
inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
title = "Choose channel to select the desired regions";
Dialog.create(title);
Dialog.addChoice("Type:", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers","Others"));
////////////////////////////////////////////////
Dialog.show();
type = Dialog.getChoice();
/////////// make dir ////////////
if(File.isDirectory(inputDir + "LabeledImagesOf" + type + "/")  == 0 ){
File.makeDirectory(inputDir + "LabeledImagesOf" + type  + "/");}

//////////
list = getFileList(inputDir + type + "/");
largo=list.length;
print(largo);
StringyList =newArray(largo);
StringyNumber =newArray(largo);
for(s = 0; s < largo; s++) { 
	 print(list[s]);
	 //waitForUser("wait");

     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     print(a);
     i = indexOf(a, "_");
    
    // StringyNumber[s] = parseInt(substring(list[s], (lastIndexOf(list[s], "_")+1),lastIndexOf(list[s], ".")));
      StringyNumber[s] = parseInt(substring(a,0, i));
      
       }
     

Array.print(StringyList);

///////go through picture add the rois and do overlay///
for (i=0; i < largo; i++) { // go over each slice
	
	showProgress(i+1, StringyList.length);	
	
    setBatchMode(true);
    print("Wait...");
	print(i);
	
	open(inputDir + type + "/"+ StringyList[i] + ".tif");
	roiManager("reset");
	
	if(File.exists(inputDir + "Roi_all_image_" + type + "/" +  StringyList[i] + ".zip")){
	print(inputDir + "Roi_all_image_" + type + "/" +  StringyList[i] + ".zip");
    roiManager("open", inputDir + "Roi_all_image_" + type + "/" +  StringyList[i] + ".zip" );
    roiManager("Set Color", "yellow");
    roiManager("Set Line Width", 3);
	roiManager("Show All");
	run("Flatten");
	rename("Overlay");
	selectWindow("Overlay");
    saveAs("Tiff", inputDir + "LabeledImagesOf" + type + "\\" + StringyList[i] + ".tif" );
	}
	close("*");
    setBatchMode(false);
}
showMessage("Finished");