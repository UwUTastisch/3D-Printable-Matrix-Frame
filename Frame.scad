cube_size = [65.25,66.5,5];

//cube_size = [20,20,5];

thickness = 6;
gap_width = -0.15;
gap_depth = 0.3;
clip_depth = 5;
teeth_amount = 4;

clip_depth_ = clip_depth+gap_depth;
size = [cube_size[0]-clip_depth_-gap_depth,cube_size[1]-clip_depth_-gap_depth,cube_size[2]];
clip_width_x = (size[0]/teeth_amount)/2;
clip_width_y = (size[1]/teeth_amount)/2;




module teeth () {
    for(clip = [0:clip_width_x*2:size[0]-0.1]) { 
        translate([clip+gap_width/2,-clip_depth_-gap_depth,0]) cube([clip_width_x-gap_width, clip_depth_, size[2]]);
        translate([clip,-gap_depth,0]) cube([clip_width_x, gap_depth, size[2]]);
    }
    for(clip = [clip_width_y:clip_width_y*2:size[0]-0.1]) {
        translate([-clip_depth_-gap_depth,clip+gap_width/2,0]) cube([clip_depth_, clip_width_y-gap_width, size[2]]);
        translate([-gap_depth,clip,0]) cube([gap_depth, clip_width_y, size[2]]);
    }
}
difference() {
    cube(size);
    translate([size[0]/2,size[1]/2,size[2]/2]) cube([size[0]-thickness*2,size[1]-thickness*2,size[2]], center=true);
  }
teeth();
translate([size[0]-0.001, size[1]-0.001,0]) rotate([0,0,180]) teeth();