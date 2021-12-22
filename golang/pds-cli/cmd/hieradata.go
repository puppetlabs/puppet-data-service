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
	levelStr      string
	keyStr        string
	valueStr      string
	hieraDataFile string
)

// hieraDataCmd represents the hieraData command
var hieraDataCmd = &cobra.Command{
	Use:   "hiera",
	Short: "Operations on hieraData",
}

var listHieraDataCmd = &cobra.Command{
	Use:   "list [-l LEVEL]",
	Short: "List all hieraData or hieraData for LEVEL",
	Args:  cobra.ExactArgs(0),
	Run: func(cmd *cobra.Command, args []string) {
		params := &client.GetHieraDataParams{}
		if levelStr != "" {
			level := client.OptionalHieraLevel(levelStr)
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
	Use:   "get -l LEVEL -k KEY",
	Args:  cobra.ExactArgs(0),
	Short: "Retrieve hieraData with LEVEL and KEY",
	Run: func(cmd *cobra.Command, args []string) {
		level := client.HieraLevel(levelStr)
		key := client.HieraKey(keyStr)
		response, err := pdsClient.GetHieraDataWithLevelAndKeyWithResponse(context.Background(), level, key)
		if err != nil {
			log.Fatalf("Couldn't get hieraData %s/%s: %s", level, key, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d\nbody: %s, headers: %v\n",
				response.HTTPResponse.StatusCode, response.Body, response.HTTPResponse.Header)
		}
		dump(response.JSON200)
	},
}

var deleteHieraDataCmd = &cobra.Command{
	Use:   "delete -l LEVEL -k KEY",
	Args:  cobra.ExactArgs(0),
	Short: "Delete hieraData with LEVEL and KEY",
	Run: func(cmd *cobra.Command, args []string) {
		level := client.HieraLevel(levelStr)
		key := client.HieraKey(keyStr)
		response, err := pdsClient.DeleteHieraDataObjectWithResponse(context.Background(), level, key)
		if err != nil {
			log.Fatalf("Couldn't delete hieraData %s/%s: %s", level, key, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d\nbody: %s, headers: %v\n",
				response.HTTPResponse.StatusCode, response.Body, response.HTTPResponse.Header)
		}
		dump(response.Status())
	},
}

var upsertHieraDataCmd = &cobra.Command{
	Use:   "upsert -l LEVEL -k KEY -v VALUE",
	Args:  cobra.ExactArgs(0),
	Short: "Upsert hiera data VALUE for KEY at LEVEL",
	Run: func(cmd *cobra.Command, args []string) {
		var value interface{}
		valueErr := json.Unmarshal([]byte(valueStr), &value)

		if valueErr != nil {
			log.Fatalf("Value is not valid JSON: %s", valueErr)
		}

		body := client.UpsertHieraDataWithLevelAndKeyJSONRequestBody{
			Value: &value,
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

var createHieraDataCmd = &cobra.Command{
	Use:   "create -f FILENAME",
	Args:  cobra.ExactArgs(0),
	Short: "Create hieradata in json file FILENAME",
	Run: func(cmd *cobra.Command, args []string) {

		// read the file
		file, err := ioutil.ReadFile(hieraDataFile)
		if err != nil {
			log.Fatalf("Couldn't open file %s: %s", hieraDataFile, err)
		}

		// unmarshal file contents into the request body
		var hieraData client.CreateHieraDataJSONRequestBody
		err = json.Unmarshal(file, &hieraData)
		if err != nil {
			log.Fatalf("Couldn't decode file %s: %s", hieraDataFile, err)
		}

		// Submit the request
		response, err := pdsClient.CreateHieraDataWithResponse(context.Background(), hieraData)

		// Handle errors
		if err != nil {
			hieraDataString, _ := json.MarshalIndent(hieraData, "", "\t")
			log.Fatalf("Couldn't create users %s: %s", hieraDataString, err)
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
	rootCmd.AddCommand(hieraDataCmd)

	hieraDataCmd.AddCommand(listHieraDataCmd)
	listHieraDataCmd.Flags().StringVarP(&levelStr, "level", "l", "", "Hiera level")

	hieraDataCmd.AddCommand(getHieraDataCmd)
	getHieraDataCmd.Flags().StringVarP(&levelStr, "level", "l", "", "Hiera level")
	getHieraDataCmd.Flags().StringVarP(&keyStr, "key", "k", "", "Hiera key")
	getHieraDataCmd.MarkFlagRequired("level")
	getHieraDataCmd.MarkFlagRequired("key")

	hieraDataCmd.AddCommand(deleteHieraDataCmd)
	deleteHieraDataCmd.Flags().StringVarP(&levelStr, "level", "l", "", "Hiera level")
	deleteHieraDataCmd.Flags().StringVarP(&keyStr, "key", "k", "", "Hiera key")
	deleteHieraDataCmd.MarkFlagRequired("level")
	deleteHieraDataCmd.MarkFlagRequired("key")

	hieraDataCmd.AddCommand(upsertHieraDataCmd)
	upsertHieraDataCmd.Flags().StringVarP(&levelStr, "level", "l", "", "Hiera level")
	upsertHieraDataCmd.Flags().StringVarP(&keyStr, "key", "k", "", "Hiera key")
	upsertHieraDataCmd.Flags().StringVarP(&valueStr, "value", "v", "", "Value (valid JSON)")
	upsertHieraDataCmd.MarkFlagRequired("level")
	upsertHieraDataCmd.MarkFlagRequired("key")
	upsertHieraDataCmd.MarkFlagRequired("value")

	hieraDataCmd.AddCommand(createHieraDataCmd)
	createHieraDataCmd.Flags().StringVarP(&hieraDataFile, "hieradatafile", "f", "", "JSON file containing an array of hiera data")
	createHieraDataCmd.MarkFlagRequired("hieradatafile")

}
