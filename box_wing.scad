// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <cabin3.scad>

/* ----------------------------------------------------

For some reason, this is the only version that renders!

------------------------------------------------------- */

$fs=0.01;
$fa=3;
$fn=64;

NACA = 2422;
ATTACK = 15;
THICKEN = 40;

module trace(bezier) {
  trace_bezier(bezier, N=len(bezier)-1);
}

function bzpoints(bezier) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=200)
);

function gen_dat(X, R=0, N=100) = [for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca=NACA, L=x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, R+90, x[5], R_(0, 0, x[4], vec3D(v2)))) )   // rotate and translate
     v3];

//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);


module wing(h, orientation) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  X = [ // L, dx, dy, dz, R
      [35, 0.01,  h, 80, -ATTACK, 0],
      [27, 80,  h, 80, -ATTACK, 0],
      [18, 95,  h, 80, -ATTACK, 0],
      [10, 120,  h, 80, -ATTACK, -THICKEN/2], 
      [12, 130, h-10, 80, 0, -THICKEN],
      [15, 132,  10, 75, 0, -THICKEN],  
      [30, 128,  -5, 20, 0, -THICKEN],  
      [28, 110,  -14, 3, -ATTACK, -THICKEN/2],
      [26,   0.01,  -21, -3, -ATTACK, 0]
   ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module front_wing() {
  wing(60, 0);
  mirror([1, 0, 0]) {
    wing(60, 0);
  }
}

module back_wing() {
  rotate([0,180,0])
    wing(132, 180);
  mirror([1, 0, 0]) {
    rotate([0,180,0])
    wing(132, 180);
  }  
}

module prop(r) {
  translate([121,58,85]) {
    rotate([0,90,0])
      cylinder(6,6,6);
    translate([3,0,-12]) {
      translate([0,0,-4])
        cylinder(10,3,3);
      cylinder(2,r,r);
    }
  }
} 

translate([0,30,0]) {
  front_wing();
  prop(45);
  mirror([1, 0, 0])
    prop(45);
}
translate([0,30,320]) {
  back_wing();
}
translate([0,100,160]) {
  prop(45);
  mirror([1, 0, 0])
    prop(45);
}
translate([0,70,70]) {
  rotate([0,270,0]) {
    quad_cabin(240, 4);
  }
}
  