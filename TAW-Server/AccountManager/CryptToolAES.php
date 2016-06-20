<?php
//這是 AES 使用 CBC， PKCS7 的工具
class CryptToolAES
{
    public static function Encrypt_CBC($data, $key, $iv) 
    {
        if(32 !== strlen($key)) $key = hash('SHA256', $key, true);
        
        $padding = 16 - (strlen($data) % 16);
        $data .= str_repeat(chr($padding), $padding);
        return base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_CBC, $iv));
    }
    
    public static function Decrypt_CBC($data, $key, $iv)
    {
        if(32 !== strlen($key)) $key = hash('SHA256', $key, true);
        
        $data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, base64_decode($data), MCRYPT_MODE_CBC, $iv);
        $padding = ord($data[strlen($data) - 1]);
        return substr($data, 0, -$padding);
    }
}
?>