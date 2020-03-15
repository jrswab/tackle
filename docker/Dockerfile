FROM ubuntu:16.04
LABEL Maintainer: @jrswab

RUN apt-get update \
	&& apt-get install -y \
		bash \ 
		wget \
		jq \ 
		vim \
		tmux \
		libreadline6 \
		nano \
		autotools-dev \
		build-essential \
		g++ \
		libbz2-dev \
		libicu-dev \
		doxygen \
		python3-dev \
		python3-pip \
		libboost-all-dev \
	&& apt-get clean -qy \
	&& useradd --create-home --shell /bin/bash witness

# P2P port
EXPOSE 2001
# RPC port
EXPOSE 8090

USER witness
WORKDIR /home/witness/

COPY config/ /home/witness/.config/
COPY wallet.sh /home/witness/
COPY smoked.sh /home/witness/
COPY config.sh /home/witness/
COPY update.sh /home/witness/

CMD ["/home/witness/.config/install.sh"]
