//////Auxiliary functions///////////////








/////////////////////////////////////////////////BEGIN PROGRAM//////////////////////////////////////////////////////
//open slice
//open roi
//open roi atlas
// combine roi and save it as .roi
image_input_1 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Cfos/127_BMR20_Slide18_6.tif";
image_input_2 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Oxytocin/127_BMR20_Slide18_6.tif";
scale = 648.4;
StainCell = "Cfos+Oxytocin";
roi_input_1 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Roi_all_image_Cfos/127_BMR20_Slide18_6.zip";
roi_input_2 ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/Roi_all_image_Oxytocin/127_BMR20_Slide18_6.zip";
roi_user = "X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/ROI/RoiSet127_BMR20_Slide18_6.zip"
outputDir ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/"+ "/CountingResultsOf" + StainCell  + "/";
outputImages ="X:/Users/Members/Yael_Kashash/All Images/cfos exp/Social group/BMR20/tifs for OT count/"+ "/LabeledImagesOf" + StainCell  + "/";
//roi_all = "X:/Users/Members/Tali S/aging project/p16 virus/p16 virus brain/p16 old/tif/plate1/RoisAll/4p16_brain_old1_plate1_1_2.roi"
/*inputData =  getArgument();

data =split(inputData,"%");
roi_input_1 = data[0];
roi_input_2 = data[1];
roi_atlas = data[2];
outputDir = data[3];
outputImages = data[4];
image_input_1 = data[5];
image_input_2 = data[6];
StainCell = data[7];
scale = parseFloat(data[8]);*/
/*
 * find cfos with roi
 * find oxytocin with roi
 * find intersection cfos oxytocin
 */
 
 //Get name of the image file
 name_file =substring(image_input, lastIndexOf(image_input_1, "/")+1, lastIndexOf(image_input, "."));
 print("Wait  "+name_file);

 
 
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
    //Initialization
 ///Create empty arrays with the size of roi user
array_labels_Cfos = newArray(nUser);
array_labels_Oxytocin = newArray(nUser);
array_labels_CfosOxytocin = newArray(nUser);
array_areas = newArray(nUser);
array_names = newArray(nUSer);
Index_outside_region =newArray(0);
IndexIntersection = newArray(0);
ncountCfos =0;
ncountOxytocin = 0;
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
for (vr1 = nUser; vr1 < (nTotal-1); vr1++){
	print("\\Clear");
	print("working "+ name_file + "  "+ vr1);
   //loop through the roi user
   for (r = 0; r < nUser; r++){
   //all the sector
   roiManager("select",newArray(r,vr1));
   roiManager("AND"); //find joining
   if (selectionType > -1 ){// if it is overlapped
         array_labels_Cfos[r] = array_labels_Cfos[r] + 1;
         ncountCfos = ncountCfos +1;
         } else{//index to delete outside interest region
         	Index_outside_region = Array.concat(Index_outside_region ,vr1);
         	}
         }
   } 
//Find Oxytocin inside each region
for (vr1 = nTotal; vr1 < (nTotalall-1); vr1++){
	print("\\Clear");
	print("working "+ name_file + "  "+ vr1);
   //loop through the roi user
   for (r = 0; r < nUser; r++){
   //all the sector
   roiManager("select",newArray(r,vr1));
   roiManager("AND"); //find joining
   if (selectionType > -1 ){// if it is overlapped
         array_labels_Oxytocin[r] = array_labels_Oxytocin[r] + 1;
         ncountOxytocin = ncountOxytocin + 1;
         }else{//index to delete outside interest region- add to the array of cfos
         	Index_outside_region = Array.concat(Index_outside_region ,vr1);
         	}
   } 
//Delete labels outside the region of interest
if(Index_outside_region.length !=0){
roiManager("select", Index_outside_region);
roiManager("delete");}
////////////////////////////////


//Find intersection between cfos and oxytocin 
for (index1 = nUser; index1 < nUser + ncountCfos -1; index1++){ // loop over the cfos cells

	for (index2 = nUser + ncountCfos ; index2 < nUser + ncountCfos + ncountOxytocin - 1; index2++){ // loop over oxytocin
		roiManager("select",newArray(index1,index2));
		roiManager("AND"); //find joining
		if (selectionType >-1 )	{// if it is overlapped
		  for(r=0; r < nUser ; r++){// go through the rois
		  	roiManager("deselect");
		  	
		  	}
		  }
		  
		}
	}
