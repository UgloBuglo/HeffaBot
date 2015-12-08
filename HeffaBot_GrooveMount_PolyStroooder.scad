// Groove mount clamp for PolyStroooder Tri Hotend, for HeffaBot delta printer.
//
// This work is licensed under a Creative Commons
// Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)
// Visit: http://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Håkan Berg
// hakan.berg.666@gmail.com

// Holds one PolyStroooder Tri Hotend using the groove mount.
// Print in nylon or other plastic with higher temperature tolerance

include <configuration.scad>;
use     <HeffaBot_Effector_PolyStroooder.scad>;

$fn = 360/4;
lightRingOutsideDiameter= 60;
lightRingInsideDiameter = 51;
lightRingAverageRadius  = (lightRingOutsideDiameter+lightRingInsideDiameter)/4;
smidge                  = 0.1;
grooveMountThickness    = 3-smidge;
grooveMountRadius       = 17/2;
mount_radius            = 16;  // Hotend mounting screws
minkowskiCircleRadius   = 0.75;

module grooveMount()
{
    linear_extrude(height=grooveMountThickness, center=false, convexity=10)
    // round off all edges
    minkowski() 
    {
        difference() 
        {
            union() 
            {
                // start with a basic circle
                circle(r=20-minkowskiCircleRadius);
                
                translate([0,20,0])
                circle(r=3.2-minkowskiCircleRadius);
            }
            
            // Cut-outs
            
            // holes for PolyStroooder mount clamp
            for (a = [30:60:360]) 
            {
                rotate([0, 0, a])
                translate([0, mount_radius, 0])
                circle(r=m3_wide_radius+minkowskiCircleRadius, center=true, $fn=15);
            
            }
            
            // hole for hotend
            circle(r=grooveMountRadius+minkowskiCircleRadius+smidge);
            
            // hole in clamp end
            translate([0,20,0])
            circle(r=m3_wide_radius+minkowskiCircleRadius);
            
            // holes for mounting fans and other stuff
            for (a = [120:120:240]) 
            {
                rotate([0, 0, a]) {
                    translate([0, offset, 0])
                    circle(r=m3SocketHeadRadius+minkowskiCircleRadius+smidge, center=true);
                }
            }

            // split the mounting clamp
            hull() 
            {
                translate([0,offset,0])
                circle(r=1.5);
                
                translate([0,-lightRingOutsideDiameter/2,0])
                circle(r=1.5);
            }
            
            // hexagon holes for cable management
            // (note that the whole hexagon will not be visible, it's
            //  a leftover from a previous version of the HeffaBot Effector)
            for (a = [60:120:360]) 
            {
                rotate([0, 0, a]) 
                {
                    minkowski() 
                    {
                        translate([0, 20, 0])
                        hexagonHole(); // from HeffaBot_Effector_Polystroooder.scad
                    
                        circle(r=minkowskiCircleRadius);
                    }
                }
            }
        }
        
        // the minkowski sum
        circle(r=minkowskiCircleRadius);
    }
}

// generate the mount clamp
grooveMount();
