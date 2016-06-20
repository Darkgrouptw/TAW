<?php
    require("CryptToolAES.php");            // 金鑰的 php
    require("key.php");
    header("Content-Type:text/html; charset=utf-8");        // 設定他是 UTF-8 的形式
    date_default_timezone_set("Asia/Taipei");               // 設定時區
    const TimeGap = 180;
    
    if(!empty($_POST["Account"]) && !empty($_POST["Password"]) && !empty($_POST["Time"]))
    {
        $ParamsAccount = CryptToolAES::Decrypt_CBC($_POST["Account"], $key, $iv);
        $ParamsPassword = CryptToolAES::Decrypt_CBC($_POST["Password"], $key, $iv);
        $ParamsTime = CryptToolAES::Decrypt_CBC($_POST["Time"], $key, $iv);
        
        $TimeFromDevice = date_create_from_format("Ymd-His", CryptToolAES::Decrypt_CBC($_POST["Time"], $key, $iv));//->getTimestamp();

        if($TimeFromDevice == null)
        {
            EchoResponse(2);
            return;
        }
        // 判斷時間差距
        if($TimeFromDevice->getTimestamp() - time() >= TimeGap)
        {
            EchoResponse(1);
            return;
        }
        
        // 真的註冊的位置
        $File = fopen("account.box", "r+");
        $AllInfo = "";
        if(filesize("account.box") != 0)
        {
            $AllInfo = fread($File,filesize("account.box"));
        
            $info = explode("\n", $AllInfo);

            $found = false;     //確定帳號有被找到
            for($i = 0; $i < count($info); $i++)
            {
                $temp = explode(" ", $info[$i]);
                if($temp[0] == $ParamsAccount)
                {
                    $found = true;
                    break;
                }
            }
            
            if($found)
            {
                // 註冊過了
                EchoResponse(3);
                return;
            }  
        }
        
        // 沒註冊過
        srand(microtime() * 1000000);               // 用 microtime() 作為亂數 seed
        $uuid = md5(uniqid(rand(), true));          // 產生 uuid 作為token
        fwrite($File, $ParamsAccount." ".$ParamsPassword." ".$uuid."\n");
        EchoResponse(0);
        echo "Token: ".$uuid."\n";
        
        fclose($File);
    }
    else
        EchoResponse(2);

    function EchoResponse($state)
    {
        echo "Type: ";
        switch($state)
        {
            case 0:
                echo "00\nState: 註冊成功\n";
                break;
            case 1:
                echo "01\nState: 時間誤差太大\n";
                break;
            case 2:
                echo "02\nState: Post有問題\n";
                break;
            case 3:
                echo "03\nState: 已經註冊過囉\n";
                break;
            default:
                echo "04\nState: 有 Bug !!\n";
                break;
        }
    }

