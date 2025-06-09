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
/////////////////////////////
///
function FindIndexArray(Arr,reg,numrows ) { //find the region sometimes the roi cointains more inf than the region as left right
  count=0;
  for (ii = 0; ii < numrows ; ii++) {
  	   
       if(reg.contains(Arr[ii])){
       	 IndexA = ii;
       	 count=1;
       }
      
    }
 if(count ==0){
 	IndexA = -1;   
 }
 return IndexA;
	
}
////
///
function CreateArrayIndex(n) {
      ArrayIndex=newArray(n);
  for (ii = 0; ii < n; ii++) {
       ArrayIndex[ii]=ii;

    }
 return ArrayIndex;
	
}
/////////////////////////////////////////////////////////////
///
function MoveSelection(pos11,pos22) {

   for (vr = 1; vr <roiManager("count"); vr++){
          roiManager('select', vr);
          getSelectionBounds(x, y, w, h);
          setSelectionLocation(x+pos11, y+pos22);
          roiManager("Set Color", "red");
          roiManager("Set Line Width", 3);
          roiManager('update');
      }

	
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Get directory of input files.
   inputDir = getArgument();
   stringy = inputDir;
   // stringy = getDirectory("Choose a Directory with the folder of the desired images --------");
  //////////////////////////Add excel file with fiber parameters/////////////////////
  CsvDir = inputDir;
 //  CsvDir = getDirectory("Choose the  directory of the csv file with the regions of interest");
setBatchMode(true);

   
   CsvDir = replace(CsvDir,"\\","/");
   open(CsvDir + "FiberParameters.csv"); 
   RawRegion = Table.getColumn("Region");
   RawMinimumInt = Table.getColumn("Minimum Intensity");
   RawMaximumInt = Table.getColumn("Maximum Intensity");
   RawAxonDetectionSen = Table.getColumn("Axon Detection Sensitivity");
   RawAxonLength = Table.getColumn("Minimum Axon Length [pixel]");
   ThresholdFactor = Table.getColumn("ThresholdFactor");

   
   numrows = Table.size();
   print(numrows);
    selectWindow("FiberParameters.csv");
    run("Close");
/////////////////////////////////////////////////////////
    FileList = getFileList(stringy + "Fibers/"); // the file is composed of a name plus a number
    q = FileList.length; 
    Filenames =newArray(q);
    NumSlide = newArray(q);
    
//////        Sort file ///////////   
   for(i = 0; i < q; i++) { 
   	
     a = substring(FileList[i], 0, lastIndexOf(FileList[i], "."));
     IndexAux = lastIndexOf(a, "_");
     num = substring(a, IndexAux+1);
     nameexp = substring(a,0,IndexAux-1);
     Filenames[i] = a;
     NumSlide[i] = parseInt(num);
    }
    Array.sort(NumSlide,Filenames,FileList); //Sort the arrays according to the sorting of NumSlide
//////////////////////////////////////////////////////////////////////////////////////
    Array.print(FileList);


   //showMessage("Automatic running");
    
   //Now that the parameters are all defined, the program will loop through and analyze all the images

    run("Set Measurements...", "area mean integrated redirect=None decimal=5");

    myDir = stringy + "Traced Images" + File.separator;
   
    File.makeDirectory(myDir);
   if (!File.exists(myDir)){
        exit("Unable to create directory");}

    j = 1; //counter variable for result
    counter =0;
    setBackgroundColor(0, 255, 255);
    setForegroundColor(253, 253, 253);
    
//////////////////////////////////////////////////////////////////    
    for (i = 0; i < q; i++) { //go through each file
 /////////////////////
      showProgress(i+1, FileList.length);	
       //setBatchMode(true);
 //////////////////////   
    showText("Now is running:" + Filenames[i]);
    //--- Open roi images-----------------------------
     // Addition 21/7 of silvia
    roiManager("reset");
    /////////////////////////finish addition
       roiManager("open", stringy + "ROI/" + Filenames[i] + ".zip" );
       nR = roiManager("Count");  // number of ROI per image.
       print(nR);
       // for (r = 0; r < nR; r++)
       for (r = 0; r < nR; r++){ //go through each roi
      	roiManager("reset");
      	roiManager("open", stringy + "ROI/" + Filenames[i] + ".zip" );//open all roi
        setBackgroundColor(0, 255, 255);
        setForegroundColor(253, 253, 253);

        open(stringy + "Fibers\\" + FileList[i] ); //open each picture
        wait(25);
        run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
       // waitForUser("Before1");
        rename("image2");
        selectWindow("image2");

     


   //--------------------Select the zone to find axons---------------------------
       
       roiManager("select",r);
       rName = Roi.getName(); 
       print(r);
       print(rName);
       getSelectionBounds(x, y, width, height);
       pos1 = x;
       pos2 = y;
       areaSelection = width*height;
    ////////////get all the parameters of the given roi from the csv file//////////////////////////////////////////////////
    //find index
    Array.print(RawRegion);
    print(rName);
  // waitForUser('stop1');
    Index = FindIndexArray(RawRegion,rName,numrows ); //find the  given region in the csv table
    print(Index);
   // waitForUser('stop1');
    if(Index > -1){
    print(Index); //index of roi parameters in csv table
     //////////////////////////////////
    // set max and minimo in the original picture
      min = RawMinimumInt[Index];
      max = RawMaximumInt[Index];
      selectWindow("image2");
       //
       
    //  waitForUser("wait3");
     //CHANGE 11/04/2021
      // run("Enhance Contrast", "saturated=0.35");
      //setMinAndMax(min, max); //Changed on 13-04-2021
     // waitForUser('stop')
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Convert into 8 bits 
      run("Duplicate...", "title=faintAxons");
       //Adjust the intensity of the region according to excel file
      run("8-bit"); //Changed on 11/04/2021
      close("\\Others"); //close all except last one
      roiManager("reset");
      print(r);
   /////////////////////////////////////////////////////////////////////////
//set axon parameters
 //initial axon parameters
    //Threshy = 5;//10
    //MinAxonLength = 15;
    Threshy = RawAxonDetectionSen[Index];
    MinAxonLength = RawAxonLength[Index];
    Threshf = ThresholdFactor[Index];
    print(Threshy);
    print(MinAxonLength);
    print(rName);
////////////////////////////////////////////////////////////////////
//Begin processing
        //----------------------------------------------------------
        // this is to destroy all of the holes
        //----------------------------------------------------------
        //----------------------------------------------------------
        wait(25);
        run("Duplicate...", "title=HoleKiller");
        wait(25);
        getRawStatistics(nPixels, Mean, min, max, std, histogram);
        getDimensions(width, height, channels, slices, frames);
        print('min',min);
        print('max',max);
        print('mean',Mean);
        //Array.print(histogram);
        run("Threshold...");
        setAutoThreshold("Default dark");
       // setThreshold(0, 0.75 * Mean);
        setThreshold(0, Threshf*Mean);//change on 15-04-2021
        setOption("BlackBackground", false);
        run("Convert to Mask");
        run("Create Selection");
      if (selectionType() != -1) {
            roiManager("Add"); //roi[2] holes
            Holes = roiManager("count") - 1;
        } else {
            Holes = -1;
        }
        selectWindow("HoleKiller");
        close(); //active picture
   
        //-----------------------------------------------------
        //-------------------------------------------------------
        run("FeatureJ Derivatives", "x-order=1 y-order=0 z-order=0 smoothing=1.0");
        rename("GradientX");
        wait(25);

        //Zero's out the holes area
        //
        if (Holes > -1) {
            roiManager("Select", Holes);
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

            roiManager("Select", Holes);
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

 
        getRawStatistics(nPixels, Mean, min, max, std, histogram);
        run("Threshold...");
        setAutoThreshold("Default dark");
        setThreshold(-1 / Threshy, 1 / Threshy);
        wait(80);
        
//if(r==8){
// waitForUser("stop");}
 //waitForUser("stop");
        //run("NaN Background");
        run("Convert to Mask");
        wait(50);
        run("Make Binary");
        wait(50);
        //setForegroundColor(0, 0, 0);
        //setBackgroundColor(0, 0, 0);
        //setOption("BlackBackground", false);


        run("Create Selection");
        //checks to see if actual selection exist
        if (selectionType() != -1) {
            roiManager("Add"); //roi[3]Axons in X
            AxonsInX = roiManager("count") - 1;
        } else {
            AxonsInX = -1;
        }

        selectWindow("GradientX");
        close();

        //selectWindow("GFP2-iter13");

    run("FeatureJ Derivatives", "x-order=0 y-order=1 z-order=0 smoothing=1.0");
    rename("GradientY");
        wait(25);

     if (Holes > -1) {
            roiManager("Select", Holes);
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

            roiManager("Select", Holes);
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



        run("Threshold...");
        setAutoThreshold("Default dark");
        setThreshold(-1 / Threshy, 1 / Threshy);
        run("Convert to Mask");
        //run("NaN Background");
        wait(80);
        //setForegroundColor(0, 0, 0);
        //setBackgroundColor(0, 0, 0);
        //setOption("BlackBackground", false);
        run("Make Binary");
        wait(50);
        run("Create Selection");

        if (selectionType() != -1) {
            roiManager("Add"); //roi[4]Axons in Y
            AxonsInY = roiManager("count") - 1;
        } else {
            AxonsInY = -1;
        }
        selectWindow("GradientY");
        close();

        //selectWindow("GFP2-iter13");
        //close();

        selectWindow("faintAxons");
              
        getDimensions(width, height, channels, slices, frames);
        newImage("Skeleton", "8-bit white", width, height, 1);

        setForegroundColor(0, 0, 0);
        setBackgroundColor(0, 0, 0);



        if (AxonsInX > -1 && AxonsInY > -1) {
            roiManager("Select", AxonsInX);
            run("Fill", "slice");

            wait(25);
            roiManager("Select", AxonsInY);
            run("Fill", "slice");

            wait(25);

            run("Create Selection");
            run("Enlarge...", "enlarge=1");

            wait(25);
            run("Enlarge...", "enlarge=-1");
            roiManager("Add"); //roi[5] blob axons
            BlobAxons = roiManager("count") - 1;

        } else {
            BlobAxons = -1;
        }


        //////////////Add by Silvia Select  Region to measure//
      
        //////////////////////////////////////////////////

        selectWindow("Skeleton");
        if (BlobAxons > -1) {
            roiManager("Select", BlobAxons);
            wait(25);
            run("Fill", "slice");
        }


 //waitForUser("stop");
        run("Make Binary");
        wait(25);
        run("Skeletonize");
        
        wait(25);

        //////add by Silvia ///

       ////////////Silvia
      

        selectWindow("faintAxons");
        run("Set Measurements...", "area mean integrated redirect=faintAxons decimal=5");
        
        selectWindow("Skeleton");
        run("Restore Selection");

   /////////////
      if (r > 0 || i > 0){
         IJ.renameResults("AllAxons","Results"); 
       // run("Analyze Particles...", "size=MinAxonLength show=Masks");
      }
     run("Analyze Particles...", "size=MinAxonLength show=Masks");
    
       run("Create Selection"); //do composite
       run("Measure");
      
       
        if (selectionType() != -1) {
            roiManager("Add"); //roi[6] skeletonized axonz
            wait(25);
            SkeletonizedAxons = roiManager("count") - 1;
            Area = getResult("Area", j-1);
           setResult("TotalAxonLengthPerimage[pix]", j-1, Area);
        } else {
            SkeletonizedAxons = -1;
            setResult("TotalAxonLengthPerimage[pix]", j-1, 0); 
            setResult("Area", j-1 ,0);
      	    setResult("Mean", j-1 ,0);
      	    setResult("IntDen", j-1 ,0);
      	    setResult("RawIntDen", j-1 ,0);
        }
     print(SkeletonizedAxons);
//waitForUser;ADD IF SkeletonizedAxons SELECTION IS -1 -tHEN ALLL RESULtS ARE ZERO
   

        setResult("Selected Area [pix]", j-1 , areaSelection);
        setResult("Image Name", j - 1, Filenames[i]);
        setResult("Selected region", j - 1, rName);
        setResult("Axon detection sensitivity:", j-1 ,Threshy);
        setResult("Minimum Axon Length [Pix]", j-1 ,MinAxonLength);
         IJ.renameResults("AllAxons"); 
        run("Clear Results");
        
 
/////////////////////////////
    if(SkeletonizedAxons!= -1) { //onlly when there are fibers
         run("Analyze Skeleton (2D/3D)", "prune=none show display");
      //   run("Analyze Skeleton (2D/3D)", "prune=none prune_0 show display");
         selectWindow("Branch information");
         NumberOfBranches = Table.size;
         print( NumberOfBranches);
         NumberSkeleton = getValue("results.count");
         print(NumberSkeleton);
          //get the sum of the branch length  
         selectWindow("Branch information");
          TotalBranchLength=0;
            for(k=0; k < NumberOfBranches; k++) {
    	TotalBranchLength += parseFloat(Table.get("Branch length", k));
                  } 
          wait(100);        
          print(TotalBranchLength);
          
        ///////////////////////////////////         
       IJ.renameResults("Branch information","Results");
        saveAs("Results", myDir + "\\Tracing Data Details for Image" + FileList[i] + rName + ".xls"); //save if there are fibers
		IJ.renameResults("Tracing Data Details for Image" + FileList[i] + rName + ".xls");
		selectWindow("Tracing Data Details for Image" + FileList[i] + rName + ".xls");
		run("Close");
    } else {
               NumberOfBranches = 0;
               TotalBranchLength=0;
                NumberSkeleton=0;
                  }
		wait(25);
		//waitForUser("stop');
/////////////////////////////Add information to all axons///////////////////////////////
      IJ.renameResults("AllAxons","Results");
      setResult("Number of Branches", j-1 ,NumberOfBranches);
      setResult("Number of Skeletons", j-1 ,NumberSkeleton);
      setResult("Total length of Branches", j-1 ,TotalBranchLength);}

      saveAs("Results", stringy + "Traced Images/"+ nameexp +"Tracing Data Summary.xls"); //presaving

      IJ.renameResults("AllAxons"); 
///////////////////////////////////////////////////////////////////////////////////////		
		run("Clear Results");

        j = j + 1;
             print(r);
           

        //drawing pictures, creates the images in traced images folder.
        
        selectWindow("faintAxons");
        run("Select None");
        Coolstring = Filenames[i];
       run("Duplicate...", "title=blank");
        wait(25);
        close(); 
       
       run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");


        //drawing picture
        run("Line Width...", "line=1");
          
          print(r);  
          
        wait(25);
        if (SkeletonizedAxons > -1) {
            roiManager("Select", SkeletonizedAxons);
            run("RGB Color");
            setForegroundColor(255, 255, 0);
            if (r == 0){
            setForegroundColor(255, 255, 0);}
             if (r ==1){setForegroundColor(255, 0, 0);}
             if (r ==2){setForegroundColor(0, 0, 255);}
             if (r ==3){setForegroundColor(255, 0, 255);}
             if (r ==4){setForegroundColor(0, 255, 255);}
             if (r ==6){setForegroundColor(255, 153, 0);}
            run("Draw");}
          
          print(r);

        if (r == 0){ //first time
        open(stringy + "Fibers/" + FileList[i]);
        wait(25);
       run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
       rename("image3");
       selectWindow("image3");
       run("Save", "save=[" + myDir + "f" + Coolstring + ".tif" + "]");
       rename("image3");
       selectWindow("image3");
       //waitForUser('stop');

       } else {  
       	open(myDir + "f" + Coolstring + ".tif" );
       	 rename("image3");
       selectWindow("image3");
       }
       
     

       /////////////
       if (SkeletonizedAxons > -1) {//draw on the original picture with fibers
       	
       n = roiManager("count")-1; 
       print(n);
       IndexToDelete = CreateArrayIndex(n);
       roiManager("select", IndexToDelete);
       roiManager("delete");
       roiManager("select", 0); // select the intrested group
       roiManager("List");
      // waitForUser('stop');

       selectWindow("Overlay Elements of image3");
       AT = Table.getColumn("Type");
       Array.print(AT);
       selectWindow("Overlay Elements of image3");
       run("Close");
        
      if( AT[0] == "Composite" ) {
       roiManager("Split"); //split the group
       MoveSelection(pos1,pos2);
       roiManager("select", 0);
       roiManager("delete");} else { //for one element
       	roiManager("select", 0);
       	MoveSelection(pos1,pos2);
         }
       selectWindow("image3");
       roiManager("Show All without labels");
       run("Flatten");
       run("Save", "save=[" + myDir + "f" + Coolstring + ".tif" + "]");
       }
       //////////////////////

      
         print(SkeletonizedAxons);
          /////////////

         
        wait(25);

        close("\\Others");
        run("Close");
       roiManager("reset");
      // setBatchMode(false); 
      print(r);
  
 
     }
      }
        


    print( stringy + "Traced Images/"+ nameexp + "Tracing Data Summary.xls");
   run("Clear Results");
    IJ.renameResults("AllAxons","Results");
    saveAs("Results", stringy + "Traced Images/"+ nameexp +"Tracing Data Summary.xls");
    wait(25);
    run("Clear Results");

setBatchMode(false);


    // Headers, font color, and italics
//    showMessage("1/1", "<html>" + "<h1><font color=blue><i>Analysis Complete</i></h1>");

        
    
       // run("Close");









  

    //Organizes axon data

 //   sum = 0;
 //   counter = 0;
//    for (i = 0; i < j - 1; i += 1) {
//        Area = getResult("Area", i);
//        setResult("AxonLengthPerimage[pix]", i, Area);
 //       sum = sum + Area;
 //       if (Area != 0) counter = counter + 1;
//    }
//    setResult("Sum of Axon Length Per Folder [pix]", 0, sum);
//    setResult("Average Axon Length Per Image [pix]", 0, sum / counter);
//    setResult("Axon detection sensitivity:",0,Threshy);
 //   setResult("Minimum Axon Length [Pix]",0,MinAxonLength);
    





