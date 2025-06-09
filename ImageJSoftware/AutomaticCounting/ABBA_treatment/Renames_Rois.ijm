//open the roi and split
//and delete the old one
//////////////////////////////////////
function  AddNamesSplitRegion(nrbefore,nrafter,name_Roi,color_index){
	j=0;
	no_good = newArray(0);
	i = 0;
	color_array = newArray("yellow","blue","red","green","gray","black","white");
	
	for(index = nrbefore; index < nrafter; index++){
		roiManager("select", index);
		roiManager("Set Color", color_array[color_index]);
		
		print(color_index);
		//waitForUser("stop");
		//delete small regions
		if(Roi.size < 10){
			no_good[i] = index;
			i = i + 1;
		}else{
		//accept
		roiManager("rename", name_Roi + "_r" + j);
		j=j+1;}
	}
	//waitForUser("stop");
	//delete
	if(no_good.length != 0){
	
		roiManager("select",no_good);
		roiManager("delete");
	
	}
}

function delete_first_rois(nr){
	a1 = newArray(nr);
	for(index = 0; index < nr; index++){
		a1[index] = index;
	}
	roiManager("Select", a1);
	roiManager("Delete");
}

function save_new_rois(nr,filename){
	a1 = newArray(nr);
	for(index = 0; index < nr; index++){
		a1[index] = index;
	}
	roiManager("Select", a1);
	roiManager("Save",filename);
}

function Select_manager_color(j){
	color_array = newArray("yellow","blue","red","green","gray","black","white");
	
	//waitForUser("stop");
	print(color_array[j]);
	roiManager("Set Color", color_array[j]);
}

function getRoiFile(inputFile){
	aux = substring(inputFile,lastIndexOf(inputFile,"/")+1,indexOf(inputFile,".tif"));
	dir = File.getDirectory(inputFile);
	print(dir);
	
	dir= substring(dir,0,lastIndexOf(dir,"/")-1);
	dir= substring(dir,0,lastIndexOf(dir,"/"));
	print(dir);

	inputRoi = dir + "/ROI from ABBA/" +"RoiSet" + aux + ".zip";
	return inputRoi;
}

function getOutputRoiFile(inputFile){
	aux = substring(inputFile,lastIndexOf(inputFile,"/")+1,indexOf(inputFile,".tif"));
	dir = File.getDirectory(inputFile);
	
	dir= substring(dir,0,lastIndexOf(dir,"/")-1);
	dir= substring(dir,0,lastIndexOf(dir,"/"));
	outputRoi = dir + "/Roi from ABBA split/" +"RoiSet" + aux + ".zip";
	return outputRoi;
}

///////////////////////////////////////////Begin the program////////
inputFile = getArgument();
inputRoi = getRoiFile(inputFile);
outputRoi = getOutputRoiFile(inputFile);
//open picture
open(inputFile);
//open roi manager
print(inputRoi);
//waitForUser("stop");

roiManager("open",inputRoi);
filename = outputRoi;
//number of rois
nr = roiManager("count");

j=0;
// go through each roi and split

for(index=0; index<nr; index++){
	roiManager("select", index); //open original roi
	
	if(j==7){
		j=0;
	}else{
	Select_manager_color(j); //select color of the roi
	
	}
	
	
	type = Roi.getType;
	name_Roi = Roi.getName;
	print(name_Roi);
	print(type);
    //number of regions before splitting
    nrbefore = roiManager("count");
	//if type is composite, it can be splitted
	if(type.contains("composite")){
		//can split the roi
	  roiManager("split");
	//  waitForUser("stop");
	  //find new roi in position nr
	  nrafter = roiManager("count");
	  AddNamesSplitRegion(nrbefore,nrafter,name_Roi,j);
	 // waitForUser("stop");
	} else{
		//duplicate roi
		roiManager("add");
		//waitForUser("stop");
	}
	j=j+1;
}
//waitForUser("stop");
// at the end delete first nr original rois
 delete_first_rois(nr);
 //waitForUser("stop");
//save the new rois
save_new_rois(roiManager("count"),filename);
roiManager("reset");
//close image and roi manager
close("*");
