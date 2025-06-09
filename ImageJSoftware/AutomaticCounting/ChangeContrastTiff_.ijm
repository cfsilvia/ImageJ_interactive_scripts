//This script is to arrange contrast problem in the figure

inputDir = getDirectory("Choose directory with the images to correct contrast/brightness");


i=0;
FileList = getFileList(inputDir);
largo=FileList.length;


for (i=0; i < largo; i++) {

open(inputDir + FileList[i]);
run("Brightness/Contrast...");
waitForUser("1- Adjust Maximum and Minimum of the picture \n  2- Press set \n 3- Press ok");
saveAs("Tiff",inputDir + FileList[i]); //save the corrected picture on the old one
close();

	
}
showMessage("Finished");