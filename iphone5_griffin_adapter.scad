//
// Adapter that uses a griffin stand as platform to hook our iphone5 to. This
// is temporary in that it just uses the griffin as a hook. Lightning cable is
// routed by itself as well as an audio plug to pull sound out of the iphone in
// to the car stereo's AUX in.
//
use <Libs.scad>;

padding = 0.05;

dock_hitch_h = 21;
pin30_adapter_h = 6;
iphone5_depth = 8.1;
iphone5_width = 59.57;
iphone5_height = 123.83;
iphone5_glass_depth = 0.4;

iphone5_mic_w = 7.2;
iphone5_mic_d = 2.59;
iphone5_mic_offset = 13.92;

iphone5_spkr_w = 11.96;
iphone5_spkr_d = 2.59;
iphone5_spkr_offset = 9.23;

iphone5_headphone_plug_offset = 10.46;
iphone5_hp_neg_offset = -((iphone5_width/2) - iphone5_headphone_plug_offset);
iphone5_screen_w = 53;
iphone5_screen_h = 90.39;
iphone5_screen_offset = 16.72;
home_button_r = 10.9 / 2;
home_button_offset = 9.15;
screen_cutout_h = 5;

lightning_w = 8.2;
lightning_d = 5;
lightning_h = 12;
lightning_cable_r = 2.5/2;
lightning_strain_relief_r = 4.1/2;

// The offsets are from the left side of the device
//
audio_jack_center_offset = 10.46;
audio_jack_r = 4.83 / 2;
lightning_width = 9.05;
lightning_edge_offset = 24.75;
lightning_keepout_d = 6.85;
lightning_keepout_w = 10.02;
lightning_edge_r = 3.4;

iphone_from_bottom_offset = 15;
wall_thickness = 3;
adapter_d = 15.9 + wall_thickness;

block_back_w = 40;
block_back_d = 15;
block_back_h = 23;

block_bottom_d = iphone5_depth + (wall_thickness * 2) + adapter_d;
block_bottom_h = 25;

// block_front_h = 60;
block_front_h = 18;
block_front_w = iphone5_width + (wall_thickness * 2);
block_front_d = iphone5_depth + (wall_thickness * 2);

headphone_plug_top_r = 8.3 / 2;
headphone_plug_hex_w = 9.3;
headphone_plug_hex_h = 17;
headphone_plug_top_h = 4.73;
headphone_plug_h = headphone_plug_top_h + headphone_plug_hex_h - 1;

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
// We use the iphone5 model from http://www.thingiverse.com/thing:30471
// by http://www.thingiverse.com/hisashikun
//
module iphone5() {
    import("iPhone5_cg_model.stl");
}

/////////////////////////////////////////////////////////////////////////////
//
// The thing in the car that our sleeve/adapter slides on to.
//
// It has rounded x edges.
// it is 25.96mm wide (x)
// it is 24mm tall (y)
// it is 6.85mm deep (z)
// there is ball bearing on the left and ride sides 3.4mm from the bottom
// this ball bearing is 3.16mm in diameter
// the connector on the back is a cylinder that is 13.25mm in diameter
// it is 15.19 mm from the bottom to the top of the back connector
// thus it is 8.81mm from the top to the top of the back connector.
// it's bottom height is not really important, what is important is the
// distance from the top to the back connector because that is where it
// mates with the iphone stuck in to the dock.
//
module vertical_car_mount() {
    translate(v=[0,0,30/2]) {
        rotate([90,0,180]) {
            car_mount();
        }
    }
}

module car_mount() {
    // since all the important measurements that we want to offset from are
    // the -top- of the car mount we call that y position 0. we really do
    // not care how tall this all is, as long as the measurements from the
    // top of the connector are right.
    //
    height = 30;
    depth = 7;
    // base_width = 17.15;
    base_width = 20.1;
    connector_radius = 6.625;
    side_radius = 3.525;
    dimple_radius = 1.55;

    cube(size = [base_width, height, depth], center = true);

    // the left and right sides are rounded.
    //
    rotate([90,0,0]) {
        translate(v = [base_width / 2, 0, -(height / 2)]) {
            cylinder(h = height, r = side_radius);
        }
        translate(v = [-(base_width / 2), 0, -(height / 2)]) {
            cylinder(h = height, r = side_radius);
        }
    }

    // the connector is a cylinder that connects to the back.. we also
    // draw a cube below it because this needs to cut out the slot in
    // the iphone mount that will slide on to this connector.
    //
    // the height does not matter that much...
    //
    translate(v = [0,(height/2)-9.3-connector_radius,0]) {
        cylinder(h = 15, r = connector_radius);
    }
    translate(v = [0, -(connector_radius+0.9),15/2]) {
        cube(size = [connector_radius * 2,
                0.9+ (height/2) + ((height/2)-(9.3)-connector_radius),
                15], center = true);
    }

    // and the dimples on the left and ride sides are 18.78mm from the
    // top.  even though they are spheres on each side of the connector
    // we are going to use a cylinder because the hole this will make
    // when we subtract this will be good enough.
    //
    dimple_length = base_width + (2*side_radius) + 4*dimple_radius;
    translate(v = [-(dimple_length/2),(height/2)-dimple_radius-18.78,0]) {
        rotate([0,90,0]) {
            cylinder(h = dimple_length, r = dimple_radius, $fn = 10);
        }
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
        // translate( v = [0,0,block_back_h/2] ) {
        //     roundRect(size = [block_back_w, block_back_d, block_back_h],
        //         round = 3, center = true);
        // }
    }

     translate( v = [0, -((block_back_d/2)+wall_thickness),iphone_from_bottom_offset]) {
        iphone5_cutout();
     }
     // translate( v= [0,1.4,-6]) {
     //     vertical_car_mount();
     // }
     translate( v = [8,-20,-1]) {
         cube([35,20,25]);
     }
 }
}

iphone_adapter();
// iphone5_cutout();
// headphone_plug();
// lightning_plug();
// lightning_cable_cutout(30);
