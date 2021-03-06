/*
A parametic lamp / lightobject design by overflo for hackerspaceshop.com / metalab.at

This can be used with the usblinky usbstick to create a hypnotizing lavalamp / colorfading thing.

Built on openSCAD 2014.03


Links:
 http://www.hackerspaceshop.com/blinky/usblinky.html
 https://metalab.at




Thanks go to:
Clifford Wolf, Marius Kintel and Philipp 'wizard23' Tiefenbacher for the FANTASTIC openSCAD software, their friendship and support.
 


Design revision: 2015.03.35

Released under CC-AT licence
Modify at will and cherish the love.
*/




/* for thingiverse / makerbot customizer */
// preview[view:south, tilt:side]


/* [Fan options] */


// Should we use fans or make a solid object?
use_fans =0;  //[1:Yes,0:No]




// How many blades should the fan be made of?
blades = 23; //[5:50]


// Direction of twist
left_right =1;  //[0:Left,1:Right,2:Both]



// How much shall we twist those blades? Dont make a too steep twist or you wont be able to print it. 30-90 looks good..
twist = 45;



// How thick should a blade be? 
thickness = 2;







/* [Outer shell options] */

// The width FACTOR of the outer shell is defined here. tweak it and see what happens..
//w_factor = 0.3;

//Move outer shall by this many mm down
offset = 10;



/* [General] */


// How wide can it be (maximum rating, its probably going to be smaller than that)
outer_dia = 190;

// How tall should the object be
height = 190;



//Diameter of the collow shaft in the middle
spike_inner_dia = 15;





/* [Hidden] */


// how high?
spike_height = height -20;



fn=80;







// IMPORTANT!
// modify this funtion to create a custom outline for your object
// you could include another .stl here or so some fancy math .. the sphere is just a suggestion.
module add_outer_shell()
{



 translate([0, 0, (height/2)-42]) scale([0.6,0.45,1]) resize([0,0,height+10],auto=true) union()
{
  sphere(r = 20,$fn = 80, convexity=2);
  translate([0, 0, 20 * sin(30)])
    cylinder(h = 30, r1 = 20 * cos(30), r2 = 0,$fn = 80, convexity=2);
}
}









// this creates a rod with a round end
// used in the middle of the object twice to make a hollow shaft
module spike(inset)
{

  h = spike_height - spike_inner_dia/2;
  cylinder(h = h, r = spike_inner_dia/2 - inset,$fn = fn);
  translate([0, 0, h]) sphere(spike_inner_dia/2 - inset, $fn = fn);
}




// create one fan element
module fan()
{
	 // left twist
       if(left_right==0)   linear_extrude(height = height, slices=250, twist = -twist, $fn = fn, convexity=2 )      square([thickness, outer_dia/2]);
    // right twist (-twist)
       if(left_right==1)    linear_extrude(height = height, slices=250, twist = twist, $fn = fn, convexity=2 )      square([thickness, outer_dia/2]);

	// both directions
       if(left_right==2)
       {
linear_extrude(height = height, slices=250, twist = twist, $fn = fn, convexity=2 )      square([thickness, outer_dia/2]);
linear_extrude(height = height, slices=250, twist = -twist, $fn = fn, convexity=2 )  square([thickness, outer_dia/2]);   

       } 

}



// rotate those fan elements
module fan_assembly()
{
  for (i = [0:blades-1])
  {
   rotate([0, 0, i*360/blades]) fan();
  }
}
















//.. the magic happens below this line
// i know this could be much nicer.. but its my first openSCAD script .. have mercy on me.
//////////////////////////////////////



intersection() // cut away overlap
{


intersection()  // add outer shell (make it round)
{


 difference() // make hollow and remove cable outlet + 4 screw holes
{

 union()  // base structure 
{




   if(use_fans==1)
   {
    // the rotated squares
    fan_assembly();
   }

   if(use_fans==0)
   { 
    // use this instead of the fan when tweaking with the outer shell
   cylinder(r=outer_dia/2, h=height+20);
   } 

   // add a filled shaft in the middle with a round end on top
   translate([0,0,-5])  spike(thickness/2-1);

   // add the base (the round solid thing on the bottom taht we can screw onto)
   cylinder(r=spike_inner_dia/2+10,h=5, $fn = fn);






}


  // make the spike in the middle hollow
  translate([0,0,-6]) spike(thickness/2);

  // remove a little opening for the cables from the base
  // actually no. it looks much nicer with a lasercut acrylic base, but we keep this here for reference..s 
  // translate([0,0,-1]) rotate([90,0,45]) cylinder(r=5, h=100, $fn = fn);


  // remove 4 screwholes from the base
  translate([spike_inner_dia/2+5,0,0])cylinder(r=1.5, h=5, $fn = fn);
  translate([-(spike_inner_dia/2+5),0,0])cylinder(r=1.5, h=5,$fn = fn);
  translate([0,spike_inner_dia/2+5,0])cylinder(r=1.5, h=5,$fn = fn);
  translate([0,-(spike_inner_dia/2+5),0]) cylinder(r=1.5, h=5,$fn = fn);



//blumenoeffnung 1s
  translate([-21,0,2])  cylinder(r=5,h=200,$fn = fn);// rotate([0,180,0]) spike(thickness/2+1);
 // translate([21,0,2])  cylinder(r=5,h=200,$fn = fn);// rotate([0,180,0]) spike(thickness/2+1);




}


 // now carve add_oout the outer shell (the egg shape)
 add_outer_shell();


}







// cut away bottom overlaps

  translate([0,0,height/2+10])  
 cube([height,height,height+20],center=true);







}





