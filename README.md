OpenScad-iPhone5-to-Griffin-adapter
===================================

Simple temporary make-shift set of things that lets me plug iPhone5 in to car using existing griffin car docks that I have.

Uses the Libs.scad library which is included in the repository.


There are three versions:

Version 1: The scad file is fairly modular so you could take and 'iphone5 mount' part out and provide the scad code for your own mount.

The phono jack hole is designed specifically for some cables I have that have a hex shaped jacket with a cylinder on top. If anyone finds this design useful chances are they will need to design a new phono plug cutout.

Both the phono plug and the lightning adapter are friction fit, but the lightning adapter has a floor so it can not go any lower than it already is. The phono jack could be pushed out a bit if the fit is not tight enough or it is not positioned quite correctly.

If the 'connector_test' variable is set to be true the scad produced at the end is clipped such that printing copies and testing the fit of the lightning adapter and phono plug are good without having to go through the entire print.

Version 2: If you have a 30 pin to lightning adapter this lets you plug it directly in to the griffin dock without having to run separate lightning and audio cables.

Version 3: If you have the much older griffin tuneflex and a 30 pin adpater this slots in to the tuneflex and lets you dock your iphone5.
