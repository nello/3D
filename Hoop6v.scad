thick = 5;
gap = 2;
magnets = 6;
magnet_h = 12.0;
magnet_r = 9.0;
magnet_gap = 50;
radius = magnet_gap; // https://en.wikipedia.org/wiki/Hexagon
height = magnet_h + 4;
disc_h = 2;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    translate([0,0,0])
    {
        // outer rings
        difference() {
            difference() {
                cylinder(h=height, r=radius, center=true);
                cylinder(h=height, r=radius-thick, center=true);
            }
            
            difference() {
                cylinder(h=height/2, r=radius, center=true);
                cylinder(h=height/2, r=radius-thick, center=true);
            }
        }

        // inner ring
       rotate_extrude() {
          translate([radius-magnet_r/2-4,0,0]) 
             circle(thick/2);
       }
        
        // struts
        rotate([0,90,90]) 
            for (i = [0 : (magnets*2-1)] )
            {
                rotate(i * 360 / magnets / 2, [1, 0, 0])
                translate([0, radius-thick/2, disc_h/2])
                rotate([180,0,0]) {
                    difference() {
                        cylinder(h=disc_h, r1=magnet_r, r2=magnet_r);
                        
                        // hole
                        translate([0,0,-10])
                            cylinder(h=30, r1=4, r2=4);
                    }
                }
            } 
    } 

    translate([0,0,0]) {
        
        // magnets    
        rotate([0,90,45]) 
            for (i = [0 : (magnets-1)] )
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([-8.5, radius, 0])
                rotate([90,0,45]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=40, r1=1, r2=1);
                }
            }
            
                
        // magnets
        rotate([0,90,135]) 
            for (i = [0 : (magnets-1)] )
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([0.5, radius - 8, 0])
                rotate([90,0,135])  {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=40, r1=1, r2=1);
                }
            } 

    }  
}