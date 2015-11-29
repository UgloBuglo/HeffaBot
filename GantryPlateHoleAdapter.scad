$fn = 360/4;

include <configuration.scad>;

smidge=0.075;


module smallPlug(){
    difference(){
        translate([0,0,0])
        cylinder(r=2.5-smidge, h=3);
        translate([0,0,-0.1])
        cylinder(r=1.5+smidge, h=3.2);
    }
}


module largePlug(){
    difference(){
        translate([0,0,0])
        cylinder(r=3.6-smidge, h=3);
        translate([0,0,-0.1])
        cylinder(r=1.5+smidge, h=3.2);
    }
}


module plugs(){
    translate([10,0,0])
    smallPlug();

    translate([-10,0,0])
    smallPlug();
}    
    

module m3x8BallStud()
{
	len = 8.0;

	// The screw shaft.
	translate([0, 0, 2-0.6*m3LockNutHeight])
	cylinder(r=m3LooseRadius, h=len+3, $fn=16);
	
	// The nylock nut trap.
	translate([0, 0, -1.4])
	rotate([0, 0, 30])
	cylinder(r1=m3LockNutRadius-1*smidge,
			 r2=m3LockNutRadius-3*smidge,
			 h=2+m3LockNutHeight, $fn=6);
}


module m3x8Base(){
	translate([0, 0, -5])
	cylinder(r1=(10+2)/2, r2=10/2, h=13.3);
}


module adapter() {
    difference(){
        union(){
            translate([0, 0, 0])
            rotate([30, 0, 0])
            m3x8Base();
            
            hull(){
                translate([0,10,0])
                cylinder(r=2.5-smidge, h=1.5);

                translate([0,-10,0])
                cylinder(r=2.5-smidge, h=1.5);
            }
        }
        
        translate([0, 0, 0])
		rotate([30, 0, 0])
		m3x8BallStud();

        translate([0,10,-0.1])
        cylinder(r=1.5+smidge, h=3.2);
        
        translate([0,-10,-0.1])
        cylinder(r=1.5+smidge, h=3.2);

        // Remove everything below the base.
		translate([0, 0, -10])
		cylinder(r=10, h=10);

    }
}    


adapter();

plugs();
