# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as cryptpad with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

{%- if cryptpad.cert.manage %}

Cryptpad certificate private key is managed:
  x509.private_key_managed:
    - name: {{ cryptpad.lookup.paths.tls | path_join("cert.key") }}
    - algo: rsa
    - keysize: 2048
    - new: true
{%-   if salt["file.file_exists"](cryptpad.lookup.paths.tls | path_join("cert.key")) %}
    - prereq:
      - Cryptpad certificate is managed
{%-   endif %}
    - makedirs: true
    - user: {{ cryptpad.lookup.user.name }}
    - group: {{ cryptpad.lookup.user.name }}
    - mode: '0640'
    - watch_in:
      - CryptPad is installed

Cryptpad certificate is managed:
  x509.certificate_managed:
    - name: {{ cryptpad.lookup.paths.tls | path_join("cert.pem") }}
    - ca_server: {{ cryptpad.cert.ca_server or "null" }}
    - signing_policy: {{ cryptpad.cert.signing_policy or "null" }}
    - signing_cert: {{ cryptpad.cert.signing_cert or "null" }}
    - signing_private_key: {{ cryptpad.cert.signing_private_key or
                              (cryptpad.lookup.paths.tls | path_join("cert.key") if not cryptpad.cert.ca_server and not cryptpad.cert.signing_cert
                              else "null") }}
    - private_key: {{ cryptpad.lookup.paths.tls | path_join("cert.key") }}
    - days_valid: {{ cryptpad.cert.days_valid or "null" }}
    - days_remaining: {{ cryptpad.cert.days_remaining or "null" }}
    - days_valid: {{ cryptpad.cert.days_valid or "null" }}
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
{%-   if cryptpad.cert.san %}
    - subjectAltName:  {{ cryptpad.cert.san | json }}
{%-   else %}
    - subjectAltName:
      - dns: {{ cryptpad.cert.cn or ([grains.fqdn] + grains.fqdns) | reject("==", "localhost.localdomain") | first | d(grains.id) }}
      - dns: {{ "sandbox." ~ (cryptpad.cert.cn or ([grains.fqdn] + grains.fqdns) | reject("==", "localhost.localdomain") | first | d(grains.id)) }}
      - ip: {{ (grains.get("ip4_interfaces", {}).get("eth0", [""]) | first) or (grains.get("ipv4") | reject("==", "127.0.0.1") | first) }}
{%-   endif %}
    - CN: {{ cryptpad.cert.cn or grains.fqdns | reject("==", "localhost.localdomain") | first | d(grains.id) }}
    - mode: '0640'
    - user: {{ cryptpad.lookup.user.name }}
    - group: {{ cryptpad.lookup.user.name }}
    - makedirs: true
    - append_certs: {{ cryptpad.cert.intermediate | json }}
    - watch_in:
      - CryptPad is installed
{%-   if not salt["file.file_exists"](cryptpad.lookup.paths.tls | path_join("cert.key")) %}
    - require:
      - Cryptpad certificate private key is managed
{%-   endif %}
{%- else %}

Certs are not managed:
  test.nop:
    - name: This is required to be able to watch this file.
{%- endif %}
