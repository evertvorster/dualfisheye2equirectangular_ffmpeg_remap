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

Still looking for the best way to do lens calibrations

Use nona -c lens.pto to create x & y translation maps

Run the Ffmeg_360 script on the input file with the input file as the only
argument

Still todo:
1. Find best lens calibration
2. Fix up README.md
