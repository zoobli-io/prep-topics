<?php

function encrypt(string $text, int $shift): string
{
    $encryptedText = '';
    foreach (str_split($text) as $c) {
        if (ctype_alpha($c)) {
            $placeValue = ord($c) - ord(ctype_upper($c) ? 'A' : 'a');
            $placeValue = ($placeValue + $shift) % 26;
            $placeValue += ord(ctype_upper($c) ? 'A' : 'a');
            $newChar = chr($placeValue);
            $encryptedText .= $newChar;
        } else {
            $encryptedText .= $c;
        }
    }

    return $encryptedText;
}

function decrypt(string $text, int $shift): string
{
    $decryptedText = '';
    foreach (str_split($text) as $c) {
        if (ctype_alpha($c)) {
            $placeValue = ord($c) - ord(ctype_upper($c) ? 'A' : 'a');
            $placeValue = ($placeValue - $shift) % 26;
            if ($placeValue < 0) {
                $placeValue += 26;
            }
            $placeValue += ord(ctype_upper($c) ? 'A' : 'a');
            $newChar = chr($placeValue);
            $decryptedText .= $newChar;
        } else {
            $decryptedText .= $c;
        }
    }

    return $decryptedText;
}
