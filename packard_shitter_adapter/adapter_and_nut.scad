include <../lib/threads.scad>

module lens_board_base() {
    width_1 = 140;
    height_1 = 4;
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
    h_max = 20;
    width = 140 - 5*2;
    r = width*1.7;
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
    w = 113;
    w2  = 5;
    union() {
        cube([w, w, 8], center=true);
        translate([w/2+w2/2, 0, 0])
            cube([w2, w-2*15, 8], center=true);
    }
}

module lens_board_nut() {
    dia = 72;
    h = 20 - 4;
    //difference() {
    //    cylinder(d = dia + 2*4, h = h, $fn=8);
    translate([0,0, -h - 4])
        metric_thread (diameter=dia, pitch=4, length=h, internal=true, n_starts=1, square=true);
    //}

}

module lens_bord_air_pump_hole() {
    h = 20;
    w = 113;
    translate([-w/2-5/2-1, 0, -h/2+4]){
        union() {
            #cylinder(d=5, h=h, center=true);
            translate([0, 0, -h/2])
                #cylinder(d=8, h = 10);
        }
    }
}

module packard_shutter_pin() {
    d = 2;
    h = 20;
    translate([113/2 - 5, 113/2 - 25, -4]){
        union() {
            #cylinder(h = h, d = d, center = true);
            translate([0, 0, -h/2])
                #cylinder(d=13, h = 8);
        }
    }
}

$fn= 200;
//$fa = 100;

difference() {
    lens_board();
    packard_shuter_container();
    lens_board_nut();
    packard_shutter_pin();
    lens_bord_air_pump_hole();
}


