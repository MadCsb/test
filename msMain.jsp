<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.wootide.travel.modules.partner.*"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>南京智慧民宿</title>
<meta name="baidu-site-verification" content="XFQucHwK8v" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0;" />
<meta name="format-detection" content="telephone=no" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/ms/css/ms-main.css" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-1.6.2.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/fusionchart/FusionCharts.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/selectRangeDateMs.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/echarts/echarts.js"></script>
</head>

<script type="text/javascript">

    //页面初始化后加载方法
    $(function(){
   
    	selectDate('0',null);
    	//getCompany();
    	//getProduction();
    	//showHomeHotelOperatorTrend(5,null);
    	//getTrade();
    	//getYYSInfoTotal();
    	msSourceStatistic(0);
    })

	//重新选择日期后加载方法
	function reLoad(){
		showHomeHotelOperatorTrend(4);
		showHomeHotelAreaCount(0);
		showHomeHotelAreaCount(1);
		showHomeHotelAreaCount(2);
		showHomeHotelTop10(0);
		//getTrade();
		getYYSInfoTotal();
	}

	//FusionCharts使用js方式渲染
	FusionCharts.setCurrentRenderer('javascript');

    //民宿区域统计
	function getCompany(){
		$.post('getCompanys.action',{"statistic.spId":$("#spId").val()},function(data){
			var chart = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/Pie2D.swf", "company_flash", "100%", "300", "0", "1" ); 
	       chart.setXMLData(data);
	       chart.render("sourcediv");
	       
	       //图表div上加入一层蒙板  变通方法去除图表点击功能
	       $("#sourcedivpanel").height($("#sourcediv").height()).width($("#sourcediv").width());
	       
		});
	}
	
	//民宿类型统计
	function getProduction(){
		$.post('getProductions.action',{"statistic.spId":$("#spId").val()},function(data){
			var chart = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/Pie2D.swf", "production_flash", "100%", "300", "0", "1" );
	       chart.setXMLData(data);
	       chart.render("sourcediv");
		});
	}
	
	
	//民宿星级统计
	function getPartner(){
		$.post('getPartners.action',{"statistic.spId":$("#spId").val()},function(data){
			var chart = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/Pie2D.swf", "partner_flash", "100%", "300", "0", "1" );
	       chart.setXMLData(data);
	       chart.render("sourcediv");
		});
	}
	//民宿价格统计
	function getMsPrice(){

		$.post('queryMddFansChart.action',{"statistic.spId":$("#spId").val()},function(data){
			var chart = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/Pie2D.swf", "mddFans_flash", "100%", "300", "0", "1" );
	       chart.setXMLData(data);
	       chart.render("sourcediv");
		});
	}
	
	//民宿资源统计
	function msSourceStatistic(type){
	
		if(type==0){
			getCompany();
		}else if(type==1){
			getProduction();
		}else if(type==2){
			getPartner();
		}else if(type==3){
			getMsPrice();
		}
	
	
		$(".ss1 .dd-one").removeClass().addClass("dd-two");
		$("#mp"+type).removeClass().addClass("dd-one");
	
	}
	
	//运营商新增趋势
	
	function showHomeHotelOperatorTrend(type)
	{
		var areaId="MSLine_flash"+type;
		var homeHotelOperatorTrend = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/MSLine.swf", areaId, "100%", "300", "0", "1" );

		$(".ss2 .dd-one").removeClass().addClass("dd-two");
		$("#sp"+type).removeClass().addClass("dd-one");

	    if(type=='5'){
			$.post('queryChartSale.action',{'statistic.statisticType':$("#statisticType").val(),'statistic.orderDateStart':$("#startDateTemp").val(),'statistic.orderDateEnd':$("#endDateTemp").val(),"spId":$("#spId").val()},function(data){
		       homeHotelOperatorTrend.setXMLData(data);
		       homeHotelOperatorTrend.render("homeHotelOperatorTrend");
                //图表div上加入一层蒙板  变通方法去除图表点击功能
			   $("#homeHotelOperatorTrendpanel").height($("#homeHotelOperatorTrend").height()).width($("#homeHotelOperatorTrend").width());
	        });
		}else{
			var url;
			$("#homeHotelOperatorTrendType").val(type);
			$.post("queryHomeHotelOperatorTrend.action",{"statistic.homeHotelOperatorTrendType":type,"statistic.spId":$("#spId").val(),"statistic.statisticType":$("#statisticType").val(),"statistic.orderDateStart":$("#startDateTemp").val(),"statistic.orderDateEnd":$("#endDateTemp").val()
			},function(data){
				homeHotelOperatorTrend.setXMLData(data);
                homeHotelOperatorTrend.render("homeHotelOperatorTrend");
                //图表div上加入一层蒙板  变通方法去除图表点击功能
                $("#homeHotelOperatorTrendpanel").height($("#homeHotelOperatorTrend").height()).width($("#homeHotelOperatorTrend").width());
			});
		}
	}
	//=============================================================================================
	//区域统计图(柱形图)
	function showHomeHotelAreaCount(type)
	{
		var areaId="ChartId_flashArea"+type;
		var homeHotelAreaCount = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/Column3D.swf",areaId, "100%", "300", "0", "1");
		/*$(".ss3 .dd-one").removeClass().addClass("dd-two");
		$("#area"+type).removeClass().addClass("dd-one");*/

		$.post("showHomeHotelAreaCount.action", {
			"statistic.homeHotelOperatorTrendType":type,
			"statistic.spId":$("#spId").val(),
			"statistic.statisticType":$("#statisticType").val(),
			"statistic.orderDateStart":$("#startDate").val(),
			"statistic.orderDateEnd":$("#endDate").val()}, 
			function(data) {
			homeHotelAreaCount.setXMLData(data);
			homeHotelAreaCount.render("homeHotelAreaCount"+type);
			$("#homeHotelAreaCountPanel"+type).height($("#homeHotelAreaCount"+type).height()).width($("#homeHotelAreaCount"+type).width());
		});
	}
	
	//区域统计图(横柱形图)
	var homeHotelTop = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/MSBar3D.swf", "ChartId_flashTop", "96%", "300", "0", "1" );
	function showHomeHotelTop10(type)
	{
		$(".ss4 .dd-one").removeClass().addClass("dd-two");
		$("#top"+type).removeClass().addClass("dd-one");

		$.post("showHomeHotelTop10.action", {
			"statistic.homeHotelOperatorTrendType":type,
			"statistic.spId":$("#spId").val(),
			"statistic.statisticType":$("#statisticType").val(),
			"statistic.orderDateStart":$("#startDate").val(),
			"statistic.orderDateEnd":$("#endDate").val()}, 
			function(data) {
			homeHotelTop.setXMLData(data);
			homeHotelTop.render("homeHotelTop10");
			$("#homeHotelTop10Panel").height($("#homeHotelTop10").height()).width($("#homeHotelTop10").width());
		});
	}
	//======================================================================================================
	//民宿区域销售统计
	var jiaoYichart = new FusionCharts("<%=request.getContextPath()%>/js/fusionchart/Column3D.swf","ChartId_flash", "100%", "300", "0", "1");
	function getTrade() {
		$.post("toGetTrade.action", {
			"statistic.orderDateStart" : $("#startDate").val(),
			"statistic.orderDateEnd" : $("#endDate").val(),
			"spId" : $("#spId").val()
		}, function(data) {
			jiaoYichart.setXMLData(data);
			jiaoYichart.render("chartdiv");

			//图表div上加入一层蒙板  变通方法去除图表点击功能
			$("#chartdivpanel").height($("#chartdiv").height()).width(
					$("#chartdiv").width());
		});
	}

	//打开选择日期面板
	function openSelectDateDiv() {

		$("#selectDateDiv").toggle();
	}

	//选择日期方法
	function selectDate(val, obj) {

		changeRangeDateByVal(val, "startDate", "endDate");

		if (val == '0' || val == '1') {
			var currentDate = new Date();
			currentDate.setDate(currentDate.getDate() - 7);
			$("#startDateTemp").val(getDateStr(currentDate));
			$("#endDateTemp").val(getDateStr(new Date()));
		} else {
			$("#startDateTemp").val($("#startDate").val());
			$("#endDateTemp").val($("#endDate").val());
		}

		if (val == '8' || val == '9') {
			$("#statisticType").val(2);
		} else {
			$("#statisticType").val(1);
		}
		if (obj != null) {
			$("#spandiv").text($(obj).text());
		}

		$("#selectDateDiv").hide();
		reLoad();

	}

	//民宿运营总览 统计
	function getYYSInfoTotal() {

		$.post("getYYSInfoTotal_Front.action", {
			"statistic.orderDateStart" : $("#startDate").val(),
			"statistic.orderDateEnd" : $("#endDate").val(),
			"statistic.spId" : $("#spId").val()
		}, function(data) {
			var html = "";
			html = "<tr>" + "<td>注册客户数<p>" + data.msRegPeopleTotal
					+ "</p></td>" + "<td>入住率<p>" + data.msOccupancyRateCount
					+ "%</p></td>" + "</tr>";
			html += "<tr>" + "<td>民宿业主<p>" + data.msCompanyTotal + "</p></td>"
					+ "<td>订单销售额<p>&yen;" + data.msMoneyCount + "</p></td>"
					+ "</tr>";
			html += "<tr>" + "<td>上线民宿数量<p>" + data.msRoomTotal + "</p></td>"
					+ "<td>订单量<p>" + data.msOrderCount + "</p></td>" + "</tr>";
			html += "<tr>" + "<td>可容纳住宿人数<p>" + data.msMaxCheckInNumTotal
					+ "</p></td>" + "<td>入住房间数<p>" + data.msOrderRoomCount
					+ "</p></td>" + "</tr>";
			html += "<tr>" + "<td>在线民宿平均房价<p>&yen;" + data.msAvgRoomPriceCount
					+ "</p></td>" + "<td>入住人数<p>" + data.msOrderPeopleCount
					+ "</p></td>" + "</tr>";
			html += "<tr>" + "<td>发布民宿房间数<p>1128</p></td>"
					+ "<td>床位数<p>1991</p></td>" + "</tr>";
			$("#yysInfo").html(html);
		}, "json");
	}
