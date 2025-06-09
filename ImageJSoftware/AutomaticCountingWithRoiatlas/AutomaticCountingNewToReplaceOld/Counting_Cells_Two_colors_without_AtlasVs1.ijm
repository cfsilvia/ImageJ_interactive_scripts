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
 name_file =substring(image_input_1, lastIndexOf(image_input_1, "/")+1, lastIndexOf(image_input_1, "."));
 print("Wait  "+name_file);

 //setBatchMode(true);
 
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
   //Initialization
 ///Create empty arrays with the size of roi user
array_names = newArray(nUser);
array_areas = newArray(nUser);
array_labels_Cfos = newArray(nUser);
array_labels_Oxytocin = newArray(nUser);
array_labels_CfosOxytocin = newArray(nUser);
ncountCfos =0;
ncountOxytocin = 0;

///////////////////////////////////////////////
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
////////////////////Loop over each region ///////////////
for (r = 0; r < nUser; r++){
	// create for each region array to save data
	Index_cfos =newArray(0);
	Index_oxytocin = newArray(0);
	IndexIntersection = newArray(0);
	index_inters = 0;

    //go through cfos counts and save index
    for (vr1 = nUser; vr1 < (nTotal-1); vr1++){
	print("\\Clear");
	print("working "+ name_file + "  "+ vr1);
   // select region and cfos
   roiManager("deselect");
   roiManager("select",newArray(r,vr1));
   roiManager("AND"); //find joining
   if (selectionType > -1 ){// if it is overlapped
         array_labels_Cfos[r] = array_labels_Cfos[r] + 1; //counts cfos
         Index_cfos = Array.concat(Index_cfos ,vr1);
   }
    }
         
    //go through oxytocin counts and save index inside the region
    for (vr1 = nTotal; vr1 < (nTotalall-1); vr1++){
	print("\\Clear");
	print("working "+ name_file + "  "+ vr1);
	roiManager("deselect");
	 roiManager("select",newArray(r,vr1));
    roiManager("AND"); //find joining
   if (selectionType > -1 ){// if it is overlapped
         array_labels_Oxytocin[r] = array_labels_Oxytocin[r] + 1;
         Index_oxytocin = Array.concat(Index_oxytocin ,vr1);
         }
    }
    
    //find intersection between oxytocin and cfos inside the region
    for(index1 = 0; index1 < Index_cfos.length; index1++){// go through Cfos inside the region
    	for(index2 = 0; index2 < Index_oxytocin.length; index2++){// go through oxytocin inside the region
    		roiManager("deselect");
	        roiManager("select",newArray(Index_cfos[index1],Index_oxytocin[index2]));
            roiManager("AND"); //find joining
    		if (selectionType > -1 ){// if it is overlapped
    		   roiManager("add"); //add the selectionat the end of the list
    		   index_inters = index_inters + 1;
               array_labels_CfosOxytocin[r] = array_labels_CfosOxytocin[r] + 1;
               IndexIntersection = Array.concat(IndexIntersection ,(nTotalall + index_inters - 1) );
         }
    		
    	}
    	}
    
    // add labels to pictures
//Save pictures
if(r==0){//first selection create overlay image
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
} 
// add cfos
selectWindow("Overlay");
roiManager("Select", IndexIntersection);
roiManager("Set Fill Color", "red");
roiManager("Show All without labels");	
run("Flatten");
close("Overlay");
rename("Overlay");	



roiManager("reset");

}
/// Save picture
selectWindow("Overlay");
saveAs("Tiff", outputImages + name_file + "All3.tif" );

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
close("*");
close("Results");
close("ROI Manager");
//setBatchMode(false);
print("Finish  " +  name_file);
close("Log");
run("Quit");
/////////////////////////////////////////////////
