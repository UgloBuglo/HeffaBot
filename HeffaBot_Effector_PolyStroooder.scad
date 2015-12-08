// Magnetic effector for HeffaBot delta printer.
//
// This work is licensed under a Creative Commons
// Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)
// Visit: http://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Builds on the work of Haydn Huntley
// haydn.huntley@gmail.com
// https://www.youmagine.com/designs/magnetic-effector-with-3-fans-and-led-light-ring-for-kossel-plus
//
// Additions and modifications for HeffaBot & PolyStroooder Tri Hotend by Håkan Berg
// hakan.berg.666@gmail.com

// Holds one PolyStroooder Tri Hotend using a groove mount.
// Print in nylon or other plastic with higher temperature tolerance

$fn = 360/4;
include <configuration.scad>;

// All measurements in mm.
insideBaseRadius        = 47.5 / 2;
baseHeight              = 4.2;
sides                   = 3;
ballStudBaseOffset		= 48.0 / 2;
lightRingOutsideDiameter= 60;
lightRingInsideDiameter = 51;
lightRingAverageRadius  = (lightRingOutsideDiameter+lightRingInsideDiameter)/4;
fanThickness            = 15.3+2*smidge;
fanLugThickness			=  3.25;
fanLugRadiusInner		=  5.2/2;
fanLugRadiusOuter		=  7.0/2;
fanLugOffset		    = 35.0;


module m3x8BallStud() 
{
	len = 8.0;

	// The screw shaft.
	translate([0, 0, 2-0.6*m3LockNutHeight])
	cylinder(r=m3LooseRadius, h=len+5, $fn=16);
	
	// The nylock nut trap.
	translate([0, 0, -1.4])
	rotate([0, 0, 30])
	cylinder(r1=m3LockNutRadius-1*smidge,
			 r2=m3LockNutRadius-3*smidge,
			 h=2+m3LockNutHeight, $fn=6);
}


module m3x8Base() 
{
	translate([0, 0, -3])
	cylinder(r1=(10+2)/2, r2=10/2, h=13.3);
}


module fanAttachment(positiveShape=true) 
{
	if (positiveShape) 
    {
		// The part to be added to the body.
		difference() 
        {
			// Fan attachment to body.
			hull() 
            {
				cylinder(r=fanLugRadiusOuter, h=fanThickness+2*fanLugThickness,
					     center=true);
				translate([0, -9, 0])
				cylinder(r=fanLugRadiusInner, h=fanThickness+2*fanLugThickness,
					     center=true);
			}
			hull() {
				// Gap for fan to fit in.
				cylinder(r=fanLugRadiusOuter+5*smidge, h=fanThickness,
						 center=true);
				translate([0, -9, 0])
				cylinder(r=fanLugRadiusInner+5*smidge, h=fanThickness,
						 center=true);
			}
			// Screw hole.
			translate([-abs(fanLugRadiusInner-fanLugRadiusOuter)/2, 0, 0])
			cylinder(r=m3LooseRadius, h=fanThickness+2*fanLugThickness+smidge,
				     center=true);
		}
	}
	else 
    {
		// The part to be subtracted from the body.
		// Gap for fan to fit in.
		translate([-abs(fanLugRadiusInner-fanLugRadiusOuter)/2, 0, 0])
		cylinder(r=fanLugRadiusOuter+5*smidge, h=fanThickness, center=true);
	}
}

//PolyStroooder Tri Hotend mount hole shape
module mountHole() 
{
    union() 
    {
        hull() 
        {
            for (a = [90:120:360]) 
            {
                rotate([0, 0, a])
                translate([11.5, 0, 0])
                square([1, 5], center=true);
            }
        }
     
        for (a = [10:120:360]) 
        {
            rotate([0, 0, a]) 
            {
                translate([0, 11.7, 0])
                circle(r=1, center=true, $fn=15);
            }
            rotate([0, 0, a-20]) {
                translate([0, 11.7, 0])
                circle(r=1, center=true, $fn=15);
            }
        }
    }
}

// hexagon shape for cable management
module hexagonHole() 
{
    hull()
    {
        for (a = [30:60:360]) 
        {
            rotate([0, 0, a]) 
            {
                translate([0, 5, 0])
                circle(r=1.5, center=true, $fn=15);
            }
        }
    }
}    
    

module effector_2d() 
{
    mount_radius    = 16;  // Hotend mounting screws

    difference() 
    {
        // basic effector shape
        circle(r=insideBaseRadius+1);

        // cut out the mount hole for hot-end 
        mountHole();

        // cut out holes for PolyStroooder mount clamp
        for (a = [30:60:360]) 
        {
            rotate([0, 0, a]) 
            {
                translate([0, mount_radius, 0])
                circle(r=m3_wide_radius, center=true, $fn=15);
            }
        }
        
        // cut out holes for mounting fans and other stuff
        for (a = [0:120:360]) 
        {
            rotate([0, 0, a]) 
            {
                translate([0, offset, 0])
                circle(r=m3_wide_radius, center=true, $fn=15);
            }
        }

        // cut out hexagon holes for cable management
        // (note that the whole hexagon will not be visible, it's
        //  a leftover from a previous version of the HeffaEffector)
        for (a = [60:120:360]) 
        {
            rotate([0, 0, a]) 
            {
                translate([0, offset, 0])
                hexagonHole();
            }
        }
    }
}


