/*********************************************************
                  Main Window!

Click the "Run" button to Run the simulation.

Change the geometry, flow conditions, numerical parameters
visualizations and measurements from this window.

This screen has an example. Other examples are found at 
the top of each tab. Copy/paste them here to run, but you 
can only have one setup & run at a time.

*********************************************************/
import java.util.Random;


BDIM flow;
Body body;
FloodPlot flood;
//SaveVectorFieldForEllipse data;
SaveVectorFieldFromBoundary data;
DiscNACA foil;
float t = 0., u = 0.;
int iter = 0, max_iter = 10;
float stime = 300., etime = 400.;
String lines;  // Array to store lines from the text file
float[][] points;
float[] point;
float x;
float y;

void setup(){
  size(700,700);                             // display window size
}

float[][] parse_string(String lines) {
  
  // Remove square brackets and spaces
  lines = lines.replaceAll("\\[|\\]|\\s", "");
  // Split the string into individual elements based on commas
  String[] elements = split(lines, ',');
  // Determine the number of rows and columns in the array
  int rows = elements.length / 3; // Each point has three values: x, y, z
  int cols = 3; // Assuming three columns for x, y, z

  // Create a 2D array of floats
  points = new float[rows][cols];
  
  // Convert the elements to floats and populate the array
  int index = 0;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      points[i][j] = float(elements[index]);
      index++;
    }
  }
  // Print the array for verification
  //for (int i = 0; i < rows; i++) {
  //  for (int j = 0; j < 2; j++) {
  //    print(points[i][j] + "\t");
  //  }
  //  println();
  //}
 
  return points;
}

void customsetup(int iteration){  
  // Create a Random object
  size(700,700); 
  int n=(int)pow(2,6); 
  Window view = new Window(n,n);

  lines = loadStrings("/Users/weilong/data/boundary_test2/sim_0/boundary_"+str(iteration)+".txt")[0];
  points = parse_string(lines);
  println("points: ", points);
  x = points[0][0]; 
  y = points[0][1];
    
  body = new GENERATED_NACA(x,y, points, view);
  
  //for (int i = 0; i < points.length; i++) {
  //  x = points[i][0]; 
  //  y = points[i][1];
  //  println(i, x, y);
  //  PVector vector = new PVector(x, y);
  //  body.coords.add(vector);
  //  //body.coords[i][0] = float(lines[i][0]);
  //  //body.coords[i][1] = float(lines[i][1]);
  //}
  
  flow = new BDIM(n,n,1.,body);             // solve for flow using BDIM
  flood = new FloodPlot(view);               // initialize a flood plot...
  flood.setLegend("vorticity",-.5,.5);       //    and its legend
  
  data = new SaveVectorFieldFromBoundary("/Users/weilong/data/design/simulation_"+str(iteration)+".txt", 64, 64);

}
void draw(){
  if ((t == 0.) && (iter < max_iter)){
    customsetup(iter);
  }
  if(t<stime){  // run simulation until t<Time
    body.follow();                             // update the body
    flow.update(body); flow.update2();         // 2-step fluid update
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display();      
    t+=flow.dt;
    //System.out.println(t);
    //System.out.println(flow.dt);
  }else if((stime<= t) && (t<etime)){  // run simulation until t<Time
    body.follow();                             // update the body
    flow.update(body); flow.update2();         // 2-step fluid update
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display();      
    data.addField(flow.u, flow.p);
    PrintWriter output;
    output = createWriter("/Users/weilong/data/design/sim_"+str(iter)+"/boundary_"+str(int(t-stime))+".txt");
    output.print(body.coords);
    output.flush();                           // Writes the remaining data to the file
    output.close();                           // Closes the file
    t+=flow.dt;
  }
  else{  // close and save everything when t>Time
    data.finish();
    t = 0.;
    iter+=1;
    //exit();
  }
  if (max_iter <= iter){  // close and save everything when t>Time
    exit();
  }
}


