	
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output Results directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


// El resumen del macro
Run(input); // genera dos carpetas nuevas donde se guardan los resultados, luego analiza las imagenes si son tiff las procesa, de lo contrario las ignora



 	
function Run (input) {  // Estas variables generan que se guarden en distintas carpetas luego del procesamiento 
	
splitDir_1= output + "/Canal 1 Phansalkar r=12/"; // Aqui se guardaran los resultados de la carpeta 1
splitDir_2= output + "/Canal 2 Phansalkar r=12/"; // Aqui se guardaran los resultados de la carpeta 2
splitDir_3= output + "/Canal 3 Phansalkar r=12/"; // Aqui se guardaran los resultados de la carpeta 3
splitDir_4= output + "/ROI y resultados SYP r=12 (0.035-3.00)/"; // Aqui se guardaran los resultados de la carpeta 4
splitDir_5= output + "/ROI y resultados PSD95 r=12 (0,035-3.00)/"; // Aqui se guardaran los resultados de la carpeta 5

splitDir_7= splitDir_1 +"/Canal 2 en Canal 1/";
splitDir_8= splitDir_1+"/Canal 2 en Canal 2/";
splitDir_9= splitDir_1 +"/Canal 3 en Canal 1/";
splitDir_10= splitDir_1+"/Canal 3 en Canal 3/";

File.makeDirectory(splitDir_1);
File.makeDirectory(splitDir_2); 
File.makeDirectory(splitDir_3); 
File.makeDirectory(splitDir_4); 
File.makeDirectory(splitDir_5);

File.makeDirectory(splitDir_7); 
File.makeDirectory(splitDir_8); 
File.makeDirectory(splitDir_9); 
File.makeDirectory(splitDir_10); 
 
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
	results=getInfo("Results" + title);// ventana log como variable
	
	name_file=outpath +namefile+".csv";// genera el nombre del archivo csv y el lugar de guardado
	File.saveString(results,name_file);// guarda el archivo

  
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
	C2onC2 = "C2 over C2-" + title;
	C3onC1 = "C3 over C1-" + title;
	C3onC3 = "C3 over C3-" + title;
	C3 = "C3-" + title;
	C4 = "C4-" + title;
	C5 = "C5-" + title;
	C6 = "C6-" + title;
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
	 
	selectWindow(C1);
	run("Duplicate...", "title=C4");
	selectWindow("C4");
	rename(C4);
	
	selectWindow(C2);
	run("Duplicate...", "title=C5");
	selectWindow("C5");
	rename(C5);
	selectWindow(C2);
	run("Auto Local Threshold", "method=Phansalkar radius=12 parameter_1=0 parameter_2=0 white");
	run("Convert to Mask");
	run("Despeckle");
	run("Analyze Particles...", "size=0.035-3.00 show=[Overlay Masks] display exclude include add");
  IJ.renameResults("Analyzed1"); 
  run("Close");
  
	selectWindow(C1);
	roiManager("Show All without labels");
	run("Set Measurements...", "area mean integrated redirect=None decimal=3");
	A = roiManager("count");
	SYP_final = newArray(A); // una base de datos llamada SYP_final con A elementos
	
   for (i=0; i<A; i++) { 
       roiManager("select", i) 
       run("Measure"); 
       Roi.setStrokeColor("Green");
   }
   
  Overlay.addSelection();

   IJ.renameResults(SYPt);
   roiManager("save", splitDir_4+SYPt+".zip");
saveAs("Results", splitDir_4+SYPt+".csv");
  IJ.renameResults(SYPt);
  
	selectWindow(C1);
	run("Restore Selection");
	saveAs("Jpeg",splitDir_7+C2onC1);
	close();

	
Overlay.clear();

	
	selectWindow(C2);
	saveAs("Jpeg",splitDir_2+C2);
	selectWindow(C2);
	close();
	selectWindow(SYPt);
	
   IJ.renameResults(SYPt);   
   for (i=0; i<A; i++)   
       SYP_final[i] = getResult("Mean", i); 
      
         for (i=0; i<A; i++) { 
       roiManager("select", i) 
       Roi.setStrokeColor("Green");
   }
   
  Overlay.addSelection();

	selectWindow(C5);
	roiManager("Show All without labels");
	saveAs("Jpeg",splitDir_8+C2onC2);
	close();
      
	roiManager("Deselect");
roiManager("Delete");



	// SYP analisis
	selectWindow(C3);
	run("Duplicate...", "title=C6");
	selectWindow("C6");
	rename(C6);
	selectWindow(C3);
run("Auto Local Threshold", "method=Phansalkar radius=12 parameter_1=0 parameter_2=0 white");
	run("Convert to Mask");
	run("Despeckle");
	run("Analyze Particles...", "size=0.035-3.00 show=[Overlay Masks] display exclude include add");
	IJ.renameResults("Analyzed2");


	selectWindow(C4);
	roiManager("Show All without labels");
	run("Set Measurements...", "area mean integrated redirect=None decimal=3");
	B = roiManager("count"); 
	PSD95_final = newArray(B); // una base de datos llamada PSD95_final con B elementos
   for (i=0; i<B; i++) { 
       roiManager("select", i) 
       run("Measure"); 
       Roi.setStrokeColor("Red");
   }
   Overlay.addSelection();

   IJ.renameResults(PSD95t);
   roiManager("save", splitDir_5+PSD95t+".zip");
   saveAs("Results", splitDir_5+PSD95t+".csv");
  IJ.renameResults(PSD95t);
  
	selectWindow(C4);
	run("Restore Selection");
	saveAs("Jpeg",splitDir_9+C3onC1);
	
	Overlay.clear();
	
	selectWindow(C3);
	saveAs("Jpeg", splitDir_3+C3);
	selectWindow(C3);
	close();
	
	selectWindow(C4);
	rename(title);
	print(title);
	close();
	
   selectWindow(PSD95t); 
   IJ.renameResults(PSD95t); 
   for (i=0; i<B; i++) 
       PSD95_final[i] = getResult("Mean", i);  
       
   for (i=0; i<A; i++) {
       setResult("SYP Local Mean Intensity", i, SYP_final[i]); 
       }
       for (i=0; i<B; i++) {
       setResult("PSD95 Local Mean Intensity", i, PSD95_final[i]); 
   } 
   IJ.renameResults("Results "+title); 
   saveAs("Results", outpath+Results_title+".csv");
    IJ.renameResults(Results_title);

  for (i=0; i<B; i++) { 
       roiManager("select", i) 
       Roi.setStrokeColor("Red");
   }
   
  Overlay.addSelection();

	selectWindow(C6);
	roiManager("Show All without labels");
	saveAs("Jpeg",splitDir_10+C3onC3);
	close();

    
	roiManager("Deselect");
	roiManager("Delete");

selectWindow("Analyzed2");
run("Close");

selectWindow("Results of SYP Measurement "+title);
run("Close");
selectWindow("Results of PSD95 Measurement "+title);
run("Close");
selectWindow("Results "+title);
run("Close");


}
 
	