/**********************************
 SaveVectorField class
 
Saves the velocity and pressure field to a text file with customizable header
These files can be quite large!

example code:


SaveVectorField data;
AudreyTest test;

void setup(){
  int resolution = 128, xLengths=6, yLengths=3, zoom = 1;
  float xStart = -4, yDist =0.2;
  test = new AudreyTest(resolution, xLengths, yLengths, xStart , yDist, zoom);
  test.update();

  data = new SaveVectorField("saved/data.txt",test.body.a.coords,test.Re,resolution, test.n,test.m);
  data.addField(test.flow.u,test.flow.p);
  data.finish();
}
***********************************/
class SaveVectorFieldForEllipse {
  PrintWriter output;
  int m, n;

  SaveVectorFieldForEllipse(String name, float x, float y, float h, float a, float pivot, int n, int m) {
    this.m = m;
    this.n = n;
    output = createWriter(name);
    output.println("%% Initial parameters for elliptic cylinder.");
    output.print("; x = "+ x);
    output.print("; y = "+ y);
    output.print("; h = "+ h);
    output.print("; a = "+ a);
    output.print("; pivot = "+ pivot);
    output.print("; n = "+ n);
    output.print("; m = "+ m);
    output.println(";");
  }


  void addField(VectorField u, Field p) {
    for (int j=1; j<m-1; j++) {
      output.print("x-coords ");
      for (int i=1; i<n-1; i++) {
        output.print(u.x.a[i][j] +" ");
      }
      output.println(";");
    }
    for (int j=1; j<m-1; j++) {
      output.print("y-coords ");
      for (int i=1; i<n-1; i++) {
        output.print(u.y.a[i][j] +" ");
      }
      output.println(";");
    }
    for (int j=1; j<m-1; j++) {
      output.print("pressure ");
      for (int i=1; i<n-1; i++) {
        output.print(p.a[i][j] +" ");
      }
      output.println(";");
    }
  }

  void finish() {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Closes the file
  }
} 


class SaveVectorFieldFromBoundary {
  PrintWriter output;
  int m, n;

  SaveVectorFieldFromBoundary(String name, int n, int m) {
    this.m = m;
    this.n = n;
    output = createWriter(name);
    output.println("%% Initial parameters.");
    output.print("; n = "+ n);
    output.print("; m = "+ m);
    output.println(";");
  }


  void addField(VectorField u, Field p) {
    for (int j=1; j<m-1; j++) {
      output.print("x-coords ");
      for (int i=1; i<n-1; i++) {
        output.print(u.x.a[i][j] +" ");
      }
      output.println(";");
    }
    for (int j=1; j<m-1; j++) {
      output.print("y-coords ");
      for (int i=1; i<n-1; i++) {
        output.print(u.y.a[i][j] +" ");
      }
      output.println(";");
    }
    for (int j=1; j<m-1; j++) {
      output.print("pressure ");
      for (int i=1; i<n-1; i++) {
        output.print(p.a[i][j] +" ");
      }
      output.println(";");
    }
  }

  void finish() {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Closes the file
  }
} 


// class SaveVectorField {
//   PrintWriter output;
//   int m, n;

//   SaveVectorField(String name, ArrayList<PVector> coords, float Re, int resolution, int n, int m) {
//     this.m = m;
//     this.n = n;
//     output = createWriter(name);
//     output.println("%% Steady field generated by a NACA foil. u, followed by v, followed by p");
//     output.print("% xcoord = [");
//     for (int i=0; i<coords.size(); i++) {
//       output.print(coords.get(i).x +" ");
//     }
//     output.println("];");

//     output.print("% ycoord = [");
//     for (int i=0; i<coords.size(); i++) {
//       output.print(coords.get(i).y +" ");
//     }
//     output.println("];");

//     output.print("% resolution = "+ resolution);
//     output.print("; n = "+ n);
//     output.print("; m = "+ m);
//     output.print("; Re = "+ Re);
//     output.println(";");
//   }


//   void addField(VectorField u, Field p) {
//     for (int j=1; j<m-1; j++) {
//       for (int i=1; i<n-1; i++) {
//         output.print(u.x.a[i][j] +" ");
//       }
//       output.println(";");
//     }
//     for (int j=1; j<m-1; j++) {
//       for (int i=1; i<n-1; i++) {
//         output.print(u.y.a[i][j] +" ");
//       }
//       output.println(";");
//     }
//     for (int j=1; j<m-1; j++) {
//       for (int i=1; i<n-1; i++) {
//         output.print(p.a[i][j] +" ");
//       }
//       output.println(";");
//     }
//   }

//   void finish() {
//     output.flush(); // Writes the remaining data to the file
//     output.close(); // Closes the file
//   }
// } 


// class SaveVectorFieldFromBoundary {
//   PrintWriter output;
//   int m, n;

//   SaveVectorFieldFromBoundary(String name, ArrayList<PVector> coords, int resolution, int n, int m) {
//     this.m = m;
//     this.n = n;
//     println("debug");
//     output = createWriter(name);
//     output.println("%% Steady field generated from predefined boundaries. u, followed by v, followed by p");
//     output.print("% xcoord = [");
//     for (int i=0; i<coords.size(); i++) {
//       output.print(coords.get(i).x +" ");
//     }
//     output.println("];");

//     output.print("% ycoord = [");
//     for (int i=0; i<coords.size(); i++) {
//       output.print(coords.get(i).y +" ");
//     }
//     output.println("];");

//     output.print("% resolution = "+ resolution);
//     output.print("; n = "+ n);
//     output.print("; m = "+ m);
//     output.println(";");
//   }


//   void addField(VectorField u, Field p) {
//     for (int j=1; j<m-1; j++) {
//       for (int i=1; i<n-1; i++) {
//         output.print(u.x.a[i][j] +" ");
//       }
//       output.println(";");
//     }
//     for (int j=1; j<m-1; j++) {
//       for (int i=1; i<n-1; i++) {
//         output.print(u.y.a[i][j] +" ");
//       }
//       output.println(";");
//     }
//     for (int j=1; j<m-1; j++) {
//       for (int i=1; i<n-1; i++) {
//         output.print(p.a[i][j] +" ");
//       }
//       output.println(";");
//     }
//   }

//   void finish() {
//     output.flush(); // Writes the remaining data to the file
//     output.close(); // Closes the file
//   }
// } 
