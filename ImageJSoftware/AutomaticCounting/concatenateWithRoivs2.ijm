/*
 * Refactored ImageJ Macro: overlays → montages
 * Fixed IJM syntax; return arrays instead of objects
 */

var inputDir, roiDir,labelsDir;
var channelType, overlayTypes;
var doSort, doChooseRange;
var slideBegin, slideEnd;
var addRoiRegions, addCellLabels;
var sortedNums; // Numeric indices after sorting slides
var roiColor, showRoiLabels;
var roiFromAtlas;

function main() {
    showMainDialog();
    var files = getFileListForType();
    if (doSort) files = sortFileList(files);
    var range = getProcessingRange(files);
    var startIdx = range[0];
    var endIdx   = range[1];
    var count    = range[2];
    processFiles(files, startIdx, endIdx);
    createMontage(count, files[endIdx-1]);
}

function showMainDialog() {
    inputDir = getDirectory("Choose input TIFF directory");
    
    Dialog.create("Select options");
    Dialog.addChoice("Channel:", newArray("Dapi","Cfos","Cherry","Oxytocin","Vasopresin","TH","Fibers","OTR","Overlay 2","Overlay 3","Others"));
    Dialog.addCheckbox("Sort slides by name", false);
    Dialog.addCheckbox("Select slide range", false);
    Dialog.addNumber("From slide #", 1);
    Dialog.addNumber("To slide #", 1);
    Dialog.addCheckbox("Add ROI regions", false);
    Dialog.addCheckbox("Add cell labels", false);
    Dialog.addCheckbox("ROI from Atlas", false);
    Dialog.addCheckbox("Show ROI names", true);
    Dialog.addChoice("ROI color", newArray("yellow", "red", "green", "blue", "orange", "cyan", "magenta"));
    Dialog.show();

    channelType   = Dialog.getChoice();
    doSort        = Dialog.getCheckbox();
    doChooseRange = Dialog.getCheckbox();
    slideBegin    = Dialog.getNumber();
    slideEnd      = Dialog.getNumber();
    addRoiRegions = Dialog.getCheckbox();
    addCellLabels = Dialog.getCheckbox();
    roiFromAtlas = Dialog.getCheckbox();
    showRoiLabels = Dialog.getCheckbox();
    roiColor = Dialog.getChoice();
    
    if(!roiFromAtlas){
    roiDir   = inputDir + "ROI/";
    labelsDir = inputDir + "Roi_of_labels/";
    }else {
    roiDir   = inputDir + "ROI_From_Atlas/";
    labelsDir = inputDir + "Roi_all_image_"+ channelType + "/";	
    	
    }

    if (channelType=="Overlay 2") showOverlayDialog(2);
    if (channelType=="Overlay 3") showOverlayDialog(3);
}

function showOverlayDialog(n) {
    Dialog.create("Choose "+n+" channels");
    overlayTypes = newArray();
    for (var i=0; i<n; i++) {
        Dialog.addChoice("Channel "+(i+1)+":", newArray("Dapi","Cfos","Cherry","Oxytocin","Vasopresin","TH","Fibers"));
    }
    Dialog.show();
    overlayTypes = Dialog.getChoices();
}

function getFileListForType() {
    var folder;
    if (indexOf(channelType, "Overlay")==0) folder = overlayTypes[0];
    else folder = channelType;
    return getFileList(inputDir + folder + "/");
}

function sortFileList(files) {
    var nums = newArray();
    for (var i=0; i<lengthOf(files); i++) {
        nums[i] = parseInt(substring(files[i], 0, indexOf(files[i], "_")));
    }
    Array.sort(nums, files);
    sortedNums = nums;
    return files;
}

// Returns [startIdx, endIdx, count]
function getProcessingRange(files) {
    var start = 0;
    var end   = lengthOf(files);
    if (doChooseRange && doSort) {
        start = FindIndex(sortedNums, slideBegin);
        end   = FindIndex(sortedNums, slideEnd) + 1;
    }
    return newArray(start, end, end - start);
}

function processFiles(files, startIdx, endIdx) {
    var cnt = 0;
  
    for (var i=startIdx; i<endIdx; i++) {
        showProgress(i+1, lengthOf(files));
        var name = substring(files[i], 0, lastIndexOf(files[i], "."));
        if (channelType=="Overlay 2")   processOverlay(files[i], 2, name, cnt);
        else if (channelType=="Overlay 3") processOverlay(files[i], 3, name, cnt);
        else processSingle(files[i], name, cnt);
        cnt++;
    }
}

function processOverlay(fname, n, base, idx) {
    for (var c=0; c<n; c++) {
        open(inputDir + overlayTypes[c] + "/" + fname);
        rename("L"+c);
        if (c>0) {
            selectWindow("L0");
            run("Add Image...", "image=L"+c+" x=0 y=0 opacity=" + (c==2?40:50));
        }
    }
    run("Flatten");
    annotateAndRoi(base);
    renameAndClose(idx);
}

