<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY deg    "&#176;">
<!ENTITY rsquo  "'">
<!ENTITY cent   "&#162;">
<!ENTITY ntilde "&#241;">
<!ENTITY nbsp   "&#160;">
<!ENTITY copy   "&#169;">
<!ENTITY reg    "&#174;">
<!ENTITY trade  "&#8482;">
<!ENTITY ndash  "&#8212;">
<!ENTITY mdash  "&#8212;">
<!ENTITY ldquo  "&#8220;">
<!ENTITY rdquo  "&#8221;">
<!ENTITY amp  "&#38;">
]>

<!--
    Document   : search.xsl
    Created on : July 10th, 2013
    Author     : Jerrol
    Description:
        Main XSL document for the search application
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:my-ext="java" extension-element-prefixes="my-ext" xmlns:Math="http://www.math.org/" xmlns:gcse="http://www.google.com">
    <xsl:output method="html"/>

    <!-- 
    Search Template
    -->
    <xsl:template name="search">

        <!-- Begin Main Content -->
        <div class="breadcrumbs">
            <a href="/">Home</a>&nbsp;&gt;&nbsp;Search</div>
        {{social}}
        <h1 class="font-boostneo-gradient">Search</h1>
        
        <div id="search">
            <!-- Left Column -->
            <div class="col_left">
                <div class="search_box font-boostneo">Search for: </div>
                <!-- GCS input box -->
                <div class="gcse-searchbox-only" data-resultsUrl="/search/" data-newWindow="false"></div>
                
                <!-- Merch search container-->
                <div id="searchMerchContent">
                    <input id="searchMerchInput" style="display:none;"/>
                    <div class="recomended font-boostneo" >Recommended Products</div>
                    <div class="content" id="searchMerchResults"></div>
                    <div style="clear:both;"></div>
                </div>
                
                <!-- GCS results box -->
                <div id="searchResults">
                    <div class="gcse-searchresults-only"></div>
                </div>
                <div style="clear:both;"></div>
            </div>
          
            <!-- Right Column -->
            <div class="col_right">
                <xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_remove_start -->]]></xsl:text>
            
                <!-- Web Banners from promotion engine -->
                <div id="webBannerSidebar">
                    <xsl:call-template name="webbanner">
                        <xsl:with-param name="banners" select="$promos/promo[@active = 'true']/banner[@search = 'true'][@sidebar = 'true'] | /page/content/banners/banner"/> 
                    </xsl:call-template>
                </div>
                 
                <xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_remove_end -->]]></xsl:text>
            </div>
            <div style="clear:both;"></div>
        </div>
        
    </xsl:template>	
</xsl:stylesheet>

