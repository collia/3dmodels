D = 38.8;
d = 36.5;
W = 33;
//W = 27;


module apperture_2d_body() {
    rnd = 3;
    minkowski() {
        union() {
            intersection() {
                circle(d=D-rnd);
                translate([D/2, 0])
                    square([D, W-rnd], center=true);
            }
            intersection() {
                circle(d=d-rnd);
                translate([-D/2, 0])
                    square([D, W-rnd], center=true);
            }
        }
        circle(d=rnd);
    }
}

module apperture_2d_with_handle(text) {
    handle_w = 10;
    font_size = 3;
    rnd = 5;
    difference() {
        union() {
            translate([D/2,0])
                minkowski() {
                    square([handle_w*2-2*rnd, handle_w-rnd], center=true);
                    circle(d=rnd);
                }
            apperture_2d_body();
        }
        translate([D/2+font_size/2, 3])
        rotate(-90)
            text(text, size = font_size, font="Monoid:style=Italic");
    }
}

module apperture_2d(name, int_dia) {
    difference() {
        apperture_2d_with_handle(name);
        circle(d=int_dia);
    }
}

module test_print() {
    linear_extrude(height=1) {
        //translate([0, -100])
        //    apperture_2d("11", 26.24);
        //translate([0, -60])
        //    apperture_2d("16", 18.6);
        translate([0, -20])
            apperture_2d("22", 13.1);
        translate([0, 20])
            apperture_2d("32", 9.2);
        translate([0, 60])
            apperture_2d("45", 6.54);
        translate([0, 100])
            apperture_2d("64", 4.6);
    }
}

module prepare_drawing() {
    translate([0, -100])
        apperture_2d("11", 26.24);
    translate([0, -60])
        apperture_2d("16", 18.6);
    translate([0, -20])
        apperture_2d("22", 13.1);
    translate([0, 20])
        apperture_2d("32", 9.2);
    translate([0, 60])
        apperture_2d("45", 6.54);
    translate([0, 100])
        apperture_2d("64", 4.6);
}

$fn = 50;
//apperture_2d("11", 26.24);
//apperture_2d("16", 18.6);
//apperture_2d("22", 13.1);
//apperture_2d("32", 9.2);
//apperture_2d("45", 6.54);
//apperture_2d("64", 4.6);
test_print();
//prepare_drawing();