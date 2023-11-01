FROM debian:bookworm

RUN ln -s ld-linux-armhf.so.3 /lib/ld-linux.so.3

RUN apt-get update && \
	apt-get -y install \
		curl \
		unzip \
		procps \
		iproute2 \
	&& \
	apt-get clean

RUN mkdir /installer && \
	cd /installer && \
	curl -sfS -L -o mystic.zip https://mysticbbs.com/downloads/mys112a48_p32.zip && \
	unzip mystic.zip && \
	./install auto /mystic && \
	cd / && \
	rm -rf /installer

WORKDIR /mystic
VOLUME /data

COPY container-entrypoint.sh /usr/local/bin/
COPY run-mystic.sh /usr/local/bin/
ENTRYPOINT ["sh", "/usr/local/bin/container-entrypoint.sh"]
CMD ["sh", "/usr/local/bin/run-mystic.sh"]