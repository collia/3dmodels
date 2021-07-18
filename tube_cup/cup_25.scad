
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

module central_module() {
    w_full = 85;
    w_central = 65;
    w_cup = (w_full - w_central)/2;
    w_empty = 20;
    d = 22;
    
    difference() {
        cup(25, 3, (w_central - w_empty)/2, w_cup, false);
        cylinder(d = d,
                 h = (w_central - w_empty)/2 + w_cup);
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

//cup(25, 2, 15, 2);
central_module_2();
