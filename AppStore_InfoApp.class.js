class AppStoreInfoApp {
  async sentRequest(bundleid) {
    const response = await fetch(`http://itunes.apple.com/lookup?bundleId=${bundleid}`);
    const data = await response.json();
    return data.results[0];
  }

  async getInfoApp(bundleid, Version) {
    const data = await this.sentRequest(bundleid);
    const V_AppStore = data.version;
    const appLink = data.trackViewUrl;

    if (V_AppStore === Version) {
      return this.responseApi('Yes', appLink);
    } else {
      return this.responseApi('No', appLink);
    }
  }

  responseApi(Status, url) {
    if (Status === 'Yes') {
      const json = {
        status: 'success',
        status_message: 'There is no application update',
      };
      return JSON.stringify(json);
    } else {
      const json = {
        status: 'failed',
        status_message: 'The version does not match. An update is required',
        app_link: url,
      };
      return JSON.stringify(json);
    }
  }
}

// Example usage:
const app = new AppStoreInfoApp();
app.getInfoApp('your_bundle_id', 'your_version')
  .then(response => console.log(response))
  .catch(error => console.error(error));
