//This script is to arrange contrast problem in the figure

inputDir = getDirectory("Choose directory with the images to correct contrast/brightness");
//add maximum intensity
   Dialog.create(" ");
   Dialog.addMessage("Check before running this script, the minimum and maximum intensity of every image");
   Dialog.addNumber("Add the minimum intensity",0);
   Dialog.addNumber("Add the maximum intensity",300);
   Dialog.show();
   Minimum = Dialog.getNumber();
   Maximum = Dialog.getNumber();

i=0;
FileList = getFileList(inputDir);
largo=FileList.length;
setBatchMode(true);

for (i=0; i < largo; i++) {
	 showProgress(i+1, FileList.length);
open(inputDir + FileList[i]);
setMinAndMax(Minimum, Maximum);
call("ij.ImagePlus.setDefault16bitRange", 16);
run("Grays");
run("Apply LUT");
run("Subtract Background...", "rolling=50 sliding");// for background correction
saveAs("Tiff",inputDir + FileList[i]); //save the corrected picture on the old one
close();

	
}
setBatchMode(false);
showMessage("Finished");