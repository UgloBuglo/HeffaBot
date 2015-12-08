// Increase this if your slicer or printer make holes too tight.
extra_radius        = 0.05;

// OD = outside diameter, corner to corner.
m3_nut_od           = 6.1;
m3_nut_radius       = m3_nut_od/2 + 0.2 + extra_radius;
m3_washer_radius    = 3.5 + extra_radius;

// Major diameter of metric 3mm thread.
m3_major            = 2.85;
m3_radius           = m3_major/2 + extra_radius;        // 1.625
m3_wide_radius      = m3_major/2 + extra_radius + 0.2;  // 1.675

offset              = 20;   // hexagon and mount hole offset

smidge              = 0.1;
mmPerInch			= 25.4;
m3Radius            = (3.0 + 0.2) / 2;  // 1.6
m3LooseRadius		= m3Radius + 0.2;   // 1.8
m3HeadHeight        = 3.0;
m3LooseHeadRadius   = (5.4 + 0.6) / 2;
m3NutRadius         = (6.25 + 0.75) / 2;
m3LooseNutRadius    = m3NutRadius + 0.2;
m3NutHeight			= 2.4;
m3LockNutRadius     = (6.25 + 0.75) / 2;
m3LockNutHeight     = 4.0;
m3SocketHeadDiameter= 5.5 + (extra_radius * 2);
m3SocketHeadRadius  = m3SocketHeadDiameter / 2;
//ballJointSeparation = 48.0;
ballJointSeparation = 39.7;
ballRadius			= (3/8 * mmPerInch)/2;
ballBaseRadius		= 10.0 / 2;
