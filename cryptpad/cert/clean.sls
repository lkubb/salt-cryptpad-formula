# vim: ft=sls

{#-
    Removes generated Cryptpad TLS certificate + key.
    Depends on `cryptpad.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}

include:
  - {{ sls_service_clean }}

{%- if cryptpad.cert.manage %}

Cryptpad key/cert is absent:
  file.absent:
    - names:
      - {{ cryptpad.lookup.paths.tls }}
    - require:
      - sls: {{ sls_service_clean }}
{%- endif %}
