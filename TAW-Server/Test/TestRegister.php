<?php
    require("../AccountManager/CryptToolAES.php");            // 金鑰的 php
    require("../AccountManager/key.php");
    header("Content-Type:text/html; charset=utf-8"); 

    header("Content-Type:text/html; charset=utf-8");        // 設定他是 UTF-8 的形式
    $url = "http://140.118.175.73/TAW/Register.php";
    date_default_timezone_set("Asia/Taipei");               // 設定時區


    $data = array("Account" => CryptToolAES::Encrypt_CBC("darkgrouptw", $key, $iv), "Password" => CryptToolAES::Encrypt_CBC("abc123", $key, $iv), "Time" => CryptToolAES::Encrypt_CBC(date("Ymd-His", time()), $key, $iv));

    $options = array
    (
        "http" => array
        (
            "header" => "Content-type: application/x-www-form-urlencoded",
            "method" => "POST",
            "content" => http_build_query($data)
        )
    );

    $context  = stream_context_create($options);
    $result = file_get_contents($url, false, $context);
    if ($result === FALSE) { /* Handle error s*/ }

    echo $result;
?>