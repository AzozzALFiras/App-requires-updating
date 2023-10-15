// Developer by : Azozz ALFiras

using System;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

public class AppStoreInfoApp
{
    private readonly HttpClient httpClient = new HttpClient();

    public async Task<JObject> SentRequest(string bundleId)
    {
        string url = $"http://itunes.apple.com/lookup?bundleId={bundleId}";
        string response = await httpClient.GetStringAsync(url);
        JObject data = JObject.Parse(response);
        return data["results"][0] as JObject;
    }

    public async Task<JObject> GetInfoApp(string bundleId, string version)
    {
        JObject data = await SentRequest(bundleId);
        string vAppStore = data["version"].ToString();
        string appLink = data["trackViewUrl"].ToString();

        if (vAppStore == version)
        {
            return ResponseApi("Yes", appLink);
        }
        else
        {
            return ResponseApi("No", appLink);
        }
    }

    public JObject ResponseApi(string status, string url)
    {
        if (status == "Yes")
        {
            return new JObject
            {
                { "status", "success" },
                { "status_message", "There is no application update" }
            };
        }
        else
        {
            return new JObject
            {
                { "status", "failed" },
                { "status_message", "The version does not match. An update is required" },
                { "app_link", url }
            };
        }
    }
}

public class Program
{
    public static async Task Main()
    {
        var app = new AppStoreInfoApp();
        var result = await app.GetInfoApp("your_bundle_id", "your_version");
        Console.WriteLine(result);
    }
}
