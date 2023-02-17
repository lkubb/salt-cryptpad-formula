Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``cryptpad``
^^^^^^^^^^^^
*Meta-state*.

This installs the cryptpad containers,
manages their configuration and starts their services.


``cryptpad.package``
^^^^^^^^^^^^^^^^^^^^
Installs the cryptpad containers only.
This includes creating systemd service units.


``cryptpad.config``
^^^^^^^^^^^^^^^^^^^
Manages the configuration of the cryptpad containers.
Has a dependency on `cryptpad.package`_.


``cryptpad.service``
^^^^^^^^^^^^^^^^^^^^
Starts the cryptpad container services
and enables them at boot time.
Has a dependency on `cryptpad.config`_.


``cryptpad.clean``
^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``cryptpad`` meta-state
in reverse order, i.e. stops the cryptpad services,
removes their configuration and then removes their containers.


``cryptpad.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the cryptpad containers
and the corresponding user account and service units.
Has a depency on `cryptpad.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``cryptpad.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the cryptpad containers
and has a dependency on `cryptpad.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``cryptpad.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the cryptpad container services
and disables them at boot time.


