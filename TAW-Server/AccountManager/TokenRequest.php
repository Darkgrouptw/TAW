<?php
    require("key.php");
    header("Content-Type:text/html; charset=utf-8");        // 設定他是 UTF-8 的形式
    date_default_timezone_set("Asia/Taipei");               // 設定時區
    const TimeGap = 180;

    if(isset($_POST["Time"]))
    {
        $TimeFromDevice = date_create_from_format("Ymd-His", $_POST["Time"]);
        if(abs($TimeFromDevice->getTimestamp() - time()) >= TimeGap)
        {
            EchoResponse(1);
            return;
        }
        EchoResponse(0);
    }
    else
       EchoResponse(2);
       
    function EchoResponse($state)
    {
        echo "Type: ";
        switch($state)
        {
            case 0:
                echo "00\nKey: ".$GLOBALS["key"];
                break;
            case 1:
                echo "01\nState: 時間誤差太大\n";
                break;
            case 2:
                echo "02\nState: Post有問題\n";
                break;
            default:
                echo "03\nState: 有 Bug !!\n";
                break;
        }
    }
?>