mouseFolder = "RAYMOND - 05.07.2018 - Mouse 1193"; //which mouse movie to use


readDirectory = "E:\\RAYMOND\\Movies\\" + mouseFolder;
writeDirectory = "E:\\RAYMOND\\Images+Offsets\\" + mouseFolder;

files = getFileList(readDirectory); //directory should only contain folders; one folder for each batch

for (i = 0; i<files.length; i++) {
	currentMovieDirectory = readDirectory + "\\" + files[i];
	movie = getFileList(currentMovieDirectory);
	open(currentMovieDirectory + movie[0])
	run("Z Project...", "projection=[Average Intensity]");
	saveAs("Tiff", writeDirectory + "\\" + files[i] + "average.tif");
	run("Close All");
}
	