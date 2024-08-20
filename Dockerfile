FROM alpine:edge
LABEL maintainer="sanderjo"
ARG SABNZBD_VERSION="4.3.3RC1"
ARG UNRAR_VERSION="7.0.9"
# environment settings
ENV HOME="/config" PYTHONIOENCODING=utf-8

# SABnzbd Docker on RISCV64, with RVV in par2-turbo and sabctools

RUN \
	echo "**** install packages ****" && \
	apk add python3 py3-cryptography py3-cffi py3-pip python3-dev curl gcc g++ make automake autoconf git && \
	echo "installing done"
RUN \
	echo "starting unrar ..." && \
	curl -o /tmp/unrarsrc.tar.gz -L "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \
	mkdir /tmp/unrar && \
	tar xf /tmp/unrarsrc.tar.gz -C /tmp/unrar --strip-components=1 && \
	cd /tmp/unrar/ && \
	cp makefile makefile.riscv64 && \
	sed -e "s/\-march=native//g" -i  makefile.riscv64 && \
	make -j3 -f makefile.riscv64 && \
	make install && \
	echo "unrar done"
RUN \
	cd /tmp && \
	git clone https://github.com/animetosho/par2cmdline-turbo.git && \
	cd par2cmdline-turbo/ && \
	cp /usr/share/autoconf/build-aux/config.guess . && \
	cp /usr/share/autoconf/build-aux/config.sub . && \
	./automake.sh && \
	./configure && \
	make -j3 && \
	./par2 --version && \
	objdump -d par2 | awk '{ print $3 }'  | sort | uniq -c | grep " v" && \
	make install && \
	echo "par2cmdline-turbo done"
RUN \
	python3 -m venv --system-site-packages  /venv && \
	curl -o /tmp/sabnzbd.tar.gz -L "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" && \
	ls -al /tmp/sabnzbd.tar.gz && \
	mkdir -p /app/sabnzbd && \
	tar xf /tmp/sabnzbd.tar.gz -C /app/sabnzbd --strip-components=1 && \
	cd /app/sabnzbd && \
	sed -i '/^cryptography/d' requirements.txt && \
	sed -i '/^cffi/d' requirements.txt && \    
	/venv/bin/python3 -m pip install -r requirements.txt -U && \
 	echo "sabnzbd done"
  
CMD cd /app/sabnzbd && /venv/bin/python3 SABnzbd.py -b0 -l2 --server 0.0.0.0:8080

EXPOSE 8080
VOLUME /config
