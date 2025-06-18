<%-- 
    Document   : blog_list
    Created on : Jun 18, 2025, 2:22:37 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- meta tags and other links -->
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/blog.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:31 GMT -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Wowdash - Bootstrap 5 Admin Dashboard HTML Template</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />


        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Blog</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Blog</li>
                </ul>
            </div>

            <div class="row gy-4">
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog1.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                    <a href="blog-details-2.html" class="px-20 py-6 bg-neutral-100 rounded-pill bg-hover-neutral-300 text-neutral-600 fw-medium">Workshop</a>
                                    <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                        <i class="ri-calendar-2-line"></i>
                                        Jan 17, 2024
                                    </div>
                                </div>
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Discover Endless Possibilities in Real Estate Live Your Best Life in a</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <a href="blog-details.html" class="d-flex align-items-center gap-8 fw-semibold text-neutral-900 text-hover-primary-600 transition-2">
                                    Read More
                                    <i class="ri-arrow-right-double-line text-xl d-flex line-height-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog2.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                    <a href="blog-details-2.html" class="px-20 py-6 bg-neutral-100 rounded-pill bg-hover-neutral-300 text-neutral-600 fw-medium">Hiring</a>
                                    <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                        <i class="ri-calendar-2-line"></i>
                                        Jan 17, 2024
                                    </div>
                                </div>
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Turn Your Real Estate Dreams Into Reality Embrace the Real Estate</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <a href="blog-details.html" class="d-flex align-items-center gap-8 fw-semibold text-neutral-900 text-hover-primary-600 transition-2">
                                    Read More
                                    <i class="ri-arrow-right-double-line text-xl d-flex line-height-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog3.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                    <a href="blog-details-2.html" class="px-20 py-6 bg-neutral-100 rounded-pill bg-hover-neutral-300 text-neutral-600 fw-medium">Workshop</a>
                                    <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                        <i class="ri-calendar-2-line"></i>
                                        Jan 17, 2024
                                    </div>
                                </div>
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Your satisfaction is our top the best priority</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <a href="blog-details.html" class="d-flex align-items-center gap-8 fw-semibold text-neutral-900 text-hover-primary-600 transition-2">
                                    Read More
                                    <i class="ri-arrow-right-double-line text-xl d-flex line-height-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog4.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                    <a href="blog-details-2.html" class="px-20 py-6 bg-neutral-100 rounded-pill bg-hover-neutral-300 text-neutral-600 fw-medium">Workshop</a>
                                    <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                        <i class="ri-calendar-2-line"></i>
                                        Jan 17, 2024
                                    </div>
                                </div>
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Your journey to home ownership starts here</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <a href="blog-details.html" class="d-flex align-items-center gap-8 fw-semibold text-neutral-900 text-hover-primary-600 transition-2">
                                    Read More
                                    <i class="ri-arrow-right-double-line text-xl d-flex line-height-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Style Two -->
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-0">
                            <a href="blog-details.html" class="w-100 max-h-266-px radius-0 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog5.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="p-20">
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">How to hire a right business executive for your company</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500 mb-0">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">John Doe</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-0">
                            <a href="blog-details.html" class="w-100 max-h-266-px radius-0 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog6.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="p-20">
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">The Gig Economy: Adapting to a Flexible Workforce</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500 mb-0">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list2.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">Robiul Hasan</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-0">
                            <a href="blog-details.html" class="w-100 max-h-266-px radius-0 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog7.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="p-20">
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">The Future of Remote Work: Strategies for Success</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500 mb-0">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list3.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">John Doe</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-0">
                            <a href="blog-details.html" class="w-100 max-h-266-px radius-0 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog6.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="p-20">
                                <h6 class="mb-16">
                                    <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Lorem ipsum dolor sit amet consectetur adipisicing.</a>
                                </h6>
                                <p class="text-line-3 text-neutral-500 mb-0">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list5.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">John Doe</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Style Three -->
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <h6 class="mb-16">
                                <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Discover Endless Possibilities in Real Estate Live Your Best Life in a</a>
                            </h6>
                            <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-chat-3-line"></i>
                                    10 Comments
                                </div>
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-calendar-2-line"></i>
                                    Jan 17, 2024
                                </div>
                            </div>
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog1.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">John Doe</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <h6 class="mb-16">
                                <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Turn Your Real Estate Dreams Into Reality Embrace the Real Estate</a>
                            </h6>
                            <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-chat-3-line"></i>
                                    10 Comments
                                </div>
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-calendar-2-line"></i>
                                    Jan 17, 2024
                                </div>
                            </div>
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog2.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">John Doe</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <h6 class="mb-16">
                                <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Your satisfaction is our top the best priority</a>
                            </h6>
                            <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-chat-3-line"></i>
                                    10 Comments
                                </div>
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-calendar-2-line"></i>
                                    Jan 17, 2024
                                </div>
                            </div>
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog3.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">John Doe</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <h6 class="mb-16">
                                <a href="blog-details.html" class="text-line-2 text-hover-primary-600 text-xl transition-2">Your journey to home ownership starts here</a>
                            </h6>
                            <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-chat-3-line"></i>
                                    10 Comments
                                </div>
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-calendar-2-line"></i>
                                    Jan 17, 2024
                                </div>
                            </div>
                            <a href="blog-details.html" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/blog/blog4.png" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <p class="text-line-3 text-neutral-500">Lorem ipsum dolor sit amet consectetur adipisicing elit. Omnis dolores explicabo corrupti, fuga necessitatibus fugiat adipisci quidem eveniet enim minus.</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">John Doe</h6>
                                            <span class="text-xs text-neutral-500">1 day ago</span>
                                        </div>
                                    </div>
                                    <a href="blog-details.html" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                        Read More
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

    </body>

    <!-- Mirrored from wowdash.wowtheme7.com/demo/blog.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:34 GMT -->
</html>
