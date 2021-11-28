package cmd

import (
	"encoding/json"
	"fmt"
	"log"

	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds_go_client"
)

func dump(o interface{}) {
	bytes, _ := json.MarshalIndent(o, "", "\t")
	fmt.Println(string(bytes))
}

func createPDSClient() *client.ClientWithResponses {
	client, err := client.NewClientWithResponses(endpoint)
	if err != nil {
		log.Fatalf("Couldn't instantiate PDS client: %s", err)
	}
	return client
}
