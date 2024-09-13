include <../lib/threads.scad>

module graflex_container() {
    r=4;
    dia = 1.5;
    h=6;
    ext_xy = (120-2*r)/2;
    int_x = (95-2*r)/2;
    int_y = (94-2*r)/2;
    union() {
        difference() {
            linear_extrude(height = h, twist = 0) {
                difference() {
                    hull() {
                        translate([ext_xy, ext_xy,0]) circle(r=r);
                        translate([ext_xy, -ext_xy,0]) circle(r=r);
                        translate([-ext_xy, ext_xy,0]) circle(r=r);
                        translate([-ext_xy, -ext_xy,0]) circle(r=r);
                    }
                    hull() {
                        translate([int_x, int_y,0]) circle(r=r);
                        translate([int_x, -int_y,0]) circle(r=r);
                        translate([-int_x, int_y,0]) circle(r=r);
                        translate([-int_x, -int_y,0]) circle(r=r);
                    }
                }
            }
            translate([-15, (int_x+ext_xy)/2+r, h/2])
                cylinder(d=dia, h=h/2);
            translate([15, (int_x+ext_xy)/2 +r, h/2])
                cylinder(d=dia, h=h/2);
            
        }
    translate([0, -int_y-r, h])
        holder_low();
    }
}

module holder_low() {
    translate([0, 0, 0.75])
    minkowski() {
        cube([70 - 2*3, 24 - 2*2, 1.5], center=true);
        cylinder(h=1.5, r2 = 0, r1=2);
    }
}
module holder_high_hole() {
    d=3.5;
    linear_extrude(height = 5, twist = 0){
        hull() {
            translate([0, (20-6.75)/2, 0]) circle(d=d);
            translate([-10, -(20-6.75)/2, 0]) circle(d=d);
        }
    }
}
module holder_high() {
    difference() {
        holder_low();
        translate([-15, 0, 0])
            holder_high_hole();
        translate([15, 0, 0])
            holder_high_hole();
    }
}

module lens_board(central_d) {
    width_1 = 140;
    height_1 = 4;
    width_2 = width_1 - 2*2;
    height_2 = 2;
    width_3 = width_2 - 2*4;
    //central_d = 65.8;
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

module convector() {
    union() {
        rotate([180, 0, 0])
            lens_board(80);
        graflex_container();
    }
}

$fn= 200;
//$fa = 100;
//lens_board(80);
//graflex_container();
//holder_low();
holder_high();
//convector();