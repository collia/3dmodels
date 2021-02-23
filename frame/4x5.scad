
side = 200;
ext_side = 210;
int_size = 130;
height_bottom = 10;
height_top = 6;


module film_holder() {
    // standart film holder size
    // https://www.pinterest.co.uk/pin/392024342563219543/visual-search/?x=10&y=10&w=530&h=453&cropSource=6
    x_1 = 122;
    y_1 = 173.0;
    
    y_2 = 160;
    z_1 = 14.5;
    z_2 = 11.8;
    
    y_3_w = 2.5;
    y_3 = 138.5;
    z_3 = 1.3+z_2;

    x_c = 110;
    y_c = 121.5;
    z_c = z_2 + 20;
    
    x_c_offs = (x_1 - x_c) / 2;
    y_c_offs = 15.8;

    translate([x_1/2, -(y_c/2+y_c_offs), z_1])
    rotate([0,180,0])
    union() {
        translate([0, y_2, 0])
            cube([x_1, y_1-y_2, z_1]);
        cube([x_1, y_2, z_2]);
        translate([0, y_3, 0])
            cube([x_1, y_3_w, z_3]);
        translate([x_c_offs, y_c_offs, 0])
            cube([x_c, y_c, z_c]);
    }
} 


module top_connector_hole() {
    hole_dia = 1.5;
    hole_h = 15;
    hole_offset_w = 15;
    hole_offset_h = height_top/2;

    translate([-ext_side/2, ext_side/2 - hole_offset_w - hole_dia/2, -hole_offset_h])
        rotate([0,90,0])
            cylinder(d = hole_dia, h = hole_h, $fn=20);

    translate([-ext_side/2, -ext_side/2 + hole_offset_w + hole_dia/2, -hole_offset_h])
        rotate([0,90,0])
            cylinder(d = hole_dia, h = hole_h, $fn=20);
}

module top_connector_holes() {
    top_connector_hole();
    rotate([0, 0, -90])
        top_connector_hole();
}
module bottom_connector_holes() {
    hole_w = 10;
    hole_h = 3;
    hole_d = 10 + (ext_side-side)/2;
    hole_offset_w = 7;

    translate([ext_side/2-hole_d/2, side/2 - hole_offset_w - hole_w/2, -height_top+hole_h/2])
        cube([hole_d, hole_w, hole_h], center = true);
    translate([ext_side/2-hole_d/2, -side/2 + hole_offset_w + hole_w/2, -height_top+hole_h/2])
        cube([hole_d, hole_w, hole_h], center = true);
    rotate([0,0,-90]) {
        translate([ext_side/2-hole_d/2, side/2 - hole_offset_w - hole_w/2, -height_top+hole_h/2])
            cube([hole_d, hole_w, hole_h], center = true);
        translate([ext_side/2-hole_d/2, -side/2 + hole_offset_w + hole_w/2, -height_top +hole_h/2])
            cube([hole_d, hole_w, hole_h], center = true);
    }
}

module screw() {
    d = 3;
    d_thread = 2.38;
    translate([0, 0, -height_top])
        cylinder(d=d+0.5, h = height_top, $fn=30);
    translate([0, 0, -height_top-height_bottom])
        cylinder(d=d_thread, h = height_bottom, $fn=30);
}

module screws() {
    offset_y = (side-50)/3;
    translate([side/2-15, offset_y*3/2 ,0])
        screw();
    translate([side/2-15, offset_y/2 ,0])
        screw();
    translate([side/2-15, -offset_y*3/2 ,0])
        screw();
    translate([side/2-15, -offset_y/2 ,0])
        screw();
    translate([-(side/2-15), offset_y*3/2 ,0])
        screw();
    translate([-(side/2-15), offset_y/2 ,0])
        screw();
    translate([-(side/2-15), -offset_y*3/2 ,0])
        screw();
    translate([-(side/2-15), -offset_y/2 ,0])
        screw();
}
module frame() {
    film_h_x = 150;
    film_h_y = 180;
    film_h_z = 12;
    
    translate([0,0, -height_top])
    union() {
        translate([0, 0, height_top/2])
            cube([ext_side, ext_side, height_top], center=true);
        translate([0, 0, -height_bottom/2])
            difference() {
                cube([side, side, height_bottom], center=true);
                cube([int_size, int_size, height_bottom], center=true);
            }
        translate([0, 0, film_h_z/2 + height_top/2])
           cube([film_h_x, film_h_y, film_h_z], center=true);
    }
    
}

module frame_with_film_holder_container() {
    difference() {
        frame();
        film_holder();
        bottom_connector_holes();
        top_connector_holes();
        screws();
    }
}

module print_part_1_mask() {
    translate([0,0,10 - height_top])
        cube([160, 180, 20], center=true);
}

module print_part_2_mask(direction_y) {
    translate([0,side/4*direction_y, -height_top - height_bottom/2-0.1])
        cube([side, side/2, height_bottom+0.1], center=true);
}

module print_part_3_mask(direction_x, direction_y) {
    difference() {
        translate([ext_side/4*direction_x, ext_side/4*direction_y, -height_top/2])
            cube([ext_side/2, ext_side/2, height_top], center=true);
        print_part_1_mask();
    }
}



module print_part_1() {
    intersection() {
        print_part_1_mask();
        frame_with_film_holder_container();
    }
}

module print_part_2_1() {
    intersection() {
        print_part_2_mask(1);
        frame_with_film_holder_container();
    }
}

module print_part_2_2() {
    intersection() {
        print_part_2_mask(-1);
        frame_with_film_holder_container();
    }
}

module print_part_3_1() {
    intersection() {
        print_part_3_mask(1, 1);
        frame_with_film_holder_container();
    }
}

module print_part_3_2() {
    intersection() {
        print_part_3_mask(1, -1);
        frame_with_film_holder_container();
    }
}

module print_part_3_3() {
    intersection() {
        print_part_3_mask(-1, 1);
        frame_with_film_holder_container();
    }
}

module print_part_3_4() {
    intersection() {
        print_part_3_mask(-1, -1);
        frame_with_film_holder_container();
    }
}
//film_holder();
//frame_with_film_holder_container();
print_part_1();
//print_part_2_1();
print_part_2_2();
//print_part_3_1();
print_part_3_2();
print_part_3_3();
//print_part_3_4();
//print_part_1_mask();
//print_part_2_mask(1);
//print_part_3_mask(1,-1);