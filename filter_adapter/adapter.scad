
D_ext = 84;
//D_int = 42;
D_int = 38;
H_ext = 1.5;
H_int = 6;
Wall_int = 1.5;

module profile() {
    r = H_ext*2;
    delta = 0.4;
    union() {
        translate([delta, 0]) square([(D_ext-D_int)/2-delta, H_ext]);
        //square([H_ext, H_int]);
        polygon(points = [
            [0,0],
            [delta, H_int],
            [Wall_int, H_int],
            [Wall_int, 0]]);
        difference() {
            translate([delta, 0]) square([r-delta, r]);
            translate([r, r]) circle(d=r);
        }
    }
}

$fn = 50;
rotate_extrude(angle = 360)
    translate([D_int/2, 0])
        profile();