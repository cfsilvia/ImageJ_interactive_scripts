//REPLACE NAMES OF ALL VSI NAMES ACCORDING TO LIST
 stringy = getDirectory("Choose a Directory with the filenames to change --------");
//////////////////////////////////////////////////////
//////////////////////////Add excel file/////////////////////
   CsvDir = getDirectory("Choose the  directory of the csv file");
   CsvDir = replace(CsvDir,"\\","/");
   open(CsvDir + "SortFiles.csv"); 
   IJ.renameResults("SortFiles.csv","Results");
/////////////////////////////////////////////
  //Arrays made for later use.
FileList = getFileList(stringy+ "\\");

   newName = " ";
    q = FileList.length; 
  for(i = 0; i < q; i++) {
  	print(FileList[i]);

         for (r=0; r < getValue("results.count"); r++) {   
              nameFileP = getResultString("Pic name",r);
              
              
 
     	//if(File.isDirectory(stringy + nameFilen)){
     	 if(lastIndexOf(FileList[i], "/")>-1){
     		nameFile = substring(FileList[i], indexOf(FileList[i], "_") + 1, lastIndexOf(FileList[i], "_"));
     		nameFilen = substring(FileList[i], 0,indexOf(FileList[i], "/"));
     		print(nameFileP);
     		print(nameFilen);
     		//waitForUser("stop");
     		if (nameFileP == nameFile ) {
     		print(stringy+FileList[i]);
     		newName = "_" + getResultString("Slice #",r) + nameFilen;
     		  print(newName);
  	         File.rename(stringy + nameFilen ,stringy + newName);
  
     		}
     	} else {
     		print(FileList[i]);
        //waitForUser("stop");
     	nameFile = substring(FileList[i], 0, lastIndexOf(FileList[i], "."));
     	if (nameFileP == nameFile ) {	
     	//newName = nameFilen + "_" + getResultString("Slice #",r) + substring(FileList[i],lastIndexOf(FileList[i], ".")) ;
     	newName = getResultString("Slice #",r) + "_" + FileList[i];
     	  print(newName);
  	     File.rename(stringy + FileList[i] ,stringy + newName);
  
     	}
   }
         }
//waitForUser("stop");
 
  	 // print(newName);
  	//  File.rename(stringy + nameFilen ,stringy + newName);
  
  }

showMessage("Finished");