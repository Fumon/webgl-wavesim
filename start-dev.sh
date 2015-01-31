#!/bin/sh

coffee -wc ui/js/script.coffee &
coffee -bwc ui/js/components/wavegen.coffee &

go run server/srv.go
