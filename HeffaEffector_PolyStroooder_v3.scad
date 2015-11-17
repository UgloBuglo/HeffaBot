include <configuration_v3.scad>;

separation      = 39.7;  // Distance between ball joint mounting faces.
offset          = 20;  // Same as DELTA_EFFECTOR_OFFSET in Marlin.
mount_radius    = 16;  // Hotend mounting screws, standard would be 25mm.
thickness       = 3;
smidge          = 0.1;

module mountHole() {

    union() {
        
        hull()
        for (a = [90:120:360]) 
        rotate([0, 0, a])
        translate([11.5, 0, 0])
        square([1, 5], center=true);
     
        for (a = [10:120:360]) {
            rotate([0, 0, a]) {
                translate([0, 11.5, 0])
                circle(r=1, center=true, $fn=10);
            }
            rotate([0, 0, a-20]) {
                translate([0, 11.5, 0])
                circle(r=1, center=true, $fn=10);
            }
        }
    }
}


module effector_2d() {
    
    difference() {
        // basic effector shape
        minkowski() {
            hull()
            for (a = [60:120:360]) {
                rotate([0, 0, a+30])
                translate([offset-6, 0, 0])
                square([9, separation-1],center=true);
            }

            circle(r=5, $fn=25);
        }

        // cut out the mount hole for hot-end 
        mountHole();

        // cut out holes for magnetics balls
        for (a = [60:120:360]) {
            rotate([0, 0, a+30])
            translate([offset, 0, 0]) {
                
                translate([0, separation/2, 0])
                circle(r=m3_wide_radius, center=true, $fn=15);

                translate([0, -separation/2, 0])
                circle(r=m3_wide_radius, center=true, $fn=15);
            }
        }
        
        // cut out holes for PolyStroooder mount clamp
        for (a = [30:60:360]) {
            rotate([0, 0, a]) {
                translate([0, mount_radius, 0])
                circle(r=m3_wide_radius, center=true, $fn=15);
            }
        }


    }
    
}


module effector_3d() {
    difference() {
        translate([0,0,0])
        linear_extrude(height=thickness, center=false, convexity=10)
        effector_2d();
        
        // cut out space for hot end
        translate([0,0,2])
        cylinder(r=12.5, height=1+smidge);
    }
}
    

// generate the effector
translate([0,0,0])
effector_3d();
