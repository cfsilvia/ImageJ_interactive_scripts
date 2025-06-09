////////////////////////////////////////Function////////////////////
function CreateArrayIndex(n) {
       ArrayIndex=newArray(n);
   for (ii = 0; ii < n; ii++) {
        ArrayIndex[ii]=ii;
     }
 return ArrayIndex;
 }

///
function ArrayIndexWithtSelectionIntersection(r,nR,nTotal ) { //find roi index without intersection of main selection with the stardist detections

  indexdel1=newArray(0);
  //auxarray= newArray(0)
   for (vr1 = nR; vr1 < (nTotal-1); vr1++) {
   	    roiManager("select",newArray(r,vr1));
   	    
		roiManager("AND"); //find joining
		
		if (selectionType > -1 )	{// if it is overlapped
         indexdel1= Array.concat(indexdel1, vr1);
			
		}
   }

    return indexdel1;
	
}

function FindSector(nR,Sector){
	for (vr1 = 0; vr1 < nR; vr1++) {
		roiManager("select",vr1);
        rName = Roi.getName(); 
       
		if(rName == Sector){
		index = vr1;
	}
	}
	return index;
}

function FindOnSector(arraySelection,indexSector){
	nlabels = 0;

	for(i =0; i<arraySelection.length; i++){
		 roiManager("select",newArray(arraySelection[i],parseInt(indexSector)));
		 print(arraySelection[i]);
		 print(indexSector);
		// waitForUser("stop");
   	     roiManager("AND"); //find joining
   	     if(selectionType > -1 ){
   	     	nlabels = nlabels + 1;
   	     	 //waitForUser("stop");
   	     }
	}
	
	return nlabels;
}

function FindArea(r,indexSector){
	if(r != indexSector){
	roiManager("select",newArray(r,indexSector));
	
	roiManager("AND"); //find joining
   	 if(selectionType > -1 ){
   	     getStatistics(area);
         areaRoi = area/(1000000*1000000);
   	     } else{
   	     	areaRoi = 0;
   	     }
	}else {
		roiManager("select",indexSector);
		 getStatistics(area);
         areaRoi = area/(1000000*1000000);
		}
	return areaRoi;
}

/////////////////////////////////////////////////BEGIN PROGRAM//////////////////////////////////////////////////////
//open slice
//open roi
//open roi atlas
// combine roi and save it as .roi
image_input ="X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/P16/4p16_brain_old1_plate1_1_2.tif";
scale = 648.400;
StainCell = "P16";
roi_input ="X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/Roi_all_image/4p16_brain_old1_plate1_1_2.zip";
roi_atlas = "X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/ROI_From_Atlas/RoiSet4p16_brain_old1_plate1_1_2.zip"
outputDir ="X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/"+ "/CountingResultOf" + StainCell  + "/";
outputImages ="X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/"+ "/LabeledImagesOf" + StainCell  + "/";
//roi_all = "X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/RoisAll/4p16_brain_old1_plate1_1_2.roi"
name_file =substring(image_input, lastIndexOf(image_input, "/")+1, lastIndexOf(image_input, "."));
//Open the image
open(image_input);
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
rename("Original");  
//open roi atlas 
// find index for left and right- ADD

//Open roi
 roiManager("reset");
 roiManager("open",roi_atlas);
 nR = roiManager("Count");  // number of ROI per image.
 print(nR); 
 //Find Left /Right
 indexLeft = FindSector(nR,"Left"); //left is actually right
 indexRight = FindSector(nR,"Right"); 
 print(indexLeft);
 print(indexRight);
 
//combine roi labels
//Roi_atlas=CreateArrayIndex(nR); //create array for selection
roiManager("open",roi_input);
nTotal = roiManager("Count");  
nlabels = nTotal -nR;
print(nlabels);
//waitForUser("stop");
j=1; //count results
run("Set Scale...", "distance=1 known=648.400 unit=nm global");
for (r = 0; r < nR; r++){ //trough the atlas
	//information about the roi
	run("Select None");//erase previous selection
    roiManager("select",r);
    rName = Roi.getName(); 
    print(rName);
    //get area of the sector in mmXmm
    getStatistics(area);
    area_all_region = area/(1000000*1000000);
    
    getSelectionBounds(x, y, width, height); //information about the roi

       areaSelection = width*height;
       widths=width*scale; //for mm
       widths=widths/1000000;
       heights=height*scale;
      heights=heights/1000000;
      areaSelectionS = widths*heights;
      run("Select None");//erase previous selection
	//
	arraySelection = ArrayIndexWithtSelectionIntersection(r,nR,nTotal);
	
	
	//add arraySelection isnot emptyADD 
	if(arraySelection.length > 0){
	roiManager("select",arraySelection);
	roiManager("measure");
	nlabels = nResults;
	///
	//ADD ONCE FOUND INTERSECTION FOUND INTERSECTION WITH LEFT AND WITH RIGHT(OPPOSED THAN IN FRONT) FOUND COUNTINGS
    nlabelsRight = FindOnSector(arraySelection,indexRight);
    nlabelsLeft = FindOnSector(arraySelection,indexLeft);
   
   // waitForUser("stop");
    
	//
	}
	else{
		nlabels = 0;
		nlabelsLeft = 0;
		nlabelsRight = 0;
	}
	areaRoiLeft = FindArea(r,indexLeft);
    areaRoiRight = FindArea(r,indexRight);
	//////////////////////////////////////
	
    
    
    //////////////////////////////////////
	//save in a table
	//--------------------Store results-----------
run("Clear Results");
if (j >1){
IJ.renameResults("AllLabels","Results");	
}


//setResult("# slice", j-1 ,SliceNumber);



setResult("Brain slice", j-1 ,name_file);
setResult("Number of Labels", j-1 ,nlabels);
setResult("Area of all the ROI mmxmm",j-1, area_all_region);

setResult("Number of Labels Left", j-1 ,nlabelsLeft);
setResult("Area of Left ROI mmxmm",j-1, areaRoiLeft);

setResult("Number of Labels Right", j-1 ,nlabelsRight);
setResult("Area of Right ROI mmxmm",j-1, areaRoiRight);
//setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);

saveAs("Results",outputDir + name_file + "SummaryCounting.xls"); //intermediate result
IJ.renameResults("AllLabels");
run("Clear Results");

	//waitForUser("stop");
	j=j+1;
}
//save slide with roi
roiManager("reset");
selectWindow("Original");
roiManager("open",roi_input); //add the marked sector
roiManager("Set Line Width", 2);
run("Flatten");
//saveAs("Tiff", outputImages + name_file + "All.tif" );
close("*");