include <../lib/threads.scad>

module blend(base_diameter, top_diameter, wall, height) {
    translate([0,0,-height])
    difference() {
        cylinder(d2 = base_diameter, d1 = top_diameter, h=height);
        cylinder(d2 = base_diameter-wall*2, d1 = top_diameter- wall*2, h=height);
    };
}

module thread(d, wall) {
    height = 5;
    difference() {
        union() {
            cylinder(h=height, d=d-2);
            metric_thread (diameter=d-1, pitch=1, length=height, internal=false, n_starts=1);
        }
        cylinder(h=height, d=(d - 2 - wall*2));
    }
}

angle_to_diameter = function(height, angle) height/cos(angle/2);


$fn = 100;
lens_angle = 72;
height = 70;
diameter = 103;
union() {
    blend(diameter-2, diameter + angle_to_diameter(height, lens_angle), 2, 70);
    thread(diameter,2);
}