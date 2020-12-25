use <../MCAD/involute_gears.scad>

module gears_print(print_gear1, print_gear2) {
        $fn = 20;
        gear1_teeth = 56;
        gear2_teeth = 12;
        axis_angle = 90;
        outside_circular_pitch=300;
    
    
        outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
        outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
        pitch_apex1=outside_pitch_radius2 * sin (axis_angle) +
                (outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
        cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
        pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
        echo ("cone_distance", cone_distance);
        pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
        pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
        echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
        echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);
        rotate([0,0,90])
        translate ([0,0,pitch_apex1+12])
        {
            if(print_gear2 != 1) {
                translate([0,0,-pitch_apex1])
                bevel_gear (
                        number_of_teeth=gear1_teeth,
                        cone_distance=cone_distance,
                        pressure_angle=30,
                        outside_circular_pitch=outside_circular_pitch,
                        face_width = 15,
                        gear_thickness = 10,
                        bore_diameter=5
                );
            }
            if(print_gear1 != 1) {
                rotate([0,-(pitch_angle1+pitch_angle2),0])
                translate([0,0,-pitch_apex2])
                bevel_gear (
                        number_of_teeth=gear2_teeth,
                        cone_distance=cone_distance,
                        pressure_angle=30,
                        outside_circular_pitch=outside_circular_pitch,
                        face_width=15,
                        gear_thickness = 10,
                        bore_diameter=3
                );
            }
       }

       echo("external_gear_dia = ", pitch_apex2*2);
       echo("external_gear_height = ", pitch_apex1+12); 
    
}

module frame() {
    external_gear_dia = 96;
    external_gear_height = 22;
    frame_w = 20;
    frame_h = 10;
   
    union() {
        translate([ -frame_w/2,
                -(external_gear_dia + frame_h*2) /2,
                -frame_h])
            cube([frame_w, 
                external_gear_dia+frame_h*2,
                frame_h]);
        translate([ -frame_w/2,
                (external_gear_dia)/2,
                -0.1])
            cube([frame_w, 
                frame_h,
                external_gear_height*2]);
        translate([ -frame_w/2,
                -(external_gear_dia)/2 - frame_h,
                -0.1])
            cube([frame_w, 
                frame_h,
                external_gear_height*2]);
        translate([ -frame_w/2,
                -(external_gear_dia + frame_h*2) /2,
                frame_h*2+external_gear_height])
            cube([frame_w, 
                external_gear_dia+frame_h*2,
                frame_h]);
    }
}

module pin_big(pin_d) {
    pin_d = 5;
    $fn = 20;
    union() {
        translate([0,0,15/2])
            cube([pin_d, pin_d, 15], center=true);
        translate([0,0,-20])
            cylinder(d=pin_d, h=20);
    }
}

module pin_small(pin_d) {
    external_gear_dia = 96;
    external_gear_height = 22;
    $fn = 20;
    //pin_d = 5;
    union() {
        translate([0, external_gear_dia/2 - 15/2, external_gear_height])
            cube([pin_d, 20, pin_d], center=true);
        translate([0, external_gear_dia/2 + 30,               external_gear_height])
            rotate([90,0,0])
                cylinder(d=pin_d, h=30);
    }
}

module handle() {
    external_gear_dia = 96;
    external_gear_height = 22;

    translate([0, -external_gear_dia/2-15, external_gear_height])
    union() {
        hull() {
            translate([0, -40, 0])
                sphere(r=20);
            sphere(r=10);
        }
        translate([0,10,0])
            cube([10,10,10], center=true);
    }
}

module main_part() {
    difference() {
        union() {
            gears_print(1, 0);
            //frame();
        }
        pin_big(5.5);
        pin_small(5.5);
        handle();
    }
}
union() {
    main_part();
    //pin_big(5);
    //pin_small(5);
    //handle();
}