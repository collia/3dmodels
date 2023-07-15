include <../lib/threads.scad>


frame_width = 65;
frame_depth = 125;
frame_center_x = 0;
frame_center_y = 0;

ground_glass_offset = 13;

graflock_plate_height = 6;
film_thikness = 0.1;

film_base_offset_z = -4;

ground_glass_thikness = 0.8;

module graflock_plate() {
    width = 120;
    depth = 155;
    height = graflock_plate_height;
    frame_center_y = -(depth - frame_depth)/2+12;
    difference() {
        union() {
            translate([0, 0,-height/2])
                cube([width, depth, height], center=true);
            //translate([0, (140 - depth/2) , -height - 1.2/2])
            //    cube([width-4, 2, 1.5], center=true);
        }
        translate([0, frame_center_y,-height/2])
            cube([frame_width, frame_depth, height], center = true);
    }
}

module film_container_slider_external() {
    width1 = 107;
    depth1 = 155-1;
    height1 = 8.7;
    //height1 = 7;

    width2 = 98;
    depth2 = 155-1;
    height2 = 1.6;

    width3 = 103;
    depth3 = 155-1;
    height3 = 2.2;
        
    
    union() {
        translate([0, 0, height1/2 + height2 + height3])
            cube([width1, depth1, height1], center=true);
        translate([0, 0, height2/2 + height3])
            cube([width2, depth2, height2], center=true);
        translate([0, 0, height3/2])
            cube([width3, depth3, height3], center=true);
        translate([width1/2-5, depth1/2-5, 0])
            rotate([0,0,45])
                cube([10, 10, height1]);
        translate([-(width1/2-5), depth1/2-5, 0])
            rotate([0,0,45])
                cube([10, 10, height1]);
        translate([0, depth3/2+12, -0/2])
            rotate([45,0,0])
                cube([width3, 20, 20], center = true);
    }
}

module film_container_slider_internal() {
    width1 = 107-1.6;
    depth1 = 155-1;
    height1 = 8.7;
    //height1 = 7;

    width2 = 98-1.6;
    depth2 = 155-1;
    height2 = 1.6+1.0;

    width3 = 103-1;
    depth3 = 155-1;
    height3 = 2.2-0.6;
    
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
                cube([120, 155, h-offset_h], center = true);
        }
        translate([0, 1, -offset_h])
            //scale([1.01, 1, 1])
                film_container_slider_external();
        translate([0, -1, h/2])
                cube([97, 155, h], center = true);
    }
}

module shape(top_d, bottom_x, bottom_y, height) {
    steps = 128;
    L_top = [ for (a = [0 : steps-1]) [top_d/2 * sin(360*a/steps), 
                                     top_d/2 * cos(360*a/steps), height]];
    L_bottom = [ 
                for (a = [0:steps/8-1]) [(bottom_x/2)*a/(steps/8), bottom_y/2, 0],
                for (a = [0:steps/8-1]) [bottom_x/2, bottom_y/2*((steps/8-a)/(steps/8)), 0],
                for (a = [0:steps/8-1]) [bottom_x/2, bottom_y/2*((-a)/(steps/8)), 0],
                for (a = [0:steps/8-1]) [(bottom_x/2)*(steps/8-a)/(steps/8), -bottom_y/2, 0],
                for (a = [0:steps/8-1]) [(bottom_x/2)*(-a)/(steps/8), -bottom_y/2, 0],
                for (a = [0:steps/8-1]) [-bottom_x/2, bottom_y/2*((a-steps/8)/(steps/8)), 0],
                for (a = [0:steps/8-1]) [-bottom_x/2, bottom_y/2*((a)/(steps/8)), 0],
                for (a = [0:steps/8-1]) [(bottom_x/2)*(a-steps/8)/(steps/8), bottom_y/2, 0]
               ];
    L_points = [for (a=[0:len(L_bottom) + len(L_top)-1]) 
          (a % 2 == 0)? L_bottom[a/2] : L_top[a/2]];
    L_lines = [for (a = [0 : 2 : steps*2-3]) [a+1, a, a + 2, a +3],
                [steps*2-1, steps*2-2, 0, 1],
               [for (a = [steps*2-2: -2: 0]) a],
               [for (a = [1: 2 : steps*2-1]) a]];
    //polygon(L_top);
    //echo(L_points);
    //echo(L_lines);
    //echo(len(L_points));
    //polygon(L);           
    polyhedron(L_points, L_lines); 
}

module lens_nut() {
    d= 32;
    pitch =5/9;
    h =5;
    difference() {
        union() {
            cylinder(h-1, d=57, $fn=128);
            cylinder(h, d=38, $fn=128);
        }
        scale([1.01, 1.01, 1])
            metric_thread (diameter=d, pitch=pitch, length=h, internal=true, n_starts=1, test=false );
        
    }
}
module platform() {
    h = 15;
    difference() {
        cylinder(h, d=40, $fn=128);
        scale([1.01, 1.01,1])
            english_thread (diameter=1/4, threads_per_inch=20, length=h/25.4, internal=true, test=false);
    }
}

module camera() {
    h = 105 - ground_glass_offset;
    union() {
        translate([0,0, -graflock_plate_height])
            rotate([180,0,0])
                base();
        translate([0, 3, 0])
        difference() {
            shape(57, 120, 155-6, h-3);
            shape(32, frame_width, frame_depth, h);
        };
        translate([0,3,h-5])
            lens_nut();
        translate([120/2-15, 0, 20])
            rotate([0,90,0])
                platform();
    }
}

camera();
//platform();
//lens_nut();