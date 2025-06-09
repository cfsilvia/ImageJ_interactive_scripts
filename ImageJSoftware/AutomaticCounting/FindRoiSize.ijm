 //This script find the size of the rois regions-to do this we have to open an image
 
 inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
 title = "Choose the staining type";
  Dialog.create(title);
  Dialog.addChoice("Staining:", newArray("Dapi","Cherry", "Oxytocin","Vasopresin","TH","Fibers")); //this is the name of the folder
  Dialog.show();
  type1 = Dialog.getChoice();
 //open the  file
  list = getFileList(inputDir + type1 +"/");
  largo=list.length;
  StringyList =newArray(largo); //to get the name of the file
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }

 

 // loop over each roi file and each roi
run("Clear Results");
j=0;
//scale factor
 scale=648.4 //nm per pixel
 	for (i=0; i < largo; i++)  {
		showProgress(i+1, list.length);	
		setBatchMode(true);
//open the picture		
	open(inputDir + type1 + "\\"+ list[i]); //add first picture
    run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");	
///////////////////// open the roi //////////////////////////
   roiManager("reset");
   roiManager("open", inputDir + "ROI/" + StringyList[i] + ".zip" );
 nR = roiManager("Count");  // number of ROI per image.
  print(nR);     
   for (r = 0; r < nR; r++){ 
     roiManager("select",r);
// Get information of the roi
     rName = Roi.getName(); 
     getSelectionBounds(x, y, width, height);
     print(x);
     print(y);
     pos11 = x;
     pos22 = y;
     width=width*scale; //for mm
     width=width/1000000;
     height=height*scale;
     height=height/1000000;
     areaSelection = width*height;

  //save the data in a table
     setResult("Brain slice", j ,list[i]);
     setResult("Region considered",j, rName);
     setResult("Region width (mm)",j, width);
     setResult("Region height(mm)",j, height);
     setResult("Region area(mmxmm)",j,  areaSelection);
   	 j=j+1;
   }
    close("*");
    saveAs("Results",inputDir + "RoiInformation.xls"); //intermediate result 
    setBatchMode(false);
 	}
 	saveAs("Results",inputDir + "RoiInformation.xls"); //intermediate result 
 	showMessage("Finished");