class apache2::dynamic {
	@ferm::rule { 'dsa-http-limit':
		prio        => '20',
		description => 'limit HTTP DOS',
		chain       => 'http_limit',
		rule        => 'mod limit limit-burst 60 limit 15/minute jump ACCEPT;
		                jump DROP'
	}

	@ferm::rule { 'dsa-http-soso':
		prio        => '21',
		description => 'slow soso spider',
		chain       => 'limit_sosospider',
		rule        => 'mod connlimit connlimit-above 2 connlimit-mask 21 jump DROP;
		                jump http_limit'
	}

	@ferm::rule { 'dsa-http-yahoo':
		prio        => '21',
		description => 'slow yahoo spider',
		chain       => 'limit_yahoo',
		rule        => 'mod connlimit connlimit-above 2 connlimit-mask 16 jump DROP;
		                jump http_limit'
	}

	@ferm::rule { 'dsa-http-google':
		prio        => '21',
		description => 'slow google spider',
		chain       => 'limit_google',
		rule        => 'mod connlimit connlimit-above 2 connlimit-mask 19 jump DROP;
		                jump http_limit'
	}

	@ferm::rule { 'dsa-http-bing':
		prio        => '21',
		description => 'slow bing spider',
		chain       => 'limit_bing',
		rule        => 'mod connlimit connlimit-above 2 connlimit-mask 16 jump DROP;
	                  jump http_limit'
	}

	@ferm::rule { 'dsa-http-baidu':
		prio        => '21',
		description => 'slow baidu spider',
		chain       => 'limit_baidu',
		rule        => 'mod connlimit connlimit-above 2 connlimit-mask 16 jump DROP;
		                jump http_limit'
	}

	@ferm::rule { 'dsa-http-rules':
		prio        => '22',
		description => 'http subchain',
		chain       => 'http',
		rule        => '
		                saddr ( 74.6.22.182 74.6.18.240 67.195.0.0/16 ) jump limit_yahoo;
		                saddr 124.115.0.0/21 jump limit_sosospider;
		                saddr (65.52.0.0/14 207.46.0.0/16) jump limit_bing;
		                saddr (66.249.64.0/19) jump limit_google;
		                saddr (123.125.71.0/24 119.63.192.0/21 180.76.0.0/16) jump limit_baidu;

		                mod recent name HTTPDOS update seconds 1800 jump log_or_drop;
		                mod hashlimit hashlimit-name HTTPDOS hashlimit-mode srcip hashlimit-burst 600 hashlimit 30/minute jump ACCEPT;
		                mod recent name HTTPDOS set jump log_or_drop'
	}

	@ferm::rule { 'dsa-http':
		prio        => '23',
		description => 'Allow web access',
		rule        => 'proto tcp dport (http https) jump http'
	}
}
