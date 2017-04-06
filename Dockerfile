FROM alpine:3.5
RUN \
	apk add --update --no-cache \
		tini \
		subversion

# Use tini 'init' system to handle signals properly:
# https://github.com/krallin/tini
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/bin/svnserve", "--daemon", "--foreground", "--root", "/var/opt/svn"]
VOLUME ["/var/opt/svn"]
EXPOSE 3690
