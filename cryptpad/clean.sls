# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``cryptpad`` meta-state
    in reverse order, i.e. stops the cryptpad services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
