/////////////////////////////////////////////////BEGIN PROGRAM//////////////////////////////////////////////////////
//open slice
//open roi
//open roi atlas
// combine roi and save it as .roi
image_input ="X:/Users/Members/Yael_Kashash/ABBA for trial_BMR4/tifs/Cfos/13_BMR4_Slide1_03.tif";
scale = 648.4;
StainCell = "Cfos";
roi_input ="X:/Users/Members/Yael_Kashash/ABBA for trial_BMR4/tifs/Roi_all_image/13_BMR4_Slide1_03.zip";
roi_atlas = "X:/Users/Members/Yael_Kashash/ABBA for trial_BMR4/tifs/ROI_From_Atlas/RoiSet13_BMR4_Slide1_03.zip"
outputDir ="X:/Users/Members/Yael_Kashash/ABBA for trial_BMR4/tifs/"+ "/CountingResultOf" + StainCell  + "/";
outputImages ="X:/Users/Members/Yael_Kashash/ABBA for trial_BMR4/tifs/"+ "/LabeledImagesOf" + StainCell  + "/";
save_roi = "X:/Users/Members/Yael_Kashash/ABBA for trial_BMR4/tifs/"+ "/testRoi" + StainCell  + "/";
////////
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

//////////Begin Program ///////////////
name_file =substring(image_input, lastIndexOf(image_input, "/")+1, lastIndexOf(image_input, "."));
//Open the image
open(image_input);
run("Set Scale...", "distance=1 known=648.400 unit=nm global");
rename("Original");  
//Get the height and width of current image-and create new image of same size
h=getHeight();
w=getWidth();
newImage("Mask_main", "16-bit black", w, h, 1);

//Open roi from stardist
roiManager("reset");
roiManager("open",roi_input);
nTotal = roiManager("Count"); 
print(nTotal);

//Select empty image- fill rois- convert into binary mask
selectImage("Mask_main");
//roiManager("Draw");
roiManager("Fill");
setOption("BlackBackground", true);
run("Convert to Mask");
//run("Watershed");
roiManager("Delete");
waitForUser("stop");

//load the atlas
 roiManager("open",roi_atlas);
 nR = roiManager("Count");  // number of atlas ROI per image.
 
 // Create mask for right and left-First find the index for left and right
 indexLeft = FindSector(nR,"Left"); //left is actually right
 indexRight = FindSector(nR,"Right");
 roiManager("Select", indexLeft);
run("Create Mask");
rename("Mask_Left");
 
 roiManager("Select", indexRight);
run("Create Mask");
rename("Mask_Right");
 
 j=1;
 //Get a loop through every  region
for (r = 0; r < nR; r++){ 
roiManager("reset");
roiManager("open",roi_atlas);
//select region and convert into mask
roiManager("Select", r);
run("Create Mask");
rename("Mask_region");
// get information of the atlas region as area
roiManager("Select", r);
 rName = Roi.getName(); 
    print(rName);
    //get area of the sector in mmXmm
  getStatistics(area);
    area_all_region = area/(1000000*1000000);

//get only the rois of the given region by multipy the two masks
roiManager("reset");

imageCalculator("Multiply create", "Mask_main","Mask_region");
//save rois

//Count the particles in the mask
run("Analyze Particles...", "display summarize add"); //add to roi
selectWindow("Summary");
waitForUser("stop");
IJ.renameResults("Summary","Results");
nlabels = getResult("Count",0);
filepath = save_roi + rName + ".zip";
if(nlabels > 0){
roiManager("save", filepath);}

//close unnecessary windows
//close("Results");

close("Result of Mask_main");
//find labels on the left
imageCalculator("Multiply create", "Mask_Left","Mask_region");
run("Analyze Particles...", "display summarize");
selectWindow("Summary");
IJ.renameResults("Summary","Results");
areaRoiLeft = (getResult("Total Area",0))/(1000000*1000000);

imageCalculator("Multiply create","Mask_main", "Result of Mask_Left");

run("Analyze Particles...", "display summarize");
selectWindow("Summary");
IJ.renameResults("Summary","Results");
nlabelsLeft = getResult("Count",0);

close("Result of Mask_main");
close("Result of Mask_Left");

//find labels on the Right and area
imageCalculator("Multiply create", "Mask_Right","Mask_region");
run("Analyze Particles...", "display summarize");
selectWindow("Summary");
IJ.renameResults("Summary","Results");
areaRoiRight = (getResult("Total Area",0))/(1000000*1000000);
imageCalculator("Multiply create","Mask_main", "Result of Mask_Right");

run("Analyze Particles...", "display summarize");
selectWindow("Summary");
IJ.renameResults("Summary","Results");
nlabelsRight = getResult("Count",0);

close("Result of Mask_main");
close("Result of Mask_Right");
close("Mask_region");
//Save data into a table- which will not closed 
run("Clear Results");
if (j >1){
IJ.renameResults("AllLabels","Results");	
}

setResult("Brain slice", j-1 ,name_file);
setResult("Number of Labels", j-1 ,nlabels);
setResult("Area of all the ROI mmxmm",j-1, area_all_region);

setResult("Number of Labels Left", j-1 ,nlabelsLeft);
setResult("Area of Left ROI mmxmm",j-1, areaRoiLeft);

setResult("Number of Labels Right", j-1 ,nlabelsRight);
setResult("Area of Right ROI mmxmm",j-1, areaRoiRight);

setResult("Region considered",j-1, rName);

saveAs("Results",outputDir + name_file + "SummaryCountingvs3.xls"); //intermediate result
IJ.renameResults("AllLabels");
run("Clear Results");

j=j+1;


} // end loop atlas regions

//save slide with roi
roiManager("reset");
selectWindow("Original");
roiManager("open",roi_input); //add the marked sector
roiManager("Set Line Width", 2);
run("Flatten");
saveAs("Tiff", outputImages + name_file + "All2.tif" );
close("*");



