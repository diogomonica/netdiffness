var margin = {top: 50, right: 200, bottom: 0, left: 40},
	width = 550,
	height = 100;

var start_year = 0,
	end_year = 6;

var c = d3.scale.category20c();

var svg = d3.select("#history").append("svg")
	.attr("width", width + margin.left + margin.right)
	.attr("height", height + margin.top + margin.bottom)
	.style("margin-left", margin.left + "px")
	.append("g")
	.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.json(document.URL + ".json", function(data) {
	console.log(data);
  var x = d3.scale.ordinal()
      .domain(data['timeline'])
      .rangePoints([0, width]);

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("top");

  svg.append("g")
    .attr("class", "x axis")
    .call(xAxis);

	x.domain([start_year, end_year]);
	var xScale = d3.scale.linear()
		.domain([start_year, end_year])
		.range([0, width]);

		var g = svg.append("g");

		var circles = g.selectAll("circle")
			.data(data['articles'])
			.enter().append("a")
			.attr("xlink:href", function(d) {return "/scan_results/" + data['current_result'] +"/compare/" + d[2]; })
			.append("circle");

		var rScale = d3.scale.linear()
			.domain([0, d3.max(data['articles'], function(d) { return d[1]; })])
			.range([2, 9]);

		circles
				.attr("cx", function(d, i) { return xScale(d[0]); })
				.attr("cy", 20+20)
				.attr("r", function(d) { return rScale(d[1]); })
				.style("fill", function(d) { return c(1); });
});
