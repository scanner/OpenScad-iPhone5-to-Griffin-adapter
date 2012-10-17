//
// Adapter that uses a griffin stand as platform to hook our iphone5 to. This
// is temporary in that it just uses the griffin as a hook. Lightning cable is
// routed by itself as well as an audio plug to pull sound out of the iphone in
// to the car stereo's AUX in.
//
use <Libs.scad>;
include <common_elements.scad>;

connector_test = false;

/////////////////////////////////////////////////////////////////////////////
//
// the cut out for the lightning cable.
//
module lightning_cable_cutout(height) {
    translate( v = [0,0,height/2] ) {
        union() {
            cylinder( h = height, r = lightning_strain_relief_r, center = true, $fn = 16 );
            translate( v = [0,-(height/2),0]) {
                cube([lightning_cable_r*2, height, height], true);
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
//
// the base of the headphone plug we are using.. which has a cylindrical top
// and then a hexagonal base that appears to be 1mm wider than the cylinder. My
// idea is make this a friction fit that is tight enough that plugging the
// iphone in and out does not cause it to sink down.
//
module headphone_plug() {
    union() {
        translate( v = [0,0,headphone_plug_hex_h - padding] ) {
            cylinder( h = headphone_plug_top_h + padding, r = headphone_plug_top_r, $fn = 20 );
        }
        hex(width = headphone_plug_hex_w, height = headphone_plug_hex_h, flats = true, center = false);

    }
}

/////////////////////////////////////////////////////////////////////////////
//
// Like the headphone plug we need a shape sized to the lightning connector
// with a nice tight fit. It is actually oval shaped, but a rounded rectangle
// is good enough since the size is small and we want a tight fit.
//
module lightning_plug() {
    translate( v = [0,0,lightning_h/2] ) {
        roundRect( size = [lightning_w, lightning_d, lightning_h],
            round = lightning_d / 2, center = true);
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

        // and we stick on the plugs for the headphone cable
        //
        translate( v = [iphone5_hp_neg_offset,iphone5_glass_depth,-(headphone_plug_h-padding)] ) {
            headphone_plug();
        }

        // And the lightning cable - centered on the bottom of the iphone.
        //
        translate( v = [0,iphone5_glass_depth,-(lightning_h-padding)] ) {
            lightning_plug();
        }

        // And we have this -huge- cutout for the cable.. it has to cut through
        // the same face that the home button does, and all the way out the
        // bottom. This will look a bit odd when mounted in real life but it
        // gives the lightning connector a solid bottom so it can not be pushed
        // out and basically a gap to thread the cable into.
        //
        translate( v = [0,iphone5_glass_depth,-25] ) {
            lightning_cable_cutout(30);
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
//
module iphone_adapter() {
    difference() {
    union() {
        translate( v = [0,-((block_back_d/2)+wall_thickness),block_front_h/2] ) {
            roundRect(size = [block_front_w, block_front_d, block_front_h],
                round = 3, center = true);
        }
        if (connector_test == false) {
            translate( v = [0,0,block_back_h/2] ) {
                roundRect(size = [block_back_w, block_back_d, block_back_h],
                    round = 3, center = true);
            }
        }
    }

     translate( v = [0, -((block_back_d/2)+wall_thickness),iphone_from_bottom_offset]) {
        iphone5_cutout();
     }
     if (connector_test == false) {
         translate( v= [0,1.4,-6]) {
             vertical_car_mount();
         }
     }
     if (connector_test) {
         translate( v = [8,-20,-1]) {
             cube([35,20,25]);
         }
     }
 }
}

iphone_adapter();
// iphone5_cutout();
// headphone_plug();
// lightning_plug();
// lightning_cable_cutout(30);
