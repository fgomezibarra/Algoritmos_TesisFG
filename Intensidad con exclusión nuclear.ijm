#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output Results directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


// El resumen del macro
Run(input); // genera dos carpetas nuevas donde se guardan los resultados, luego analiza las imagenes si son tiff las procesa, de lo contrario las ignora
save_data();//guarda los datos en un archivo .csv que se puede abrir con excel lo guarda en la carpeta donde estan las imagenes

 	
function Run (input) {  // Estas variables generan que se guarden en distintas carpetas luego del procesamiento 
	

splitDir_1= output + "/DAPI  1/"; // Aqui se guardaran los resultados de la carpeta 1
splitDir_2= output + "/ATF4 2/"; // Aqui se guardaran los resultados de la carpeta 2
splitDir_3= output + "/ROI 3/";

File.makeDirectory(splitDir_1);
File.makeDirectory(splitDir_2); 
File.makeDirectory(splitDir_3); 
list = getFileList(input); 
	list = Array.sort(list);
for (i=0; i<list.length; i++) { 
     if (endsWith(list[i], ".oib")){ 
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
	namefile=getString("Choose the name of you .csv File ","Resultados ATF4 pata");
	results=getInfo("log");// ventana log como variable
	
	name_file=outpath +namefile+".csv";// genera el nombre del archivo csv y el lugar de guardado
	File.saveString(results,name_file);// guarda el archivo
	selectWindow("Log");
	run("Close");
	run("Close All");

}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	
	path = input + File.separator; 
	outpath = output + File.separator; 
	full_path = path + file;
	open(full_path); // The image is now open
	
	// Set up the variables 
	// C4 es el duplicado de C1, C5 de C2 y C6 de C3.
	title = getTitle();
	selectWindow(title);
	C1 = "C1-" + title;
	C4 = "C4-" + title;
	C2 = "C2-" + title;
	C5 = "C5-" + title;
	C3 = "C3-" + title;
	C6 = "C6-" + title;
	DAPI= "DAPI"+ C1+ ".csv";
	ROI= "ROI DAPI" + title+ ".zip";
	R= "Measurements of Nuclear ATF4";
	column= " Area   "+ "   Mean  "+ "  Perimeter"+ "Area " + "  Integrated density  " + "  Raw Integrated density";

	print("Processing: " + title);
	selectWindow(title);
	run("Split Channels");
selectWindow(C2);
run("Duplicate...", "title=C4");
rename(C4);
selectWindow(C4);
setOption("ScaleConversions", true);
run("8-bit");
setAutoThreshold("Default");
//run("Threshold...");

setThreshold(35, 255);
getThreshold(lower1,upper);
Trh1=lower1;
print("Somatic ATF4 Treshold " +lower1,upper);
run("Smooth");
run("Despeckle");
run("Create Selection");
selectWindow(C2);
run("Restore Selection");
setBackgroundColor(0, 0, 0);
run("Clear", "slice");
setOption("ScaleConversions", true);
run("8-bit");
setAutoThreshold("Default");
//run("Threshold...");
setThreshold(15, 255);
getThreshold(lower2,upper);
Trh2=lower2;
print("ATF4 Treshold " +lower2,upper);
run("Create Selection");
run("ROI Manager...");
roiManager("Add");
selectWindow(C2);

	run("Analyze Particles...", "size=0-1000 circularity=0.05-0.50 show=Overlay exclude include add ");
selectWindow(C2);
run("Set Measurements...", "area mean perimeter integrated limit redirect=None decimal=3");
n = roiManager("count"); 
   for (i=0; i<n; i++) { 
       roiManager("select", i) 
       run("Measure"); 
       roiManager("save", splitDir_3+ROI);
       selectWindow(C1);
       saveAs("Jpeg", splitDir_1+C1);
       selectWindow(C2);
       roiManager("select", i) 
       roiManager("draw");
       selectWindow(C2);
       saveAs("Jpeg", splitDir_2+C2);
       
   }
   print(column);
 headings = split(String.getResultsHeadings);
  for (row=0; row<nResults; row++) {
     line = "";
     for (col=0; col<lengthOf(headings); col++)
        line = line + getResult(headings[col],row) + "  ";
        
     print(line);
  }
   roiManager("save", outpath+ROI);
   IJ.renameResults(DAPI);
   saveAs("Results", outpath+DAPI);
 
close(C1);
close(C2);
close(C3);
close(DAPI);
roiManager("reset");
	}
