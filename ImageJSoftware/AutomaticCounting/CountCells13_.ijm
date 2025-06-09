/////////////////////////////////////////Auxiliary functions/////////////////////////////

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
  if(areaSelectionV > 2000){ //in the case of fails
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
///////Function to save partial regions
function SaveSubregion(rName,file,StainCell) {
// open overlap regions
roiManager("open", inputDir + "Pvn.zip"); 
Rois=newArray( roiManager("count"));
for (rr = 0; rr< roiManager("count"); rr++) {// to select all
 Rois[rr]=rr;
  }
///////////////////////////////
selectWindow('label'); //with overlap
//roiManager("select",Rois);
//roiManager("show all without labels");
//roiManager("Set Color", "red");
//roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");

selectWindow('use'); //with overlap
run("Duplicate..."," ");
rename('UseR');
selectWindow('use');
roiManager("select",Rois);
roiManager("show all without labels");
roiManager("Set Color", "red");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");

selectWindow('UseR');
run("Flatten");
run("RGB Color");
///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[label-1] image3=[UseR-1]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=1 scale=1 label");
//print( inputDir + "CountingResults" + StainCell + StainNucleus + "/" + rName + "Label" + file);

saveAs("Tiff", inputDir  + "CountingResultsOf" + StainCell + "/" + rName + "Label" + file );
close("Concatenate");
close(rName + "Label" + file);
close('UseR');
///////////////////

 }
//
///////////////////////////////////////////////////////
function SaveSubregion1(rName,file,StainCell) {
//without pvn
selectWindow('use');
run("Flatten");
run("RGB Color");
	
///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[use-1]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=2 rows=1 scale=1 label");
saveAs("Tiff", inputDir + "CountingResultsOf" + StainCell + "\\" + rName + "Label" + file);
close("Concatenate");
close(rName + "Label" + file);
///////////////////

 }

///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////




//Count the cellls
//Count the cellls
///////////////////////////////Begin the program/////////////////////////
 inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
title = "Choose the staining type";
Dialog.create(title);
Dialog.addChoice("Staining of the cell (as oxytocin):", newArray("Cherry", "Oxytocin","Vasopresin","TH","Others")); //this is the name of the folder
Dialog.addCheckbox("Save the subregions images", false);
Dialog.addCheckbox("Images are sorted", false);
Dialog.addNumber("Add scale factor nm per pixel (as 648.4 for 10x):", 648.4);
Dialog.show();
StainCell = Dialog.getChoice();
OptionSave = Dialog.getCheckbox();
Sorting = Dialog.getCheckbox();
scale = Dialog.getNumber();
//Create title for the table
title1 = "#" + " " + StainCell + "cells";
/////////////////////////////////////////////////////
File.makeDirectory(inputDir + "CountingResultsOf" + StainCell  + "/");
File.makeDirectory(inputDir + "LabeledImagesOf" + StainCell + "/");//to save one type of cell

outputDir = inputDir + "CountingResultsOf" + StainCell  + "/";


i=0;
list = getFileList(inputDir+ StainCell +"/");
largo=list.length;
StringyList =newArray(largo);
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }
j=0;
run("Clear Results");

for (i=0; i < largo; i++) {
	showProgress(i+1, list.length);	
	//setBatchMode(true);
	/// get number of slice
if(Sorting){
  SliceNumber = substring(StringyList[i],lastIndexOf(StringyList[i], "_")+1);}
///////////////////// open the roi //////////////////////////
 roiManager("reset");


 roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );
 nR = roiManager("Count");  // number of ROI per image.
  print(nR);     
   for (r = 0; r < nR; r++){ 
   	
   	roiManager("reset");
    roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );

/////////////////////////////////////////////////

///////////////////
if(r==0){//first time which is open
open(inputDir + StainCell + "/"+ list[i]);
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
rename("Oxytocin");  }    
selectWindow("Oxytocin");
run("Select None");//erase previous selection
roiManager("select",r);
rName = Roi.getName(); 
    getSelectionBounds(x, y, width, height); //information about the roi
     print(x);
       print(y);
      pos11 = x;
       pos22 = y;
       areaSelection = width*height;
         widths=width*scale; //for mm
     widths=widths/1000000;
     heights=height*scale;
     heights=heights/1000000;
     areaSelectionS = widths*heights;

run("Duplicate..."," ");
rename('use');
//close("Oxytocin");
roiManager("reset");
//////////////////////////////////////////////////////////

showText("Now is running the slice:"+ rName + " - "+ StringyList[i]);


j=j+1;	

