// Montage tif images with th cfos and roi together prepared befor- Put initial  and last frame-don't add roi regions
//Open directory of the pictures
 inputDir = getDirectory("Choose the images to montage");
 //inputDirRoi = getDirectory("Choose the directory of Roi selection regions");

  Dialog.create("For Montage");
   Dialog.addMessage("Select pictures to montage");
   Dialog.addNumber("Number of first image to montage",1);
   Dialog.addNumber("Number of last image to montage",119);
   
   Dialog.addString("Name of experiment- ","B51-50-TH-_",2);

      
   Dialog.show();
   initialFrame= Dialog.getNumber();
   finalFrame = Dialog.getNumber();
   NameExp = Dialog.getString();
  
  
 //initialFrame = 1; //user input
 //finalFrame = 119; // user input
 FinalExtension = "All-2.tif" //for cfos
 
 j = 0;
 // loop over the desired range
 for (r = initialFrame; r < finalFrame + 1; r++) {
    
  if (File.exists(inputDir + NameExp + r+ FinalExtension)) {	
  	print(inputDir + NameExp + r+ FinalExtension);
      open(inputDir + NameExp + r+ FinalExtension);

 // waitForUser("stop");    
//////add the specific analysis region
//roiManager("reset");

// add text
setFont("SansSerif", 200, " antialiased");
makeText(NameExp + r, 50, 100);
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
selectWindow("" + NameExp + r+ FinalExtension);
close();

j = j+1;

if(j == 2)
{
	new1 =""+ NameExp + initialFrame + "All-1.tif";
	new2 =""+ NameExp + (initialFrame+1) + "All-1.tif";
	run("Concatenate...", "open image1=[new1] image2=[new2] ");
    rename("Concatenate");
 }
 if(j > 2) {
 	new =""+ r + FinalExtension;
 	//print(new);
  run("Concatenate...", "open image1=[Concatenate] image2=[new] ");
   rename("Concatenate");
 }
  }
   }
 print(round(j/6));
 rowss = Math.ceil(j/6);
run("Make Montage...", "columns=6 rows=rowss scale=0.25 label");

   // Headers, font color, and italics
    showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");
