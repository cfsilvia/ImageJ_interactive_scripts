Dialog.create("This scripts is doing either the counting of cells ,nucleus and fibers");
Dialog.addMessage("        Save the imagej macros in: \n  C-Fiji-Fiji.app-macros-PVNAutomatic- ");


Dialog.addMessage(" ");
Dialog.addMessage("     AUTOMATIC COUNTING OF CELLS , DO THE FOLLOWING STEPS:",false);
Dialog.addCheckbox("	Conversion to tiff format- Do the following steps:", false);
Dialog.addCheckbox("	Correction of contrast/brightness, if it's required, in specific folders:", false);
Dialog.addCheckbox("	Selection of  regions for counting -Follow the instructions", false);
Dialog.addMessage("	AUTOMATIC COUNTING - SELECT YOUR PREFERENCE", false);
Dialog.addMessage(" ");
Dialog.addCheckbox("	Counting of cells with staining in the cytoplasm - ", false);
Dialog.addCheckbox("	Counting of the overlap of cells with  stainings in the cytoplasm and in the nucleus - ", false);
Dialog.addCheckbox("	Counting of the overlap of cells with 2 types of staining in the cytoplasm- ", false);
Dialog.addCheckbox("	Counting of fibers - ", false);

Dialog.addMessage("	HELP FUNCTIONS", false);
Dialog.addMessage(" ");
Dialog.addCheckbox("	Calibrate the intensity of a stack of images:", false);
//Dialog.addCheckbox("	Change name of files with points", false);
Dialog.addCheckbox("	Do montage of one channel/or 2 overlay channels", false);
Dialog.addCheckbox("	Do montage of one channel/or 2 overlay channels  with ROI", false);
Dialog.addCheckbox("	Find rois's size", false);
Dialog.addCheckbox("	Replace the file name with sortfile", false);

Dialog.addMessage("	RUN A GROUP OF FILES", false);
Dialog.addMessage(" ");
Dialog.addCheckbox("	TH with Cfos", false);
Dialog.addCheckbox("	Fibers", false);
Dialog.addCheckbox("	Montage detected fibers", false);

Dialog.show();
a = Dialog.getCheckbox();
b = Dialog.getCheckbox();
c = Dialog.getCheckbox();
d = Dialog.getCheckbox();
e = Dialog.getCheckbox(); 
f = Dialog.getCheckbox(); 
fiber = Dialog.getCheckbox(); 
g = Dialog.getCheckbox(); 
//h = Dialog.getCheckbox(); 
i = Dialog.getCheckbox();
k= Dialog.getCheckbox();
roisize = Dialog.getCheckbox();
filechange = Dialog.getCheckbox();
bunch =  Dialog.getCheckbox();
fib =  Dialog.getCheckbox();
MontageFib =  Dialog.getCheckbox();
    
if (a){
    runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/ConvertToTiff.ijm");} 
     
if (b){
    runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/ChangeContrastTiff_.ijm");} 

if (c){
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SelectRegionsVs2_.ijm");
    //runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SelectRegions.ijm");
    }   

if (d){
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/CountCells13_.ijm");}
	
if (e){	
    runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/CountCellsDapiCfosvs13_.ijm");}          

if (f){
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/CountOxytocinVirusv13_.ijm");
	//runMacro("\PVNAutomatic\\CountOxytocinVirusv12_.ijm");
 	//runMacro("\PVNAutomatic\\CountOxytocinVirusv11_.ijm"); 
 	//runMacro("\PVNAutomatic\\CountOxytocinVirusv5_.ijm"); 
 }

if(fiber){
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/MainFibersSegmentation_.ijm");}

 
if (g){
   runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/IntensityCalibration.ijm"); 
}
//if (h){
  // runMacro("\PVNAutomatic\\ReplaceFileNames.ijm"); 
//}
if (i){
   runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/concatenate.ijm"); 

}
if (k){
   runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/concatenateWithRoi.ijm"); 
}
if (roisize){
   runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/FindRoiSize.ijm"); 
}
if(filechange){
   runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/ReplaceFileNames.ijm"); 
}

if(bunch){
	//file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/32/";
//	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfos_.ijm",file);
//	run("Close All");
//	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/37/";
//	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfos_.ijm",file);

  //run("Close All");
	//file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/152/May2021/";
	//runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfosWithCorrectionsa_.ijm",file);

	//run("Close All");
	//file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/40/May2021/";
	//runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfosWithCorrections_.ijm",file);

	
 //  run("Close All");
//	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/167/May2021/";
//	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfosWithCorrectionsCfos_.ijm",file);
//run("Close All");
	//file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/37/May2021/";
//	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfosWithCorrectionsCfos_.ijm",file);
run("Close All");
	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/143/May2021/";
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfosWithCorrectionsCfos_.ijm",file);
 
}


if(fib){

	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/49/";
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/DetectFibers_.ijm",file);

	//run("Close All");
	//file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/152/";
	//runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/DetectFibers_.ijm",file);

//		run("Close All");
//	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/164/";
//	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/DetectFibers_.ijm",file);

	showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
}


if(MontageFib){

     file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/32/Traced Images/";
     A = newArray("one","two");
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabel1_.ijm",file);

}

