# Distributable Images

Void prepares and distributes multiple live images.  These are
prepared manually due to the need for full root authority during
build, and for the need to sign them after building.

## Prepare the Environment

The images must be built from the root mirror in order to be done in a
reasonable amount of time.  This is constrained by network bandwidth,
available compute power, and security requirements for signing the
images.

First stop all non-essential services.  This includes the buildmaster,
local buildslaves, and if the redis server is consuming too much
memory then that too.

```
# sv down void-buildmaster
# sv down void-buildslave-armv6l
# sv down void-buildslave-armv7l
# sv down void-buildslave-i686
# sv down void-buildslave-x86_64
```

Now install the required extra packages:

```
# xbps-install qemu-user-static xz git lz4 liblz4
```

Obtain the contents of mklive:

```
$ git clone https://github.com/void-linux/void-mklive.git
```

Perform the initial make for templating:

```
$ cd void-mklive
$ make
```

Now the contents of lib.sh should be edited to pull the packages
directly from disk rather than via http since the root mirror is
available locally.

Locate the `XBPS_REPOSITORY` declaration at the bottom of the file and
change the references from `http://alpha.de.repo.voidlinux.org` to
`/hostdir/binpkgs`.

## Building the Images

Building the images takes several hours with large gaps of time in
between.  Make sure you have time to finish the build before starting.

*!! Warning !!* Beware of UTC midnight while building.  The
intermediate stages are all keyed with a datecode, and if the build
crosses midnight UTC you'll suddenly find multiple copies of rootfs's
being built.  Since the mirror is locked this shouldn't be a problem,
but its still best to try and avoid it.

### Building the root filesystems.

All the rest of the builds depend on the availability of the root
filesystems for each architecture.  This process should be run first
and usually if something is going to go wrong it will go wrong here.

Verify that the root filesystem list is correct:

```
$ make rootfs-all-print
void-i686-ROOTFS-20190217.tar.xz
void-x86_64-ROOTFS-20190217.tar.xz
void-x86_64-musl-ROOTFS-20190217.tar.xz
void-armv6l-ROOTFS-20190217.tar.xz
void-armv6l-musl-ROOTFS-20190217.tar.xz
void-armv7l-ROOTFS-20190217.tar.xz
void-armv7l-musl-ROOTFS-20190217.tar.xz
void-aarch64-ROOTFS-20190217.tar.xz
void-aarch64-musl-ROOTFS-20190217.tar.xz
```

Your list should match with the exception of dates.  If it does not,
either the makefile or the docs are out of date, figure out which one
and send a patch.

Now you are ready to build the root filesystems:

```
$ sudo make rootfs-all
```

Make here should be called with sudo to ensure that sudo doesn't time
out inside of make.

### Building the platform filesystems.

Once the root filesystems have built, they can be specialized into
platform filesystems.  These have system specific adaptations added to
them which make them suitable for installation targets.

Verify that the platformfs list is correct:

```
$ make platformfs-all-print
void-rpi-PLATFORMFS-20190217.tar.xz
void-rpi-musl-PLATFORMFS-20190217.tar.xz
void-rpi2-PLATFORMFS-20190217.tar.xz
void-rpi2-musl-PLATFORMFS-20190217.tar.xz
void-rpi3-PLATFORMFS-20190217.tar.xz
void-rpi3-musl-PLATFORMFS-20190217.tar.xz
void-beaglebone-PLATFORMFS-20190217.tar.xz
void-beaglebone-musl-PLATFORMFS-20190217.tar.xz
void-cubieboard2-PLATFORMFS-20190217.tar.xz
void-cubieboard2-musl-PLATFORMFS-20190217.tar.xz
void-odroid-c2-PLATFORMFS-20190217.tar.xz
void-odroid-c2-musl-PLATFORMFS-20190217.tar.xz
void-usbarmory-PLATFORMFS-20190217.tar.xz
void-usbarmory-musl-PLATFORMFS-20190217.tar.xz
void-GCP-PLATFORMFS-20190217.tar.xz
void-GCP-musl-PLATFORMFS-20190217.tar.xz
```

As above your list should match with the exception of the datecodes.
If it does not match, it is likely this list is out of date and
another platform has been added or one of the old ones has been
dropped.  Send a patch to update this page.

As above call make with sudo to build the filesystems:

```
$ sudo make platformfs-all
```

### Building the PXE images.

The PXE images are a specialized set of images for x86_64 and
x86_64-musl that are intended to allow running Void at large scale.
These images can be booted over the network to support installing Void
on a large number of machines at once.


As before, confirm the correct images will be built:

```
$ make pxe-all-print
void-x86_64-NETBOOT-20190217.tar.gz
void-x86_64-musl-NETBOOT-20190217.tar.gz
```

And finally build the images:

```
$ sudo make pxe-all
```

### Building the ISO images.

The ISO images do not follow the same build process as the rest of the
system.  To build these you should use the `build-x86-images.sh`
script which does a one-shot build of all the images.

First build the x86_64 images:

```
$ sudo ./build-x86-images.sh -r /hostdir/binpkgs
```

Then build the musl equivalents:

```
$ sudo ./build-x86_64-images.sh -a x86_64musl -r /hostdir/binpkgs/musl
```

And finally the x86 images:

```
$ sudo ./build-x86-images.sh -a i686 -r /hostdir/binpkgs
```

## Collecting the Images

Once all images are built, they need to be collected into a directory,
signed, and moved into place.

```
$ mkdir <date>
$ mv void*<date>* <date>/
```

Generate the sha256sums:

```
$ cd <date>
$ sha256 * > sha256.txt
```

## Signing the Images

Signing the images is done after all the images have been checked and
validated, and after the decision has been made to promote the set to
`current`.

Generate a new signing key:

```
$ pwgen -cny 25 1 > void-release-<date>.key
$ signify -G -p void-release-<date>.pub -s void-release-<date>.sec -c "This key is only valid for images with date <date>."
```

Copy the public half of this key to the void-release-keys package in
void-packages and make a release.  Copy all key material to the
owner's team in keybase and ensure that the copy has been completed
successfully.

Copy the `sha256.txt` file to your local workstation and sign it with the appropriate key.

```
$ signify -S -e -s void-release-<date>.sec -m sha256.txt -x sha256sum.sig
```

Copy the signed file back up to the master mirror and change the
current symlink to point to the now signed ISOs.

Once you have confirmed that the link has updated, post an update to
the website and arrange for the new key to be distributed as widely as
possible.
