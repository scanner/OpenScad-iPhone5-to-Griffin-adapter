use <Libs.scad>;

padding = 0.05;

iphone6_width = 67.8;
iphone6_length = 138.1;
iphone6_height = 7.6;
iphone6_radius = 9.3;

iphonex_width = 71.0;
iphonex_length = 143.6;
iphonex_height = 7.8;
iphonex_radius = 9.3;

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

iphone5_headphone_plug_offset = 11.46;
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

// if (connector_test == true) {
//     block_front_h = 18;
// } else {
//     block_front_h = 60;
// }
block_front_h = 60;

block_front_w = iphonex_width + (wall_thickness * 2);
block_front_d = iphonex_height + (wall_thickness * 2);

headphone_plug_top_r = 8.2 / 2;
headphone_plug_hex_w = 9.2;
headphone_plug_hex_h = 17;
headphone_plug_top_h = 5.4;
headphone_plug_h = headphone_plug_top_h + headphone_plug_hex_h - 1;

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
            cylinder(h = height, r = side_radius, $fn = 20);
        }
        translate(v = [-(base_width / 2), 0, -(height / 2)]) {
            cylinder(h = height, r = side_radius, $fn = 20);
        }
    }

    // the connector is a cylinder that connects to the back.. we also
    // draw a cube below it because this needs to cut out the slot in
    // the iphone mount that will slide on to this connector.
    //
    // the height does not matter that much...
    //
    translate(v = [0,(height/2)-9.3-connector_radius,0]) {
        cylinder(h = 26, r = connector_radius);
    }
    translate(v = [0, -(connector_radius+0.9),12]) {
        cube(size = [connector_radius * 2,
                0.9+ (height/2) + ((height/2)-(9.3)-connector_radius),
                27.9], center = true);
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

module car_mount_cap() {
    depth = 21;
    height = 30;
    connector_radius = 6.625;
    rotate([90,0,0]) {
        roundRect([(connector_radius*2)+6, (height/2)+6, 22], round=3, center=true);
    }
}
