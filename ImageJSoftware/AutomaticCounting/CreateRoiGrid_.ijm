/*
 * Create Roi composes from rectangulars to form a grid
 * size of each rectangle is 1mm x 1mm
 * use scale factor of 0.6484
 * Note: Remember units in micron
 * Input1: Folder which includes folders with the images e.g. Cfos folder with images of cfos.
 * Input2: type of staining
 * There is a way to do interactive to remove or add rectangles.
 */
///functions 
function CreateArrayIndex(n) {
      ArrayIndex=newArray(n);
  for (ii = 0; ii < n; ii++) {
       ArrayIndex[ii]=ii;

    }
 return ArrayIndex;
	
}
///////////////////////////////////Begin the program/////////////////////////////////

///////////////////////////////////////////////////get files of the images//////////////
inputDir = getDirectory("Choose a Directory with the folder of the desired data which includes roi and images--------");

title = "Choose the staining type";
Dialog.create(title);
Dialog.addChoice("Staining (as cfos):", newArray("Dapi", "Cfos", "Oxytocin","Vasopresin","Others")); 
Dialog.addCheckbox("Change interactively the grid", false);
Dialog.show();
////
StainNucleus = Dialog.getChoice();
OptionChangeGrid = Dialog.getCheckbox();
////////////////////////////////////////////////////////////
list = getFileList(inputDir + StainNucleus + "/");
largo=list.length;
StringyList =newArray(largo);
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }

//create roi directory
if(File.isDirectory(inputDir +"ROI/")  == 0 ){
   File.makeDirectory(inputDir +"ROI/");}
 
roiManager("reset");
//Open the selected images
 for (p = 0 ; p < largo; p++) {
 	showProgress(p+1, list.length);
setBatchMode(true);
   open(inputDir + StainNucleus + "/"+ list[p]);
    run("Enhance Contrast", "saturated=0.35");
 // set the scale of the images  scale 0.6484 micron per pixel
 	  run("Set Scale...", "distance=1 known=0.6484 pixel=1 unit=micron global"); //change to adequate units
 	// create the grid 
 	  	gridNum = 0;
    
        h_allimage = getHeight; //units in pixel
        w_allimage = getWidth;
       
        boxSide = 1543; //number of pixels to cover 1mm
        numBoxY = floor(h_allimage/boxSide); // number of boxes that will fit along the width
        numBoxX = floor(w_allimage/boxSide); // "" height
        remainX = (w_allimage - (numBoxX*boxSide))/2; // remainder distance left when all boxes fit
        remainY = (h_allimage - (numBoxY*boxSide))/2;
        count = 0;
        for (i=0; i<numBoxY; i++) { // draws rectangles in a grid, centred on the X and Y axes and adds to ROI manager
        	for (j=0; j<numBoxX; j++) {
        		makeRectangle((remainX + (j*boxSide)), (remainY+(i*boxSide)), boxSide, boxSide); 
        		roiManager("add");
        		///Rename r roi ///
               roiManager("Select", count);
               roiManager("Rename", count+1);  
               count += 1; 
        		gridNum+=1;
        	}
        }

      
     // Save roi manager
   
    
     roiManager("Show All with labels");
     if(OptionChangeGrid == 1){
     waitForUser("Please select the square you want to remove : select and delete(from keyboard) ");}
     
     roiManager("Select",CreateArrayIndex(gridNum));
     roiManager("Save", inputDir +"ROI/" + "RoiSet"+ StringyList[p] +".zip");
    
   roiManager("reset");
   close("*");
  
setBatchMode(false);


 }
 showMessage("Finished");