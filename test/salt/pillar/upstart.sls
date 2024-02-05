# vim: ft=yaml
---
cryptpad:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: cryptpad
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/cryptpad
      compose: docker-compose.yml
      config_cryptpad: cryptpad.env
      config_js: config.js
      customize: customize
      data: data
      data_blob: blob
      data_block: block
      data_data: data
      data_files: datastore
      nginx_conf: nginx.conf
      tls: tls
    user:
      groups: []
      home: null
      name: cryptpad
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      cryptpad:
        image: docker.io/cryptpad/cryptpad:version-{version}
      nginx:
        image: docker.io/library/nginx:stable
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
    podman_api: true
  cert:
    ca_server: null
    cn: null
    days_remaining: 3
    days_valid: 7
    intermediate: []
    manage: false
    root: null
    san: null
    signing_cert: null
    signing_policy: null
    signing_private_key: null
  config:
    adminKeys: []
    httpAddress: 0.0.0.0
    httpPort: 3000
    httpSafeOrigin: http://localhost:3001
    httpUnsafeOrigin: http://localhost:3000
    logToStdout: true
    websocketPort: 3003
  config_nginx:
    http2_disable: true
    realip_recursive: false
    trusted_proxy: []
  container:
    ulimit_nofile:
      hard: 1000000
      soft: 1000000
  customizations_app: {}
  version: 5.6.0

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://cryptpad/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   cryptpad-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      CryptPad environment file is managed:
      - cryptpad.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
