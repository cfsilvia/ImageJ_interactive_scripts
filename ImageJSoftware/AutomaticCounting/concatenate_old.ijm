/// Open overlay pictures and do montage
//Open directory of the pictures
 inputDir = getDirectory("Choose the input  tif directory");
 //////////////////////////////////////////////////////
title = "Choose channel to select the desired regions";
Dialog.create(title);
Dialog.addChoice("Type:", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers","Overlay 2 channels","Overlay 3 channels","Others")); //this is the name of the folder
Dialog.addCheckbox("Sort the slides according to the last number", false);
Dialog.show();
type = Dialog.getChoice();
sorting = Dialog.getCheckbox();
///////////////////////////////////////////////////////////
if(type == "Overlay 2 channels"){
Dialog.create("Choose 2 channels to overlay");	
Dialog.addChoice("Channel 1  green (as oxytocin):", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.addChoice("Channel 2: red (as vasopresin)", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.show();
typeOverlay1 = Dialog.getChoice();
typeOverlay2 = Dialog.getChoice();	

}
//
if(type == "Overlay 3 channels"){
Dialog.create("Choose 3 channels to overlay");	
Dialog.addChoice("Channel 1  green (as oxytocin):", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.addChoice("Channel 2: red (as vasopresin)", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.addChoice("Channel 3: gray (as fibers)", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.show();
typeOverlay1 = Dialog.getChoice();
typeOverlay2 = Dialog.getChoice();	
typeOverlay3 = Dialog.getChoice();
}
//
if(type == "Others"){
      
      inputDir = getDirectory("Choose again the input  tif directory with pictures, you are intrested to do montage");
}


////////////////////////////////////////
if(type =="Overlay 2 channels" || type =="Overlay 3 channels"){
  	FileList = getFileList(inputDir + typeOverlay1 + "\\");}
  	else if(type == "Others"){
  		FileList = getFileList(inputDir);
  	}
  else{ 
    FileList = getFileList(inputDir + type + "\\");}
/////////////////////////////////////////////////////////////////
// Sort file list
largo=FileList.length;
if(sorting) {    
      // to save slide name
    Num =newArray(largo); // to save slide number for sorting
//////        Sort file ///////////   
   for(i = 0; i < largo; i++) { 
     a = substring(FileList[i], 0, lastIndexOf(FileList[i], "."));
     IndexAux = lastIndexOf(a, "_");
     num = substring(a, IndexAux+1);
     //New[i] = a;
     Num[i] = parseInt(num);
    }
 
  Array.sort(Num,FileList); //Sort New according to the sorting of Num
  
}


////////////////////////////////////////////////////////////////////
 //setBatchMode(true);
 j=0;
 Names=newArray(largo);
 // loop over the desired range
for (i=0; i < largo; i++) {
showProgress(i+1, FileList.length);	

if(type =="Overlay 2 channels"){

	open (inputDir + typeOverlay1 + "\\"+ FileList[i]);
	rename("Overlay1");
	open(inputDir + typeOverlay2 + "\\"+ FileList[i]);
	rename("Overlay2");
	selectWindow("Overlay1");
	run("Add Image...", "image=Overlay2 x=0 y=0 opacity=50"); //overlay of 2 pictures
	run("Flatten");
	
    nameFile = substring(FileList[i], 0, indexOf(FileList[i], ".tif")); //get file name
	//add text 
    setFont("SansSerif", 200, " antialiased");
    makeText(nameFile, 50, 100);
    run("Flatten");
     rename("image"+j);
     close("Overlay1");
     close("Overlay1-1");
     close("Overlay2");
   
} else if (type =="Overlay 3 channels") {
	open (inputDir + typeOverlay1 + "\\"+ FileList[i]);
	rename("Overlay1");
	open(inputDir + typeOverlay2 + "\\"+ FileList[i]);
	run("Enhance Contrast", "saturated=0.35");
	rename("Overlay2");
	selectWindow("Overlay1");
	run("Add Image...", "image=Overlay2 x=0 y=0 opacity=50"); //overlay of 2 pictures
	rename("Aux");
	open(inputDir + typeOverlay3 + "\\"+ FileList[i]);
	rename("Overlay3");
	selectWindow("Aux");
	run("Add Image...", "image=Overlay3 x=0 y=0 opacity=40");
	run("Flatten");
	
    nameFile = substring(FileList[i], 0, indexOf(FileList[i], ".tif")); //get file name
	//add text 
    setFont("SansSerif", 200, " antialiased");
    makeText(nameFile, 50, 100);
    run("Flatten");
     rename("image"+j);
     close("Overlay1");
     close("Overlay1-1");
     close("Overlay2");
     close("Overlay3");
     close("Aux");
     close("Aux-1");
	
}
  else if (type == "Others"){
  	if ((endsWith(FileList[i], ".tif"))){
  	open (inputDir + FileList[i]);
	rename("Overlay1");
	selectWindow("Overlay1");
	nameFile = substring(FileList[i], 0, indexOf(FileList[i], ".tif")); //get file name
	//add text 
    setFont("SansSerif", 200, " antialiased");
    makeText(nameFile, 50, 100);
    run("Flatten");
    rename("image"+j);
    close("Overlay1");}
  }
  else { 
	open (inputDir + type + "\\"+ FileList[i]);
	rename("Overlay1");
	selectWindow("Overlay1");
	nameFile = substring(FileList[i], 0, indexOf(FileList[i], ".tif")); //get file name
	//add text 
    setFont("SansSerif", 200, " antialiased");
    makeText(nameFile, 50, 100);
    run("Flatten");
    rename("image"+j);
    close("Overlay1");
    
	}



rename("image"+j);



if(j == 1)
{
	new1 ="image"+(j-1);
	new2 ="image"+j;
	run("Concatenate...", "open image1=[new1] image2=[new2] ");
    rename("Concatenate");
    close(new1);
    close(new2);
 }
 if(j > 1) {
 	new ="image"+j;
 //	//print(new);
  run("Concatenate...", "open image1=[Concatenate] image2=[new] ");
   rename("Concatenate");
    close(new);
 }
 j = j+1;

  }

print(Math.ceil(j/6));
 rowss = Math.ceil(j/6);
run("Make Montage...", "columns=6 rows=rowss scale=0.25 label");
 //setBatchMode(false);