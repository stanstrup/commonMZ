function(el) {
  // Plotly sets text-anchor='end' on rightmost-column node labels, putting
  // them to the LEFT of the nodes. Flip them to appear on the RIGHT instead.
  function fixLabels() {
    var nodes = Array.from(el.querySelectorAll('.sankey-node'));
    if (!nodes.length) { setTimeout(fixLabels, 100); return; }
    var maxTx = Math.max.apply(null, nodes.map(function(g) {
      var m = (g.getAttribute('transform') || '').match(/translate\(([-\d.]+)/);
      return m ? +m[1] : 0;
    }));
    nodes.forEach(function(g) {
      var m = (g.getAttribute('transform') || '').match(/translate\(([-\d.]+)/);
      if (!m || Math.abs(+m[1] - maxTx) > 2) return;
      var t = g.querySelector('text.node-label');
      if (!t) return;
      t.setAttribute('text-anchor', 'start');
      t.setAttribute('x', '24');
    });
  }
  fixLabels();
}
