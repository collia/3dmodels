plate_x = 73;
plate_y = 129;
plate_z = 4;


module screen_hole() {
    translate([0,0,7.5/2])
        cube([60.5, 14.5, 7.5], center=true);
}
module plate() {
    union() {
        translate([0,0, plate_z/2])
            minkowski() {
                cube([plate_x-3, plate_y-3, plate_z/2], center=true);
                cylinder(d1=3, d2=0, h=plate_z/4);
            }
        }
        translate([plate_x/2-20, -plate_y/2+20, (plate_z+4)/2])
            cylinder(d=13.5, h=(plate_z+4));
}

module encoder_hole() {
    translate([0,0, 4/2])
        cylinder(h=6, d=7, center =true);
    translate([10-7/2,0, 1/2])
        cylinder(h=1, d=3, center =true);
}


module button_hole() {
    translate([0,0, 12/2])
        cylinder(h=12, d=12, center =true);
}

module switch_hole() {
    translate([0,0, 8/2])
        cylinder(h=8, d=6, center =true);
}

module texts() {
    translate([plate_x/2-20, -plate_y/2+30, plate_z-1]) {
        linear_extrude(height = 1) {
            text("start", size = 5, halign="center");
        }
    }
    translate([-plate_x/2+20, -plate_y/2+30, plate_z-1]) {
        linear_extrude(height = 1) {
            text("white", size = 5, halign="center");
        }
    }
    translate([-plate_x/2+20, -plate_y/2+5, plate_z-1]) {
        linear_extrude(height = 1) {
            text("red", size = 5, halign="center");
        }
    }
    translate([-plate_x/2+20, -plate_y/2+50, plate_z-1]) {
        linear_extrude(height = 1) {
            text("time", size = 5, halign="center");
        }
    }
    translate([-plate_x/2+20, plate_y/2-44, plate_z-1]) {
        linear_extrude(height = 1) {
            text("brightnes", size = 4, halign="center");
        }
    }
    translate([plate_x/2-20, plate_y/2-44, plate_z-1]) {
        linear_extrude(height = 1) {
            text("contrast", size = 4, halign="center");
        }
    }
}

difference() {
    $fn = 100;
    plate();
    translate([0, plate_y/2-30, 0])
        screen_hole();
    translate([plate_x/2 - 20, plate_y/2-50, 0])
        encoder_hole();
    translate([-plate_x/2 + 20, plate_y/2-50, 0])
        encoder_hole();
    translate([0, -plate_y/2+50, 0])
        encoder_hole();
    translate([plate_x/2-20, -plate_y/2+20, 0])
        button_hole();
    translate([-plate_x/2+20, -plate_y/2+20, 0])
        switch_hole();
    texts();
}