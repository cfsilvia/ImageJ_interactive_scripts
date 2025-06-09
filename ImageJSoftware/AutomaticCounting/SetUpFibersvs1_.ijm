/////////////////////////////////Auxiliary functions/////////////////////////////////////////////////////////
///
function FindIndex( ) {
  for (ii = 0; ii < q ; ii++) {
       if(NumSlide[ii] == Myhighindex){
       	 IndexA = ii;
       }

    }
 return IndexA;
	
}


///////////////////////////////////---------------------------------------------------------------
// This makes the pop up at the beginning with instructions
// Unordered lists, headers, and text modifiers
//showMessage("1/1", "<html>" + "<h1>ImageJ Java bundle 1.6" + "<li>Analysis option (3) and (4) only run correctly with Java 1.6 (link for download is available on Poplawski-lab.com)" + "</ul><h1>General Instructions</h1>" + "<ul>" + "<li>This software was downloaded from www.poplawski-lab.com/axontracer" + "<li>For Updates and comments refer to www.poplawski-lab.com/axontracer" + "</ul><h4>Install featureJ derivatives:</h4><ul>" + "<li>For ImageJ (http://www.imagescience.org/meijering/software/featurej/)" + "<li>For FIJI: >HELP >UPDATE >Manage update sitesCHECK ImageScience(http://sites.imagej.net/ImageScience/) >CLOSE and >APPLY CHANGES" + "</ul><h4>Image Folder:</h4><ul>" + "<li>Image names can only be numbers (e.g. 1.tif) and not start with Zero (e.g. 01.tif is not allowed)" + "<li>Image folder must ONLY contain images to be analysed" + "<li>Images must be (RGB) and can be of diverse dimensions or formats"+"<li>Image Folder located on a shared drive can lead to errors"+"</ul>"+"</ul><h4>Definition of Variables:</h4><ul>" + "<li>In Analysis Mode 2 (automatic ROI detection): The ROI is increased by 60 pixels and then reduced by 90 pixels. The variables enlargeROI (line 8) and reduceROI (line 9) can manually be altered in the journal script" +"</ul>"+"<h1>License:</h1>" + "<ul>" + "<li>Licensed under GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007"+"</ul>"+"<h1>General Comments:</h1>" + "<ul>" + "<li>Only runs on Windows and not on MAC (but can be run in virtual Windows on MAC)" + "<li>When run in virtual windows on a Mac, the processing power should be reduced to avoid glitches during the detection parameter setting step. The analysis itself can be run in full power mode."+"<li>Once the analysis is in autorun mode, do not interfere with ImageJ or ideally do not touch the computer until you see the 'Analysis complete' message."+"</ul>");
//showMessage("This scripts is doing the segmentation of fibers")
/////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////Settings //////////////////////////////

// All of the images are sorted within these following loops	

//For automatically defining the ROI, we have two variable that can be easily changed to any number user wants, which are enlarge size and reduce size of the ROI
enlargeROI = 60;
reduceROI = -90;
run("Set Measurements...", "area mean integrated redirect=None decimal=5");



//////////////////////////////////
    //Arrays made for later use.
    stringy = getDirectory("Choose a Directory with the folder of the desired images --------");
    FileList = getFileList(stringy + "Fibers/"); // the file is composed of a name plus a number
    q = FileList.length; 
    Filenames =newArray(q);
    NumSlide = newArray(q);
//////        Sort file ///////////   
   for(i = 0; i < q; i++) { 
     a = substring(FileList[i], 0, lastIndexOf(FileList[i], "."));
     IndexAux = lastIndexOf(a, "_");
     num = substring(a, IndexAux+1);
     Filenames[i] = a;
     NumSlide[i] = parseInt(num);
    }
    Array.sort(NumSlide,Filenames,FileList); //Sort the arrays according to the sorting of NumSlide
