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

	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds-go-client"
	"github.com/spf13/cobra"
)

var (
	userEmail string
	userRole string
)

var userCmd = &cobra.Command{
	Use:   "user",
	Short: "Operations on users",
}

var listUsersCmd = &cobra.Command{
	Use:   "list",
	Short: "List users",
	Run: func(cmd *cobra.Command, args []string) {
		// fmt.Println("listusers called")
		response, err := pdsClient.GetAllUsersWithResponse(context.Background())
		if err != nil {
			log.Fatalf("Couldn't get users %s", err)
		}
		dump(response.JSON200)
	},
}

var getUserCmd = &cobra.Command{
	Use:   "get USERNAME",
	Args:  cobra.ExactArgs(1),
	Short: "Retrieve user with username USERNAME",
	Run: func(cmd *cobra.Command, args []string) {
		// username, _ := cmd.Flags().GetString("username")
		username := args[0]
		response, err := pdsClient.GetUserByUsernameWithResponse(context.Background(), client.Username(username))
		if err != nil {
			log.Fatalf("Couldn't get user %s: %s", username, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.JSON200)
	},
}

var getUserTokenCmd = &cobra.Command{
	Use:   "get-token USERNAME",
	Args:  cobra.ExactArgs(1),
	Short: "Retrieve token for user with username USERNAME",
	Run: func(cmd *cobra.Command, args []string) {
		username := args[0]
		response, err := pdsClient.GetTokenByUsernameWithResponse(context.Background(), client.Username(username))
		if err != nil {
			log.Fatalf("Couldn't get token for user %s: %s", username, err)
		}
		if response.HTTPResponse.StatusCode > 299 {
			log.Fatalf("Request failed with status code: %d and\nbody: %s\n", response.HTTPResponse.StatusCode, response.Body)
		}
		dump(response.JSON200)
	},
}

var putUserCmd = &cobra.Command{
	Use:   "put USERNAME",
	Args:  cobra.ExactArgs(1),
	Short: "Put user with username USERNAME",
	Run: func(cmd *cobra.Command, args []string) {
		// Build the JSON body
		username := args[0]
		body := client.PutUserJSONRequestBody{
			ImmutableUserProperties : client.ImmutableUserProperties{
				Username : (*client.Username)(&username),
			},
			EditableUserProperties : client.EditableUserProperties{
				Email : &userEmail,
				Role : (*client.EditableUserPropertiesRole)(&userRole),
			},
		}

		// Submit the request
		response, err := pdsClient.PutUserWithResponse(context.Background(), client.Username(username), body)

		// Handle errors
		if err != nil {
			log.Fatalf("Couldn't put user %s: %s", username, err)
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
	rootCmd.AddCommand(userCmd)
	userCmd.AddCommand(listUsersCmd)
	userCmd.AddCommand(getUserCmd)
	userCmd.AddCommand(getUserTokenCmd)

	userCmd.AddCommand(putUserCmd)
	putUserCmd.Flags().StringVarP(&userEmail, "email", "e", "", "User email address")
	putUserCmd.Flags().StringVarP(&userRole, "role", "r", "", "User role")
	putUserCmd.MarkFlagRequired("email")
	putUserCmd.MarkFlagRequired("role")
}
