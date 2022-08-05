$fn=100;
number_holes = 8;
difference() {
    cube ([10, 10*(number_holes+1), 10]);
    for(i = [0 : number_holes-1]) {
        d = 2.5 + 0.05*i;
        translate([5, 10*(i+1), 0]){
            cylinder(d = d, h = 10);
            translate([2, -3, 10-0.5]){
                #linear_extrude(0.5)
                    text(str(d), size = 2);
            }
        }
    }
}