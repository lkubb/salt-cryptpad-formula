# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

CryptPad environment files are managed:
  file.managed:
    - names:
      - {{ cryptpad.lookup.paths.config_cryptpad }}:
        - source: {{ files_switch(['cryptpad.env', 'cryptpad.env.j2'],
                                  lookup='cryptpad environment file is managed',
                                  indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ cryptpad.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ cryptpad.lookup.user.name }}
    - watch_in:
      - CryptPad is installed
    - context:
        cryptpad: {{ cryptpad | json }}

CryptPad config files are managed:
  file.managed:
    - names:
      - {{ cryptpad.lookup.paths.config_js }}:
        - source: {{ files_switch(['config.js', 'config.js.j2'],
                                  lookup='CryptPad config file is managed',
                                  indent_width=10,
                     )
                  }}
      - {{ cryptpad.lookup.paths.customize | path_join("application_config.js") }}:
        - source: {{ files_switch(['application_config.js', 'application_config.js.j2'],
                                  lookup='CryptPad application customization file is managed',
                                  indent_width=10,
                     )
                  }}
    - mode: '0644'
    - user: root
    - group: {{ cryptpad.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ cryptpad.lookup.user.name }}
    - watch_in:
      - CryptPad is installed
    - context:
        cryptpad: {{ cryptpad | json }}
