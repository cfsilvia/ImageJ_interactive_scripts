title = "Calibration";
Dialog.create(title);

Dialog.addMessage("Calibrate the images intensity/for 3 channels- Select images and save them in a special folder")
Dialog.addChoice("Choose channel :", newArray("Channel 1","Channel 2","Channel 3","Channel 4"));
Dialog.show();
channel = Dialog.getChoice();
/////////////////////////////////
//  showMessage("Crop one image")
  inputDir = getDirectory("Choose the input vsi directory");

  
i=0;
list = getFileList(inputDir);
largo=list.length;
j=0;

for (i=0; i < largo; i++) {
showProgress(i+1, list.length);	
  if ((endsWith(list[i], ".vsi"))) { //checks that the current file is a subfolder	
//	setBatchMode(true);
    A=inputDir + list[i];
    A = replace(A,"\\","/");
    j=j+1;
   print(A);
 
    run("Bio-Formats Importer", "open='" + A + "' color_mode=Composite crop rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
    Name = getTitle();
     //  print(Name);
    run("Split Channels");
    
    if(channel == "Channel 1"){ 
     if (isOpen("C4-"+ Name)) {close("C4-"+ Name);}
     if (isOpen("C2-"+ Name)) {close("C2-"+ Name);}
     if (isOpen("C3-"+ Name)) {close("C3-"+ Name);}
    }
    
  if(channel == "Channel 2"){ 
   if (isOpen("C1-"+ Name)) {close("C1-"+ Name);}
   if (isOpen("C4-"+ Name)) {close("C4-"+ Name);}
   if (isOpen("C3-"+ Name)) {close("C3-"+ Name);}
   }
    
 if(channel == "Channel 3"){ 
    if (isOpen("C1-"+ Name)) {close("C1-"+ Name);}
    if (isOpen("C2-"+ Name)) {close("C2-"+ Name);}
    if (isOpen("C4-"+ Name)) {close("C4-"+ Name);}}

  if(channel == "Channel 4"){ 
     if (isOpen("C1-"+ Name)) {close("C1-"+ Name);}
   if (isOpen("C2-"+ Name)) {close("C2-"+ Name);}
   if (isOpen("C3-"+ Name)) {close("C3-"+ Name);}}   
    
if(channel == "Channel 1"){ 
 run("Blue");}
if(channel == "Channel 2"){ 
 run("Red");}
if(channel == "Channel 3"){ 
 run("Green");}
 if(channel == "Channel 4"){ 
 run("Magenta");}
    
   // run("Close All");
   // setBatchMode(false);
  }
	
 }
 run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use keep");

 close("\\Others");

  
 showMessage("Adjust intensity");

 title = "Adjust intensity of the stack";
  getMinAndMax(min, max);
  print(min,max);
  Min=min; Max=max;
  Dialog.create(title);
  Dialog.addNumber("Minimum Intensity:", Min);
  Dialog.addNumber("Maximum Intensity", Max);
  Dialog.addCheckbox("Accept the settings", false);
  Dialog.show();
 
  ramp = Dialog.getCheckbox();
while (ramp == false){
  Min1 = Dialog.getNumber();
  Max1 = Dialog.getNumber();
  setMinAndMax(Min1,Max1);
  waitForUser;

  Dialog.create(title);
  Dialog.addNumber("Minimum Intensity:",Min1);
  Dialog.addNumber("Maximum Intensity", Max1);
  Dialog.addCheckbox("Accept the settings", false);
  Dialog.show();
  ramp = Dialog.getCheckbox();

  } 
  if (ramp == true){
  	//save data in the future
  run("Clear Results"); 
   name = "IntensityParameters" + channel +".csv";	
    setResult("Minimum Intensity", 0, Min1);
    setResult("Maximum Intensity", 0, Max1);
    updateResults();
    saveAs("Results", inputDir + name); 
 close();

  }
  
