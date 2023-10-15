// Developer by : Azozz ALFiras

package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"encoding/json"
)

type AppStoreInfoApp struct {
	httpClient http.Client
}

func (app *AppStoreInfoApp) SentRequest(bundleID string) (map[string]interface{}, error) {
	url := fmt.Sprintf("http://itunes.apple.com/lookup?bundleId=%s", bundleID)
	response, err := app.httpClient.Get(url)
	if err != nil {
		return nil, err
	}
	defer response.Body.Close()

	data, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return nil, err
	}

	var result map[string]interface{}
	err = json.Unmarshal(data, &result)
	if err != nil {
		return nil, err
	}

	if results, ok := result["results"].([]interface{}); ok && len(results) > 0 {
		if appData, ok := results[0].(map[string]interface{}); ok {
			return appData, nil
		}
	}

	return nil, fmt.Errorf("Invalid response data")
}

func (app *AppStoreInfoApp) GetInfoApp(bundleID string, version string) (map[string]interface{}, error) {
	data, err := app.SentRequest(bundleID)
	if err != nil {
		return nil, err
	}

	vAppStore, ok := data["version"].(string)
	if !ok {
		return nil, fmt.Errorf("Invalid version data")
	}

	appLink, ok := data["trackViewUrl"].(string)
	if !ok {
		return nil, fmt.Errorf("Invalid app link data")
	}

	if vAppStore == version {
		return app.ResponseAPI("Yes", appLink), nil
	}

	return app.ResponseAPI("No", appLink), nil
}

func (app *AppStoreInfoApp) ResponseAPI(status string, url string) map[string]interface{} {
	if status == "Yes" {
		return map[string]interface{}{
			"status":         "success",
			"status_message": "There is no application update",
		}
	}

	return map[string]interface{}{
		"status":         "failed",
		"status_message": "The version does not match. An update is required",
		"app_link":       url,
	}
}

func main() {
	app := AppStoreInfoApp{}
	result, err := app.GetInfoApp("your_bundle_id", "your_version")
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(result)
	}
}
