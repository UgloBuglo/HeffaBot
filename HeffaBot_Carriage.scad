// Adapter for magnetic ball studs to be used on OpenBuilds 20mm Gantry Plates.
// Two adapters & four hole plugs are needed for each carriage.
//
// This work is licensed under a Creative Commons
// Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)
// Visit: http://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Håkan Berg
// hakan.berg.666@gmail.com

$fn = 360/4;

include <configuration.scad>;
use     <HeffaBot_Effector_Polystroooder.scad>;

smidge=0.075;


module smallPlug(){
    difference(){
        translate([0,0,0])
        cylinder(r=2.5-smidge, h=3);
        translate([0,0,-0.1])
        cylinder(r=m3_wide_radius, h=3.2);
    }
}


module largePlug(){
    difference(){
        translate([0,0,0])
        cylinder(r=3.6-smidge, h=3);
        translate([0,0,-0.1])
        cylinder(r=m3_wide_radius, h=3.2);
    }
}


module plugs(){
    translate([10,0,0])
    smallPlug();

    translate([-10,0,0])
    smallPlug();
}    
    

module adapter() {
    difference(){
        union(){
            translate([0, 1.5, 0])
            rotate([30, 0, 0])
            m3x8Base(); // from HeffaEffector_Polystroooder.scad
            
            hull(){
                translate([0,10,0])
                cylinder(r=5.3, h=1.5);

                translate([0,-10,0])
                cylinder(r=5.3, h=1.5);
            }
        }
        
        // cut away
        
        // hole for ball stud
        translate([0, 2, -0.5])
		rotate([30, 0, 0])
		m3x8BallStud(); // from HeffaEffector_Polystroooder.scad

        translate([0,10,-0.1])
        cylinder(r=m3_wide_radius, h=2);
        
        translate([0,-10,-0.1])
        cylinder(r=m3_wide_radius, h=2);

        // Remove everything below the base.
		translate([0, 0, -10])
		cylinder(r=10, h=10);

    }
}    


adapter();

plugs();
