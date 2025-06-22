Dialog.create("This scripts is doing either the counting of cells ,nucleus and fibers");
Dialog.addMessage("        Save the imagej macros in: \n  C-Fiji-Fiji.app-macros-PVNAutomatic- ");
Dialog.addMessage(" ");
Dialog.addMessage("     AUTOMATIC COUNTING OF CELLS , DO THE FOLLOWING STEPS:",false);
Dialog.addCheckbox("	Conversion to tiff format- Do the following steps:", false);
Dialog.addCheckbox("	Correction of contrast/brightness, if it's required, in specific folders:", false);
Dialog.addCheckbox("	Selection of  regions for counting -Follow the instructions", false);
Dialog.addCheckbox("	Create a grid of rois on the image -Follow the instructions", false); //create agrid with rectangles of 1 mm to 1 mm- given the scale factor of the images- This script was prepared for blind moles

Dialog.addMessage("	AUTOMATIC COUNTING - SELECT YOUR PREFERENCE", false);
Dialog.addMessage(" ");
Dialog.addCheckbox("	Counting of nucleus staining as cfos either a grid of rois or non-rectangular rois - ", false);
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
Dialog.addCheckbox("	Replace the file name of vsi files with sortfile", false);
Dialog.addCheckbox("	Set up automatic the same intensity to every region", false);
Dialog.addCheckbox("	Overlay roi labels of cells to its picture", false);
Dialog.addCheckbox("	Review the rois", false);

Dialog.addMessage("	RUN A GROUP OF FILES", false);
Dialog.addMessage(" ");
Dialog.addCheckbox("	TH with Cfos", false);
Dialog.addCheckbox("	Fibers", false);
Dialog.addCheckbox("	Montage detected fibers", false);
Dialog.addCheckbox("	Set up automatic intensity with correction", false);
Dialog.addCheckbox("	Montage every picture", false);
Dialog.addCheckbox("	Montage every picture with ROI", false);
Dialog.addCheckbox("	Montage every picture Without any sorting ", false);

Dialog.show();
a = Dialog.getCheckbox();
b = Dialog.getCheckbox();
c = Dialog.getCheckbox();
grid = Dialog.getCheckbox();
onlycfos = Dialog.getCheckbox();
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
SetIntensity =Dialog.getCheckbox();
OverlayRois = Dialog.getCheckbox();
ReviewRois = Dialog.getCheckbox();

bunch =  Dialog.getCheckbox();
fib =  Dialog.getCheckbox();
MontageFib =  Dialog.getCheckbox();
AutDetect =   Dialog.getCheckbox();
MontageEverything =  Dialog.getCheckbox();
MontageEverythingRoi =  Dialog.getCheckbox();
MontageEverythingWithoutSorting  =  Dialog.getCheckbox();


if (a){
    runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/ConvertToTiff.ijm");} 
     
if (b){
    runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/ChangeContrastTiff_.ijm");} 

if (c){
	runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/SelectRegionsVs4_.ijm");
	// runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SelectRegionsVs3_.ijm");
    //runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SelectRegions.ijm");
    }   
if (grid){
    runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/CreateRoiGrid_.ijm");}     //for grid creating

if (onlycfos){
	//runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/CountCellOnlyiCfosvs13_.ijm");
	runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/CountCellOnlyROIiCfosvs13_.ijm");
	
	}  //only for the counting of cfos  over a grid of rois (prepared for blind moles-also other rois


if (d){
	runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/CountCells13_.ijm");}
	
if (e){	
    runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/CountCellsCfosvs13_vs2.ijm");
     //runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/CountCellsDapiCfosvs13_.ijm");
    }          

if (f){
	runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/CountOxytocinVirusv13_.ijm");
	//runMacro("\PVNAutomatic\\CountOxytocinVirusv12_.ijm");
 	//runMacro("\PVNAutomatic\\CountOxytocinVirusv11_.ijm"); 
 	//runMacro("\PVNAutomatic\\CountOxytocinVirusv5_.ijm"); 
 }

if(fiber){
	runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/MainFibersSegmentation_.ijm");}

 
if (g){
   runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/IntensityCalibration.ijm"); 
}
//if (h){
  // runMacro("\PVNAutomatic\\ReplaceFileNames.ijm"); 
//}
if (i){
   runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/concatenate.ijm"); 

}
if (k){
   runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/concatenateWithRoivs2.ijm"); 
}
if (roisize){
   runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/FindRoiSize.ijm"); 
}
if(filechange){
   runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/ReplaceFileNames.ijm"); 
}

if(SetIntensity){
	 runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/ChangeContrastAutomaticTiff_.ijm"); // change automatic the contrast
}

if(OverlayRois){
	 runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/Overlay_rois_vs1_.ijm"); // overlay rois 
}

if(ReviewRois){
	 runMacro("C:/LabSoftware/ImageJSoftware/AutomaticCounting/Review_the_ROIS.ijm"); // overlay rois 
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
	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/128/PrePVN/TiffsAndROI/";
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/CountCellsTHvsCfosWithCorrectionsCfos_.ijm",file);



	
    showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
}


if(fib){

	

	run("Close All");
	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/128/PrePVN/FiberAnalysis/";
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/DetectFibers_.ijm",file);
	

	

	
	showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
}


if(MontageFib){

     file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/148";
     runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabel1_.ijm",file);
     run("Close All");
     file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/182";
     runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabel1_.ijm",file);
     run("Close All");

}

if(AutDetect){

//run("Close All");
	//file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/132/FiberAnalysis/Fibers/";
	//runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/ChangeContrastAutomaticTiffBatchVersion_.ijm",file);
//run("Close All");
	//file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/152/FiberAnalysis/Fibers/";
	//runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/ChangeContrastAutomaticTiffBatchVersion_.ijm",file);
run("Close All");
	file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/128/PrePVN/FiberAnalysis/Fibers/";
	runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/ChangeContrastAutomaticTiffBatchVersion_.ijm",file);


   showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");	
}

if(MontageEverything){
		   file = "X:/Users/Members/Itzik_Sofer/The Image Folder/Scl vs no-Scl/BX m/326/tiff/Oxytocin/";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomatic_.ijm",file);
     run("Close All");
     	  
     


     
     showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
}







if(MontageEverythingRoi){
		
//		   file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B50/4/cFosTHanalysis/PrePVN/Cfos";
//          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
//     run("Close All");
  
          file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/132/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
     
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/143/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/148/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/152/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/164/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/177/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B54/182/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/108/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B52/53/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/37/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/41/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B51/49/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
         
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B50/15/FiberAnalysis/PostPVN/2000";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureWithRoiAutomatic_.ijm",file);
     run("Close All");
     
     showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
}


if(MontageEverythingWithoutSorting){
        file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B52/52/PrePVN/TH";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
       file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B52/58/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B52/59/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B52/60/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B52/73/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B52/75/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/62/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/98/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/109/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/110/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/127/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/128/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
      file = "X:/Users/Members/Itzik_Sofer/The Image Folder/DREADD/exp/Gq/Axon_tracer - TH/B53/130/PrePVN/Cfos";
          runMacro("X:/Users/LabSoftware/ImageJSoftware/AutomaticCounting/SpetialCases/MontagetifLabelAnyPictureAutomaticWithoutSorting_.ijm",file);
     run("Close All");
     
     showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
}
