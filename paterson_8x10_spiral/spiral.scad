spiral_height = 5;
spiral_dia_ext = 200;

module spiral() {
    translate([-15,-20,0]) //scale([1.2, 1.2, 0])
        linear_extrude(height = spiral_height, center = true, convexity = 10)
            import("spiral.svg", dpi=100, center=true);
}

module film_line() {
    minkowski() {
        difference() {
            minkowski() {
                spiral();
                cylinder(r=5, h=spiral_height/3 );
            }
            minkowski() {
                spiral();
                //sphere(r=2 );
                cylinder(r=2, h=spiral_height/3 );
            }
        }
        sphere(r=1);
    }
}

module side_part() {
    $fn = 100;
    union() {
        translate([0, 0, 4])
            film_line();
        translate([0, 0, 4])
            rotate([0, 0, 180])
                film_line();
        for (i = [0:4]) {
            rotate([0,0, (360/5)*i])
                translate([0,0,-2])
                    cube([spiral_dia_ext-1, 3, 4], center=true);
        }
        for (i = [200:-10:30]) {
            translate([0,0,-4])
                difference() {
                    cylinder(h=4, d = i);
                    cylinder(h=4, d = i-5);
                }
        }
    }
}
/*
difference() {
    translate([0,0,-5])
        cylinder(h=5, d=150);
    translate([0,0,-5])
        cylinder(h=5, d=35);
}*/
side_part();