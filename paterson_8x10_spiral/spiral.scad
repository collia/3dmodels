spiral_height = 5;
spiral_dia_ext = 93;
spiral_dia_int = 36.5;
spiral_dia_h = 63.5;
central_hole = 26.5;
film_height = 8*25.4;
connector_h = (spiral_dia_int + central_hole)/2;

medium_holder_h = spiral_height + 2;

module spiral() {
        linear_extrude(height = spiral_height, center = true, convexity = 10)
            import("spiral.svg", dpi=100, center=true);
}

module film_line() {
    //minkowski() {
        difference() {
            union() {
                minkowski() {
                    spiral();
                    cylinder(r=2, h=spiral_height/3 );
                }
                for (i = [0:4]) {
                    rotate([0,0, (360/5)*i])
                        translate([0,0,1])
                            cube([spiral_dia_ext-14, 2, spiral_height + 1], center=true);
                }
            }
            minkowski() {
                spiral();
                //sphere(r=2 );
                cylinder(r=0.5, h=spiral_height/3 );
            }
     //   }
     //   sphere(r=1);
    }
}

module side_part(z) {
    $fn = 100;
    union() {
        for (i = [0:4]) {
            rotate([0,0, (360/5)*i])
                translate([0,0,z+2/2])
                    cube([spiral_dia_ext-1, 3, 2], center=true);
        }
        for (i = [spiral_dia_ext:-10:30]) {
            translate([0,0, z])
                difference() {
                    cylinder(h=2, d = i);
                    cylinder(h=2, d = i-5);
                }
        }
    }
}

module leaves_enter_bottom(z) {
    translate([spiral_dia_ext/2 - 5, 0, z])
        rotate([0, 0, 0])
            cube([5, 20, 2], center=true);
    translate([-spiral_dia_ext/2 + 5, 0, z])
        rotate([0, 0, 0])
            cube([5, 20, 2], center=true);
}
module leaves_enter_side(z) {
    translate([-spiral_dia_ext/2+7, 1, z])
        rotate([0, 0, 40])
            cube([2, 5.0, spiral_height/2+4.1], center=true);
    translate([spiral_dia_ext/2-7, -1, z])
        rotate([0, 0, 40])
            cube([2, 5.0, spiral_height/2+4.1], center=true);
}
module leaves_enter_upper(z) {
    translate([spiral_dia_ext/2 - 2, 0, z])
        rotate([0, 0, 30])
            cube([8, 8, spiral_height+4], center=true);
    translate([-spiral_dia_ext/2 + 2, 0, z])
        rotate([0, 0, 30])
            cube([8, 8, spiral_height+4], center=true);
}
module connector() {
    //side = spiral_dia_int/sqrt(2) - 0.5;
    //translate([0, 0, side/2])
    //    cube([side, side, side], center=true);
    d = (spiral_dia_int + central_hole)/2;
        cylinder(d=d, h=connector_h, $fn=8);
}

module bottom() {
    union() {
        difference() {
            union() {
                translate([0, 0, 1.5])
                    film_line();
                side_part(-2);
                translate([0,0,-2])
                    cylinder(h=spiral_dia_h+2, d=spiral_dia_int);
                leaves_enter_bottom(-1);
                leaves_enter_side(spiral_height/4+1);
                translate([0,0,spiral_dia_h])
                    connector();
            }
            translate([0,0,-2])
                cylinder(h=film_height, d=central_hole);
            leaves_enter_upper(spiral_height/2+2);
        }
    }
}

module upper() {
    union() {
        difference() {
            union() {
                translate([0, 0, -spiral_height/2-1.5])
                    film_line();
                side_part(0);
                translate([0,0,-spiral_dia_h])
                    cylinder(h=spiral_dia_h+2, d=spiral_dia_int);
                leaves_enter_bottom(1);
                leaves_enter_side(-spiral_height/2-0.6);
                translate([0,0,-spiral_dia_h-connector_h])
                    connector();
            }
            translate([0,0,-film_height])
                cylinder(h=film_height+2, d=central_hole);
            leaves_enter_upper(-spiral_height/2-2);
        }
    }
}

module medium() {
    difference() {
        cylinder(h=film_height - spiral_dia_h*2 - 2*medium_holder_h, d=spiral_dia_int);
        translate([0, 0, -medium_holder_h])
            scale([1.01, 1.01, 1.01])
              connector();
        cylinder(h=film_height+2, d=central_hole-0.5);
        translate([0, 0, film_height - spiral_dia_h*2-connector_h - medium_holder_h])
            scale([1.01, 1.01, 1.01])
              connector();
    }
}

module medium_holder() {
    difference() {
        union() {
            translate([0, 0, spiral_height/2])
                    film_line();
            cylinder(h=medium_holder_h, d=spiral_dia_int);
            leaves_enter_side(3.3);
            translate([spiral_dia_int/2 + 3, 1, medium_holder_h/2])
                cube([10, 6, medium_holder_h], center = true);
            translate([-(spiral_dia_int/2 + 3), -1, medium_holder_h/2])
                cube([10, 6, medium_holder_h], center = true);
        }
        translate([0,0,-connector_h/2])
            scale([1.02, 1.02, 1.00])
                connector();
        leaves_enter_upper(3);
    }
}
module bottom_new() {
    //union() {
        difference() {
            union() {
                //translate([0, 0, 1.5])
                import("bottom_generated.stl");
                translate([0,0,-2])
                    cylinder(h=spiral_dia_h+2, d=spiral_dia_int);
                //leaves_enter_bottom(-1);
                //leaves_enter_side(spiral_height/4+1);
                translate([0,0,spiral_dia_h])
                    connector();
            }
            translate([0,0,-2])
                cylinder(h=film_height, d=central_hole);
            //leaves_enter_upper(spiral_height/2+2);
       }
    //}
}

//bottom();
//upper();
//medium();
//medium_holder();
bottom_new();