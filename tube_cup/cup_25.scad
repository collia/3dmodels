
module cup(width, side, h1, h2, is_empty=true) {
    difference() {
        rotate([0, 0, 45]) union() {
            cylinder(d1 = (width - side*2)*sqrt(2)-1, 
                    d2 = (width - side*2)*sqrt(2),
                    h = h1,
                    $fn = 4);
            translate([0, 0, h1])
                cylinder(d1 = (width)*sqrt(2), 
                         d2 = (width)*sqrt(2)-2, 
                         h = h2,
                         $fn = 4); 
        }
        if(is_empty) {
            translate([0, 0, (h1-2)/2])
                cube([(width - side*4),
                      (width - side*4),
                      (h1-2)],
                      center = true);
        }
    }
}

module central_module_simple() {
    w_full = 90;
    w_central = 65;
    w_cup = (w_full - w_central)/2;
    w_empty = 20;
    d = 22;
    
    difference() {
        cup(30, 2.5, (w_central - w_empty)/2, w_cup, false);
        cylinder(d = d,
                 h = (w_central - w_empty)/2 + w_cup);
    }
}


module central_module_complex() {
    w_full = 90;
    w_central = 65;
    w_cup = (w_full - w_central)/2;
    w_empty = 20;
    d = 22;

    difference() {
        union() {
            cup(30, 2.5, (w_central - w_empty)/2, w_cup, false);
            translate([0,0,(w_central - w_empty)/2])
                cylinder(h = w_cup, r= 50);
        }
        cylinder(d = d,
                 h = (w_central - w_empty)/2 + w_cup);
        translate([35,0,(w_central - w_empty)/2])
            cylinder(d = 5, h = w_cup);
    }
}

module central_module_2() {
    w_full = 80;
    w_central = 65;
    w_cup = (w_full - w_central)/2;
    w_empty = 40;
    d = 22;

    difference() {
        union() {
            cup(25, 3, (w_central - w_empty)/2, w_cup, true);
            translate([0, 25/2, w_cup/2 + (w_central - w_empty)/2])
                cube([25, 50+3, w_cup], center=true);
            translate([0, 25+3,  ((w_central - w_empty)/2 + w_cup)/2])
                cube([25, 25,  (w_central - w_empty)/2 + w_cup], center=true);
        }
        translate([0, 25+3,  0])
        cylinder(d = d,
                 h = (w_central - w_empty)/2 + w_cup);
    }
}

module handle() {
    d_nut = 17;
    h_nut = 5;
    h = 15;
    d = 80;
    ds = d*PI/24;
    $fn = 50;

    difference() {
        union() {
            cylinder(h = h, d = d);
            for(i = [0 : 360/12 : 360])
                rotate([0,0,i])
                    translate([d/2, 0, 0])
                        cylinder(d=ds, h=h);
        };
        cylinder(d = d_nut, h = 5, $fn=6);
        cylinder(d = 11, h = 15);
        for(i = [360/12 /2 : 360/12 : 360+ 360/12 /2])
                rotate([0,0,i])
                    translate([d/2, 0, 0])
                        cylinder(d=ds, h=h);
    }
}
module cups() {
rotate([0, 180, 0]) {
    //cup(25, 2, 15, 2);
    translate([70, 0, 0])
        central_module_simple();
    central_module_complex();
    //central_module_2();
}
}


//cups();
handle();