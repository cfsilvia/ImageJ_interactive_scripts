//////Auxiliary functions///////////////








/////////////////////////////////////////////////BEGIN PROGRAM//////////////////////////////////////////////////////
//open slice
//open roi
//open roi atlas
// combine roi and save it as .roi
/*image_input_1 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Cfos/127_BMR20_Slide18_6.tif";
image_input_2 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Oxytocin/127_BMR20_Slide18_6.tif";
scale = 648.4;
StainCell = "Cfos+Oxytocin";
roi_input_1 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Roi_all_image_Cfos/127_BMR20_Slide18_6.zip";
roi_input_2 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Roi_all_image_Oxytocin/127_BMR20_Slide18_6.zip";
roi_user = "X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/ROI/RoiSet127_BMR20_Slide18_6.zip"
outputDir ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/"+ "/CountingResultsOf" + StainCell  + "/";
outputImages ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/"+ "/LabeledImagesOf" + StainCell  + "/";*/
//roi_all = "X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/RoisAll/4p16_brain_old1_plate1_1_2.roi"
inputData =  getArgument();

data =split(inputData,"%");
roi_input_1 = data[0];
roi_input_2 = data[1];
roi_user = data[2];
outputDir = data[3];
outputImages = data[4];
image_input_1 = data[5];
image_input_2 = data[6];
StainCell = data[7];
scale = parseFloat(data[8]);

print(roi_input_1);
print(roi_input_2);
print(roi_user);
print(outputDir);
print(outputImages);
print(image_input_1);
print(image_input_2);
print(StainCell);

// find cfos with roi
 /* find oxytocin with roi
 * find intersection cfos oxytocin
 */
 
 //Get name of the image file
 name_file =substring(image_input_1, lastIndexOf(image_input_1, "/")+1, lastIndexOf(image_input_1, "."));
 print("Wait  "+name_file);

setBatchMode(true);
 
 //Open the two images
open(image_input_1);
run("Set Scale...", "distance=1 known=648.4 unit=nm global");
rename("Cfos");  
//Open the image
open(image_input_2);
run("Set Scale...", "distance=1 known=648.4 unit=nm global");
rename("Oxytocin");  
//open rois marked by the user 
 roiManager("reset");
 roiManager("open",roi_user);
 nUser = roiManager("Count");  // number of ROI of atlas.
 
     //Initialization
 ///Create empty arrays with the size of roi user
array_labels_Cfos = newArray(nUser);
array_labels_Oxytocin = newArray(nUser);
array_labels_CfosOxytocin = newArray(nUser);
array_areas = newArray(nUser);
array_names = newArray(nUser);
Index_cfos =newArray(0);
Index_oxytocin =newArray(0);
IndexIntersection = newArray(0);
ncountCfos =0;
ncountOxytocin = 0;
index_inters =0; 
 //////////////////////////
 //Find areas of the roi user
 //fill areas and names from the roi user-Create two arrays
for (r = 0; r < nUser; r++){
    run("Select None");//erase previous selection
    roiManager("select",r);
    rName = Roi.getName(); 
    //print(rName);
    //get area of the sector in mmXmm
    getStatistics(area);
    area_all_region = area/(1000000*1000000);
    //save in the arrays
    array_names[r] = rName;
    array_areas[r] = area_all_region;
   }

 ////////////////
 //add to roi manager rois of the first image
roiManager("open",roi_input_1);
 nTotal = roiManager("Count");  
 nlabels_cfos = nTotal -nUser; 
  //add to roi manager rois of the second image
roiManager("open",roi_input_2);
nTotalall = roiManager("Count");  
nlabels_oxytocin = nTotalall -(nUser+nlabels_cfos); 
/////////////////////////////////////////////////
//Find Cfos inside each region
for (vr1 = nUser; vr1 < (nTotal); vr1++){
	print("\\Clear");
	print("work cfos "+ name_file + "  "+ vr1);
   //loop through the roi user
   for (r = 0; r < nUser; r++){
   //all the sector
   roiManager("deselect");
   roiManager("select",newArray(r,vr1));
   roiManager("AND"); //find joining
   if (selectionType > -1 ){// if it is overlapped
         array_labels_Cfos[r] = array_labels_Cfos[r] + 1;
         Index_cfos= Array.concat(Index_cfos ,vr1);
         } 
         
         }
   } 
