// Montage tif images which are inside a given directory
//Open directory of the pictures
// inputDir = getDirectory("Choose the images to montage");
 //inputDirRoi = getDirectory("Choose the directory of Roi selection regions");

 // Dialog.create("For Montage");
 //  Dialog.addMessage("Select pictures to montage");
 //  Dialog.addNumber("Number of first image to montage",1);
  // Dialog.addNumber("Number of last image to montage",119);
   
 //  Dialog.addString("Name of experiment- ","B51-50-TH-_",2);

      
 //  Dialog.show();
//   initialFrame= Dialog.getNumber();
 //  finalFrame = Dialog.getNumber();
 //  NameExp = Dialog.getString();
  
  
 //initialFrame = 1; //user input
 //finalFrame = 119; // user input
 //FinalExtension = "All-2.tif" //for cfos
inputDir1 = getArgument();
inputDir = inputDir1 + "/";
FileList = getFileList(inputDir);
largo = FileList.length;
initialFrame = 0;
finalFrame = largo;
OutputDir = substring(inputDir1,0,lastIndexOf(inputDir1, "/")+1);
print(OutputDir);


//
StringyList =newArray(largo);
for(s = 0; s < largo; s++) {
	 a= File.getNameWithoutExtension(inputDir +FileList[s]); 
     b = substring(a, indexOf(a,"_") + 1, indexOf(a,"All"));
     StringyList[s] = parseInt(b); 
     }
    Array.print(StringyList);
    
     Array.sort(StringyList, FileList); //Arrange according to last number
//
 
 j = 0;
 // loop over the desired range
 for (r = initialFrame; r < finalFrame; r++) {
 a= File.getNameWithoutExtension(inputDir +FileList[r]);  

   if (File.exists(inputDir + a + ".tif")) {	//only tif files accept
  	
      open(inputDir + FileList[r]);
   
     NameExp = substring(a, 0, indexOf(a,"All"));

  
//////add the specific analysis region
//roiManager("reset");

// add text
setFont("SansSerif", 200, " antialiased");
makeText(NameExp, 50, 100);
//roiManager("Add", "red");
//roiManager("Set Fill Color", "#88000000"); 
run("Show Overlay");
//waitForUser('stop');



//roiManager("open", inputDirRoi  + NameExp + r + ".zip" );
//roiManager("Show All without labels");
//roiManager("Show All");
//roiManager("Set Color", "yellow");
//roiManager("Set Line Width", 2);

// flatten the overlay
run("RGB Color");
run("Flatten");
//waitForUser("wait");
selectWindow("" + FileList[r]);
close();
rename(a + "All-6.tif");

j = j+1;
if(j==1){
	first = a;
}
if(j == 2)
{
	new1 =""+ first + "All-6.tif";
	new2 =""+ a + "All-6.tif";
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
saveAs("Tiff", OutputDir + NameExp1 + "Montage.tif" );
  
run("Close All");
