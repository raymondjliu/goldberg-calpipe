// turns a directory contains individual frame-wise tiffs into a single collated tif, one batch folder at a time

mouseFolder = "RAYMOND - 05.07.2018 - MOUSE 1193"
batchSize = 5000; //must match batchSize of batchRegister.txt

setBatchMode(true);

ioDirectory = "E:\\RAYMOND\\Movies\\" + mouseFolder;

files = getFileList(ioDirectory);
numberOfFrames = files.length*batchSize;

for (i = 0; i<files.length; i++) {

	indexIn = toString(i*batchSize+1);
	indexOut = toString(i*batchSize+batchSize);

	while (lengthOf(indexIn) < lengthOf(toString(numberOfFrames))) {
		indexIn = "0" + indexIn;
	}

	while (lengthOf(indexOut) < lengthOf(toString(numberOfFrames))) {
		indexOut = "0" + indexOut;
	}

	currentMovieDirectory = ioDirectory + "\\" + files[i];
	movie = getFileList(currentMovieDirectory) 
	run("Image Sequence..." "open=" + currentMovieDirectory + movie[0]");
	saveAs("Tiff", currentMovieDirectory + "registered" + indexIn + "_to_" + indexOut + ".tif");
}