//Find Oxytocin inside each region
for (vr1 = nTotal; vr1 < (nTotalall); vr1++){
	print("\\Clear");
	print("work oxytocin "+ name_file + "  "+ vr1);
   //loop through the roi user
   for (r = 0; r < nUser; r++){
   //all the sector
   roiManager("deselect");
   roiManager("select",newArray(r,vr1));
   roiManager("AND"); //find joining
   if (selectionType > -1 ){// if it is overlapped
         array_labels_Oxytocin[r] = array_labels_Oxytocin[r] + 1;
         Index_oxytocin= Array.concat(Index_oxytocin ,vr1);
         }
   } 
}
////////////////////////////////


//Find intersection between cfos and oxytocin 
for(i=0; i < Index_cfos.length; i++){//go through cfos
	    print("\\Clear");
	print("work oxytocin-cfos "+ name_file + "  "+ i);
		for(j=0; j < Index_oxytocin.length; j++){//go through oxytocin
		    roiManager("deselect");
            roiManager("select",newArray(Index_cfos[i],Index_oxytocin[j]));
            roiManager("AND"); //find joining
       if (selectionType > -1 ){// if it is overlapped
       	   index_inters = index_inters + 1;
       	   roiManager("add"); //add the selectionat the end of the list
       	   
       	   //Check that the overlapped is almost equal to cfos area
       	   roiManager("deselect");
       	   roiManager("select", Index_cfos[i]);
       	   getStatistics(area);
           area_cfos = area/(1000000*1000000);
           roiManager("deselect");
       	   roiManager("select", nTotalall + index_inters - 1);
       	   getStatistics(area);
           area_intersection = area/(1000000*1000000);
           //consider intersection only if it has size of cfos
           if(area_intersection < 0.8*area_cfos){
           	roiManager("deselect");
       	    roiManager("select", nTotalall + index_inters - 1);
       	    roiManager("delete");
       	    index_inters = index_inters - 1; //go back
       	    
           } else {
           	IndexIntersection = Array.concat(IndexIntersection,nTotalall + index_inters - 1); //add the overlapped  data -oxytocin cfos
           	
           }
       	   
       	   //
       }
       }
		}
// Find the counts for each region
for(t=0; t< IndexIntersection.length ; t++){
	 print("\\Clear");
	print("work count oxytocin-cfos "+ name_file + "  "+ t);
	//loop through the roi user
   for (r = 0; r < nUser; r++){
//////
   //all the sector
   roiManager("deselect");
   roiManager("select",newArray(r,IndexIntersection[t]));
   roiManager("AND"); //find joining
   if (selectionType > -1 ){// if it is overlapped
         array_labels_CfosOxytocin[r] = array_labels_CfosOxytocin[r] + 1;
         }
   } 
}

// save data
///Save data
j=1; //save results 

for (r = 0; r < nUser; r++){ //trough the atlas

setResult("Brain slice", j-1 ,name_file);
setResult("Number of Labels Cfos", j-1 ,array_labels_Cfos[r]);
setResult("Number of Labels Oxytocin", j-1 ,array_labels_Oxytocin[r]);
setResult("Number of Labels overlapped Cfos-Oxytocin", j-1 ,array_labels_CfosOxytocin[r]);
setResult("Area of ROI mmxmm",j-1,array_areas[r]);

setResult("Region considered",j-1, array_names[r]);

//saveAs("Results",outputDir + name_file + "SummaryCounting.xls"); //intermediate result

j=j+1;

}

saveAs("Results",outputDir + name_file + "SummaryCounting.xls");

//save cfos label and rois
selectWindow("Cfos");
run("Select None");
run("Duplicate...", " ");
rename("CfosP");
run("Red");

selectWindow("Oxytocin");
run("Select None");
run("Duplicate...", " ");
rename("OxytocinP");

run("Select None");
run("Duplicate...", " ");
run("Add Image...", "image=CfosP x=0 y=0 opacity=40");//overlay image
run("Flatten");
close("OxytocinP-1");
rename("Overlay");

//add cfos
selectWindow("Overlay");
roiManager("Select", IndexIntersection);
roiManager("Set Fill Color", "red");
roiManager("Show All without labels");	
run("Flatten");
close("Overlay");
rename("Overlay");	

/// Save picture
selectWindow("Overlay");
saveAs("Tiff", outputImages + name_file + "All3.tif" );


/////////////////////////////////
close("*");
close("Results");
close("ROI Manager");
setBatchMode(false);
print("Finish  " +  name_file);
close("Log");
run("Quit");
