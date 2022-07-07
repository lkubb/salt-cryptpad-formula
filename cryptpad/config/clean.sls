# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
CryptPad environment files are absent:
  file.absent:
    - names:
      - {{ cryptpad.lookup.paths.config_cryptpad }}
      - {{ cryptpad.lookup.paths.config_js }}
      - {{ cryptpad.lookup.paths.customize | path_join("application_config.js") }}
    - require:
      - sls: {{ sls_service_clean }}
