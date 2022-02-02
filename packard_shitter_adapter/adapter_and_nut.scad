include <../lib/threads.scad>

// Main config
external_board_w = 139;
external_board_h = 3;
shutter_w = 103;
shutter_h = 9;
main_h = 20;

module lens_board_base() {
    width_1 = external_board_w;
    height_1 = external_board_h;
    width_2 = width_1 - 2*2;
    height_2 = 2;
    width_3 = width_2 - 2*4;
 
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
}

module lens_board() {
    width = external_board_w - 5*2;
    r = width*1.7;
    h_max = main_h;
    union() {
        intersection() {
            translate([0,0, -h_max/2 + 4])
                cube([width, width, h_max], center=true);
            translate([0, 0, r - h_max ]){
                sphere(r = r);
            }
        }
        lens_board_base();
    }
}

module packard_shuter_container() {
    w = shutter_w;
    w2  = 5;
    union() {
        cube([w, w, shutter_h], center=true);
        translate([w/2+w2/2, 0, 0])
            cube([w2, w-2*15, shutter_h], center=true);
    }
}

module lens_board_thread() {
    dia = 85;
    h = main_h - external_board_h;
    //difference() {
    //    cylinder(d = dia + 2*4, h = h, $fn=8);
    translate([0,0, -h - external_board_h])
        metric_thread (diameter=dia, pitch=4, length=h, internal=true, n_starts=1, square=true);
    //}
}

module lens_nut_thread() {
    dia = 85;
    h = main_h - external_board_h;
    metric_thread (diameter=dia, pitch=4, length=h, internal=false, n_starts=1, square=true);
}

module lens_bord_air_pump_hole() {
    h = main_h;
    w = shutter_w;
    translate([-w/2-5/2-1, 0, -h/2+external_board_h]){
        union() {
            cylinder(d=5, h=h, center=true);
            translate([0, 0, -h/2+5])
                cylinder(d=8, h = 10, center=true);
            translate([0, 0, h/2-1])
                cube([7,7,4], center=true);
        }
    }
}

module packard_shutter_pin() {
    d = 3;
    h = main_h;
    translate([shutter_w/2 - 5, -(shutter_w/2 - 25), -h/2]){
        union() {
            cylinder(h = h, d = d, center = true);
            translate([0, 0, -h/2])
                cylinder(d=14, h = 15);
        }
    }
}

module main_board() {
    difference() {
        lens_board();
        packard_shuter_container();
        lens_board_thread();
        packard_shutter_pin();
        lens_bord_air_pump_hole();
    }
}

module lens_nut_52() {
    central_d = 52;
    central_thread_step = 0.75;
    side_wall = 10;
    h = 7;
    big_thread_h = main_h - external_board_h;
    union() {
        difference() {
            cylinder(d = central_d + 2*side_wall, h = h, $fn=8);
            metric_thread (diameter=central_d, pitch=central_thread_step, length=h, internal=true, n_starts=1);
        }
        translate([0, 0, -big_thread_h]) {
            difference() {
                lens_nut_thread();
                cylinder(h=big_thread_h, d2 = central_d + 5, d1 = central_d+10);
            }
        }
    }
}


module lens_nut_72() {
    central_d = 72;
    central_thread_step = 0.75;
    side_wall = 10;
    h = 7;
    big_thread_h = main_h - external_board_h;
    union() {
        difference() {
            cylinder(d = central_d + 2*side_wall, h = h, $fn=8);
            metric_thread (diameter=central_d, pitch=central_thread_step, length=h, internal=true, n_starts=1);
        }
        translate([0, 0, -big_thread_h]) {
            difference() {
                lens_nut_thread();
                cylinder(h=big_thread_h, d2 = central_d + 5, d1 =central_d + 5);
            }
        }
    }
}

$fn= 200;
//$fa = 100;

//main_board();
//lens_nut_52();
lens_nut_72();