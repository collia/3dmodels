spiral_height = 5;

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
            cylinder(r=1, h=spiral_height/3 );
        }
    }
    sphere(r=1);
    }
}

module side_part() {
    film_line();
}
/*
difference() {
    translate([0,0,-5])
        cylinder(h=5, d=150);
    translate([0,0,-5])
        cylinder(h=5, d=35);
}*/
side_part();