 //Select the PVN region to count
/////////////////////////////////////////////
 title = "Convert to tiff format";
  width=512; height=512;
  Dialog.create("Convert to Tiff format");

 
  Dialog.addMessage("  Choose Channels");
  Dialog.addCheckbox("Channel 1", false);
  Dialog.addCheckbox("Channel 2", false);
  Dialog.addCheckbox("Channel 3", true);
  Dialog.addCheckbox("Channel 4", true);


  Dialog.addMessage("  Choose Channels properties");
  Dialog.addChoice("Channel 1:", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers","Others"));
  Dialog.addChoice("Channel 2:",newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers","Others"));
  Dialog.addChoice("Channel 3:",newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers","Others"));
  Dialog.addChoice("Channel 4:", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers","Others"));
  Dialog.addMessage(" ");
  Dialog.addCheckbox("Adjust Intensity channel 2", false);
  Dialog.addNumber("Minimum Intensity :", 200);
  Dialog.addNumber("Maximum Intensity :", 16000);
  Dialog.addCheckbox("Adjust Intensity channel 3", false);
  Dialog.addNumber("Minimum Intensity :", 200);
  Dialog.addNumber("Maximum Intensity :", 6000);
  Dialog.addCheckbox("Adjust Intensity channel 4", false);
  Dialog.addNumber("Minimum Intensity :", 200);
  Dialog.addNumber("Maximum Intensity :", 6000);
  Dialog.addMessage(" ");
  Dialog.addCheckbox("Add a csv file for changing the name of files", false);
  Dialog.addMessage("   Create a file called SortFiles.csv" ); 
  
   Dialog.addCheckbox("Change contrast", true);
  
  // Dialog.addCheckbox("  Choose 2 Channels to Overlay",false);
 //  Dialog.addChoice("First Channel :", newArray( "Channel 1","Channel 2","Channel 3","Channel 4"));
 //  Dialog.addChoice("Second Channel :", newArray( "Channel 1","Channel 2","Channel 3","Channel 4"));
  
 Dialog.show();
//////////////////////////////////////////////////////
a1 = Dialog.getCheckbox();
a2 = Dialog.getCheckbox();
a3 = Dialog.getCheckbox();
a4 = Dialog.getCheckbox();

a5=Dialog.getCheckbox(); //to change manually the intensity of channel 2
a6=Dialog.getCheckbox(); //to change manually the intensity of channel 3
a7=Dialog.getCheckbox(); //to change manually the intensity of channel 4

a8=Dialog.getCheckbox(); //to add csv file which change names
a9=Dialog.getCheckbox();

type1 = Dialog.getChoice();
type2 = Dialog.getChoice();
type3 = Dialog.getChoice();
type4 = Dialog.getChoice(); 

if(type1 == "Dapi"){ color1 = "Blue";}
if(type1 == "Cfos"){ color1 = "Green";}
if(type1 == "Cherry"){ color1 = "Red";}
if(type1 == "Oxytocin"){ color1 = "Green";}
if(type1 == "Vasopresin"){ color1 = "Magenta";}
if(type1 == "TH"){ color1 = "Magenta";}
if(type1 == "Fibers"){ color1 = "Grays";}

if(type2 == "Dapi"){ color2 = "Blue";}
if(type2 == "Cfos"){ color2 = "Green";}
if(type2 == "Cherry"){ color2 = "Red";}
if(type2 == "Oxytocin"){ color2 = "Green";}
if(type2 == "Vasopresin"){ color2 = "Magenta";}
if(type2 == "TH"){ color2 = "Magenta";}
if(type2 == "Fibers"){ color2 = "Grays";}

if(type3 == "Dapi"){ color3 = "Blue";}
if(type3 == "Cfos"){ color3 = "Green";}
if(type3 == "Cherry"){ color3 = "Red";}
if(type3 == "Oxytocin"){ color3 = "Green";}
if(type3 == "Vasopresin"){ color3 = "Magenta";}
if(type3 == "TH"){ color3 = "Magenta";}
if(type3 == "Fibers"){ color3 = "Grays";}

if(type4 == "Dapi"){ color4 = "Blue";}
if(type4 == "Cfos"){ color4 = "Red";}
if(type4 == "Cherry"){ color4 = "Red";}
if(type4 == "Oxytocin"){ color4 = "Green";}
if(type4 == "Vasopresin"){ color4 = "Magenta";}
if(type4 == "TH"){ color4 = "Magenta";}
if(type4 == "Fibers"){ color4 = "Grays";}


//////////////////////////////////////////////////////////
if (a5){
 minChannel2 = Dialog.getNumber();
 maxChannel2 = Dialog.getNumber();
}
if (a6){
 minChannel3 = Dialog.getNumber();
 maxChannel3 = Dialog.getNumber();
}
if (a7){
 minChannel4 = Dialog.getNumber();
 maxChannel4 = Dialog.getNumber();
}
if (a8){
	//////////////////////////Add excel file/////////////////////
   CsvDir = getDirectory("Choose the  directory of the csv file");
   CsvDir = replace(CsvDir,"\\","/");
   open(CsvDir + "SortFiles.csv"); 
   IJ.renameResults("SortFiles.csv","Results");
/////////////////////////////////////////////////////////
}



////////////////////////////////////////////////////
 
inputDir = getDirectory("Choose the input vsi directory");
output = getDirectory("Choose directory of Results");
 

i=0;
list = getFileList(inputDir);
largo=list.length;
j=0;

for (i=0; i < largo; i++) {
showProgress(i+1, list.length);	
  if ((endsWith(list[i], ".vsi"))) { //checks that the current file is a subfolder
  	//setBatchMode(true);
  A=inputDir + list[i];
    A = replace(A,"\\","/");
    ////////////////////find listi in the results//////////////
    nameFile = substring(list[i], 0, indexOf(list[i], ".vsi")); //get rid off  of the vsi
    IndexAux = lastIndexOf(nameFile, "_");
    nf=parseInt(nameFile.length)-3; //assuming to numbers assigned by the microscope
    print(nf);
    print( IndexAux);
    if(IndexAux == nf) { //- should be the last character
        IndexAux=IndexAux-1;
        }
    else{
    	 IndexAux = parseInt(nameFile.length) -1;
    }
   print(nameFile);
 //  waitForUser('wait');
 
   
    /////////////////////////////////////////////
 if(a8) {   
     for (r=0; r < getValue("results.count"); r++) {   
    nameFileP = getResultString("Pic name",r);
   print(nameFileP);
   print(nameFile)
     if (nameFileP == nameFile ) {
     	//newName = substring(nameFile,0,IndexAux) + "_" + getResultString("Slice #",r);
     	  newName = getResultString("Slice #",r) + "_" + nameFile;
     	}
   }
   
   nameFile=newName;
 }
 print(nameFile);
 //waitForUser('wait');
    ////////////////////////////////////////////
   // setBatchMode(true);
    j=j+1;
    //Open
    run("Bio-Formats Importer", "open='" + A + "' color_mode=Composite crop rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
    Name = getTitle();
    print(Name);
    if(a1 && !a2 && !a3 && !a4){
    Name = substring(Name,0,indexOf(Name, ".vsi")) + ".vsi";
    Name1 ="C1-"+ Name ;
    rename(Name1);
    print(Name1);}
    

    //Split the channels
    if( a1 && a2 && a3 && a4){ 
    //Split the channels
    run("Split Channels");}
    
    if( a1 && a2 && a3){ 
    waitForUser('stop');

    //Split the channels
    run("Split Channels");}   
    
    if( a1 && a2 ){ 
    //Split the channels
    run("Split Channels");}  
///////////////////////////////////////////////////////////////////////
if (a1){ 
	selectWindow("C1-"+ Name);
	if(a9){
	run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");}
    run(color1);
    File.makeDirectory(output + type1 + "/");
    saveAs("Tiff",output + type1 + "/" + nameFile + ".tif"); //save a subdirectory of crop images
    close();
	    } else {close("C1-"+ Name); }
if (a2){ 
	selectWindow("C2-"+ Name);
    if (a5){
	   setMinAndMax(minChannel2,maxChannel2);
	   run("Apply LUT");
       //getMinAndMax(minGFP, maxGFP);
    } else {
    	if(a9){
    run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");}
    }
    run(color2);
    File.makeDirectory(output + type2 + "/");
    saveAs("Tiff",output + type2 + "/" + nameFile + ".tif"); //save a subdirectory of crop images
    close();
	    }else {close("C2-"+ Name); }
if (a3){ 
	selectWindow("C3-"+ Name);
	  if (a6){
	   setMinAndMax(minChannel3,maxChannel3);
	   run("Apply LUT");
       //getMinAndMax(minGFP, maxGFP);
    } else {
    	if(a9){
    run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");}
    }
    run(color3);
    File.makeDirectory(output + type3 + "/");
    saveAs("Tiff",output + type3 + "/" + nameFile + ".tif"); //save a subdirectory of crop images
    close();
	    }else {close("C3-"+ Name); }
if (a4){ 
	selectWindow("C4-"+ Name);
	  if (a7){
	   setMinAndMax(minChannel4,maxChannel4);
	   run("Apply LUT");
       //getMinAndMax(minGFP, maxGFP);
    } else {
    	if(a9){
    run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");}
    }
    print(color4);
    run(color4);
    File.makeDirectory(output + type4 + "/");
    saveAs("Tiff",output + type4 + "/" + nameFile + ".tif"); //save a subdirectory of crop images
    close();
	    }else {close("C4-"+ Name); }
    

  	 run("Close All");
    setBatchMode(false);
  }
}
showMessage("Finished");