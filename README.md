# dualfisheye2equirectangular_ffmpeg_remap
This is my foray into using ffmpeg's remap filters to turn dual fisheye
footage into the equirectangular footage used by VR video on Youtube
et al. 

Big Kudo's go to the following people
ultramango on github. It was the inspiration for a lot of the work here
the ffmpeg man pages, especially remap filter pages
the ffmpeg user list for helping me sort out the more esoteric bits of the filter

What I did to get here:
1. Take some test footage

1.a 360 camera was taken to a large open space with features on the horizon

1.b camera was rotated slowly 360 degrees while recording

2. Do lens calibrations

2.a Extract frames from the raw footage. Do enough to cover every 45 
    degrees of rotation. More if you want to me more accurate

This command should create a subdir called frames, and take one frame every second from the input video

ffmpeg -i [Input.mp4] -q 2 -r 1 frames/dual%05d.jpg

Open Hugin, and load the images produced above. 
Set the lens type to circular fisheye, and create a crop. 
Un-tick center on d,e, and set the crop boundaries 0,0,1920,1920
The crop should now nicely fit over the left lens

Load all the images a second time, and this time highlight all the newly loaded images. 
Right-click and select "New Lens"
Set lens type to circular fisheye, and create a crop again. 
Un-tick center on d,e, and set the crop boundaries to 0,1921,3640,1920
The crop should now fit nicely over the right lens

In the images view, set the Yaw of the first image to 180
This rotates the images like ActionDirector

Under create control points, select Hugin's CPfind + Celeste, and create control points. 
Once that is done, select optimize positions starting from anchor. 
Once that is done, Highlight all the images, and right-click and select "Clean Control Points"
Once that is done, select optimize everything except positions.
Optimize,
Clean control points,
Optimize, 
Clean control points
....
keep on doing this until the average distance between control points is 1.

Set output canvas size to 3840x1920
Save your Hugin project as "dual leans optimize.pto"

Delete all images except the first left-hand image. 
Save your project as "Left.pto"
Undo the delete, and delete all the images except the first right-hand image. 
Save your project as "Right.pto"

On a command line, run
nona -c Left.pto -o l

then run
nona -c Right.pto -o r

This should generate the 4 maps the remap filter fo ffmpeg needs. 
It also generates a l.tif and r.tif

Load l.tif in GIMP.
Use the fuzzy select tool, and select the transparent part of the image.
Load r.tif as a layer in the same gimp.
They should now be nicely overlaid, and you should have a nice band of overlap.
Add another transparent layer.
Select the new layer
Fill the selection with black
Select nothing
Use the airbrush tool
Set brush size to 300
Trace the sides of the black filled rectange, so that the transition between 
black and transparent is somewhere on the overlap.

Delete the two layers with images
Export the image as "Alpha_Map.png"

Take the following block of text and paste it into a text file:
-----------------------------------------------------------------
#!/bin/bash
#This will split, defish, blend and re-assemble Samsung Gear 360 video
map_dir="."
ffmpeg -y -i "$1" \
-i $map_dir/l0000_x.tif -i $map_dir/l0000_y.tif \
-loop 1 -i $map_dir/Alpha_Map.png \
-i $map_dir/r0000_x.tif -i $map_dir/r0000_y.tif \
-c:v hevc_nvenc -rc constqp -qp 20 -cq 20 \
-filter_complex \
"[3]alphaextract[alf]; \
 [v:0][1][2]remap[l_remap]; \
 [v:0][4][5]remap[r_remap]; \
 [r_remap][alf]alphamerge[r_rm_a]; \
 [l_remap][r_rm_a]overlay=0:0[out]" \
 -map [out] -map 0:a "$1_out.mp4"
------------------------------------------------------------------

Save the text file as "Remap"
run the following command
chmod a+x Remap

Run the Remap script on the input file with the input file as the only
argument

If this works nicely for you, you can place the "Remap" script in a directory 
on your path. Place the maps in a directory and modify the "map_dir"
variable in the script to point to that directory. 
Currently the script is using hardware nVidia accell, if this does not
work for you, use libx265 instead of hevc_nvenc