function processSingle(fname, base, idx) {
	var files_to_use = newArray();
    open(inputDir + channelType + "/" + fname);
    rename("Img");
    selectWindow("Img");
    annotateAndRoi(base);
    
    if(addCellLabels && !roiFromAtlas){
      annotateAddCellLabels(fname,base,idx);
      }else{
      	annotateAddCellLabels_Atlas(fname,base,idx);
      }
    renameAndClose(idx);
    
    
}

function annotateAndRoi(base) {
    setFont("SansSerif",200);
    makeText(base,50,100);
    run("Flatten");
    rename("Img1");
    selectWindow("Img1");
    if (addRoiRegions) {
        var rf = roiDir + "RoiSet" + base + ".zip";
        if (File.exists(rf)) {
        	roiManager("reset");
            roiManager("open", rf);
            roiManager("Set Color", roiColor);
            roiManager("Set Line Width", 4);
            if (showRoiLabels) {
                roiManager("Show All with labels");
                run("Labels...", "color=" + roiColor + " font=100 show use");
           } else {
               roiManager("Show All without labels");
           }
            run("Flatten");
           
            roiManager("reset");
        }
    }
    rename("Img2");
    //waitForUser("stop1");
}

function renameAndClose(i) {
    // Keep the processed image open for concatenation
   
    rename("image" + i);
    close("Img");
    close("Img1");
    close("Img2");
   
    // Do not close here to allow Concatenate to access all image windows
}

function createMontage(count, last) {
	var c  = floor(sqrt(count));
	if (c*c < count) c = c + 1;
    var cols = c;
    // IJM has no ceil; use floor((count+cols-1)/cols) to compute rows
    var rows = floor((count + cols - 1) / cols);
    
    var opts = "title=[MyStack]";
    for (var i=0; i<count; i++) opts += " image"+(i+1)+"=[image"+i+"]";
    run("Concatenate...", opts);
    run("Make Montage...", "columns="+cols+" rows="+rows+" scale=0.25 label");
    saveAs("Tiff", inputDir+"Montage_"+last+".tif");
}

function FindIndex(arr, val) {
    for (var i=0; i<lengthOf(arr); i++) {
    	
        if (arr[i]==val) return i;
    }
    return 0;
}

function annotateAddCellLabels(fname,base,idx){
	//find the files  inside the folder which have the channel type between the name and the last _
	var ldir = labelsDir + base + "/";
	var files = getFileList(ldir);
	var files_to_use = select_files(files);
	for(var i=0; i<lengthOf(files_to_use); i++){
		roi_count = check_roi(files_to_use[i], ldir);
		 if( roi_count > 0){
            roiManager("reset");
            selectWindow("Img2");
            //waitForUser("stop");
            print(ldir + files_to_use[i]);
            //waitForUser("stop");
            roiManager("open", ldir + files_to_use[i] );
            roiManager("Set Color", "red");
            roiManager("Set Line Width", 4);
            roiManager("Show All without labels");
            run("Flatten");
            
           //waitForUser("stop");
		 }
	}
	
	
}

function annotateAddCellLabels_Atlas(fname,base,idx){
	//find the files  inside the folder which have the channel type between the name and the last _
	    var ldir = labelsDir;
	    var files_to_use =  base + ".zip";
		roi_count = check_roi(files_to_use, ldir);
		 if( roi_count > 0){
            roiManager("reset");
            selectWindow("Img2");
            //waitForUser("stop");
            print(ldir + files_to_use);
           // waitForUser("stop");
            roiManager("open", ldir + files_to_use );
            roiManager("Set Color", "red");
            roiManager("Set Line Width", 4);
            roiManager("Show All without labels");
            run("Flatten");
            
           //waitForUser("stop");
		 }
	
	
	
}






function select_files(files){
	// select the pertinent files with only one channel type
	var prefix = base + "_" + channelType + "_";
	var ext = ".zip";
	var extLen = lengthOf(ext);
	var files_to_use = newArray();
	
	for (var i=0; i<lengthOf(files); i++) {
	   var f = files[i];
	   if (lastIndexOf(prefix,"_")==lastIndexOf(f,"_")) {
	   files_to_use = Array.concat(files_to_use, f);
     }
	}
	//Array.print(files_to_use);
	//waitForUser('stop');

	return files_to_use;
	
}

function check_roi(f,ldir){
	 path = ldir + f;
     javaPath = replace(path, "\\", "\\\\");  

    // 3) count only .roi files inside the ZIP using JavaScript if there are roifile
    roiCount = parseInt(eval("js",
        // import ZipFile and iterate entries
        "var ZipFile = Packages.java.util.zip.ZipFile;\n" +
        "var zf = new ZipFile(\"" + javaPath + "\");\n" +
        "var e = zf.entries();\n" +
        "var cnt = 0;\n" +
        "while (e.hasMoreElements()) {\n" +
        "  var ze = e.nextElement();\n" +
        "  if (!ze.isDirectory() && ze.getName().toLowerCase().endsWith('.roi')) cnt++;\n" +
        "}\n" +
        "zf.close();\n" +
        "// return as string so IJM can parse it\n" +
        "cnt + '';\n"
    ));
    return roiCount
}


iamBatch = true;
main();