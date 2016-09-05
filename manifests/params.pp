class filebeat::params {
  $package_ensure = present
  $manage_repo    = true
  $service_ensure = running
  $service_enable = true
  $spool_size     = 2048
  $idle_timeout   = '5s'
  $publish_async  = false
  $registry_file  = '.filebeat'
  $config_dir_mode = '0755'
  $config_file_mode = '0644'
  $purge_conf_dir = true
  $outputs        = {}
  $shipper        = {}
  $logging        = {}
  $run_options    = {}
  $key_location   = 'http://packages.elastic.co/GPG-KEY-elasticsearch'

  if versioncmp('1.9.1', $::rubyversion) > 0 {
    $conf_template = "${module_name}/filebeat.yml.ruby18.erb"
  } else {
    $conf_template = "${module_name}/filebeat.yml.erb"
  }

  case $::kernel {
    'Linux'   : {
      $config_file     = '/etc/filebeat/filebeat.yml'
      $config_dir      = '/etc/filebeat/conf.d'

      # These parameters are ignored if/until tarball installs are supported in Linux
      $tmp_dir         = '/tmp'
      $install_dir     = undef
      $download_url    = undef
      case $::osfamily {
        'RedHat': {
          $service_provider = 'redhat'
        }
        default: {
          $service_provider = undef
        }
      }
    }

    'Windows' : {
      $config_file      = 'C:/Program Files/Filebeat/filebeat.yml'
      $config_dir       = 'C:/Program Files/Filebeat/conf.d'
      $download_url     = 'https://download.elastic.co/beats/filebeat/filebeat-1.2.3-windows.zip'
      $install_dir      = 'C:/Program Files'
      $tmp_dir          = 'C:/Windows/Temp'
      $service_provider = undef
    }

    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
