include <../lib/threads.scad>

module blend(base_diameter, top_diameter, wall, height) {
    translate([0,0,-height])
    difference() {
        cylinder(d2 = base_diameter, d1 = top_diameter, h=height);
        cylinder(d2 = base_diameter-wall*2, d1 = top_diameter- wall*2, h=height);
    };
}

module thread(d, pitch, wall) {
    height = 5;
    difference() {
        union() {
            //cylinder(h=height, d=d-3*pitch);
            metric_thread (diameter=d, pitch=pitch, length=height, internal=false, n_starts=1);
        }
        cylinder(h=height, d=(d - 3*pitch - wall*2));
    }
}

//angle_to_diameter = function (height, angle) height/cos(angle/2);
function angle_to_diameter(height, angle) = height/cos(angle/2);


$fn = 200;
lens_angle = 70;
height = 60;
diameter = 105;
pitch = 1;
union() {
    blend(diameter-2*pitch, diameter + angle_to_diameter(height, lens_angle), 1.4, height);
    thread(diameter, pitch, 1.4);
}