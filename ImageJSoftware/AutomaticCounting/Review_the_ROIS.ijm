////Auxiliary files////////////
function getRoiFile(inputFile){
	aux = substring(inputFile,lastIndexOf(inputFile,"/")+1,indexOf(inputFile,".tif"));
	dir = File.getDirectory(inputFile);
	print(dir);
	
	dir= substring(dir,0,lastIndexOf(dir,"/")-1);
	dir= substring(dir,0,lastIndexOf(dir,"/"));
	print(dir);

	inputRoi = dir + "/ROI/" +"RoiSet" + aux + ".zip";
	return inputRoi;
}
function SortFiles(FileList){
	New = newArray();
	Num = newArray();
	//////        Sort file ///////////   
   for(i = 0; i < FileList.length; i++) { 
     print(FileList[i]);
    // waitForUser("stop");

     a = substring(FileList[i], 0, indexOf(FileList[i], "_")); ///suppose the separation is p
    
    

     New[i] = a;
     Num[i] = parseInt(a);
    }
 
  Array.sort(Num,New,FileList); //Sort New according to the sorting of Num
  
  return FileList;
	
}

//////////////////////////////

//Go over the Rois and try to adapt the rois

//open directory with figures 
///////////////////////////////Begin the program/////////////////////////
 inputDir = getDirectory("Choose a Directory with the folder of the desired images --------");
//////////////////////////////////////////////////////
title = "Choose the staining type";
Dialog.create(title);
Dialog.addChoice("Staining of the cell (as oxytocin):", newArray("Cherry", "Oxytocin","Vasopresin","TH","Dapi","Others")); //this is the name of the folder
Dialog.addMessage("        Note: the roi's should be inside a folder called ROI, which is part of the directory with the pictures \n -Sort data according the first number  ");
Dialog.show();
StainCell = Dialog.getChoice();

/////
list_f = getFileList(inputDir+ StainCell +"/");
Array.print(list_f);

//Sort the data
list = SortFiles(list_f);
Array.print(list_f);

for(s = 0; s < list.length; s++) { 
file_picture = inputDir+ StainCell +"/" + list[s];
inputRoi = getRoiFile(file_picture);
print(inputRoi);
if(File.exists(inputRoi)){
//waitForUser("stop");
//open figure
 open(file_picture);
 //open roi
roiManager("open",inputRoi);
roiManager("show all with labels");

waitForUser("UPDATE and SAVE before you press ok");

roiManager("reset");
//close image and roi manager
close("*");
}
}