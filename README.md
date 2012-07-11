## Auto Photo Mosaic

This program facilitates the creation of the classic [photo mosaic](http://en.wikipedia.org/wiki/Photographic_mosaic), a large composition of many small photographs stitched together in such a way as to resemble a single photograph.

More information on this program, see [genekogan.com/works/mosaic](http://www.genekogan.com/works/mosaic).

![Example photo mosaic](http://www.genekogan.com/images/mosaic/mosaic-antigua_smaller.jpg)

### Usage

The basic workflow is to first analyze a large corpus of photographs to derive color distribution features and generate thumbnails. The result of this is a matlab data file (.mat) which contains this information for lookup later.  This step only needs to be done once.

After the analysis is done, the user supplies a path to a target image and a set of parameters, and it will create a large mosaic file and save it to disk.

More detailed usage instructions are found in the main program of the repository, main.m.

### Credit

Thanks to Ofir Pele for the [FastEMD](http://www.cs.huji.ac.il/~ofirpele/FastEMD/code/) implementation of [Earth Mover's distance](http://en.wikipedia.org/wiki/Earth_mover's_distance) which is used for determining image similarity.