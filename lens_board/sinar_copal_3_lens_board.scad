include <../lib/threads.scad>

module lens_board() {
    width_1 = 140;
    height_1 = 4;
    width_2 = width_1 - 2*2;
    height_2 = 2;
    width_3 = width_2 - 2*4;
    central_d = 65.8;
    difference() {
        union() {
            difference() {
                translate([0,0, height_1/2])
                    cube([width_1, width_1, height_1], center = true);
                translate([0,0, height_1 - (height_1 - height_2)/2])
                    cube([width_2, width_2, height_1 - height_2], center = true);
            }
            translate([0,0, height_1/2])
                cube([width_3, width_3, height_1], center = true);
        }
        cylinder(d=central_d, h=height_1);
    }
}


$fn= 100;
//$fa = 100;
lens_board();

