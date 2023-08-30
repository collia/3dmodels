plates = 5;
space = 15;
plate_h = 2.5;
h = 5*2 + (plates-1)*(space+plate_h)+plate_h;
difference() {
    cube([50, 50, h]);
    for(a=[5: space+plate_h : h]) {
        translate([plate_h, plate_h, a])
            cube([50, 50, plate_h]);
    }
    translate([25, 25, 0])
        cylinder(h=h, d=25);
}