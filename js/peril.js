var kar_idx = 1,
    $img = $('#home img');

setInterval(function(){
  $img.attr('src', 'images/karyotype/chr'+kar_idx+'.png');
  kar_idx++;
  if(kar_idx==24){kar_idx=1;}
}, 400);

$(document).ready(function() {
  $img.fadeIn(10000);
});

var prep_section = function($section) {
  $section.css({backgroundColor: '#fff'});
  $section.html('<i class="fa fa-circle-o-notch fa-spin fa-5x"></i>')
}

var show_section = function($section) {
  $section.find('svg').fadeIn('slow');
  $section.find('i').fadeOut(function() {
    $(this).remove();
  });
}

/* D3 Code for drawing / UX of sections */
var draw_chr_graph = function(chr_num) {
  var $section = $('section#chr'+chr_num);
  prep_section($section);

  var section_height = 500,
      margin = {top: 0, right: 0, bottom: 120, left: 30},
      margin2 = {top: 400, right: 0, bottom: 20, left: 30},
      width = $('body').width() - margin.left - margin.right,
      height = section_height - margin.top - margin.bottom,
      height2 = section_height - margin2.top - margin2.bottom;

  var x = d3.scale.linear().range([0, width]),
      x2 = d3.scale.linear().range([0, width]),
      y = d3.scale.linear().range([height, 0]),
      y2 = d3.scale.linear().range([height2, 0]);

  var xAxis = d3.svg.axis().scale(x2).orient('bottom');
  var brush = d3.svg.brush()
      .x(x2)
      .on('brush', brushed);
  var stack = d3.layout.stack().offset('silhouette');

  /* Layouts */
  var area = d3.svg.area()
      .x(function(d) { return x(d.x); })
      .y0(function(d) { return y(d.y0); })
      .y1(function(d) { return y(d.y0 + d.y); });

  var area2 = d3.svg.area()
      .interpolate('linear')
      .x(function(d, idx) { return x2(idx); })
      .y0(height2)
      .y1(function(d) { return y2(d['sum']); });

  var color =  d3.scale.linear().domain([0, 1, 2]).range(['#C5E3FA', '#FF6666', '#0B2C3C']),
      bg_color =  d3.scale.linear().domain([0, 297]).range(['#DADFE1', '#444444']),
      dsv = d3.dsv(' ', 'text/plain'),
      layers, stacked, rectangle;

  /* Full SVG that fills the Chromosome Section */
  var svg = d3.select('#chr'+chr_num)
      .append('svg')
        .style('display', 'none')
        .attr({
          'width': width + margin.left + margin.right,
          'height': height + margin.top + margin.bottom
        });

  svg.append('defs').append('clipPath')
    .attr('id', 'clip')
    .append('rect')
      .attr({
        'width': width,
        'height': height
      });

  /* The dynamic background
  var background = svg.append('g')
      .attr({
        'class': 'background',
        'transform': 'translate(' + margin.left + ',' + (margin.top - margin2.bottom) + ')'
      });
  */

  /* The main view */
  var focus = svg.append('g')
      .attr({
        'class': 'focus',
        'transform': 'translate(' + margin.left + ',' + margin.top + ')'
      });

  /* Provides the zoom brush function */
  var context = svg.append('g')
      .attr({
        'class': 'context',
        'transform': 'translate(' + margin2.left + ',' + margin2.top + ')'
      });

  y.domain([0, 297]);
  y2.domain(y.domain());

  dsv('data/chr20_at50mil_formatted.tsv', type, function(error, data) {

    layers = stack( d3.range(3).map(function(i) {
      return data.map(function(d, idx) {
        return {'x': idx, 'y': d[i]};
      });
    }) );

    x.domain([0, data.length]);
    x2.domain(x.domain());

    /* Chr SNP Focus Viewport */
    stacked = focus.selectAll('path').data(layers)
    stacked.exit().remove();
    stacked.enter().append('path');
    stacked
      .attr('d', area)
      .style('fill', function(d, idx) { return color(idx); });

    /* Chr SNP Focus Viewport
    rectangle = background.selectAll('rect').data(data);
    rectangle.exit().remove();
    rectangle.enter().append('rect');
    rectangle.attr({
      'x': function(d, idx) { return x(idx); },
      'y': 0,
      'width': '1px',
      'height': section_height
    }).style('fill', function(d) { return bg_color(d['sum']); });
    */

    /* Area Legend */
    context.append('path')
      .datum(data)
      .attr({
        'class': 'area',
        'd': area2
      });

    context.append('g')
      .attr({
        'class': 'x axis',
        'transform': 'translate(0,' + height2 + ')'
      }).call(xAxis);

    context.append('g')
      .attr('class', 'x brush')
      .call(brush)
      .selectAll('rect')
        .attr({
          'y': -6,
          'height': height2 + 7
        });

    show_section($section);
  });

  function brushed() {
    x.domain(brush.empty() ? x2.domain() : brush.extent());
    stacked.attr('d', area);
  }

  function type(d) {
    var obj = Object();
    obj[0] = +d.phred_1
    obj[1] = +d.phred_2
    obj[2] = +d.phred_3
    obj['sum'] = obj[0]+obj[1]+obj[2]
    return obj;
  }

}
