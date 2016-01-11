ssid-changer
============

Script to change the SSID when there is no suffic sufficient connection to the selected Gateway.

It is quite basic, it just checks the Quality of the Connection and decides if a change of the SSID is necessary.

Create a file "modules" with the following content in your <a href="https://github.com/valcryst/site/tree/offline-ssid"> site directory:</a>

GLUON_SITE_FEEDS="ssidchanger"<br>
PACKAGES_SSIDCHANGER_REPO=https://github.com/valcryst/gluon-ssid-changer.git<br>
PACKAGES_SSIDCHANGER_COMMIT=83ad4711e0ed939fcd5a8db611441176ed7b58f3<br>

With this done you can add the package gluon-ssid-changer to your site.mk

This skript is tested with Gluon 2015.2.1 and the current master (upcoming 2016.1)

* Forked from
https://github.com/ffac/gluon-ssid-changer
