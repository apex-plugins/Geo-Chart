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
 
function drawMarkersMap(regionId,displayMode,region,resolution,colourAxisStart,colourAxisEnd,bgColour) 
{
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Region');
  data.addColumn('number', 'Value');
  var gData=JSON.parse($("div.map-data-"+regionId).html());
  if (gData.data.length>0)
  {
      for (var i = 0, len = gData.data.length; i < len; ++i) {
           var rec = gData.data[i];
          data.addRow([rec.region,rec.val]);
       }
   }
      var view = new google.visualization.DataView(data);
      view.setColumns([0, 1]);
      var options = {
        region: region,
        displayMode: displayMode,
        resolution: resolution,
        colorAxis: {colors: [colourAxisStart,colourAxisEnd]},
        keepAspectRatio: false,
        backgroundColor:{fill: bgColour}
      };
      var chart = new google.visualization.GeoChart(document.getElementById('chart_div_'+regionId));
      chart.draw(view, options);

};