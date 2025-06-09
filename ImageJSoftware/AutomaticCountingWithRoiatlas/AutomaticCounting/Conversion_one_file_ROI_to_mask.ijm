
///////////////////////////////Begin the program/////////////////////////
inputData =  getArgument();

data =split(inputData,"%");
inputDir = data[0];
StainCell = data[1];
filename = data[2];


print(inputDir);
print(StainCell);
print(filename);



/////////////
	setBatchMode(true);
	//set up the binary maske to be black inside
    run("Options...", "iterations=1 count=1 black");

	//open image
	open(inputDir + "/"+ StainCell + "/"+ filename + ".tif");
	
	rename("image");
	// create a folder for each slide with the masks
	File.makeDirectory(inputDir + "/"+ "ROI_Into_Mask/")
	File.makeDirectory(inputDir + "/"+ "ROI_Into_Mask/" + filename + "/");
	
	//open the respective ROI
	roiManager("reset");
	roiManager("open", inputDir + "/"+ "ROI_From_Atlas/" + "RoiSet" + filename + ".zip" );
    nR = roiManager("Count");  // number of ROI per image.
   print(nR);  
   //loop over every roi
   for (r = 0; r < nR; r++){ 
   	roiManager("Select", r);
   	rName = Roi.getName(); 
   	//convert into mask
   	selectWindow("image");
   	run("Create Mask");
   
   	selectImage("Mask"); // save each mask
   	path = inputDir + "/"+ "ROI_Into_Mask/" + filename + "/" + rName + "_" + filename + "_Mask.tif";
   	saveAs("Tiff", path);
   
	close();
	}
  
	//close image
	selectImage("image");
	close();

setBatchMode(false);
print("Finished"+ filename); //to know if finished