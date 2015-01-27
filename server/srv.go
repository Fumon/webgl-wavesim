package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
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
	r.PathPrefix("/").Handler(http.FileServer(http.Dir("../ui")))
	http.Handle("/", r)

	log.Println("[i] Serving on ", servport, "\n\tWaiting...")

	log.Fatal(http.ListenAndServe(servport, nil))

	log.Println("[i] Shutting down...")
}
