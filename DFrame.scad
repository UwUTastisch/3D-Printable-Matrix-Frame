$fn = 20;

//cube_size = [66.5,66.5,5];
cube_size = [65.25,63.98+4.02,5];
//cube_size = [65.25,66.5,5];
//cube_size = [20,20,5];

hole_space_x = 49.25;
hole_space_y = 50.60;

hole_radius = 2.85/2;
hole_depth = 1.6;

activate_holes=true;

corner_remove_x = 8.75;
corner_remove_y = 5.25;

activate_corner_remove = true;


thickness = 6;
gap_width = 0.4;
gap_depth = 0.1;
teeth_depth = 8;
teeth_amount = 4;
//teeth_amount = 2;

size = [cube_size[0]-teeth_depth-gap_depth,cube_size[1]-teeth_depth-gap_depth,cube_size[2]];
clip_width_x = (size[0]/teeth_amount)/2;
clip_width_y = (size[1]/teeth_amount)/2;

hole_gap_to_frame_x = (size[0]-hole_space_x)/2;
hole_gap_to_frame_y = (size[1]-hole_space_y)/2;

module prism_x(l, w, h){
    translate([0,w/2,0]) cube([l,w/2,h]); 
    difference() {
    polyhedron(//pt 0        1        2        3        4        5
              points=[[0,0,h/2], [l,0,h/2], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
              faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
              );
        cube([l,w/6,h]);
    }
}

module prism_y(l, w, h){
     translate([0,w,0]) rotate([0,0,270]) prism_x(w,l,h);
}

module teeths () {
    module teeth(l, w, h) {
        d=gap_width;
        di=h/2; 
        da=h/2;
        
        module dron(end=false) {
            faces=[[0,1,2,3],[11,10,9,8],[0,4,5,1],[4,8,9,5],[1,5,6,2],[5,9,10,6],[2,6,7,3],[6,10,11,7],[3,7,4,0],[7,11,8,4]];
            if (!end) { 
                polyhedron(
                    points=[[d,0,0],[l+d,0,0], [l,w/4,0], [0,w/4,0], 
                        [di+d,0,h/2], [l+da+d,0,h/2], [l+da,w/4,h/2],[di,w/4,h/2],
                        [d,0,h], [l+d,0,h], [l,w/4,h],[0,w/4,h]],
                    faces=faces
              );
            } else {
                polyhedron(
                    points=[[d,0,0],[l,0,0], [l,w/4,0], [0,w/4,0], 
                        [di+d,0,h/2], [l+da,0,h/2], [l+da,w/3,h/2],[di,w/3,h/2],
                        [d,0,h], [l,0,h], [l,w/4,h],[0,w/4,h]],
                    faces=faces
             );
            }
        }
        
        dron(end=true);
        translate([0,w*2/4,0]) mirror([0,1,0]) dron();
        translate([0,w*2/4,0]) dron();
        translate([0,w*4/4,0]) mirror([0,1,0]) dron();
        
        
    }
    
    
    for(clip = [0:clip_width_x*2:size[0]-0.1]) {
        translate([clip,-teeth_depth,0]) teeth(clip_width_x, teeth_depth, size[2]);
    }
    
    
    
    intersection() {
        translate([0,size[1],0]) cube([size[0],size[1],size[2]]);
        mirror([0,1,0]) {
            for(clip = [0:clip_width_x*2:size[0]]) {
                translate([clip-clip_width_x,-size[1]-teeth_depth,0]) teeth(clip_width_x,  teeth_depth, size[2]);
            }
        }
    }
    
    for(clip = [0:clip_width_y*2:size[0]-0.1]) {
        translate([-teeth_depth, clip+clip_width_y*2,0]) rotate(270) teeth(clip_width_y, teeth_depth, size[2]);
    }
    
    intersection() {
        translate([size[0],0,0]) cube([size[0],size[1],size[2]]);
        mirror([1,0,0]) {
            for(clip = [0:clip_width_y*2:size[0]]) {
            translate([-teeth_depth-size[0], clip+clip_width_y,0]) rotate(270) teeth(clip_width_y, teeth_depth, size[2]);
            }
        }
    }
}




module cylinder_v() {
    
    h=cube_size[2]/2;
    l=hole_radius;
    hd = hole_depth;
    gr = 0.2;
    
    translate([0,0,-h]) cylinder(h=h*2,r=l+gr,center=true);
    translate([0,0,hd/2]) cylinder(h=hd,r1=l+gr,r2=l,center=true);
    translate([0,0,hd*1.25]) cylinder(h=hd/2,r1=l,r2=l+gr,center=true);
    translate([0,0,hd*1.75]) cylinder(h=hd/2,r1=l+gr,r2=l/2,center=true);
}

module frame() {
   
    translate([teeth_depth,teeth_depth,0]) {
    color("green") difference() {
        cube(size);
        translate([size[0]/2,size[1]/2,size[2]/2]) cube([size[0]-thickness*2,size[1]-   thickness*2,size[2]], center=true);
    }
    teeths();
    if(activate_holes) {
        //x1
        translate([hole_gap_to_frame_x,hole_gap_to_frame_y,cube_size[2]]) cylinder_v();
        translate([hole_gap_to_frame_x,hole_gap_to_frame_y+hole_space_y/2,cube_size[2]]) cylinder_v();
        translate([hole_gap_to_frame_x,size[1]-hole_gap_to_frame_y,cube_size[2]]) cylinder_v();


        //x2
        translate([size[0]-hole_gap_to_frame_x,size[1]-hole_gap_to_frame_y,cube_size[2]]) cylinder_v();
        translate([size[0]-hole_gap_to_frame_x,hole_gap_to_frame_y+hole_space_y/2,cube_size[2]]) cylinder_v();
        translate([size[0]-hole_gap_to_frame_x,hole_gap_to_frame_y,cube_size[2]]) cylinder_v();}
    }
  
}

if(activate_corner_remove) {
    difference() {
        translate([-teeth_depth/2,-teeth_depth/2,0]) frame();
        translate([0,-corner_remove_y,0]) cube([corner_remove_x,corner_remove_y,cube_size[2]]);
        translate([0,cube_size[1]-corner_remove_y,0]) cube([corner_remove_x,corner_remove_y*2/*remove unnessecary overhang*/,cube_size[2]]);
        translate([cube_size[0]-corner_remove_x,0,0]) cube([corner_remove_x,corner_remove_y,cube_size[2]]);
        translate([cube_size[0]-corner_remove_x,cube_size[1],0]) cube([corner_remove_x,corner_remove_y,cube_size[2]]);
    }
} else {frame();}

