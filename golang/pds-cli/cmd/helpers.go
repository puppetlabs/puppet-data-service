package cmd

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/deepmap/oapi-codegen/pkg/securityprovider"
	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds-go-client"
)

func dump(o interface{}) {
	bytes, _ := json.MarshalIndent(o, "", "\t")
	fmt.Println(string(bytes))
}

func createPDSClient(baseuri, token string) *client.ClientWithResponses {
	bearerTokenProvider, bearerTokenProviderErr := securityprovider.NewSecurityProviderBearerToken(token)
	if bearerTokenProviderErr != nil {
			panic(bearerTokenProviderErr)
	}
	client, err := client.NewClientWithResponses(baseuri, client.WithRequestEditorFn(bearerTokenProvider.Intercept))
	if err != nil {
		log.Fatalf("Couldn't instantiate PDS client: %s", err)
	}
	return client
}

