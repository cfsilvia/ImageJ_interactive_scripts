////////////////Auxiliary function /////////////////
////////////////////////////////////////////////////////////
///
function CreateArrayIndex(n) {
      ArrayIndex=newArray(n);
  for (ii = 0; ii < n; ii++) {
       ArrayIndex[ii]=ii;

    }
 return ArrayIndex;
	
}

//
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
 print(pos11);
 print(pos22);
   for (vr = 0; vr <roiManager("count"); vr++){
          roiManager("select", vr);
          /*getSelectionBounds(x, y, w, h);
          setSelectionLocation(x+pos11, y+pos22);*/
          RoiManager.translate(pos11, pos22);
          
      }
      

	
}
//
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

//////////////////////////////////////////// end auxiliary functions
//////////////////////////////////////
//Count the cellls
///////////////////////////////Begin the program/////////////////////////
 inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
title = "Choose the staining type";
Dialog.create(title);
Dialog.addChoice("Staining of the cell (as oxytocin):", newArray("Cherry", "Oxytocin","Vasopresin","TH","Others")); //this is the name of the folder
Dialog.addNumber("Add scale factor nm per pixel (as 648.4 for 10x):", 648.4);
Dialog.show();

StainCell = Dialog.getChoice();
scale = Dialog.getNumber();
/////////////////////////////////////////////////////
File.makeDirectory(inputDir + "Roi_all_image_" + StainCell + "/");
//////////////////////////////////////////////////////////
list = getFileList(inputDir + StainCell + "/");
largo=list.length;
StringyList =newArray(largo);
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }
     
for (i=0; i < largo; i++) {
	showProgress(i+1, list.length);	
	 roiManager("reset");
	roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );
	nR = roiManager("Count");  // number of ROI per image.
	for (r = 0; r < nR; r++){ 
		roiManager("reset");
        roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );

///////////////////
if(r==0){//first time which is open
open(inputDir + StainCell + "/"+ list[i]);
rename("Oxytocin"); }
selectWindow("Oxytocin");
run("Select None");//erase previous selection
roiManager("select",r);
//information of r
rName = Roi.getName(); 
//get information of the roi selected
 getSelectionBounds(x, y, width, height);
 pos11 = x;
 pos22 = y;
 //select the region
run("Duplicate..."," ");
rename('use');
roiManager("reset");
		////////////////////////
showText("Now is running the slice:"+ rName + " - "+ StringyList[i]);

////////////////////////////////////
///////////////////////////////////////////////////////For PVN////////////////////////////////////////////////////////
 
selectWindow('use');
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
roiManager("Save", inputDir + rName + ".zip");
}
roiManager ("Reset");
run("Clear Results");
}


//print(npvn);
//////////////////////////////////////////////////////////Eliminate detection outside the selection region and save again/////////////////////////////////////////////////////////
//////////////////////////////////////////// Remove events outside the desired region /////////////////////////////////
/// Begin for virus return to original picture
if(npvn > 0){
//Move to original place
selectWindow("Oxytocin");
roiManager("open", inputDir + rName + ".zip");
 print(pos11);
 print(pos22);
 n1 = roiManager("count");
 indexes_to_select = CreateArrayIndex(n1);
 roiManager("select", indexes_to_select);
 RoiManager.translate(pos11, pos22);
//add the roi and remove labels outside 
naux2= roiManager("count");// add to this roi
roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );
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
   
//save the roi
selectWindow('use');
roiManager("select",(roiManager("count")-1));
roiManager("delete");
NumberOfOxytocin  = roiManager("count");
npvn =  roiManager("count");

if(npvn !=0){
roiManager("Save", inputDir + rName + ".zip");}
//close("AuxP");
}
////////////////////////


roiManager("reset");
close("use");
close("label");
//waitForUser("stop4");


	}
/////////Save all rois in the same window////////////////////////

selectWindow("Oxytocin");
roiManager("open", inputDir + "ROI/" + "RoiSet" + StringyList[i] + ".zip" );
ninitial = roiManager("count");
print(ninitial);

for (r = 0; r < ninitial; r++){ 
	roiManager("select",r);
//information of r
    rName = Roi.getName(); 
	roiManager("open", inputDir + rName + ".zip" );
	
}

//delete rois
indexes_1 = CreateArrayIndex(ninitial);
roiManager("select",indexes_1);
//information of r
//waitForUser("stop3");
roiManager("Save", inputDir + "Roi_all_image_" + StainCell + "/"+ StringyList[i] + ".zip");
roiManager("reset");
close("*");

}