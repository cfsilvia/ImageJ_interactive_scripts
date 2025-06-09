/*This script counts the number of nucleus, cfos or dapi on stained slice brains.
 * It counts all the brains by scanning the rectangles of a pre defined grid.
 * The counting used a stardist model for nucleus and filter according area size was added.
 * The filter removes very large and very small detections.
 * Input: directory with 2 folder :e.g. cfos images and ROI with grids for each slice
 * Output1: a folder Counting with csv files. One file for each slice , including the number of cfos per  square in the grid 
 * Output 2: a folder with the labeled images of each slice, marking the cfos.
 * Output 3: a folder inside the roi folder saving the roi cfos of each slice to use for evaluation.
 * 
 */




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
  if(areaSelectionV > 500 || areaSelectionV < 80){ //in the case of fails
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

///////Function to save partial regions
function SaveSubregion(rName,file,StainCell,StainNucleus) {
// open overlap regions
roiManager("open", inputDir + "cfosOxytocinFilterTwo.zip"); 
Rois=newArray( roiManager("count"));
for (rr = 0; rr< roiManager("count"); rr++) {// to select all
 Rois[rr]=rr;
  }
///////////////////////////////
selectWindow('label'); //with overlap
roiManager("select",Rois);
roiManager("show all without labels");
roiManager("Set Color", "red");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
//waitForUser("stop");

selectWindow('use'); //with overlap


//setMinAndMax(0, 120);
roiManager("select",Rois);
roiManager("show all without labels");
roiManager("Set Color", "red");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
//run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");//add 18-04
//run("Enhance Contrast", "saturated=0.35");
//run("Enhance Contrast", "saturated=0.35");
//run("Enhance Contrast", "saturated=0.35");//add 18-04
//run("Enhance Contrast", "saturated=0.35");




selectWindow('useCfos');  //with overlap
//run("Enhance Contrast", "saturated=0.35");
roiManager("select",Rois);
roiManager("show all without labels");
roiManager("Set Color", "red");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");

//////////////////////////
///Add  two images to see the real counts 
 roiManager("reset");
roiManager("open", inputDir + "Cfos.zip"); 
RoisV= CreateArrayIndex(roiManager("count"));
selectWindow('useCfos');
//run("Enhance Contrast", "saturated=0.35");//add 18-04
roiManager("select",RoisV);
roiManager("show all without labels");
roiManager("Set Color", "blue");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
///
 roiManager("reset");
roiManager("open", inputDir + "Pvn.zip"); 
RoisPV=CreateArrayIndex(roiManager("count"));
//waitForUser("stop");
selectWindow('use');
//run("Brightness/Contrast...");
//setMinAndMax(0, 120);
//run("Enhance Contrast", "saturated=0.45");//add 18-04
roiManager("select",RoisPV);
roiManager("show all without labels");
roiManager("Set Color", "blue");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
//run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");//add 18-04
//run("Enhance Contrast", "saturated=0.35");
//run("Enhance Contrast", "saturated=0.35");
//run("Enhance Contrast", "saturated=0.35");//add 18-04
//run("Enhance Contrast", "saturated=0.35");




//waitForUser('stop');
//selectWindow('use-2');


///
	
///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[label-1] image3=[useCfos-1] image4=[use-2] image5=[useCfos-2]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
saveAs("Tiff", inputDir + "CountingResults" + StainCell + StainNucleus + "/" + rName + "Label" + file);
close("Concatenate");
close(rName + "Label" + file);
///////////////////



 
 }

///////////////////////////////////////////////////////
function SaveSubregion1(rName,file,StainCell,StainNucleus) {
//without pvn
//waitForUser("stop");
//selectWindow('use');
selectWindow('label');
run("Flatten");
run("RGB Color");

selectWindow('useCfos'); 
run("Flatten");
run("RGB Color");

//////////////////////////
///Add  two images to see the real counts 
roiManager("reset");
roiManager("open", inputDir + "Cfos.zip"); 
RoisV= CreateArrayIndex(roiManager("count"));
selectWindow('useCfos');
roiManager("select",RoisV);
roiManager("show all without labels");
roiManager("Set Color", "blue");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
///

///
	
///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[label-1] image2=[label-1] image3=[useCfos-1] image4=[label-1] image5=[useCfos-2]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
saveAs("Tiff", inputDir + "CountingResults" + StainCell + StainNucleus + "/" + rName + "Label" + file);
close("Concatenate");
close(rName + "Label" + file);
///////////////////



 
 }

 ////////////////////////////////////
///////Function to save partial regions
function SaveSubregion2(rName,file,StainCell,StainNucleus) {


///////////////////////////////
selectWindow('label'); //with overlap
run("Flatten");
run("RGB Color");
//waitForUser("stop");
selectWindow('use'); //with overlap
run("Flatten");
run("RGB Color");
run("Brightness/Contrast...");
setMinAndMax(0, 50);

selectWindow('useCfos');  //with overlap
//run("Enhance Contrast", "saturated=0.35");
run("Flatten");
run("RGB Color");

//////////////////////////
///Add  two images to see the real counts 

///
 roiManager("reset");
roiManager("open", inputDir + "Pvn.zip"); 
RoisPV=CreateArrayIndex(roiManager("count"));
//waitForUser("stop");
selectWindow('use');
roiManager("select",RoisPV);
roiManager("show all without labels");
roiManager("Set Color", "blue");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
run("Brightness/Contrast...");
setMinAndMax(0, 50);
///
	
///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[label-1] image3=[useCfos-1] image4=[use-2] image5=[useCfos-1]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
saveAs("Tiff", inputDir + "CountingResults" + StainCell + StainNucleus + "/" + rName + "Label" + file);
close("Concatenate");
close(rName + "Label" + file);
///////////////////



 
 }
///////////////////////////////////////////////////
///////Function to save partial regions
function SaveSubregion3(rName,file,StainCell,StainNucleus) {


///////////////////////////////
selectWindow('label'); //with overlap
run("Flatten");
run("RGB Color");
//waitForUser("stop");
selectWindow('use'); //with overlap
run("Flatten");
run("RGB Color");
//run("Brightness/Contrast...");
//setMinAndMax(0, 50);

selectWindow('useCfos');  //with overlap
//run("Enhance Contrast", "saturated=0.35");
run("Flatten");
run("RGB Color");

///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[label-1] image3=[useCfos-1] image4=[use-1] image5=[useCfos-1]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
saveAs("Tiff", inputDir + "CountingResults" + StainCell + StainNucleus + "/" + rName + "Label" + file);
close("Concatenate");
close(rName + "Label" + file);
///////////////////

 }
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Count the cellls
///////////////////////////////Begin the program/////////////////////////
 //inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
 inputDir="/home/labs/kimchi/cfsilvia/Data/ImagesBlindMole/"
//////////////////////////////////////////////////////
//title = "Choose the staining type";
//Dialog.create(title);
//Dialog.addChoice("Staining of the nucleus (as cfos):", newArray("Dapi", "Cfos","Others")); //this is the name of the folder
//Dialog.addCheckbox("Save the subregions images", false);
//Dialog.addNumber("Add scale factor nm per pixel (as 648.4 for 10x):", 648.4);
//Dialog.show();
//StainCell = Dialog.getChoice();
StainNucleus = "Cfos";
OptionSave = false;
scale =648.4;
//Create title for the table
//title1 = "#" + " " + StainCell + "cells";
//print(title1);
title2 = "#" + " " + StainNucleus + "nucleus";
//title3 ="#" + " " + "of overlapped " + StainCell + "and" + StainNucleus ;
print(title2);
//count = 1;
/////////////////////////////////////////////////////
if(File.isDirectory(inputDir + "CountingResults" + StainNucleus + "/")  == 0 ){
File.makeDirectory(inputDir + "CountingResults" + StainNucleus + "/");}
if(File.isDirectory(inputDir + "LabeledImagesOf" + StainNucleus + "/")  == 0 ){
File.makeDirectory(inputDir + "LabeledImagesOf" + StainNucleus + "/");// to save nucleus -cfos
}

///////////////////////////////////////////
list = getFileList(inputDir + StainNucleus + "/");
largo=list.length;
StringyList =newArray(largo);
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }

