
roiManager("open","F:/Michal/BMR24/tiff/ROI/RoiSet150_BMR24_14_2.zip");
numROIs=roiManager("count");
nr=0;

for (i=0; i<numROIs; i++) {
	roiManager("Select", i);
	rName = Roi.getName();
	Roi.getCoordinates(x, y);
	
	
    for (j=0; j<x.length; j++) {
		setResult("Label", j+nr, rName);
		setResult("X", j+nr, x[j]);
		setResult("Y", j+nr, y[j]);
	}
    nr+=x.length;
	updateResults();
	    
}