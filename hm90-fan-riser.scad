// HM90 Cooler Stand: holds two fans (40mm x 25mm) to cool the lower half
// 2023 Matt Klapman

// OpenSCAD units are millimeters

$fn=60; // number of resolved facets on curves

include <Chamfers-for-OpenSCAD/Chamfer.scad>;


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
