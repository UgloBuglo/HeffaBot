// Fan duct for the PolyStroooder Tri Hotend heatsink.
//
// This work is licensed under a Creative Commons
// Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)
// Visit: http://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Uses the fan_holder_v2.scad OPENSCAD Library file by DoomMeister
// http://www.thingiverse.com/thing:18273
//
// Additions and modifications for HeffaBot & PolyStroooder Tri Hotend by Håkan Berg
// hakan.berg.666@gmail.com
//
// Holds one 25mm fan to the PolyStroooder Tri Hotend heatsink.
// The fan duct is rather thin, so I'd recommend to print in a tough material, like Nylon or similar.
//
// 2016-03-08 Håkan berg
// - Added the option for adding a connection lug for a Blower Fan.
// - moved some generic parameters to configuration.scad

$fn = 360/4;
include <configuration.scad>;
use <fan_holder_v2.scad>;

fanSize         = 25;
heatSinkRadius  = 25/2;
fanDuctDepth    = 26;

addBlowerFanLugs        = true; // change this to false if blower fan lugs are not needed

// create fan lugs for a blower fan
module blowerFanLugs()
{
	difference() 
    {
        // Fan attachment to body.
		hull() 
        {
			cylinder(r=fanLugRadiusOuter, h=fanThickness+2*fanLugThickness, center=true);
            
            translate([0, -15, 0])
			cylinder(r=fanLugRadiusInner, h=fanThickness+2*fanLugThickness, center=true);
        }

		// Screw hole.
        cylinder(r=m3LooseRadius, h=fanThickness+2*fanLugThickness+smidge, center=true);
	}
}

// create the HeffaBot Fan Duct for PolyStroooder heatsink
difference()
{
    union()
    {
        difference()
        {
            // start with the basic cylinder shape
            translate([heatSinkRadius, heatSinkRadius, 0])
            rotate([0,0,0])
            cylinder(r=heatSinkRadius+2,h=25);
            
            // open up the cylinder at fan side
            translate([1, 25/2+2+smidge, 0])
            cube(size=[23,25/2,25], center=false);
        }

        // add fan duct
        translate([0, fanDuctDepth+4, 0])
        rotate([90, 0, 0])
        fan_mount(size=fanSize,thick=heatSinkRadius,cutter=true );
        
        // lugs to connect an external blower fan for plastic cooling to the fan duct
        if (addBlowerFanLugs)
            translate([heatSinkRadius, -11, fanSize-6])
            rotate([180, 90, 0])
            blowerFanLugs();
    
    }
    
    // cut out cylinder & blower fan lugs at outlet side
    translate([heatSinkRadius, -6, heatSinkRadius])
    cube(size=[15,20,27], center=true);
    
    // hollow out the zylinder for the heatsink
    translate([heatSinkRadius, heatSinkRadius, -1])
    rotate([0,0,0])
    cylinder(r=heatSinkRadius,h=30+(smidge*4));
    
    // holes for PolyStroooder mount clamp bolts
    translate([heatSinkRadius, heatSinkRadius, -smidge*3])
    for (a = [30:60:360]) 
    {
        rotate([0, 0, a])
        translate([0, mount_radius, 0])
        cylinder(r=5.7/2, h=3);
    }

}
