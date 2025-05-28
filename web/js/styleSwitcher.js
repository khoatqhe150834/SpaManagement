function addSwitcher()
{
	
	var demoPanel = '<div class=dz-demo-panel><div class=bg-close></div><a class=dz-demo-trigger href=javascript:void(0) data-original-title="Check out more demos"data-placement=right data-toggle=tooltip>View Demo</a><div class=dz-demo-inner><div class=dz-demo-header><h4 class="text-white m-b0">Select Preset Demo</h4><a class=dz-demo-close href=javascript:void(0)><span><i class="fa fa-close"></i></span></a></div><div class=dz-demo-content><div class="dz-wrapper row"><div class="col-lg-4 col-md-6 m-b30"><div class="rounded-lg dz-demo-bx overlay-bx"><div class="rounded-lg overlay-wrapper"><img alt=""class=w-100 src=images/demo/index.png></div><div class=overlay-layer><a class="btn btn-sm btn-success mr-2"href=index.html>Multi Page</a> <a class="btn btn-sm btn-info"href=index-6.html>One Page</a></div></div><h5 class=text-white>Demo 1</h5></div><div class="col-lg-4 col-md-6 m-b30"><div class="rounded-lg dz-demo-bx overlay-bx"><div class="rounded-lg overlay-wrapper"><img alt=""class=w-100 src=images/demo/index-2.png></div><div class=overlay-layer><a class="btn btn-sm btn-success mr-2"href=index-2.html>Multi Page</a> <a class="btn btn-sm btn-info"href=index-7.html>One Page</a></div></div><h5 class=text-white>Demo 2</h5></div><div class="col-lg-4 col-md-6 m-b30"><div class="rounded-lg dz-demo-bx overlay-bx"><div class="rounded-lg overlay-wrapper"><img alt=""class=w-100 src=images/demo/index-3.png></div><div class=overlay-layer><a class="btn btn-sm btn-success mr-2"href=index-3.html>Multi Page</a> <a class="btn btn-sm btn-info"href=index-8.html>One Page</a></div></div><h5 class=text-white>Demo 3</h5></div><div class="col-lg-4 col-md-6 m-b30"><div class="rounded-lg dz-demo-bx overlay-bx"><div class="rounded-lg overlay-wrapper"><img alt=""class=w-100 src=images/demo/index-4.png></div><div class=overlay-layer><a class="btn btn-sm btn-success mr-2"href=index-4.html>Multi Page</a> <a class="btn btn-sm btn-info"href=index-9.html>One Page</a></div></div><h5 class=text-white>Demo 4</h5></div><div class="col-lg-4 col-md-6 m-b30"><div class="rounded-lg dz-demo-bx overlay-bx"><div class="rounded-lg overlay-wrapper"><img alt=""class=w-100 src=images/demo/index-5.png></div><div class=overlay-layer><a class="btn btn-sm btn-success mr-2"href=index-5.html>Multi Page</a> <a class="btn btn-sm btn-info"href=index-10.html>One Page</a></div></div><h5 class=text-white>Demo 5</h5></div><div class="col-lg-4 col-md-6 m-b30"><div class="rounded-lg dz-demo-bx overlay-bx"><div class="rounded-lg overlay-wrapper"><img alt=""class=w-100 src=images/demo/index-6.png></div><div class=overlay-layer><a class="btn btn-sm btn-success mr-2"href=index-11.html>Multi Page</a> <a class="btn btn-sm btn-info"href=index-12.html>One Page</a></div></div><h5 class=text-white>Demo 6</h5></div></div></div><div class="bottom-text fs-14"><span class=text-danger>*Note :</span>This theme switcher is not part of product. It is only for demo. you will get all guideline in documentation. please check <a class=text-primary href=https://beautyzone.dexignzone.com/doc/ target=_blank>documentation.</a></div></div></div>';
	
	if($("#dzSwitcher").length == 0) {
		jQuery('body').append(demoPanel);
		
			
		 //const ps = new PerfectScrollbar('.sidebar-right-inner');
		 //console.log(ps.reach.x);	
			//ps.isRtl = false;
				
		  $('.sidebar-right-trigger').on('click', function() {
				$('.sidebar-right').toggleClass('show');
		  });
		  $('.sidebar-close-trigger,.bg-overlay').on('click', function() {
				$('.sidebar-right').removeClass('show');
		  });
	}
}

(function($) {
    "use strict"
	addSwitcher();
	
})(jQuery);


