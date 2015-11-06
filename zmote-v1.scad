release = true;

$fn=60;
olp=0.2; // overlap (for joints)
tol=0.2; // tolerence

// LEDs
//   r,  h,  v,  h angles
l1=[28, 12, 30,  0, 120, 240];
l2=[28, 12, 60, 60, 180, 300];
l3=[-9, 15,  0, 180];

// Nut size
nut1=3.8;
nut2=4.2;
nuth=1.6;

// PCB
px=29;
py=0;
pz=-9;
pl=24;
pw=22;
phd=2.4;
phw=nut2;
phh=13+pz;
ph=[[-5, -8], [-5, 8]];

// TSOP
tt=[-28, 0, 4];
tr=[0, 15, 0];
// TSOP spacer
tsw = 10; // width

// ---------------------------------------------------------------------------------------

//rotate([180, 0, 0]) dome();
base();

//!difference() { union() { %circuit(); PCBbed("spacer"); } PCBbed("cut"); }

*union() {
	difference() { dome(); translate([0, -50, 0]) cube(100, true); }
	%for (l=[l1, l2]) for (b=[l[3], l[4], l[5]]) rotate([0, 0, b]) translate([l[0], 0, l[1]]) rotate([0, l[2], 0]) LED();
	%TSOPproc() TSOP();
	%circuit();
	difference() { base(); translate([0, -50, 0]) cube(100, true); }
}

// ---------------------------------------------------------------------------------------

module dome() {
	difference() {
		union() {
			difference() {cylinder(r=35, h=17); inner();}
			pfTop();
			// LEDs
			for (l=[l1, l2]) for (b=[l[3], l[4], l[5]]) rotate([0, 0, b]) translate([l[0], 0, l[1]]) rotate([0, l[2], 0]) LEDspacer();
			// TSOP
			translate([-6+tt[0], tsw/-2-tol, 0]) cube([7.5, tsw+2*tol, 20]);
		}
		// LEDs
		for (l=[l1, l2]) for (b=[l[3], l[4], l[5]]) rotate([0, 0, b]) translate([l[0], 0, l[1]]) rotate([0, l[2], 0]) LEDcut();
		// TSOP
		TSOPproc() TSOPcut();
		// Name / Logo
		if (release) 
		translate([-4,-0.5,14.5])
		rotate([0, 0, -90])
		linear_extrude(height=3)
		scale([.7, .8])
		translate([-25,-5,0])
		union() {
			polygon([[2.69082,10],[2.17576,7.80426],[9.21472,7.80426],[9.77146,8.46562],[9.70199,10]]);
			polygon([[11.4803,10],[10.9837,7.80426],[23.376,7.80426],[23.4812,8.27162],[23.5362,8.60671],[23.5118,8.8889],[23.2942,9.34999],[22.901,9.70018],[22.3606,9.92404],[21.7053,10]]);
			polygon([[27.5124,10],[26.4343,9.92076],[25.7396,9.68254],[25.3096,9.23947],[25.0335,8.54498],[24.8579,7.80426],[32.6563,7.80426],[32.7685,8.28046],[32.8165,8.60671],[32.7877,8.90654],[32.5742,9.35512],[32.1813,9.70018],[31.6353,9.92404],[30.9763,10]]);
			polygon([[34.4124,10],[33.8974,7.80426],[42.1589,7.80426],[42.6739,10]]);
			polygon([[44.1929,10],[43.6778,7.80426],[48.7625,7.80426],[49.4849,7.80426],[50,10]]);
			polygon([[4.41733,6.28749],[0.327083,1.3933],[0,-0],[7.73359,-0],[8.24864,2.19577],[4.4791,2.19577],[7.93681,6.28749]]);
			polygon([[10.6042,6.28749],[9.15064,-0],[12.2256,-0],[13.6976,6.28749]]);
			polygon([[15.2999,6.28749],[13.8464,-0],[16.8842,-0],[18.3378,6.28749]]);
			polygon([[19.9401,6.28749],[18.4495,-0],[21.5429,-0],[23.015,6.28749]]);
			polygon([[24.5061,6.28749],[23.4532,1.72839],[23.4026,1.37566],[23.4292,1.08466],[23.6439,0.635152],[24.0355,0.291028],[24.5673,0.0724888],[25.2106,-0],[28.6745,-0],[29.755,0.0801652],[30.4566,0.317472],[30.8911,0.75777],[31.1626,1.45505],[32.2953,6.28749]]);
			polygon([[36.2779,6.28749],[34.815,-0],[37.9085,-0],[39.3713,6.28749]]);
			polygon([[43.3353,6.28749],[42.811,4.09171],[48.6274,4.09171],[49.1425,6.28749]]);
			polygon([[42.3691,2.19577],[41.854,-0],[47.6611,-0],[48.1762,2.19577]]);
		}
		// Limits
		if (release) difference() {
			rotate([0, 0, 0]) cylinder(d=100, h=50);
			outer();
		}
		// Slit for opening
		//translate([-2, 30, 0]) cube([4, 8, 1]);
	}
}

