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
	levelStr string
	keyStr string
	valueStr string
)

// hieraDataCmd represents the hieraData command
var hieraDataCmd = &cobra.Command{
	Use:   "hiera",
	Short: "Operations on hieraData",
}

var listHieraDataCmd = &cobra.Command{
	Use:   "list [LEVEL]",
	Short: "List all hieraData or hieraData for LEVEL",
	Args:  cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		params := &client.GetHieraDataParams{}
		if len(args) > 0 {
			level := client.OptionalHieraLevel(args[0])
			params.Level = &level
		}
		response, err := pdsClient.GetHieraDataWithResponse(context.Background(), params)
		if err != nil {
			log.Fatalf("Couldn't list hieraData: %s", err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.JSON200)
	},
}

var getHieraDataCmd = &cobra.Command{
	Use:   "get LEVEL KEY",
	Args:  cobra.ExactArgs(2),
	Short: "Retrieve hieraData with LEVEL and KEY",
	Run: func(cmd *cobra.Command, args []string) {
		level := client.HieraLevel(args[0])
		key := client.HieraKey(args[1])
		response, err := pdsClient.GetHieraDataWithLevelAndKeyWithResponse(context.Background(), level, key)
		if err != nil {
			log.Fatalf("Couldn't get hieraData %s/%s: %s", level, key, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.JSON200)
	},
}

var deleteHieraDataCmd = &cobra.Command{
	Use:   "delete LEVEL KEY",
	Args:  cobra.ExactArgs(2),
	Short: "Delete hieraData with LEVEL and KEY",
	Run: func(cmd *cobra.Command, args []string) {
		level := client.HieraLevel(args[0])
		key := client.HieraKey(args[1])
		response, err := pdsClient.DeleteHieraDataObjectWithResponse(context.Background(), level, key)
		if err != nil {
			log.Fatalf("Couldn't delete hieraData %s/%s: %s", level, key, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.Status())
	},
}

var upsertHieraDataCmd = &cobra.Command{
	Use:   "upsert -l=LEVEL -k=KEY -v=VALUE",
	Args:  cobra.ExactArgs(0),
	Short: "Upsert hiera data VALUE for KEY at LEVEL",
	Run: func(cmd *cobra.Command, args []string) {
		var value interface{}
		valueErr := json.Unmarshal([]byte(valueStr), &value)

		if valueErr != nil {
			log.Fatalf("Value is not valid JSON: %s", valueErr)
		}

		body := client.UpsertHieraDataWithLevelAndKeyJSONRequestBody{
			EditableHieraValueProperties : client.EditableHieraValueProperties{
				Value : &value,
			},
		}

		response, err := pdsClient.UpsertHieraDataWithLevelAndKeyWithResponse(context.Background(), client.HieraLevel(levelStr), client.HieraKey(keyStr), body)

		if err != nil {
			log.Fatalf("Couldn't upsert hiera data %s/%s: %s", levelStr, keyStr, err)
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

// // var deletehieraDataCmd = &cobra.Command{
// 	Use:   "delete hieraDataNAME",
// 	Args:  cobra.ExactArgs(1),
// 	Short: "Delete hiera data with hieraDataname hieradataNAME",
// 	Run: func(cmd *cobra.Command, args []string) {
// 		// username, _ := cmd.Flags().GetString("username")
// 		hieradataname := args[0]
// 		response, err := pdsClient.DeletehieradataWithResponse(context.Background(), client.hieradataName(hieradataname))
// 		if err != nil {
// 			log.Fatalf("Couldn't delete hieradata %s: %s", hieradataname, err)
// 		}
// 		if response.HTTPResponse.StatusCode > 299 {
// 			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
// 		}
// 		dump(response.Status())
// 	},
// }

func init() {
	rootCmd.AddCommand(hieraDataCmd)
	hieraDataCmd.AddCommand(listHieraDataCmd)
	hieraDataCmd.AddCommand(getHieraDataCmd)
	hieraDataCmd.AddCommand(deleteHieraDataCmd)

	hieraDataCmd.AddCommand(upsertHieraDataCmd)
	upsertHieraDataCmd.Flags().StringVarP(&levelStr, "level", "l", "", "Node code-environment")
	upsertHieraDataCmd.Flags().StringVarP(&keyStr, "key", "k", "", "Node code-environment")
	upsertHieraDataCmd.Flags().StringVarP(&valueStr, "value", "v", "", "Node code-environment")
	upsertHieraDataCmd.MarkFlagRequired("level")
	upsertHieraDataCmd.MarkFlagRequired("key")
	upsertHieraDataCmd.MarkFlagRequired("value")
}