/*
import java.util.Random;

BDIM flow;
Body body;
FloodPlot flood;
SaveVectorFieldForEllipse data;
int example = 3; // Choose an example reaction function
float t = 0., u = 0.;
int iter = 0, max_iter = 100;

void setup(){
  size(700,700);                             // display window size
}
void customsetup(int iteration){
  // Create a Random object
  Random random = new Random();
  // Specify the range of random numbers you want to generate
  int xlowerBound = 0;
  int xupperBound = 20;
  // Generate a random integer within the specified range
  int xrandomInteger = xlowerBound + random.nextInt(xupperBound - xlowerBound + 1);
  // Output the random integer
  //System.out.println("Random integer: " + xrandomInteger);
  
  int ylowerBound = -5;
  int yupperBound = 5;
  int yrandomInteger = ylowerBound + random.nextInt(yupperBound - ylowerBound + 1);

  float hlowerBound = -5f;
  float hupperBound = 0f;
  float hrandomFloat = hlowerBound + random.nextFloat() * (hupperBound - hlowerBound);

  float alowerBound = -0.01;
  float aupperBound = 0.4;
  float arandomFloat = alowerBound + random.nextFloat() * (aupperBound - alowerBound);

  size(700,700); 
  int n=(int)pow(2,7);  
  float L = n/4., l = 0.2;                   // length-scale in grid units
  float x = n/3+xrandomInteger, y = n/2+yrandomInteger;
  float h = L*l+hrandomFloat, a = l+arandomFloat, pivot = 0.5;
  Window view = new Window(n,n);
  body = new ChaoticEllipse(x, y, h, a, pivot,example,view); // define geom
  flow = new BDIM(n,n,1.,body);               // solve for flow using BDIM
  flood = new FloodPlot(view);                // intialize a flood plot...
  flood.setLegend("vorticity",-.5,.5);        //    and its legend
  data = new SaveVectorFieldForEllipse("saved/ellipse_"+str(iteration)+".txt", x, y, h, a, pivot, n, n);
}
void draw(){
  if ((t == 0.) && (iter < max_iter)){
    customsetup(iter);
    System.out.println("Iteration: " + iter);
  }
  if(t<100.){  // run simulation until t<Time
    body.react(flow);
    flow.update(body); flow.update2();         // 2-step fluid update
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display(); // display the body
    t+=flow.dt;
    //System.out.println(t);
    //System.out.println(flow.dt);
  }else if((100.<= t) && (t<400.)){  // run simulation until t<Time
    body.react(flow);
    flow.update(body); flow.update2();         // 2-step fluid update
    data.addField(flow.u, flow.p);
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display();                            // display the body
    PrintWriter output;
    output = createWriter("boundary/sim_"+str(iter)+"/boundary_"+str(int(t)-100)+".txt");
    output.print(body.coords);
    output.flush();                           // Writes the remaining data to the file
    output.close();                           // Closes the file
    t+=flow.dt;
  }
  else{  // close and save everything when t>Time
    data.finish();
    t = 0.;
    iter+=1;
    //exit();
  }
  if (max_iter <= iter){  // close and save everything when t>Time
    exit();
  }
}
*/

