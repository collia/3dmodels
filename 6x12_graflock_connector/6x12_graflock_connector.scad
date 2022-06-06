frame_width = 65;
frame_depth = 125;
frame_center_x = 0;
frame_center_y = 0;

ground_glass_offset = 13;

graflock_plate_height = 4.5;
film_thikness = 0.1;

film_base_offset_z = -2;

ground_glass_thikness = 3;

module graflock_plate() {
    width = 121.5;
    depth = 155;
    height = graflock_plate_height;
    frame_center_y = -(depth - frame_depth)/2+11;
    difference() {
        union() {
            translate([0, 0,-height/2])
                cube([width, depth, height], center=true);
            translate([0, (139 - depth/2) , -height - 1.2/2])
                cube([width, 3.5, 1.2], center=true);
        }
        translate([0, frame_center_y,-height/2])
            cube([frame_width, frame_depth, height], center = true);
    }
}

module film_container_slider() {
    width1 = 107;
    depth1 = 155-1;
    height1 = 8.7;
    //height1 = 7;

    width2 = 97;
    depth2 = 155-1;
    height2 = 2;

    width3 = 101;
    depth3 = 155-1;
    height3 = 1.6;
        
    
    union() {
        translate([0, 0, height1/2 + height2 + height3])
            cube([width1, depth1, height1], center=true);
        translate([0, 0, height2/2 + height3])
            cube([width2, depth2, height2], center=true);
        translate([0, 0, height3/2])
            cube([width3, depth3, height3], center=true);
    }
}

module base() {
    h = 6;
    offset_h = -film_base_offset_z;
    difference() {
        union() {
            graflock_plate();
            translate([0, 0,h/2-offset_h/2])
                cube([115, 155, h-offset_h], center = true);
        }
        translate([0, 1, -offset_h])
            //scale([1.01, 1, 1])
                film_container_slider();
        translate([0, -1,h/2])
                cube([97, 155, h], center = true);
    }
}

module ground_glass() {
    height = ground_glass_thikness;
    translate([0, frame_center_y, ground_glass_offset - graflock_plate_height + height/2 + film_thikness - film_base_offset_z])
            cube([frame_width+5, frame_depth+5, height], center = true);

}

module nut() {
    $fn = 50;
    union() {
        cylinder(h= 10, d =2);
        translate([0, 0, 10-2])
            cylinder(h=2, r1=1, r2=2.5);
    }
}
module ground_glass_container() {
    h = 3+13;
    difference() {
        union() {
            film_container_slider();
            translate([0, 0,h/2])
                cube([90, 154, h], center = true);
        }
        ground_glass();
        translate([0, frame_center_y,h/2])
            cube([frame_width, frame_depth, h], center = true);
        translate([40, -50, 6])
            nut();
        translate([40,   0, 6])
            nut();
        translate([40,  50, 6])
            nut();
        translate([-40, -50, 6])
            nut();
        translate([-40,   0, 6])
            nut();
        translate([-40,  50, 6])
            nut();
    }
}

module ground_glass_container_bottom() {
    split_h = ground_glass_offset - graflock_plate_height + ground_glass_thikness - film_thikness - film_base_offset_z;
    intersection() {
        ground_glass_container();
        translate([0,0,split_h/2])
            cube([160, 160 ,split_h], center=true);
    }
}

module ground_glass_container_upper() {
    split_h = ground_glass_offset - graflock_plate_height + ground_glass_thikness - film_thikness - film_base_offset_z;
    intersection() {
        ground_glass_container();
        translate([0,0,split_h/2+split_h])
            cube([160, 160 ,split_h], center=true);
    }
}
//graflock_plate();
//film_container_slider();

base();
//ground_glass_container();
//ground_glass_container_bottom();
//ground_glass_container_upper();