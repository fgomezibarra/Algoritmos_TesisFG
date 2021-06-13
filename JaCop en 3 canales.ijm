	
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output Results directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

Run(input);
save_data();


 	
function Run (input) {  // Estas variables generan que se guarden en distintas carpetas luego del procesamiento 
	
print(output); 
splitDir_2= output + "/Results Van Steensels/"; // Aqui se guardaranlos resultados de Van Steensels 
print(splitDir_2); 
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
	namefile=getString("Choose the name of you .csv File ","Resultados JaCOP");
	results=getInfo("log");// ventana log como variable
	
	name_file=outpath +namefile+".csv";// genera el nombre del archivo csv y el lugar de guardado
	File.saveString(results,name_file);// guarda el archivo
	selectWindow("Log");
	run("Close");

}

   function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	path = input + File.separator; 
	
	full_path = path + file;
	open(full_path); // The image is now open
	        
	        title = getTitle();
	selectWindow(title);
	C1 = "C1-" + title;
	C4 = "C4-" + title;
	C2 = "C2-" + title;
	C5 = "C5-" + title;
	C3 = "C3-" + title;
	C6 = "C6-" + title;
	ICA1= "ICA A " + C1;
	ICA2= "ICA B " + C2;
	ICA4= "ICA A " + C2;
	ICA3= "ICA B " + C3;
	VS12= "Van Steensel's analysis" + C1 + "-" + C2;
	VS13= "Van Steensel's analysis" + C1 + "-" + C3;
	VS23= "Van Steensel's analysis" + C2 + "-" + C3;  
	
        
	selectWindow(title);
	run("8-bit");
	run("Split Channels");
	selectWindow(C1);
	rename(C1);
setThreshold(10,255);
getThreshold(lowerC1,upper);
selectWindow(C2);
rename(C2);
setThreshold(8,255);
getThreshold(lowerC2,upper);
selectWindow(C3);
rename(C3);
setThreshold(28,255);
getThreshold(lowerC3,upper);
	thrC1 = (lowerC1);
	thrC2 = (lowerC2);
	thrC3 = (lowerC3);
	thra = (upper);
	pthrC1= "Treshold C1 = " + thrC1;
	pthrC2= "Treshold C2 = " + thrC2;
	pthrC3= "Treshold C3 = " + thrC3;

print(pthrC1);
print(pthrC2);
print(pthrC3);
getPixelSize(unit, pixelWidth, pixelHeight);
print("20 pixel Height = " + 20*pixelHeight +"  "+unit);
print("20 pixel Width = " + 20*pixelWidth +"  "+unit);
run("JACoP ", "imga=["+C1+"] imgb=["+C2+"] thra="+d2s(thrC1,0)+" thrb="+d2s(thrC2,0)+"ccf=20");
selectWindow("Van Steensel's CCF between "+C1+" and "+C2+"");
rename(VS12);
saveAs("tiff",splitDir_2 +VS12);
close(); // aqui se termina el analisis del canal 1 y 2

run("JACoP ", "imga=["+C1+"] imgb=["+C3+"] thra="+d2s(thrC1,0)+" thrb="+d2s(thrC3,0)+"ccf=20");
selectWindow("Van Steensel's CCF between "+C1+" and "+C3+"");
rename(VS13);
saveAs("tiff",splitDir_2 +VS13);
close(); // aqui termina el analisis del canal 1 y 3 y los resultados estan grabados

run("JACoP ", "imga=["+C2+"] imgb=["+C3+"] thra="+d2s(thrC2,0)+" thrb="+d2s(thrC3,0)+"ccf=20");
selectWindow("Van Steensel's CCF between "+C2+" and "+C3+"");
rename(VS23);
saveAs("tiff",splitDir_2 +VS23);
close();// aqui termina el analisis del canal 2 y 3

selectWindow(C3);
close();
selectWindow(C2);
close();
selectWindow(C1);
close();

}
    
 