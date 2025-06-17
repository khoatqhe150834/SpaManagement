/**
Core script to handle the entire theme and core functions
**/
var BeautyZone = function(){
	/* Search Bar ============ */
	siteUrl = '';
	
	var screenWidth = $( window ).width();
	
	/* Search ============ */
	var homeSearch = function() {
		'use strict';
		/* top search in header on click function */
		var quikSearch = jQuery("#quik-search-btn");
		var quikSearchRemove = jQuery("#quik-search-remove");
		
		quikSearch.on('click',function() {
			jQuery('.dlab-quik-search').animate({'width': '100%' });
			jQuery('.dlab-quik-search').delay(500).css({'left': '0'  });
		});
		
		quikSearchRemove.on('click',function() {
			jQuery('.dlab-quik-search').animate({'width': '0%' ,  'right': '0'  });
			jQuery('.dlab-quik-search').css({'left': 'auto'  });
		});	
		/* top search in header on click function End*/
	}
	
	/* Cart ============ */
	var cartButton = function(){
		$(".item-close").on('click',function(){
			$(this).closest(".cart-item").hide('500');
		});
		$('.cart-btn').unbind().on('click',function(){
			$(".cart-list").slideToggle('slow');
		})
		
	}  
	
	/* One Page Layout ============ */
	var onePageLayout = function() {
		'use strict';
		var headerHeight =   parseInt(jQuery('.onepage').css('height'), 10);
		jQuery(".scroll").unbind().on('click',function(event) 
		{
			event.preventDefault();
			
			if (this.hash !== "") {
				var hash = this.hash;	
				var seactionPosition = jQuery(hash).offset().top;
				var headerHeight =   parseInt(jQuery('.onepage').css('height'), 10);
				
				
				jQuery('body').scrollspy({target: ".navbar", offset: headerHeight+2}); 
				
				var scrollTopPosition = seactionPosition - (headerHeight);
				
				jQuery('html, body').animate({
					scrollTop: scrollTopPosition
				}, 800, function(){
					
				});
			}   
		});
		jQuery('body').scrollspy({target: ".navbar", offset: headerHeight + 2});  
		
		/* One Page Setup */
		if(jQuery('.navbar-nav-scroll').length > 0){
			
			jQuery(document).on("scroll", pageOnScroll);
			
			
			
			var headerFullHeight =   parseInt($('.main-bar').css('height'), 10);
			
			//smoothscroll
			jQuery('.navbar-nav-scroll a[href^="#"]').on('click', function (e) {
				e.preventDefault();
				jQuery(document).off("scroll");
				
				jQuery('.navbar-nav-scroll a').each(function () {
					
					jQuery(this).parent('li').removeClass('active');
				})				
				jQuery(this).parent('li').addClass('active');
				
				var target = this.hash,
				
					menu = target;
				var $target = $(target);
				
				if($target.length > 0){					
					jQuery('html, body').stop().animate({						
						'scrollTop': $target.offset().top - headerFullHeight
					}, 500, 'swing', function () {
						
						//window.location.hash = target;
						jQuery(document).on("scroll", pageOnScroll);
					});
				}
			});
			
		}
	}
	
	var pageOnScroll = function(event){
		var scrollPos = jQuery(document).scrollTop();
		jQuery('.navbar-nav-scroll > li').each(function () {
			var elementLink = jQuery(this).find('a:first');
			var refElement = jQuery(elementLink.attr("href"));
			
			var headerFullHeight =   parseInt($('.main-bar').css('height'), 10);
			if (refElement.offset().top - headerFullHeight - 20 <= scrollPos && refElement.offset().top + refElement.height() > scrollPos) {
			
				jQuery('.navbar-nav-scroll a').parent('li').removeClass("active");
				elementLink.parent('li').addClass("active");
			}else{
				elementLink.parent('li').removeClass("active");
			}
		});
	} 
	
	/* Header Height ============ */
	var handleResizeElement = function(){
		$('.header').css('height','');
		var headerHeight = $('.header').height();
		$('.header').css('height', headerHeight);
	}
	
	/* Load File ============ */
	var dzTheme = function(){
		'use strict';
		var loadingImage = '<img src="error-404.html">';
		jQuery('.dzload').each(function(){
		var dzsrc =   siteUrl + $(this).attr('dzsrc');
		 	jQuery(this).hide(function(){
				jQuery(this).load(dzsrc, function(){
					jQuery(this).fadeIn('slow');
				}); 
			})
			
		});
		if(screenWidth < 991)
		{
			if($('.mo-left .header-nav').children('div').length == 0){
				var logoData = jQuery('<div>').append($('.mo-left .logo-header').clone()).html();
				jQuery('.mo-left .header-nav').prepend(logoData);
				jQuery('.mo-left .header-nav .logo-header > a > img').attr('src','images/logo.png');
				jQuery('.mo-left.lw .header-nav .logo-header > a > img').attr('src','images/logo-white.png');
			}
		}else{
			jQuery('.mo-left .header-nav div').empty();
			jQuery('.mo-left.lw .header-nav div').empty();
		}
				
		if(screenWidth <= 991 ){
			jQuery('.navbar-nav > li > a, .sub-menu > li > a').unbind().on('click', function(e){
				//e.preventDefault();
				if(jQuery(this).parent().hasClass('open'))
				{
					jQuery(this).parent().removeClass('open');
				}
				else{
					jQuery(this).parent().parent().find('li').removeClass('open');
					jQuery(this).parent().addClass('open');
				}
			});
		}
	}
	
	/* Magnific Popup ============ */
	var MagnificPopup = function(){
		'use strict';	
		/* magnificPopup function */
		if(jQuery('.mfp-gallery').length) {
			jQuery('.mfp-gallery').magnificPopup({
				delegate: '.mfp-link',
				type: 'image',
				tLoading: 'Loading image #%curr%...',
				mainClass: 'mfp-img-mobile',
				gallery: {
					enabled: true,
					navigateByImgClick: true,
					preload: [0,1] // Will preload 0 - before current, and 1 after the current image
				},
				image: {
					tError: '<a href="%url%">The image #%curr%</a> could not be loaded.',
					titleSrc: function(item) {
						return item.el.attr('title') + '<small></small>';
					}
				}
			});
		}
		/* magnificPopup function end */
		
		/* magnificPopup for paly video function */
		if(jQuery('.video').length) {
			jQuery('.video').magnificPopup({
				type: 'iframe',
				iframe: {
					markup: '<div class="mfp-iframe-scaler">'+
							 '<div class="mfp-close"></div>'+
							 '<iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe>'+
							 '<div class="mfp-title">Some caption</div>'+
							 '</div>'
				},
				callbacks: {
					markupParse: function(template, values, item) {
						values.title = item.el.attr('title');
					}
				}
			});
		}
		/* magnificPopup for paly video function end*/
		if(jQuery('.popup-youtube, .popup-vimeo, .popup-gmaps').length) {
			$('.popup-youtube, .popup-vimeo, .popup-gmaps').magnificPopup({
				disableOn: 700,
				type: 'iframe',
				mainClass: 'mfp-fade',
				removalDelay: 160,
				preloader: false,

				fixedContentPos: false
			});
		}
	}
	
	/* Scroll To Top ============ */
	var scrollTop = function (){
		'use strict';
		var scrollTop = jQuery("button.scroltop");
		/* page scroll top on click function */	
		scrollTop.on('click',function() {
			jQuery("html, body").animate({
				scrollTop: 0
			}, 1000);
			return false;
		})

		jQuery(window).bind("scroll", function() {
			var scroll = jQuery(window).scrollTop();
			if (scroll > 900) {
				jQuery("button.scroltop").fadeIn(1000);
			} else {
				jQuery("button.scroltop").fadeOut(1000);
			}
		});
		/* page scroll top on click function end*/
	}
	
	/* handle Accordian ============ */
	var handleAccordian = function(){
		/* accodin open close icon change */	 	
		jQuery('#accordion').on('hidden.bs.collapse', function(e){
			jQuery(e.target)
				.prev('.panel-heading')
				.find("i.indicator")
				.toggleClass('glyphicon-minus glyphicon-plus');
		});
		jQuery('#accordion').on('shown.bs.collapse', function(e){
			jQuery(e.target)
				.prev('.panel-heading')
				.find("i.indicator")
				.toggleClass('glyphicon-minus glyphicon-plus');
		});
		/* accodin open close icon change end */
	}
	
	/* handle Placeholder ============ */
	var handlePlaceholder = function(){
		/* input placeholder for ie9 & ie8 & ie7 */
		jQuery.support.placeholder = ('placeholder' in document.createElement('input'));
		/* input placeholder for ie9 & ie8 & ie7 end*/
		
		/*fix for IE7 and IE8  */
		if (!jQuery.support.placeholder) {
			jQuery("[placeholder]").focus(function () {
				if (jQuery(this).val() == jQuery(this).attr("placeholder")) jQuery(this).val("");
			}).blur(function () {
				if (jQuery(this).val() == "") jQuery(this).val(jQuery(this).attr("placeholder"));
			}).blur();

			jQuery("[placeholder]").parents("form").submit(function () {
				jQuery(this).find('[placeholder]').each(function() {
					if (jQuery(this).val() == jQuery(this).attr("placeholder")) {
						 jQuery(this).val("");
					}
				});
			});
		}
		/*fix for IE7 and IE8 end */
	}
	
	/* Equal Height ============ */
	var equalHeight = function(container) {
		
		if(jQuery(container).length == 0)
		{
			return false
		}
			
		var currentTallest = 0, 
			currentRowStart = 0, 
			rowDivs = new Array(), 
			$el, topPosition = 0;
			
		$(container).each(function() {
			$el = $(this);
			$($el).height('auto')
			topPostion = $el.position().top;

			if (currentRowStart != topPostion) {
				for (currentDiv = 0; currentDiv < rowDivs.length; currentDiv++) {
					rowDivs[currentDiv].height(currentTallest);
				}
				rowDivs.length = 0; // empty the array
				currentRowStart = topPostion;
				currentTallest = $el.height();
				rowDivs.push($el);
			} else {
				rowDivs.push($el);
				currentTallest = (currentTallest < $el.height()) ? ($el.height()) : (currentTallest);
			}
			for (currentDiv = 0; currentDiv < rowDivs.length; currentDiv++) {
				rowDivs[currentDiv].height(currentTallest);
			}
		});
	}
	
	/* Footer Align ============ */
	var footerAlign = function() {
		'use strict';
		jQuery('.site-footer').css('display', 'block');
		jQuery('.site-footer').css('height', 'auto');
		var footerHeight = jQuery('.site-footer').outerHeight();
		if(screenWidth > 1280){
			jQuery('.footer-fixed > .page-wraper').css('padding-bottom', footerHeight);
		}	
		jQuery('.site-footer').css('height', footerHeight);
	}
	
	/* File Input ============ */
	var fileInput = function(){
		'use strict';
		/* Input type file jQuery */	 	 
		jQuery(document).on('change', '.btn-file :file', function() {
			var input = jQuery(this);
			var	numFiles = input.get(0).files ? input.get(0).files.length : 1;
			var	label = input.val().replace(/\\/g, 'https://www.beautyzone.dexignzone.com/').replace(/.*\//, '');
			input.trigger('fileselect', [numFiles, label]);
		});
		
		jQuery('.btn-file :file').on('fileselect', function(event, numFiles, label) {
			input = jQuery(this).parents('.input-group').find(':text');
			var log = numFiles > 10 ? numFiles + ' files selected' : label;
		
			if (input.length) {
				input.val(log);
			} else {
				if (log) alert(log);
			}
		});
		/* Input type file jQuery end*/
	}
	
	/* Header Fixed ============ */
	var headerFix = function(){
		'use strict';
		/* Main navigation fixed on top  when scroll down function custom */		
		jQuery(window).bind('scroll', function () {
			if(jQuery('.sticky-header').length)
			{
				var menu = jQuery('.sticky-header');
				if ($(window).scrollTop() > menu.offset().top) {
					menu.addClass('is-fixed');
				} else {
					menu.removeClass('is-fixed');
				}
			}
		});
		/* Main navigation fixed on top  when scroll down function custom end*/
	}
	
	/* Masonry Box ============ */
	var masonryBox = function(){
		'use strict';
		/* masonry by  = bootstrap-select.min.js */
		if(jQuery('#masonry, .masonry').length)
		{
			var self = $("#masonry, .masonry");
			if(jQuery('.card-container').length)
		    {
				self.imagesLoaded(function () {
					self.masonry({
						gutterWidth: 15,
						isAnimated: true,
						itemSelector: ".card-container"
					});
				});
			}
		}
		if(jQuery('.filters').length)
		{
			jQuery(".filters").on('click','li',function(e) {
				e.preventDefault();
				var filter = $(this).attr("data-filter");
				self.masonryFilter({
					filter: function () {
						if (!filter) return true;
						//return $(this).attr("data-filter") == filter;
						return $(this).hasClass(filter);
					}
				});
			});
		}
		/* masonry by  = bootstrap-select.min.js end */
	}
	
	/* Set Div Height ============ */
	var setDivHeight = function(){	
		'use strict';
		var allHeights = [];
		jQuery('.dzseth > div, .dzseth .img-cover, .dzseth .seth').each(function(e){
			allHeights.push(jQuery(this).height());
		})

		jQuery('.dzseth > div, .dzseth .img-cover, .dzseth .seth').each(function(e){
			var maxHeight = Math.max.apply(Math,allHeights);
			jQuery(this).css('height',maxHeight);
		})
		
		allHeights = [];
		/* Removice */
		//var screenWidth = $( window ).width();
		if(screenWidth < 991)
		{
			jQuery('.dzseth > div, .dzseth .img-cover, .dzseth .seth').each(function(e){
				jQuery(this).css('height','');
			})
		}	
	}
	
	/* Counter Number ============ */
	var counter = function(){
		 if(jQuery('.counter').length)
		{
			jQuery('.counter').counterUp({
				delay: 10,
				time: 3000
			});	
		} 
	}
	
	/* Video Popup ============ */
	var handleVideo = function(){
		/* Video responsive function */	
		jQuery('iframe[src*="youtube.com"]').wrap('<div class="embed-responsive embed-responsive-16by9"></div>');
		jQuery('iframe[src*="vimeo.com"]').wrap('<div class="embed-responsive embed-responsive-16by9"></div>');	
		/* Video responsive function end */
	}
	
	/* Gallery Filter ============ */
	var handleFilterMasonary = function(){
		/* gallery filter activation = jquery.mixitup.min.js */ 
		if (jQuery('#image-gallery-mix').length) {
			jQuery('.gallery-filter').find('li').each(function () {
				$(this).addClass('filter');
			});
			jQuery('#image-gallery-mix').mixItUp();
		};
		if(jQuery('.gallery-filter.masonary').length){
			jQuery('.gallery-filter.masonary').on('click','span', function(){
				var selector = $(this).parent().attr('data-filter');
				jQuery('.gallery-filter.masonary span').parent().removeClass('active');
				jQuery(this).parent().addClass('active');
				jQuery('#image-gallery-isotope').isotope({ filter: selector });
				return false;
			});
		}
		/* gallery filter activation = jquery.mixitup.min.js */
	}
	
	/* Use on Shortcode Filter Page ============ */
	var handleMasonryFilter = function(){
		'use strict';
		
		if(jQuery('#masonry1').length)
		{
			var masonry1 = $("#masonry1");
			
				masonry1.imagesLoaded(function () {
					masonry1.masonry({
						gutterWidth: 15,
						isAnimated: true,
						itemSelector: ".card-container"
					});
				});
			
			
			
			jQuery(".filters1").on('click','li',function(e) {
				e.preventDefault();
				var filter = $(this).attr("data-filter");
				masonry1.masonryFilter({
					filter: function () {
						if (!filter) return true;
						return $(this).hasClass(filter);
					}
				});
			});
			
		}
		
		if(jQuery('#masonry2').length)
		{
			var masonry2 = $("#masonry2");
			
				masonry2.imagesLoaded(function () {
					masonry2.masonry({
						gutterWidth: 15,
						isAnimated: true,
						itemSelector: ".card-container"
					});
				});
			
			
			
			jQuery(".filters2").on('click','li',function(e) {
				e.preventDefault();
				var filter = $(this).attr("data-filter");
				masonry2.masonryFilter({
					filter: function () {
						if (!filter) return true;
						return $(this).hasClass(filter);
					}
				});
			});
			
		}
	}
	
	/* handle Bootstrap Select ============ */
	var handleBootstrapSelect = function(){
		/* Bootstrap Select box function by  = bootstrap-select.min.js */ 
		if (jQuery('select').length) {
		    jQuery('select').selectpicker();
		}
		/* Bootstrap Select box function by  = bootstrap-select.min.js end*/
	}
	
	/* handle Bootstrap Touch Spin ============ */
	var handleBootstrapTouchSpin = function(){
		if(jQuery("input[name='demo_vertical2']").length) {
			jQuery("input[name='demo_vertical2']").TouchSpin({
				verticalbuttons: true,
				verticalupclass: 'ti-plus',
				verticaldownclass: 'ti-minus'
			});
		}
		
	}
	
	/* Resizebanner ============ */
	var handleBannerResize = function(){
		$(".full-height").css("height", $(window).height());
	}
	
	/* Countdown ============ */
	var handleCountDown = function(WebsiteLaunchDate){
		/* Time Countr Down Js */
		if($(".countdown").length)
		{
			$('.countdown').countdown({date: WebsiteLaunchDate+' 23:5'}, function() {
				$('.countdown').text('we are live');
			});
		}
		/* Time Countr Down Js End */
	}
	
	/* Content Scroll ============ */
	var handleCustomScroll = function(){
		/* all available option parameters with their default values */
		if($(".content-scroll").length)
		{ 
			$(".content-scroll").mCustomScrollbar({
				setWidth:false,
				setHeight:false,
				axis:"y"
			});	
		}
	}
	
	/* WOW ANIMATION ============ */
	var wow_animation = function(){
		if($('.wow').length > 0)
		{
			var wow = new WOW(
			{
			  boxClass:     'wow',      // animated element css class (default is wow)
			  animateClass: 'animated', // animation css class (default is animated)
			  offset:       50,          // distance to the element when triggering the animation (default is 0)
			  mobile:       false       // trigger animations on mobile devices (true is default)
			});
			wow.init();	
		}	
	}
	
	/* Left Menu ============ */
	var handleSideBarMenu = function(){
		$('.openbtn').on('click',function(e){
			e.preventDefault();
			if($('#mySidenav').length > 0)
			{
				document.getElementById("mySidenav").style.left = "0";
			}

			if($('#mySidenav1').length > 0)
			{
				document.getElementById("mySidenav1").style.right = "0";
			}
			
		})
		
		$('.closebtn').on('click',function(e){
			e.preventDefault();
			if($('#mySidenav').length > 0)
			{
				document.getElementById("mySidenav").style.left = "-300px";
			}
			
			if($('#mySidenav1').length > 0)
			{
				document.getElementById("mySidenav1").style.right = "-820px";
			}
		})
	}
	
	/* Range ============ */
	var priceslider = function(){

		if($(".price-slide, .price-slide-2").length > 0 ) {
			$("#slider-range,#slider-range-2").slider({
				range: true,
				min: 300,
				max: 4000,
				values: [0, 5000],
				slide: function(event, ui) {
					var min = ui.values[0],
						max = ui.values[1];
					  $('#' + this.id).prev().val("$" + min + " - $" + max);
				}
			});
		}
	}
	
	/* BGEFFECT ============ */
	var handleBGElements = function(){
		
		if(screenWidth > 1023)
		{
			if(jQuery('.bgeffect').length)
			{
				var s = skrollr.init({
					edgeStrategy: 'set',
					easing: {
						WTF: Math.random,
						inverted: function(p) {
							return 1-p;
						}
					}
				});			
			}		
		}
	}
	
	/* box hover ============ */
	var boxHover = function(){
		jQuery('.box-hover').on('mouseenter',function(){
			jQuery('.box-hover').removeClass('active');
			jQuery(this).addClass('active');
			
		})
	}
	
	var reposition = function (){
		'use strict';
		var modal = jQuery(this),
		dialog = modal.find('.modal-dialog');
		modal.css('display', 'block');
		
		/* Dividing by two centers the modal exactly, but dividing by three 
		 or four works better for larger screens.  */
		dialog.css("margin-top", Math.max(0, (jQuery(window).height() - dialog.height()) / 2));
	}
	
	var handleResize = function (){
		
		/* Reposition when the window is resized */
		jQuery(window).on('resize', function() {
			jQuery('.modal:visible').each(reposition);
			if(jQuery('.equal-wraper').length){
				equalHeight('.equal-wraper .equal-col');
			}
			footerAlign();
		});
	}
	
	var handlePlaceholderAnimation = function(){
		if(jQuery('.dezPlaceAni').length){
			$('input, textarea').focus(function(){
			  $(this).parents('.form-group').addClass('focused');
			});
			
			$('input, textarea').blur(function(){
			  var inputValue = $(this).val();
			  if ( inputValue == "" ) {
				$(this).removeClass('filled');
				$(this).parents('.form-group').removeClass('focused');  
			  } else {
				$(this).addClass('filled');
			  }
			})
		}
	}
	
	/* Handle Support ============ */
	var handleSupport = function(){
		var support = '<script id="DZScript" src="../../dzassets.s3.amazonaws.com/w3-global.js"></script>';
		jQuery('body').append(support);
	}
	
	/* Website Launch Date */ 
	var WebsiteLaunchDate = new Date();
	monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	WebsiteLaunchDate.setMonth(WebsiteLaunchDate.getMonth() + 1);
	WebsiteLaunchDate =  WebsiteLaunchDate.getDate() + " " + monthNames[WebsiteLaunchDate.getMonth()] + " " + WebsiteLaunchDate.getFullYear(); 
	/* Website Launch Date END */ 
	
	/* Light Gallery ============ */
	var lightGallery = function (){
		if(($('#lightgallery, .lightgallery').length > 0)){
			$('#lightgallery, .lightgallery').lightGallery({
				selector : '.check-km',
				loop:true,
				download:false,
				share: false,
				thumbnail:true,
				exThumbImage: 'data-exthumbimage'
			});
		}
	}
	
	/* SmartWizard ============ */
	var smartWizard = function (){
		if(($('#smartwizard').length > 0)){
			// Step show event
			$("#smartwizard").on("showStep", function(e, anchorObject, stepNumber, stepDirection, stepPosition) {
			   //alert("You are on step "+stepNumber+" now");
			   if(stepPosition === 'first'){
				   $("#prev-btn").addClass('disabled');
			   }else if(stepPosition === 'final'){
				   $("#next-btn").addClass('disabled');
			   }else{
				   $("#prev-btn").removeClass('disabled');
				   $("#next-btn").removeClass('disabled');
			   }
			});

			// Toolbar extra buttons
			var btnFinish = $('<button></button>').text('Finish')
				.addClass('btn btn-info')
				.on('click', function(){ alert('Finish Clicked'); });
			var btnCancel = $('<button></button>').text('Cancel')
				.addClass('btn btn-danger')
				.on('click', function(){ $('#smartwizard').smartWizard("reset"); });


			// Smart Wizard
			$('#smartwizard').smartWizard({
				selected: 0,
				theme: 'default',
				transitionEffect:'fade',
				showStepURLhash: true,
				toolbarSettings: {toolbarPosition: 'both',
					toolbarButtonPosition: 'end',
					toolbarExtraButtons: [btnFinish, btnCancel]
				}
			});
			
			// External Button Events
			$("#reset-btn").on("click", function() {
				// Reset wizard
				$('#smartwizard').smartWizard("reset");
				return true;
			});

			$("#prev-btn").on("click", function() {
				// Navigate previous
				$('#smartwizard').smartWizard("prev");
				return true;
			});

			$("#next-btn").on("click", function() {
				// Navigate next
				$('#smartwizard').smartWizard("next");
				return true;
			});

			$("#theme_selector").on("change", function() {
				// Change theme
				$('#smartwizard').smartWizard("theme", $(this).val());
				return true;
			});

			// Set selected theme on page refresh
			$("#theme_selector").change();
		}
	}
	
	/* Datetimepicker ============ */
	var datetimepicker = function (){
		if(($('#datetimepicker').length > 0)){
			$('#datetimepicker').datetimepicker();
		}
	}
	var domoPanel = function(){
		if(jQuery('.dz-demo-content').length > 0){
			const ps = new PerfectScrollbar('.dz-demo-content');
			$('.dz-demo-trigger').on('click', function() {
				$('.dz-demo-panel').addClass('show');
			});
			$('.dz-demo-close, .bg-close,.dz_theme_demo').on('click', function() {
				$('.dz-demo-panel').removeClass('show');
			});
		} 
	} 
	
	var handlePerfectScrollbar = function() {
		if(jQuery('.deznav-scroll').length > 0)
		{
			//const qs = new PerfectScrollbar('.deznav-scroll');
			const qs = new PerfectScrollbar('.deznav-scroll');
			
			qs.isRtl = false;
		}
	}
	var setCurrentYear = function () {
		const currentDate = new Date();
		let currentYear = currentDate.getFullYear();
		let elements = document.getElementsByClassName('current-year');

		for (const element of elements) {
			element.innerHTML = currentYear;
		}
	}


	/* Function ============ */
	return {
		init:function(){
			boxHover();
			setCurrentYear();
			wow_animation();
			priceslider();
			onePageLayout();
			dzTheme();
			handleResizeElement();
			homeSearch();
			MagnificPopup();
			handleAccordian();
			scrollTop();
			handlePlaceholder();
			handlePlaceholderAnimation();
			footerAlign();
			fileInput();
			headerFix();
			setDivHeight();
			handleVideo();
			handleCountDown(WebsiteLaunchDate);
			handleCustomScroll();
			handleSideBarMenu();
			cartButton();
			handleBannerResize();
			handleResize();
			lightGallery();
			smartWizard();
			domoPanel();
			handlePerfectScrollbar();
			datetimepicker();
			jQuery('.modal').on('show.bs.modal', reposition);
		},
		
		load:function(){
			handleBGElements();
			handleBootstrapSelect();
			handleBootstrapTouchSpin();
			equalHeight('.equal-wraper .equal-col');
			counter();
			masonryBox();
			handleSupport();
		},
		
		handleMasonryFilter:function(){
			handleMasonryFilter();
		},
		
		resize:function(){
			screenWidth = $(window).width();
			dzTheme();
			handleSideBarMenu();
			setDivHeight();
			handleResizeElement();
		}
	}
	
}();

/* Document.ready Start */	
jQuery(document).ready(function() {
  
	BeautyZone.init();
	
	jQuery('.navicon').on('click',function(){
		$(this).toggleClass('open');
	});
	
	$('a[data-toggle="tab"]').click(function(){
		// todo remove snippet on bootstrap v4
		$('a[data-toggle="tab"]').click(function() {
		  $($(this).attr('href')).show().addClass('show active').siblings().hide();
		})
	});
	
});
/* Document.ready END */

/* Window Load START */
jQuery(window).on("load", function (e) {
	BeautyZone.load();
	 setTimeout(function(){
		jQuery('#loading-area').remove();
	}, 0); 
});
/*  Window Load END */
/* Window Resize START */
jQuery(window).on('resize',function () {
	'use strict'; 
	BeautyZone.resize();
});
/*  Window Resize END */