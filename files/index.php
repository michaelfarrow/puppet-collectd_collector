<?php

function append_line_to_limited_text_file($text, $filename) {
	if (!file_exists($filename)) { touch($filename); chmod($filename, 0666); }
	if (filesize($filename) > 2*1024*1024) {
		$filename2 = "$filename.old";
		if (file_exists($filename2)) unlink($filename2);
		rename($filename, $filename2);
		touch($filename); chmod($filename,0666);
	}
	if (!is_writable($filename)) die("<p>\nCannot open log file ($filename)");
	if (!$handle = fopen($filename, 'a')) die("<p>\nCannot open file ($filename)");
	if (fwrite($handle, $text) === FALSE) die("<p>\nCannot write to file ($filename)");
	fclose($handle);
}

$postdata = file_get_contents("php://input");

append_line_to_limited_text_file(print_r($postdata, true), 'events_log');

print 'OK';