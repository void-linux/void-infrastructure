# DevSpace

Sometimes maintainers wish to distribute certain files to either each
other or to external users for test.  A good example is new builds of
the major browsers, and builds that are unsuitable for inclusion in
the main repo in their current state, such as when a new technology is
being trialed.

For these purposes Void Linux maintains the worlds worst webhost, void
DevSpace.  This is a webserver and SFTP server combination that derive
authentication from NetAuth so that its users are divorced from users
on the physical host.  The hosting service provided is extremely
limited and its only feature is auto-indexing of the filesystem tree.

If you are a currently active maintainer and wish to have an account
on this system, contact `maldridge@`.  Once you have an account you
may connect via SFTP to `devspace-sftp.voidlinux.org` on port number
2022.  Expect the following key fingerprints:

```
3072 SHA256:kQvGWsG7SGP4qTHn11RtifPJIxDchzdWDqoYcW9obrw [devspace-sftp.voidlinux.org]:2022 (RSA)
256 SHA256:/1lubJnK04FUqH+NJH9QXRyzuK1BDq2baRa21K/OzzQ [devspace-sftp.voidlinux.org]:2022 (ECDSA)
256 SHA256:E/VvL7jVtAGutQDyswxm/dL639i56wEHiDJgS5L+QQ8 [devspace-sftp.voidlinux.org]:2022 (ED25519)
```
