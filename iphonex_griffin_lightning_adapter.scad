//
// Adapter that uses a griffin stand as platform to hook our iphone5 to. This
// is temporary in that it just uses the griffin as a hook. Lightning cable is
// routed by itself as well as an audio plug to pull sound out of the iphone in
// to the car stereo's AUX in.
//
v="1.5";

use <Libs.scad>;
include <common_elements.scad>;
include <iPhone_6_and_6_Plus_Mockups.scad>;

connector_test = false;
iphone_holder_xoff = 0;
iphone_holder_yoff = 0;
iphone_holder_zoff = 42.5;

speaker_width = 12;
speaker_depth = 3;
griffin_lightning_height = 10;
griffin_lightning_corner_r = 1;
griffin_lightning_width = 5;
griffin_lightning_depth = 4;
griffin_cable_r = 2;

tp_height = 27;
tp_z_offset = 33;

nb_h = (block_front_h-40) + tp_z_offset + tp_height;

// If you put a dbrand skin on your iphone6 we need to make the cutout
// just a little bit larger. Set this to '0' if you do not have a dbrand skin.
//
/* dbrand_thickness = 0.4; */
/* w_d = iphone6_width + (dbrand_thickness * 2); */
/* l_d = iphone6_length + dbrand_thickness; */
/* h_d = iphone6_height; */
/* r_d = iphone6_radius; */

dbrand_thickness = 0.0;
w_d = iphonex_width + (dbrand_thickness * 2);
l_d = iphonex_length + dbrand_thickness;
h_d = iphonex_height;
r_d = iphonex_radius;


/////////////////////////////////////////////////////////////////////////////
//
// the cut out for the lightning cable.
//
module lightning_cable_cutout(height, cable_r, strain_r) {
    translate( v = [0,0,height/2] ) {
        union() {
            cylinder( h = height, r = strain_r, center = true, $fn = 16 );
            translate( v = [0,-(10/2),0]) {
                cube([cable_r*2, 10, height], true);
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
//
// The body of griffin lightning adapter is a rounded rect and is
// larger than the regular lightning cable head (although the top if
// identical to a lighting cable head, that does not matter here.
//
module lightning_plug(h, w, d) {
    translate( v = [0,0,h/2] ) {
        roundRect( size = [w, d, h],
            round = d / 2, center = true);
    }
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
module iphonex_cutout() {
     union() {
          iphone(w_d,l_d,h_d,r_d);

          // screen projection forward goes here...
          //
          translate([(h_d / 2)-1.5, (home_button_diameter * 1.5)-15.8, h_d - 1]) {
               cube([iphonex_width - iphonex_height +3, 30, 20]);
          }
          translate([4.5,10,0]) {
               cube([iphonex_width-9,30,5]);
          }
          translate([2.5,0,10]) {
               rotate([0,90,0]) {
                    cylinder(h = iphonex_width-5, r = 2.5, $fn=20);
               }
          }
          /* cube(iphonex); */
          /* // Home button cutout */
          /* // */
          /* translate(v = [w_d/2,11,4]) { */
          /*      rotate([0,0,0]) { */
          /*           cylinder( h = iphone5_depth, r = home_button_r + 4); */
          /*      } */
          /* } */
     }
}

/////////////////////////////////////////////////////////////////////////////
//
module iphone_adapter() {
    difference() {
        union() {
            if (!connector_test) {
                translate(v=[0,17+11,7]) {
                    car_mount_cap();
                }
                // The block that goes around the car mount.
                //
                translate( v = [0,11,block_back_h/2] ) {
                    roundRect(size = [block_back_w-6, block_back_d-2.9, block_back_h],
                        round = 3, center = true);
                }
            }
            intersection() {
                // When doing test prints cut off the top of the entire thing
                // so we have less to print.
                //
                if (connector_test) {
                    translate( v = [0,0,12.5]) {
                        cube([48,20,25], center=true);
                    }
                }

                translate(v=[0,0,0]) {
                    cylinder(h = nb_h-10, r1 = 18, r2 = (block_front_w/2) + 12, $fn = 80);
                }
                difference() {
                    union() {
                        translate( v = [iphone_holder_xoff,
                                iphone_holder_yoff, nb_h/2]) {
                            // The external walls of our holder
                            //
                            roundRect(size = [block_front_w, block_front_d,
                                    nb_h],
                                round = 3, center = true);
                        }
                    }

                    translate(v=[0,0,iphone_holder_zoff+0.5]) {
                        iphone5_cutout();
                    }

                    translate( v = [iphone_holder_xoff,
                            iphone_holder_yoff,
                            iphone_holder_zoff-1.5]) {
                        translate(v=[-w_d/2, h_d/2, 2]) {
                            rotate([90,0,0]) {
                                 iphonex_cutout();
                            }
                        }
                    }
                    // expose the back of the iphone for cooling and
                    // antenna exposure.
                    //
                    translate( v = [0,5,64] ) {
                        cube([55, 10, 40], true);
                    }
                }
            }
        }

        // Debugging code.. we skip this if we are just trying to make
        // sure the connector fits properly
        //
        if (connector_test == false) {
            union() {
                translate( v= [0,11,-6]) {
                    vertical_car_mount();
                }
            }
        }

        // And cut out the griffin lighting adapter
        //
        translate(v=[0,0,25]) {
            lightning_plug(19.5, 10.7, 6.3);
        }
        translate(v=[0,0,-1]) {
            rotate([0,0,180]) {
                lightning_cable_cutout(50, 1.7, 2.7);
            }
        }

        // and cut out rounded rects for the speaker and mic so we can
        // say "hey siri" while the iphone is plugged in.
        //
        translate(v=[-16,-6,42.5]) {
            rotate([0,90,0]) {
                roundRect(size=[5, 15, speaker_width], round = 5/2, center = true);
            }
        }
        translate(v=[16,-6,42.5]) {
            rotate([0,90,0]) {
                roundRect(size=[5, 15, speaker_width], round = 5/2, center = true);
            }
        }

        // And clip off anything below z == 0 to provide a clean
        // bottom so we do not hvae to worry about various
        // protrusions.
        translate(v=[0,0,-20]) {
            cube([40,80,40], center=true);
        }
    }
}

/* difference() { */
/*      translate(v=[0,0,-38]) { */
iphone_adapter();
/*     } */
/*      translate(v=[0,0,-40]) { */
/*           cube([100,100,80], true); */
/*      } */
/* } */


// headphone_plug();
// lightning_plug();
// lightning_cable_cutout(30);
