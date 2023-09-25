# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}

include:
  - {{ sls_config_file }}

CryptPad service is enabled:
  compose.enabled:
    - name: {{ cryptpad.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if cryptpad.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ cryptpad.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - CryptPad is installed
{%- if cryptpad.install.rootless %}
    - user: {{ cryptpad.lookup.user.name }}
{%- endif %}

CryptPad service is running:
  compose.running:
    - name: {{ cryptpad.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if cryptpad.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ cryptpad.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if cryptpad.install.rootless %}
    - user: {{ cryptpad.lookup.user.name }}
{%- endif %}
    - watch:
      - CryptPad is installed
      - sls: {{ sls_config_file }}
