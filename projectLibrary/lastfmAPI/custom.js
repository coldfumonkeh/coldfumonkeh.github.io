
function ajaxSearch() {
$("#searchBtn").click(function() {
	var searchVal = $("#searchValue").val();
	var searchType = $("#searchType").val();
	var randomnumber=Math.floor(Math.random()*100001);
	$("#leftContent").html('');
	$("#leftContent").load("searchResults.cfm?"+randomnumber, {searchValue: searchVal, searchType: searchType});
});
};

function getInfo(thisName,thisClass,thisMethod,thisFormat,thisLocation) {
	var name = thisName;
	var class = thisClass;
	var method = thisMethod;
	var format = thisFormat;
	var location = thisLocation;
	$("#" + location + "").html('');
	$("#" + location + "").load("getInfo.cfm", {name: thisName, class: thisClass, method: method, format: format});
};


$(document).ready(function() {
	$.ajaxSetup({async:false});
	ajaxSearch();
});