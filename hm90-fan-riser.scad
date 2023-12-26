// HM90 Cooler Stand: holds two fans (40mm x 25mm) to cool the lower half
// 2023 Matt Klapman

// OpenSCAD units are millimeters

$fn=60; // number of resolved facets on curves

//include <Chamfer.scad>;
//include <BOSL/constants.scad>
//use <BOSL/shapes.scad>

wallThickness = 3;
wallThicknessMin = 1.5;

clearance = 0.5; // allow some space as 3D printing isn't perfect

// from a horizontal view looking at the front
hm90Width = 149.5 + clearance;  // measurement left to right
hm90Length = 149.5 + clearance; // measurement front to back
hm90Height = 50 + 3.5 + clearance; // with feet
hm90Radial = 10; // corners (eyeballed)

hm90VentWidth = 75.5;
hm90VentLength = 45.3; // through holes are actually smaller
hm90VentOffset = 17; // from front to start of length

fanWidth = 40 + clearance;
fanLength = 40 + clearance;
fanHeight = 25; // does not include any wireframe around it

standRadial = hm90Radial;
hm90shelf = 3.5 + 1 + 2.5; // depth of hm90 into the base
trayHeight = hm90shelf + wallThickness;
bottomAirGap = 10; // height off of the desk to allow airflow

renderHelp = 0.001; // used during development to correct visual artifacts in OpenSCAD (OK to print with this)

module tray()
{
    difference()
    {
        translate([0, 0, bottomAirGap + fanHeight - wallThickness - hm90shelf]) translate([0, 0, wallThickness + trayHeight/2 + hm90shelf]) cubeRadial(hm90Width, hm90Length, trayHeight, standRadial, 1);
        union()
        {
            // HM90 tray
            //translate([0, 0, trayHeight + hm90Height/2 - hm90shelf]) cubeRound(hm90Width, hm90Length, hm90Height, hm90Radial);
            translate([0, 0, bottomAirGap + fanHeight - wallThickness - hm90shelf]) translate([0, 0, wallThickness + trayHeight + hm90Height/2]) cubeChamferRoundTop(hm90Width, hm90Length, hm90Height, hm90Radial);
            echo("wallThickness - hm90shelf", wallThickness - hm90shelf);
            
            // vent(s)
//            translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2, 0]) cube([hm90VentWidth, hm90VentLength, 2*(hm90Height+trayHeight)], center=true);
            translate([0, 0, 0.15]) fans();
            
        }
    }
}

module fanSupport()
{
    // outside skirt
    //translate([0, 0, -wallThicknessMin])
        difference()
        {
            translate([0, 0, bottomAirGap + wallThickness + fanHeight/2 - wallThicknessMin/2]) cubeRadial(hm90Width, hm90Length, fanHeight + wallThicknessMin, standRadial, 1);
            translate([0, 0, bottomAirGap + wallThickness + fanHeight/2 - wallThicknessMin/2]) cubeRadial(hm90Width - 2*wallThickness, hm90Length - 2*wallThickness, fanHeight + wallThicknessMin + 2*renderHelp, standRadial, 1);
        }
    
    // fan cavity
    difference()
    {
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThickness + fanHeight/2 - wallThicknessMin/2]) cubeRadial(hm90Width, hm90Length/2, fanHeight + wallThicknessMin, standRadial, 1);
        union()
        {
            fans();
            translate([0, 0, -wallThicknessMin]) fans();
        }
    }
}

module fanGrates()
{
    // fan grates
    jointDiameter = 8;

