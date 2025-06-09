// Montage tif images with fibers segmentation- Put initial  and last frame-Also add roi regions
//Open directory of the pictures

file = getArgument();
//waitForUser('stop');

 inputDir = file + "/";
 inputDirRoi = substring(file, 0, lastIndexOf(file, "/")) + "/" + "ROI/";
OutputDir = substring(file,0,lastIndexOf(file, "/")+1);


 // Dialog.create("For Montage");
 //  Dialog.addMessage("Select pictures to montage");
//   Dialog.addNumber("Number of first image to montage",1);
//   Dialog.addNumber("Number of last image to montage",119);
   
//   Dialog.addString("Name of experiment- in case of fibers without the initial f","B54-143-_",20);

//      
//   Dialog.show();
 //  initialFrame= Dialog.getNumber();
//   finalFrame = Dialog.getNumber();
//   NameExp = Dialog.getString();
//  first = substring(file, lastIndexOf(file, "B"), lastIndexOf(file, "/"));
//  second = substring(file, lastIndexOf(file, "/")+1);
 // NameExp = first + "-" + second + "-TH-_";
 
  ROIList  = getFileList(inputDirRoi);
  FileList = getFileList(inputDir);
  largo=FileList.length;
  initialFrame = 0;
finalFrame = largo;
 //To automatize
 
StringyList =newArray(largo);
for(s = 0; s < largo; s++) {
	 a= File.getNameWithoutExtension(inputDir +FileList[s]); 
     b = substring(a, indexOf(a,"_") + 1);
     StringyList[s] = parseInt(b); 
     }
    Array.print(StringyList);
    
     Array.sort(StringyList, FileList,ROIList); //Arrange according to last number
//
  
 Array.print(FileList);
  Array.print(ROIList);
 //initialFrame = 1; //user input
 //finalFrame = 119; // user input
 
 slide=0;
 j = 0;
 // loop over the desired range
 for (r = initialFrame; r < finalFrame; r++) {
   a= File.getNameWithoutExtension(inputDir +FileList[r]);
    NameExp = a;
  if (File.exists(inputDir + a + ".tif")) {	
      open(inputDir + FileList[r]);
      slide =slide +1;
//////add the specific analysis region
roiManager("reset");

// add text
setFont("SansSerif", 300, " antialiased");
makeText( NameExp, 50, 100);
roiManager("Add", "red");
roiManager("Set Fill Color", "#88000000"); 
run("Show Overlay");


roiManager("open",  inputDirRoi + ROIList[r] );
roiManager("Set Color", "red");
roiManager("Set Line Width", 4);
roiManager("Show All with labels");
//roiManager("List");
run("Labels...", "color=orange font=100 show use");
 run("Flatten");
rename("Flat" + FileList[r]);

 
// flatten the overlay
run("RGB Color");
run("Flatten");
selectWindow(""+ FileList[r]);
close();
selectWindow(""+ "Flat" + FileList[r]);
close();

rename(a + "All-6.tif");
//waitForUser("stop");
j = j+1;
if(j==1){
	first = a;
}
if(j == 2)
{
	new1 =""+ NameExp + first + "All-6.tif";
	new2 =""+ NameExp + a + "All-6.tif";
	run("Concatenate...", "open image1=[new1] image2=[new2] ");
    rename("Concatenate");
 }
 if(j > 2) {
 	new =""+ a + "All-6.tif";
 	//print(new);
  run("Concatenate...", "open image1=[Concatenate] image2=[new] ");
   rename("Concatenate");
 }
  }
   }
 print(round(j/6));
 rowss = Math.ceil(j/6);
run("Make Montage...", "columns=6 rows=rowss scale=0.25 label");
NameExp1 = substring(NameExp, 0, lastIndexOf(NameExp, "_"));
saveAs("Tiff", OutputDir + NameExp1 + "Montage1.tif" );
   // Headers, font color, and italics
   // showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
run("Close All");