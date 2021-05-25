
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
    union() {
        translate([-lenght/4, -width/2, height/2])
            cube([lenght/2, line, height], center =true);
        translate([0, -width/2, 0])
            handle_bottom(-1);
    }
}
module full_tongs() {
    union() {
        right_part();
        top_part();
        left_part();
    }
}
full_tongs();