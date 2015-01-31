package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path"

	"github.com/gorilla/mux"
)

var servport = ":6863"

func failOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("[X] %s, %s", msg, err)
		panic(fmt.Sprintf("%s, %s", msg, err))
	}
}

func main() {
	log.Println("[i] Server started")

	// Restful handler
	r := mux.NewRouter()

	_, file := path.Split(os.Args[0])
	if file == "server" {
		r.PathPrefix("/").Handler(http.FileServer(http.Dir("/ui")))
	} else {
		log.Println("[i] Dev mode")
		r.PathPrefix("/").Handler(http.FileServer(http.Dir("./ui")))
	}

	http.Handle("/", r)

	log.Println("[i] Serving on ", servport, "\n\tWaiting...")

	log.Fatal(http.ListenAndServe(servport, nil))

	log.Println("[i] Shutting down...")
}
