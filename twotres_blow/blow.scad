/*
module main_body() {
    external_h = 5;
    union() {
        difference() {
            cube([28, 8, 4]);
            translate([1, 0, 0])
                cube([26, 7, 4]);
        };
        translate([-6,-1,-external_h]) {
            cube([40, 10, external_h]);
        }
    }
}*/

module main_body(left) {
    window_h = 2;
    window_x = 18;
    external_h = 5;

    points_left = [ [5, 0, -external_h], //0
               [5+window_x+2, 0, -external_h], //1

               [-6, 10, 0],  //2
               [34, 10, 0], //3

               [-6, -2, 0],  //4
               [34, -2, 0]]; //5

    points_right = [ [26 - window_x - 5, 0, -external_h], //0
               [26 - 5 + 2, 0, -external_h], //1

               [-6, 10, 0],  //2
               [34, 10, 0], //3

               [-6, -2, 0],  //4
               [34, -2, 0]]; //5
    faces = [ [0, 1, 3, 2],
              [0, 2, 4],
              [2, 3, 5, 4],
              [3, 1, 5],
              [0, 4, 5, 1]];
    union() {
         difference() {
            cube([28, 8, 4]);
            translate([1, 0, 0])
                cube([26, 7, 4]);
        };
        if(left) {
            polyhedron(points_left, faces);
        } else {
            polyhedron(points_right, faces);
        }
    }
}

module connector() {
    difference() {
        intersection(){
            cube([4.5,4,4.5]);
            union() {
                translate([2.25,0,2.25])
                    rotate([-90, 0, 0])
                        cylinder(r = 2.25, h=4);
                cube([2.25,4,4.5]);
                cube([4.5,4,2]);
            }
        }
        translate([2,0,2.7])
        rotate([-90, 0, 0])
            cylinder(d=2, h = 4);
    }
}

module connectors() {
    translate([-6, 2, 0]) {
        connector();
    }
    translate([40-6, 2+4, 0]){
        rotate([0,0,180])
            connector();
    }
}

module air_path(left) {
    window_h = 2;
    window_x = 18;
    internal_h = 5;

    points_left = [ [5, 0, 0], //0
               [5+window_x, 0, 0], //1
               //[5+window_x, 0, window_h],
               //[5, 0, window_h],

               [0, 7, internal_h],  //2
               [26, 7, internal_h], //3

               [0, 0, internal_h],  //4
               [26, 0, internal_h]]; //5

    points_right = [ [26 - window_x - 5, 0, 0], //0
               [26 - 5, 0, 0], //1
               //[5+window_x, 0, window_h],
               //[5, 0, window_h],

               [0, 7, internal_h],  //2
               [26, 7, internal_h], //3

               [0, 0, internal_h],  //4
               [26, 0, internal_h]]; //5
    faces = [ [0, 1, 3, 2],
              [0, 2, 4],
              [2, 3, 5, 4],
              [3, 1, 5],
              [0, 4, 5, 1]];
    union() {
        if(left) {
            polyhedron(points_left, faces);
            translate([5, -1, 0])
                cube([window_x, 1, window_h]);
        } else {
            polyhedron(points_right, faces);
            translate([26 - window_x-5, -1, 0])
                cube([window_x, 1, window_h]);
        }
    }
}

$fn = 50;

difference() {
    union() {
        main_body(false);
        //main_body(true);
        connectors();
    };
    translate([1, 0, -5])
        air_path(false);
        //air_path(true);
}
