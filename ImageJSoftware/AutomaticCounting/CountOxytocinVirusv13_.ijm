
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
//////////////////////////////////////////////////////////////
///////Function to save partial regions
function SaveSubregion(rName,file,StainCell,StainNucleus) {
// open overlap regions
roiManager("open", inputDir + "VirusOxytocinFilterTwo.zip"); 
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

selectWindow('use'); //with overlap
roiManager("select",Rois);
roiManager("show all without labels");
roiManager("Set Color", "red");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");

selectWindow('useVirus');  //with overlap
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
roiManager("open", inputDir + "Virus.zip"); 
RoisV= CreateArrayIndex(roiManager("count"));
selectWindow('useVirus');
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
selectWindow('use');
roiManager("select",RoisPV);
roiManager("show all without labels");
roiManager("Set Color", "blue");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
///
	
///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[label-1] image3=[useVirus-1] image4=[use-2] image5=[useVirus-2]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
//print( inputDir + "CountingResults" + StainCell + StainNucleus + "/" + rName + "Label" + file);

saveAs("Tiff", inputDir  + "CountingResultsOf" + StainCell + StainNucleus + "\\" + rName + "Label" + file );
close("Concatenate");
close(rName + "Label" + file);
///////////////////



 
 }

///////////////////////////////////////////////////////
function SaveSubregion1(rName,file,StainCell,StainNucleus) {
//without pvn
selectWindow('use');
run("Flatten");
run("RGB Color");

selectWindow('useVirus'); 
run("Flatten");
run("RGB Color");

//////////////////////////
///Add  two images to see the real counts 
roiManager("reset");
roiManager("open", inputDir + "Virus.zip"); 
RoisV= CreateArrayIndex(roiManager("count"));
selectWindow('useVirus');
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
run("Concatenate...", "open image1=[use-1] image2=[use-1] image3=[useVirus-1] image4=[use-1] image5=[useVirus-2]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
saveAs("Tiff", inputDir + "CountingResultsOf" + StainCell + StainNucleus + "\\" + rName + "Label" + file);
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

selectWindow('use'); //with overlap
run("Flatten");
run("RGB Color");

selectWindow('useVirus');  //with overlap
//run("Enhance Contrast", "saturated=0.35");
run("Flatten");
run("RGB Color");

//////////////////////////
///Add  two images to see the real counts 

///
 roiManager("reset");
roiManager("open", inputDir + "Pvn.zip"); 
RoisPV=CreateArrayIndex(roiManager("count"));
selectWindow('use');
roiManager("select",RoisPV);
roiManager("show all without labels");
roiManager("Set Color", "blue");
roiManager("Set Line Width", 2);
run("Flatten");
run("RGB Color");
///
	
///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[label-1] image3=[useVirus-1] image4=[use-2] image5=[useVirus-1]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
saveAs("Tiff", inputDir + "CountingResultsOf" + StainCell + StainNucleus + "\\" + rName + "Label" + file);
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

selectWindow('use'); //with overlap
run("Flatten");
run("RGB Color");

selectWindow('useVirus');  //with overlap
//run("Enhance Contrast", "saturated=0.35");
run("Flatten");
run("RGB Color");

///////////////////////////////////////    
 // concatenate the images	
run("Concatenate...", "open image1=[use-1] image2=[label-1] image3=[useVirus-1] image4=[use-1] image5=[useVirus-1]");
rename("Concatenate");
selectWindow("Concatenate");
run("Make Montage...", "columns=3 rows=2 scale=1 label");
saveAs("Tiff", inputDir + "CountingResultsOf" + StainCell + StainNucleus + "\\" + rName + "Label" + file);
close("Concatenate");
close(rName + "Label" + file);
///////////////////
 
 }
/////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////Begin the program//////////////////////////////////////////////////////////////////////////
 inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
title = "Choose the staining type";
Dialog.create(title);
Dialog.addChoice("First Staining (as oxytocin):", newArray("Cherry", "Oxytocin","Vasopresin","TH","Others")); //this is the name of the folder
Dialog.addChoice("Second Staining (as cherry):", newArray("Cherry", "Oxytocin","Vasopresin","TH","Others")); //this is the name of the folder
Dialog.addCheckbox("Save the subregions images", false);
Dialog.addCheckbox("Images are sorted", false);
Dialog.addNumber("Add scale factor nm per pixel (as 648.4 for 10x):", 648.4);
Dialog.show();
type1 = Dialog.getChoice();
type2 = Dialog.getChoice();
OptionSave = Dialog.getCheckbox();
Sorting = Dialog.getCheckbox();
scale = Dialog.getNumber();
//Create title for the table
title1 = "#" + " " + type1 + "cells";
print(title1);
title2 = "#" + " " + type2 + "cells";
title3 ="#" + " " + "of overlapped cells" + type1 + "and" + type2 ;
print(title3);
/////////////////////////////////////////////////////////////////////////////////////////////////////
//Count the cellls

File.makeDirectory(inputDir + "CountingResultsOf" + type1 + type2 +"/");
File.makeDirectory(inputDir + "LabeledImagesOf" + type1 + "/");//to save one type of cell
File.makeDirectory(inputDir + "LabeledImagesOf" + type2 + "/");// to save second type of cell
File.makeDirectory(inputDir + "LabeledImagesOf" + type1 + type2 + "/");// to save the intersection
////////////////////
list = getFileList(inputDir + type1 +"/");
largo=list.length;
StringyList =newArray(largo); //to get the name of the file
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }
j=0;
i=0;

