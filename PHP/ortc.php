<?php
class Request {
    /*
     0 success
    -1 not a HTTP request
    -2 (parse_url) Host or Path are empty
    -3 curl/socket connection error
    -4 failed to localize http 1.1 in the result header
    -5 response was not successul ( != 201 )
     */
    static function execute($method, $url, $data=array(), $referer='', $timeout=30, $user_agent=''){
        $is_curl_enabled = function_exists('curl_version');
        
        // Convert the data array into URL Parameters like a=b&foo=bar etc.
        $data = http_build_query($data);
        // parse the given URL
        $url = parse_url($url);

        if(!isset($url['scheme']) || $url['scheme'] != 'http'){
             return array(
                 'errcode' => -1,
                 'status' => 'err',
                 'error' => "Error: Only HTTP request are supported"
                );
        }
        // extract host and path
        $host = $url['host'];
        $path = isset($url['path']) ? $url['path'] : '';
        
        if (trim($host)=="" ){
            return array(
                 'errcode' => -2,
                 'status' => 'err',
                 'error' => "Error: (parse_url) Host is empty"
                );
         }
        
        if (!$is_curl_enabled)
        {
            // open a socket connection on port 80 - timeout: 30 sec
            $fp = fsockopen($host, 80, $errno, $errstr, $timeout);
            if($fp){
                    // send the request headers:
                    fputs($fp, "$method $path HTTP/1.1\r\n");
                    fputs($fp, "Host: $host\r\n");
                    if($referer != '') fputs($fp, "Referer: $referer\r\n");
                    if($method == 'POST'){
                            fputs($fp, "Content-type: application/x-www-form-urlencoded\r\n");
                            fputs($fp, "Content-length: " . strlen($data) . "\r\n");
                    }
                    fputs($fp, "Connection: close\r\n\r\n");
                    fputs($fp, $data);
                    $result = '';
                    while(!feof($fp)){
                            // receive the results of the request
                            $result .= fgets($fp, 128);
                    }
            } else{
                    return array(
                     'errcode' => -3,
                     'status' => 'err',
                     'error' => "$errstr ($errno)"
                    );
            }
            // close the socket connection:
            fclose($fp);
        } else
        {
            $ch = curl_init();
            curl_setopt_array($ch, array(
                CURLOPT_RETURNTRANSFER => 1,
                CURLOPT_URL => $host.$path,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_TIMEOUT => $timeout,
                CURLOPT_PORT => 80
                // CURLOPT_HEADER => 1
            ));
            
            $httpHeader = array();
            $httpHeader[] = "Host: $host";
            if($referer != '') 
                $httpHeader[] = "Referer: $referer";
            
            if($method == 'POST'){
                $httpHeader[] = "Content-Type: application/x-www-form-urlencoded";
                $httpHeader[] = "Content-length: " . strlen($data);
                
                curl_setopt($ch, CURLOPT_POST, true);    
                curl_setopt($ch, CURLOPT_POSTFIELDS, $data ); // NOTE: specifying this option automatically sets http method to POST
            } else
            {
                curl_setopt($ch, CURLOPT_POST, FALSE);
                curl_setopt($ch, CURLOPT_HTTPGET, TRUE);                
            }
            $httpHeader[] = "Connection: close";
            curl_setopt($ch, CURLOPT_HTTPHEADER, $httpHeader);
            curl_setopt($ch, CURLOPT_HEADER, 1);
            
            if ($user_agent != '')
                curl_setopt ($ch, CURLOPT_USERAGENT, $user_agent);
             
            $result = curl_exec($ch);
            
            if(!$result){               
                 return array(
                     'errcode' => -3,
                     'status' => 'err',
                     'error' => 'Error: "' . curl_error($ch) . '" - Code: ' . curl_errno($ch),
                     'response' => $result
                    );
            }
            
            curl_close($ch);
        }
        // split the result header from the content
        $result = explode("\r\n\r\n", $result, 2);
        
        $header = isset($result[0]) ? $result[0] : '';
        $content = isset($result[1]) ? $result[1] : '';

        // be carefull with HTTP1.1 (nginx)
        if(preg_match('/Transfer-Encoding: chunked/i', $header)){
                $chunks = explode("\n", $content);
                if (count($chunks)>1){       
                    foreach($chunks as $line => $data){
                            if($line%2 == 0) unset($chunks[$line]);

                    }
                    array_pop($chunks);
                    $content = implode("\n", $chunks);
                } else 
                    $content = $result[1];
        }
        // $header example
        // HTTP/1.1 200 OK X-Powered-By: Express Access-Control-Allow-Origin: * Content-Type: text/javascript Transfer-Encoding: chunked Connection: close
                    
        
        // print curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if( ! preg_match('/^HTTP\/1.1 ([0-9]{3})/', $header, $matches)){
          
                 return array(
                     'errcode' => -4,
                     'status' => 'err',
                     'error' => 'Error: failed to localize http 1.1 in the result header',
                     'response' => $result
                    );
        };

