import processing.serial.*;
import java.lang.Math;
import grafica.*;

Serial myPort;  // The serial port
int timeStart;
float sampleRate = 1; //Sample frequency in Hz
Table table;
int mouseState = 0;
float[] panelDim = new float[] {500, 300}; // Size of graphs

GPointsArray redPoints0;
GPointsArray greenPoints0;
GPointsArray bluePoints0;
GPointsArray redPoints1;
GPointsArray greenPoints1;
GPointsArray bluePoints1;
GPointsArray redPoints2;
GPointsArray greenPoints2;
GPointsArray bluePoints2;
GPointsArray redPoints3;
GPointsArray greenPoints3;
GPointsArray bluePoints3;

GPlot plot0;
GPlot plot1;
GPlot plot2;
GPlot plot3;

//Create Colour object
Colour colour = new Colour();

void setup() {
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[1], 115200);
  table = new Table();
  table.addColumn("Time (s)");
  table.addColumn("Red 0");
  table.addColumn("Green 0");
  table.addColumn("Blue 0");
  table.addColumn("Red 1");
  table.addColumn("Green 1");
  table.addColumn("Blue 1");
  table.addColumn("Red 2");
  table.addColumn("Green 2");
  table.addColumn("Blue 2");
  table.addColumn("Red 3");
  table.addColumn("Green 3");
  table.addColumn("Blue 3");
  
  // Initialize point arrays
  size(1300,900);
  redPoints0 = new GPointsArray();
  greenPoints0 = new GPointsArray();
  bluePoints0 = new GPointsArray();
  redPoints1 = new GPointsArray();
  greenPoints1 = new GPointsArray();
  bluePoints1 = new GPointsArray();
  redPoints2 = new GPointsArray();
  greenPoints2 = new GPointsArray();
  bluePoints2 = new GPointsArray();
  redPoints3 = new GPointsArray();
  greenPoints3 = new GPointsArray();
  bluePoints3 = new GPointsArray();
  
  //Initialize graph settings
  plot0 = new GPlot(this);
  plot0.setPos(25,25);
  plot0.setDim(panelDim);
  plot0.setTitleText("Chamber 1");
  plot0.getXAxis().setAxisLabelText("Time");
  plot0.getYAxis().setAxisLabelText("Brightness");
  plot1 = new GPlot(this);
  plot1.setPos(625,25);
  plot1.setDim(panelDim);
  plot1.setTitleText("Chamber 2");
  plot1.getXAxis().setAxisLabelText("Time");
  plot1.getYAxis().setAxisLabelText("Brightness");
  plot2 = new GPlot(this);
  plot2.setPos(25,425);
  plot2.setDim(panelDim);
  plot2.setTitleText("Chamber 3");
  plot2.getXAxis().setAxisLabelText("Time");
  plot2.getYAxis().setAxisLabelText("Brightness");
  plot3 = new GPlot(this);
  plot3.setPos(625,425);
  plot3.setDim(panelDim);
  plot3.setTitleText("Chamber 4");
  plot3.getXAxis().setAxisLabelText("Time");
  plot3.getYAxis().setAxisLabelText("Brightness");
  
  //Add layers to graphs
  plot0.addLayer("RED", redPoints0);
  plot0.addLayer("GREEN", greenPoints0);
  plot0.addLayer("BLUE", bluePoints0);
  plot1.addLayer("RED", redPoints1);
  plot1.addLayer("GREEN", greenPoints1);
  plot1.addLayer("BLUE", bluePoints1);
  plot2.addLayer("RED", redPoints2);
  plot2.addLayer("GREEN", greenPoints2);
  plot2.addLayer("BLUE", bluePoints2);
  plot3.addLayer("RED", redPoints3);
  plot3.addLayer("GREEN", greenPoints3);
  plot3.addLayer("BLUE", bluePoints3);
  
  //Draw graphs with default settings
  plot0.defaultDraw();
  plot1.defaultDraw();
  plot2.defaultDraw();
  plot3.defaultDraw();
}

