FROM alpine:edge

LABEL maintainer="sanderjo"

# environment settings
ENV HOME="/config" PYTHONIOENCODING=utf-8

RUN \
	echo "**** install packages ****" && \
	apk add python3 py3-cryptography py3-cffi py3-pip python3-dev curl gcc g++ make automake autoconf git && \

	cd /tmp && \
	git clone https://github.com/animetosho/par2cmdline-turbo.git && \
	cd par2cmdline-turbo/ && \
	git reset --hard 8bd0a431e58716cf8456696867a59829aa72771b && \
	cp /usr/share/autoconf/build-aux/config.guess . && \
	cp /usr/share/autoconf/build-aux/config.sub . && \
	./automake.sh && \
	./configure && \
	sed -i -e 's/c99/gnu99/g' Makefile && \
	make -j3 && \
	./par2 --version && \
	objdump -d par2 | awk '{ print $3 }'  | sort | uniq -c | grep " v" && \
	make install && \

	curl -o /tmp/unrarsrc.tar.gz -L https://www.rarlab.com/rar/unrarsrc-7.0.9.tar.gz && \
	mkdir /tmp/unrar && \
	tar xf /tmp/unrarsrc.tar.gz -C /tmp/unrar --strip-components=1 && \
	cd /tmp/unrar/ && \
	sed -e "s/\-march=native//g" -i  makefile && \
	make -j3 && \
	make install && \

	python3 -m venv --system-site-packages  /venv && \
	curl -o /tmp/sabnzbd.tar.gz -L "https://github.com/sabnzbd/sabnzbd/releases/download/4.3.3RC1/SABnzbd-4.3.3RC1-src.tar.gz" && \
	ls -al /tmp/sabnzbd.tar.gz && \
	mkdir -p /app/sabnzbd && \
	tar xf /tmp/sabnzbd.tar.gz -C /app/sabnzbd --strip-components=1 && \
	cd /app/sabnzbd && \
	sed -i '/^cryptography/d' requirements.txt && \
	sed -i '/^cffi/d' requirements.txt && \    
	/venv/bin/python3 -m pip install -r requirements.txt -U && \
 	echo "Done building"
  
CMD /venv/bin/python3 SABnzbd.py -b0 -l2 --server 0.0.0.0:8080

      

EXPOSE 8080
VOLUME /config
