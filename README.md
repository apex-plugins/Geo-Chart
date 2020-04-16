# Geo-Chart

Google visualization:GeoChart region plugin used to display visualization of data on google map.

**A Region plugin for Oracle Application Express**

This plugin allows you to display visualization of data on google map. 

![Preview1.png](https://raw.githubusercontent.com/apex-plugins/Geo-Chart/master/Source/Preview1.png)
![Preview2.png](https://raw.githubusercontent.com/apex-plugins/Geo-Chart/master/Source/Preview2.png)
![Preview3.png](https://raw.githubusercontent.com/apex-plugins/Geo-Chart/master/Source/Preview3.png)

## DEMO ##

[https://apps.zerointegration.com/demo/f?p=apexplugins:geochart](https://apps.zerointegration.com/demo/f?p=apexplugins:geochart)

## PRE-REQUISITES ##

* You need a [Google Maps API Key](https://developers.google.com/maps/documentation/javascript/get-api-key#get-an-api-key)

## INSTALLATION ##

1. Download the [latest release](https://github.com/apex-plugins/Geo-Chart/releases/latest)
2. Install the plugin to your application - **region_type_plugin_com_zerointegration_geochart.sql**
3. Supply your **Google API Key** (Component Settings)
4. Add a region to the page and use below SQL Query format to get data.

SELECT COUNTRY, POPULATION FROM TABLE

For more info, refer to the [WIKI](https://github.com/apex-plugins/Geo-Chart/wiki).