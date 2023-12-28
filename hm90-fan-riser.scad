// HM90 Fan Riser: holds two fans (40mm x 25mm) to cool the lower inside of an HM90 Mini PC
// OpenSCAD units are millimeters

/****************
BSD 2-Clause License

Copyright (c) 2023, mattklapman

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*****************/

include <Chamfers-for-OpenSCAD/Chamfer.scad>;

wallThickness = 3; // used for the tray bottom; thick enough to have an internal truss to reduce warping over time (15% infill)
wallThicknessMin = 1.5;

clearance = 0.3; // allow some space as 3D printing isn't perfect

// from a horizontal view looking at the front
hm90Width = 149.5 + clearance;  // measurement left to right
hm90Length = 149.5 + clearance; // measurement front to back
hm90Height = 50 + 3.5 + clearance; // with feet
hm90Radial = 10; // corners (eyeballed)

hm90VentWidth = 75.5;
hm90VentLength = 45.3; // through holes are actually smaller
hm90VentOffset = 17; // from front to start of length

fanWidth = 40;
fanLength = 40;
fanHeight = 10.3; // does not include any wireframe around it
fanCableDiameter = 3;
fanCableOffset = 6; // short distance of outside cable to edge of fan

// fan dongle must pass through hole
fanCablePassthroughX = 23.1 + 1;
fanCablePassthroughY = 15 + 1;

standRadial = hm90Radial;
hm90shelf = 3.5 + 1 + 2.5; // depth of hm90 into the base
bottomAirGap = 7; // height off of the desk to allow airflow

$fn=60; // number of resolved facets on curves
renderHelp = 0.001; // used during development to correct visual artifacts in OpenSCAD (OK to print with this)

module tray()
{
    difference()
    {
        // tray
        translate([0, 0, bottomAirGap + wallThicknessMin + fanHeight - wallThickness + (hm90shelf + wallThickness)/2]) cubeRadial(hm90Width, hm90Length, (hm90shelf + wallThickness), standRadial, 1);
        union()
        {
            // tray inset
            translate([0, 0, bottomAirGap + wallThicknessMin + fanHeight + hm90Height/2]) cubeChamferRoundTopBot(hm90Width, hm90Length, hm90Height, hm90Radial);
            
            // vent(s)
            translate([0, 0, 0.014]) fans(); // I do not know why there is a 0.014mm error here
            fans();
            
        }
    }
}

module fanSupport()
{
    // outside skirt
    difference()
        {
            translate([0, 0, bottomAirGap + (fanHeight + wallThicknessMin - wallThickness)/2]) cubeRadial(hm90Width, hm90Length, fanHeight + wallThicknessMin - wallThickness, standRadial, 1);
            translate([0, 0, bottomAirGap + (fanHeight + wallThicknessMin - wallThickness)/2]) cubeRadial(hm90Width - 2*wallThickness, hm90Length - 2*wallThickness, fanHeight + wallThicknessMin - wallThickness + 2*renderHelp, standRadial, 1);
        }
    
    // fan cavity
    difference()
    {
        union()
        {
            translate([0, -hm90Length/4, bottomAirGap + (fanHeight + wallThicknessMin - wallThickness)/2]) cubeRadial(hm90Width, hm90Length/2, fanHeight + wallThicknessMin - wallThickness, standRadial, 1);
            // clean up the inner rounded corners
            translate([0, -hm90Length/8, bottomAirGap + (fanHeight + wallThicknessMin - wallThickness)/2]) cube([hm90Width, hm90Length/4, fanHeight + wallThicknessMin - wallThickness], center=true);
        }
        union()
        {
            fans();
            translate([0, 0, -wallThicknessMin]) fans();
        }
    }
}

