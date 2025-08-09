function roundWithAccuracy(value, digits) {
  var accuracy = Math.pow(10, digits);
  return Math.round(value * accuracy) / accuracy;
}

function create_line_chart(data) {
  $('#line-chart').empty();

  new Chartist.Line('#line-chart', data,
    {
      fullWidth: true,
      height: 250,
      showPoint: true,
      chartPadding: { left: 15, right: 50 },
      axisX: { showGrid: false },
      axisY: { onlyInteger: true },
      lineSmooth: Chartist.Interpolation.none(),
      plugins: [
        Chartist.plugins.tooltip({
          appendToBody: true,
          pointClass: 'ct-point',
          metaIsHTML: true
        })
      ]
    }
  );
}

function draw_line(template, data) {
  $(template).empty();

  new Chartist.Line(template, data,
    {
      fullWidth: true,
      height: 250,
      showPoint: true,
      chartPadding: { left: 15, right: 50 },
      axisX: { showGrid: false },
      axisY: { onlyInteger: true },
      lineSmooth: Chartist.Interpolation.none(),
      relative: true,
      plugins: [
        Chartist.plugins.tooltip({
          appendToBody: true,
          pointClass: 'ct-point',
          metaIsHTML: true
        })
      ]
    }
  );
}