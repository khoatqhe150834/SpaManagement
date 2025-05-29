<%-- Document : header Created on : May 25, 2025, 4:22:29 PM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
    contentType="text/html" pageEncoding="UTF-8"%>
   
    
    <header class="site-header header header-transparent mo-left spa-header">
		<!-- main header -->
        <div class="sticky-header main-bar-wraper navbar-expand-lg">
            <div class="main-bar clearfix ">
                <div class="container clearfix">
                    <!-- website logo -->
                    <div class="logo-header mostion">
						<a href="index.html" class="dez-page"><img src="${pageContext.request.contextPath}/assets/home/images/logo-4.png" alt=""></a>
					</div>
                    <!-- nav toggle button -->
                    <button class="navbar-toggler collapsed navicon justify-content-end" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
						<span></span>
						<span></span>
						<span></span>
					</button>
					
					 <!-- extra nav -->
                    <div class="extra-nav">
                        <div class="extra-cell">
                            <a href="booking.html" class="site-button radius-no">Book Now</a>
                        </div>
                    </div>
					
                    <!-- main nav -->
                    <div class="header-nav navbar-collapse collapse justify-content-end" id="navbarNavDropdown">
                        <ul class="nav navbar-nav">	
							<li class="active"><a href="javascript:void(0);">Home <i class="fa fa-chevron-down"></i></a>
								<ul class="sub-menu">
									<li><a href="index.html" class="dez-page">Home 1</a></li>
									<li><a href="index-6.html" class="dez-page">Home 1 One Page</a></li>
									<li><a href="index-2.html" class="dez-page">Home 2</a></li>
									<li><a href="index-7.html" class="dez-page">Home 2 One Page</a></li>
									<li><a href="index-3.html" class="dez-page">Home 3</a></li>
									<li><a href="index-8.html" class="dez-page">Home 3 One Page</a></li>
									<li><a href="index-4.html" class="dez-page">Home 4 </a></li>
									<li><a href="index-9.html" class="dez-page">Home 4 One Page</a></li>
									<li><a href="index-5.html" class="dez-page">Home 5</a></li>
									<li><a href="index-10.html" class="dez-page">Home 5 One Page</a></li>
									<li><a href="index-11.html" class="dez-page">Home 6 </a></li>
									<li><a href="index-12.html" class="dez-page">Home 6 One Page </a></li>
								</ul>	
							</li>
							<li><a href="javascript:void(0);">Pages <i class="fa fa-chevron-down"></i></a>
								<ul class="sub-menu">
									<li><a href="javascript:void(0);" class="dez-page">Header <i class="fa fa-angle-right"></i></a>
										<ul class="sub-menu">
											<li><a href="header-1.html" class="dez-page">Header 1</a></li>
											<li><a href="header-2.html" class="dez-page">Header 2</a></li>
											<li><a href="header-3.html" class="dez-page">Header 3</a></li>
											<li><a href="header-4.html" class="dez-page">Header 4</a></li>
											<li><a href="header-5.html" class="dez-page">Header 5</a></li>
										</ul>
									</li>
									<li><a href="javascript:void(0);" class="dez-page">Footer <i class="fa fa-angle-right"></i></a>
										<ul class="sub-menu">
											<li><a href="footer-1.html" class="dez-page">Footer 1</a></li>
											<li><a href="footer-2.html" class="dez-page">Footer 2</a></li>
											<li><a href="footer-3.html" class="dez-page">Footer 3</a></li>
											<li><a href="footer-4.html" class="dez-page">Footer 4</a></li>
											<li><a href="footer-5.html" class="dez-page">Footer 5</a></li>
										</ul>
									</li>
									<li><a href="about-us.html" class="dez-page">About Us</a></li>
									<li><a href="booking.html" class="dez-page">Booking</a></li>
									<li><a href="team.html" class="dez-page">Our Team</a></li>
									<li><a href="under-maintenance.html" class="dez-page">Under Maintenance</a></li>
									<li><a href="magnific-popup.html" class="dez-page">Magnific Gallery</a></li>
									<li><a href="light-box.html" class="dez-page">Light Gallery </a></li>
									<li><a href="coming-soon.html" class="dez-page">Coming Soon</a></li>
									<li><a href="error-404.html" class="dez-page">Error 404</a></li>
									<li><a href="login.html" class="dez-page">Login</a></li>
									<li><a href="register.html" class="dez-page">Register</a></li>
									<li><a href="contact.html" class="dez-page">Contact Us</a></li>
								</ul>
							</li>
							<li><a href="javascript:void(0);">Our Service <i class="fa fa-chevron-down"></i></a>
								<ul class="sub-menu">
									<li><a href="service.html" class="dez-page">Services</a></li>
									<li><a href="services-details.html" class="dez-page">Services Details</a></li>
								</ul>
							</li>
							<li class="sub-menu-down"><a href="javascript:void(0);">Blog <i class="fa fa-chevron-down"></i></a>
								<ul class="sub-menu">
									<li><a href="javascript:void();">Page Layout <i class="fa fa-angle-right"></i></a>
										<ul class="sub-menu">
											<li><a href="javascript:void();">No Sidebar <i class="fa fa-angle-right"></i></a>
												<ul class="sub-menu">
													<li><a href="blog-list.html">Blog List</a></li>
													<li><a href="blog-grid.html">Blog Grid</a></li>
													<li><a href="blog-grid-wide.html">Blog Grid Wide</a></li>
												</ul>	
											</li>
											<li><a href="javascript:void();">2 Columns <i class="fa fa-angle-right"></i></a>
												<ul class="sub-menu">
													<li><a href="blog-list-right-sidebar.html">Blog List</a></li>
													<li><a href="blog-grid-right-sidebar.html">Blog Grid</a></li>
												</ul>	
											</li>
											<li><a href="javascript:void();">3 Columns <i class="fa fa-angle-right"></i></a>
												<ul class="sub-menu">
													<li><a href="blog-list-both-sidebar.html">Blog List</a></li>
													<li><a href="blog-grid-both-sidebar.html">Blog Grid</a></li>
												</ul>	
											</li>
										</ul>
									</li>
									<li><a href="javascript:void();">Blog Sidebar <i class="fa fa-angle-right"></i></a>
										<ul class="sub-menu">
											<li><a href="javascript:void();">No Sidebar <i class="fa fa-angle-right"></i></a>
												<ul class="sub-menu">
													<li><a href="blog-list.html">Blog List</a></li>
													<li><a href="blog-grid.html">Blog Grid</a></li>
												</ul>	
											</li>
											<li><a href="javascript:void();">Left Sidebar <i class="fa fa-angle-right"></i></a>
												<ul class="sub-menu">
													<li><a href="blog-list-left-sidebar.html">Blog List</a></li>
													<li><a href="blog-grid-left-sidebar.html">Blog Grid</a></li>
												</ul>	
											</li>
											<li><a href="javascript:void();">Right Sidebar <i class="fa fa-angle-right"></i></a>
												<ul class="sub-menu">
													<li><a href="blog-list-right-sidebar.html">Blog List</a></li>
													<li><a href="blog-grid-right-sidebar.html">Blog Grid</a></li>
												</ul>	
											</li>
											<li><a href="javascript:void();">2 Sidebar <i class="fa fa-angle-right"></i></a>
												<ul class="sub-menu">
													<li><a href="blog-list-both-sidebar.html">Blog List</a></li>
													<li><a href="blog-grid-both-sidebar.html">Blog Grid</a></li>
												</ul>	
											</li>
										</ul>
									</li>
								</ul>	
							</li>
							<li class="has-mega-menu">
								<a href="javascript:void(0);">Post Layout<i class="fa fa-chevron-down"></i></a>
								<ul class="mega-menu">
									<li> 
										<a href="javascript:;">Side Bar</a>
										<ul>
											<li><a href="post-left-sidebar.html">Post Left Sidebar</a></li>
											<li><a href="post-right-sidebar.html">Post Right Sidebar</a></li>
											<li><a href="post-both-sidebar.html">Post Both Sidebar<span class="new-page">New</span></a></li>
											<li><a href="post-no-sidebar.html">Post No Sidebar</a></li>
										</ul>
									</li>
									<li> 
										<a href="javascript:;">Post Types</a>
										<ul>
											<li><a href="post-text.html">Text Post<span class="new-page">New</span></a></li>
											<li><a href="post-image.html">Image Post<span class="new-page">New</span></a></li>
											<li><a href="post-video.html">Post Video<span class="new-page">New</span></a></li>
											<li><a href="post-link.html">Post Link<span class="new-page">New</span></a></li>
											<li><a href="post-audio.html">Post Audio<span class="new-page">New</span></a></li>
											<li><a href="post-quote.html">Post Quote<span class="new-page">New</span></a></li>
											<li><a href="post-tutorial.html">Tutorial Post<span class="new-page">New</span></a></li>
											<li><a href="post-cateloge.html">Cateloge Post<span class="new-page">New</span></a></li>
										</ul>
									</li>
									<li> 
										<a href="javascript:;">Multiple Media</a>
										<ul>
											<li><a href="post-banner.html">Banner<span class="new-page">New</span></a></li>
											<li><a href="post-slide-show.html">Post Slide Show<span class="new-page">New</span></a></li>
											<li><a href="post-gallery.html">Gallery<span class="new-page">New</span></a></li>
											<li><a href="post-status-slider.html">Status Slider<span class="new-page">New</span></a></li>
										</ul>
									</li>
									<li> 
										<a href="javascript:;">Post Layout Type</a>
										<ul>
											<li><a href="post-standard.html" class="dez-page">Post Standard<span class="new-page">New</span></a></li>
											<li><a href="post-side.html">Side Post<span class="new-page">New</span></a></li>
											<li><a href="post-corner.html">Corner Post<span class="new-page">New</span></a></li>
										</ul>
									</li>
								</ul>
							</li>
							
							<li><a href="javascript:void(0);">Our Portfolio <i class="fa fa-chevron-down"></i></a>
								<ul class="sub-menu">
									<li><a href="portfolio-grid-2.html" class="dez-page">Portfolio Grid 2 </a></li>
									<li><a href="portfolio-grid-3.html" class="dez-page">Portfolio Grid 3 </a></li>
									<li><a href="portfolio-grid-4.html" class="dez-page">Portfolio Grid 4 </a></li>
								</ul>
							</li>
							<li><a href="javascript:void(0);">Shop <i class="fa fa-chevron-down"></i></a>
								<ul class="sub-menu left">
									<li><a href="shop-columns.html" class="dez-page">Shop Columns</a></li>
									<li><a href="shop-columns-sidebar.html" class="dez-page">Shop Columns Sidebar</a></li>
									<li><a href="shop-product-details.html" class="dez-page">Product Details</a></li>
									<li><a href="shop-cart.html" class="dez-page">Cart</a></li>
									<li><a href="shop-checkout.html" class="dez-page">Checkout</a></li>
									<li><a href="shop-wishlist.html" class="dez-page">Wishlist</a></li>
									<li><a href="shop-login.html" class="dez-page">Shop Login</a></li>
									<li><a href="shop-register.html" class="dez-page">Shop Register</a></li>
								</ul>
							</li>
						</ul>		
                    </div>
                </div>
            </div>
        </div>
        <!-- main header END -->
    </header>