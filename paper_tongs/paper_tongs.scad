
lenght = 150;
width = 20;
height = 10;
line = 3;

module handle_bottom(side) {
    handle_points = [
        [  0,  0,  0 ],  //0
        [ lenght/2,  0,  0 ],  //1
        [ lenght/4,  line*side,  0 ],  //2
        [  0,  line*side,  0 ],  //3
        [  0,  0,  height ],  //4
        [ lenght/2,  0,  height ],  //5
        [ lenght/4,  line*side,  height ],  //6
        [  0,  line*side,  height ]]; //7
  
    handle_faces = [
        [0,1,2,3],  // bottom
        [4,5,1,0],  // front
        [7,6,5,4],  // top
        [5,6,2,1],  // right
        [6,7,3,2],  // back
        [7,4,0,3]]; // left
    
    translate([0, -line*side/2, 0])
        polyhedron( handle_points, handle_faces );
}

module handle() {
    r = 3;
    R = width/2;

    union() {
        translate([0, r+line/2, 0]) rotate([0,0,-90])
            rotate_extrude(angle=90, convexity=1) {
                translate([r+line/2, 0])
                    square([line, height], center=true);
            }
        translate([r+line/2, R/2 + r/2, 0])
            cube([line, R-r-line, height], center = true);

        translate([2*(r+line/2), R - r+line/2, 0]) rotate([0,0,90])
            rotate_extrude(angle=90, convexity=1) {
                translate([r+line/2, 0])
                    square([line, height], center=true);
            }
        {
        translate([2*(r+line/2), line/2, 0]) rotate([0,0,10])
            rotate_extrude(angle=80, convexity=1) {
                translate([R+line/2, 0])
                    square([line, height], center=true);
            }
        translate([R + 3*(r+line/2)+1.2, r+line/2, 0]) rotate([0,0,180])
            rotate_extrude(angle=90, convexity=1) {
                translate([r+line/2, 0])
                    square([line, height], center=true);
            }
        }
    }
}
module right_part() {
    union() {
        translate([-lenght/4, width/2, height/2])
            cube([lenght/2, line, height], center =true);
        translate([0, width/2, 0])
            handle_bottom(1);
    }
}
module top_part() {
    translate([(-lenght)/2, 0, 0]) difference() {
        cylinder(d=width+line, h=height);
        cylinder(d=width-line, h=height);
        translate([(width+line)/2, 0, height/2])
            cube([width+line, width+line, height], center =true);
    }
}

module left_part() {
    handle_offset_1 = 20;
    handle_offset_2 = 31;
    union() {
        translate([-lenght/2+handle_offset_1/2, -width/2, height/2])
            cube([handle_offset_1, line, height], center =true);
        translate([-lenght/2+handle_offset_1, -width/2, height/2])
            handle();
        translate([0, -width/2, 0])
            handle_bottom(-1);

        translate([-handle_offset_2/2, -width/2, height/2])
            cube([handle_offset_2, line, height], center =true);
    }
}
module full_tongs() {
    union() {
        right_part();
        top_part();
        left_part();
    }
}
full_tongs($fn=200);
