<?php

  $handle = @fopen("dates.csv", "r");
  if ($handle) {
      while (($buffer = fgets($handle, 4096)) !== false) {
          $d = explode(",",$buffer);
          $month = $d[0];
          $day = $d[1];
          $year = $d[2];
          $pmonth = str_pad($month,2,"0",STR_PAD_LEFT);
          $pday = str_pad($day,2,"0",STR_PAD_LEFT);
          $fold = $year."".$pmonth."".$pday;
          echo $fold . "\n";
          mkdir("/home/ubuntu/hysplit-805/trunk/output/".$fold,0777);
          $file = "output_".$year."_".$month."_".$day."_*";
          foreach (glob("output/".$file) as $fileName) {
          	  $f = str_replace("output/","",$fileName);
          	  //echo $fileName . "\t" . "output/".$fold."/".$f . "\n";
		      copy($fileName, "output/".$fold."/".$f);
		  }
          //copy("/home/ubuntu/hysplit-805/trunk/output/".$file, "/home/ubuntu/hysplit-805/trunk/output/".$fold."/".$file);
      }
      if (!feof($handle)) {
          echo "Error: unexpected fgets() fail\n";
      }
      fclose($handle);
  }
?>