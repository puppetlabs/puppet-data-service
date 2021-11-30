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
	"log"

	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds_go_client"
	"github.com/spf13/cobra"
)

// hieradataCmd represents the hieradata command
var hieradataCmd = &cobra.Command{
	Use:   "hiera",
	Short: "Operations on hiera-data",
}

var listHieradataCmd = &cobra.Command{
	Use:   "list [LEVEL]",
	Short: "List all hieradata or hieradata for LEVEL",
	Args:  cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		level := client.OptionalHieraLevel("")
		if len(args) > 0 {
			level = client.OptionalHieraLevel(args[0])
		}
		params := &client.GetHieraDataParams{Level: &level}
		response, err := pdsClient.GetHieraDataWithResponse(context.Background(), params)
		if err != nil {
			log.Fatalf("Couldn't list hieradata: %s", err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.JSON200)
	},
}

var getHieradataCmd = &cobra.Command{
	Use:   "get hiera LEVEL KEY",
	Args:  cobra.ExactArgs(2),
	Short: "Retrieve hieradata with LEVEL and KEY",
	Run: func(cmd *cobra.Command, args []string) {
		level := client.HieraLevel(args[0])
		key := client.HieraKey(args[1])
		response, err := pdsClient.GetHieraDataWithLevelAndKeyWithResponse(context.Background(), level, key)
		if err != nil {
			log.Fatalf("Couldn't get hieradata %s/%s: %s", level, key, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.JSON200)
	},
}

// var deletehieradataCmd = &cobra.Command{
// 	Use:   "delete hieradataNAME",
// 	Args:  cobra.ExactArgs(1),
// 	Short: "Delete hieradata with hieradataname hieradataNAME",
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

// var puthieradataCmd = &cobra.Command{
// 	Use:   "put hieradataNAME",
// 	Args:  cobra.ExactArgs(1),
// 	Short: "Put hieradata with hieradataname hieradataNAME",
// 	Run: func(cmd *cobra.Command, args []string) {
// 		// username, _ := cmd.Flags().GetString("username")
// 		hieradataname := args[0]
// 		body := client.No
// 		response, err := pdsClient.PuthieradataByNameWithBodyWithResponse(context.Background(), client.hieradataName(hieradataname), "application/json", body)
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
	rootCmd.AddCommand(hieradataCmd)
	hieradataCmd.AddCommand(listHieradataCmd)
	hieradataCmd.AddCommand(getHieradataCmd)
	// hieradataCmd.AddCommand(deletehieradataCmd)
}