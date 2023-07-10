# Distributable Images

Void prepares and distributes multiple live images. These are prepared manually
due to the need for full root authority during build, and for the need to sign
them after building.

## Building the Images

The images should be built using Github CI in the void-mklive repository. This
can be triggered [on
Github](https://github.com/void-linux/void-mklive/actions/workflows/gen-images.yml)
or by using the `release.sh` script in void-mklive:

```
$ ./release.sh start
```

By default, this will build:

- Live ISOs with `base` and `xfce` variants for `x86_64*` and `i686`
- ROOTFSes for `x86_64*`, `i686`, `aarch64*`, `armv7l*`, and `armv6l*`
- PLATFORMFSes for `aarch64*`, `armv7l*`, and `armv6l*` Raspberry Pis
- SBC images for `aarch64*`, `armv7l*`, and `armv6l*` Raspberry Pis

This will take approximately 2 hours for the default settings. To ensure all
images have the same datecode, the datecode is cached at the beginning of the
run. The CI workflow will also generate `sha256sum.txt` for the built images.

## Collecting the Images

Once all images are built, they need to be collected from the Github CI
artifacts. This can be done via the Github CI web interface, on the "Summary"
tab of the CI run, or void-mklive's `release.sh` can download them to a
directory called `void-live-<date>` with:

```
$ ./release.sh dl
```

> Note: this currently assumes latest successful CI run is the one to download.

Once downloaded, verify all sha256sums match:

```
$ cd void-live-<date>
$ sha256sum -C *
```

The images can then be uploaded to [DevSpace](/services/devspace.md) or the
mirrors for testing.

## Signing the Images

Signing the images is done after all the images have been checked and validated,
and after the decision has been made to promote the set to `current`.

Generate a new signing key:

```
$ export DATECODE=<date>
$ pwgen -cny 25 1 > void-release-$DATECODE.key
$ cat void-release-$DATECODE.key void-release-$DATECODE.key | \
	minisign -G -p void-release-$DATECODE.pub -s void-release-$DATECODE.sec \
	-c "This key is only valid for images with date $DATECODE." \
```

Copy the public half of this key to the `void-release-keys` package in
`void-packages` and make a release. Copy the passphrase (`.key`), privkey
(`.sec`), and pubkey (`.pub`) to
`secret/releng/image-keys/<date>/{passphrase,privkey,pubkey}` in Vault and
ensure that the copy has been completed successfully.

Copy the `sha256sum.txt` file to your local workstation and sign it with the
appropriate key.

```
$ minisign -S -x sha256sum.sig -s void-release-$DATECODE.sec \
	-c "This key is only valid for images with date $DATECODE." \
	-t "This key is only valid for images with date $DATECODE." \
	-m sha256sum.txt < void-release-$DATECODE.key
```

Alternatively, key generation and signing can be done with `release.sh` in
`void-mklive`, which will generate the proper keys and sign the files as
described above:

```
$ ./release.sh sign <date> sha256sum.txt
```

Copy the signed file back up to the master mirror and change the current symlink
to point to the now signed ISOs.

Once you have confirmed that the link has updated, post an update to the website
and arrange for the new key to be distributed as widely as possible.