run("Clear Results");
 
//for (i=0; i < largo; i++) {
	for (i=0; i < largo; i++)  {
		showProgress(i+1, list.length);	
		//setBatchMode(true);
/// get number of slice
if(Sorting){
  SliceNumber = substring(StringyList[i],lastIndexOf(StringyList[i], "_")+1);}
///////////////////// open the roi //////////////////////////
 roiManager("reset");
 roiManager("open", inputDir + "ROI/" +"RoiSet"+ StringyList[i] + ".zip" );
 nR = roiManager("Count");  // number of ROI per image.
  print(nR);     
   for (r = 0; r < nR; r++){ 
   	
   	roiManager("reset");
    roiManager("open", inputDir + "ROI/" +"RoiSet"+ StringyList[i] + ".zip" );
///////////////////////////////////////////////// /////////////////////
if(r==0){//first time which is open
open(inputDir + type2 + "\\"+ list[i]); //add first picture
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
rename("Virus");   }   
selectWindow("Virus");
run("Select None"); //previous selection
roiManager("select",r);
// Get information of the roi
    rName = Roi.getName(); 
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
run("Duplicate..."," ");
rename('useVirus');
//close("Virus");

////////////////////////
showText("Now is running the slice:"+ rName + " - "+ StringyList[i]);

///////////////////
if(r==0){//first time which is open
open(inputDir + type1 + "\\"+ list[i]);
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
rename("Oxytocin"); }     
selectWindow("Oxytocin");
run("Select None");//erase previous selection
roiManager("select",r);

run("Duplicate..."," ");
rename('use');
//close("Oxytocin");
//waitForUser;

roiManager("reset");

/////////////////////////////	
////////////////////////////////////////////////////////////////	


/////////////////////////////////////////////////////////For Virus begin segmentation ////////////////////////////////////////////////////////
selectWindow('useVirus');
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'useVirus', 'modelChoice':'Model (.zip) from File', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.3', 'nmsThresh':'0.5', 'outputType':'Both', 'modelFile':'X:\\\\Users\\\\LabSoftware\\\\ImageJSoftware\\\\AutomaticCounting\\\\TestModelNewFinalvs4.zip', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
rename('labelVirus');
selectWindow('labelVirus');
n=roiManager ("Count");
nvirus=n;
print(n);
VirusDelete=newArray(0);
if(nvirus > 0){ //Remove very big areas due to the segmentation
VirusDelete = RemoveRoiAreas(n,VirusDelete);
if(VirusDelete.length !=0){
roiManager("select", VirusDelete);
roiManager("delete");}

n=roiManager ("Count"); //delete no good segmentation
if(n==0){nvirus=0; }
if(nvirus > 0){
VirusRoi=CreateArrayIndex(n);
roiManager("select", VirusRoi); //For Selection
roiManager("Save", inputDir + "Virus.zip"); //save the shifted selection
}
roiManager ("Reset");

run("Clear Results");
}

/////////////////////////
//////////////////////////////////////////////////////////Eliminate detection outside the selection region and save again/////////////////////////////////////////////////////////
//////////////////////New addition ///
//roiManager("reset");

//////////////////////////////////////////// Remove events outside the desired region /////////////////////////////////
/// Begin for virus return to original picture
if(nvirus > 0){
//open(inputDir + type2 + "\\"+ list[i]);
//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
//rename("AuxT");
selectWindow("Virus");
roiManager("open", inputDir + "Virus.zip");

MoveSelection(pos11,pos22); //Move the selection to the original position
naux1= roiManager("count");// add to this roi
roiManager("open", inputDir + "ROI/" +"RoiSet"+ StringyList[i] + ".zip" );
print(r);
// Remove all selections except the one you are intrested, only left the intrested roi
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
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////
   
MoveSelection(-pos11,-pos22); //Return roi to selected picture
selectWindow('useVirus');
roiManager("select",(roiManager("count")-1));
roiManager("delete");
InfCells = roiManager("count");
nvirus = roiManager("count");
if(nvirus !=0){
roiManager("Save", inputDir + "Virus.zip");}
//close("AuxT");
}
//reset the system

//Addition to check
//close('labelVirus');
//close('useVirus'); //no pictures
roiManager("reset");
////////////////////////
///////////////////////////////////////////////////////For oxytocin////////////////////////////////////////////////////////
selectWindow('use');
//waitForUser;
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'use', 'modelChoice':'Model (.zip) from File', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.3', 'nmsThresh':'0.5', 'outputType':'Both', 'modelFile':'X:\\\\Users\\\\LabSoftware\\\\ImageJSoftware\\\\AutomaticCounting\\\\TestModelNewFinalvs4.zip', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
rename('label');
selectWindow('label');
//waitForUser;
//------------------------------------------
n=roiManager ("Count");
npvn = n;
print(n);
PvnDelete=newArray(0);
if(npvn > 0){ //in the case that nothing was detected
PvnDelete = RemoveRoiAreas(n,PvnDelete); //Remove big detections that stardist adds
if(PvnDelete.length !=0){
roiManager("select", PvnDelete);
roiManager("delete");}


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
//////////////////////New addition ///
//roiManager("reset");

//////////////////////////////////////////// Remove events outside the desired region /////////////////////////////////
/// Begin for virus return to original picture
if(npvn > 0){
//open(inputDir + type1 + "/"+ list[i]);
//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
//rename("AuxP");
selectWindow("Oxytocin");
roiManager("open", inputDir + "Pvn.zip");
MoveSelection(pos11,pos22); // Move selection to the original picture
naux2= roiManager("count");// add to this roi
roiManager("open", inputDir + "ROI/" +"RoiSet"+ StringyList[i] + ".zip" );
// Remove all selections except the one you are intrested,left roi you are intrested
RegionsToDelete2=RemoveNoSelectedRegions(r,nR,naux2);

//Array.print(RegionsToDelete2);
if(RegionsToDelete2.length !=0){
roiManager("select", RegionsToDelete2);
roiManager("delete");}
//////////
indexdel1 = ArrayIndexWithoutSelectionIntersection(); //remove detections not inside the main selection
if(indexdel1.length !=0){ 
   roiManager("select",indexdel1);
   roiManager("delete");}

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////
MoveSelection(-pos11,-pos22); //Return roi to selected picture
selectWindow('use');
roiManager("select",(roiManager("count")-1));
roiManager("delete");
PvnCells = roiManager("count");
npvn =  roiManager("count");
if(npvn !=0){
roiManager("Save", inputDir + "Pvn.zip");} //only when npvn different from zero
//close("AuxP");
}
//reset the system

//Addition to check
//close('label');
//close('use'); //no pictures
roiManager("reset");
//left only one picture open for the roimanager
////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////Find intersection between each pnv and the virus infected cells ///////////////////////

//roiManager("Open", inputDir + "Pvn.zip"); //oxytocin
//Num1 = roiManager("count");
selectWindow("use");
if(nvirus > 0 && npvn > 0){// the two cases must be positive
roiManager("Open", inputDir + "Pvn.zip"); //oxytocin
Num1 = roiManager("count");	
roiManager("Open", inputDir + "Virus.zip");//virus
Num2 = roiManager("count");
countAux = 0;
IndexDetected = newArray(0);
IndexSPVN = newArray(0);
IndexSVirus = newArray(0);
for (index = 0; index < Num1; index++){ // loop over the oxytocin cells

	for (indexVirus = Num1 ; indexVirus < Num2; indexVirus++){ // loop over Virus
		roiManager("select",newArray(index,indexVirus)); //find the 2 together
		roiManager("AND"); //find joining
		
		if (selectionType >-1 )	{// if it is overlapped
		  roiManager("add"); //add the selectionat the end of the list
		  
          IndexDetected =Array.concat(IndexDetected,(Num2+countAux));
          roiManager("select", (Num2+countAux) );
          roiManager("rename", "S"+countAux);
          IndexSPVN  =Array.concat(IndexSPVN ,index);
          IndexSVirus =Array.concat(IndexSVirus,indexVirus);
           
           countAux= countAux +1; 
		}		
	}

}
//Array.print(IndexDetected);
//Array.print(IndexSPVN);
//Array.print(IndexSVirus);
//print(IndexDetected.length);
//print(IndexSPVN.length);
//print(IndexSVirus.length);
//selectWindow('label');
roiManager("select", IndexDetected);
roiManager("save selected", inputDir + "VirusOxytocin.zip"); 
//
//roiManager("draw");

///////////////////////////////////////////////Filter1 - The idea is to capture only if the selection area is almost similar to the oxytocin cell/////////////////////////////////////////
row=0;
count=0;
IndexDetectedFilterSize=newArray(0);
IndexSPVNFilterSize=newArray(0);
IndexSVirusFilterSize=newArray(0);
/////////////For each selection with all the coordinates pvn, cfos and selection - eliminate those whose cfos are much bigger than the selection.since the selection must be like cfos////////////////////////////////
for (in=0; in<IndexDetected.length; in++) {
 
//////////////////////////////////////////////////////////////////////
 // find all the coordinates of the virus roi
       roiManager("deselect");
       roiManager("select",IndexSVirus[in]);
       Roi.getContainedPoints(xVirus, yVirus); 
  //find all the coordinat of pvn     
       roiManager("deselect");
       roiManager("select",IndexSPVN[in]);
       Roi.getContainedPoints(xPVN, yPVN);
///////////////////////////////////////////////////////find if one region is inside the other////////////////////////////

     UnionLength = ArrayUnion(xPVN,yPVN,xVirus,yVirus);

     print(UnionLength);
     print(xPVN.length);
     print(xVirus.length);
              if((UnionLength > 0.6*xPVN.length)|| (UnionLength > 0.6*xVirus.length)){ //the idea is that if the selection has the same size of the virus or pvn then one cell is inside the other
                   //all the roi is included into the pvn then considered the selection
                       	     IndexDetectedFilterSize  = Array.concat(IndexDetectedFilterSize ,IndexDetected[in]); //only index with that condition for selection
              	             IndexSVirusFilterSize  = Array.concat(IndexSVirusFilterSize ,IndexSVirus[in]); //only index with that condition for cfos
              	             IndexSPVNFilterSize  = Array.concat(IndexSPVNFilterSize ,IndexSPVN[in]); //only index with that condition for pvn
                     
              	
              }
                  
  }
///////////////////////////////////////////////////////////////////////////////////      


// not valid for one element
//Array.print(IndexDetectedFilterSize);
//Array.print(IndexSPVNFilterSize);
//Array.print(IndexSVirusFilterSize);
//print(IndexDetectedFilterSize.length);
//print(IndexSPVNFilterSize.length);
//print(IndexSVirusFilterSize.length);
//print(Num1);
//print(Num2);

selectWindow('label');
roiManager("select", IndexDetectedFilterSize);
roiManager("save selected", inputDir + "VirusOxytocinFilterOne.zip"); 
//roiManager("draw");


///////////////////////////////////////////////////////////////////////////Filter2 removing double detection in the same cell/////////////////////////
//////////////////////////In case of duplicate took the first selection///////////////////////////////
array1 = IndexDetectedFilterSize; 
array2 = IndexSPVNFilterSize;
array3 = IndexSVirusFilterSize;


Array.sort(array2, array1, array3); //sort according to PVN // not valid for one element
//Array.show(array2, array1, array3);	
	
	array 	= Array.concat(array2, 999999);
	uniquePVN = newArray();
	uniqueVirus = newArray();
	uniqueSelection = newArray();
	ip = 0;	
   	while (ip<(array.length)-1) {
		if (array[ip] == array[(ip)+1]) {
			//print("found: "+array[i]);			

		} else {
			uniquePVN = Array.concat(uniquePVN, array[ip]);
			uniqueVirus = Array.concat(uniqueVirus, array3[ip]);
			uniqueSelection = Array.concat(uniqueSelection, array1[ip]);
		}
   		ip++;
   	}
	
Array.show(uniqueSelection,uniquePVN, uniqueVirus);	
selectWindow('label');
roiManager("deselect");
roiManager("select",uniqueSelection);
roiManager("save selected", inputDir + "VirusOxytocinFilterTwo.zip"); 
//roiManager("draw");
//print(uniqueSelection.length);
//NumberOfVirusOxytocin = uniqueSelection.length;
//NumberOfOxytocin = PvnRoi.length;
//NumberOfInfectedCells=VirusRoi.length;

//// Remove double detection of the virus///////////////////////////////
array1a = uniqueVirus; 
array2a = uniquePVN;
array3a = uniqueSelection;


Array.sort(array1a, array2a, array3a); //sort according to virus // not valid for one element
//Array.show(array2, array1, array3);	
	
	array1a 	= Array.concat(array1a, 999999);
	unique1PVN = newArray();
	unique1Virus = newArray();
	unique1Selection = newArray();
	ip1 = 0;	
   	while (ip1<(array1a.length)-1) {
		if (array1a[ip1] == array1a[(ip1)+1]) {
			//print("found: "+array[i]);			

		} else {
			unique1PVN = Array.concat(unique1PVN, array2a[ip1]);
			unique1Virus = Array.concat(unique1Virus, array1a[ip1]);
			unique1Selection = Array.concat(unique1Selection, array3a[ip1]);
		}
   		ip1++;
   	}
	
Array.show(unique1Selection,unique1PVN, unique1Virus);	
selectWindow('label');
roiManager("deselect");
roiManager("select",unique1Selection);
roiManager("save selected", inputDir + "VirusOxytocinFilterTwo.zip"); 
//roiManager("draw");
//print(uniqueSelection.length);
NumberOfVirusOxytocin = unique1Selection.length;
//NumberOfOxytocin = PvnRoi.length;
//NumberOfInfectedCells=VirusRoi.length;
NumberOfInfectedCells = InfCells; 
NumberOfOxytocin = PvnCells; 
print("Oxytocin:");
print(NumberOfOxytocin);
print("infected:" );
print(NumberOfInfectedCells); 
////////////////////////////////////
///////////////////////////////////////     Save results in a table       //////////////////////////////////////////      //////////////////////
run("Clear Results");

j=j+1;

if (j>1){
IJ.renameResults("Counting","Results");	
if(Sorting){
	setResult("# slice", j-1 ,SliceNumber);
}
setResult("Brain slice", j-1 ,list[i]);
setResult(title1 , j-1 ,NumberOfOxytocin  );
setResult(title2 , j-1 ,NumberOfInfectedCells  ); //for example cherry infected virus cells
setResult(title3 , j-1 ,NumberOfVirusOxytocin ); //overlapped cells 
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResultsOf" + type1 + type2 +"/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
} else{
if(Sorting){
	setResult("# slice", j-1 ,SliceNumber);
}
setResult("Brain slice", j-1 ,list[i]);
setResult(title1 , j-1 ,NumberOfOxytocin  );
setResult(title2 , j-1 ,NumberOfInfectedCells  );
setResult(title3 , j-1 ,NumberOfVirusOxytocin );
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResultsOf" + type1 + type2 +"/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
	
}
run("Clear Results");
roiManager("reset");
//run("Clear Results");


} else {

j=j+1;

if (j>1){
IJ.renameResults("Counting","Results");	
if(Sorting){
	setResult("# slice", j-1 ,SliceNumber);
}
setResult("Brain slice", j-1 ,list[i]);
setResult(title1 , j-1 ,npvn); //example oxytocin cells
setResult(title2 , j-1 ,nvirus );//example cherry infected cells 
setResult(title3 , j-1 ,0 ); //example overlap cells
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResultsOf" + type1 + type2 +"/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
} else{
if(Sorting){
	setResult("# slice", j-1 ,SliceNumber);
}
setResult("Brain slice", j-1 ,list[i]);
setResult(title1 , j-1 ,npvn);
setResult(title2 , j-1 ,nvirus );
setResult(title3 , j-1 ,0 );
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResultsOf" + type1 + type2 +"/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
	
}

}

///////////////////////////////
//The idea is to save partial regions
if(OptionSave){
if(nvirus > 0 && npvn > 0){
SaveSubregion(rName,StringyList[i],type1,type2);}

if(nvirus > 0 && npvn == 0){
SaveSubregion1(rName,StringyList[i],type1,type2);}


if(nvirus == 0 && npvn > 0){
SaveSubregion2(rName,StringyList[i],type1,type2);}

if(nvirus == 0 && npvn == 0){
SaveSubregion3(rName,StringyList[i],type1,type2);}

	
}


/////////////////////////////////
close("labelVirus");
close("useVirus");
close("use");
close("label");

////////////////////////////////////////////////////////

roiManager("reset");
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Save pictures
if(r==0){//first selection
selectWindow("Virus");
run("Select None");
run("Duplicate...", " ");
rename("VirusP");
run("Red");
//run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");

selectWindow("Oxytocin");
run("Select None");
run("Duplicate...", " ");
rename("OxytocinP");
//run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");
run("Select None");
run("Duplicate...", " ");
run("Add Image...", "image=VirusP x=0 y=0 opacity=40");//overlay image
run("Flatten");
close("OxytocinP-1");
rename("Overlay");
} 
roiManager("reset");
//add virus selection
if(nvirus>0){
selectWindow("VirusP");	
roiManager("open", inputDir + "Virus.zip"); //add type1
MoveSelection(pos11,pos22);
Indextype2 = CreateArrayIndex(roiManager("count"));
roiManager("Select", Indextype2);
roiManager("Set Color", "Magenta");
roiManager("Set Line Width", 3);
roiManager("Show All without labels");
run("Flatten");	
close("VirusP");
rename("VirusP");
selectWindow("Overlay");	
roiManager("Select", Indextype2);
roiManager("Set Color", "Magenta");
roiManager("Set Line Width", 3);
roiManager("Show All without labels");
run("Flatten");	
close("Overlay");
rename("Overlay");
}
roiManager("reset");
//add pvn
if(npvn>0){
selectWindow("OxytocinP");	
roiManager("open",  inputDir + "Pvn.zip");  //type2
MoveSelection(pos11,pos22);
Indextype1 = CreateArrayIndex(roiManager("count"));
roiManager("Select", Indextype1);
roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 3);
roiManager("Show All without labels");
run("Flatten");	
close("OxytocinP");
rename("OxytocinP");
selectWindow("Overlay");
roiManager("Select", Indextype1);
roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 3);
roiManager("Show All without labels");
run("Flatten");
close("Overlay");
rename("Overlay");	
}
roiManager("reset");
//overlapping
if(nvirus >0 && npvn >0){
selectWindow("Overlay");
roiManager("open", inputDir + "VirusOxytocinFilterTwo.zip"); 
MoveSelection(pos11,pos22); //Move the selection to the original position
Indextype3 = CreateArrayIndex(roiManager("count"));
roiManager("Select", Indextype3);
roiManager("Set Fill Color", "red");
roiManager("Show All without labels");	
run("Flatten");
close("Overlay");
rename("Overlay");	
}
//mark the region
selectWindow("Overlay");
roiManager("reset");
roiManager("open", inputDir + "ROI/" +"RoiSet"+ StringyList[i] + ".zip" ); //add the marked sector
roiManager("select", r);
roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 2);
//roiManager("Show All without labels");
run("Flatten");
close("Overlay");
rename("Overlay");	
selectWindow("OxytocinP");	
roiManager("select", r);
roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 2);
//roiManager("Show All without labels");
run("Flatten");	
close("OxytocinP");
rename("OxytocinP");
selectWindow("VirusP");	
roiManager("select", r);
roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 2);
//roiManager("Show All without labels");
run("Flatten");	
close("VirusP");
rename("VirusP");
roiManager("reset");
}

//////////////////////////////Save the pictures/////////////////////////////
selectWindow("OxytocinP");

saveAs("Tiff", inputDir + "LabeledImagesOf" + type1 + "\\" + StringyList[i] + "All-1.tif" );
selectWindow("VirusP");
saveAs("Tiff", inputDir + "LabeledImagesOf" + type2 + "\\" + StringyList[i] + "All-2.tif" );
selectWindow("Overlay");
saveAs("Tiff", inputDir + "LabeledImagesOf" + type1 + type2 + "\\" + StringyList[i] + "All3.tif" );
//////////////////////////////////////////////////////////////////////////////////
close("*");
///setBatchMode(false);
}

 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
selectWindow("Counting");
IJ.renameResults("Counting","Results");
saveAs("Results",inputDir + "CountingResultsOf" + type1 + type2 +"/"+"SummaryCountingFinal.xls");
showMessage("Finished");



//////////////////////////////
/////////////////////////////////////////
///////////////////
