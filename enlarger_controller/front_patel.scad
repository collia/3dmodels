plate_x = 73;
plate_y = 129;


module screen_hole() {
    translate([0,0,7.5/2])
        cube([60.5, 14.5, 7.5], center=true);
}
module plate() {
    plate_z = 4;
    translate([0,0, plate_z/2])
        minkowski() {
            cube([plate_x-3, plate_y-3, plate_z/2], center=true);
            cylinder(d1=3, d2=0, h=plate_z/4);
        }
}

module encoder_hole() {
    translate([0,0, 4/2])
        cylinder(h=6, d=7, center =true);
}


module button_hole() {
    translate([0,0, 12/2])
        cylinder(h=12, d=11.5, center =true);
}

module switch_hole() {
    translate([0,0, 8/2])
        cylinder(h=8, d=8.5, center =true);
}

difference() {
    $fn = 100;
    plate();
    translate([0, plate_y/2-30, 0])
        screen_hole();
    translate([plate_x/2 - 20, plate_y/2-50, 0])
        encoder_hole();
    translate([-plate_x/2 + 20, plate_y/2-50, 0])
        encoder_hole();
    translate([0, -plate_y/2+50, 0])
        encoder_hole();
    translate([plate_x/2-20, -plate_y/2+20, 0])
        button_hole();
    translate([-plate_x/2+20, -plate_y/2+20, 0])
        switch_hole();
}