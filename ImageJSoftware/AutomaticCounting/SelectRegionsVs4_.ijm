                     
///////////////////////////////////////////Auxiliary function //////////////////////////////
function FindIndex(	FileListROI,qRoi,BeginROI) {
   for(i = 0; i < qRoi; i++) { 
   	 //a = substring(FileListROI[i],"_");
   	 a = startsWith(FileListROI[i],"RoiSet"+BeginROI);
   	 print(FileListROI[i]);
   	 print(a);
   	 //print(BeginROI);
   	// waitForUser;

   	 if(a){
       Index = i;
    }

	
}
        return Index;
}
///
function CreateArrayIndex(n) {
      ArrayIndex=newArray(n);
  for (ii = 0; ii < n; ii++) {
       ArrayIndex[ii]=ii;

    }
 return ArrayIndex;
	
}
//////////////////////////////////////////////////////
stringy = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
title = "Choose channel to select the desired regions";
Dialog.create(title);
Dialog.addChoice("Type:", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers","Overlay 2 channels","Overlay 3 channels","Overlay 4 channels","Others","LabeledImagesOfTH")); //this is the name of the folder
Dialog.addCheckbox("Sort the slides according to the last number", false);
Dialog.addCheckbox("Sort the slides according to the first number", false);
Dialog.addNumber("From which slide to begin:", 1);
Dialog.addCheckbox("Add given ROI to each image ONLY TO SORTING CASES", false);
Dialog.show();
type = Dialog.getChoice();
print(type);
sorting = Dialog.getCheckbox();
sortingF = Dialog.getCheckbox();
NumberSlideBegin = Dialog.getNumber();
AddROI = Dialog.getCheckbox();
//////////////////////////////
if(AddROI){
	AddROIDir= getDirectory("Choose a Directory with the folder of the desired ROI --------");
	Dialog.create(" ");
	Dialog.addNumber("From which ROI number to begin -give first number:", 1);
	Dialog.show();
	BeginROI = Dialog.getNumber();
}



//////////////////
if(type == "Overlay 2 channels"){
Dialog.create("Choose 2 channels to overlay");	
Dialog.addChoice("Channel 1  green (as oxytocin):", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.addChoice("Channel 2: red (as vasopresin)", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.show();
typeOverlay1 = Dialog.getChoice();
typeOverlay2 = Dialog.getChoice();	
print(typeOverlay1);
print(typeOverlay2);
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
print(typeOverlay1);
print(typeOverlay2);
print(typeOverlay3);
}
//
if(type == "Overlay 4 channels"){
Dialog.create("Choose 4 channels to overlay");	
Dialog.addChoice("Channel 1  blue (as dapi):", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.addChoice("Channel 2: red (as TH)", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.addChoice("Channel 3: green (as cfos)", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));
Dialog.addChoice("Channel 4: gray (as fibers)", newArray("Dapi", "Cfos", "Cherry", "Oxytocin","Vasopresin","TH","Fibers"));

Dialog.show();
typeOverlay1 = Dialog.getChoice();
typeOverlay2 = Dialog.getChoice();	
typeOverlay3 = Dialog.getChoice();
typeOverlay4 = Dialog.getChoice();
print(typeOverlay1);
print(typeOverlay2);
print(typeOverlay3);
}



////////////////////////////
  //Arrays made for later use.
  if(type =="Overlay 2 channels" || type =="Overlay 3 channels" || type =="Overlay 4 channels"){
  	FileList = getFileList(stringy+ typeOverlay1 + "\\");}
  else{ 
    FileList = getFileList(stringy+ type + "\\");}
    
    File.makeDirectory(stringy +"ROI/");
    q = FileList.length; 
    New =newArray(q);
if(sorting) {    
      // to save slide name
    Num =newArray(q); // to save slide number for sorting
//////        Sort file ///////////   
   for(i = 0; i < q; i++) { 
     a = substring(FileList[i], 0, lastIndexOf(FileList[i], "."));
     IndexAux = lastIndexOf(a, "_");
     num = substring(a, IndexAux+1);
     New[i] = a;
     Num[i] = parseInt(num);
    }
 
  Array.sort(Num,New,FileList); //Sort New according to the sorting of Num
  
}else if(sortingF){ //// with sorting of first number///
	    // to save slide name
    Num =newArray(q); // to save slide number for sorting
    
//////        Sort file ///////////   
   for(i = 0; i < q; i++) { 
   	print(FileList[i]);
   	

     a = substring(FileList[i], 0, indexOf(FileList[i], "_"));
   //  IndexAux = lastIndexOf(a, "_");
    // num = substring(a, IndexAux+1);
     num = a;
     b = substring(FileList[i], 0, lastIndexOf(FileList[i], "."));
     New[i] = b;
     Num[i] = parseInt(num);
    }
 
  Array.sort(Num,New,FileList); //Sort New according to the sorting of Num
	
	} 

 else { //////        without sort  ///////////   
   for(i = 0; i < q; i++) { 
     a = substring(FileList[i], 0, lastIndexOf(FileList[i], "."));
     New[i] = a;
     print(a);
    }
   }
   print(q);
   print(NumberSlideBegin);
 //  waitForUser("stop");
   
//////////////////////////////////////////////////////////////
//Find the index begin of the initial Roi
   if(AddROI){
   	FileListROI = getFileList(AddROIDir);
   	qRoi = FileListROI.length; 
 //////////////////////////  	
   	//DO SORT
   	Num1 =newArray(qRoi);
   	   for(j = 0; j < qRoi; j++) { 
     a1 = substring(FileListROI[j], 0, indexOf(FileListROI[j], "_")); //get RoiSet with number
     //IndexAux = IndexOf(a1, "t"); //of RoiSet
     num1 = substring(a1, 6,lengthOf(a1));
     print(num1);
   

     Num1[j] = parseInt(num1);
    }
 
  Array.sort(Num1,FileListROI); //Sort New according to the sorting of Num
/////////////////////////////////////////////
   	//find in new which one has the given number
    	IndexFileROI = FindIndex(FileListROI,qRoi,BeginROI);	 
    	print(IndexFileROI);
    	print(FileListROI[IndexFileROI]);
    	countROI = IndexFileROI;  
   }
 ///////////////////////////////////////////////////////////////  
//////////////////// begin loop over the files ///////////////////// 

 for (p = (NumberSlideBegin-1) ; p < q; p++) {
 //according to the sorting
////////////////////////////////////////////////////
if(type =="Overlay 2 channels"){
///////////////////////////////////////////
if(typeOverlay1 == "Dapi"){ color = "Blue";}
if(typeOverlay1 == "Cfos"){ color = "Green";}
if(typeOverlay1 == "Cherry"){ color = "Red";}
if(typeOverlay1 == "Oxytocin"){ color = "Green";}
if(typeOverlay1 == "Vasopresin"){ color = "Magenta";}
if(typeOverlay1 == "TH"){ color = "Magenta";}
if(typeOverlay1 == "Fibers"){ color = "Grays";}

if(typeOverlay2 == "Dapi"){ color2 = "Blue";}
if(typeOverlay2 == "Cfos"){ color2 = "Green";}
if(typeOverlay2 == "Cherry"){ color2 = "Red";}
if(typeOverlay2 == "Oxytocin"){ color2 = "Green";}
if(typeOverlay2 == "Vasopresin"){ color2 = "Magenta";}
if(typeOverlay2 == "TH"){ color2 = "Magenta";}
if(typeOverlay2 == "Fibers"){ color2 = "Grays";}

///////////////////////////////////	
	print(stringy + typeOverlay1 + "\\"+ FileList[p]);
	open(stringy + typeOverlay1 + "\\"+ FileList[p]);
	run(color);
	rename(color);
	open(stringy + typeOverlay2 + "\\"+ FileList[p]);
	run(color2);
	rename(color2);
	selectWindow(color);
	run("Merge Channels...", "c1=["+color+"] c2=["+color2+"] create");
	//run("Add Image...", "image=color2 x=0 y=0 opacity=50");
	rename(FileList[p]);
	close(color2);
	
	
} else if(type =="Overlay 3 channels") {
///////////////////////////////////////////
if(typeOverlay1 == "Dapi"){ color = "Blue";}
if(typeOverlay1 == "Cfos"){ color = "Cyan";}
if(typeOverlay1 == "Cherry"){ color = "Red";}
if(typeOverlay1 == "Oxytocin"){ color = "Green";}
if(typeOverlay1 == "Vasopresin"){ color = "Magenta";}
if(typeOverlay1 == "TH"){ color = "Magenta";}
if(typeOverlay1 == "Fibers"){ color = "Grays";}

if(typeOverlay2 == "Dapi"){ color2 = "Blue";}
if(typeOverlay2 == "Cfos"){ color2 = "Cyan";}
if(typeOverlay2 == "Cherry"){ color2 = "Red";}
if(typeOverlay2 == "Oxytocin"){ color2 = "Green";}
if(typeOverlay2 == "Vasopresin"){ color2 = "Magenta";}
if(typeOverlay2 == "TH"){ color2 = "Magenta";}
if(typeOverlay2 == "Fibers"){ color2 = "Grays";}

if(typeOverlay3 == "Dapi"){ color3 = "Blue";}
if(typeOverlay3 == "Cfos"){ color3 = "Cyan";}
if(typeOverlay3 == "Cherry"){ color3 = "Red";}
if(typeOverlay3 == "Oxytocin"){ color3 = "Green";}
if(typeOverlay3 == "Vasopresin"){ color3 = "Magenta";}
if(typeOverlay3 == "TH"){ color3 = "Magenta";}
if(typeOverlay3 == "Fibers"){ color3 = "Grays";}

///////////////////////////////////	
	print(stringy + typeOverlay1 + "\\"+ FileList[p]);
	open(stringy + typeOverlay1 + "\\"+ FileList[p]);
	run(color);
	rename(color);
	print(stringy + typeOverlay2 + "\\"+ FileList[p]);
	open(stringy + typeOverlay2 + "\\"+ FileList[p]);
	run(color2);
	rename(color2);
	
	print(stringy + typeOverlay3 + "\\"+ FileList[p]);
	open(stringy + typeOverlay3 + "\\"+ FileList[p]);
	run(color3);
	rename(color3);
	selectWindow(color);
	
	run("Merge Channels...", "c1=["+color+"] c2=["+color2+"] c3=["+color3+"] create");
	//run("Add Image...", "image=color2 x=0 y=0 opacity=50");
	rename(FileList[p]);
	close(color2);
	close(color3);
}

else if(type =="Overlay 4 channels") {
///////////////////////////////////////////
if(typeOverlay1 == "Dapi"){ color = "Blue";}
if(typeOverlay1 == "Cfos"){ color = "Green";}
if(typeOverlay1 == "Cherry"){ color = "Red";}
if(typeOverlay1 == "Oxytocin"){ color = "Green";}
if(typeOverlay1 == "Vasopresin"){ color = "Magenta";}
if(typeOverlay1 == "TH"){ color = "Magenta";}
if(typeOverlay1 == "Fibers"){ color = "Grays";}

if(typeOverlay2 == "Dapi"){ color2 = "Blue";}
if(typeOverlay2 == "Cfos"){ color2 = "Green";}
if(typeOverlay2 == "Cherry"){ color2 = "Red";}
if(typeOverlay2 == "Oxytocin"){ color2 = "Green";}
if(typeOverlay2 == "Vasopresin"){ color2 = "Magenta";}
if(typeOverlay2 == "TH"){ color2 = "Magenta";}
if(typeOverlay2 == "Fibers"){ color2 = "Grays";}

if(typeOverlay3 == "Dapi"){ color3 = "Blue";}
if(typeOverlay3 == "Cfos"){ color3 = "Green";}
if(typeOverlay3 == "Cherry"){ color3 = "Red";}
if(typeOverlay3 == "Oxytocin"){ color3 = "Green";}
if(typeOverlay3 == "Vasopresin"){ color3 = "Magenta";}
if(typeOverlay3 == "TH"){ color3 = "Magenta";}
if(typeOverlay3 == "Fibers"){ color3 = "Grays";}

if(typeOverlay4 == "Dapi"){ color4 = "Blue";}
if(typeOverlay4 == "Cfos"){ color4 = "Green";}
if(typeOverlay4 == "Cherry"){ color4 = "Red";}
if(typeOverlay4 == "Oxytocin"){ color4 = "Green";}
if(typeOverlay4 == "Vasopresin"){ color4 = "Magenta";}
if(typeOverlay4 == "TH"){ color4 = "Magenta";}
if(typeOverlay4 == "Fibers"){ color4 = "Grays";}

///////////////////////////////////	
	print(stringy + typeOverlay1 + "\\"+ FileList[p]);
	open(stringy + typeOverlay1 + "\\"+ FileList[p]);
	run(color);
	rename(color);
	open(stringy + typeOverlay2 + "\\"+ FileList[p]);
	run(color2);
	rename(color2);
	open(stringy + typeOverlay3 + "\\"+ FileList[p]);
	run(color3);
	rename(color3);
	open(stringy + typeOverlay4 + "\\"+ FileList[p]);
	run(color4);
	rename(color4);
	selectWindow(color);
	run("Merge Channels...", "c1=["+color+"] c2=["+color2+"] c3=["+color3+"] c4=["+color4+"] create");
	//run("Add Image...", "image=color2 x=0 y=0 opacity=50");
	rename(FileList[p]);
	close(color2);
	close(color3);
	close(color4);
}


else {

    print(stringy);
    print(type);
  
    open(stringy + type + "\\"+ FileList[p]);
}
///////////////////////////////////////////////////     
     run("ROI Manager...");
    if(AddROI){ //open the wanted ROI
    	roiManager("reset");
    	if(countROI < qRoi){
        roiManager("open", AddROIDir + 	FileListROI[countROI] );}
        countROI = countROI +1;
    }
     
     roiManager("Show All with labels");
     waitForUser("1- Select with one of the tools your Roi \n 2- Press Add \n  3- Rename the selection or update selection \n  5- Press ok to go forward or \n Press shift+ok to go reverse");
     //Add roi manager select all-and update 
     nc=roiManager("count");
     Reg=CreateArrayIndex(nc);
     roiManager("select", Reg);
     roiManager("update");
     print(stringy + "ROI/" + New[p] + ".zip");
      roiManager("save", stringy + "ROI/"+"RoiSet" + New[p] + ".zip");//save roi selection
     //// in the case of reverse
     if (isKeyDown("Shift") == true) {
     	 close(FileList[p]);
     	p=p-2;
       countROI=countROI-2;
      
      } else {
   
   close(FileList[p]);}
     
   
 }

 close("*");
 showMessage("Finished");