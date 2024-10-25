$fn = 20;

cube_size = [65.25,66.5,5];

hole_space_x = 49.25;
hole_space_y = 50.60;

hole_radius = 2.85/2;
hole_depth = 1.6;

corner_remove_x = 8.75;
corner_remove_y = 5.25;

//cube_size = [20,20,5];

thickness = 6;
gap_width = -0.1;
gap_depth = 2.6;
clip_depth = 2.5;
teeth_amount = 4;

clip_depth_ = clip_depth;
size = [cube_size[0]-clip_depth_-gap_depth,cube_size[1]-clip_depth_-gap_depth,cube_size[2]];
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

module teeth () {
    for(clip = [0:clip_width_x*2:size[0]-0.1]) { 
        //translate([clip+gap_width/2,-clip_depth_-gap_depth,0]) cube([clip_width_x-gap_width, clip_depth_, size[2]]);
        translate([clip,-gap_depth,0]) cube([clip_width_x, gap_depth, size[2]]);
        translate([clip+gap_width/2,-clip_depth_-gap_depth,0]) prism_x(clip_width_x-gap_width, clip_depth_, size[2]);
        translate([clip_width_x+clip, 0,0]) mirror([0,1,0]) difference() { 
            cube([clip_width_x, gap_depth, size[2]]);
            prism_x(clip_width_x, gap_depth, size[2]);
        }
    }
    for(clip = [clip_width_y:clip_width_y*2:size[0]-0.1]) {
        //translate([-clip_depth_-gap_depth,clip+gap_width/2,0]) cube([clip_depth_, clip_width_y-gap_width, size[2]]);
        translate([-gap_depth,clip,0]) cube([gap_depth, clip_width_y, size[2]]);
        translate([-clip_depth_-gap_depth,clip+gap_width/2,0]) prism_y(clip_depth_, clip_width_y-gap_width, size[2]);
        translate([0,clip-clip_width_y,0]) mirror([]) difference() { 
            cube([gap_depth, clip_width_y, size[2]]);
            prism_y(gap_depth, clip_width_y, size[2]);
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
    /*
    module holder() {
            cylinder(h=h*2,r=l,center=true);
            scale([hole_radius/(hole_radius+gr),1,1]) translate([0,0,h-gr/2]) cylinder(h=gr,r1=l+gr,r2=l,center=true);
        }
    
    difference() {
        holder();
        polyhedron(//pt 0        1        2        3        4        5
        points=[[-l-gr,0,0], [l+gr,0,0], [l+gr,-l+gr,h], [-l-gr,-l+gr,h], [-l-gr,l-gr,h], [l+gr,l-gr,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
        
    
    }*/
}

module frame() {
    translate([gap_depth,gap_depth,0]) {
    difference() {
        cube(size);
        translate([size[0]/2,size[1]/2,size[2]/2]) cube([size[0]-thickness*2,size[1]-   thickness*2,size[2]], center=true);
    }
    teeth();
    translate([size[0]-0.001, size[1]-0.001,0]) rotate([0,0,180]) teeth();
    
    //x1
    translate([hole_gap_to_frame_x,hole_gap_to_frame_y,cube_size[2]]) cylinder_v();
    translate([hole_gap_to_frame_x,hole_gap_to_frame_y+hole_space_y/2,cube_size[2]]) cylinder_v();
    translate([hole_gap_to_frame_x,size[1]-hole_gap_to_frame_y,cube_size[2]]) cylinder_v();


    //x2
    translate([size[0]-hole_gap_to_frame_x,size[1]-hole_gap_to_frame_y,cube_size[2]]) cylinder_v();
    translate([size[0]-hole_gap_to_frame_x,hole_gap_to_frame_y+hole_space_y/2,cube_size[2]]) cylinder_v();
    translate([size[0]-hole_gap_to_frame_x,hole_gap_to_frame_y,cube_size[2]]) cylinder_v();}
  
}

difference() {
    frame();
    translate([0,-corner_remove_y,0]) cube([corner_remove_x,corner_remove_y,cube_size[2]]);
    translate([0,cube_size[1]-corner_remove_y,0]) cube([corner_remove_x,corner_remove_y,cube_size[2]]);
    translate([cube_size[0]-corner_remove_x,0,0]) cube([corner_remove_x,corner_remove_y,cube_size[2]]);
    translate([cube_size[0]-corner_remove_x,cube_size[1],0]) cube([corner_remove_x,corner_remove_y,cube_size[2]]);
}

