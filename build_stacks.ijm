setBatchMode(true);

inputs = split(getArgument(), ",");

inputDir = inputs[0];
outputDir = inputs[1];
fileRef = inputs[2];

rounds = getFileList(inputDir);

print(rounds.length + " staining rounds found.");

print("Opening " + fileRef + "\n");

open(fileRef);

getDimensions(width, height, chans, slices, frames);

print("Image Metadata");
print("Width: " + width);
print("Height: " + height);

bits = bitDepth();

print("Bit Depth: " + bits + "\n");

close("*");

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
