include <../lib/threads.scad>

module lens_board() {
    board_width = 79.5;
    board_h = 3.5;
    board_trim=10;
    board_trim_side=sqrt(board_trim*board_trim*2);
    difference() {
        cube([board_width, board_width, 3], center=true);
        translate([board_width/2, board_width/2, 0])
            rotate([0, 0, 45])
                cube([board_trim_side, board_trim_side, board_h], center=true);
        translate([-board_width/2, board_width/2, 0])
            rotate([0, 0, 45])
                cube([board_trim_side, board_trim_side, board_h], center=true);
        translate([board_width/2, -board_width/2, 0])
            rotate([0, 0, 45])
                cube([board_trim_side, board_trim_side, board_h], center=true);
        translate([-board_width/2, -board_width/2, 0])
            rotate([0, 0, 45])
                cube([board_trim_side, board_trim_side, board_h], center=true);
        
        translate([0, board_width/2+1, 0])
            rotate([45, 0, 0])
                cube([12.5, board_h*6, board_h], center=true);
        
        translate([0, -board_width/2-5, 0])
            rotate([-30, 0, 0])
                #cube([board_width, board_h*6, board_h*2], center=true);
    }
}
difference() {
    $fn=100;
    union() {
        lens_board();
        cylinder(d=45, h=5);
    }
    translate([0, 0, -3])
    //thread M39 26 lines per inch
        scale([1.02, 1.02, 1])
            metric_thread (diameter=39, pitch=25.4/26, length=5+3, internal=true, n_starts=1);
    
    translate([0, 0, -3])
        cylinder(h=5, d1=39+3, d2=39-3);
}