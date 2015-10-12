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
    Document   : stores.xsl
    Created on : June 25, 2013
    Author     : Jerrol  
    Description: This XSL is for the store locator application

## Additional Hidden Variables ##
s1, s2, s3, s4 - Exclude results to these store type, IE 'best-buy'
sales-channel - Exclude results to this sales channel, IE 'indirect'
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:my-ext="java" extension-element-prefixes="my-ext" xmlns:Math="http://www.math.org/">
    <xsl:output method="html"/>

    <!-- 
    These variables need to be outside the template so that they can be used to output the title tag used by mp-head.xsl
    -->
    <xsl:variable name="storeParams">
        <xsl:for-each select="/page/server/queryParams/param">
            <xsl:value-of select="@key"/>=<xsl:value-of select="@value"/>
            <xsl:if test="position() != last()">&amp;</xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="storeParamsNoPage">
        <xsl:for-each select="/page/server/queryParams/param[not(contains(@key, 'page'))]">
            <xsl:value-of select="@key"/>=<xsl:value-of select="@value"/>
            <xsl:if test="position() != last()">&amp;</xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="storeContent" select="document(concat(/page/content/locator/@api-url,$storeParams))"/>
    <xsl:variable name="storePageTitle">
        <xsl:choose>
            <!-- No zip code hence no locations-->
            <xsl:when test="$storeContent/nearestOutletResponse/searchParameters/zipcode = 0">Find Boost Mobile Store Locations Near You</xsl:when>
            <!-- On page 2+, this shows for paginated results-->
            <xsl:when test="/page/server/queryParams/param[@key = 'page']/@value &gt; 1">Boost Mobile Locations near <xsl:value-of select="concat($storeContent/nearestOutletResponse/zipCityState,' ',$storeContent/nearestOutletResponse/searchParameters/zipcode)"/> | Page <xsl:value-of select="/page/server/queryParams/param[@key = 'page']/@value"/></xsl:when>
            <!-- Default single results page title -->
            <xsl:otherwise>Boost Mobile Locations near <xsl:value-of select="concat($storeContent/nearestOutletResponse/zipCityState,' ',$storeContent/nearestOutletResponse/searchParameters/zipcode)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="storeDescription">
        <xsl:choose>
            <!-- On page 2+, this shows for paginated results-->
            <xsl:when test="$storeContent/nearestOutletResponse/searchParameters/zipcode = 0"><xsl:value-of select="/page/header/metaDescription"/></xsl:when>
            <!-- Default single results page title -->
            <xsl:otherwise>Find a Boost Mobile location near <xsl:value-of select="concat($storeContent/nearestOutletResponse/zipCityState,' ',$storeContent/nearestOutletResponse/searchParameters/zipcode)"/> and get great deals on the latest phones from Apple, Samsung &amp; and more - all without a contract.
            <xsl:if test="/page/server/queryParams/param[@key = 'page']/@value &gt; 1">
                Showing Results <xsl:value-of select="($storeContent/nearestOutletResponse/searchParameters/resultsPageNum * $storeContent/nearestOutletResponse/searchParameters/resultsPerPage) - $storeContent/nearestOutletResponse/searchParameters/resultsPerPage + 1"/>-<xsl:value-of select="$storeContent/nearestOutletResponse/searchParameters/resultsPageNum * $storeContent/nearestOutletResponse/searchParameters/resultsPerPage"/>.
            </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- Get the city name and convert it to URL friendly, calls a template from sitemap-locations.xsl -->
    <xsl:variable name="storeCityUrl">
        <xsl:call-template name="CamelCase">
            <xsl:with-param name="text" select="$storeContent/nearestOutletResponse/city"/>
            <xsl:with-param name="url" select="'true'"/>
        </xsl:call-template>
    </xsl:variable>
    
    <!-- The store canonical needs to pull its data from the feed because the query params often only have the zipcode but the sitemap lists city state zip                                                     
    <xsl:variable name="storeCanonical" select="concat('?city=',$storeCityUrl,'&amp;state=',$storeContent/nearestOutletResponse/state,'&amp;zipcode=',$storeContent/nearestOutletResponse/searchParameters/zipcode)" />
    -->    
    <xsl:variable name="storeCanonical">
        <xsl:value-of select="concat('?city=',$storeCityUrl,'&amp;state=',$storeContent/nearestOutletResponse/state,'&amp;zipcode=',$storeContent/nearestOutletResponse/searchParameters/zipcode)"/>
        <xsl:if test="$storeContent/nearestOutletResponse/searchParameters/resultsPageNum != '1'">
            <xsl:text>&amp;page=</xsl:text><xsl:value-of select="$storeContent/nearestOutletResponse/searchParameters/resultsPageNum"/>
        </xsl:if>
    </xsl:variable>
    
    
    <!-- 
    Template for store locator page
    -->
    <xsl:template name="stores">
        <!-- Application variables -->
        <!-- 
        Normal Call: ##REMOVED##
        iPhone Only Call: ##REMOVED##
        -->
        <xsl:variable name="zipcode" select="/page/server/queryParams/param[@key = 'zipcode']/@value"/>
        <xsl:variable name="page">
            <xsl:choose>
                <xsl:when test="/page/server/queryParams/param[@key = 'page']"><xsl:value-of select="/page/server/queryParams/param[@key = 'page']/@value"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="'1'"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <div class="breadcrumbs"><xsl:value-of select="/page/content/breadcrumbs" disable-output-escaping="yes"/></div>
            
        {{social}}
            
        <div class="h1 font-boostneo-gradient"><xsl:value-of select="/page/content/title" disable-output-escaping="yes"/></div>
        <div id="locatorContainer">
            <p style="display:none;"><xsl:value-of select="concat(/page/content/locator/@api-url,$storeParams)"/></p>
         
            <!-- Option to override the default search/zip form-->
            <xsl:choose>
                <!-- If override is present, use that -->
                <xsl:when test="/page/content/locator/search-box">
                    <xsl:value-of select="/page/content/locator/search-box" disable-output-escaping="yes"/>
                </xsl:when>
                <!-- Otherwise use default form -->
                <xsl:otherwise>
                    <div id="locatorForm" class="gradient-grey-dk">
                        
                        <!-- Top Promotional Banner -->
                        <xsl:if test="/page/content/banners/top/@imgSrc != ''">
                            <xsl:variable name="s1" select="/page/server/queryParams/param[@key = 's1']/@value"/>
                            
                            <div style="float:right;">
                                <xsl:variable name="href">
                                    <xsl:choose>
                                        <xsl:when test="/page/content/banners/top/@id = $s1 "><xsl:value-of select="/page/content/banners/top[@id = $s1]/@href"/></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="/page/content/banners/top/@href"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="src">
                                    <xsl:choose>
                                        <xsl:when test="/page/content/banners/top/@id = $s1 "><xsl:value-of select="/page/content/banners/top[@id = $s1]/@imgSrc"/></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="/page/content/banners/top/@imgSrc"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                
                                <a>
                                    <xsl:if test="/page/content/banners/top/@href !=''">
                                        <xsl:if test="$href != '' ">
                                            <xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
                                        </xsl:if>
                                    </xsl:if>
                                    <img alt="Promotion"> 
                                        <xsl:attribute name="src"><xsl:value-of select="$src"/></xsl:attribute>
                                    </img>
                                </a>
                            </div>
                        </xsl:if>
                        
                        
                        <!-- Zip code lookup form-->
                        <form action="/stores/" method="get">
                            <div class="h2 font-boostneo-gradient">Search for Boost Mobile Locations</div>
                            <p>
                                <input type="text" class="searchbox zipcode" name="zipcode" id="zipcode" maxlength="5"  size="5">
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$zipcode">
                                                <xsl:value-of select="$zipcode"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                        
                                            </xsl:otherwise>
                                        </xsl:choose>
                                
                                    </xsl:attribute>
                                </input>
                                <input type="submit" width="62" height="18" id="submit" class="submit rounded-3 gradient-orange" value="Find"/>
                            </p>
                            <div style="clear:both;"></div>
                            <!-- Filtering options. These values correspond to lookup query params to nearest outlet -->
                            <p>Limit search to locations that offer:</p>
                            <ul id="locatorFormOptions">
                                <li>
                                    <input type="checkbox" name="phones" id="phoneSalesInd" value="1">
                                        <xsl:if test="/page/server/queryParams/param[@key = 'phones']/@value = '1'">
                                            <xsl:attribute name="checked">true</xsl:attribute>
                                        </xsl:if>
                                    </input>
                                    <label for="phoneSalesInd" title="We have the phones to fit your needs and budget. Pick from top-of-the-line smartphones, and to super-affordable feature phones.">
                                        <div class="icons icon-phone"></div>
                                        Phones</label>
                                </li>
                                <li> 
                                    <input type="checkbox" name="reboost" id="reboostInd" value="1">
                                        <xsl:if test="/page/server/queryParams/param[@key = 'reboost']/@value = '1'">
                                            <xsl:attribute name="checked">true</xsl:attribute>
                                        </xsl:if>
                                    </input>
                            
                                    <label for="reboostInd" title="Add money to your account. Pay with cash, credit card or debit card in person at any of these Re-Boost® locations.">
                                        <div class="icons icon-reboost" title="Reboost"></div>Re-Boost</label>
                                </li>
                               
                                <li> 
                                    <input type="checkbox" name="mw" id="mwInd" value="1">
                                        <xsl:if test="/page/server/queryParams/param[@key = 'mw']/@value = '1'">
                                            <xsl:attribute name="checked">true</xsl:attribute>
                                        </xsl:if>
                                    </input>
                            
                                    <label for="mwInd" title="Load cash to your Mobile Wallet&trade; account - the convenient and simple way to make payments and manage your cash without carrying anything more than your phone or a prepaid card. A $3 service fee applies.">  
                                        <div class="icons icon-wallet" title="Mobile Wallet Cash Reload"></div>Mobile Wallet</label>
                                </li>
                                <li> 
                                    <input type="checkbox" name="pref" id="prefInd" value="1">
                                        <xsl:if test="/page/server/queryParams/param[@key = 'pref']/@value = '1'">
                                            <xsl:attribute name="checked">true</xsl:attribute>
                                        </xsl:if>
                                    </input>
                            
                                    <label for="prefInd" title="Get help with your account. Add services including Phone Insurance, International Calling, or Mobile Hotspot. ">  
                                        <div class="icons icon-boost" title="Boost Stores Only"></div>Customer Support</label>
                                </li>
                                
                            </ul>
                            
                            
                            <!-- 
                            Hidden query parameters to allow filtering by store type or sales channel. 
                            These should only show if the param is present
                            -->
                            <xsl:if test="/page/server/queryParams/param[@key = 's1']/@value">
                                <input type="hidden" name="s1" id="s1"> 
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="/page/server/queryParams/param[@key = 's1']/@value"/>
                                    </xsl:attribute>
                                </input>
                            </xsl:if>
                            <xsl:if test="/page/server/queryParams/param[@key = 's2']/@value">
                                <input type="hidden" name="s2" id="s2"> 
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="/page/server/queryParams/param[@key = 's2']/@value"/>
                                    </xsl:attribute>
                                </input>
                            </xsl:if>
                            <xsl:if test="/page/server/queryParams/param[@key = 's3']/@value">
                                <input type="hidden" name="s3" id="s3"> 
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="/page/server/queryParams/param[@key = 's3']/@value"/>
                                    </xsl:attribute>
                                </input>
                            </xsl:if>
                            <xsl:if test="/page/server/queryParams/param[@key = 's4']/@value">
                                <input type="hidden" name="s4" id="s4"> 
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="/page/server/queryParams/param[@key = 's4']/@value"/>
                                    </xsl:attribute>
                                </input>
                            </xsl:if>
                            <xsl:if test="/page/server/queryParams/param[@key = 'sales_channel']/@value">
                                <input type="hidden" name="sales_channel" id="sales_channel"> 
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="/page/server/queryParams/param[@key = 'sales_channel']/@value"/>
                                    </xsl:attribute>
                                </input>
                            </xsl:if>
                         
                            <div style="clear:both;"></div>
                        </form>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Google Mappage container -->
            <div id="map" style="width:100%;height:400px;display:none;"></div>

            <!-- Output locator results -->
            <div id="locatorResults">
                <xsl:choose>
                    
                    <!-- No zip code present, show nothing-->
                    <xsl:when test="not(/page/server/queryParams/param[@key = 'zipcode'])"></xsl:when>
                    
                    <!-- Invalid/missing zip -->
                    <xsl:when test="$storeContent/nearestOutletResponse/validZip = 'False'">
                        <div id="error"><h2>Missing or invalid ZIP code.</h2></div>
                    </xsl:when>
                    
                    <!-- No store locations -->
                    <xsl:when test="$storeContent/nearestOutletResponse/resultsFoundInd = 'False'">
                        <div id="error"><h2>No locations found in your area</h2></div>
                    </xsl:when> 
                    
                    <!-- Valid zip, show results -->
                    <xsl:when test="$storeContent/nearestOutletResponse/validZip = 'True' and $storeContent/nearestOutletResponse/resultsFoundInd = 'True'">
                        <div id="locatorTop">
                            <img src="/stores/images/legend.png" class="legend"/>
                            <!-- Featured Results -->
                            <h1 class="font-boostneo-gradient">Boost Mobile Locations in
                                <xsl:comment> mp_trans_disable_start </xsl:comment>
                                <xsl:value-of select="concat($storeContent/nearestOutletResponse/zipCityState,' ',$storeContent/nearestOutletResponse/searchParameters/zipcode)"/>
                                <xsl:comment> mp_trans_disable_end </xsl:comment>
                            </h1>
                        
                            <!-- Show featured results -->
                            <xsl:if test="$storeContent/nearestOutletResponse/nearestShowcaseInfoList/nearestLocationInfo and /page/content/locator/@show-featured = 'true'">
                                <div id="locatorFeatured"> 
                                    <h2 class="font-boostneo title">Featured Boost Mobile Stores</h2>
                                    <ul>
                                        
                                        <!-- Loop through returned locations -->
                                        <xsl:for-each select="$storeContent/nearestOutletResponse/nearestShowcaseInfoList/nearestLocationInfo">
                                            <xsl:if test="position() &lt; 4">
                                                <xsl:variable name="address" select="concat(storeAddress/primaryAddressLine,' ',storeAddress/city,' ',storeAddress/state,', ',storeAddress/zipCode,' ')"/>
                                                <li itemscope="itemscope" itemtype="http://schema.org/LocalBusiness">	
                          
                                                    <xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text>
                                                    <h2><xsl:value-of select="storeName"/></h2>
                                            
                                                    <div style="padding-bottom: 7px;">
                                                        <xsl:if test="@phoneSalesInd = 'True'">
                                                            <div class="icons icon-phone tooltip">We have the phones to fit your needs and budget. Pick from top-of-the-line smartphones, and to super-affordable feature phones.</div>
                                                        </xsl:if>
                                                        <xsl:if test="@reboostInd = 'True'">
                                                            <div class="icons icon-reboost tooltip" title="Reboost">Add money to your account. Pay with cash, credit card or debit card in person at any of these Re-Boost® locations.</div>
                                                        </xsl:if>
                                                        <xsl:if test="@MobileWalletInd = 'True'">
                                                            <div class="icons icon-wallet tooltip" title="Mobile Wallet Cash Reload">Load cash to your Mobile Wallet&trade; account - the convenient and simple way to make payments and manage your cash without carrying anything more than your phone or a prepaid card. A $3 service fee applies.</div>
                                                        </xsl:if>
                                                        <xsl:if test="@preferredStoreInd = 'True'">
                                                            <div class="icons icon-boost tooltip" title="Boost Stores Only">Get help with your account. Add services including Phone Insurance, International Calling, or Mobile Hotspot. </div>
                                                        </xsl:if>
                                                    </div>
                                    
                                                    <div itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress">
                                                        <span itemprop="streetAddress">
                                                            <xsl:value-of select="storeAddress/primaryAddressLine"/>
                                                        </span>
                                                        <br/>
                                                        <span itemprop="addressLocality">
                                                            <xsl:value-of select="storeAddress/city"/>
                                                        </span>
                                                        <xsl:text> </xsl:text>
                                                        <span itemprop="addressRegion">
                                                            <xsl:value-of select="storeAddress/state"/>
                                                        </span>
                                                        <xsl:text>, </xsl:text>
                                                        <span itemprop="postalCode">
                                                            <xsl:value-of select="storeAddress/zipCode"/>
                                                        </span>
                                                    </div>
                                    
                                                    <xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text>
                                                    <meta itemprop="logo" content="http://www.boostmobile.com/_themes/libs/images/opengraph/boost-mobile.jpg"/>
                                                    <meta itemprop="brand" content="Boost Mobile"/>
                       
                                                    <div itemprop="telephone">
                                                        <xsl:value-of select="storePhone"/>
                                                    </div>
                                                    <div itemprop="telephone">
                                                        Distance: <strong>
                                                            <xsl:value-of select="distance"/> Miles</strong>
                                                    </div>
                                                  
                                                    <div>
                                                        <div class="icons icon-pin"></div>
                                                        <a target="_blank" class="map" itemprop="map">
                                                            <xsl:attribute name="href">http://maps.google.com/maps?q=<xsl:value-of select="$address"/></xsl:attribute>
                                                            <xsl:attribute name="title">Maps &amp; directions to <xsl:value-of select="storeName"/></xsl:attribute>
                                                            Maps &amp; Directions 
                                                        </a>
                                                    </div>
                                                </li>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </ul>
                                    <div style="clear:both;"></div>
                                
                                </div>
                                <h2 class="title font-boostneo" style="margin-top:20px;">Additional locations to purchase Boost Mobile phones or Re-Boost cards</h2>
                           
                            </xsl:if>
                          
                        </div>  
                        
                        <!-- Normal Results, IE non featured -->
                        <div id="locatorNormal">
                            
                            <div class="showing-results">Results <xsl:value-of select="($storeContent/nearestOutletResponse/searchParameters/resultsPageNum * $storeContent/nearestOutletResponse/searchParameters/resultsPerPage) - $storeContent/nearestOutletResponse/searchParameters/resultsPerPage + 1"/>-<xsl:value-of select="$storeContent/nearestOutletResponse/searchParameters/resultsPageNum * $storeContent/nearestOutletResponse/searchParameters/resultsPerPage"/> of <xsl:value-of select="$storeContent/nearestOutletResponse/resultsFoundNum"/> results</div>
                          
                            <table class="results">
                                <tbody>
                                    <!-- Loop through location data in the XML response -->
                                    <xsl:for-each select="$storeContent/nearestOutletResponse/nearestLocationInfoList/nearestLocationInfo">
                                        <xsl:variable name="address" select="concat(storeAddress/primaryAddressLine,' ',storeAddress/city,' ',storeAddress/state,', ',storeAddress/zipCode,' ')"/>
                                        <tr id="popup" itemscope="itemscope" itemtype="http://schema.org/LocalBusiness">	
                                            <xsl:if test="@preferredStoreInd = 'True'">
                                                <xsl:attribute name="class">preferred</xsl:attribute>
                                            </xsl:if>
                                            <td class="cell" >
                                                <xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text>
                                                
                                                <div>
                                                    <h2 style="float:left;"><xsl:value-of select="storeName"/></h2>

                                                    <div class="icons-callout">
                                                        <xsl:if test="@phoneSalesInd = 'True'">
                                                            <div class="icons icon-phone tooltip">We have the phones to fit your needs and budget. Pick from top-of-the-line smartphones, and to super-affordable feature phones.</div>
                                                        </xsl:if>
                                                        <xsl:if test="@reboostInd = 'True'">
                                                            <div class="icons icon-reboost tooltip" title="Reboost">Add money to your account. Pay with cash, credit card or debit card in person at any of these Re-Boost® locations.</div>
                                                        </xsl:if>
                                                        <xsl:if test="@MobileWalletInd = 'True'">
                                                            <div class="icons icon-wallet tooltip" title="Mobile Wallet Cash Reload">Load cash to your Mobile Wallet&trade; account - the convenient and simple way to make payments and manage your cash without carrying anything more than your phone or a prepaid card. A $3 service fee applies.</div>
                                                        </xsl:if>
                                                        <xsl:if test="@preferredStoreInd = 'True'">
                                                            <div class="icons icon-boost tooltip" title="Boost Stores Only">Get help with your account. Add services including Phone Insurance, International Calling, or Mobile Hotspot. </div>
                                                        </xsl:if>
                                                    </div>
                                                    <div style="clear:both;"></div>
                                                </div>
                                                
                                               
                                                <p itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress">
                                                    <span itemprop="streetAddress">
                                                        <xsl:value-of select="storeAddress/primaryAddressLine"/>
                                                    </span>
                                                    <br/>
                                                    <span itemprop="addressLocality">
                                                        <xsl:value-of select="storeAddress/city"/>
                                                    </span>
                                                    <xsl:text> </xsl:text>
                                                    <span itemprop="addressRegion">
                                                        <xsl:value-of select="storeAddress/state"/>
                                                    </span>
                                                    <xsl:text>, </xsl:text>
                                                    <span itemprop="postalCode">
                                                        <xsl:value-of select="storeAddress/zipCode"/>
                                                    </span>
                                                </p>
                                                <xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text>
                                                <meta itemprop="logo" content="http://www.boostmobile.com/_themes/libs/images/opengraph/boost-mobile.jpg"/>
                                                <meta itemprop="brand" content="Boost Mobile"/>
                                            </td>
                                        
                                            <td class="centerTextvert" itemprop="telephone">
                                                <xsl:value-of select="storePhone"/>
                                            </td>
                                        
                                            <td class="centerTextvert2">Distance: <b>
                                                    <xsl:value-of select="distance"/> Miles</b>
                                            </td>
                                        
                                            <td class="centerText">
                                                <div class="icons icon-pin"></div>
                                                <a target="_blank" class="map" itemprop="map">
                                                    <xsl:attribute name="href">http://maps.google.com/maps?q=<xsl:value-of select="$address"/></xsl:attribute>
                                                    <xsl:attribute name="title">Maps &amp; directions to <xsl:value-of select="storeName"/></xsl:attribute>
                                                    Maps &amp; Directions 
                                                </a>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </div>
                    </xsl:when>
                </xsl:choose>

                <!-- 
                Pagination
                -->
                <!-- If we have more than 10 pages of results, cap at 10 -->
                <xsl:if test="$storeContent/nearestOutletResponse/resultsFoundNum &gt; 10">
                
                    <!-- Get total num of pages -->
                    <xsl:variable name="totalPages">
                        <xsl:choose>
                            <xsl:when test="format-number($storeContent/nearestOutletResponse/resultsFoundNum div 10,'###,###,##0') &gt; 10">
                                <xsl:value-of select="$page + 10"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="format-number($storeContent/nearestOutletResponse/resultsFoundNum div 10,'###,###,##0')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                   
                    <!-- Get total num of pageination options -->
                    <xsl:variable name="totalPaginate">
                        <xsl:choose>
                            <xsl:when test="($storeContent/nearestOutletResponse/resultsFoundNum div 10) &lt; 10">
                                <xsl:value-of select="ceiling($storeContent/nearestOutletResponse/resultsFoundNum div 10)"/>
                            </xsl:when>
                            <xsl:otherwise>10</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                   
                    <div id="pagination">
                        <ul>
                            <xsl:call-template name="storesPagination">
                                <!-- If we want more than 10 pages
                                <xsl:with-param name="index" select="$page" />
                                <xsl:with-param name="total" select="$totalPages" />
                                -->
                                <xsl:with-param name="index" select="1" />
                                <xsl:with-param name="total" select="$totalPaginate" />
                                <xsl:with-param name="params" select="$storeParamsNoPage" />
                            </xsl:call-template>
                        </ul>
                    </div>
                </xsl:if>
                
                <!-- Marketing banners -->
                <div id="adBox">
                    <xsl:if test="/page/content/banners/reboost/@imgSrc !=''">
                        <div style="float:right;">
                            <h3>Re-Boost at these national retailers:</h3>
                            <img alt="Reboost at 7-Eleven, Walgreens and CVS">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="/page/content/banners/reboost/@imgSrc"/>
                                </xsl:attribute>
                            </img> 
                        </div>
                    </xsl:if>
                        
                    <xsl:if test="/page/content/banners/retailers/@imgSrc !=''">
                        <h3>Find Boost Mobile phones at these national retailers:</h3>
                        <a>
                            <xsl:if test="/page/content/banners/retailers/@href !=''">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/page/content/banners/retailers/@href"/>
                                </xsl:attribute>
                            </xsl:if>
                            <img alt="Find Boost Mobile phones at Best Buy, Target, Radioshack and Walmart"> 
                                <xsl:attribute name="src">
                                    <xsl:value-of select="/page/content/banners/retailers/@imgSrc"/>
                                </xsl:attribute>
                            </img>
                        </a>
                    </xsl:if>
                </div>
                
                <div style="clear:both;"></div>
            </div>    
                
        </div>

        <!-- Bottom marketing graphic -->
        <xsl:if test="/page/content/banners/bottom/@imgSrc !=''">   
            <a>
                <xsl:if test="/page/content/banners/bottom/@href !=''">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/page/content/banners/bottom/@href"/>
                    </xsl:attribute>
                </xsl:if>
                <img> 
                    <xsl:attribute name="src">
                        <xsl:value-of select="/page/content/banners/bottom/@imgSrc"/>
                    </xsl:attribute>
                </img>
            </a> 
        </xsl:if>
        
        <xsl:variable name="valid">
            <xsl:choose>
                <xsl:when test="$storeContent/nearestOutletResponse/validZip = 'False'">false</xsl:when>
                <xsl:otherwise>true</xsl:otherwise>  
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="results">
            <xsl:choose>
                <xsl:when test="$storeContent/nearestOutletResponse/resultsFoundInd = 'False'">false</xsl:when> 
                <xsl:otherwise>
                    <xsl:value-of select="$storeContent/nearestOutletResponse/resultsFoundNum"/>
                </xsl:otherwise>  
            </xsl:choose>
        </xsl:variable>
        
        <!-- Output location data onto the page for use in the application. This data is coming from the feed and is outputted here to avoid the need for a separate API call -->
        <script>
            var locationData = {
            valid: <xsl:value-of select="$valid"/>,
            locations: <xsl:value-of select="$results"/>,
            zip: '<xsl:value-of select="$storeContent/nearestOutletResponse/searchParameters/zipcode"/>',
            cityState: '<xsl:value-of select="$storeContent/nearestOutletResponse/zipCityState"/>',
            params: '<xsl:value-of select="$storeParams"/>'
            }
        </script>
    </xsl:template> 
  
  
    <!--
    Outputs the list of pagination links at the bottom of the page
    -->
    <xsl:template name="storesPagination">
        <xsl:param name="index" />
        <xsl:param name="total" />
        <xsl:param name="params"/>
        <xsl:param name="link"/>

        <li>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$link"/>/stores/?page=<xsl:value-of select="$index"/>&amp;<xsl:value-of select="$storeParamsNoPage"/></xsl:attribute>
                <xsl:if test="(/page/server/queryParams/param[@key = 'page']/@value and /page/server/queryParams/param[@key = 'page']/@value = $index) or ($index = 1 and not(/page/server/queryParams/param[@key = 'page']))">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$index"/>
            </a>
        </li>
        
        <xsl:if test="not($index = $total)">
            <xsl:call-template name="storesPagination">
                <xsl:with-param name="index" select="$index + 1" />
                <xsl:with-param name="total" select="$total" />
                <xsl:with-param name="params" select="$storeParams" />
                <xsl:with-param name="link" select="$link" />
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>

</xsl:stylesheet>

