// Montage tif images with fibers segmentation- Put initial  and last frame-Also add roi regions
//Open directory of the pictures

file = getArgument();
//waitForUser('stop');

 inputDir = file + "/" + "Traced Images/";
 inputDirRoi = file + "/" + "ROI/";

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
  first = substring(file, lastIndexOf(file, "B"), lastIndexOf(file, "/"));
  second = substring(file, lastIndexOf(file, "/")+1);
  NameExp = first + "-" + second + "-TH-_";
 



  
  FileList = getFileList(inputDir);
  largo=FileList.length;
  
 //initialFrame = 1; //user input
 //finalFrame = 119; // user input
 
 slide=0;
 j = 0;
 // loop over the desired range
 for (r = 0; r < largo; r++) {
    
  if (File.exists(inputDir + "f" + NameExp + r+".tif")) {	
      open(inputDir+ "f" + NameExp  + r+".tif");
      slide =slide +1;
//////add the specific analysis region
roiManager("reset");

// add text
setFont("SansSerif", 300, " antialiased");
makeText( NameExp + r, 50, 100);
roiManager("Add", "red");
roiManager("Set Fill Color", "#88000000"); 
run("Show Overlay");


roiManager("open", inputDirRoi  + NameExp  + r + ".zip" );
roiManager("Show All without labels");
//roiManager("Show All");
roiManager("Set Color", "yellow");
roiManager("Set Line Width", 2);

// flatten the overlay
run("RGB Color");
run("Flatten");
selectWindow(""+ "f" + NameExp  + r+".tif");
close();

j = j+1;

if(j == 2)
{
	new1 =""+ NameExp + slide + "f-1.tif";
	new2 =""+ NameExp + (slide+1) + "f-1.tif";
	run("Concatenate...", "open image1=[new1] image2=[new2] ");
    rename("Concatenate");
 }
 if(j > 2) {
 	new =""+ r + "f-1.tif";
 	//print(new);
  run("Concatenate...", "open image1=[Concatenate] image2=[new] ");
   rename("Concatenate");
 }
  }
   }
 print(round(j/6));
 rowss = Math.ceil(j/6);
run("Make Montage...", "columns=6 rows=rowss scale=0.25 label");
saveAs("Tiff", inputDir + NameExp + "IntMax300.tif" );
   // Headers, font color, and italics
   // showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
run("Close All");