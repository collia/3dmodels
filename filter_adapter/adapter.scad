
D_ext = 100;
D_int = 35;
H_ext = 3;
H_int = 15;

module profile() {
    r = H_ext*2;
    delta = 0.7;
    union() {
        square([(D_ext-D_int)/2, H_ext]);
        //square([H_ext, H_int]);
        polygon(points = [
            [-delta/2,0],
            [delta/2, H_int],
            [H_ext, H_int],
            [H_ext, 0]]);
        difference() {
            translate([0, 0]) square([r, r]);
            translate([r, r]) circle(d=r);
        }
    }
}

$fn = 50;
rotate_extrude(angle = 360)
    translate([D_int/2, 0])
        profile();