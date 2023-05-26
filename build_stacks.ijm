setBatchMode(true);

inputs = split(getArgument(), ",");

//inputDir = "/nemo/stp/lm/inputs/santoss/Elias Copin/Multiplexed_imaging_data/";
//outputDir = "/nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/Test/Output_Stacks/";

//inputDir = "Z:/inputs/santoss/Elias Copin/Multiplexed_imaging_data/";
//outputDir = "Z:/working/barryd/Working_Data/Santos/Elias/Test/Output_Stacks/";

inputDir = inputs[0];
outputDir = inputs[1];
fileRef = inputs[2];

rounds = getFileList(inputDir);

print(rounds.length + " staining rounds found.");

//firstRoundDir = inputDir + File.separator() + rounds[rounds.length - 1];

//firstRoundDataDir = firstRoundDir + File.separator() + "data";

//firstRoundFileList = getFileList(firstRoundDataDir);

//print(firstRoundFileList.length + " positions found.");

//firstImage = firstRoundDataDir + File.separator() + firstRoundFileList[fileIndex];

print("Opening " + fileRef + "\n");

open(fileRef);

getDimensions(width, height, chans, slices, frames);

print("Image Metadata");
print("Width: " + width);
print("Height: " + height);

bits = bitDepth();

print("Bit Depth: " + bits + "\n");

close("*");

//for(s = 0; s < 10; s++){
	print("Processing " + fileRef);
	buildStack(inputDir, rounds, File.getName(fileRef), outputDir);
//}

print("Done");

setBatchMode(false);

function buildStack(inputDir, rounds, refFile, outputDir){
	frames = newArray(0);
	for (r = 0; r < rounds.length; r++) {
		fullFilePath = inputDir + File.separator() + rounds[r] + File.separator() + "data" + File.separator() + refFile;
		foundFile = File.exists(fullFilePath);
		if(foundFile){
			print("Round " + r + ": " + fullFilePath);
			open(fullFilePath);
		} else {
			print("Round " + r + ": file not found");
			newImage("null", bits + "-bit", width, height, 1);
		}
		//rename("Frame " + getRoundNumber(rounds[r]));
		rename(rounds[r]);
		frames = Array.concat(frames, getTitle());
	}
	Array.sort(frames);
	concatArg = "";
	for (i = 1; i <= frames.length; i++) {
		concatArg = concatArg + " image" + i + "=[" + frames[i - 1] + "]";
	}
	
	run("Concatenate...", "open " + concatArg);
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames=" + frames.length + " display=Color");
	saveAs("Tiff", outputDir + File.separator() + refFile);
	close("*");
}

function getRoundNumber(folderName){
	index1 = indexOf(folderName, "(");
	index2 = indexOf(folderName, ")");
	if(index1 < 0 || index2 < 0){
		roundNumber = "1";
	} else {
		roundNumber = substring(folderName, index1 + 1, index2);
	}
	return IJ.pad(parseInt(roundNumber), 2);
}

function getChannelList(directory){
	fileNames = getFileList(directory);
	uniqueFileNames = newArray(0);
	for(fileIndex = 0; fileIndex < fileNames.length; fileIndex++){
		channels[fileIndex] = substring(File.getNameWithoutExtension(fileNames[fileIndex]), lengthOf("--") + lastIndexOf(fileNames[fileIndex], "--"));
	}
	return channels;
}