void draw() {
    if (mouseState == 0) {
    if (mousePressed == true) {myPort.write('y'); mouseState = 1; println("Sent"); timeStart=millis();}
    delay(100);
    }
    if (mouseState == 1){
      if (myPort.available() > 0) {
        char inByte = myPort.readChar();
        
        if (inByte != '('){
          myPort.clear();
        }
        
        if (inByte == '('){
          String inBuffer = myPort.readStringUntil(')');  
          println(inBuffer);
          if (inBuffer.charAt(0) == '0'){
            
            //Start data read
            colour.buffer = inBuffer;
            colour.parseBuffer();
            myPort.write(65);
            
            inBuffer = myPort.readStringUntil(')');   
            colour.buffer = inBuffer;
            colour.parseBuffer();
            myPort.write(65);
            
            inBuffer = myPort.readStringUntil(')');   
            colour.buffer = inBuffer;
            colour.parseBuffer();
            myPort.write(65);
            
            inBuffer = myPort.readStringUntil(')');   
            colour.buffer = inBuffer;
            colour.parseBuffer();
            //End Data Read
            
            colour.updateColourStrings();
            colour.printColourStrings();
            
            myPort.write(65);
            
            
            //FOR DIAGNOSTIC ONLY
            //print(inBuffer); print("/");
            //print(inBuffer); print("//"); print(noCR); println("!!");
            
            //Add data to new row
            TableRow newRow = table.addRow();
            newRow.setFloat("Time (s)", colour.getCurrentTime());
            newRow.setString("Red 0",colour.red0);
            newRow.setString("Green 0",colour.green0);
            newRow.setString("Blue 0",colour.blue0);
            newRow.setString("Red 1",colour.red1);
            newRow.setString("Green 1",colour.green1);
            newRow.setString("Blue 1",colour.blue1);
            newRow.setString("Red 2",colour.red2);
            newRow.setString("Green 2",colour.green2);
            newRow.setString("Blue 2",colour.blue2);
            newRow.setString("Red 3",colour.red3);
            newRow.setString("Green 3",colour.green3);
            newRow.setString("Blue 3",colour.blue3);
            
            //Save updated table
            saveTable(table, "C:/Users/darrel/Desktop/New.csv");
            
            //Plot Sensor 0
            plot0.addPoint(colour.currentTime,Integer.parseInt(colour.red0), "1", "RED");
            plot0.addPoint(colour.currentTime,Integer.parseInt(colour.green0), "2", "GREEN");
            plot0.addPoint(colour.currentTime,Integer.parseInt(colour.blue0), "3", "BLUE");
  
            plot0.getLayer("RED").setPointColor(color(255,0,0));
            plot0.getLayer("GREEN").setPointColor(color(0,255,0));
            plot0.getLayer("BLUE").setPointColor(color(0,0,255));
  
            plot0.beginDraw();
            plot0.drawBackground();
            plot0.drawBox();
            plot0.drawXAxis();
            plot0.drawYAxis();
            plot0.drawTopAxis();
            plot0.drawRightAxis();
            plot0.drawTitle();
            plot0.drawGridLines(GPlot.BOTH);
            plot0.drawPoints();
            plot0.drawLines();
            plot0.endDraw();
            
            //Plot Sensor 1
            plot1.addPoint(colour.currentTime,Integer.parseInt(colour.red1), "1", "RED");
            plot1.addPoint(colour.currentTime,Integer.parseInt(colour.green1), "2", "GREEN");
            plot1.addPoint(colour.currentTime,Integer.parseInt(colour.blue1), "3", "BLUE");
  
            plot1.getLayer("RED").setPointColor(color(255,0,0));
            plot1.getLayer("GREEN").setPointColor(color(0,255,0));
            plot1.getLayer("BLUE").setPointColor(color(0,0,255));
  
            plot1.beginDraw();
            plot1.drawBackground();
            plot1.drawBox();
            plot1.drawXAxis();
            plot1.drawYAxis();
            plot1.drawTopAxis();
            plot1.drawRightAxis();
            plot1.drawTitle();
            plot1.drawGridLines(GPlot.BOTH);
            plot1.drawPoints();
            plot1.drawLines();
            plot1.endDraw();
            
            //Plot Sensor 2
            plot2.addPoint(colour.currentTime,Integer.parseInt(colour.red2), "1", "RED");
            plot2.addPoint(colour.currentTime,Integer.parseInt(colour.green2), "2", "GREEN");
            plot2.addPoint(colour.currentTime,Integer.parseInt(colour.blue2), "3", "BLUE");
  
            plot2.getLayer("RED").setPointColor(color(255,0,0));
            plot2.getLayer("GREEN").setPointColor(color(0,255,0));
            plot2.getLayer("BLUE").setPointColor(color(0,0,255));
  
            plot2.beginDraw();
            plot2.drawBackground();
            plot2.drawBox();
            plot2.drawXAxis();
            plot2.drawYAxis();
            plot2.drawTopAxis();
            plot2.drawRightAxis();
            plot2.drawTitle();
            plot2.drawGridLines(GPlot.BOTH);
            plot2.drawPoints();
            plot2.drawLines();
            plot2.endDraw();
            
            //Plot Sensor 3
            plot3.addPoint(colour.currentTime,Integer.parseInt(colour.red3), "1", "RED");
            plot3.addPoint(colour.currentTime,Integer.parseInt(colour.green3), "2", "GREEN");
            plot3.addPoint(colour.currentTime,Integer.parseInt(colour.blue3), "3", "BLUE");
  
            plot3.getLayer("RED").setPointColor(color(255,0,0));
            plot3.getLayer("GREEN").setPointColor(color(0,255,0));
            plot3.getLayer("BLUE").setPointColor(color(0,0,255));
  
            plot3.beginDraw();
            plot3.drawBackground();
            plot3.drawBox();
            plot3.drawXAxis();
            plot3.drawYAxis();
            plot3.drawTopAxis();
            plot3.drawRightAxis();
            plot3.drawTitle();
            plot3.drawGridLines(GPlot.BOTH);
            plot3.drawPoints();
            plot3.drawLines();
            plot3.endDraw();
          }
        }
      }
      myPort.clear();
      int temp = Math.round(1000/sampleRate);
      delay(temp);
    }
}

