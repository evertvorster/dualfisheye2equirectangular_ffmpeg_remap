
#INSTALLATION

git clone or unzip the repository in a directory

## DEPENDENCIES

### Ubuntu 18.04

```
apt install -y ffmpeg mediainfo
```

### Ubuntu 16.04

```
add-apt-repository ppa:jonathonf/ffmpeg-3
apt update
apt dist-upgrade
apt install -y ffmpeg mediainfo
```

## STEPS

1. make a short (1 minute or less) dualfisheye video of the resolution you plan to use
2. put it in this directory
3. cd into this directory
4. change the map\_dir variable in Multimap to be equivalent to $PWD/Original
5. run ./setup.sh

### DEVELOPMENT
# dualfisheye2equirectangular_ffmpeg_remap
This is my foray into using ffmpeg's remap filters to turn dual fisheye
footage into the equirectangular footage used by VR video on Youtube
et al.

Big Kudo's go to the following people:

Ultramango on github. It was the inspiration for a lot of the work here

The ffmpeg user list for helping me sort out the more esoteric bits of the
  filter

What I did to get here:
1. Take some test footage

  1.a 360 camera was taken to a large open space with features on the horizon

  1.b camera was rotated slowly 360 degrees while recording

2. Do lens calibrations

  2.a Extract frames from the raw footage. Do enough to cover every 45
      degrees of rotation. More if you want to me more accurate

This command should create a subdir called frames, and take one frame every
  second from the input video

ffmpeg -i [Input.mp4] -q 2 -r 1 frames/dual%05d.jpg

Open Hugin, and load the images produced above.
Set the lens type to circular fisheye, and create a crop.
Un-tick center on d,e, and set the crop boundaries 0,0,1920,1920
The crop should now nicely fit over the left lens

Load all the images a second time, and this time highlight all the newly loaded
  images.
Right-click and select "New Lens"
Set lens type to circular fisheye, and create a crop again.
Un-tick center on d,e, and set the crop boundaries to 0,1921,3640,1920
The crop should now fit nicely over the right lens

In the images view, set the Yaw of the first image to 180
This rotates the images like ActionDirector

Under create control points, select Hugin's CPfind + Celeste, and create control
  points.
Once that is done, select optimize positions starting from anchor.
Once that is done, Highlight all the images, and right-click and select "Clean
  Control Points"
Once that is done, select optimize everything except positions.
Optimize,
Clean control points,
Optimize,
Clean control points
....
keep on doing this until the average distance between control points is 1.

Next thing is photometric optimisations.
Select custom parameters in photometric optimization drop-down.
Click on the Exposure tab that opens
un-select x, y coordinates.
copy the lens parameters for x and y into the vignetting.
Hit "optimize"


Set output canvas size to 3840x1920
Save your Hugin project as "dual leans optimize.pto"

Delete all images except the first left-hand image.
Save your project as "Left.pto"
Undo the delete, and delete all the images except the first right-hand image.
Save your project as "Right.pto"

Create an image that is a flat grey of the same dimensions as the video canvas.
In Hex "888888"
I called mine "grey.tif"

On a command line, run
nona -c Left.pto grey.tif -o l

then run
nona -c Right.pto grey.tif -o r

This should generate the 6 maps the remap filter fo ffmpeg needs.

Load l0000.tif in GIMP.
Use the fuzzy select tool, and select the transparent part of the image.
Load r0000.tif as a layer in the same gimp.
They should now be nicely overlaid, and you should have a nice band of overlap.
Add another transparent layer.
Select the new layer
Fill the selection with black
Use rectangular select to select a rectangle on the overlap between the images.
Fill with gradient foreground to transparent, so that the forground is on the
black selection earlier
Repeat on the other sidie of the earlier black selection
bucket fill the area between the gradients and earlier black selection with
black

Delete the two layers with images
Export the image as "Alpha_Map.png"

The Multimap script contains all the ffmpeg magic that actually does the
heavy lifting.

Inside the script there are some variables that can be set.
The first is "map_dir" which points to the directory in which all the tiff
files generated in the above steps have been saved. (I am still pondering
a proper place for them)

The second variable is "remap_dir" and this is the destination of the
remapped output files. Currently it just generates a subdirectory in the
current directory, and put the files in there.


Run the Multimap script on the input file with the input file as the only
argument

The Multimap script looks through the current directory and tries to convert all
the files it finds. When it detects a .jpg extention, it uses a different
compressor on the ffmpeg output. If the horizontal resolution of the input is
not 3840, it will rescale the input to be 3840, as that is the size of the
maps.

There is a difference between the remap of the video and photo of the Samsung
gear 360. To get around this, I took calibration photos at 45 degree steps,
and manually rescaled to 3840x1920 to simulate what the ffmpeg rescaler would
do anyways. Then I repeated the calibration steps with the images to get
special remaps for the photos.

The upshot of this is that you can now download your Samsung Gear 360 into
a directory, and run Multimap in that directory, and all the files will be
converted. The remaps will go to a "Remap" subdirectory, and the originals
will go into a "Original" directory. Both these are configurable in the script


:)