selectWindow('use');
//run("Duplicate...", " ");
//rename("Auxiliary");
//selectWindow('use');
//change ntiles to 6 instead 1
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'use', 'modelChoice':'Model (.zip) from File', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.3', 'nmsThresh':'0.5', 'outputType':'Both', 'modelFile':'X:\\\\Users\\\\LabSoftware\\\\ImageJSoftware\\\\AutomaticCounting\\\\TestModelNewFinalvs4.zip', 'nTiles':'8', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
rename('label');
selectWindow('label');
/////////////////////////////////////////
//------------------------------------------
//------------------------------------------
n=roiManager ("Count");
npvn = n;
print(n);
PvnDelete=newArray(0);
if(npvn > 0){ //in the case that nothing was detected
PvnDelete = RemoveRoiAreas(n,PvnDelete); //Remove big detections that stardist adds

if(PvnDelete.length !=0){
roiManager("select", PvnDelete);
roiManager("delete");} //delete big things
n=roiManager ("Count");
if(n==0){npvn=0; }//after remove of big things
if(npvn>0){
print(n);
PvnRoi=CreateArrayIndex(n); //create array for selection
roiManager("select", PvnRoi);
roiManager("Save", inputDir + "Pvn.zip");
}
roiManager ("Reset");
run("Clear Results");
}

/////////////////////////
//////////////////////////////////////////////////////////Eliminate detection outside the selection region and save again/////////////////////////////////////////////////////////
//////////////////////////////////////////// Remove events outside the desired region /////////////////////////////////
/// Begin for virus return to original picture
if(npvn > 0){
//open(inputDir + StainCell + "/"+ list[i]);
//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
//rename("AuxP");
selectWindow("Oxytocin");
roiManager("open", inputDir + "Pvn.zip");
MoveSelection(pos11,pos22); // Move selection to the original picture

naux1= roiManager("count");// add to this roi
roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );
print(r);
// Remove all selections except the one you are intrested
RegionsToDelete=RemoveNoSelectedRegions(r,nR,naux1);

//Array.print(RegionsToDelete);
if(RegionsToDelete.length !=0){
roiManager("select", RegionsToDelete);
roiManager("delete");}
//////////

indexdel1 = ArrayIndexWithoutSelectionIntersection(); //remove detections not inside the main selection
if(indexdel1.length !=0){ 
   roiManager("select",indexdel1);
   roiManager("delete");}
 ///////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////////////////////
   
MoveSelection(-pos11,-pos22); //Return roi to selected picture
selectWindow('use');
roiManager("select",(roiManager("count")-1));
roiManager("delete"); //delete the big selection
numberCells = roiManager("count");
npvn =  roiManager("count");
if(npvn !=0){
roiManager("Save", inputDir + "Pvn.zip");}
//close("AuxP");

////////////////////////

/////////////////////////////////////////////////
roiManager("reset");
//run("Clear Results");
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////
   }

run("Clear Results");

if (j>1){
IJ.renameResults("AllCells","Results");	
}
if(Sorting){
	setResult("# slice", j-1 ,SliceNumber);
}
setResult("Brain slice", j-1 ,list[i]);
setResult("Number of Cells", j-1 ,npvn);
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",outputDir + "SummaryCounting.xls"); //intermediate result
IJ.renameResults("AllCells");
////////////////////////////////////////////
//The idea is to save partial regions
if(OptionSave){
if( npvn > 0){
SaveSubregion(rName,StringyList[i],StainCell);}

if(npvn == 0){
SaveSubregion1(rName,StringyList[i],StainCell);}
	
}
close("use");
close("label");
////////////////////////Save all the pictures//
roiManager("reset");
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Save pictures
if(r==0){//first selection


selectWindow("Oxytocin");
run("Select None");
run("Duplicate...", " ");
rename("OxytocinP");
} 
roiManager("reset");
if(npvn>0){
selectWindow("OxytocinP");	
roiManager("open",  inputDir + "Pvn.zip");  //type2
MoveSelection(pos11,pos22);
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
roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" ); //add the marked sector
roiManager("select", r);
roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 2);
run("Flatten");	
///////////////////////////////////////////////
roiManager("reset");
run("Clear Results");

wait(25);
}

//////////////////////////////Save the pictures/////////////////////////////
selectWindow("OxytocinP");

saveAs("Tiff", inputDir + "LabeledImagesOf" + StainCell + "\\" + StringyList[i] + "All.tif" );
close("*");
//setBatchMode(false);
}
IJ.renameResults("AllCells","Results");
    saveAs("Results", outputDir +"SummaryCountingFinal.xls");
showMessage("Finished");