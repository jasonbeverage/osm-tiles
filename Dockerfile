FROM ubuntu:16.04

MAINTAINER jasonbeverage

RUN apt-get update && apt-get install -y \
    wget build-essential cmake libexpat1-dev zlib1g-dev libbz2-dev libsparsehash-dev \
    libboost-program-options-dev libboost-dev libgdal-dev libproj-dev git libgeos-dev

WORKDIR /code
RUN git clone https://github.com/osmcode/libosmium.git
RUN git clone --quiet --depth 1 https://github.com/mapbox/protozero.git
RUN git clone --quiet --depth 1 https://github.com/osmcode/osm-testdata.git

WORKDIR /code/libosmium

WORKDIR /code/libosmium/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF ..
RUN make

WORKDIR /code
RUN git clone https://github.com/osmcode/osmium-tool.git

WORKDIR /code/osmium-tool/build
RUN cmake .. && \
    make && \
    make install

WORKDIR /code
RUN git clone https://github.com/mapbox/tippecanoe.git
RUN cd tippecanoe && \
    make && \
    make install

ADD qa.json /qa.json