        // $matches example
        // Array ( [0] => HTTP/1.1 200 [1] => 200 )
        
        $successCode = ( $method == 'POST' ? '201' : '200' ); // specs on codes: http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html 
        if( $successCode !== $matches[1]){
                 return array(
                     'errcode' => -5,
                     'status' => 'err',
                     'error' => "Error: response was not successful ( != $successCode )",
                     'response' => $result
                    );
        }       
        
        // return as structured array:
        return array(
                'errcode' => 0,
                'status' => 'ok',
                'header' => $header,
                'content' => $content
        );
    }

}

class Realtime{
	private $ortc_data;
        private $is_version_21;
	
	function __construct($balancer, $app_key, $priv_key, $token){
            
                $arg_list = func_get_args();
                if (count($arg_list)<4) die("ERROR: Some of constructor's parameters are missing.");
                foreach( $arg_list as $idx=>$val )
                    if ( trim($val) == "" )
                        die("ERROR: parameters '$idx' is not specified.");
                
                $strpos_res = strpos( $balancer, "2.1" );
                $this->is_version_21 = ($strpos_res > 0);
                
		$this->ortc_data['balancer'] = $balancer;
		$this->ortc_data['app_key'] = $app_key;
		$this->ortc_data['priv_key'] = $priv_key;
		$this->ortc_data['token'] = $token;
	}
	
	
	private function _get_server(){
		$url = $this->ortc_data['balancer'];		
		$balancer_response = Request::execute("GET",$url);
                
		if($balancer_response['errcode'] != 0){
			die('Error getting data from balancer! '.$balancer_response['error'].' Response: '.print_r($balancer_response['response'],true));
		}

                // error
		if(!preg_match('/http:\/\/[^\"]+/', $balancer_response['content'], $matches)) return '';
		if('http://undefined:undefined' == $matches[0]) return '';
                
		// success
		return $matches[0];
	}
	
	private function send_message_part($url, $channel, $msg, &$response = Array() ){
		$message = array(
				'AK' => $this->ortc_data['app_key'],
				'PK' => $this->ortc_data['priv_key'],
				'AT' => $this->ortc_data['token'],
				'C' => $channel,
				'M' => $msg
		);
		
		$content = Request::execute("POST",$url. '/send/', $message);
		
                $response = $content;
                
                return ( $content['errcode'] == 0 );
	}

	public function send($channel, $msg, &$response = Array() ){
            
		$url = $this->_get_server();

                if(!$url || $url == "") return false; // no server available
				
		$numberOfParts = ((int)(strlen($msg) / 700)) + ((strlen($msg) % 700 == 0)? 0 : 1 );

		if($numberOfParts > 1){			
			$part = 1;
			$guid = substr(uniqid(),5,8);

			while ($part <= $numberOfParts){

				$ret = $this->send_message_part($url, $channel, $guid."_".$part."-".$numberOfParts."_".substr($msg,($part-1) * 700, 699), $response ); // $response returned used for debug purposes
				if (!$ret)  return false;

				$part = $part + 1;

                        }	

			return true;
		}
		else
		{
			$ret = $this->send_message_part($url,$channel,$msg,$response); // returning $response for debug purpose
                        return $ret;
		}
	}
        
        
        public function auth($channels, $private = 0, $expire_time = 180000, &$response = Array() ){

                // post permissions
                $fields = array(
                    'AK' => $this->ortc_data['app_key'],
                    'PK' => $this->ortc_data['priv_key'],
                    'AT' => $this->ortc_data['token'], //access token
                    'PVT' => $private,
                    'TTL' => $expire_time,
                    'TP' => count($channels) // total num of channels
                );
                
                /*Array(Array('name'=>'r'))*/
                foreach($channels as $channel => $perms){
                        $fields[$channel] = $perms;
                }
                $url = $this->_get_server();
                if(!$url) return false; // no server available
                
                $auth_path = '/authenticate';
                
                $content = Request::execute('POST', $url.$auth_path, $fields, $referer='', 15, 'CURL library'); // /auth or /authenticate depends on the server version
                $response = $content;
                
                return ( $content['errcode'] == 0 );        
        }
        
}
?>