module fanMounts()
{
    translate([-(wallThicknessMin/2 + fanWidth/2), -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThicknessMin/2])
        fanMountCorners();
    translate([(wallThicknessMin/2 + fanWidth/2), -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThicknessMin/2])
        fanMountCorners();
}
module fanMountCorners()
{
    difference()
    {
        // corner shelves
        linear_extrude(height=wallThicknessMin, center=true)
            difference()
            {
                square([fanWidth + clearance, fanLength + clearance], center=true);
                circle(d=38);
            }
        // holes
        translate([(fanWidth/2 - 4), (fanLength/2 - 4), 0]) cylinder(h=2*wallThicknessMin, d=4, center=true);
        translate([(fanWidth/2 - 4), -(fanLength/2 - 4), 0]) cylinder(h=2*wallThicknessMin, d=4, center=true);
        translate([-(fanWidth/2 - 4), (fanLength/2 - 4), 0]) cylinder(h=2*wallThicknessMin, d=4, center=true);
        translate([-(fanWidth/2 - 4), -(fanLength/2 - 4), 0]) cylinder(h=2*wallThicknessMin, d=4, center=true);

        // countersinks
        translate([(fanWidth/2 - 4), (fanLength/2 - 4), -wallThicknessMin/2]) cylinder(h=2, d1=6.6, d2=4, center=true);
        translate([(fanWidth/2 - 4), -(fanLength/2 - 4), -wallThicknessMin/2]) cylinder(h=2, d1=6.6, d2=4, center=true);
        translate([-(fanWidth/2 - 4), (fanLength/2 - 4), -wallThicknessMin/2]) cylinder(h=2, d1=6.6, d2=4, center=true);
        translate([-(fanWidth/2 - 4), -(fanLength/2 - 4), -wallThicknessMin/2]) cylinder(h=2, d1=6.6, d2=4, center=true);        
    }
}

module feet()
{
    // corner cube stands
    standCornerWidth = (hm90Width - max(hm90VentWidth, 2*fanWidth + wallThicknessMin))/2;
    standCenterWidth = 2*(hm90Length/2 - hm90VentOffset - hm90VentLength);
    // center circle stand
    translate([-(hm90Width/2 - standCornerWidth/2), -(hm90Width/2 - standCornerWidth/2), bottomAirGap/2])
        cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap, standRadial, 1);
    translate([-(hm90Width/2 - standCornerWidth/2), (hm90Width/2 - standCornerWidth/2), (bottomAirGap + wallThicknessMin + fanHeight - wallThickness)/2])
        cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap + wallThicknessMin + fanHeight - wallThickness, standRadial, 1);
    translate([(hm90Width/2 - standCornerWidth/2), -(hm90Width/2 - standCornerWidth/2), bottomAirGap/2])
        cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap, standRadial, 1);
    translate([(hm90Width/2 - standCornerWidth/2), (hm90Width/2 - standCornerWidth/2), (bottomAirGap + wallThicknessMin + fanHeight - wallThickness)/2])
        cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap + wallThicknessMin + fanHeight - wallThickness, standRadial, 1);
}

module fans()
{
    translate([-wallThicknessMin/2 - fanWidth/2, -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThicknessMin + fanHeight/2]) cubeRadial(fanWidth + clearance, fanLength + clearance, fanHeight + 2*renderHelp, 2, 1);
    translate([+wallThicknessMin/2 + fanWidth/2, -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThicknessMin + fanHeight/2]) cubeRadial(fanWidth + clearance, fanLength + clearance, fanHeight + 2*renderHelp, 2, 1);
}

/****************
// Main
*****************/
// difference is to create the fan cable rounting
difference()
{
    union()
    {
        tray();
        color("red") fanSupport();
        fanMounts();
        feet();
    }
    // cable dongle hole
    translate([0, fanCablePassthroughY/2, 0]) cubeRadial(fanCablePassthroughX, fanCablePassthroughY, hm90Height, 1, 1);

    // cable channel to fans
    zHeight = bottomAirGap + wallThicknessMin + fanHeight + wallThickness - fanHeight/2; //helper
    hull()
    {
        translate([0, 0, zHeight]) cylinder(h=fanHeight/2 + fanCableDiameter + clearance, d=fanCableDiameter + clearance, center=true);
        translate([(fanCableOffset + wallThicknessMin/2), -hm90Length/2 + hm90VentOffset + hm90VentLength - wallThicknessMin - 4*clearance, zHeight]) cylinder(h=fanHeight/2 + fanCableDiameter + clearance, d=fanCableDiameter + clearance, center=true);
    }
    hull()
    {
        translate([0, 0, zHeight]) cylinder(h=fanHeight/2 + fanCableDiameter + clearance, d=fanCableDiameter + clearance, center=true);
        translate([-(fanCableOffset + wallThicknessMin/2), -hm90Length/2 + hm90VentOffset + hm90VentLength - wallThicknessMin - 4*clearance, zHeight]) cylinder(h=fanHeight/2 + fanCableDiameter + clearance, d=fanCableDiameter + clearance, center=true);
    }
}

