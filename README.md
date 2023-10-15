# App requires updating
Check the application in the App Store if it requires an update or not

# How does it work? I will create an example in the language of PHP

# First Import file AppStore_InfoApp.class.php
```PHP
include ("AppStore_InfoApp.class.php");
```

# Second Call Function's
```PHP
$AppStore = new AppStore_InfoApp();

// how to use the url like 
// https://127.0.0.1:8912/check.php?bundleId=[YOUR_APP_BUNDEL]&version=[YOUR_APP_VERSION]
if((isset($_GET["bundleId"])) && (isset($_GET["version"]))){
    $bundleid = $_GET["bundleId"];
    $Version  = $_GET["version"];
    echo $AppStore->get_info_app($bundleid,$Version);
}

```