</script>
<body>
	<div class="w">
		<input type="hidden" id="spId" value="${spId}" /> <input
			type="hidden" id="statisticType" value="1"> <input
			type="hidden" value="${statistic.startDate}" id="startDate" /> <input
			type="hidden" value="${statistic.endDate}" id="endDate" /> <input
			type="hidden" id="startDateTemp" /> <input type="hidden"
			id="endDateTemp" /> <input type="hidden"
			id="homeHotelOperatorTrendType" value="" />
			<!--header 开始--> <header>
			<div class="header">
				<a class="new-a-back" href="index.html"> <%-- <span>返回</span> --%>
				</a>
				<h2 style="background-color: #9900cd">民宿运营报告</h2>
				<a class="new-a-sc" href=""> <span></span> </a>
			</div>
			</header> <!--header 结束-->
			<div class="clearfix"></div>

			<div class="page">
				<div class="main">
					<nav class="sj-nav" style=" margin-top:0;"> <a
						href="javascript:openSelectDateDiv();"><span id="spandiv"
						class="dd-one" style="width:100%">今天</span><i class="down-ico"></i>
					</a> </nav>

					<div class="sj-open-div" id="selectDateDiv" style="display: none;">
						<ul>
							<li onclick="selectDate('1',this);">昨天</li>
							<li onclick="selectDate('0',this);">今天</li>
							<li onclick="selectDate('2',this);">一周</li>
							<li onclick="selectDate('4',this);">半个月</li>
							<li onclick="selectDate('5',this);">一个月</li>
							<li onclick="selectDate('8',this);">半年</li>
							<li onclick="selectDate('9',this);">一年</li>
						</ul>
					</div>

					<div class="title">
						<i></i>【运营总览】
					</div>
					<div class="tjcon">
						<table width="100%" id="yysInfo" border="0" cellspacing="0"
							cellpadding="0" class="tabcss">
						</table>
					</div>
					<div class="title">
						<i></i>【民宿资源统计】
					</div>
					<div style="width:100%;height:40px;">
						<nav class="bq-nav">
						<div class="ss1">
							<span class="dd-one" id="mp0" onclick="msSourceStatistic('0')">民宿区域</span>
							<span class="dd-two" id="mp1" onclick="msSourceStatistic('1')">民宿类型</span>
							<%-- <span class="dd-two" id="mp2" onclick="msSourceStatistic('2')">民宿星级</span>   --%>
							<span class="dd-two" id="mp3" onclick="msSourceStatistic('3')">民宿价格</span>
						</div>
						</nav>
					</div>
					<div class="tjcon" style="position: relative;">
						<div id="sourcedivpanel" style="position: absolute;z-index: 999;"></div>
						<div id="sourcediv"></div>
					</div>
					<div style="clear:both; height:8px;"></div>
					<div class="title">
						<i></i>【民宿区域入住率统计】
					</div>
					<div class="tjcon" style="position: relative;">
						<div id="homeHotelAreaCountPanel2"
							 style="position: absolute;z-index: 999;"></div>
						<div id="homeHotelAreaCount2"></div>
					</div>
					<div class="title">
						<i></i>【民宿区域销售额统计】
					</div>
					<div class="tjcon" style="position: relative;">
						<div id="homeHotelAreaCountPanel1"
							 style="position: absolute;z-index: 999;"></div>
						<div id="homeHotelAreaCount1"></div>
					</div>


					<div class="title">
						<i></i>【民宿区域订单量统计】
					</div>
					<div class="tjcon" style="position: relative;">
						<div id="homeHotelAreaCountPanel0"
							style="position: absolute;z-index: 999;"></div>
						<div id="homeHotelAreaCount0"></div>
					</div>


					<div class="title">
						<i></i>【民宿前十排名】
					</div>
					<div style="width:100%;height:40px;">
						<nav class="bq-nav">
						<div style="width:610px; overflow-x:scroll;" class="ss4">
							<span class="dd-one" id="top0" onclick="showHomeHotelTop10('0')">订单量</span>
							<span class="dd-two" id="top1" onclick="showHomeHotelTop10('1')">销售额</span>
							<span class="dd-two" id="top2" onclick="showHomeHotelTop10('2')">入住率</span>
						</div>
						</nav>
					</div>
					<div class="tjcon" style="position: relative;">
						<div id="homeHotelTop10Panel"
							style="position: absolute;z-index: 999;"></div>
						<div id="homeHotelTop10"></div>
					</div>
					<div style="clear:both; height:8px;"></div>
					<div class="title">
						<i></i>【民宿运营趋势】
					</div>
					<div style="width:100%;height:40px;">
						<nav class="bq-nav">
						<div style="width:610px; overflow-x:scroll;" class="ss2">
							<span class="dd-one" id="sp4"
								  onclick="showHomeHotelOperatorTrend('4')">民宿入住率</span>
							<span class="dd-two" id="sp5"
								onclick="showHomeHotelOperatorTrend('5')">民宿销售额</span>
							<span class="dd-two" id="sp3"
								onclick="showHomeHotelOperatorTrend('3')">平均房价</span>
							<span class="dd-two" id="sp0"
								  onclick="showHomeHotelOperatorTrend('0')">民宿订单量</span>
							<span class="dd-two" id="sp1"
									onclick="showHomeHotelOperatorTrend('1')">入住客房数</span>
							<span class="dd-two" id="sp2"
									onclick="showHomeHotelOperatorTrend('2')">民宿预定人数</span>
						</div>
						</nav>
					</div>
					<div class="tjcon" style="position: relative;">
						<div id="homeHotelOperatorTrendpanel"
							style="position: absolute;z-index: 999;"></div>
						<div id="homeHotelOperatorTrend"></div>
					</div>
				</div>
			</div>
	</div>
</body>

</html>