// uncomment to see the fan outline in the model
//color("blue") fans();

// uncomment to see the planes where slicing should occur
echo("Bambu/Prusa Slicing Instructions:");
echo("1. Slice off feet at height: ", bottomAirGap);
//color([0.5, 0.5, 0.5, 0.5]) translate([0, 0, bottomAirGap]) cube([2*hm90Width, 2*hm90Length, renderHelp], center=true);
echo("2. Slice off tray at height: ", wallThicknessMin + fanHeight - wallThickness);
//color([0.5, 0.5, 0.5, 0.5]) translate([0, 0, bottomAirGap + wallThicknessMin + fanHeight - wallThickness]) cube([2*hm90Width, 2*hm90Length, renderHelp], center=true);

/****************
// Primatives
*****************/

// cube chamfered with round mitered corners on the top and bottom
module cubeChamferRoundTopBot(sizeX, sizeY, sizeZ, chamferRadius)
{
    difference()
    {
        translate([-sizeX/2, -sizeY/2, -sizeZ/2]) chamferCube([sizeX, sizeY, sizeZ], [[1, 1, 1, 1], [1, 1, 1, 1], [0, 0, 0, 0]], chamferRadius, roundCube=true);

        // top
        translate([(sizeX/2 - chamferRadius/2), (sizeY/2 - chamferRadius/2), (sizeZ/2 - chamferRadius/2)])
            rotate([0, 0, 180]) cornerChamferRoundCut(chamferRadius);
        translate([-(sizeX/2 - chamferRadius/2), (sizeY/2 - chamferRadius/2), (sizeZ/2 - chamferRadius/2)])
            rotate([0, 0, -90]) cornerChamferRoundCut(chamferRadius);
        translate([(sizeX/2 - chamferRadius/2), -(sizeY/2 - chamferRadius/2), (sizeZ/2 - chamferRadius/2)])
            rotate([0, 0, 90]) cornerChamferRoundCut(chamferRadius);
        translate([-(sizeX/2 - chamferRadius/2), -(sizeY/2 - chamferRadius/2), (sizeZ/2 - chamferRadius/2)])
            rotate([0, 0, 0]) cornerChamferRoundCut(chamferRadius);

        // bottom
        translate([(sizeX/2 - chamferRadius/2), (sizeY/2 - chamferRadius/2), -(sizeZ/2 - chamferRadius/2)])
            rotate([180, 0, -90]) cornerChamferRoundCut(chamferRadius);
        translate([-(sizeX/2 - chamferRadius/2), (sizeY/2 - chamferRadius/2), -(sizeZ/2 - chamferRadius/2)])
            rotate([180, 0, 0]) cornerChamferRoundCut(chamferRadius);
        translate([(sizeX/2 - chamferRadius/2), -(sizeY/2 - chamferRadius/2), -(sizeZ/2 - chamferRadius/2)])
            rotate([180, 0, 180]) cornerChamferRoundCut(chamferRadius);
        translate([-(sizeX/2 - chamferRadius/2), -(sizeY/2 - chamferRadius/2), -(sizeZ/2 - chamferRadius/2)])
            rotate([180, 0, 90]) cornerChamferRoundCut(chamferRadius);
    }
}
// helper for above cubeChamferRoundTopBot()
module cornerChamferRoundCut(chamferRadius)
{
    // tool to cut a rounded corner between 2 angled chamfers
    // cube minus cone per corner
    difference()
    {
        cube(chamferRadius, center=true);
        translate([chamferRadius/2, chamferRadius/2, -chamferRadius/2])
            cylinder(h=chamferRadius, r1=chamferRadius, r2=0);
    }
}


// Subroutine for cube with radial corners
module cubeRadial(width, length, height, radial, extrudeScale)
{
    translate([0, 0, -height/2])
    linear_extrude(height, scale = extrudeScale) 
    {
        minkowski()
        {
            square([width-2*radial, length-2*radial], center=true);
            circle(radial);
        }
    }
}

// Subroutine for cube with radial corners on all sides
module cubeRound(width, length, height, radial)
{
        minkowski()
        {
            cube([width-2*radial, length-2*radial, height-2*radial], center=true);
            sphere(radial);
        }
}
