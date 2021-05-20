include <../lib/threads.scad>

module lens_board() {
    width_1 = 139;
    height_1 = 4;
    width_2 = width_1 - 2*2;
    height_2 = 2;
    width_3 = width_2 - 2*4;
    
    central_d = 53;
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

module lens_connector() {
    central_d = 52;
    central_thread_step = 1;
    side_wall = 10;
    h = 12+4;
    difference() {
        hull() {
            cylinder(d = central_d + 2*side_wall, h = h);
            cylinder(d = 1.3*central_d + 4*side_wall, h = 4);
        }
        metric_thread (diameter=central_d, pitch=central_thread_step, length=h, internal=true, n_starts=1);
    }
}

union() {
    lens_board();
    lens_connector();
}