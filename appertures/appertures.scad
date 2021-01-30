D = 47.5;
d = 36.5;
W = 27.5;


module apperture_2d_body() {
    rnd = 2;
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
    font_size = 4;
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
            text(text, size = font_size);
    }
}

module apperture_2d(name, int_dia) {
    difference() {
        apperture_2d_with_handle(name);
        circle(d=int_dia);
    }
}

module test_print() {
    linear_extrude(height=0.7)
        apperture_2d("16", 18.6);
}

$fn = 50;
//apperture_2d("16", 18.6);
test_print();