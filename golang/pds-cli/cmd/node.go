/*
Copyright © 2021 NAME HERE <EMAIL ADDRESS>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"log"

	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds-go-client"
	"github.com/spf13/cobra"
)

var (
	trustedExternalCommand bool
	codeEnvironment string
	classes []string
	dataStr string
	nodeFile string
)

// nodeCmd represents the node command
var nodeCmd = &cobra.Command{
	Use:   "node",
	Short: "Operations on nodes",
}

var listNodesCmd = &cobra.Command{
	Use:   "list",
	Short: "List nodes",
	Run: func(cmd *cobra.Command, args []string) {
		response, err := pdsClient.GetAllNodesWithResponse(context.Background())
		if err != nil {
			log.Fatalf("Couldn't get nodes %s", err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.JSON200)
	},
}

var getNodeCmd = &cobra.Command{
	Use:   "get NODENAME",
	Args:  cobra.ExactArgs(1),
	Short: "Retrieve node with nodename NODENAME",
	Run: func(cmd *cobra.Command, args []string) {
		nodename := args[0]
		response, err := pdsClient.GetNodeByNameWithResponse(context.Background(), client.NodeName(nodename))
		if err != nil {
			log.Fatalf("Couldn't get node %s: %s", nodename, err)
		}

		if (response.HTTPResponse.StatusCode == 404 && trustedExternalCommand) {
			// On 404, trusted external command returns empty node entity
      data := make(map[string]interface{})
			dump(client.EditableNodeProperties{Classes: &classes, CodeEnvironment: nil, Data: &data})
		} else if response.HTTPResponse.StatusCode > 299 {
			// Fail on errors otherwise
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		} else if (trustedExternalCommand) {
			// Return just editable properties if trusted-external-command
			dump(response.JSON200.EditableNodeProperties)
		} else {
			// Else return all properties
			dump(response.JSON200)
		}
	},
}

var deleteNodeCmd = &cobra.Command{
	Use:   "delete NODENAME",
	Args:  cobra.ExactArgs(1),
	Short: "Delete node with nodename NODENAME",
	Run: func(cmd *cobra.Command, args []string) {
		nodename := args[0]
		response, err := pdsClient.DeleteNodeWithResponse(context.Background(), client.NodeName(nodename))
		if err != nil {
			log.Fatalf("Couldn't delete node %s: %s", nodename, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.Status())
	},
}

var upsertNodeCmd = &cobra.Command{
	Use:   "upsert NODENAME",
	Args:  cobra.ExactArgs(1),
	Short: "Upsert node with name NODENAME",
	Run: func(cmd *cobra.Command, args []string) {
		nodename := args[0]

		// Build the JSON body
		var data map[string]interface{}
		dataErr := json.Unmarshal([]byte(dataStr), &data)

		if dataErr != nil {
			log.Fatalf("Couldn't parse trusted-data JSON: %s", dataErr)
		}

		body := client.PutNodeByNameJSONRequestBody{
			Classes : &classes,
			Data : &data,
		}

		if codeEnvironment != "" {
			body.CodeEnvironment = (*client.EditableNodePropertiesCodeEnvironment)(&codeEnvironment)
		}

		// Submit the request
		response, err := pdsClient.PutNodeByNameWithResponse(context.Background(), client.NodeName(nodename), body)

		// Handle errors
		if err != nil {
			log.Fatalf("Couldn't upsert node %s: %s", nodename, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}

		// Print results
		if response.JSON201 == nil {
			dump(response.JSON200)
		} else {
			dump(response.JSON201)
		}
	},
}

var createNodeCmd = &cobra.Command{
	Use:   "create -f FILENAME",
	Args:  cobra.ExactArgs(0),
	Short: "Create nodes in json file FILENAME",
	Run: func(cmd *cobra.Command, args []string) {

		// read the file
		file, err := ioutil.ReadFile(nodeFile)
		if err != nil {
			log.Fatalf("Couldn't open file %s: %s", nodeFile, err)
		}

		// unmarshal file contents into the request body
		var nodes client.CreateNodeJSONRequestBody
		err = json.Unmarshal(file, &nodes)
		if err != nil {
			log.Fatalf("Couldn't decode file %s: %s", nodeFile, err)
		}

		// Submit the request
		response, err := pdsClient.CreateNodeWithResponse(context.Background(), nodes)

		// Handle errors
		if err != nil {
			nodesString, _ := json.MarshalIndent(nodes, "", "\t")
			log.Fatalf("Couldn't create users %s: %s", nodesString, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d\nbody: %s\nheaders: %v\n", 
				response.HTTPResponse.StatusCode, response.Body, response.HTTPResponse.Header)
		}

		// Print results
		if response.JSON201 != nil {
			dump(response.JSON201)
		}
	},
}

func init() {
	rootCmd.AddCommand(nodeCmd)

	nodeCmd.AddCommand(listNodesCmd)

	nodeCmd.AddCommand(getNodeCmd)
	getNodeCmd.Flags().BoolVar(&trustedExternalCommand, "trusted-external-command", false, 
		"for running as trusted_external_command: return only 'classes', 'code-environment' and 'trusted-data' properties.")

	nodeCmd.AddCommand(deleteNodeCmd)

	nodeCmd.AddCommand(upsertNodeCmd)
	upsertNodeCmd.Flags().StringVarP(&codeEnvironment, "code-environment", "e", "", "Node code-environment")
	upsertNodeCmd.Flags().StringSliceVarP(&classes, "classes", "c", []string{}, "Node classes (as comma-separated list)")
	upsertNodeCmd.Flags().StringVarP(&dataStr, "trusted-data", "d", "{}", "Node trusted data (as valid JSON object)")

	nodeCmd.AddCommand(createNodeCmd)
	createNodeCmd.Flags().StringVarP(&nodeFile, "nodefile", "f", "", "JSON file containing an array of nodes")
	createNodeCmd.MarkFlagRequired("nodefile")
}
