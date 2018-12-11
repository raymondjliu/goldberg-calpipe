mouseFolder = "RAYMOND-04.17.2018-MOUSE-1094"; //which mouse movie to use

setBatchMode(true);
batchSize = 5000;
readDirectory = "Z:\\Raymond\\TrpM2-Cre-Data\\Movies\\" + mouseFolder;
writeDirectory = "Z:\\Raymond\\TrpM2-Cre-Data\\Images+Offsets\\" + mouseFolder;

files = getFileList(readDirectory); //directory should only contain folders; one folder for each batch
File.makeDirectory(writeDirectory + "\\");
Array.sort(files);

for (i = 0; i<files.length; i++) {
	currentMovieDirectory = readDirectory + "\\" + files[i];
	File.makeDirectory(writeDirectory + "\\" + files[i]);
	movie = getFileList(currentMovieDirectory);
	run("Image Sequence...", "open=" + currentMovieDirectory + "//" + movie[0] + "  sort");
	run("Z Project...", "projection=[Average Intensity]");
	save(writeDirectory + "\\" + files[i] + "average.tif");
	run("Close All");
}
	