package cmd

import (
	"encoding/json"
	"fmt"
	"log"
	"io/ioutil"
	"net/http"
	"crypto/tls"
	"crypto/x509"

	"github.com/deepmap/oapi-codegen/pkg/securityprovider"
	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds-go-client"
)

func dump(o interface{}) {
	bytes, _ := json.MarshalIndent(o, "", "\t")
	fmt.Println(string(bytes))
}

func createPDSClient(baseuri, token, caFile string) *client.ClientWithResponses {
	bearerTokenProvider, bearerTokenProviderErr := securityprovider.NewSecurityProviderBearerToken(token)
	if bearerTokenProviderErr != nil {
		panic(bearerTokenProviderErr)
	}

	// Load CA cert, if supplied
	var tlsConfig *tls.Config
	if caFile != "" {
		caCert, err := ioutil.ReadFile(caFile)
		if err != nil {
			log.Fatal(err)
		}
		caCertPool := x509.NewCertPool()
		caCertPool.AppendCertsFromPEM(caCert)
		tlsConfig = &tls.Config{RootCAs: caCertPool}
	} else {
		tlsConfig = &tls.Config{}
	}

	// Setup HTTPS client
	transport := &http.Transport{TLSClientConfig: tlsConfig}
	httpClient := &http.Client{Transport: transport}

	// Setup OpenAPI client
	clientWithResponses, err := client.NewClientWithResponses(baseuri,
	                                                          client.WithRequestEditorFn(bearerTokenProvider.Intercept),
	                                                          client.WithHTTPClient(httpClient))
	if err != nil {
		log.Fatalf("Couldn't instantiate PDS client: %s", err)
	}
	return clientWithResponses
}
