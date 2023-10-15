// Developer By : Azozz ALFiras

import json
import requests

class AppStoreInfoApp:
    def sent_request(self, bundleid):
        url = f"http://itunes.apple.com/lookup?bundleId={bundleid}"
        response = requests.get(url)
        data = response.json()
        return data["results"][0]

    def get_info_app(self, bundleid, version):
        data = self.sent_request(bundleid)
        V_AppStore = data["version"]
        app_link = data["trackViewUrl"]

        if V_AppStore == version:
            return self.response_api('Yes', app_link)
        else:
            return self.response_api('No', app_link)

    def response_api(self, status, url):
        if status == 'Yes':
            json_data = {
                'status': 'success',
                'status_message': 'There is no application update'
            }
        else:
            json_data = {
                'status': 'failed',
                'status_message': 'The version does not match. An update is required',
                'app_link': url
            }

        return json.dumps(json_data)

# Example usage:
app = AppStoreInfoApp()
result = app.get_info_app('your_bundle_id', 'your_version')
print(result)
