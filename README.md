multi_http
==========

Description
-----------

Puppet report handler that functions exactly the same as the built-in HTTP report handler, but
adds support for posting reports to multiple URLs. This is useful if you use Puppet Dashboard along
with another HTTP service that recieves Puppet reports.

Requirements
------------

* `puppet`

Installation & Usage
--------------------

1. Create `multi_http.yaml` in your `/etc/puppet` directory.

    ```
    ---
    :urls:
      - http://webhook.example.com/hook/puppet
      - http://dashboard.example.com:3000/reports/upload
    ```

2. Install `ianunruh/multi_http` as a module in your Puppet modules directory.

3. Enable pluginsync and reports on your master and agents in `/etc/puppet/puppet.conf`.

    ```
    [master]
      report = true
      reports = multi_http
      pluginsync = true
    [agent]
      report = true
      pluginsync = true
    ```

4. Run the Puppet clients and start getting reports

Author
------

Ian Unruh <ianunruh@gmail.com>


License
-------

Licensed under the MIT license.
