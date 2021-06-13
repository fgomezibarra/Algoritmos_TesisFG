	
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output Results directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


// El resumen del macro
Run(input); // genera dos carpetas nuevas donde se guardan los resultados, luego analiza las imagenes si son tiff las procesa, de lo contrario las ignora


 	
function Run (input) {  // Estas variables generan que se guarden en distintas carpetas luego del procesamiento 
	
splitDir_1= output + "/Canal 1 Global/"; // Aqui se guardaran los resultados de la carpeta 1
splitDir_2= output + "/Canal 2 Perimetro Global/"; // Aqui se guardaran los resultados de la carpeta 2


File.makeDirectory(splitDir_1);
File.makeDirectory(splitDir_2); 

list = getFileList(input); 
	list = Array.sort(list);
for (i=0; i<list.length; i++) { 
     if (endsWith(list[i], ".tif")){ 
               processFile(input, output, list[i]);
               write("Success");
     } else {
     write("Aborted");
     }
}
} 

function save_data()
{
	outpath = output + File.separator; 
		namefile=getString("Choose the name of you .csv File ","Resultados Local Intensity Analysis Phansalkar ");
	
	results=getInfo("Results" + namefile);// ventana log como variable	
	saveAs("Results", outpath+results+".csv");// genera el nombre del archivo csv y el lugar de guardado

  
selectWindow("Log");
run("Close All");

}
 

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.

if (roiManager("count")>0 ) {
	roiManager("deselect");
	roiManager("delete");
	
}

	path = input + File.separator; 
	outpath = output + File.separator; 
	full_path = path + file;
	open(full_path); // The image is now open
title = getTitle();
		print("Processing: " +title);
	// Set up the variables 
	// C4 es el duplicado de C1, C5 de C2 y C6 de C3.
	title = getTitle();
	selectWindow(title);
	C1 = "C1-" + title;
	C2onC1 = "C2 over C1-" + title;
	C2 = "C2-" + title;
	C3onC1 = "C3 over C1-" + title;
	C1onC1 = "C1 over C1-" + title;
	C3 = "C3-" + title;
	C4 = "C4-" + title;
	peIF2at="Results of p-eIF2a Global Measuremnt "+title;
	SYPt="Results of SYP Measurement " + title;
	PSD95t="Results of PSD95 Measurement " +title;
	Results_title= "Results "+ title;
	selectWindow(title);
	run("8-bit");
	resetThreshold();
resetThreshold();
	run("Grays");
	run("Next Slice [>]");
	resetThreshold();
resetThreshold();
	run("Grays");
	run("Next Slice [>]");
	resetThreshold();
resetThreshold();
	run("Grays");
	run("Split Channels");
selectWindow(C2);
close();
selectWindow(C3);
close();
selectWindow(C1);
run("Duplicate...", "title=C4");
rename(C4);
setAutoThreshold("Default dark no-reset");
//run("Threshold...");
resetThreshold();
run("Auto Threshold", "method=Li white");
run("Despeckle");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Create Selection");
selectWindow(C1);
run("Restore Selection");
run("Set Measurements...", "area mean integrated redirect=None decimal=3");
run("Measure");
selectWindow(C4);
saveAs(splitDir_2+C1);
close();
selectWindow(C1);
run("Flatten");
saveAs("Jpeg", splitDir_1+C1onC1);
close();
close();
IJ.renameResults(peIF2at);
saveAs("Results", outpath+peIF2at+".csv");
IJ.renameResults(peIF2at);
selectWindow(peIF2at);
run("Close");
}
