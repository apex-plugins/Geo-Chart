/*
 * 0integration Geo Chart
 * Plug-in Type: Region
 * Summary: Google visualization:GeoChart region plugin used to display visualization of data on google map.
 *
 * ^^^ Contact information ^^^
 * Developed by 0integration
 * http://www.zerointegration.com
 * apex@zerointegration.com
 *
 * ^^^ License ^^^
 * Licensed Under: GNU General Public License, version 3 (GPL-3.0) -
http://www.opensource.org/licenses/gpl-3.0.html
 *
 * @author Kartik Patel - kartik.patel@zerointegration.com
 */
 
FUNCTION RENDER_GEOCHART (
    P_REGION IN APEX_PLUGIN.T_REGION,
    P_PLUGIN IN APEX_PLUGIN.T_PLUGIN,
    P_IS_PRINTER_FRIENDLY IN BOOLEAN
  ) RETURN APEX_PLUGIN.T_REGION_RENDER_RESULT 
AS
  SUBTYPE plugin_attr is VARCHAR2(32767);

  l_column_value_list  APEX_PLUGIN_UTIL.t_column_value_list;

  l_region VARCHAR2(100);

  V_DIAPLAY_MODE VARCHAR2(20);
  V_REGION_LOCATION VARCHAR2(20);
  V_REGION VARCHAR2(20);
  V_RESOLUTION VARCHAR2(20);
  V_COLOUR_AXIS_START VARCHAR2(10);
  V_COLOUR_AXIS_END VARCHAR2(10);
  V_BACKGROUD_COLOUR VARCHAR2(10);
  V_API_KEY P_PLUGIN.ATTRIBUTE_01%TYPE;

  V_DATA CLOB;
BEGIN
  -- Debug information (if app is being run in debug mode)
    IF apex_application.g_debug THEN
      APEX_PLUGIN_UTIL.debug_region
          (p_plugin => p_plugin
          ,p_region => p_region
          ,p_is_printer_friendly => p_is_printer_friendly);
    END IF;

    -- Application Plugin Attributes
    V_API_KEY := P_PLUGIN.ATTRIBUTE_01;

    -- Component Plugin Attributes
    V_DIAPLAY_MODE := P_REGION.ATTRIBUTE_01;
    V_REGION_LOCATION := P_REGION.ATTRIBUTE_02;
    V_REGION := P_REGION.ATTRIBUTE_03;
    V_COLOUR_AXIS_START := P_REGION.ATTRIBUTE_04;
    V_COLOUR_AXIS_END := P_REGION.ATTRIBUTE_05;
    V_BACKGROUD_COLOUR := P_REGION.ATTRIBUTE_06;
    
    IF V_REGION_LOCATION='world' THEN
      V_REGION := V_REGION_LOCATION;
    ELSIF V_REGION_LOCATION='country' THEN
      V_RESOLUTION := 'provinces';
    END IF;
    
    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => 'https://www.gstatic.com/charts/loader.js', P_DIRECTORY => NULL, P_VERSION => NULL, P_SKIP_EXTENSION => TRUE);
    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => 'com.zerointegration.geochart', P_DIRECTORY => P_PLUGIN.FILE_PREFIX, P_VERSION => NULL, P_SKIP_EXTENSION => FALSE);

    l_region := CASE WHEN p_region.static_id IS NOT NULL
                          THEN p_region.static_id
                          ELSE 'R'||p_region.id END;

    IF p_region.source IS NOT NULL THEN
      null;
    END IF;

    l_column_value_list := APEX_PLUGIN_UTIL.get_data
        (p_sql_statement  => p_region.source
        ,p_min_columns    => 2
        ,p_max_columns    => 3
        ,p_component_name => p_region.name
        ,p_max_rows       => p_region.fetched_rows);

    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object;
    APEX_JSON.open_array('data');

    FOR i IN 1..l_column_value_list(1).count LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('region', l_column_value_list(1)(i));
      APEX_JSON.write('val', TO_NUMBER(l_column_value_list(2)(i)));
      APEX_JSON.close_object;
    END LOOP;

    APEX_JSON.close_array;
    APEX_JSON.close_object;
    V_DATA := APEX_JSON.get_clob_output;
    APEX_JSON.free_output;
   
    sys.htp.p('<div id="chart_div_'||l_region||'"></div>');

    sys.htp.p('<div class="map-data-'||l_region||'" style="display: none;">'||V_DATA||'</div>');
    
    APEX_JAVASCRIPT.ADD_ONLOAD_CODE(P_CODE => 'google.charts.load(''current'', {''packages'': [''geochart''],''mapsApiKey'': '''||V_API_KEY||'''});');
    APEX_JAVASCRIPT.ADD_ONLOAD_CODE(P_CODE => 'google.charts.setOnLoadCallback(function(){drawMarkersMap('''||l_region||''','''||V_DIAPLAY_MODE||''','''||V_REGION||''','''||V_RESOLUTION||''','''||V_COLOUR_AXIS_START||''','''||V_COLOUR_AXIS_END||''','''||V_BACKGROUD_COLOUR||''');});');

    RETURN NULL;

END RENDER_GEOCHART;