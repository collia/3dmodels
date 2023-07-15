include <../lib/threads.scad>

// Main config
external_board_w = 139;
external_board_h = 3.9;
shutter_w = 104;
shutter_h = 8+2;
main_h = 20;

module lens_board_base() {
    width_1 = external_board_w;
    height_1 = external_board_h;
    width_2 = width_1 - 2*2;
    height_2 = 2.6;
    width_3 = width_2 - 2*3;
 
    union() {
        difference() {
            translate([0,0, height_1/2])
                cube([width_1, width_1, height_1], center = true);
            translate([0,0, height_1 - height_2/2])
                cube([width_2, width_2, height_2], center = true);
        }
        translate([0,0, height_1/2])
            cube([width_3, width_3, height_1], center = true);
    }
}

module lens_board() {
    width = external_board_w - 5*2;
    r = width*2.5;
    h_max = main_h;
    union() {
        intersection() {
            translate([0,0, -h_max/2 + external_board_h])
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
    w2  = 6;
    thread_hole_h = 12;
    flash_sync_hole_d1 = 5.3;
    flash_sync_hole_d2 = 8;
    flash_sync_h1 = 10;
    union() {
        translate([0, 0, -shutter_h/2+external_board_h])
            cube([w, w, shutter_h], center=true);
        translate([w/2+w2/2, 0, -shutter_h/2+external_board_h])
            cube([w2, w-2*15, shutter_h], center=true);
        translate([w/2+w2/2, w/2-15-10, -shutter_h]) {
            union() {
                cylinder(d=flash_sync_hole_d1, h = flash_sync_h1, center=true);
                translate([0, 0, -4])
                    cylinder(d=flash_sync_hole_d2, h = flash_sync_h1, center=true);
                translate([0, 0, -4-3])
                    cylinder(d=flash_sync_hole_d2*3, h = flash_sync_h1, center=true);
            }
        }
        translate([w/2 - 6, w/2 - 5.5, -shutter_h/2])
            cylinder(d=2, h = thread_hole_h, center=true);
        translate([-(w/2 - 6), (w/2 - 5.5), -shutter_h/2])
            cylinder(d=2, h = thread_hole_h, center=true);
        translate([(w/2 - 6), -(w/2 - 5.5), -shutter_h/2])
            cylinder(d=2, h = thread_hole_h,center=true);
        translate([-(w/2 - 6), -(w/2 - 5.5), -shutter_h/2])
            cylinder(d=2, h = thread_hole_h, center=true);
    }
}

module lens_board_thread() {
    dia = 80;
    h = main_h - external_board_h;
    difference() {
        translate([0,0, -h - external_board_h]) {
            scale([1.01, 1.01, 1])
                metric_thread (diameter=dia, pitch=3, length=h, internal=true, n_starts=1, square=true);
            translate([0,0, 5])
                cylinder(d1 = dia + 5, d2 = dia - 5, h = 5, center=true);
            translate([0,0, h-2])
                cylinder(d1 = dia - 5, d2 = dia + 5, h = 5, center=true);
        }
    }
}

module lens_nut_thread() {
    dia = 80;
    h = main_h - shutter_h;
    difference() {
        scale([0.99, 0.99, 1])
            metric_thread (diameter=dia, pitch=3, length=h, internal=false, n_starts=1, square=true);
        translate([0, 0, h - 5])
            difference() {
                cylinder(d = dia+5, h=5);
                cylinder(d2 = dia-5, d1 = dia + 5, h=5);
            }
    }
}

module lens_bord_air_pump_hole() {
    h = main_h;
    w = shutter_w;
    d = 6;
    translate([-w/2-d/2-1, 0, -h/2+external_board_h]){
        union() {
            cylinder(d=d, h=h, center=true);
            translate([0, 0, -h/2+5])
                cylinder(d=8, h = 10, center=true);
            translate([0, 0, h/2-1])
                cube([9,9,5], center=true);
        }
    }
}

module packard_shutter_pin() {
    d = 3;
    h = main_h;
    translate([shutter_w/2 - 12, -(shutter_w/2 - 25), -h/2]){
        union() {
            cylinder(h = h, d = d, center = true);
            translate([0, 0, -h/2])
                cylinder(d=14, h = 10);
            translate([0, 4.5, 0])
                cylinder(h = h-4, d = 1.5, center = true);
            translate([0, -4.5, 0])
                cylinder(h = h-4, d = 1.5, center = true);
        }
    }
}

module packard_shutter_pin_nut() {
    d = 3;
    h = main_h;
    translate([shutter_w/2 - 12, -(shutter_w/2 - 25), -h/2]){
        difference() {
            
            cylinder(d=13.5, h = 3.5);
            cylinder(h = h, d = d, center = true);
            translate([0, 4.5, 0])
                cylinder(h = h-4, d = 1.5, center = true);
            translate([0, -4.5, 0])
                cylinder(h = h-4, d = 1.5, center = true);
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

module lens_nut_42() {
    lens_thread_d = 42.2; // 42.2 - 41.7
    lens_thread_h = 8;
    lens_thread_step = 2/3;//2mm/4 lines
    lens_thread_offset = 8;
    lens_barrel_d = 41;
    side_wall = 6;
    extenal_d = 84;

    big_thread_h = main_h - shutter_h;
    total_h = lens_thread_offset + lens_thread_h;
    handle_h = total_h - big_thread_h;
    difference() {
    union() {
        difference() {
            cylinder(d = extenal_d, h = handle_h);
            scale([1.01, 1.01, 1.0])
                metric_thread (diameter=lens_thread_d,
                               pitch=lens_thread_step,
                               length=lens_thread_h,
                               internal=true, n_starts=1);
            translate([0,0,0]) {
                cylinder(d1 = lens_thread_d + 2, d2 = lens_thread_d - 2, h = 2);
            }
            for (i=[0:64])
                rotate([0, 0, i*(360/64)])
                    translate([extenal_d/2,0,0])
                        cylinder(d = side_wall/2, h = handle_h);
        }
        translate([0, 0, handle_h-0.1])
            lens_nut_thread();
    }
    cylinder(d = lens_barrel_d, h = total_h);
    }
}


module lens_nut_52() {
    lens_thread_d = 52;
    lens_thread_h = 8;
    lens_thread_step = 1;
    lens_thread_offset = 8;
    lens_barrel_d = 52;
    side_wall = 6;
    extenal_d = 84;

    big_thread_h = main_h - shutter_h;
    total_h = lens_thread_offset + lens_thread_h;
    handle_h = total_h - big_thread_h;
    difference() {
    union() {
        difference() {
            cylinder(d = extenal_d, h = handle_h);
            scale([1.01, 1.01, 1.0])
                metric_thread (diameter=lens_thread_d,
                               pitch=lens_thread_step,
                               length=lens_thread_h,
                               internal=true, n_starts=1);
            translate([0,0,0]) {
                cylinder(d1 = lens_thread_d + 2, d2 = lens_thread_d - 2, h = 2);
            }
            for (i=[0:64])
                rotate([0, 0, i*(360/64)])
                    translate([extenal_d/2,0,0])
                        cylinder(d = side_wall/2, h = handle_h);
        }
        translate([0, 0, handle_h-0.1])
            lens_nut_thread();
    }
    cylinder(d = lens_barrel_d, h = total_h);
    }
}

module lens_nut_63() {
    lens_thread_d = 63;
    lens_thread_h = 23;
    lens_thread_step = 1;
    lens_thread_offset = 23;
    lens_barrel_d = 63;
    side_wall = 6;
    extenal_d = 84;

    big_thread_h = main_h - shutter_h;
    total_h = lens_thread_offset + lens_thread_h;
    handle_h = total_h - big_thread_h;
    difference() {
    union() {
        difference() {
            cylinder(d = extenal_d, h = handle_h);
            scale([1.02, 1.02, 1.0])
                metric_thread (diameter=lens_thread_d,
                               pitch=lens_thread_step,
                               length=lens_thread_h,
                               internal=true, n_starts=1);
            translate([0,0,0]) {
                cylinder(d1 = lens_thread_d + 2, d2 = lens_thread_d - 2, h = 2);
            }
            for (i=[0:64])
                rotate([0, 0, i*(360/64)])
                    translate([extenal_d/2,0,0])
                        cylinder(d = side_wall/2, h = handle_h);
        }
        translate([0, 0, handle_h-0.1])
            lens_nut_thread();
    }
    cylinder(d = lens_barrel_d, h = total_h);
    }
}

module lens_nut_72() {
    lens_thread_d = 72;
    lens_thread_h = 10;
    lens_thread_step = 1;
    lens_thread_offset = 15;
    lens_barrel_d = 70;
    side_wall = 6;
    extenal_d = 84;

    big_thread_h = main_h - shutter_h;
    total_h = lens_thread_offset + lens_thread_h;
    handle_h = total_h - big_thread_h;
    difference() {
    union() {
        difference() {
            cylinder(d = extenal_d, h = handle_h);
            scale([1.01, 1.01, 1.0])
                metric_thread (diameter=lens_thread_d,
                               pitch=lens_thread_step,
                               length=lens_thread_h,
                               internal=true, n_starts=1);
            translate([0,0,0]) {
                cylinder(d1 = lens_thread_d + 2, d2 = lens_thread_d - 2, h = 2);
            }
            for (i=[0:64])
                rotate([0, 0, i*(360/64)])
                    translate([extenal_d/2,0,0])
                        cylinder(d = side_wall/2, h = handle_h);
        }
        translate([0, 0, handle_h-0.1])
            lens_nut_thread();
    }
    cylinder(d = lens_barrel_d, h = total_h);
    }
}

module rair_cup () {
    extenal_d = 85;
    handle_h = 16;
    side_wall = 6;

    difference() {
        translate([0,0, -handle_h-1]) {
            cylinder(d = extenal_d, h = handle_h);
            for (i=[0:64])
                rotate([0, 0, i*(360/64)])
                    translate([extenal_d/2,0,0])
                        cylinder(d = side_wall/2, h = handle_h);
        }
        #lens_board_thread();

    }
}


$fn= 200;

main_board();
//lens_nut_42();
//lens_nut_52();
//lens_nut_63();
//lens_nut_72();
//rair_cup();
//packard_shutter_pin_nut();
//packard_shuter_container();