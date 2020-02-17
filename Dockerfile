FROM ubuntu:latest as localized-ubuntu

# generate locales (WA: for more info see https://github.com/bakwc/JamSpell/issues/17)
RUN apt-get update && apt-get -y install locales && locale-gen en_US.UTF-8

# set locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

FROM localized-ubuntu as builder

WORKDIR /jamspell

# install git and cmake
RUN apt-get -y install git build-essential cmake

# clone jamspell repo
RUN git clone https://github.com/bakwc/JamSpell.git .

# build jamspell
RUN mkdir build && cd build && cmake .. && make

# copy training data
COPY dataset.txt dataset.txt
COPY alphabet.txt alphabet.txt

# train custom model
RUN ./build/main/jamspell train alphabet.txt dataset.txt model.bin

FROM localized-ubuntu

ENV PORT=8080

COPY --from=builder /jamspell/build/web_server/web_server /usr/bin/jamspell-server
COPY --from=builder /jamspell/model.bin model.bin

EXPOSE $PORT

ENTRYPOINT exec /usr/bin/jamspell-server model.bin 0.0.0.0 ${PORT}
