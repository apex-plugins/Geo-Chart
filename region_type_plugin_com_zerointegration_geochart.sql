prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>59964498029690491
,p_default_application_id=>711
,p_default_id_offset=>59966624562745583
,p_default_owner=>'ZI_DEMO'
);
end;
/
 
prompt APPLICATION 711 - Plugins
--
-- Application Export:
--   Application:     711
--   Name:            Plugins
--   Date and Time:   19:07 Thursday April 16, 2020
--   Exported By:     KARTIK.PATEL@ZEROINTEGRATION.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 44429162535447311
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     248208677495795
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/com_zerointegration_geochart
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(44429162535447311)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COM.ZEROINTEGRATION.GEOCHART'
,p_display_name=>'0integration GeoChart'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION RENDER_GEOCHART (',
'    P_REGION IN APEX_PLUGIN.T_REGION,',
'    P_PLUGIN IN APEX_PLUGIN.T_PLUGIN,',
'    P_IS_PRINTER_FRIENDLY IN BOOLEAN',
'  ) RETURN APEX_PLUGIN.T_REGION_RENDER_RESULT ',
'AS',
'  SUBTYPE plugin_attr is VARCHAR2(32767);',
'',
'  l_column_value_list  APEX_PLUGIN_UTIL.t_column_value_list;',
'',
'  l_region VARCHAR2(100);',
'',
'  V_DIAPLAY_MODE VARCHAR2(20);',
'  V_REGION_LOCATION VARCHAR2(20);',
'  V_REGION VARCHAR2(20);',
'  V_RESOLUTION VARCHAR2(20);',
'  V_COLOUR_AXIS_START VARCHAR2(10);',
'  V_COLOUR_AXIS_END VARCHAR2(10);',
'  V_BACKGROUD_COLOUR VARCHAR2(10);',
'  V_API_KEY P_PLUGIN.ATTRIBUTE_01%TYPE;',
'',
'  V_DATA CLOB;',
'BEGIN',
'  -- Debug information (if app is being run in debug mode)',
'    IF apex_application.g_debug THEN',
'      APEX_PLUGIN_UTIL.debug_region',
'          (p_plugin => p_plugin',
'          ,p_region => p_region',
'          ,p_is_printer_friendly => p_is_printer_friendly);',
'    END IF;',
'',
'    -- Application Plugin Attributes',
'    V_API_KEY := P_PLUGIN.ATTRIBUTE_01;',
'',
'    -- Component Plugin Attributes',
'    V_DIAPLAY_MODE := P_REGION.ATTRIBUTE_01;',
'    V_REGION_LOCATION := P_REGION.ATTRIBUTE_02;',
'    V_REGION := P_REGION.ATTRIBUTE_03;',
'    V_COLOUR_AXIS_START := P_REGION.ATTRIBUTE_04;',
'    V_COLOUR_AXIS_END := P_REGION.ATTRIBUTE_05;',
'    V_BACKGROUD_COLOUR := P_REGION.ATTRIBUTE_06;',
'    ',
'    IF V_REGION_LOCATION=''world'' THEN',
'      V_REGION := V_REGION_LOCATION;',
'    ELSIF V_REGION_LOCATION=''country'' THEN',
'      V_RESOLUTION := ''provinces'';',
'    END IF;',
'    ',
'    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => ''https://www.gstatic.com/charts/loader.js'', P_DIRECTORY => NULL, P_VERSION => NULL, P_SKIP_EXTENSION => TRUE);',
'    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => ''com.zerointegration.geochart'', P_DIRECTORY => P_PLUGIN.FILE_PREFIX, P_VERSION => NULL, P_SKIP_EXTENSION => FALSE);',
'',
'    l_region := CASE WHEN p_region.static_id IS NOT NULL',
'                          THEN p_region.static_id',
'                          ELSE ''R''||p_region.id END;',
'',
'    IF p_region.source IS NOT NULL THEN',
'      null;',
'    END IF;',
'',
'    l_column_value_list := APEX_PLUGIN_UTIL.get_data',
'        (p_sql_statement  => p_region.source',
'        ,p_min_columns    => 2',
'        ,p_max_columns    => 3',
'        ,p_component_name => p_region.name',
'        ,p_max_rows       => p_region.fetched_rows);',
'',
'    APEX_JSON.initialize_clob_output;',
'    APEX_JSON.open_object;',
'    APEX_JSON.open_array(''data'');',
'',
'    FOR i IN 1..l_column_value_list(1).count LOOP',
'      APEX_JSON.open_object;',
'      APEX_JSON.write(''region'', l_column_value_list(1)(i));',
'      APEX_JSON.write(''val'', TO_NUMBER(l_column_value_list(2)(i)));',
'      APEX_JSON.close_object;',
'    END LOOP;',
'',
'    APEX_JSON.close_array;',
'    APEX_JSON.close_object;',
'    V_DATA := APEX_JSON.get_clob_output;',
'    APEX_JSON.free_output;',
'   ',
'    sys.htp.p(''<div id="chart_div_''||l_region||''"></div>'');',
'',
'    sys.htp.p(''<div class="map-data-''||l_region||''" style="display: none;">''||V_DATA||''</div>'');',
'    ',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE(P_CODE => ''google.charts.load(''''current'''', {''''packages'''': [''''geochart''''],''''mapsApiKey'''': ''''''||V_API_KEY||''''''});'');',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE(P_CODE => ''google.charts.setOnLoadCallback(function(){drawMarkersMap(''''''||l_region||'''''',''''''||V_DIAPLAY_MODE||'''''',''''''||V_REGION||'''''',''''''||V_RESOLUTION||'''''',''''''||V_COLOUR_AXIS_START||'''''',''''''||V_COLOUR_AXIS_END||'''''','''
||'''''||V_BACKGROUD_COLOUR||'''''');});'');',
'',
'    RETURN NULL;',
'',
'END RENDER_GEOCHART;'))
,p_api_version=>2
,p_render_function=>'render_geochart'
,p_standard_attributes=>'SOURCE_SQL:AJAX_ITEMS_TO_SUBMIT:FETCHED_ROWS:NO_DATA_FOUND_MESSAGE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/apex-plugins/Geo-Chart'
,p_files_version=>3
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(44429866674461191)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Google Map API Key'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'To use the Maps JavaScript API you must have an API key. The API key is a unique identifier that is used to authenticate requests associated with your project for usage and billing purposes.',
'',
'https://developers.google.com/maps/documentation/javascript/get-api-key'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(44431825528627778)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Display Mode'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'regions'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Which type of geochart this is. The DataTable format must match the value specified. The following values are supported:',
'',
'Regions - Color the regions on the geochart.',
'Markers - Place markers on the regions.',
'Text - Label the regions with text from the DataTable.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(44432350593629171)
,p_plugin_attribute_id=>wwv_flow_api.id(44431825528627778)
,p_display_sequence=>10
,p_display_value=>'Region'
,p_return_value=>'regions'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(44432771749630007)
,p_plugin_attribute_id=>wwv_flow_api.id(44431825528627778)
,p_display_sequence=>20
,p_display_value=>'Markers'
,p_return_value=>'markers'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(44433136105630714)
,p_plugin_attribute_id=>wwv_flow_api.id(44431825528627778)
,p_display_sequence=>30
,p_display_value=>'Text'
,p_return_value=>'text'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(44435124149651373)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Region Location'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'world'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The area to display on the geochart. (Surrounding areas will be displayed as well.) Can be one of the following:',
'',
'''world'' - A geochart of the entire world.',
'A continent or a sub-continent, specified by its 3-digit code, e.g., ''011'' for Western Africa.',
'A country, specified by its ISO 3166-1 alpha-2 code, e.g., ''AU'' for Australia.',
'A state in the United States, specified by its ISO 3166-2:US code, e.g., ''US-AL'' for Alabama. Note that the resolution option must be set to either ''provinces'' or ''metros''.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(44435676490652690)
,p_plugin_attribute_id=>wwv_flow_api.id(44435124149651373)
,p_display_sequence=>10
,p_display_value=>'World'
,p_return_value=>'world'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(44436010319654051)
,p_plugin_attribute_id=>wwv_flow_api.id(44435124149651373)
,p_display_sequence=>20
,p_display_value=>'Continent'
,p_return_value=>'continent'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(44436415480654976)
,p_plugin_attribute_id=>wwv_flow_api.id(44435124149651373)
,p_display_sequence=>30
,p_display_value=>'Country'
,p_return_value=>'country'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(44436857684656395)
,p_plugin_attribute_id=>wwv_flow_api.id(44435124149651373)
,p_display_sequence=>40
,p_display_value=>'State'
,p_return_value=>'state'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(45185934005335794)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Region'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The area to display on the geochart. (Surrounding areas will be displayed as well.) Can be one of the following:',
'',
'''world'' - A geochart of the entire world.',
'A continent or a sub-continent, specified by its 3-digit code, e.g., ''011'' for Western Africa.',
'A country, specified by its ISO 3166-1 alpha-2 code, e.g., ''AU'' for Australia.',
'A state in the United States, specified by its ISO 3166-2:US code, e.g., ''US-AL'' for Alabama. Note that the resolution option must be set to either ''provinces'' or ''metros''.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(45187018418338231)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Colour Axis - Start'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_is_translatable=>false
,p_help_text=>'An object that specifies a mapping between color column values and colors or a gradient scale.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(45328568265550654)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Colour Axis - End'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>'An object that specifies a mapping between color column values and colors or a gradient scale.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(45329913782551702)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Background Color'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'The background color for the main area of the chart.'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(44429325263447316)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_name=>'SOURCE_SQL'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A202A2030696E746567726174696F6E2047656F2043686172740A202A20506C75672D696E20547970653A20526567696F6E0A202A2053756D6D6172793A20476F6F676C652076697375616C697A6174696F6E3A47656F436861727420726567696F';
wwv_flow_api.g_varchar2_table(2) := '6E20706C7567696E207573656420746F20646973706C61792076697375616C697A6174696F6E206F662064617461206F6E20676F6F676C65206D61702E0A202A0A202A205E5E5E20436F6E7461637420696E666F726D6174696F6E205E5E5E0A202A2044';
wwv_flow_api.g_varchar2_table(3) := '6576656C6F7065642062792030696E746567726174696F6E0A202A20687474703A2F2F7777772E7A65726F696E746567726174696F6E2E636F6D0A202A2061706578407A65726F696E746567726174696F6E2E636F6D0A202A0A202A205E5E5E204C6963';
wwv_flow_api.g_varchar2_table(4) := '656E7365205E5E5E0A202A204C6963656E73656420556E6465723A20474E552047656E6572616C205075626C6963204C6963656E73652C2076657273696F6E2033202847504C2D332E3029202D0A687474703A2F2F7777772E6F70656E736F757263652E';
wwv_flow_api.g_varchar2_table(5) := '6F72672F6C6963656E7365732F67706C2D332E302E68746D6C0A202A0A202A2040617574686F72204B617274696B20506174656C202D206B617274696B2E706174656C407A65726F696E746567726174696F6E2E636F6D0A202A2F0A200A66756E637469';
wwv_flow_api.g_varchar2_table(6) := '6F6E20647261774D61726B6572734D617028726567696F6E49642C646973706C61794D6F64652C726567696F6E2C7265736F6C7574696F6E2C636F6C6F75724178697353746172742C636F6C6F757241786973456E642C6267436F6C6F757229200A7B0A';
wwv_flow_api.g_varchar2_table(7) := '20207661722064617461203D206E657720676F6F676C652E76697375616C697A6174696F6E2E446174615461626C6528293B0A2020646174612E616464436F6C756D6E2827737472696E67272C2027526567696F6E27293B0A2020646174612E61646443';
wwv_flow_api.g_varchar2_table(8) := '6F6C756D6E28276E756D626572272C202756616C756527293B0A20207661722067446174613D4A534F4E2E7061727365282428226469762E6D61702D646174612D222B726567696F6E4964292E68746D6C2829293B0A20206966202867446174612E6461';
wwv_flow_api.g_varchar2_table(9) := '74612E6C656E6774683E30290A20207B0A202020202020666F7220287661722069203D20302C206C656E203D2067446174612E646174612E6C656E6774683B2069203C206C656E3B202B2B6929207B0A202020202020202020202076617220726563203D';
wwv_flow_api.g_varchar2_table(10) := '2067446174612E646174615B695D3B0A20202020202020202020646174612E616464526F77285B7265632E726567696F6E2C7265632E76616C5D293B0A202020202020207D0A2020207D0A2020202020207661722076696577203D206E657720676F6F67';
wwv_flow_api.g_varchar2_table(11) := '6C652E76697375616C697A6174696F6E2E44617461566965772864617461293B0A202020202020766965772E736574436F6C756D6E73285B302C20315D293B0A202020202020766172206F7074696F6E73203D207B0A2020202020202020726567696F6E';
wwv_flow_api.g_varchar2_table(12) := '3A20726567696F6E2C0A2020202020202020646973706C61794D6F64653A20646973706C61794D6F64652C0A20202020202020207265736F6C7574696F6E3A207265736F6C7574696F6E2C0A2020202020202020636F6C6F72417869733A207B636F6C6F';
wwv_flow_api.g_varchar2_table(13) := '72733A205B636F6C6F75724178697353746172742C636F6C6F757241786973456E645D7D2C0A20202020202020206B656570417370656374526174696F3A2066616C73652C0A20202020202020206261636B67726F756E64436F6C6F723A7B66696C6C3A';
wwv_flow_api.g_varchar2_table(14) := '206267436F6C6F75727D0A2020202020207D3B0A202020202020766172206368617274203D206E657720676F6F676C652E76697375616C697A6174696F6E2E47656F436861727428646F63756D656E742E676574456C656D656E74427949642827636861';
wwv_flow_api.g_varchar2_table(15) := '72745F6469765F272B726567696F6E496429293B0A20202020202063686172742E6472617728766965772C206F7074696F6E73293B0A0A7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(45367264664863244)
,p_plugin_id=>wwv_flow_api.id(44429162535447311)
,p_file_name=>'com.zerointegration.geochart.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