public class Time {
  
  public float sec = 0;
  public int min = 0;
  public int hr = 0;
  
  protected int time;
  
  public void process(float tSec){
    float psec = tSec % 60;
    int pmin = (int)(Math.floor(tSec/60)%60);
    int pminTemp = (int)Math.floor(tSec/60);
    int phr = (int)Math.floor(pminTemp/60);
    
    sec = psec;
    min = pmin;
    hr = phr;
  }
  
  public String formatTime(){
    String formatTime = Integer.toString(hr) + ":" + Integer.toString(min) + ":" + Integer.toString((int)sec);
    return formatTime;
  }
}

public class Colour {
  
  public String red0;
  public String green0;
  public String blue0;
  public String red1;
  public String green1;
  public String blue1;
  public String red2;
  public String green2;
  public String blue2;
  public String red3;
  public String green3;
  public String blue3;
  public char sens;
  public String buffer;
  public TableRow newRow;
  public float currentTime;
  private Time elapsedTime;
  
  //RGB sensor reading in strings
  public String RGB_0 = "*Analyzing*";
  public String RGB_1 = "*Analyzing*";
  public String RGB_2 = "*Analyzing*";
  public String RGB_3 = "*Analyzing*";
  
  public void parseBuffer(){
    sens = buffer.charAt(0);
    if (sens == 0) {
      red0  =   buffer.substring(buffer.indexOf("<")+1,buffer.indexOf(">"));
      green0  = buffer.substring(buffer.indexOf("[")+1,buffer.indexOf("]"));
      blue0  =  buffer.substring(buffer.indexOf("{")+1,buffer.indexOf("}"));
    }
    if (sens == 1) {
      red1  =   buffer.substring(buffer.indexOf("<")+1,buffer.indexOf(">"));
      green1  = buffer.substring(buffer.indexOf("[")+1,buffer.indexOf("]"));
      blue1  =  buffer.substring(buffer.indexOf("{")+1,buffer.indexOf("}"));
    }
    if (sens == 2) {
      red2  =   buffer.substring(buffer.indexOf("<")+1,buffer.indexOf(">"));
      green2  = buffer.substring(buffer.indexOf("[")+1,buffer.indexOf("]"));
      blue2  =  buffer.substring(buffer.indexOf("{")+1,buffer.indexOf("}"));
    }
    if (sens == 3) {
      red3  =   buffer.substring(buffer.indexOf("<")+1,buffer.indexOf(">"));
      green3  = buffer.substring(buffer.indexOf("[")+1,buffer.indexOf("]"));
      blue3  =  buffer.substring(buffer.indexOf("{")+1,buffer.indexOf("}"));
    }
  }
  
  
  public void updateColourStrings() {
    RGB_0 = String.format("%-6s",red0) + " , " +String.format("%-6s",green0) + " , " +String.format("%-6s",blue0);
    RGB_1 = String.format("%-6s",red1) + " , " +String.format("%-6s",green1) + " , " +String.format("%-6s",blue1);
    RGB_2 = String.format("%-6s",red2) + " , " +String.format("%-6s",green2) + " , " +String.format("%-6s",blue2);
    RGB_3 = String.format("%-6s",red3) + " , " +String.format("%-6s",green3) + " , " +String.format("%-6s",blue3);
  }
  
  public float getCurrentTime(){
    currentTime = (millis()-timeStart)/1000.00;
    return currentTime;
  }
  
  public String stringifyElapsedTime(){
    elapsedTime.process(currentTime);
    return elapsedTime.formatTime();
  }
  
  public void printColourStrings() {
    println("<RGB Readings>");
    print("Chamber 1: "); println(RGB_0);
    print("Chamber 2: "); println(RGB_1);
    print("Chamber 3: "); println(RGB_2);
    print("Chamber 4: "); println(RGB_3);
    print("Elapsed Time:"); println(stringifyElapsedTime());
    println(table.getRowCount());
    println("");
  }
}
