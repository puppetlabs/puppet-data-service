package cmd

import (
	"encoding/json"
	"fmt"
	"log"

	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds_go_client"
)

// func dumpFunc(f func(context.Context, ...client.RequestEditorFn) (*interface{}, error)) {
// 	response, err := f(context.Background())
// 	if err != nil {
// 		log.Fatalf("Couldn't retrieve data %s", err)
// 	}
// 	dump(response)

// }
func dump(o interface{}) {
	bytes, _ := json.MarshalIndent(o, "", "\t")
	fmt.Println(string(bytes))
}

func createPDSClient() *client.ClientWithResponses {
	client, err := client.NewClientWithResponses("http://127.0.0.1:4010")
	if err != nil {
		log.Fatalf("Couldn't instantiate client: %s", err)
	}
	return client
}
