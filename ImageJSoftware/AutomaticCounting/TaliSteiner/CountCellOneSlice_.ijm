/////////////////////////////////////////Auxiliary functions /////////////////////////////////////////
function getRoiFile(inputFile){
	aux = substring(inputFile,lastIndexOf(inputFile,"/")+1,indexOf(inputFile,".tif"));
	dir = File.getDirectory(inputFile);
	print(dir);
	
	dir= substring(dir,0,lastIndexOf(dir,"/")-1);
	dir= substring(dir,0,lastIndexOf(dir,"/"));
	print(dir);

	inputRoi = dir + "/ROI/" +"RoiSet" + aux + ".zip";
	return inputRoi;
}

function getDir(inputFile){
	dir = File.getDirectory(inputFile);
	dir= substring(dir,0,lastIndexOf(dir,"/")-1);
	dir= substring(dir,0,lastIndexOf(dir,"/"));
	return dir;	
}

function ArrayUnion(array1x,array1y, array2x,array2y) {
	unionAx = newArray();
	unionAy = newArray();
	for (i=0; i<array1x.length; i++) {
		for (j=0; j<array2x.length; j++) {
			if((array1x[i] == array2x[j]) &(array1y[i] == array2y[j])){
				unionAx = Array.concat(unionAx, array1x[i]);
				unionAy = Array.concat(unionAy, array1y[i]);
				
			}
		}
	}
	return unionAx.length;
	
}
///
function CreateArrayIndex(n) {
      ArrayIndex=newArray(n);
  for (ii = 0; ii < n; ii++) {
       ArrayIndex[ii]=ii;

    }
 return ArrayIndex;
	
}
////////////////////////////////////////////////////////////
function RemoveRoiAreas(n,VirusDelete) {
for (ii = 0; ii < n; ii++) { //remove from roi undesired roi
  roiManager("select", ii);
  roiManager("measure");
  areaSelectionV = getResult('Area',ii);
  if(areaSelectionV > 1000){ //in the case of fails
  	VirusDelete = Array.concat(VirusDelete,ii);
  } 
}
return VirusDelete;
}
///
function MoveSelection(pos11,pos22) {

   for (vr = 0; vr <roiManager("count"); vr++){
          roiManager('select', vr);
          getSelectionBounds(x, y, w, h);
          setSelectionLocation(x+pos11, y+pos22);
          roiManager('update');
      }

	
}
///
function ArrayIndexWithoutSelectionIntersection( ) { //find roi index without intersection of main selection with the stardist detections

  indexdel1=newArray(0);
   for (vr1 = 0; vr1 < (roiManager("count")-1); vr1++) {
   	    roiManager("select",newArray(vr1,(roiManager("count")-1)));
		roiManager("AND"); //find joining
		
		if (selectionType == -1 )	{// if it isnot overlapped
         indexdel1= Array.concat(indexdel1, vr1);
			
		}
   }

    return indexdel1;
	
}
//// Remove no selected regions
function RemoveNoSelectedRegions(r,nR,ntotal) {
  RegionsToDelete=newArray(0);	
  for (vr1 = ntotal; vr1 < (ntotal +nR); vr1++) {
  	print(nR);
  	if(vr1 !=  (ntotal + r)) {
  		 RegionsToDelete = Array.concat(RegionsToDelete,vr1);
  	}
  }
 return RegionsToDelete;
}
/////////
//////////////////////////////////////////////////////////////

/////////////////////////////////////////////////BEGIN PROGRAM//////////////////////////////////////////////////////




///Take one slice
//Find the path - of the roi
//duplicate  the image to have an image to add data
// go through each roi

/////////
/*image_input = "X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/Oxytocin/4p16_brain_old1_plate1_1_2.tif";
scale = 684.4;
StainCell = "Oxytocin";*/
variable = getArgument();
print(variable);
image_input = substring(variable,0,indexOf(variable,"$"));
print(image_input);
StainCell = substring(variable,lastIndexOf(variable,"$")+1);
print(StainCell);
scale =  parseFloat(substring(variable,indexOf(variable,"$")+1,lastIndexOf(variable,"$")));
print(scale);


///get Roi input file

roi_input = getRoiFile(image_input);

//get dir input file
inputDir = getDir(image_input);
print(inputDir);
//waitForUser("stop");

//
name_file =substring(image_input, lastIndexOf(image_input, "/")+1, lastIndexOf(image_input, "."));
outputDir = inputDir + "/CountingResultsOf" + StainCell  + "/";
//
File.makeDirectory(inputDir + "/ROICells_" + StainCell+ "/" + name_file + "/");//to save roi of the figures


//count results
j=1;

//print(inputDir);
//waitForUser("stop");

//Open the image
open(image_input);
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
rename("Oxytocin");  
//run("Duplicate..."," ");
//rename("Oxytocin_final");
//
//Open roi
 roiManager("reset");
 roiManager("open",roi_input);
 nR = roiManager("Count");  // number of ROI per image.
 print(nR);      
//

