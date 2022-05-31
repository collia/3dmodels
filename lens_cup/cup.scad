
module lens_cup(d) {
    coef = 0.6;
    internal_d_1 = d + coef;
    internal_d_2 = d - coef;
    side_width = 1;
    height =  7;

    $fn = 50;
    difference() {
        minkowski() {
            union() {
                cylinder(d=(internal_d_1+2*side_width), h=side_width);
                cylinder(d=(internal_d_1+2*side_width), h=side_width+height);
            };
            sphere(d=side_width);
        };

        translate([0,0,side_width*2]) {
            cylinder(d2=internal_d_1, d1=internal_d_2, h=height+side_width);
        }
    }
};

lens_cup(42.1);
