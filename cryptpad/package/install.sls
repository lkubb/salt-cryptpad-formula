# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

CryptPad user account is present:
  user.present:
{%- for param, val in cryptpad.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ cryptpad.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

CryptPad user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ cryptpad.lookup.user.name }}
    - enable: {{ cryptpad.install.rootless }}
    - require:
      - user: {{ cryptpad.lookup.user.name }}

CryptPad paths are present:
  file.directory:
    - names:
      - {{ cryptpad.lookup.paths.base }}
    - user: {{ cryptpad.lookup.user.name }}
    - group: {{ cryptpad.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ cryptpad.lookup.user.name }}

{%- if cryptpad.install.podman_api %}

CryptPad podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ cryptpad.lookup.user.name }}
    - require:
      - CryptPad user session is initialized at boot

CryptPad podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ cryptpad.lookup.user.name }}
    - require:
      - CryptPad user session is initialized at boot
{%- endif %}

CryptPad compose file is managed:
  file.managed:
    - name: {{ cryptpad.lookup.paths.compose }}
    - source: {{ files_switch(["docker-compose.yml", "docker-compose.yml.j2"],
                              lookup="CryptPad compose file is present"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ cryptpad.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        cryptpad: {{ cryptpad | json }}

CryptPad is installed:
  compose.installed:
    - name: {{ cryptpad.lookup.paths.compose }}
{%- for param, val in cryptpad.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in cryptpad.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ cryptpad.lookup.paths.compose }}
{%- if cryptpad.install.rootless %}
    - user: {{ cryptpad.lookup.user.name }}
    - require:
      - user: {{ cryptpad.lookup.user.name }}
{%- endif %}

{%- if cryptpad.install.autoupdate_service is not none %}

Podman autoupdate service is managed for CryptPad:
{%-   if cryptpad.install.rootless %}
  compose.systemd_service_{{ "enabled" if cryptpad.install.autoupdate_service else "disabled" }}:
    - user: {{ cryptpad.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if cryptpad.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
