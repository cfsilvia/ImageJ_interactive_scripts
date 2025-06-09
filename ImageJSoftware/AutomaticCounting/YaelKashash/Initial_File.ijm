//run macro of overlapped

 inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
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
/*inputData =  getArgument();

data =split(inputData,"%");
roi_input_1 = data[0];
roi_input_2 = data[1];
roi_user = data[2];
outputDir = data[3];
outputImages = data[4];
image_input_1 = data[5];
image_input_2 = data[6];
StainCell = data[7];
scale = parseFloat(data[8]);*/
//////////////////////////////
//-1- list the files and get the name
list = getFileList(inputDir + "Oxytocin" + "/");
largo=list.length;
StringyList =newArray(largo);
for(s = 0; s < largo; s++) { 
     a = substring(list[s], 0, lastIndexOf(list[s], "."));
     StringyList[s] = a; 
     }
     
//run each file
for(s = 0; s < largo; s++) { 
	image_input_2 = inputDir + "Oxytocin" + "/" + StringyList[s] +".tif";
	image_input_1 = inputDir + "Cfos" + "/" + StringyList[s] +".tif";
	roi_input_2 = inputDir + "Roi_all_image_Oxytocin" + "/" + StringyList[s] +".zip";
	roi_input_1 = inputDir + "Roi_all_image_Cfos" + "/" + StringyList[s] +".zip";
	roi_user = inputDir + "ROI" + "/" + "RoiSet" + StringyList[s] +".zip";
	StainCell ="Cfos+Oxytocin";
	File.makeDirectory(inputDir + "LabeledImagesOf" + StainCell + "/");
	outputDir = inputDir + "LabeledImagesOf" + StainCell + "/";
	File.makeDirectory(inputDir + "CountingResultsOf" + StainCell + "/");
	outputImages = inputDir + "CountingResultsOf" + StainCell + "/";
	scale = 648.4;
	data = roi_input_1 + "%" + roi_input_2 + "%"+ roi_user + "%" + outputDir + "%" + outputImages + "%" + image_input_1 + "%"+ image_input_2 + "%"+ StainCell + "%" + scale;
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/YaelKashash/Counting_Cells_Two_colors_without_Atlas_vs3.ijm",data);
}
