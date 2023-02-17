# vim: ft=sls


{#-
    Stops the cryptpad container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}

cryptpad service is dead:
  compose.dead:
    - name: {{ cryptpad.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if cryptpad.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ cryptpad.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if cryptpad.install.rootless %}
    - user: {{ cryptpad.lookup.user.name }}
{%- endif %}

cryptpad service is disabled:
  compose.disabled:
    - name: {{ cryptpad.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if cryptpad.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ cryptpad.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if cryptpad.install.rootless %}
    - user: {{ cryptpad.lookup.user.name }}
{%- endif %}
