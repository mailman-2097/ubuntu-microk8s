// main.go
// https://www.golanglearn.com/golang-tutorials/get-ip-address-using-host-header-using-golang/

package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", ExampleHandler)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}
func ExampleHandler(w http.ResponseWriter, r *http.Request) {
	var ip string
	w.Header().Add("Content-Type", "application/json")
	forwarded := r.Header.Get("X-FORWARDED-FOR")
	log.Print(forwarded)
	if forwarded != "" {
		log.Print("forwarded")
		ip = forwarded
	} else {
		log.Print("Not forwarded")
		ip = r.RemoteAddr
	}
	resp, _ := json.Marshal(map[string]string{
		"ip": ip,
	})
	w.Write(resp)
}
