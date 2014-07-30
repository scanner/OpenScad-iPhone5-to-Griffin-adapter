//
// Adapter that uses a griffin stand as platform to hook our iphone5 to. This
// is temporary in that it just uses the griffin as a hook. Lightning cable is
// routed by itself as well as an audio plug to pull sound out of the iphone in
// to the car stereo's AUX in.
//
use <Libs.scad>;
include <common_elements.scad>;

connector_test = false;
iphone_holder_xoff = 0;
iphone_holder_yoff = 0;
iphone_holder_zoff = 42.5;

tp_depth = 6.4;
tp_height = 19.87;
tp_width = 26.5;
tp_z_offset = 33;

nb_h = (block_front_h-40) + tp_z_offset + tp_height;

/////////////////////////////////////////////////////////////////////////////
//
module 30pin_adapter() {
    $fn = 20;
    roundRect(size = [tp_width, tp_depth, tp_height], round = 5.65/2, center = true);
}

/////////////////////////////////////////////////////////////////////////////
//
module iphone5_cutout() {
    union() {
        translate(v = [0,0,iphone5_height / 2]){
            rotate([90,0,0]) {
                roundRect(size = [iphone5_width, iphone5_height, iphone5_depth],
                    round = 9, center = true);
            }
        }

        // The screen is really a cutout from the front of our holder, so we
        // want it to extend a little further down thant he screen actually
        // does.
        //
        translate(v = [0,-(wall_thickness + padding),(iphone5_screen_h/2)+(iphone5_screen_offset-(screen_cutout_h/2))] ) {
            // translate(v = [0,0,0] ) {
            cube([iphone5_screen_w, iphone5_depth+1,iphone5_screen_h + screen_cutout_h], center = true);
        }
        // The home button is mostly just in here for reference.
        //
        translate(v = [0,0,home_button_offset]) {
            rotate([90,0,0]) {
                cylinder( h = iphone5_depth+wall_thickness, r = home_button_r);
            }
        }
        // The cutout is larger than the home button and we wantit to extend up
        // to the bottom of the where the screen should be.
        //
        translate(v = [0,0,home_button_offset + 2]) {
            rotate([90,0,0]) {
                cylinder( h = iphone5_depth, r = home_button_r + 4);
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
//
module iphone_adapter() {
    difference() {
        union() {
            translate(v=[0,17,7]) {
                car_mount_cap();
            }
            intersection() {
                cylinder(h = nb_h, r1 = 18, r2 = (block_front_w/2) + 12, $fn = 80);
                difference() {
                    union() {
                        translate( v = [iphone_holder_xoff,
                                        iphone_holder_yoff, nb_h/2]) {
                            roundRect(size = [block_front_w, block_front_d,
                                              nb_h],
                                      round = 3, center = true);
                        }
                    }

                    translate( v = [iphone_holder_xoff, iphone_holder_yoff,
                                    iphone_holder_zoff]) {
                        iphone5_cutout();
                    }
                    translate( v = [0,5,64] ) {
                        cube([42, 10, 40], true);
                    }
                }
            }
        }
        if (connector_test == false) {
            union() {
                translate( v= [0,0,-6]) {
                    vertical_car_mount();
                }
                translate( v = [0, 0, tp_z_offset-padding] ) {
                    30pin_adapter();
                }
            }
        }
        if (connector_test) {
            translate( v = [8,-20,-1]) {
                cube([35,20,25]);
            }
        }
        translate(v=[0,0,-20]) {
        cube([40,80,40], center=true); }
    }
}

iphone_adapter();
// iphone5_cutout();
// headphone_plug();
// lightning_plug();
// lightning_cable_cutout(30);
