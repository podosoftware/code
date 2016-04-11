<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="main">
    <head>
       <title>barChart Sample</title>
       
       <script type="text/javascript">               
        yepnope([{
       	  load: [
          	//'css!/styles/kendo/kendo.common.min.css',
          	//'css!/styles/kendo/kendo.default.min.css',
          	'css!/styles/kendo/kendo.bootstrap.min.css',
          	'css!/styles/kendo/kendo.dataviz.bootstrap.min.css',
      		'/js/jquery/1.8.2/jquery.min.js',
      		'/js/jgrowl/jquery.jgrowl.min.js',
       	    '/js/kendo/kendo.web.min.js',
       	    '/js/kendo/kendo.all.min.js',
       	    '/js/common/common.ui.min.js',
      	    '/js/common/common.models.min.js', 
       	 	'/js/kendo/kendo.ko_KR.js'
          ],
          complete: function() {    
        	  createChart();        	  
          } //End of complete: function()
      }]);   
	</script>
	
	
	<script>		
		//챠트 제목 셋팅
		var textForChart = "학과평균";
		//차트 유형 선택 : bar(세료), column(가로), line(라인)
		var seriesDefaultsForChart = "bar";  // bar, column		
		//데이터 셋팅
		var dataSourceForChart =[
		                     	{
		                    		"ca":"의사소통",
		                    		"no1": 65,
		                    		"no2": 75,
		                    		"no3": 45,
		                    		"no4": 78,
		                    		"avg": 64,
		                    		"cmr": 85
		                    	},
		                    	{
		                    		"ca":"자기관리",
		                    		"no1": 65,
		                    		"no2": 75,
		                    		"no3": 45,
		                    		"no4": 78,
		                    		"avg": 72,
		                    		"cmr": 81
		                    	},
		                    	{
		                    		"ca":"문제해결",
		                    		"no1": 45,
		                    		"no2": 35,
		                    		"no3": 65,
		                    		"no4": 79,
		                    		"avg": 68,
		                    		"cmr": 74
		                    	},
		                    	{
		                    		"ca":"정보기술활용",
		                    		"no1": 56,
		                    		"no2": 68,
		                    		"no3": 79,
		                    		"no4": 85,
		                    		"avg": 79,
		                    		"cmr": 78
		                    	},
		                    	{
		                    		"ca":"대인관계",
		                    		"no1": 54,
		                    		"no2": 54,
		                    		"no3": 85,
		                    		"no4": 75,
		                    		"avg": 80,
		                    		"cmr": 90
		                    	},
		                    	{
		                    		"ca":"예술전문성",
		                    		"no1": 65,
		                    		"no2": 75,
		                    		"no3": 45,
		                    		"no4": 78,
		                    		"avg": 58,
		                    		"cmr": 67
		                    	}
		                    ];
		
		// 값의 최대치 설정
		var valueAxisMax = 100;
		
		//챠트 크기 height, width
		var heightChart = 600;
		
		//챠트를 생성한다.
		function createChart() {
			$("#chart").kendoChart({
                title: {
                    text: textForChart,
                    font: "45px sans-serif",
                    border: {
                      width: 0,
                    }
                },
                chartArea: {
	    		    height: heightChart,	    		  
	    	    },
                dataSource : {
                				data: dataSourceForChart ,
                },
                legend: {
                	position : "top",   
                	labels : {
                		font: "20px sans-serif"
                	}
                },
                seriesDefaults: {
                    type: seriesDefaultsForChart  //bar, column
                },
                series : [	
                          	{
								labels: {
									visible: true,
									font: "12px sans-serif",
									background: "white",									
								    template: "#= series.name #: #= value #"
								},
						        field: "no1",
								name: "1학년",
								color : "yellow"
						    }, 
						    {
								labels: {
									visible: true,
									background: "white",
									template: "#= series.name #: #= value #"
								},
						        field: "no2",
								name: "2학년",
						    },
						    {
								labels: {
									visible: true,
									background: "white",
									template: "#= series.name #: #= value #"
								},
						        field: "no3",
								name: "3학년",
						    },
						    {
								labels: {
									visible: true,
									background: "white",
									template: "#= series.name #: #= value #"
								},
						        field: "no4",
								name: "4학년",
						    },
						    {
								labels: {
									visible: true,
									background: "white",
									template: "#= series.name #: #= value #",
									color : "#0000ff"
								},
						        field: "avg",
								name: "평균",
								type : "line",
								color : "#0000ff"
						    },
						    {
								labels: {
									visible: true,
									background: "white",
									template: "#= series.name #: #= value #",
									color : "#ff0000"									
								},
						        field: "cmr",
								name: "기업요구수준",
								type : "line",
								color : "#ff0000"
						    },
			    ],
                valueAxis: {
                    max: valueAxisMax,
                    line: {
                        visible: false
                    },
                    minorGridLines: {
                        visible: false
                    },
                    axisCrossingValue: 0
                },
                categoryAxis: {
                	field: "ca",
                    majorGridLines: {
                        visible: false
                    },
                    line: {
                        visible: true
                    }

                },
                tooltip: {
                    visible: true,
                    template: "#= series.name #: #= value #"
                }
            });


        };
	</script>
	
	</head>
    <body class="cf">	
		<!-- START MAIN CONTNET -->
		<div id="example">
           <div id="chart"></div>
        </div>
        		
		<!-- END MAIN CONTENT  --> 	
		<footer>
	  	</footer>
    </body>
</html>