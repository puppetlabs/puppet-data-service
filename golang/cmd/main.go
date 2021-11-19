package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/puppetlabs/puppet-data-service/golang/pds"
)

func main() {
	client, err := pds.NewClientWithResponses("http://127.0.0.1:4010")
	if err != nil {
		log.Fatalf("Couldn't instantiate client: %s", err)
	}

	// newPtrStr := func(s string) *string {
	// 	return &s
	// }

	// newPtrTime := func(t time.Time) *time.Time {
	// 	return &t
	// }

	// Get users

	getAllUsersResponse, err := client.GetAllUsersWithResponse(context.Background())
	if err != nil {
		log.Fatalf("Couldn't get users %s", err)
	}

	fmt.Printf("Users\n %+v\n", getAllUsersResponse.JSON200)

	// Get one user

	users := *getAllUsersResponse.JSON200
	firstUser := users[0]

	getUserResponse, err := client.GetUserByUsernameWithResponse(context.Background(), 
		*firstUser.Username)
		if err != nil {
			log.Fatalf("Couldn't get user %s", err)
		}
	
	user, _ := json.MarshalIndent(getUserResponse, "", "\t")
	// fmt.Printf("User\n %+v\n", *getUserResponse.JSON200)
	fmt.Println("foo")
	fmt.Println(string(user))

	// //- Create

	// priority := pds.Priority_low

	// respC, err := client.CreateTaskWithResponse(context.Background(),
	// 	pds.CreateTaskJSONRequestBody{
	// 		Dates: &pds.Dates{
	// 			Start: newPtrTime(time.Now()),
	// 			Due:   newPtrTime(time.Now().Add(time.Hour * 24)),
	// 		},
	// 		Description: newPtrStr("Sleep early"),
	// 		Priority:    &priority,
	// 	})
	// if err != nil {
	// 	log.Fatalf("Couldn't create task %s", err)
	// }

	// fmt.Printf("New Task\n\tID: %s\n", *respC.JSON201.Task.Id)
	// fmt.Printf("\tPriority: %s\n", *respC.JSON201.Task.Priority)
	// fmt.Printf("\tDescription: %s\n", *respC.JSON201.Task.Description)
	// fmt.Printf("\tStart: %s\n", *respC.JSON201.Task.Dates.Start)
	// fmt.Printf("\tDue: %s\n", *respC.JSON201.Task.Dates.Due)

	// //- Update

	// priority = pds.Priority_high
	// done := true

	// _, err = client.UpdateTaskWithResponse(context.Background(),
	// 	*respC.JSON201.Task.Id,
	// 	pds.UpdateTaskJSONRequestBody{
	// 		Dates: &pds.Dates{
	// 			Start: respC.JSON201.Task.Dates.Start,
	// 			Due:   respC.JSON201.Task.Dates.Due,
	// 		},
	// 		Description: newPtrStr("Sleep early..."),
	// 		Priority:    &priority,
	// 		IsDone:      &done,
	// 	})
	// if err != nil {
	// 	log.Fatalf("Couldn't create task %s", err)
	// }

	// //- Read

	// respR, err := client.ReadTaskWithResponse(context.Background(), *respC.JSON201.Task.Id)
	// if err != nil {
	// 	log.Fatalf("Couldn't create task %s", err)
	// }

	// fmt.Printf("Updated Task\n\tID: %s\n", *respR.JSON200.Task.Id)
	// fmt.Printf("\tPriority: %s\n", *respR.JSON200.Task.Priority)
	// fmt.Printf("\tDescription: %s\n", *respR.JSON200.Task.Description)
	// fmt.Printf("\tStart: %s\n", *respR.JSON200.Task.Dates.Start)
	// fmt.Printf("\tDue: %s\n", *respR.JSON200.Task.Dates.Due)
	// fmt.Printf("\tDone: %t\n", *respR.JSON200.Task.IsDone)
}