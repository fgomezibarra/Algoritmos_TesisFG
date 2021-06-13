	
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output Results directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


// El resumen del macro
Run(input); // genera dos carpetas nuevas donde se guardan los resultados, luego analiza las imagenes si son tiff las procesa, de lo contrario las ignora
//guarda los datos en un archivo .csv que se puede abrir con excel lo guarda en la carpeta donde estan las imagenes


 	
function Run (input) {  // Estas variables generan que se guarden en distintas carpetas luego del procesamiento 
	
splitDir_1= output + "/Z images con T  1/"; // Aqui se guardaran los resultados de la carpeta 1
splitDir_2= output + "/+VePDM values con T 2/"; // Aqui se guardaran los resultados de la carpeta 2
splitDir_3= output + "/PDM values con T 3/"; // Aqui se guardaran los resultados de la carpeta 2

File.makeDirectory(splitDir_1);
File.makeDirectory(splitDir_2); 
File.makeDirectory(splitDir_3); 
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
		print("Processing: " +title);
	selectWindow(title);
	C1 = "C1-" + title;
	C4 = "C4-" + title;
	C2 = "C2-" + title;
	C5 = "C5-" + title;
	C3 = "C3-" + title;
	C6 = "C6-" + title;
	PDM1="PDM Values - C1-" +title+ " and C2-" +title;
	vPDM1= "+vePDM  Values - C1-" + title+ " and C2-" + title;
	PDM2="PDM Values - C2-" +title+ " and C3-" +title;
	vPDM2= "+vePDM  Values - C2-" + title+ " and C3-" + title;
	PDM3="PDM Values - C1-" +title+ " and C3-" +title;
	vPDM3= "+vePDM  Values - C1-" + title+ " and C3-" + title;
	selectWindow(title);
	run("8-bit");
	run("Split Channels");
	selectWindow(C1);
	setAutoThreshold("Default dark");
	setThreshold(10, 255);// linea 55 treshold C1 ver linea 103
	getThreshold(C1T,upper);
	selectWindow(C2);
	setAutoThreshold("Default dark");
	setThreshold(8, 255); // linea 59 treshold C2 ver linea 91
	getThreshold(C2T,upper);
	selectWindow(C3);
	setAutoThreshold("Default dark");
	setThreshold(28, 255); // linea 63 trehsold C3 ver linea 108
	getThreshold(C3T,upper);
   selectWindow(C1);
    saveAs("tiff",splitDir_1+C1);
    selectWindow(C2);
    saveAs("tiff",splitDir_1+C2);
    selectWindow(C3);
    saveAs("tiff",splitDir_1+C3);
       run("Intensity Correlation Analysis", "channel=C1 channel_0=C2 channel_1=[Red : Green] use=None use_0 crosshair=3 display_3 display_4");  // C1 y C2 (se usa treshold)
    selectWindow(vPDM1);
    saveAs("tiff",splitDir_2+vPDM1);
    close();
    selectWindow(PDM1);
    saveAs("tiff",splitDir_3+PDM1);
    close();
    selectWindow(C2);
	run("Duplicate...", "title=C5");
	selectWindow(C2);
	close();
	 selectWindow("C5");
	 rename(C2);
	 selectWindow(C2);
	 setAutoThreshold("Default dark");
	setThreshold(C2T, upper); //treshold C2
	 selectWindow(C3);
	 run("Duplicate...", "title=C6");
	 selectWindow(C3);
	 close();
	 selectWindow(C1);
	run("Duplicate...", "title=C4");
	selectWindow(C1);
	close();
	 selectWindow("C4");
	 rename(C1);
	 setAutoThreshold("Default dark");
	setThreshold(C1T, upper);//treshold C1
	 selectWindow("C6");
	 rename(C3);
	 selectWindow(C3);
	setAutoThreshold("Default dark");
	setThreshold(C3T, upper); //treshold C3
	run("Intensity Correlation Analysis", "channel=C1 channel_0=C2 channel_1=[Green : Blue] use=None use_0 crosshair=3 display_3 display_4");  //C2 y C3
	  selectWindow(vPDM2);
    saveAs("tiff",splitDir_2+vPDM2);
    close();
    selectWindow(PDM2);
    saveAs("tiff",splitDir_3+PDM2);
    close();
	selectWindow(C2);
	close();
	selectWindow(C3);
	 run("Duplicate...", "title=C6");
	 selectWindow(C3);
	 close();
	  selectWindow("C6");
	 rename(C3);
	 selectWindow(C3);
	setAutoThreshold("Default dark");
	setThreshold(C3T, upper); //treshold C3
	run("Intensity Correlation Analysis", "channel=C1 channel_0=C2 channel_1=[Red : Blue] use=None use_0 crosshair=3 display_3 display_4"); ;//C1 y C3
	 selectWindow(vPDM3);
    saveAs("tiff",splitDir_2+vPDM3);
    close();
    selectWindow(PDM3);
    saveAs("tiff",splitDir_3+PDM3);
    close();
	selectWindow(C1);
	close();
	selectWindow(C3);
	close();

} 