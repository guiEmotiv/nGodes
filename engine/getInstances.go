package engine

import (
	"os"
	"encoding/json"
)

type Client struct {
	AreaA []struct {
		ID   		string		`json:"id"`
		LocX		float64		`json:"locX"`
		LocY 		float64   	`json:"locY"`
		Frequency	float64		`json:"frequency"`
	} `json:"areaA"`
}
func GetInstances(s string) Client {
	var newJson Client
	jsonFile, _ := os.Open(s)
	defer jsonFile.Close()
	jsonParser := json.NewDecoder(jsonFile)
	jsonParser.Decode(&newJson)
	return newJson
}







