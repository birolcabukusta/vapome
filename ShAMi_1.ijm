title=getTitle();

n=roiManager("count");
//getDimensions(width, height, nChannels, slices, frames)

thickness=getNumber("Stepsize (in µm)", 5);


setAutoThreshold("Otsu");
setOption("BlackBackground", true);
run("Threshold..."); 
waitForUser("Adjust your thresholding and OK"); //user definedthresholding 
run("Convert to Mask");



for(i=0; i<n; i++){ 
	roiManager("Select", i);
	nameInitialCellRoi = Roi.getName; 
	waitForUser("Draw your nucleus ROI and OK"); 
	roiManager("Add"); // Nucleus Roi # N
	numberCircles=5;

	for (ii=1; ii<=numberCircles; ii++){
		roiManager("Select",n);
		per=ii*thickness;
		run("Enlarge...", "enlarge=&per");
		Roi.setName("ROI_downscaleImage" + i);
		roiManager("Add");
	}


	for (ii=0; ii<=numberCircles; ii++){
		ni = n+ii;
		roiManager("Select", newArray(ni , 1+ni));
		roiManager("XOR");
		roiManager("Add");
	}

	roiManager("Select", newArray(n, n+1, n+2, n+3, n+4, n+5));
	roiManager("delete"); 

	run("Select None");
	run("Duplicate...", " ");
	roiManager("Select",i);
	run("Clear Outside");
	k=nResults; 
	roiManager("Select", i); 
	getStatistics(area1,mean1);
	setResult("ROI", k, nameInitialCellRoi);	
	setResult("part", k, "whole");
	setResult("area", k, area1);
	setResult("signal", k, mean1*area1);
	setResult("per%", k, area1*mean1/(area1*mean1));

	for (ii = 0; ii<numberCircles; ii++){
		k=nResults; 
		roiManager("Select", n+ii); 
		getStatistics(area_temp,mean_temp);
		setResult("ROI", k, nameInitialCellRoi);
		setResult("part", k, "circle_" + ii);
		setResult("area", k, area_temp);
		setResult("signal", k, area_temp*mean_temp);
		setResult("per%", k, area_temp*mean_temp/(area1*mean1));
	}


	selectWindow(title);


	roiManager("Select", newArray(n, n+1, n+2, n+3, n+4, n+5));
	roiManager("delete"); // have fun
}
