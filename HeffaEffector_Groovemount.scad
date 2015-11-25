include <configuration.scad>;
use     <HeffaEffector_Polystroooder_v4.scad>;

$fn = 360/4;
lightRingOutsideDiameter= 60;
lightRingInsideDiameter = 51;
lightRingAverageRadius  = (lightRingOutsideDiameter+lightRingInsideDiameter)/4;
smidge                  = 0.1;
grooveMountThickness    = 3;
grooveMountRadius       = 17/2;
mount_radius    = 16;  // Hotend mounting screws
minkowskiCircleRadius   = 0.75;


module doughnut()
{
    rotate_extrude(convexity=10)
	translate([lightRingAverageRadius, 0, 0])
	circle(r=2.5+(lightRingOutsideDiameter+10*smidge -
                 (lightRingInsideDiameter-10*smidge))/4);
}

module grooveMount()
{
    linear_extrude(height=grooveMountThickness, center=false, convexity=10)
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
            
            // cut out holes for PolyStroooder mount clamp
            for (a = [30:60:360]) {
                rotate([0, 0, a])
                translate([0, mount_radius, 0])
                circle(r=m3_wide_radius+minkowskiCircleRadius, center=true, $fn=15);
            
            }
            
            // cut out hole for hotend
            circle(r=grooveMountRadius+minkowskiCircleRadius);
            
            // cut out hole in clamp end
            translate([0,20,0])
            circle(r=m3_wide_radius+minkowskiCircleRadius);

            // split the mounting clamp
            hull()
            {
                translate([0,offset,0])
                circle(r=1.5);
                
                translate([0,-lightRingOutsideDiameter/2,0])
                circle(r=1.5);
            }
            
        // cut out hexagon holes for cable management
        // (note that the whole hexagon will not be visible, it's
        //  a leftover from a previous version of the HeffaEffector)
        for (a = [60:120:360]) {
            rotate([0, 0, a]) {
                minkowski()
                {
                    translate([0, 20, 0])
                    hexagonHole();
                    
                    circle(r=minkowskiCircleRadius);
                }
            }
        }
        }
        
        // the minkowski sum
        circle(r=minkowskiCircleRadius);
    }
}

grooveMount();
