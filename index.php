<?php

$keypadNum = '';
$dataToSend='';
$myfile = fopen("keypadNum.txt", "r") or die("Unable to open file!");
// Output one character until end-of-file
while(!feof($myfile)) {
  keypadNum =  fgetc($myfile);
  if(keypadNum == 'A'){
  	dataToSend = '1'
  }
  elseif(keypadNum=='B'){
  	dataToSend='2';
  }
  elseif(keypadNum=='C'){
  	dataToSend='3';
  }
  elseif(keypadNum=='D'){
  	dataToSend='4';
  }
  elseif(keypadNum=='E'){
  	dataToSend='5';
  }
  elseif(keypadNum=='F'){
  	dataToSend='6';
  }
  elseif(keypadNum=='G'){
  	dataToSend='7';
  }
  elseif(keypadNum=='H'){
  	dataToSend='8';
  }
  elseif(keypadNum=='I'){
  	dataToSend='9';
  }
  elseif(keypadNum=='J'){
  	dataToSend='10';
  }
  elseif(keypadNum=='K'){
  	dataToSend='11';
  }
  elseif(keypadNum=='L'){
  	dataToSend='12';
  }
  elseif(keypadNum=='M'){
  	dataToSend='13';
  }
  elseif(keypadNum=='N'){
  	dataToSend='14';
  }
  elseif(keypadNum=='O'){
  	dataToSend='15';
  }
  elseif(keypadNum=='P'){
  	dataToSend='16';
  }
}
fclose($myfile);
?> 
