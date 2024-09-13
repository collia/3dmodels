
board_x = 95;
board_y = 94;
board_h = 7;

module graflex_container() {
    translate([0, 0, board_y/2])
        cube([board_x, board_h, board_y], center = true);
}
module rounded_box(x, y, h, r){
    ext_x = (x - 2*r)/2;
    ext_y = (y - 2*r)/2;
    linear_extrude(height = h, twist = 0) {
        difference() {
            hull() {
                translate([ext_x, ext_y,0]) circle(r=r);
                translate([ext_x, -ext_y,0]) circle(r=r);
                translate([-ext_x, ext_y,0]) circle(r=r);
                translate([-ext_x, -ext_y,0]) circle(r=r);
            }
        }
    }
}

module container(front, back, number) {
    wall = 4;
    int_wall = wall/2;
    cap_h = 20;
    ext_y = front+board_h+back+wall*2+2*int_wall;
    difference()  {
        translate([0, ext_y/2, 0]) {
            union() {
                rounded_box(board_x+wall*2, ext_y, board_y+wall - cap_h, 10);
                rounded_box(board_x+wall, ext_y-wall, board_y+wall, 10);
            }
        }
        translate([0, front/2 + wall, wall]) {
            rounded_box(board_x, front, board_y, 10);
        }
        
        translate([0, front + wall + int_wall + board_h/2, wall]) {
            graflex_container();
        }
        translate([0, front + wall + int_wall + board_h/2, wall+board_y/2]) {
            cube([board_x-20, board_h+2*int_wall, board_y], center = true);
        }
        translate([0, front + wall + int_wall + board_h + int_wall + back/2, wall]) {
            rounded_box(board_x, back, board_y, 5);
        }
    }
}

module container_cap(front, back, number) {
    wall = 4;
    int_wall = wall/2;
    cap_h = 20;
    ext_y = front+board_h+back+wall*2+2*int_wall;
    difference()  {
            rounded_box(board_x+wall*2, ext_y, cap_h + wall, 10);
            translate([0, 0, wall]) {
                rounded_box(board_x+wall+0.3, ext_y-wall+0.3, cap_h , 10);
            }
    }
}

$fn= 200;
//$fa = 100;
//lens_board(80);
//graflex_container();
//holder_low();
//holder_high();
//graflex_container();

//container(30, 10, 160);
container_cap(30, 10, 160);