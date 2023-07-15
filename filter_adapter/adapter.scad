include <../lib/threads.scad>

module profile(H_ext, H_int, D_ext, D_int, Wall_int) {
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

module external_cokin_adapter() {
    D_ext = 84;
    //D_int = 42;
    //D_int = 38;
    //D_int = 51-0.5;
    D_int = 46-0.5;
    H_ext = 1.5;
    //H_int = 6;
    H_int = 8;
    Wall_int = 1.5;

    $fn = 100;
    rotate_extrude(angle = 360)
        translate([D_int/2, 0])
            profile(H_ext, H_int, D_ext, D_int, Wall_int);
}

module thread_cokin_adapter(thread_d) {
    D_ext = 84;
    H_ext = 1.5;

    H_int = 6;
    Wall_int = 1.5;
    D_int = thread_d - Wall_int*2 - 0.75*2;

    D_chamfer = ((sqrt(3)*(H_int-H_ext - 0.5))+ D_int/2 + Wall_int)*2;
    H_chamfer = ((D_int/2 + Wall_int - 0.5)/sqrt(3))+ H_int;
    
    $fn = 100;
    union() {
        intersection() {
            difference() {
                union() {
                    rotate_extrude(angle = 360)
                        translate([D_int/2, 0])
                            profile(H_ext, H_int + 0.1, D_ext, D_int, Wall_int);
                    translate([0,0, H_ext*2])
                            metric_thread (diameter=thread_d, pitch=0.75, length=H_int - H_ext*2, internal=false, n_starts=1, test=false);
                }
                cylinder(h=H_int, d=D_int);
            }
            union() {
                translate([0,0,H_ext])
                    cylinder(h=H_chamfer, d1=D_chamfer, d2=0);
                cylinder(h=H_ext, d=D_ext);
            }
        }
        translate([-2.5, D_ext/2 - 4, 0])
            linear_extrude(H_ext + 1)
                text(str(thread_d), size = 3);
    }
}

//external_cokin_adapter();
thread_cokin_adapter(63);