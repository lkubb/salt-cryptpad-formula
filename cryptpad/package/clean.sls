# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}

include:
  - {{ sls_config_clean }}

{%- if cryptpad.install.autoupdate_service %}

Podman autoupdate service is disabled for CryptPad:
{%-   if cryptpad.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ cryptpad.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

CryptPad is absent:
  compose.removed:
    - name: {{ cryptpad.lookup.paths.compose }}
    - volumes: {{ cryptpad.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if cryptpad.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ cryptpad.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if cryptpad.install.rootless %}
    - user: {{ cryptpad.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

CryptPad compose file is absent:
  file.absent:
    - name: {{ cryptpad.lookup.paths.compose }}
    - require:
      - CryptPad is absent

CryptPad user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ cryptpad.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ cryptpad.lookup.user.name }}

CryptPad user account is absent:
  user.absent:
    - name: {{ cryptpad.lookup.user.name }}
    - purge: {{ cryptpad.install.remove_all_data_for_sure }}
    - require:
      - CryptPad is absent
    - retry:
        attempts: 5
        interval: 2

{%- if cryptpad.install.remove_all_data_for_sure %}

CryptPad paths are absent:
  file.absent:
    - names:
      - {{ cryptpad.lookup.paths.base }}
    - require:
      - CryptPad is absent
{%- endif %}
