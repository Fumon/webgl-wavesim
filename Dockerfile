FROM golang
ADD ./server /go/src/github.com/Fumon/webgl-wavesim/server
ADD ./ui /ui
RUN go get -v -d github.com/Fumon/webgl-wavesim/server
RUN go install github.com/Fumon/webgl-wavesim/server
ENTRYPOINT /go/bin/server
EXPOSE 6863
