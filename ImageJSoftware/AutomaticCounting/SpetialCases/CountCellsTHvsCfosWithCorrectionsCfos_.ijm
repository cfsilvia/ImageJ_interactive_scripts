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

////////////////////////////////////////////////////////////
function RemoveRoiAreasCfos(n,VirusDelete) {
for (ii = 0; ii < n; ii++) { //remove from roi undesired roi
  roiManager("select", ii);
  roiManager("measure");
  areaSelectionV = getResult('Area',ii);
  circSelectionV = getResult('Circ.',ii);
  if((areaSelectionV > 400) || (circSelectionV < 0.9)){ //in the case of fails
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
  inputDir = getArgument();
 

//////////////////////////////////////////////////////
StainCell = "TH";
StainNucleus = "Cfos";
OptionSave = true;
scale = 648.4;

//Create title for the table
title1 = "#" + " " + StainCell + "cells";
print(title1);
title2 = "#" + " " + StainNucleus + "nucleus";
title3 ="#" + " " + "of overlapped " + StainCell + "and" + StainNucleus ;
print(title3);

/////////////////////////////////////////////////////
File.makeDirectory(inputDir + "CountingResults" + StainCell + StainNucleus + "/");
File.makeDirectory(inputDir + "LabeledImagesOf" + StainCell + "/");//to save  type of cell
File.makeDirectory(inputDir + "LabeledImagesOf" + StainNucleus + "/");// to save nucleus -cfos
File.makeDirectory(inputDir + "LabeledImagesOf" + StainCell + StainNucleus+ "/");// to save the intersection
///////////////////////////////////////////
list = getFileList(inputDir + StainCell + "/");
largo=list.length;
StringyList =newArray(largo);
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }
j=0;
i=0;
run("Set Measurements...", "area mean shape integrated limit redirect=None decimal=5");
run("Clear Results");
//for (i=0; i < largo; i++)
for (i=0; i < largo; i++) {
	showProgress(i+1, list.length);	
//	setBatchMode(true);
///////////////////// open the roi //////////////////////////
 roiManager("reset");
  // 	while ( File.exists(inputDir + "ROI/" + StringyList[i] + ".zip")  == 0 ) { //if file doesnt exit
 //  		i = i+1;
//   		if (i==largo) {
 //  			showMessage("Finish");
 //  		}
 //  		}
 roiManager("open", inputDir + "ROI/" + StringyList[i] + ".zip" );
 nR = roiManager("Count");  // number of ROI per image.
  print(nR);     
   for (r = 0; r < nR; r++){ 
   	
   	roiManager("reset");
    roiManager("open", inputDir + "ROI/" + StringyList[i] + ".zip" );
/////////////////////////////////////////////////
if(r==0){//first time which is open
open(inputDir + StainNucleus + "/"+ list[i]);
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
//close("Cfos");

////////////////////////
showText("Now is running the slice:"+ rName + " - "+ StringyList[i]);

///////////////////
if(r==0){//first time which is open
open(inputDir + StainCell + "/"+ list[i]);
rename("Oxytocin"); }
selectWindow("Oxytocin");
run("Select None");//erase previous selection
roiManager("select",r);

run("Duplicate..."," ");
rename('use');
//close("Oxytocin");

roiManager("reset");

print(rName);
print(r);
/////////////////////////////	
////////////////////////////////////////////////////////////////	


/////////////////////////////////////////////////////////For Cfos- Before probThresh was 0.5////////////////////////////////////////////////////////
selectWindow('useCfos');
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'useCfos', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.6', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
rename('labelCfos');
selectWindow('labelCfos');
n=roiManager ("Count");
ncfos=n;
print(n);

CfosDelete=newArray(0);
if(ncfos > 0){ //Remove very big areas due to the segmentation
CfosDelete = RemoveRoiAreasCfos(n,CfosDelete);
if(CfosDelete.length !=0){
roiManager("select", CfosDelete);
roiManager("delete");}

n=roiManager ("Count"); //delete no good segmentation
if(n==0){ncfos=0; }

if(ncfos > 0){
cfosRoi = CreateArrayIndex(n);
roiManager("select", cfosRoi);
roiManager("Save", inputDir + "Cfos.zip");

}
roiManager ("Reset");

run("Clear Results");


}
/////////////////////////
//////////////////////////////////////////////////////////Eliminate detection outside the selection region and save again/////////////////////////////////////////////////////////
//////////////////////////////////////////// Remove events outside the desired region /////////////////////////////////
/// Begin for virus return to original picture
if(ncfos > 0){
//open(inputDir + StainNucleus + "/"+ list[i]);
//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
//rename("AuxT");

selectWindow("Cfos");
roiManager("open", inputDir + "Cfos.zip");
MoveSelection(pos11,pos22); //Move the selection to the original position
naux1= roiManager("count");// add to this roi
roiManager("open", inputDir + "ROI/" + StringyList[i] + ".zip" ); //open original selection
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
   roiManager("delete");} //delete all the irrelevant points
////////////////////////////
////////////////////////////
MoveSelection(-pos11,-pos22); //Return roi to selected picture
selectWindow('useCfos');
roiManager("select",(roiManager("count")-1));
roiManager("delete");
ncfos = roiManager("count");

if(ncfos !=0){
roiManager("Save", inputDir + "Cfos.zip");}
//close("AuxT");
}
roiManager("reset");
////////////////////////

///////////////////////////////////////////////////////For PVN oxytocin probThresh 0.3 for TH////////////////////////////////////////////////////////
 
selectWindow('use');
//waitForUser('stop');
//
//getRawStatistics(nPixels, Mean, min, max, std, histogram);
//run("Threshold...");
//setAutoThreshold("Default dark");
//setThreshold(0, 0.75 * Mean);
//waitForUser('stop');
//
//selectWindow('use');
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'use', 'modelChoice':'Model (.zip) from File', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.3', 'nmsThresh':'0.5', 'outputType':'Both', 'modelFile': 'X:\\\\Users\\\\LabSoftware\\\\ImageJSoftware\\\\AutomaticCounting\\\\TestModelNewFinalvs4.zip', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");


rename('label');
selectWindow('label');

//------------------------------------------
n=roiManager ("Count");
print(n);
npvn = n;
PvnDelete=newArray(0);
if(npvn > 0){
PvnDelete = RemoveRoiAreas(n,PvnDelete); //Remove big detections that stardist adds
if(PvnDelete.length !=0){
roiManager("select", PvnDelete);
roiManager("delete");}
n=roiManager ("Count");
print(n);
//PvnRoi=newArray(n);
if(n==0){npvn=0; }
if(npvn>0){
PvnRoi=CreateArrayIndex(n); //create array for selection
roiManager("select", PvnRoi);
roiManager("Save", inputDir + "Pvn.zip");
}
roiManager ("Reset");
run("Clear Results");
}
//print(npvn);
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

naux2= roiManager("count");// add to this roi
roiManager("open", inputDir + "ROI/" + StringyList[i] + ".zip" );
// Remove all selections except the one you are intrested
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
   
MoveSelection(-pos11,-pos22); //Return roi to selected picture
selectWindow('use');
roiManager("select",(roiManager("count")-1));
roiManager("delete");
NumberOfOxytocin  = roiManager("count");
npvn =  roiManager("count");
if(npvn !=0){
roiManager("Save", inputDir + "Pvn.zip");}
//close("AuxP");
}
////////////////////////

roiManager("reset");

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////Find intersection between each pnv and the cfos ///////////////////////
if(ncfos > 0 && npvn > 0){
roiManager("Open", inputDir + "Pvn.zip"); //oxytocin
Num1 = roiManager("count");
roiManager("Open", inputDir + "Cfos.zip");//cfos
Num2 = roiManager("count");
countAux = 0;
IndexDetected=newArray(0);
IndexSPVN=newArray(0);
IndexSCfos=newArray(0);
for (index = 0; index < Num1; index++){ // loop over the oxytocin cells

	for (indexcfos = Num1 ; indexcfos < Num2; indexcfos++){ // loop over cfos
		roiManager("select",newArray(index,indexcfos));
		roiManager("AND"); //find joining
		
		if (selectionType >-1 )	{// if it is overlapped
		  roiManager("add"); //add the selectionat the end of the list
		  
             IndexDetected =Array.concat(IndexDetected,(Num2+countAux));
             roiManager("select", (Num2+countAux) );
            roiManager("rename", "S"+countAux);
            IndexSPVN  =Array.concat(IndexSPVN ,index);
            IndexSCfos =Array.concat(IndexSCfos,indexcfos);
           
           countAux= countAux +1;
		  
		}
		
	}


}
//print(countAux);
//Array.print(IndexDetected);
//Array.print(IndexSPVN);
//Array.print(IndexSCfos);
//Array.print(IndexDetected);
//selectWindow('label');
roiManager("select", IndexDetected);
roiManager("save selected", inputDir + "cfosOxytocin.zip"); 
//
//roiManager("draw");
///////////////////////////////////////////////Filter1 small intersections/////////////////////////////////////////
row=0;
count=0;
IndexDetectedFilterSize=newArray(0);
IndexSPVNFilterSize=newArray(0);
IndexSCfosFilterSize=newArray(0);
/////////////For each selection with all the coordinates pvn, cfos and selection - eliminate those whose cfos are much bigger than the selection.since the selection must be like cfos////////////////////////////////
for (in=0; in<IndexDetected.length; in++) {
     roiManager("deselect");
     roiManager("select",newArray(IndexDetected[in],IndexSCfos[in]));
      roiManager("measure");
	  areaSelection = getResult('Area',row);
	  areacfos = getResult('Area',row+1);
      row = row + 2;
      
      if (areaSelection > 0.8*areacfos){
      	 
			//	if(count==0){	
			//  IndexDetectedFilterSize[0] = IndexDetected[in];
			//  IndexSCfosFilterSize[0] = IndexSCfos[in];
			//  IndexSPVNFilterSize[0] = IndexSPVN[in];
			//  }
             // else{
              	IndexDetectedFilterSize  = Array.concat(IndexDetectedFilterSize ,IndexDetected[in]); //only index with that condition for selection
              	IndexSCfosFilterSize  = Array.concat(IndexSCfosFilterSize ,IndexSCfos[in]); //only index with that condition for cfos
              	IndexSPVNFilterSize  = Array.concat(IndexSPVNFilterSize ,IndexSPVN[in]); //only index with that condition for pvn
            //  }
			  
			 
			  count=count+1;
      }
	
}
// not valid for one element
//Array.print(IndexDetectedFilterSize);
//Array.print(IndexSPVNFilterSize);
//Array.print(IndexSCfosFilterSize);
//print(IndexDetectedFilterSize.length);
//print(IndexSPVNFilterSize.length);
//print(IndexSCfosFilterSize.length);


selectWindow('label');
roiManager("select", IndexDetectedFilterSize);
roiManager("save selected", inputDir + "cfosOxytocinFilterOne.zip"); 
//roiManager("draw");

///////////////////////////////////////////////////////////////////////////Filter2 removing double detection in the same cell/////////////////////////
//////////////////////////In case of duplicate took the first cfos///////////////////////////////
array1 = IndexDetectedFilterSize; 
array2 = IndexSPVNFilterSize;
array3 = IndexSCfosFilterSize;


Array.sort(array2, array1, array3); //sort according to PVN // not valid for one element
//Array.show(array2, array1, array3);	
	
	array 	= Array.concat(array2, 999999);
	uniquePVN = newArray();
	uniqueCfos = newArray();
	uniqueSelection = newArray();
	ip = 0;	
   	while (ip<(array.length)-1) {
		if (array[ip] == array[(ip)+1]) {
			//print("found: "+array[i]);			
		} else {
			uniquePVN = Array.concat(uniquePVN, array[ip]);
			uniqueCfos = Array.concat(uniqueCfos, array3[ip]);
			uniqueSelection = Array.concat(uniqueSelection, array1[ip]);
		}
   		ip++;
   	}
	
//Array.show(uniqueSelection,uniquePVN, uniqueCfos);	
selectWindow('label');
roiManager("deselect");
roiManager("select",uniqueSelection);
roiManager("save selected", inputDir + "cfosOxytocinFilterTwo.zip"); 
//roiManager("draw");
print(uniqueSelection.length);
NumberOfCfosOxytocin = uniqueSelection.length;
//NumberOfOxytocin = PvnRoi.length;
NumberOfOxytocin = npvn;
///////////////////////////////////////     Save results in a table       //////////////////////////////////////////      //////////////////////
run("Clear Results");

j=j+1;

if (j>1){
IJ.renameResults("Counting","Results");	
setResult("Brain slice", j-1 ,list[i]);
setResult(title1, j-1 ,NumberOfOxytocin  );
setResult(title2, j-1 ,ncfos);
setResult(title3, j-1 ,NumberOfCfosOxytocin );
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResults" + StainCell + StainNucleus + "/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
} else{
setResult("Brain slice", j-1 ,list[i]);
setResult(title1, j-1 ,NumberOfOxytocin  );
setResult(title2, j-1 ,ncfos);
setResult(title3, j-1 ,NumberOfCfosOxytocin );
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResults" + StainCell + StainNucleus + "/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
	
} 
run("Clear Results");
roiManager("reset");


}else {

j=j+1;

if (j>1){
IJ.renameResults("Counting","Results");	
setResult("Brain slice", j-1 ,list[i]);
setResult(title1, j-1 ,npvn);
setResult(title2, j-1 ,ncfos);
setResult(title3, j-1 ,0);
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResults" + StainCell + StainNucleus + "/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
} else{
setResult("Brain slice", j-1 ,list[i]);
setResult(title1, j-1 ,npvn);
setResult(title2, j-1 ,ncfos);
setResult(title3, j-1 ,0 );
setResult("Area selected region mmxmm",j-1, areaSelectionS);
setResult("Region considered",j-1, rName);
saveAs("Results",inputDir + "CountingResults" + StainCell + StainNucleus + "/"+"SummaryCounting.xls"); //intermediate result
IJ.renameResults("Counting");
	
}

}
///////////////////////////////
//The idea is to save partial regions
if(OptionSave){
if(ncfos > 0 && npvn > 0){
SaveSubregion(rName,StringyList[i],StainCell,StainNucleus);}

if(ncfos > 0 && npvn == 0){
	
SaveSubregion1(rName,StringyList[i],StainCell,StainNucleus);
}


if(ncfos == 0 && npvn > 0){
SaveSubregion2(rName,StringyList[i],StainCell,StainNucleus);}

if(ncfos == 0 && npvn == 0){
SaveSubregion3(rName,StringyList[i],StainCell,StainNucleus);}

	
}


/////////////////////////
close("labelCfos");
close("useCfos");


close("use");
close("label");


////////////////////////////////////////////
//run("Clear Results");
roiManager("reset");
//run("Clear Results");
///////////////////////////////////////////////////////////////////////////////////////Save the pictures as montage////////////////////////////////////
//Save pictures
if(r==0){//first selection
selectWindow("Cfos");
run("Select None");
run("Duplicate...", " ");
rename("CfosP");
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
run("Add Image...", "image=CfosP x=0 y=0 opacity=40");//overlay image
run("Flatten");
close("OxytocinP-1");
rename("Overlay");
} 
roiManager("reset");
//add virus selection
if(ncfos > 0){
selectWindow("CfosP");	
roiManager("open", inputDir + "Cfos.zip"); //add type1
MoveSelection(pos11,pos22);
Indextype2 = CreateArrayIndex(roiManager("count"));
roiManager("Select", Indextype2);
roiManager("Set Color", "Magenta");
roiManager("Set Line Width", 3);
roiManager("Show All without labels");
run("Flatten");	
close("CfosP");
rename("CfosP");
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
if(ncfos >0 && npvn >0){
selectWindow("Overlay");
roiManager("open", inputDir + "cfosOxytocinFilterTwo.zip"); 
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
roiManager("open", inputDir + "ROI/" + StringyList[i] + ".zip" ); //add the marked sector
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
selectWindow("CfosP");	
roiManager("select", r);
roiManager("Set Color", "Yellow");
roiManager("Set Line Width", 2);
//roiManager("Show All without labels");
run("Flatten");	
close("CfosP");
rename("CfosP");
roiManager("reset");
}

//////////////////////////////Save the pictures/////////////////////////////
selectWindow("OxytocinP");
saveAs("Tiff", inputDir + "LabeledImagesOf" + StainCell + "\\" + StringyList[i] + "All-1.tif" );
selectWindow("CfosP");
saveAs("Tiff", inputDir + "LabeledImagesOf" + StainNucleus + "\\" + StringyList[i] + "All-2.tif" );
selectWindow("Overlay");
saveAs("Tiff", inputDir + "LabeledImagesOf" + StainCell + StainNucleus + "\\" + StringyList[i] + "All3.tif" );
//////////////////////////////////////////////////////////////////////////////////
close("*");
//setBatchMode(false);
}

 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IJ.renameResults("Counting","Results");
saveAs("Results",inputDir + "CountingResults" + StainCell + StainNucleus + "/"+"SummaryCounting.xls");
//showMessage("Finished");