//
    axonaverage = newArray(q); //stores image Mean pixel inten
    axonsortaverage = newArray(q); //to be sorted

    j = 1; //counter variable for result sorting to be done at the end
    counter = 0;
    setBackgroundColor(0, 255, 255);
    setForegroundColor(253, 253, 253);

    //----------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------


    //purpose: Obtain Axon sensitivity value
    //--------------------------
    //---------------------------
 //Calibrate your region
   Dialog.create(" ");
   Dialog.addCheckbox("	Begin your calibration ", true);
   Dialog.addMessage("Select IMAGE REPRESENTATIVE OF YOUR REGION -USE THE MONTAGE");
   Dialog.addNumber("ADD NUMBER OF THE SELECTED IMAGE",1);
   Dialog.show();
   Myhighindex = Dialog.getNumber();
   a = Dialog.getCheckbox();
   count =1;
 while(a){ // finish when the user calibrate all the regions
  //get image with axons for calibration
   IndexA =FindIndex( );//find the index for calibration
   roiManager("open", stringy + "ROI\\" + Filenames[IndexA] + ".zip" );
   Dialog.create("Axon Segmentation");
   Dialog.addMessage("SELECT REGION TO CALIBRATE");
   Dialog.addString("ADD EXACTLY THE NAME OF THE REGION YOU USE IN THE ROI- not neccessary left or right", "");
   Dialog.show();
   Region = Dialog.getString();
   
 
   print(Region);
   print(Myhighindex);

///////////////////////////////////////
    //we open the medium axon image.

   open(stringy + "Fibers\\" + FileList[IndexA]);
    wait(25);
    run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
   // run("8-bit");
    rename("image2");
    selectWindow("image2");
    wait(25);
    run("Duplicate...", "title=Fibers");
    wait(25);
    selectWindow("Fibers");

    wait(25);

    run("Duplicate...", "title=Fibers2");
    wait(25);

    selectWindow("Fibers");
    close();
    selectWindow("Fibers2");
   run("Duplicate...", "title=Fibers3");
    wait(25);
    selectWindow("Fibers3");
    getRawStatistics(nPixels, Mean, min, max, std, histogram);
    run("Close");
    close("Fibers3");
    wait(25);

    selectWindow("Fibers2");

//////////////////////////////////////////////////////////////////////////////////
    //user selected area in order to input axon detection parameters

   // makeRectangle(0, 0, 400, 400);
    run("Brightness/Contrast...");
    waitForUser("Adjust the image intensity to see very clear your region, Click OK when done.");

    getMinAndMax(min, max);
    print(min);
    print(max);
    Minimo=min;
    Maximo=max;
    setMinAndMax(Minimo,Maximo);
    print(min);
    print(max);
   
    waitForUser("Please mark the selected region with representative axons intensities you want to detect, you can change its size if you wish, Click OK when done.");

    run("Duplicate...", "title=faintAxons");
    selectWindow("faintAxons");
    run("Duplicate...", "title=faintAxonsAux");
    
// Save for following use
    File.makeDirectory(stringy + "AuxiliaryImages" + "/");
    saveAs("Tiff",stringy + "AuxiliaryImages" + "/" + "faintAxonsHR" + ".tif"); //save a subdirectory of crop images
    close("faintAxonsHR" + ".tif");
    selectWindow("faintAxons");
    run("8-bit");
    close("\\Others");
   roiManager("reset"); 

  // waitForUser("step 1");
    //---------------------------------------------------------------
    //--------------------------------------------------------------
    //user input repeating while loop to find THRESHY!
    //--------------------------------------------------------------

    //initial axon parameters
    Threshy = 10;//5
    MinAxonLength = 15;
    ThresholdFactor = 0.75;
//------------------------------------------------------------------------------------------------
   Continue = false; //while loop condition

    while (Continue == false) {

        //----------------------------------------------------------
        //this is to destroy all of the holes, holes are thresholded and created into an ROI
        //----------------------------------------------------------
        //----------------------------------------------------------
        wait(25);
        run("Duplicate...", "title=HoleKiller");
        wait(25);
        getRawStatistics(nPixels, Mean, min, max, std, histogram);
        getDimensions(width, height, channels, slices, frames);

        run("Threshold...");
        setAutoThreshold("Default dark");
        setThreshold(0, ThresholdFactor * Mean);
        setOption("BlackBackground", false);
        run("Convert to Mask");
        run("Create Selection");
        if (selectionType() != -1) {
            roiManager("Add"); //roi of holes
            BoxHoles = roiManager("count") - 1;
        } else {
            BoxHoles = -1;
        }
        selectWindow("HoleKiller");
        close();


        //-----------------------------------------------------
        //-------------------------------------------------------


        //calculates derivitive in x direction
        run("FeatureJ Derivatives", "x-order=1 y-order=0 z-order=0 smoothing=1.0");

        rename("GradientX");

        wait(25);


        //Zero's out the holes area
        //Because we are dealing with a 32 bit image, its kind of difficult
        // to simply set a pixel to a value.  As a result, I guess a value
        // and check to see what value it corresponds to on the derivitive image
        //I  then loop until that value converges to a small number, and use this
        //value to essentially zero the holes.


        if (BoxHoles > -1) {
            roiManager("Select", BoxHoles);
            getRawStatistics(nPixels, Mean, min, max, std, histogram);
            getDimensions(width, height, channels, slices, frames);

            xx = 128;
            setForegroundColor(xx, xx, xx);
            setBackgroundColor(xx, xx, xx);
            makeRectangle(0, 0, 1, 1);
            run("Fill", "slice");
            while (abs(getPixel(0, 0)) > 0.5) {
                setForegroundColor(xx, xx, xx);
                setBackgroundColor(xx, xx, xx);
                makeRectangle(0, 0, 1, 1);
                run("Fill", "slice");
                if (getPixel(0, 0) > 0) {
                    xx = xx - 1;
                } else {
                    xx = xx + 1;
                }

                counter = counter + 1;
            }

            setForegroundColor(xx, xx, xx);
            setBackgroundColor(xx, xx, xx);

            roiManager("Select", BoxHoles);
            wait(25);
            run("Fill", "slice");

        }






        //Here, the gradient image is inverted using nested for loops.
        //This is done to make thresholding easier later on.

        getDimensions(width, height, channels, slices, frames);
        for (ii = 0; ii < width; ii++) {


            for (jj = 0; jj < height; jj++) {
                currentvalue = getPixel(ii, jj);


                setPixel(ii, jj, 1 / currentvalue);





            }




        }


        wait(25);





        //This is the thresholding step

        getRawStatistics(nPixels, Mean, min, max, std, histogram);
        run("Threshold...");
        setAutoThreshold("Default dark");
        setThreshold(-1 / Threshy, 1 / Threshy);
        wait(50);


        run("Convert to Mask");
        wait(50);
        run("Make Binary");
        wait(50);



        run("Create Selection");
        if (selectionType() != -1) {
            roiManager("Add"); //roi[0]Axons in X
            BoxAxonsInX = roiManager("count") - 1;
        } else {
            BoxAxonsInX = -1;
        }
        selectWindow("GradientX");
        close();





        //The process is repeated for the y-direction.

        run("FeatureJ Derivatives", "x-order=0 y-order=1 z-order=0 smoothing=1.0");
        wait(25);
        rename("GradientY");
        wait(25);




        if (BoxHoles > -1) {
            roiManager("Select", BoxHoles);
            getRawStatistics(nPixels, Mean, min, max, std, histogram);
            getDimensions(width, height, channels, slices, frames);

            xx = 128;
            setForegroundColor(xx, xx, xx);
            setBackgroundColor(xx, xx, xx);
            makeRectangle(0, 0, 1, 1);
            run("Fill", "slice");
            while (abs(getPixel(0, 0)) > 0.5) {
                setForegroundColor(xx, xx, xx);
                setBackgroundColor(xx, xx, xx);
                makeRectangle(0, 0, 1, 1);
                run("Fill", "slice");
                if (getPixel(0, 0) > 0) {
                    xx = xx - 1;
                } else {
                    xx = xx + 1;
                }

                counter = counter + 1;
            }


            setForegroundColor(xx, xx, xx);
            setBackgroundColor(xx, xx, xx);

            roiManager("Select", BoxHoles);
            wait(25);
            run("Fill", "slice");
        }






        getDimensions(width, height, channels, slices, frames);
        for (ii = 0; ii < width; ii++) {


            for (jj = 0; jj < height; jj++) {
                currentvalue = getPixel(ii, jj);


                setPixel(ii, jj, 1 / currentvalue);





            }




        }


        wait(25);



        run("Threshold...");
        setAutoThreshold("Default dark");
        setThreshold(-1 / Threshy, 1 / Threshy);
        run("Convert to Mask");
        wait(50);
        run("Make Binary");
        wait(50);


        run("Create Selection");
        if (selectionType() != -1) {
            roiManager("Add"); //roi[1]Axons in Y
            BoxAxonsInY = roiManager("count") - 1;
        } else {
            BoxAxonsInY = -1;
        }
        selectWindow("GradientY");
        close();


        selectWindow("faintAxons");
        getDimensions(width, height, channels, slices, frames);
        newImage("Skeleton", "8-bit white", width, height, 1);

        setForegroundColor(0, 0, 0);
        setBackgroundColor(0, 0, 0);



        //Now, we take the detection from the x and y directions and overlay them
        if (BoxAxonsInX > -1 && BoxAxonsInY > -1) {
            roiManager("Select", BoxAxonsInX);
            run("Fill", "slice");
            roiManager("Select", BoxAxonsInY);
            run("Fill", "slice");
        }
        run("Create Selection");

        //this enlarge step is done to clear holes in the center if any.
        run("Enlarge...", "enlarge=1");
        run("Enlarge...", "enlarge=-1");

        if (selectionType() != -1) {

            roiManager("Add"); //roi[2] blob axons
            BoxBlobAxons = roiManager("count") - 1;
        } else {
            BoxBlobAxons = -1;
        }


        selectWindow("Skeleton");
        if (BoxBlobAxons > -1) {
            roiManager("Select", BoxBlobAxons);

            run("Fill", "slice");
        }

        //Here, the blobs are skeletonized and then trimmed based on the minimum axon length
        run("Make Binary");
        run("Skeletonize");

        run("Analyze Particles...", "size=MinAxonLength show=Masks");
        //gets rid of axons of length size

        run("Create Selection");

        if (selectionType() != -1) {
            roiManager("Add"); //roi[3] skeletonized axonz
            BoxSkeletonizedAxons = roiManager("count") - 1;
        } else {
            BoxSkeletonizedAxons = -1;
        }

        selectWindow("Skeleton");
        close();
        wait(25);

        selectWindow("faintAxons");
       // waitForUser("step2");

        //Here the skeletonized axons are overlayed to the image
        close("\\Others");
		run("Duplicate...", "title=Without Segmentation");
		selectWindow("faintAxons");
		//waitForUser("step3");
        if (BoxSkeletonizedAxons > -1) {

            wait(500);
            roiManager("Select", BoxSkeletonizedAxons);
			//wait(500);
			//selectWindow("test");
			//wait(500);
			//selectWindow("faintAxons");
			//wait(500);
			//selectWindow("test");
			//wait(500);
			//selectWindow("faintAxons");
	      //open(stringy + "AuxiliaryImages" + "/" + "faintAxonsHR" + ".tif");
	      //roiManager("Select", BoxSkeletonizedAxons);
        }

         waitForUser("Separate overlap images and click ok");

//Make montage to see better
    //    
//selectWindow("test");
    //    run("Flatten");
     //   selectWindow("faintAxons");
   //     run("Flatten");
   //     run("Concatenate...", "keep image1=test-1 image2=faintAxons-1  image3=[-- None --]");
    //    run("Make Montage...", "columns=2 rows=1 scale=0.25");
    //    close("test");
     //   close("faintAxons");
      
      
//--------------------------------------
        //Here the user input for the axon detection parameters occurs.
        Dialog.create("Axon Detection Parameters");

        Dialog.addNumber("ThresholdFactor (lower threshold in the whole picture)", ThresholdFactor);
        Dialog.addNumber("Axon Detection Sensitivity, (larger # = less sensitive)", Threshy);
        Dialog.addNumber("Minimum Axon Length [pixel]", MinAxonLength);
        Dialog.addCheckbox("Check to accept settings", false);
        Dialog.show();

        ThresholdFactor = Dialog.getNumber();
        Threshy = Dialog.getNumber();
        MinAxonLength = Dialog.getNumber();
        
 
        Continue = Dialog.getCheckbox();

// --------------------------------------------------------------------




        print("Threshy is now " + Threshy);

        if (BoxSkeletonizedAxons > 0) {
            roiManager("select", BoxSkeletonizedAxons);
 
            
            roiManager("Delete");
        }

       roiManager("reset");
    }

//Save into an excel file the region , min ,max intensity and threshold and minimum axon lenght.
if(count==1){
  run("Clear Results"); }
    setResult("Region", count-1, Region);
    setResult("Minimum Intensity", count-1, Minimo);
    setResult("Maximum Intensity",count-1, Maximo);
    setResult("Axon Detection Sensitivity",count-1,Threshy);
    setResult("Minimum Axon Length [pixel]",count-1, MinAxonLength);
    setResult("ThresholdFactor",count-1, ThresholdFactor);
    updateResults();
   
 

    close("\\Others");
 //  close();
    Dialog.create(" ");
   Dialog.addCheckbox("	Continue your calibration? ", false);
   Dialog.show();
   a = Dialog.getCheckbox();
   // close all the pictures
   close("*");
 count=count+1;
 } 
name = "FiberParameters" +".csv";	

saveAs("Results", stringy + name); 

