use <utils/morphology.scad> // https://github.com/openscad/scad-utils

/*
 motor: https://www.geekbuying.com/item/Flywoo-NIN-1404-3750KV-2-4S-Brushless-Motor-For-FPV-Racing-RC-Drone-418014.html
 
 blade: https://www.banggood.com/2-Pairs-HQProp-T4X2_5-4025-4-Inch-2-blade-Durable-PC-Propeller-2CW+2CCW-for-RC-Drone-FPV-Racing-p-1590493.html?akmClientCountry=AU&rmmds=search&p=YQ270915554535201710&custlixnkid=731048&cur_warehouse=CN
*/

$fs=0.01;
$fa=3;
$fn=64;


arm_l=90;
arm_w=5;

module spoke() {
    polygon([[-arm_w,arm_l],[arm_w,arm_l],[arm_w,9],[-arm_w,9]]);
}


arm_pad=6;
arm_hole_r=3.5;
notch_w=1;
notch_l=7;

module arm() {
    difference() {
        fillet(r=5) { 
            union() {
                spoke();
                translate([arm_pad,-arm_pad]) circle(arm_pad);
                translate([-arm_pad,-arm_pad]) circle(arm_pad);
                translate([-arm_pad,arm_pad]) circle(arm_pad);
                translate([arm_pad,arm_pad]) circle(arm_pad);
            }
        }
        circle(arm_hole_r);
        for (i = [0 : 1])
            for (j = [0 : 1]) {
                hull() {
                    translate([i * 12 - 6, j * 12 - 6, 0])
                        circle(1);
                    translate([i * 13 - 6.5, j * 13 - 6.5, 0])
                        circle(1);
                }
            }
        polygon([[-notch_w,notch_l],[notch_w,notch_l],[notch_w,-notch_l],[-notch_w,-notch_l]]);
        polygon([[-notch_l,notch_w],[notch_l,notch_w],[notch_l,-notch_w],[-notch_l,-notch_w]]);
    }
}


wing_l_1=160;
wing_w_1=70;  
    
module wing(flip) {
    mirror([flip,0])
    rotate([20,-10,-4]) {
        linear_extrude(height=1, twist=0, scale=1)
            polygon([[-wing_w_1,wing_l_1],[0,wing_l_1],[0,0],[-10,0],[-10,30],[-wing_w_1,70]]);
        translate([-wing_w_1,70,0])
            rotate([0,-10,0])
                linear_extrude(height=1, twist=0, scale=1)
                    polygon([[-wing_w_1,90],[0,90],[0,0],[20-wing_w_1,40]]);
    }
}   


engine_r=51.5; // (5" blades are 63.5 mm, 4" blades are 50.8mm)
engine_h=14.5 + 5.5 + 3; // motor + blade height + mount

module engine() {
    translate([0,0,10])
        difference() {
            scale([1,1,engine_h/10]) {
                    rotate_extrude() {
                      translate([engine_r+2,0]) 
                         circle(5);
                    } 
                }
            translate([0,0,-20])    
                cylinder(engine_r, engine_r, engine_r);   
        } 
}


// frame
floor_w=25;
floor_l=75;

linear_extrude(height=3, twist=0, scale=1)
    fillet(r=10) rounding(r=3.5) union() {
        shell(d=-10)
            union() {
                translate([56,120,0]) {
                    rotate([0,0,150])
                        spoke();
                }
                translate([-56,120,0]) {
                    rotate([0,0,-150])
                        spoke();
                }
                translate([90,-90,0]) {
                    rotate([0,0,90])
                        spoke();
                }
                translate([-90,-90,0]) {
                    rotate([0,0,-90])
                        spoke();
                }

                // floor
                translate([0,-27.5])
                    polygon([[-floor_w,floor_l],[floor_w,floor_l],[floor_w,-floor_l],[-floor_w,-floor_l]]);
            }
            
            // bars
            translate([0,-5])
                polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
            translate([0,-60])
                polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
        }
    
// arms    
linear_extrude(height=3, twist=0, scale=1) {
        translate([56,120,0]) {
            rotate([0,0,150])
                arm();
        }
        translate([-56,120,0]) {
            rotate([0,0,-150])
                arm();
        }
        translate([90,-90,0]) {
            rotate([0,0,90])
                arm();
        }
        translate([-90,-90,0]) {
            rotate([0,0,-90])
                arm();
        }
    }
    
// wings    
translate([-20,-90,0])
    wing(0);
translate([20,-90,0])
    wing(1);

// engines
translate([56,120,0]) {
    engine();
}
translate([-56,120,0]) {
    engine();
}
translate([90,-90,0]) {
    engine();
}
translate([-90,-90,0]) {
    engine();
}

// battery
battery_w=35;
battery_l=105;
battery_h=27;

translate([-battery_w/2,-60,4])
    cube([battery_w,battery_l,battery_h]);

 