i=0;

run("Clear Results");
//for (i=0; i < largo; i++)
for (i=0; i < largo; i++) { // go over each slice
	showProgress(i+1, list.length);	
	j=0;
setBatchMode(true);
///////////////////// open the roi //////////////////////////
if(File.isDirectory(inputDir + "ROI/" + StringyList[i] + "/" )  == 0 ){
File.makeDirectory(inputDir + "ROI/" + StringyList[i] + "/");}


/////////////
 roiManager("reset");
   	while ( File.exists(inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip")  == 0 ) { //if file doesnt exit
   		i = i+1;
   		if (i==largo) {
   			showMessage("Finish");
   		}
   		}
 roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );
 nR = roiManager("Count");  // number of ROI per image.
//print(inputDir + "ROI/"+ "RoiSet" + StringyList[i] + ".zip" );
//nR=15;
   for (r = 0; r < nR; r++){ 
   
   	roiManager("reset");
    roiManager("open", inputDir + "ROI/"+ "RoiSet" + StringyList[i] + ".zip" );
 
/////////////////////////////////////////////////
if(r==0){//first time which is open
open(inputDir + StainNucleus + "/"+ list[i]); // open first picture
run("Enhance Contrast", "saturated=0.35"); //adjust original image
rename("Cfos"); }
selectWindow("Cfos");
run("Select None"); //previous selection
roiManager("select",r);
rName = Roi.getName(); 
//get information of the roi selected
 getSelectionBounds(x, y, width, height);
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
 
 //

run("Duplicate..."," "); //take the selection
rename('useCfos');

////////////////////////
showText("Now is running the slice:"+ rName + " - "+ StringyList[i]);

///////////////////
roiManager("reset");
print(rName);
print(r);
/////////////////////////////	
////////////////////////////////////////////////////////////////	

/////////////////////////////////////////////////////////For Cfos////////////////////////////////////////////////////////
ncfos=0;
selectWindow('useCfos');
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'useCfos', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
rename('labelCfos');
selectWindow('labelCfos');
n=roiManager ("Count");
ncfos=n;
print(n);

CfosDelete=newArray(0);
if(ncfos > 0){ //Remove very big areas due to the segmentation
CfosDelete = RemoveRoiAreas(n,CfosDelete);
if(CfosDelete.length !=0){
roiManager("select", CfosDelete);
roiManager("delete");}

n=roiManager ("Count"); //delete no good segmentation
ncfos=n;
if(n==0){ncfos=0; }
// save the cfos roi
if(ncfos > 0){
cfosRoi = CreateArrayIndex(n);
roiManager("select", cfosRoi);
roiManager("Save", inputDir + "Cfos.zip"); //eliminate the last one

}
roiManager ("Reset");

run("Clear Results");


}




///////////////////////////////////////     Save results in a table       //////////////////////////////////////////      //////////////////////


j=j+1;

if (j > 1){
IJ.renameResults("Counting","Results");	
setResult("Brain slice", j-1 ,list[i]);
setResult(title2, j-1 ,ncfos);
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
IJ.renameResults("Counting");
} else{
setResult("Brain slice", j-1 ,list[i]);
setResult(title2, j-1 ,ncfos);
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResults" + StainNucleus + "/"+ StringyList[i] + "SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
	
} 

run("Clear Results");
roiManager("reset");




/////////////////////////
close("labelCfos");
close("useCfos");





////////////////////////////////////////////
//run("Clear Results");
roiManager("reset");
//run("Clear Results");
///////////////////////////////////////////////////////////////////////////////////////Save the pictures as montage////////////////////////////////////
//Save pictures
if(r==0){
 //first selection
selectWindow("Cfos");

run("Brightness/Contrast...");
run("Select None");
run("Duplicate...", " ");

rename("CfosP");
run("Red");}
//run("Brightness/Contrast...");
//run("Enhance Contrast");



roiManager("reset");
//add virus selection
if(ncfos > 0){
selectWindow("CfosP");	
roiManager("open", inputDir + "Cfos.zip"); //add type1
MoveSelection(pos11,pos22);
Indextype2 = CreateArrayIndex(roiManager("count"));
roiManager("Select", Indextype2);
roiManager("Save", inputDir + "ROI/" + StringyList[i] + "/" + rName + "Cfos.zip");
roiManager("Set Color", "Magenta");
roiManager("Set Line Width", 3);
roiManager("Show All without labels");
run("Flatten");	
close("CfosP");
rename("CfosP");
//selectWindow("Overlay");	
//roiManager("Select", Indextype2);
//roiManager("Set Color", "Magenta");
//roiManager("Set Line Width", 3);
//roiManager("Show All without labels");
//run("Flatten");	
//close("Overlay");
//rename("Overlay");
}


roiManager("reset");
//save each roi


//
roiManager("reset");

}


//////////////////////////////Save the pictures/////////////////////////////

selectWindow("CfosP");
saveAs("Tiff", inputDir + "LabeledImagesOf" + StainNucleus + "\\" + StringyList[i] + "All.tif" );
IJ.renameResults("Counting","Results");
saveAs("Results",inputDir + "CountingResults" + StainNucleus + "/"+ StringyList[i] + "SummaryCounting.xls");
//////////////////////////////////////////////////////////////////////////////////
run("Clear Results");
close("*");
setBatchMode(false);
}

 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//IJ.renameResults("Counting","Results");
//saveAs("Results",inputDir + "CountingResults" + StainNucleus + "/"+"SummaryCounting.xls");
showMessage("Finished");