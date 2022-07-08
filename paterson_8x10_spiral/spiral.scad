spiral_height = 5;
spiral_dia_ext = 93;
spiral_dia_int = 36.5;
central_hole = 26;

module spiral() {
    //translate([-15,-20,0]) //scale([1.2, 1.2, 0])
    translate([5,2,0])
        linear_extrude(height = spiral_height, center = true, convexity = 10)
            import("spiral.svg", dpi=100, center=true);
}

module film_line() {
    //minkowski() {
        difference() {
            minkowski() {
                spiral();
                cylinder(r=3, h=spiral_height/3 );
            }
            minkowski() {
                spiral();
                //sphere(r=2 );
                cylinder(r=1, h=spiral_height/3 );
            }
     //   }
     //   sphere(r=1);
    }
}

module side_part() {
    $fn = 100;
    union() {
        translate([0, 0, 3])
            film_line();
        //translate([0, 0, 4])
        //    rotate([0, 0, 180])
        //translate([0, 0, 3])
        //    scale([1.3, 1.3, 1])
        //        film_line();
        for (i = [0:4]) {
            rotate([0,0, (360/5)*i])
                translate([0,0,-1])
                    cube([spiral_dia_ext-1, 3, 2], center=true);
        }
        for (i = [spiral_dia_ext:-10:30]) {
            translate([0,0,-2])
                difference() {
                    cylinder(h=2, d = i);
                    cylinder(h=2, d = i-5);
                }
        }
    }
}

union() {
    difference() {
        translate([0,0,-2])
            cylinder(h=50, d=spiral_dia_int);
        translate([0,0,-2])
            cylinder(h=50, d=central_hole);
    }
    side_part();
}
//spiral();