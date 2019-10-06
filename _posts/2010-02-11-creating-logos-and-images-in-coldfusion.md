---
layout: post
title: Creating logos and images in ColdFusion
slug: creating-logos-and-images-in-coldfusion
date: 2010-02-11
categories:
- ColdFusion
tags:
- ColdFusion
status: publish
type: post
published: true
---
<p>I know I'm on a bit of a <a href="http://www.mattgifford.co.uk/image-cropping-with-coldfusion-jquery/" title="Image Cropping with ColdFusion &amp; jQuery">cfImage trip</a> at the moment, but I had some fun last night playing around with some simple code to create images using ColdFusion's built-in image functions.</p>
<p>This started off as I was enjoying a cup of coffee (white, two sugars) out of my favourite mug - a Sinclair ZX Spectrum mug. Yeah I know, I seriously know how to party.</p>
<p>Anyway, the logo that I have seen so many times over the years suddenly caught my eye; the bright rainbow colours, the stylish typography on the logo. I started wondering how easy it would be to re-create the image in ColdFusion using nothing more than the image functions. As it turns out, it was very easy!</p>
<h2>Sinclair logo</h2>
<p>This is the end result, generated entirely by ColdFusion.</p>
<p><img src="/assets/uploads/2010/02/spectrum_ColdFusion.png" alt="Spectrum ColdFusion generated image" title="Spectrum ColdFusion generated image" /></p>
<p>Ok, so I'm probably not going to win any design awards, and the Turner Prize is probably out of my reach for another year, but hey.. it's a start.</p>
<p>In terms of the code used to generate the image, it was fairly simple.</p>
<pre name="code" class="java">
&lt;cfscript&gt;
	// set the image dimensions
	strImageWidth 	= 240;
	strImageHeight 	= 150;

	// create the image with white background
	myImage = imageNew("",
					strImageWidth,
					strImageHeight,
					'',
					'white');

	imageSetAntialiasing(myImage,'on');
	imageAddBorder(myImage,
					1,
					'black',
					'constant');

	// set the stroke for drawing
	imageSetDrawingStroke(myImage,{'width' = 15});

	// time for the rainbow stripes

	// set drawing colour for each
	// and position for a diagonal placement
	imageSetDrawingColor(myImage, '##0093df');
	imageDrawLine(myImage, 232,
				0, 135, strImageWidth);

	imageSetDrawingColor(myImage, '##02913f');
	imageDrawLine(myImage, 217, 0,
				120, strImageWidth);

	imageSetDrawingColor(myImage, '##fff500');
	imageDrawLine(myImage, 202, 0,
				105, strImageWidth);

	imageSetDrawingColor(myImage, '##da251c');
	imageDrawLine(myImage, 187, 0,
				90, strImageWidth);

	// switch the drawing colour to black
	imageSetDrawingColor(myImage, 'black');

	// create the struct for text attributes
	stuTextAtt 	= {
		'font' 	= 'Arial',
		'size' 	= 22,
		'style' = 'bold'
	};
	// write text to the image
	imageDrawText(myImage, 'ZX Spectrum', 10, 110, stuTextAtt);

	// set the stroke using the attributes
	imageSetDrawingStroke(myImage,{'width' = 3});

	// create an array for the lines
	// X & Y coordinates, each contained within a struct
	arrSpellIt = [
		{
            // give me an 'S'
			'X' = [10,25,25,10,10,25],
			'Y' = [85,85,80,80,75,75]
		},
		{
            // give me an 'I'
			'X' = [30,30],
			'Y' = [85,75]
		},
		{
            // dot the 'I'
			'X' = [30,30],
			'Y' = [71,71]
		},
		{
            // give me an 'N'
			'X' = [35,35,50,50],
			'Y' = [85,75,75,85]
		},
		{
            // give me a 'C'
			'X' = [70,55,55,70],
			'Y' = [85,85,75,75]
		},
		{
            // give me an 'L'
			'X' = [75,75],
			'Y' = [85,72]
		},
		{
            // give me an(other) 'A'
			'X' = [95,95,95,80,80,95,95,80],
			'Y' = [80,80,85,85,80,80,75,75]
		},
		{
            // give me an(other) 'I'
			'X' = [100,100],
			'Y' = [85,75]
		},
		{
            // dot it (again)
			'X' = [100,100],
			'Y' = [71,71]
		},
		{
            // give me an 'R'
			'X' = [105,105,120],
			'Y' = [85,75,75]
		}
	];

	// loop over the array and draw the X & Y lines
	for(i=1; i&lt;=arrayLen(arrSpellIt); i=i+1) {
		imageDrawLines(myImage, arrSpellIt[i]['X'], arrSpellIt[i]['Y']);
	}
&lt;/cfscript&gt;

&lt;cfimage action="writeToBrowser" source="#myImage#" /&gt;
</pre>
<p>This was great fun to produce. The arrSpellIt array of structures that contains the X and Y coordinates was the most time-consuming aspect of the code, and is used to write out the word 'SINCLAIR'.</p>
<p>Each array item repesents an individual letter. Even the dots on the I's had to be mapped out separately. However, using the implicit array and structure creation methods, the code was certainly more streamlined.</p>
<p>Relatively happy with experiment number one, I wanted to try something else, which brings me to experiment number two...</p>
<h2>Adobe logo</h2>
<p><img src="/assets/uploads/2010/02/adobe_ColdFusion_generated.png" alt="Adobe Logo generated by ColdFusion" title="Adobe Logo generated by ColdFusion" /></p>
<p>At first glances, the logo, with it's sharp edges and iconic 'A' design with mishapen typography, appeared to be fairly difficult to recreate. As it turns out, it was much easier than I thought.</p>
<p>Firstly, a red rectangle was created for the background and added to the empty image object. Again, the X & Y coordinates for the letter were placed into the required arrays and applied to the image. </p>
<p>The imageDrawLines() function accepts two boolean parameters; the first to set the lines drawn as a polygon, and the second to fill the polygon with the last defined drawing colour (in this case, white).</p>
<p>Here's the code to create the Adobe logo:</p>
<pre name="code" class="java">
&lt;cfscript&gt;
	// image dimensions
	strImageWidth 	= 400;
	strImageHeight 	= 275;

	// create a new image with white background
	myImage = imageNew("",
					strImageWidth,
					strImageHeight,
					'',
					'white');

	imageSetAntialiasing(myImage,'on');
	imageAddBorder(myImage,
					1,
					'black',
					'constant');

	// set the background colour to the red
	imageSetDrawingColor(myImage, '##df2624');
	// draw a rectangle, setting the fill colour
	// (the 'yes' parameter)
	imageDrawRect(myImage, 64, 11, 274, 242, 'yes');

	// switch the colour to white to continue drawing
	imageSetDrawingColor(myImage, 'white');

	// store the coords for the white lines
	x = [165,64,223,204,157,201,266,338,236,165];
	y = [10,254,254,204,204,100,254,254,10,10];

	// draw the lines, set as a polygon, and fill with the white
	imageDrawLines(myImage, x, y, 'yes', 'yes');
&lt;/cfscript&gt;

&lt;cfimage action="writeToBrowser" source="#myImage#" /&gt;
</pre>
<p>All in all, it's been fun playing around with the image functions with the view to emulate an existing logo / design. Perhaps next time I'll try something a little more in-depth. The Mona Lisa can't be that hard, right...?</p>