module base() {
	difference() {
		union() {
			difference() {rotate([180, 0, 0]) cylinder(r=35, h=15); inner();}
			pfBottom();
			// USB
			translate([px, py, pz+phh]) rotate([180, 0, 0]) uUSBspacer();
			// PCB bed
			PCBbed("spacer");
		}
		// USB
		translate([px, py, pz+phh]) rotate([180, 0, 0]) uUSBcut();
		// PCB bed
		PCBbed("cut");
//		PCBcut();
		// TSOP
		translate([-6+tt[0], tsw/-2-2*tol, 0]) cube([6, tsw+4*tol, 3]);
		TSOPproc() TSOPcut();
		// Limits
		if (release) difference() {
			rotate([180, 0, 0]) cylinder(d=100, h=50);
			outer();
		}
	}
}

module PCBsf(l=4) {
	translate([0, l/-2, 0])
	rotate([90, 0, 180])
	linear_extrude(height=l)
	translate([-2,-5])
	polygon([[0,-0],[0,2],[1,4.8],[2.2,4.8],[2.2,6.2],[2.5,7],[15,7],[15,-0]]);
}

module PCBbed(mode="") {
	translate([px, py, pz])
	if (mode == "spacer") {
		translate([ph[0][0]+nut2/-2-tol, (pw+20)/-2, -(phh+olp)]) cube([nut2+4+2*tol, pw+20, phh-tol+olp]);
		translate([-pl, 0, 0]) PCBsf(pw);
	}
	else if (mode == "cut") {
		tol=0.4;
		for(h=ph) translate([h[0], h[1], 0]) translate([0, 0, -phh-1]) cylinder(d=phd, h=phh+1+0.1, $fn=12);
		for(h=ph) translate([h[0], h[1], 0]) translate([nut2/-2-tol-0.1, nut1/-2-tol, -phh]) cube([nut2+2*tol+0.1, nut1+2*tol, nuth+tol]);
	}
	else
		echo ("Error: No mode specified for PCBbed");
}

module circuit() {
	translate([px, py, pz])
	difference() {
		union() {
			// Board
			translate([-2, -5, 0]) cube([2, 10, 1]);
			translate([-pl, -pw/2, 0]) cube([pl-2, pw, 1]);
			// Components
			translate([0, 0, 1]) uUSB();
			translate([-18, -5, 1+8.5]) rotate([0, 0, 180]) ESP01();
			translate([-18, -5, 1]) rotate([0, 0, 180]) FemaleBERG(2, 4);
			translate([-14, 5, 1]) rotate([0, 0, 90]) FemaleBERG(1, 5);
//			translate([-22, 6, 1]) rotate([0, -90, 0]) TO220();
		}
		// Holes
		for(h=ph) translate([h[0], h[1], 0]) union() {
			translate([0, 0, -0.1]) cylinder(d=phd, h=1.2, $fn=12);
			%translate([0, 0, -(phh+0.1)]) cylinder(d=phw, h=phh+3.1, $fn=6);
		}
	}
}
module PCBcut() {
	translate([px, py, pz])
	union() {
		// Board
		translate([-2, -5.2, -0.2]) cube([2.2, 10.4, 1.4]);
		translate([-pl-0.2, -pw/2-0.2, -0.2]) cube([pl-2+0.4, pw+0.4, 1.4]);
	}
}

// ---------------------------------------------------------------------------------------

module outer(h) {
	render(convexity = 1)
	translate([0, 0, -15])
	rotate_extrude(convexity = 10)
	polygon([[0,32.0058],[0,-0],[24.6239,-0],[25.732,0.134429],[26.7872,0.509877],[27.7859,1.08459],[28.7249,1.81681],[29.6067,2.67538],[30.4351,3.6437],[31.2088,4.70177],[31.9264,5.82964],[33.1825,8.20727],[34.1544,10.628],[34.7818,12.9602],[34.9475,14.052],[35.0044,15.0724],[35.0044,16.0073],[34.9165,17.3005],[34.6569,18.6285],[34.2312,19.9759],[33.6455,21.3278],[32.9055,22.6689],[32.0171,23.984],[30.9862,25.2581],[29.8185,26.476],[28.5167,27.6206],[27.0826,28.6728],[25.5217,29.6139],[23.8392,30.4255],[22.0404,31.0891],[20.1305,31.586],[18.1147,31.8977],[15.9985,32.0058]]);
}

module inner(h) {
	render(convexity = 1)
	translate([0, 0, -15])
	rotate_extrude(convexity = 10)
	polygon([[0,30.0037],[15.9985,30.0037],[17.9122,29.9065],[19.7306,29.626],[21.45,29.1789],[23.0667,28.582],[24.5771,27.8519],[25.9775,27.0053],[27.2643,26.059],[28.4339,25.0296],[29.4798,23.9334],[30.3961,22.7886],[31.1798,21.6149],[31.8278,20.4323],[32.3371,19.2604],[32.7047,18.1191],[32.9274,17.0281],[33.0024,16.0073],[33.0024,15.0724],[32.8017,13.3738],[32.2344,11.2989],[31.3521,9.05584],[30.2066,6.85269],[28.8597,4.88108],[28.1388,4.03629],[27.402,3.31611],[26.6685,2.74504],[25.9552,2.33396],[25.2707,2.08544],[24.6239,2.00203],[0,2.00203]]);
}

