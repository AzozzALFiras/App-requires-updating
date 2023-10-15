<?php
// Developer By : Azozz ALFiras

/**
 * Summary of AppStore_InfoApp
 */
class AppStore_InfoApp {
/**
 * Summary of sent_request
 * @param mixed $bundleid
 * @return mixed
 */
public function sent_request($bundleid){
$curl = curl_init();
curl_setopt_array($curl, array(
CURLOPT_URL => "http://itunes.apple.com/lookup?bundleId=$bundleid",
CURLOPT_RETURNTRANSFER => true,
CURLOPT_ENCODING => '',
CURLOPT_MAXREDIRS => 10,
CURLOPT_TIMEOUT => 0,
CURLOPT_FOLLOWLOCATION => true,
CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
CURLOPT_CUSTOMREQUEST => 'GET',
));

$response = curl_exec($curl);

curl_close($curl);
$data =  json_decode($response);
return $data->results[0];
}
/**
 * Summary of get_info_app
 * @param mixed $bundleid
 * @param mixed $Version
 * @return bool|string
 */
public function get_info_app($bundleid,$Version){

$data       = $this->sent_request($bundleid);
$V_AppStore = $data->version;
$app_link   = $data->trackViewUrl;

if($V_AppStore == $Version){
return $this->response_api('Yes',$app_link);
} else {
return $this->response_api('No',$app_link);
}

}

/**
 * Summary of response_api
 * @param mixed $Status
 * @param mixed $url
 * @return bool|string
 */
public function response_api($Status,$url){
if($Status == 'Yes'){
$json = [
'status'=> 'success',
'status_message'=> 'There is no application update'
];
return json_encode($json);
} else {
$json = [
'status'=> 'failed',
'status_message'=> 'The version does not match. An update is required',
'app_link'=> $url,
];
return json_encode($json);  
}
}
}

