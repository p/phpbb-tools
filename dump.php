<?php

/**
* Dumps anything somewhere where it will be seen.
*
* If run in cli dumps on standard error.
*/
function dump() {
	$args = func_get_args();
	
	ob_start();
	var_dump($args);
	$output = ob_get_clean();
	$stream = fopen('php://stderr', 'w');
	fputs($stream, $output);
	fclose($stream);
}