module pfTop(x=33, y=0) {
	render(convexity = 1)
	rotate_extrude(convexity=10)
	translate([x-2, y-3, 0])
	polygon([[1.8,3],[1.5,3.5],[2,6],[2.3,6],[2.3,3]]);
}

module pfBottom(x=33, y=0) {
	render(convexity = 1)
	rotate_extrude(convexity=10)
	translate([x-3, y-5, 0])
	polygon([[3.3,5],[2.2,5],[2.3,5.5],[2.6,7],[2.3,7.5],[1,7.5],[0,5.5],[0,4.5],[2.5,0]]);
}
// ---------------------------------------------------------------------------------------

module uUSBspacer () {
	//uUSB();
	translate([1, -7, -5]) cube([6, 14, 10]);
}

module uUSB () {
	translate([-4, -3.5, 0.5]) cube([6, 7, 2]);
	translate([-4, -4, 0]) cube([4, 8, 3]);
}

module uUSBcut () {
	//uUSB();
	translate([-2, -4.5, -0.5]) cube([8, 9, 5]);
	translate([3.5, -6, -2.5]) cube([20, 12, 8]);
}

module ESP01 () {
	translate([0, -7.5, 2.5]) union() {
		cube([25, 14.5, 1]);
		cube([18, 14.5, 3]);
		translate([0, 2.5, -2.5]) cube([5, 10, 2.5]);
		%translate([1, 3.5, -8]) cube([3, 8, 8]);
	}
}

module FemaleBERG(m=1, n=1, h=8.25, p=2.54) {
	translate([0, -p*n/2, 0]) cube([p*m, p*n, h]);
	*%translate([0, -p*n/2, h]) cube([p*m, p*n, 5]);
	%translate([0.5, 0.5-p*n/2, -3]) cube([p*m-1, p*n-1, 3]);
}

module TSOPproc () {
	rotate([0, 0, tr[2]])
	translate([tt[0], tt[1], tt[2]])
	rotate([tr[0], tr[1], 0])
	rotate([0, 0, 180])
	translate([0, 0, -5])
	children();
}

module TSOP () {
	$fn = 24;
	translate([3.6/-2, 6.8/-2, 0]) cube([3.6, 6.8, 7.3]);
	color([0.6, 0.6, 0.6]) translate([1, 0, 2.2+2.5]) sphere(d=5);
*	color([0.6, 0.6, 0.6]) translate([1, 0, 0]) cylinder(d=5, h=7);
	for (y=[-2.54, 0, 2.54]) translate([0, y, 2/-2]) cube([0.6, 0.6, 2], true);
}

module TSOPcut () {
	$fn = 24;
	//TSOP();
	translate([3.6/-2-tol-2, 6.8/-2-tol, -2]) cube([3.6+2*tol+2, 6.8+2*tol, 7.3+2+tol]);
	translate([1.5, 5.4/-2, -2]) cube([1.7, 5.4, 7.3+2+tol]);
	translate([3, 0, 2.2+2.5]) rotate([0, 90, 0]) cylinder(d=5, h=10);
	translate([4.5, 0, 2.2+2.5]) rotate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d=5, d2=20, h=7);

	//translate([-3, -3, 9]) cube([4, 6, 4]);
}


module LED (l=2) {
	$fn = 24;
	translate([0, 0, -4]) union() {
		translate([0, 0, 6.5]) sphere(d=5);
		cylinder(d=5, h=6.5);
		cylinder(d=6, h=1);
		translate([0,  1.2, -l/2]) cube([0.6, 0.6, l], true);
		translate([0, -1.2, -l/2]) cube([0.6, 0.6, l], true);
		//%translate([0, 0, 6]) cylinder(d1=6, d2=120, h=100);
	}
}

module LEDcut () {
	$fn = 24;
	//%LED();
	translate([0, 0, -4]) cylinder(d=5.4, h=8);
	translate([0, 0, -9.1]) cylinder(d=7, h=6);
}

module LEDspacer () {
	$fn = 24;
	translate([0, 0, -3])
	cylinder(d1=7, d2=20, h=5);
}

module TO220() {
	$fn = 12;
	translate([-0.3, -3.3, 0]) cube([0.6, 6.6, 4]);
	translate([-1.5, -5, 4]) cube([3, 10, 9]);
	difference() {
		translate([-2.5, -5, 4]) cube([1, 10, 15]);
		translate([-3, 0, 16.4]) rotate([0, 90, 0]) cylinder(d=3.4, h=2);
	}
}

// ---------------------------------------------------------------------------------------