    // fan center
    translate([-(wallThicknessMin/2 + fanWidth/2), -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter);
    hull()
    {
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }

    // left fan
    hull()
    {
        //corner
        translate([-(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([-(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([-(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        //corner
        translate([-(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([-(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([-(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }

    // right fan
    // fan center
    translate([(wallThicknessMin/2 + fanWidth/2), -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter);
    hull()
    {
        //corner
        translate([(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        //corner
        translate([(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 + fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
    hull()
    {
        //corner
        translate([(wallThicknessMin/2 + fanWidth), -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
        // middle
        translate([0, -hm90Length/2 + hm90VentOffset + hm90VentLength/2 - fanLength/2, bottomAirGap + wallThicknessMin]) cylinder(h=wallThicknessMin, d=jointDiameter/2);
    }
}

module feet()
{
    // corner cube stands
    standCornerWidth = (hm90Width - max(hm90VentWidth, 2*fanWidth + wallThicknessMin))/2;
    standCenterWidth = 2*(hm90Length/2 - hm90VentOffset - hm90VentLength);
    // center circle stand
    // hull an X between
    //hull()
    {
        translate([-(hm90Width/2 - standCornerWidth/2), -(hm90Width/2 - standCornerWidth/2), (bottomAirGap + wallThickness)/2])
            cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap + wallThickness, standRadial, 1);
        translate([-(hm90Width/2 - standCornerWidth/2), (hm90Width/2 - standCornerWidth/2), (bottomAirGap + wallThickness + fanHeight)/2])
            cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap + wallThickness + fanHeight, standRadial, 1);
        translate([(hm90Width/2 - standCornerWidth/2), -(hm90Width/2 - standCornerWidth/2), (bottomAirGap + wallThickness)/2])
            cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap + wallThickness, standRadial, 1);
        translate([(hm90Width/2 - standCornerWidth/2), (hm90Width/2 - standCornerWidth/2), (bottomAirGap + wallThickness + fanHeight)/2])
            cubeRadial(standCornerWidth, standCornerWidth, bottomAirGap + wallThickness + fanHeight, standRadial, 1);

//        translate([0, 0, bottomAirGap/2])
//            cubeRadial(standCenterWidth, standCenterWidth, bottomAirGap, 2, 1);
    }
}

module fans()
{
    translate([-wallThicknessMin/2 - fanWidth/2, -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThickness + fanHeight/2]) cubeRadial(fanWidth, fanLength, fanHeight + 2*renderHelp, 2, 1);
    translate([+wallThicknessMin/2 + fanWidth/2, -hm90Length/2 + hm90VentOffset + hm90VentLength/2, bottomAirGap + wallThickness + fanHeight/2]) cubeRadial(fanWidth, fanLength, fanHeight + 2*renderHelp, 2, 1);
}

//translate([0, 0, bottomAirGap + fanHeight - wallThickness - hm90shelf]) tray();
//translate([0, 0, bottomAirGap + fanHeight - wallThickness - hm90shelf]) tray();
tray();
color("red") fanSupport();
fanGrates();
feet();
//color("blue") fans();




module cubeChamferRoundTop(sizeX, sizeY, sizeZ, chamferRadius)
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



// Chamfer.scad

/**
  * This code is published under a
  * Creative Commons Attribution-NonCommercial-ShareAlike 3.0
  * licence, please respect it.
  *
  * Chamfered primitives for OpenSCAD v1.2 - By TimeWaster
  */


/**
  * chamferCube returns an cube with 45° chamfers on the edges of the
  * cube. The chamfers are diectly printable on Fused deposition
  * modelling (FDM) printers without support structures.
  *
  * @param  size      The size of the cube along the [x, y, z] axis,
  *                     example: [1, 2, 3]
  * @param  chamfers  Which chamfers to render along the [x, y, z] axis,
  *                     example: [[0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0]]
  *                     X axis: 4 values in clockwise order starting from
  *                     the zero point, as seen from "Left view" (Ctrl + 6)
  *                     Y axis: 4 values in clockwise order starting from
  *                     the zero point, as seen from "Front view" (Ctrl + 8)
  *                     Z axis: 4 values in clockwise order starting from
  *                     the zero point, as seen from "Bottom view" (Ctrl + 5)
  * @param  ch        The "height" of the chamfers as seen from
  *                     one of the dimensional planes (The real
  *                     length is side c in a right angled triangle)
  */
module chamferCube(size, chamfers = [undef, undef, undef], ch = 1, ph1 = 1, ph2 = undef, ph3 = undef, ph4 = undef, sizeX = undef, sizeY = undef, sizeZ = undef, chamferHeight = undef, chamferX = undef, chamferY = undef, chamferZ = undef, roundCube = false, center = true) {
    if(size[0]) {
        chamferCubeImpl(size[0], size[1], size[2], ch, chamfers[0], chamfers[1], chamfers[2], roundCube, center);
    } else {
        // keep backwards compatibility
        size     = (sizeX == undef) ? size : sizeX;
        chamfers = (sizeY == undef) ? chamfers : sizeY;
        ch       = (sizeZ == undef) ? ch : sizeZ;
        ph1      = (chamferHeight == undef) ? ph1 : chamferHeight;
        ph2      = (chamferX == undef) ? ph2 : chamferX;
        ph3      = (chamferY == undef) ? ph3 : chamferY;
        ph4      = (chamferZ == undef) ? ph4 : chamferZ;

        chamferCubeImpl(size, chamfers, ch, ph1, ph2, ph3, ph4, roundCube, center);
    }
}

module chamferCubeImpl(sizeX, sizeY, sizeZ, chamferHeight, chamferX, chamferY, chamferZ, roundCube, center) {
    chamferX = (chamferX == undef) ? [1, 1, 1, 1] : chamferX;
    chamferY = (chamferY == undef) ? [1, 1, 1, 1] : chamferY;
    chamferZ = (chamferZ == undef) ? [1, 1, 1, 1] : chamferZ;
    chamferCLength = sqrt(chamferHeight * chamferHeight * 2);

    difference() {
        if(roundCube) {
            translate([chamferHeight, chamferHeight, chamferHeight])
                minkowski()
                {
                    cube([sizeX-2*chamferHeight, sizeY-2*chamferHeight, sizeZ-2*chamferHeight]);
                    sphere(chamferHeight);
                }
        } else {
            cube([sizeX, sizeY, sizeZ]);
        }
        for(x = [0 : 3]) {
            chamferSide1 = min(x, 1) - floor(x / 3); // 0 1 1 0
            chamferSide2 = floor(x / 2); // 0 0 1 1
            if(chamferX[x]) {
                translate([-0.1, chamferSide1 * sizeY, -chamferHeight + chamferSide2 * sizeZ])
                rotate([45, 0, 0])
                cube([sizeX + 0.2, chamferCLength, chamferCLength]);
            }
            if(chamferY[x]) {
                translate([-chamferHeight + chamferSide2 * sizeX, -0.1, chamferSide1 * sizeZ])
                rotate([0, 45, 0])
                cube([chamferCLength, sizeY + 0.2, chamferCLength]);
            }
            if(chamferZ[x]) {
                translate([chamferSide1 * sizeX, -chamferHeight + chamferSide2 * sizeY, -0.1])
                rotate([0, 0, 45])
                cube([chamferCLength, chamferCLength, sizeZ + 0.2]);
            }
        }
    }
}

/**
  * chamferCylinder returns an cylinder or cone with 45° chamfers on
  * the edges of the cylinder. The chamfers are diectly printable on
  * Fused deposition modelling (FDM) printers without support structures.
  *
  * @param  h    Height of the cylinder
  * @param  r    Radius of the cylinder (At the bottom)
  * @param  r2   Radius of the cylinder (At the top)
  * @param  ch   The "height" of the chamfer at radius 1 as
  *                seen from one of the dimensional planes (The
  *                real length is side c in a right angled triangle)
  * @param  ch2  The "height" of the chamfer at radius 2 as
  *                seen from one of the dimensional planes (The
  *                real length is side c in a right angled triangle)
  * @param  a    The angle of the visible part of a wedge
  *                starting from the x axis counter-clockwise
  * @param  q    A circle quality factor where 1.0 is a fairly
  *                good quality, range from 0.0 to 2.0
  */
module chamferCylinder(h, r, r2 = undef, ch = 1, ch2 = undef, a = 0, q = -1.0, height = undef, radius = undef, radius2 = undef, chamferHeight = undef, chamferHeight2 = undef, angle = undef, quality = undef) {
    // keep backwards compatibility
    h   = (height == undef) ? h : height;
    r   = (radius == undef) ? r : radius;
    r2  = (radius2 == undef) ? r2 : radius2;
    ch  = (chamferHeight == undef) ? ch : chamferHeight;
    ch2 = (chamferHeight2 == undef) ? ch2 : chamferHeight2;
    a   = (angle == undef) ? a : angle;
    q   = (quality == undef) ? q : quality;

    height         = h;
    radius         = r;
    radius2        = (r2 == undef) ? r : r2;
    chamferHeight  = ch;
    chamferHeight2 = (ch2 == undef) ? ch : ch2;
    angle          = a;
    quality        = q;

    module cc() {
        upperOverLength = (chamferHeight2 >= 0) ? 0 : 0.01;
        lowerOverLength = (chamferHeight >= 0) ? 0 : 0.01;
        cSegs = circleSegments(max(radius, radius2), quality);

        if(chamferHeight >= 0 || chamferHeight2 >= 0) {
            hull() {
                if(chamferHeight2 > 0) {
                    translate([0, 0, height - abs(chamferHeight2)]) cylinder(abs(chamferHeight2), r1 = radius2, r2 = radius2 - chamferHeight2, $fn = cSegs);
                }
                translate([0, 0, abs(chamferHeight)]) cylinder(height - abs(chamferHeight2) - abs(chamferHeight), r1 = radius, r2 = radius2, $fn = cSegs);
                if(chamferHeight > 0) {
                    cylinder(abs(chamferHeight), r1 = radius - chamferHeight, r2 = radius, $fn = cSegs);
                }
            }
        }

        if(chamferHeight < 0 || chamferHeight2 < 0) {
            if(chamferHeight2 < 0) {
                translate([0, 0, height - abs(chamferHeight2)]) cylinder(abs(chamferHeight2), r1 = radius2, r2 = radius2 - chamferHeight2, $fn = cSegs);
            }
            translate([0, 0, abs(chamferHeight) - lowerOverLength]) cylinder(height - abs(chamferHeight2) - abs(chamferHeight) + lowerOverLength + upperOverLength, r1 = radius, r2 = radius2, $fn = cSegs);
            if(chamferHeight < 0) {
                cylinder(abs(chamferHeight), r1 = radius - chamferHeight, r2 = radius, $fn = cSegs);
            }
        }
    }
    module box(brim = abs(min(chamferHeight2, 0)) + 1) {
        translate([-radius - brim, 0, -brim]) cube([radius * 2 + brim * 2, radius + brim, height + brim * 2]);
    }
    module hcc() {
        intersection() {
            cc();
            box();
        }
    }
    if(angle <= 0 || angle >= 360) cc();
    else {
        if(angle > 180) hcc();
        difference() {
            if(angle <= 180) hcc();
            else rotate([0, 0, 180]) hcc();
            rotate([0, 0, angle]) box(abs(min(chamferHeight2, 0)) + radius);
        }
    }
}

/**
  * circleSegments calculates the number of segments needed to maintain
  * a constant circle quality.
  * If a globalSegementsQuality variable exist it will overwrite the
  * standard quality setting (1.0). Order of usage is:
  * Standard (1.0) <- globalCircleQuality <- Quality parameter
  *
  * @param  r  Radius of the circle
  * @param  q  A quality factor, where 1.0 is a fairly good
  *              quality, range from 0.0 to 2.0
  *
  * @return  The number of segments for the circle
  */
function circleSegments(r, q = -1.0) = (q >= 3 ? q : ((r * PI * 4 + 40) * ((q >= 0.0) ? q : globalCircleQuality)));

// set global quality to 1.0, can be overridden by user
globalCircleQuality = 1.0;