for (r = 0; r < nR; r++){ 
	
///////	Before procession
//Open roi
 roiManager("reset"); //due because it is used again
 roiManager("open",roi_input);
//select the roi in the picture
selectWindow("Oxytocin");
run("Select None");//erase previous selection
roiManager("select",r);
rName = Roi.getName(); 
print(rName);
getSelectionBounds(x, y, width, height); //information about the roi
      pos11 = x;
       pos22 = y;
       areaSelection = width*height;
       widths=width*scale; //for mm
       widths=widths/1000000;
       heights=height*scale;
      heights=heights/1000000;
      areaSelectionS = widths*heights;

run("Duplicate..."," ");
rename("use");
roiManager("reset");

showText("Now is running the slice:"+ rName + " - "+ substring(image_input, lastIndexOf(image_input, "/")+1, lastIndexOf(image_input, ".")));
//Processing with stardist
//change ntiles to 6 instead 1
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'use', 'modelChoice':'Model (.zip) from File', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.3', 'nmsThresh':'0.5', 'outputType':'Both', 'modelFile':'X:\\\\Users\\\\LabSoftware\\\\ImageJSoftware\\\\AutomaticCounting\\\\TestModelForP16Virus.zip', 'nTiles':'8', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
rename('label');
selectWindow('label');
///------------------------------Remove big regions-----------------------------
npvn = roiManager ("Count");
PvnDelete=newArray(0);
if(npvn > 0){ //in the case that nothing was detected
PvnDelete = RemoveRoiAreas(npvn,PvnDelete); //Remove big detections that stardist adds
if(PvnDelete.length !=0){//if there are big things to remov
roiManager("select", PvnDelete);
roiManager("delete");} //delete big things
//check again counts
npvn=roiManager ("Count");

//collect all the useful rois in an array
if(npvn>0){
PvnRoi=CreateArrayIndex(npvn); //create array for selection
roiManager("select", PvnRoi);
roiManager("Save", inputDir + "Pvn.zip");

}
roiManager ("Reset");
run("Clear Results");
}

//------------------------ finish-------------
//--------------------Eliminate detection outside the selection region and save again--------------------------------------------------------------
//////////////////////////////////////////// Remove events outside the desired region /////////////////////////////////
if(npvn > 0){
selectWindow("Oxytocin");
roiManager("open", inputDir + "Pvn.zip");
MoveSelection(pos11,pos22); // Move selection to the original picture
naux1= roiManager("count");// add to this roi
roiManager("open", roi_input);
// Remove all selections except the one you are intrested
RegionsToDelete=RemoveNoSelectedRegions(r,nR,naux1);
//
if(RegionsToDelete.length !=0){
roiManager("select", RegionsToDelete);
roiManager("delete");}
indexdel1 = ArrayIndexWithoutSelectionIntersection(); //remove detections not inside the main selection
if(indexdel1.length !=0){ 
   roiManager("select",indexdel1);
   roiManager("delete");}
//////////////
MoveSelection(-pos11,-pos22); //Return roi to selected picture
selectWindow('use');
roiManager("select",(roiManager("count")-1));
roiManager("delete"); //delete the big selection
numberCells = roiManager("count");
npvn =  roiManager("count");
if(npvn !=0){
roiManager("Save", inputDir + "Pvn.zip");
// save final rois
if(indexOf(rName,"/") > -1){// change rname if the name includes a / like a directory- this causes problems when it is saved
rName = replace(rName,"/","_");	
}
//roiManager("Save", inputDir + "/ROICells_" + StainCell + "/" + name_file + "/" + rName + ".zip");

}
roiManager("reset");
}
//----------------------------------------------finish---------------------------------
//--------------------Store results-----------
if (j>1){
IJ.renameResults("AllCells","Results");	
}
//setResult("# slice", j-1 ,SliceNumber);
setResult("Brain slice", j-1 ,name_file);
setResult("Number of Cells", j-1 ,npvn);
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",outputDir + name_file + "SummaryCounting.xls"); //intermediate result
IJ.renameResults("AllCells");


///---------------------------------------finish-----------------------
//---------------------close no used pictures-------------------------------------
close("use");
close("label");
//----------------------------------------------------
//-------------------Save Roi in the picture------------------
if(r==0){//first selection
selectWindow("Oxytocin");
run("Select None");
run("Duplicate...", " ");
rename("OxytocinP");
} 
if(npvn > 0){
selectWindow("OxytocinP");
roiManager("open",  inputDir + "Pvn.zip");//open the labels
MoveSelection(pos11,pos22);
//save moved rois
roiManager("Save", inputDir + "/ROICells_" + StainCell + "/" + name_file + "/" + rName + ".zip");
Indextype1 = CreateArrayIndex(roiManager("count"));
roiManager("Select", Indextype1);
roiManager("Set Color", "Red");
roiManager("Set Line Width", 3);
roiManager("Show All without labels");
run("Flatten");	
close("OxytocinP");
rename("OxytocinP");
}

roiManager("reset");
/// add the roi 
selectWindow("OxytocinP");
roiManager("open", roi_input ); //add the marked sector
roiManager("select", r);
//roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 10);

run("Flatten");	
close("OxytocinP");
rename("OxytocinP");
///////////////////////////////////////////////
roiManager("reset");
run("Clear Results");

wait(25);
//----------------------

j=j+1;
	
///////			
	
}
//////////////////////////////Save the pictures/////////////////////////////
selectWindow("OxytocinP");

saveAs("Tiff", inputDir + "/LabeledImagesOf" + StainCell + "/" + name_file + "All.tif" );
close("*");
IJ.renameResults("AllCells","Results");
saveAs("Results", outputDir + name_file + "SummaryCounting.xls");
		

