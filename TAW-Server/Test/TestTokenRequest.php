<?php
    $url = "http://140.118.175.73/TAW/AccountManager/TokenRequest.php";
    date_default_timezone_set("Asia/Taipei");               // 設定時區
    $data = array("Time" =>  date("Ymd-His", time()));

    $options = array
    (
        "http" => array
        (
            "header" => "Content-type: application/x-www-form-urlencoded\r\n",
            "method" => "POST",
            "content" => http_build_query($data)
        )
    );

    $context  = stream_context_create($options);
    $result = file_get_contents($url, false, $context);
    if ($result === FALSE) { /* Handle error */ }

    echo $data["Time"]."<br>".$result;
?>