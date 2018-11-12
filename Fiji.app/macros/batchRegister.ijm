// registers large videos by splitting up the image and registering each chunk of images to the first image in each set. 
// assumes two-channel (Ch1 and Ch4) image capture as well as folder hierarchy mouse\Tseries\tiff files. Will throw errors if either is not the case.
// for some reason, macro often fails on first run, no idea why. running again fixes the problem.

mouseFolder = "RAYMOND - 06.14.2018 - MOUSE 1345";
batchSize = 5000;// size of each image chunk. Will not process the remainder if batchSize does not divide evenly into the number of frames. Setting >30000 may tax memory usage.
setBatchMode(true);

mouseDirectory = "Z:\\Raymond\\TrpM2-Cre Data\\Raw\\" + mouseFolder; // path to where TSeries is saved.
writeDirectory = "Z:\\Raymond\\TrpM2-Cre Data\\Movies\\" + mouseFolder;

files = getFileList(mouseDirectory);

for (i = 0; i<files.length; i++) {
	if (startsWith(files[i], "TSeries")) {
		TSeriesDirectory = mouseDirectory + "\\" + files[i];
	}	
}

numberOfFrames = 0; 
print("getting file list.");
TSeriesFiles = getFileList(TSeriesDirectory);
for (i = 0; i<TSeriesFiles.length; i++) {
	if (endsWith(TSeriesFiles[i], ".ome.tif")) {
		numberOfFrames++;
	} else {
		// File.rename(TSeriesDirectory + TSeriesFiles[i], TSeriesDirectory + "zzz" + TSeriesFiles[i]);
	}
}

if (numberOfFrames % 2 != 0)
	print("odd number of frames in directory. check directory for any modifications.");

numberOfFrames = floor(numberOfFrames / 2);
File.makeDirectory(writeDirectory);

for (i = 0; i < 0; i++) {

	indexIn = toString(i*batchSize+1);
	indexOut = toString(i*batchSize+batchSize);

	while (lengthOf(indexIn) < lengthOf(toString(numberOfFrames))) {
		indexIn = "0" + indexIn;
	}
	while (lengthOf(indexOut) < lengthOf(toString(numberOfFrames))) {
		indexOut = "0" + indexOut;
	}

	File.makeDirectory(writeDirectory + "\\Ch1_registered" + indexIn + "_to_" + indexOut);
	
	for (j = 0; j<batchSize; j++) {
		open(TSeriesDirectory + TSeriesFiles[batchSize*i]);
		open(TSeriesDirectory + TSeriesFiles[i*batchSize + j]);
		run("TurboReg ", "-align -window " + TSeriesFiles[i*batchSize+j] + " 0 0 511 511 -window " + TSeriesFiles[i*batchSize] + " 0 0 511 511 -translation 255 255 255 255 -showOutput");
		run("Duplicate...", "title=Output");

		// add leading zeros to index so that the folders coming out are sorted in correct order numerically

		index = toString(i*batchSize+j+1);

		while (lengthOf(index) < lengthOf(toString(numberOfFrames))) {
			index = "0" + index;
		}

		save(writeDirectory + "\\Ch1_registered" + indexIn + "_to_" + indexOut + "\\registered_" + index + ".tif");		
		run("Close All");
	}
	
}

for (i = 2; i<floor(numberOfFrames/batchSize); i++) {

	indexIn = toString(i*batchSize+1);
	indexOut = toString(i*batchSize+batchSize);

	while (lengthOf(indexIn) < lengthOf(toString(numberOfFrames))) {
		indexIn = "0" + indexIn;
	}

	while (lengthOf(indexOut) < lengthOf(toString(numberOfFrames))) {
		indexOut = "0" + indexOut;
	}

	File.makeDirectory(writeDirectory + "\\Ch4_registered" + indexIn + "_to_" + indexOut);
	
	for (j = 0; j<batchSize; j++) {
		open(TSeriesDirectory + TSeriesFiles[numberOfFrames + i*batchSize]);
		open(TSeriesDirectory + TSeriesFiles[numberOfFrames + i*batchSize + j]);
		print(j+1);
		run("TurboReg ", "-align -window " + TSeriesFiles[numberOfFrames + i*batchSize+j] + " 0 0 511 511 -window " + TSeriesFiles[numberOfFrames + batchSize*i] + " 0 0 511 511 -translation 255 255 255 255 -showOutput");
		print("reg done");
		run("Duplicate...", "title=Output");

		print("duplicated");
		// add leading zeros to index so that the folders coming out are sorted in correct order numerically

		index = toString(i*batchSize+j+1);

		print("index made");
		while (lengthOf(index) < lengthOf(toString(numberOfFrames))) {
			index = "0" + index;
		}

		print("index stored");
		save(writeDirectory + "\\Ch4_registered" + indexIn + "_to_" + indexOut + "\\registered_" + index + ".tif");		
		print("saved");
		run("Close All");
		print("closed");
	}
	
}
