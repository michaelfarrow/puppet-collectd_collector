class collectd_collector {

	exec { 'apt-get update': } -> Package['php5-common'] -> Package['httpd']

	class { 'apache':
		default_vhost => false,
		mpm_module    => 'prefork',
	}
	include apache::mod::php

	apache::vhost { "${fqdn}":
		servername     => "${fqdn}",
		docroot        => '/var/www/',
		port           => '80',
		directoryindex => 'index.html index.php',
		notify         => Service['httpd'],
	}

	include php
	include php::cli

	Php::Extension <| |>
	  -> Php::Config <| |>
	  ~> Service["httpd"]

	File <| title == '/var/www' |> {
		owner  => $::apache::params::user,
		group  => $::apache::params::group,
	} ->

	file { '/var/www/index.php':
		ensure => present,
		source => 'puppet:///modules/collectd_collector/index.php',
		owner  => $::apache::params::user,
		group  => $::apache::params::group,
	}

}