/*
import java.util.Random;

BDIM flow;
Body body;
FloodPlot flood;
SaveVectorFieldForEllipse data;
int example = 3; // Choose an example reaction function
float t = 0.;
String sim_id = "0";

void setup(){
  size(700,700);                             // display window size
  int n=(int)pow(2,7);                       // number of grid points
  float L = n/4., l = 0.2;                   // length-scale in grid units
  float x = n/3+10, y = n/2-5;
  float h = L*l+2, a = l, pivot = 0.5;
  Window view = new Window(n,n);
  body = new ChaoticEllipse(x, y, h, a, pivot,example,view); // define geom
  flow = new BDIM(n,n,1.,body);               // solve for flow using BDIM
  flood = new FloodPlot(view);                // intialize a flood plot...
  flood.setLegend("vorticity",-.5,.5);        //    and its legend
  data = new SaveVectorFieldForEllipse("saved/ellipse_00004.txt", x, y, h, a, pivot, n, n);
}
void draw(){
  if(t<100.){  // run simulation until t<Time
    body.react(flow);
    flow.update(body); flow.update2();         // 2-step fluid update
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display(); // display the body
    t+=flow.dt;
  }else if((100.<= t) && (t<400.)){  // run simulation until t<Time
    body.react(flow);
    flow.update(body); flow.update2();         // 2-step fluid update
    data.addField(flow.u, flow.p);
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display(); // display the body
    PrintWriter output;
    output = createWriter("boundary/sim_000003/boundary_"+str(int(t)-100)+".txt");
    output.print(body.coords);
    output.flush(); // Writes the remaining data to the file
    output.close(); // Closes the file
    t+=flow.dt;
  }
  else{  // close and save everything when t>Time
    data.finish();

    exit();
  }
}
*/

/*
BDIM flow;
Body body;
FloodPlot flood;
SaveVectorFieldForEllipse eldata;
int example = 3; // Choose an example reaction function
float t = 0.;

void setup(){
  size(700,700);                             // display window size
  int n=(int)pow(2,7);                       // number of grid points
  float L = n/4., l = 0.2;                   // length-scale in grid units
  float x = n/3+10, y = n/2-5;
  float h = L*l+2, a = l, pivot = 0.5;
  Window view = new Window(n,n);
  body = new ChaoticEllipse(x, y, h, a, pivot,example,view); // define geom
  flow = new BDIM(n,n,1.,body);               // solve for flow using BDIM
  flood = new FloodPlot(view);                // intialize a flood plot...
  flood.setLegend("vorticity",-.5,.5);        //    and its legend
  eldata = new SaveVectorFieldForEllipse("saved/ellipse_00003.txt", x, y, h, a, pivot, n, n);
}

void draw(){
  if(t<100.){  // run simulation until t<Time
    body.react(flow);
    flow.update(body); flow.update2();         // 2-step fluid update
    //data.addField(flow.u, flow.p);
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display(); // display the body
    t+=flow.dt;
  }else if((100.<= t) && (t<400.)){  // run simulation until t<Time
    body.react(flow);
    flow.update(body); flow.update2();         // 2-step fluid update
    eldata.addField(flow.u, flow.p);
    flood.display(flow.u.curl());              // compute and display vorticity
    body.display(); // display the body
    PrintWriter output;
    output = createWriter("boundary/sim_000003/boundary_"+str(int(t)-100)+".txt");
    output.print(body.coords);
    output.flush(); // Writes the remaining data to the file
    output.close(); // Closes the file
    t+=flow.dt;
  }
  else{  // close and save everything when t>Time
    eldata.finish();
    exit();
  }
}
*/
/*
// Circle that can be dragged by the mouse
BDIM flow;
Body body;
FloodPlot flood;

void setup(){
  size(700,700);                             // display window size
  int n=(int)pow(2,7);                       // number of grid points
  float L = n/8.;                            // length-scale in grid units
  Window view = new Window(n,n);

  body = new CircleBody(n/3,n/2,L,view);     // define geom
  flow = new BDIM(n,n,1.5,body);             // solve for flow using BDIM
  flood = new FloodPlot(view);               // initialize a flood plot...
  flood.setLegend("vorticity",-.5,.5);       //    and its legend
}
void draw(){
  body.follow();                             // update the body
  flow.update(body); flow.update2();         // 2-step fluid update
  flood.display(flow.u.curl());              // compute and display vorticity
  body.display();                            // display the body
}
void mousePressed(){body.mousePressed();}    // user mouse...
void mouseReleased(){body.mouseReleased();}  // interaction methods
void mouseWheel(MouseEvent event){body.mouseWheel(event);}
*/
