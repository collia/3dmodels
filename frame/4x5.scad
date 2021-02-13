
module film_holder() {
    // standart film holder size
    // https://www.pinterest.co.uk/pin/392024342563219543/visual-search/?x=10&y=10&w=530&h=453&cropSource=6
    x_1 = 120.5;
    y_1 = 173.0;
    
    y_2 = 160;
    z_1 = 14.5/2;
    z_2 = 11.8/2;
    
    y_3_w = 1.3;
    y_3 = 141.3;
    z_3 = 1.3+z_2;
    
    x_c_offs = 11.0;
    y_c_offs = 15.8;
    
    x_c = 95.1;
    y_c = 120.2;
    z_c = z_2 + 20;
    translate([x_1/2, -(y_c/2+y_c_offs), z_1])
    rotate([0,180,0])
    union() {
        translate([0, y_2, 0])
            cube([x_1, y_1-y_2, z_1]);
        cube([x_1, y_2, z_2]);
        translate([0, y_3, 0])
            cube([x_1, y_3_w, z_3]);
        translate([x_c_offs, x_c_offs, 0])
            cube([x_c, y_c, z_c]);
    }
} 

module frame() {
    side = 200;
    ext_side = 210;
    int_size = 180;
    height_1 = 10;
    height_2 = 6;
    
    film_h_x = 130;
    film_h_y = 180;
    film_h_z = 5;
    
    translate([0,0, -height_2])
    union() {
        translate([0, 0, height_2/2])
            cube([ext_side, ext_side, height_2], center=true);
        translate([0, 0, -height_1/2])
            difference() {
                cube([side, side, height_1], center=true);
                cube([int_size, int_size, height_1], center=true);
            }
        translate([0, 0, film_h_z/2 + height_1/2])
           cube([film_h_x, film_h_y, film_h_z], center=true);
    }
    
}

module frame_with_film_holder_container() {
    difference() {
        frame();
        film_holder();
    }
}

frame_with_film_holder_container();