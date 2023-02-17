# vim: ft=sls

{#-
    Starts the cryptpad container services
    and enables them at boot time.
    Has a dependency on `cryptpad.config`_.
#}

include:
  - .running
