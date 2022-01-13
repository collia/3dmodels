include <../lib/threads.scad>

module lens_board() {
    width_1 = 139;
    height_1 = 4;
    width_2 = width_1 - 2*2;
    height_2 = 2;
    width_3 = width_2 - 2*4;
    dia_1 = 110;
    central_d = 52.5;
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

module lens_nut() {
    central_d = 52;
    central_thread_step = 0.75;
    side_wall = 10;
    h = 7;
    difference() {
        difference() {
            cylinder(d = central_d + 2*side_wall, h = h, $fn=8);
            metric_thread (diameter=central_d, pitch=central_thread_step, length=h, internal=true, n_starts=1);
        }
        cylinder(d1 = central_d + 3, d2=0, h = h);
        cylinder(d2 = central_d + 3, d1=0, h = h);
    }
}

$fn= 500;
//$fa = 100;
lens_board();
//scale([1.02, 1.02, 1.02]) //needed for PLA+
//    lens_nut();
