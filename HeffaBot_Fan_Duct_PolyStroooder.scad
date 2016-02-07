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

$fn = 360/4;
use <fan_holder_v2.scad>;

fanSize         = 25;
smidge          = 0.1;
heatSinkRadius  = 25/2;
fanDuctDepth    = 26;
mount_radius    = 16;  // Hotend mounting screws

difference()
{
    union()
    {
        translate([0, fanDuctDepth+4, 0])
        rotate([90, 0, 0])
        fan_mount(size=fanSize,thick=heatSinkRadius,cutter=true );
    
        difference()
        {
            translate([heatSinkRadius, heatSinkRadius, 0])
            rotate([0,0,0])
            cylinder(r=heatSinkRadius+2,h=25);
            
            translate([1, 25/2+2+smidge, 0])
            cube(size=[23,25/2,25], center=false);
        }
    }
    
    translate([heatSinkRadius, -3, heatSinkRadius])
    cube(size=[15,20,27], center=true);
        
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
