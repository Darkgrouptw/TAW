<?php
    header("Content-Type:text/html; charset=utf-8");        // 設定他是 UTF-8 的形式

    // 任務 Index 的文字檔
    $FileMission = "MissionIndex.txt";
    $File = fopen($FileMission, "r");
    if(filesize($FileMission) != 0)
    {
        $Data = fread($File, filesize($FileMission));
        $DataLine = explode("\n", $Data);
    }

    if(!isset($_GET["Mission"]))
    {
        // 顯示有幾個任務
        for($i = 0; $i < count($DataLine); $i++)
        {
            $temp = explode(" ", $DataLine[$i]);
			if($i == count($DataLine) - 1)
				echo $temp[0];
			else
				echo $temp[0]."\n";
        }
    }
    else
    {
        // 選定任務，可以繼續執行
        if (!is_numeric($_GET["Mission"]))
        {
            echo "Error !!";
            return;
        }
        
        if($_GET["Mission"] < count($DataLine))
        {
            $FileMission = fopen("MissionSet/".$_GET["Mission"].".txt", "r");
            $MissionDetail = fread($FileMission, filesize("MissionSet/".$_GET["Mission"].".txt"));
            
            // 設定要哪一個 index
            $GoToIndex = 0;
            if(isset($_GET["Step"]))
                $GoToIndex = $_GET["Step"] + 0;         // 為了要轉成數字
            
            // For Window 的 double line 適用 \r\n
            $MissionText = explode("\r\n\r\n", $MissionDetail);
            
            // 把結果 echo 出來
            for($i = 0; $i < count($MissionText); $i++)
            {
                $temp = explode("\r\n", $MissionText[$i]);
                if($temp[0] == $GoToIndex)
                {
                    for($j = 1; $j < count($temp); $j++)
                        echo $temp[$j]."\n";
                    break;
                }
            }
        }
    
        
    }
    fclose($File);

    /*
    srand(microtime() * 1000000);               // 用 microtime() 作為亂數 seed
    for($i = 0; $i < 10; $i++)
        echo md5(uniqid(rand(), true))."<br>";*/
?>