# docker-svnserve

## What is docker-svnserve?

docker-svnserve is a unofficial docker image for the [svnserve][1] daemon.

[1]: http://svnbook.red-bean.com/en/1.7/svn.serverconfig.svnserve.html

## Why?

There are already a number of avaliable docker images for subversion and svnserve hosting. But most of them either are:

- Too involved; Containers shouldn't be like aplications themselves with configuration in environment variables, etc. Instead, images should be extensible so other users can create their own images with customizations, based on yours.
- Bloated; Based on heavy *fat-container* base images.
- Don't handle signals properly, forcing docker to send `SIGKILL` to the process.

This image is based on [Alpine linux][1] for small footprint and uses [Tini][2] as a single-child init system to properly handle signals, reap zombies, etc.

[1]: https://alpinelinux.org
[2]: https://github.com/krallin/tini

## How to use this image

The image is intented to run as a daemon; it exposed the default svnserve port (`3690`) and a single volume at `/var/opt/svn` which `svnserve` uses as it's root. A container based on this image could be created as:

```
docker run \
    --detatch \
    --name svnserve \
    --restart always \
    --expose 3690:3690/tcp \
    --volume /var/opt/svn:/var/opt/svn:rw \
    gcscaglia/svnserve:latest
```

With the above comand, `svnserve` will:
- run in daemon mode
- listen on the standard port on all host's interfaces
- (re)start with the system 
- serve repositories from `/var/opt/svn` in the host's filesystem.

### Adminstration

In order to create, manage and backup repositories, two approaches can be combined:

1. Directly accessing the repositories on the filesystem. This should be enough for cold-bakups and user management depending on how you autenticate your users.
2. By running your commands inside the container (using `docker-exec`). This allows access to [svn adminstration tools][1]

[1]: http://svnbook.red-bean.com/en/1.7/svn.reposadmin.html