module effectorInside() 
{
    difference() 
    {
        translate([0,0,0])
        linear_extrude(height=baseHeight, center=false, convexity=10)
        effector_2d();
        
        // cut out space for hot end heat sink
        translate([0,0,2.5])
        cylinder(r=12.5+extra_radius, h=30);
    }
}


module effectorOutside() 
{
	difference() 
    {
		union() 
        {
			// The body.
			rotate_extrude(convexity=10)
			translate([lightRingAverageRadius, 0, 0])
			circle(r=2.5+(lightRingOutsideDiameter+10*smidge -
					  (lightRingInsideDiameter-10*smidge))/4);

			// Add a base for each M3x8 ball stud to sit on.
			for (i = [0:sides]) 
            {
				angle = i * 360/sides;
				rotate([0, 0, angle])
				{
					translate([ballJointSeparation/2, 0, 0])
					translate([0, ballStudBaseOffset, 0])
					rotate([-30, 0, 0])
					m3x8Base();

					translate([-ballJointSeparation/2, 0, 0])
					translate([0, ballStudBaseOffset, 0])
                    rotate([-30, 0, 0])
					m3x8Base();
				}
			}

			// Add a fan attachment in the middle of each side.
			for (i = [0:sides])
			{
                angle = i * 360/sides;
				rotate([0, 0, angle])
				translate([0, fanLugOffset,
							  min(fanLugRadiusInner, fanLugRadiusOuter)])
				rotate([0, 90, 0])
				fanAttachment(true);
			}
        }

		// Cut-away.

		// Remove everything below the base.
		translate([0, 0, -10])
		cylinder(r=2*lightRingAverageRadius, h=10);

		// M3 holes for attaching ball studs.
		for (i = [0:sides])
		{
            angle = i * 360/sides;
			rotate([0, 0, angle])
			{
				translate([ballJointSeparation/2, 0, 0])
				translate([0, ballStudBaseOffset, 0])
				rotate([-30, 0, 0])
				m3x8BallStud();

				translate([-ballJointSeparation/2, 0, 0])
				translate([0, ballStudBaseOffset, 0])
				rotate([-30, 0, 0])
				m3x8BallStud();
			}
		}

		// Hollow out fan attachments in the middle of each side.
		for (i = [0:sides])
		{
            angle = i * 360/sides;
			rotate([0, 0, angle])
			translate([0, fanLugOffset, 
					   min(fanLugRadiusInner, fanLugRadiusOuter)])
			rotate([0, 90, 0])
			fanAttachment(false);
            
		}

		// For adding an LED light ring underneath.
		scale([1, 1, 1.3])
		rotate_extrude(convexity=10)
		translate([lightRingAverageRadius, 0, 0])
		circle(r=(lightRingOutsideDiameter+10*smidge -
				  (lightRingInsideDiameter-10*smidge))/4);

		// For the leads to the LED light ring.
		for (i = [-7, 7])
			rotate([0, 0, 90+i])
			translate([lightRingOutsideDiameter/2, 0, 0])
			rotate([0, -25, 0])
			cylinder(r=1.5/2+4*smidge, h=2*baseHeight+2, $fn=16);
        
	}
}


module fanArm()
{
	difference()
	{
		// The body.
		hull()
		{
			translate([0, 0, fanLugRadiusOuter])
			rotate([0, 90, 0])
			cylinder(r=fanLugRadiusOuter,
					 h=fanThickness-5*smidge, center=true);

			translate([0, -4, fanLugRadiusOuter])
			rotate([90, 0, 0])
			scale([1.2, 1, 1])
			cylinder(r=fanLugRadiusOuter, h=20-fanThickness);
		}

		// A hole for the M3x25 bolt to hold it to the effector.
		translate([0, 0, fanLugRadiusOuter])
		rotate([0, 90, 0])
		cylinder(r=m3LooseRadius, h=fanThickness+smidge, center=true);

		// A hole for the M3x20 bolt which will attach the fan.
		translate([0, -m3LooseRadius/2-1, fanLugRadiusOuter])
		rotate([90, 0, 0])
		translate([0, 0, -1])
		cylinder(r=m3LooseRadius, h=21);

		// A hole to capture an M3 nut, for the M3x20 fan bolt.
		translate([0, -(m3LooseRadius+4), (2*fanLugRadiusOuter+smidge)/2])
		cube([5.5+3*smidge,
			  m3NutHeight+3*smidge,
			  2*fanLugRadiusOuter+smidge],
			 center=true);
	}
}


// Draw the effector.
union() 
{
	effectorOutside();

  effectorInside();
}


// Add the fan arms.
for (i = [0:3])
	rotate([0, 0, 60+i*120])
	translate([0, -43, 0])
	fanArm();
