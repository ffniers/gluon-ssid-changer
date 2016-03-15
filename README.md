ssid-changer
============

Script to change the SSID when there is no suffic sufficient connection to the selected Gateway.

It is quite basic, it just checks the Quality of the Connection and decides if a change of the SSID is necessary.

Create a file "modules" with the following content in your site directory:

GLUON_SITE_FEEDS="ssidchanger"<br>
PACKAGES_SSIDCHANGER_REPO=https://github.com/ffniers/gluon-ssid-changer.git<br>
PACKAGES_SSIDCHANGER_COMMIT=COMES NEXT<br>

With this done you can add the package gluon-ssid-changer to your site.mk

This skript is tested with Gluon 2015.2.1 and the current master (upcoming 2016.1)

* Forked from

https://github.com/valcryst/gluon-ssid-changer
https://github.com/ffac/gluon-ssid-changer
