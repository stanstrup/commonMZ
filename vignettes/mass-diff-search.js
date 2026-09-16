$(document).ready(function() {
  var $tbl = $('#mdl_table').find('table').first();
  if (!$tbl.length) return;
  var dt = $tbl.DataTable();
  var target = null, tolDa = null;

  $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
    if (settings.nTable !== $tbl.get(0)) return true;
    if (target === null) return true;
    var val = parseFloat(data[0]);
    return !isNaN(val) && Math.abs(val - target) <= tolDa;
  });

  $('#mdl_go').on('click', function() {
    var mz  = parseFloat(document.getElementById('mdl_mz').value);
    var ppm = parseFloat(document.getElementById('mdl_ppm').value);
    if (isNaN(mz) || isNaN(ppm)) { target = null; }
    else { target = mz; tolDa = Math.abs(mz) * ppm / 1e6; }
    dt.draw();
  });

  $('#mdl_clear').on('click', function() {
    document.getElementById('mdl_mz').value = '';
    target = null;
    dt.draw();
  });
});
