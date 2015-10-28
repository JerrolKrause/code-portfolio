<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
    Document   : mobile.xsl
    Author     : Jerrol  
    Description: 
        Master XSL template for the mobile experience. Based on HTML5 boilerplate mobile.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xalan="http://xml.apache.org/xalan" xmlns:my-ext="java" extension-element-prefixes="my-ext" xmlns:Math="http://www.math.org/">
    <xsl:output method="html"/>

    
    <!-- Include page specfic templates-->
    <xsl:include href="mobile/mobile-phone-grid.xsl"/>
    <xsl:include href="mobile/mobile-phone-detail.xsl"/>
    <xsl:include href="mobile/mobile-plans.xsl"/>
    <xsl:include href="mobile/mobile-deals.xsl"/>
    <xsl:include href="mobile/mobile-faq.xsl"/>
    <xsl:include href="mobile/mobile-stores.xsl"/>
    
    
    <!-- Main mobile template-->
    <xsl:template name="mobile">
     
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <xsl:comment><![CDATA[[if IEMobile 7 ]>    <html class="no-js iem7"> <![endif]]]></xsl:comment>
        <xsl:comment><![CDATA[[[if (gt IEMobile 7)|!(IEMobile)]]]></xsl:comment>
        <html lang="en" class="no-js">
            <xsl:comment><![CDATA[<![endif]]]></xsl:comment>
            
            <head>
                <meta charset="utf-8"/>
                <title><xsl:call-template name="template-page-title"/></title>
                <meta name="description" content=""/>
                <meta name="HandheldFriendly" content="True"/>
                <meta name="MobileOptimized" content="320"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <meta http-equiv="cleartype" content="on"/>

                <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/m/img/touch/apple-touch-icon-144x144-precomposed.png"/>
                <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/m/img/touch/apple-touch-icon-114x114-precomposed.png"/>
                <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/m/img/touch/apple-touch-icon-72x72-precomposed.png"/>
                <link rel="apple-touch-icon-precomposed" href="/m/img/touch/apple-touch-icon-57x57-precomposed.png"/>
                <link rel="shortcut icon" href="/m/img/touch/apple-touch-icon.png"/>

                <!-- Tile icon for Win8 (144x144 + tile color) -->
                <meta name="msapplication-TileImage" content="/m/img/touch/apple-touch-icon-144x144-precomposed.png"/>
                <meta name="msapplication-TileColor" content="#222222"/>

                <link rel="stylesheet" href="/m/css/global.min.css"/>
                
                 <!-- Load page specific stylesheets -->
                <xsl:for-each select="/page/header/stylesheets/file" >
                    <xsl:if test="link != ''">
                        <link rel="stylesheet"><xsl:attribute name="href" ><xsl:value-of select="link"/>?c=<xsl:value-of select="$cache"/></xsl:attribute></link>
                    </xsl:if>
                </xsl:for-each>
                
                <script src="/m/js/vendor/modernizr-2.6.2.min.js"></script>
            </head>
            <body>

                <div id="header" class="content">
                    <div id="subnav">
                        <ul class="nav">
                            <li><a href="http://mobile.boostmobile.com/mt/coverage.sprint.com/mycoverage.jsp?id=BO543STC"><img alt="Coverage" src="/m/img/icon_coverage.png"/></a></li>
                            <li><a href="http://mobile.boostmobile.com/mt/www.boostmobile.com/stores/"><img alt="Find a store" src="/m/img/icon_locator_pin.png"/></a></li>
                            <li><a href="https://mobile.boostmobile.com/mt/checkout.boostmobile.com/bpdirect/boost/AddItem.do?action=view"><img alt="Cart And Checkout" src="/m/img/icon_cart_empty.png"/></a></li>
                        </ul>
                    </div>
                    
                    <div id="logo">
                        <a href="http://mobile.boostmobile.com/mt/www.boostmobile.com">
                            <img alt="BoostMobile Logo" src="/m/img/boostMobile_logo.png"/>
                        </a>
                    </div>
                    <div class="clearfix"></div>
                    
                    <div id="nav-main">
                        <ul class="nav">
                            <li><a href="https://mobile.boostmobile.com/mt/apps.boostmobile.com/boostApp/account/ECareLanding.jsp">My Account</a></li>
                            <li><a href="http://mobile.boostmobile.com/mt/www.boostmobile.com/shop/phones/">Phones</a></li>
                            <li class="last"><a href="http://mobile.boostmobile.com/mt/www.boostmobile.com/shop/plans/databoost/?un_jtt_v_hub=yes">Plans</a></li>
                        </ul>
                        <div class="clearfix"></div>
                    </div>
                </div>
                
                
                <div id="main">
                    <!-- Use page specific content if specified -->
                    <xsl:choose>
                        <!-- Phone Grid -->
                        <xsl:when test="page/templates/mobile = 'mobile-phone-grid'">
                            <xsl:call-template name="mobile-phone-grid"/>
                        </xsl:when>
                        <!-- Phone Detail -->
                        <xsl:when test="page/templates/mobile = 'mobile-phone-detail'">
                            <xsl:call-template name="mobile-phone-detail"/>
                        </xsl:when>
                        <!-- Plans -->
                        <xsl:when test="page/templates/mobile = 'mobile-plans'">
                            <xsl:call-template name="mobile-plans"/>
                        </xsl:when>
                        <!-- Deals -->
                        <xsl:when test="page/templates/mobile = 'mobile-deals'">
                            <xsl:call-template name="mobile-deals"/>
                        </xsl:when>
                        <xsl:when test="page/templates/mobile = 'mobile-faq'">
                            <xsl:call-template name="mobile-faq"/>
                        </xsl:when>
                         <xsl:when test="page/templates/mobile = 'mobile-stores'">
                            <xsl:call-template name="mobile-stores"/>
                        </xsl:when>
                        <!-- No template specified, use default output -->
                        <xsl:otherwise>
                            <xsl:value-of select="/page/content/main" disable-output-escaping="yes"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                
                
                <div id="footer" class="content">
                    <div id="social">
                        <p class="callout">Stay Connected</p>
                        <ul class="nav">
                            <li><a target="_blank" href="http://mobile.boostmobile.com/mt/stop_mobi?url=http%3A%2F%2Fwww.facebook.com%2Fboostmobile&amp;time=10m"><img src="/m/img/social_icon_fb.png" alt="facebookIcon"/></a></li>
                            <li><a target="_blank" href="http://twitter.com/boostmobile"><img src="/m/img/social_icon_twitter.png" alt="twitterIcon"/></a></li>
                            <li><a target="_blank" href="http://mobile.boostmobile.com/mt/stop_mobi?url=http%3A%2F%2Fwww.youtube.com%2Fuser%2Fboostmobile&amp;time=10m"><img src="/m/img/social_icon_youtube.png" alt="ytIcon"/></a></li>
                        </ul>
                        <div class="clearfix"></div>
                    </div>
                    
                    <div id="legal">
                        <p><a href="http://mobile.boostmobile.com/mt/www.boostmobile.com/support/services-policies/privacy-policy/">Privacy Policy</a> | <a href="http://mobile.boostmobile.com/mt/www.boostmobile.com/about/legal/terms-conditions/">Website, Use &amp; Terms &amp; Conditions</a> | <a  href="http://www.boostmobile.com/m/support/faq/">FAQs</a> | <a href="http://mobile.boostmobile.com/mt/stop_mobi?url=http%3A%2F%2Fwww.boostmobile.com&amp;time=30m">View Full Site</a></p>
                        <p>By accessing this site, you accept the terms of our 
                            Acceptable Use Policy and Visitors Agreement.<br/>
                            &#169;<xsl:value-of select="substring(translate($currentDateTimeRaw,':-T',''),1,4)"/> Boost Worldwide, Inc. All rights reserved.</p>
                        <p><span style="color: #F7901E;">Mobile Web by Usablenet</span> | <strong><a href="http://mobile.boostmobile.com/mt/?d=www.boostmobile.com">Feedback</a></strong></p>
                    </div>
                </div>
                
                <!-- Mobile template scripts -->
                <script src="/m/js/vendor/jquery-2.1.3.min.js"></script>
                <script src="/m/js/helper.js"></script>
                <script src="/m/js/main.js"></script>
                <script>
                   Modernizr.load({
                        load: ["/_themes/h5bp/js/toolkit.min.js", "/_themes/libs/js/s_code.js"<xsl:for-each select="/page/header/scripts/file"><!-- On page async scripts-->
                            <xsl:if test="link/@type = 'async' and link != ''">,'<xsl:value-of select="link"/>'</xsl:if></xsl:for-each>],
                        callback: function (c, a, d) {
                            if (c == "/_themes/libs/js/s_code.js") {
                                s.pageName = '<xsl:value-of select="/page/header/title" disable-output-escaping="yes"/>';
                                s.t();
                            }
                                
                        <xsl:for-each select="/page/header/scripts/file"> <!-- Callbacks for each on page specific script that has the callback value set-->        
                            <xsl:if test="link/@type = 'async' and link != ''"><xsl:if test="callback != ''">
                                 if (c == '<xsl:value-of select="link"/>') {
                                      <xsl:value-of select="callback"/> 
                                 }
                            </xsl:if></xsl:if>
                        </xsl:for-each>        
                                
                        }
                    });
                    <xsl:value-of select="/page/header/scripts/onpage/code" disable-output-escaping="yes" />
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>