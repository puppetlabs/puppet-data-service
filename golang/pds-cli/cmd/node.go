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
	"encoding/json"
	"context"
	"log"

	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds-go-client"
	"github.com/spf13/cobra"
)

var (
	trustedExternalCommand bool
	nodename string
	codeEnvironment string
	classes []string
	trustedDataStr string
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
		dump(response.JSON200)
	},
}

var getNodeCmd = &cobra.Command{
	Use:   "get -n NODENAME",
	Args:  cobra.ExactArgs(0),
	Short: "Retrieve node with nodename NODENAME",
	Run: func(cmd *cobra.Command, args []string) {
		// username, _ := cmd.Flags().GetString("username")
		response, err := pdsClient.GetNodeByNameWithResponse(context.Background(), client.NodeName(nodename))
		if err != nil {
			log.Fatalf("Couldn't get node %s: %s", nodename, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		if (trustedExternalCommand) {
			dump(response.JSON200.EditableNodeProperties)
		} else {
			dump(response.JSON200)
		}
	},
}

var deleteNodeCmd = &cobra.Command{
	Use:   "delete -n NODENAME",
	Args:  cobra.ExactArgs(0),
	Short: "Delete node with nodename NODENAME",
	Run: func(cmd *cobra.Command, args []string) {
		// username, _ := cmd.Flags().GetString("username")
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
	Use:   "upsert -n NODENAME",
	Args:  cobra.ExactArgs(0),
	Short: "Upsert node with name NODENAME",
	Run: func(cmd *cobra.Command, args []string) {
		// Build the JSON body
		var trustedData map[string]interface{}
		trustedDataErr := json.Unmarshal([]byte(trustedDataStr), &trustedData)

		if trustedDataErr != nil {
			log.Fatalf("Couldn't parse trusted-data JSON: %s", trustedDataErr)
		}

		body := client.PutNodeByNameJSONRequestBody{
			ImmutableNodeProperties : client.ImmutableNodeProperties{
				Name : &nodename,
			},
			EditableNodeProperties : client.EditableNodeProperties{
				Classes : &classes,
				TrustedData : &trustedData,
			},
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

func init() {
	rootCmd.AddCommand(nodeCmd)

	nodeCmd.AddCommand(listNodesCmd)

	nodeCmd.AddCommand(getNodeCmd)
	getNodeCmd.Flags().BoolVar(&trustedExternalCommand, "trusted-external-command", false, 
		"for running as trusted_external_command: return only 'classes', 'code-environment' and 'trusted-data' properties.")
	getNodeCmd.Flags().StringVarP(&nodename, "name", "n", "", "Node name")
	getNodeCmd.MarkFlagRequired("name")

	nodeCmd.AddCommand(deleteNodeCmd)
	deleteNodeCmd.Flags().StringVarP(&nodename, "name", "n", "", "Node name")
	deleteNodeCmd.MarkFlagRequired("name")

	nodeCmd.AddCommand(upsertNodeCmd)
	upsertNodeCmd.Flags().StringVarP(&nodename, "name", "n", "", "Node name")
	upsertNodeCmd.Flags().StringVarP(&codeEnvironment, "code-environment", "e", "", "Node code-environment")
	upsertNodeCmd.Flags().StringSliceVarP(&classes, "classes", "c", []string{}, "Node classes (as comma-separated list)")
	upsertNodeCmd.Flags().StringVarP(&trustedDataStr, "trusted-data", "d", "{}", "Node trusted data (as valid JSON object)")
	upsertNodeCmd.MarkFlagRequired("name")
}
