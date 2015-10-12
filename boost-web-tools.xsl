<?xml version="1.0" encoding="ISO-8859-1" ?> 
<!DOCTYPE xsl:stylesheet [
<!ENTITY deg    "&#176;">
<!ENTITY rsquo  "'">
<!ENTITY cent   "&#162;">
<!ENTITY ntilde "&#241;">
<!ENTITY nbsp   "&#160;">
<!ENTITY copy   "&#169;">
<!ENTITY reg    "&#174;">
<!ENTITY trade  "&#153;">
<!ENTITY ndash  "&#8212;">
<!ENTITY mdash  "&#8212;">
<!ENTITY ldquo  "&#8220;">
<!ENTITY rdquo  "&#8221;">
<!ENTITY amp  "&#38;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xalan="http://xml.apache.org/xalan" xmlns:ex="http://exslt.org/dates-and-times" xmlns:my-ext="java" extension-element-prefixes="ex my-ext" xmlns:Math="http://www.math.org/" >
<xsl:output method="html" encoding="utf-8" indent="yes" />

<!-- Masterpage Includes -->
<xsl:include href="##REMOVED##"/>
<xsl:variable name="products-feed" select="document($products)/payload/products"/>
<xsl:variable name="available-phones-pricing" select="document('##REMOVED##')/payload/products" />
     

    <!-- Core Template -->
    <xsl:template match="/">
        
        <!-- Ensure that this page cannot execute in production -->
        <xsl:if test="$base_url != 'www.boostmobile.com'">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
            <xsl:comment><![CDATA[[if lt IE 7]><html lang="en" class="no-js lt-ie9 lt-ie8 lt-ie7"><![endif]]]></xsl:comment>
            <xsl:comment><![CDATA[[if IE 7]><html lang="en" class="no-js lt-ie9 lt-ie8"><![endif]]]></xsl:comment>
            <xsl:comment><![CDATA[[if IE 8]><html lang="en" class="no-js lt-ie9"><![endif]]]></xsl:comment>
            <xsl:comment><![CDATA[[if IE 9]><html lang="en" class="no-js ie9"><![endif]]]></xsl:comment>
            <xsl:comment><![CDATA[[if IE]><![if (gt IE 9)|!(IE)]><![endif]]]></xsl:comment>
            <html lang="en" class="no-js">
                <xsl:comment><![CDATA[[if IE]><![endif]><![endif]]]></xsl:comment>

                    <head>
                        <META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
                        <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"/>
                        <title>Boost Web Tools | Boost Mobile</title>
                        <link rel="stylesheet" href="/_cache/_css/style.css"/>
                        <link rel="stylesheet" href="/shop/phones/_css/phoneAll.css"/> 
			<link rel="stylesheet" href="/shop/phones/_css/phoneGrid.css"/> 
                        <link rel="stylesheet" href="/_themes/h5bp/css/boost-web-tools.css"/>
                        <script src="/_themes/libs/js/modernizr-2.0.6.min.js"></script>
                    </head>
                    
                    <body>
                        <div id="container">
                            <h1 class="font-boostneo-gradient">Boost Web Tools</h1>
                            <ul id="nav">
                                <li><a href="#" data-tab-id="shopPhones">Store Tool</a></li>
                                <li> <a href="#" data-tab-id="ratings" class="gradient-grey-dk">Ratings &amp; Reviews</a></li>
                            </ul>
                            
                            
                            <!-- Phones and product content -->
                            <div id="shopPhones" class="tabs">
                                
                                <div class="grid">
                                    <div id="comparePhones">
                                        <p>Data is provided by Brightpoint and is updated every hour at approximately 20 after. These feeds can be accessed directly @: <a href="//www.boostmobile.com/__vendors/brightpoint/prod/pricing.xml" target="blank">Pricing</a> &amp; 
                                            <a href="//www.boostmobile.com/__vendors/brightpoint/prod/inventory.xml" target="blank">Inventory</a>. </p>
                                        <hr />
                                        <div id="controls">
                                            <xsl:call-template name="filters"/>  
                                        </div>
                                        <div id="dateOptions"></div>
                                        <div class="gridContent">
                                            <table border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <th scope="col" width="250px">Phone</th>
                                                    <th scope="col" width="100px">Status</th>
                                                    <th scope="col" width="90px">Inventory</th>
                                                    <th scope="col" width="100px">Current Price</th>
                                                    <th scope="col" width="">Queued Pricing</th>
                                                </tr>

                                                <!-- Loop for each phone from the catalogue file -->
                                                <xsl:for-each select="$catalogue/products/phones/phone | $catalogue/products/hotspots/hotspot">
                                                    <xsl:variable name="id" select="@id" />
                                                    <xsl:variable name="parent" select="." />
                                                    <xsl:choose>
                
                                                        <!-- If this phone has multiple variations, create an entry for each one -->
                                                        <xsl:when test="variation">
                                                            <xsl:for-each select="variation">
                                                                <xsl:variable name="phone" select="." />
                                                                <xsl:call-template name="phone-content">
                                                                    <xsl:with-param name="id" select="@id"/>
                                                                    <xsl:with-param name="parent" select="$parent"/>
                                                                    <xsl:with-param name="phone" select="$phone"/>
                                                                    <xsl:with-param name="products-feed" select="$products-feed"/>
                                                                </xsl:call-template>
                                                            </xsl:for-each>
                                                        </xsl:when>
                
                                                        <!-- Just a single phone no variations -->
                                                        <xsl:otherwise>
                                                            <xsl:variable name="phone" select="." />
                                                            <xsl:call-template name="phone-content">
                                                                <xsl:with-param name="id" select="$id"/>
                                                                <xsl:with-param name="parent" select="$parent"/>
                                                                <xsl:with-param name="phone" select="$phone"/>
                                                                <xsl:with-param name="products-feed" select="$products-feed"/>
                                                            </xsl:call-template>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div style="clear:both;"></div>
                            </div>
                            
                            <!-- Ratings Content -->
                            <div id="ratings" class="tabs">
                                 <xsl:call-template name="ratings-content"/>
                            </div>
                
                            
                            <div style="clear:both;"/>
                        </div>
                        <script src="/_cache/_js/script.js"></script>
                        <script src="/_themes/libs/js/jquery-1.7.2.min.js"></script>
                        <script src="/_themes/libs/js/jquery-ui-1.8.16.custom.min.js"></script>
                        <script src="/_themes/libs/js/jquery-ui-timepicker-addon.js"></script>
                        <script src="/_themes/h5bp/js/boost-web-tools.js"></script>
                    </body>
                    </html>
        </xsl:if>
    </xsl:template>


    <!--
    Display the content for the ratings tab
    -->
    <xsl:template name="ratings-content">
        <xsl:variable name="bvAPI_ratings">
            <xsl:text>http://api.bazaarvoice.com/data/statistics.xml?apiversion=5.4&amp;passkey=kuhuhpez8no0cnhrldxrcrpng&amp;limit=100&amp;stats=Reviews&amp;filter=ContentLocale:en_US&amp;filter=ProductID:</xsl:text>
            <xsl:for-each select="$catalogue/products/phones/phone | $catalogue/products/hotspots/hotspot">
                <xsl:value-of select="@id" />,</xsl:for-each>
            <xsl:for-each select="$catalogue/plans/plan">
                <xsl:value-of select="@id" />,</xsl:for-each>ShrinkingPayments</xsl:variable>
        <xsl:variable name="bvAPI_ratings_esp">
            <xsl:text>http://api.bazaarvoice.com/data/statistics.xml?apiversion=5.4&amp;passkey=kuhuhpez8no0cnhrldxrcrpng&amp;limit=100&amp;stats=Reviews&amp;filter=ContentLocale:es_US&amp;filter=ProductID:</xsl:text>
            <xsl:for-each select="$catalogue/products/phones/phone | $catalogue/products/hotspots/hotspot">
                <xsl:value-of select="@id" />,</xsl:for-each>
            <xsl:for-each select="$catalogue/plans/plan">
                <xsl:value-of select="@id" />,</xsl:for-each>ShrinkingPayments</xsl:variable>
                                            
        <p>This is the ratings feed received from Bazaarvoice. This will contain the most current information from their API. To update the ratings on the site, upload both XML feeds to /_vendors/bazaarvoice/xml/ and replace the existing XML files.</p>
        <h2>Feed TO BV</h2>
        <p>
            <a target="_blank">
                <xsl:attribute name="href">/feed/bazaarvoice.xml </xsl:attribute>
                View</a> | 
            <a download="bv.xml">
                <xsl:attribute name="href" >/feed/bazaarvoice.xml</xsl:attribute>
                Download</a>
        </p>
        <hr/>
        <h2>English Ratings Feed</h2>
        <p>
            <a target="_blank">
                <xsl:attribute name="href" select="$bvAPI_ratings">
                    <xsl:value-of select="$bvAPI_ratings"/>
                </xsl:attribute>
                View</a> | 
            <a download="statistics.xml">
                <xsl:attribute name="href" select="$bvAPI_ratings">
                    <xsl:value-of select="$bvAPI_ratings"/>
                </xsl:attribute>
                Download</a>
        </p>
        <textarea name="Text1"  rows="6" style="width:100%;" >
            <xsl:value-of select="$bvAPI_ratings"/>
        </textarea>
    </xsl:template>
 
 
    <!-- 
    Template for the phone content row
    -->
    <xsl:template name="phone-content">
        <xsl:param name="id"/>
        <xsl:param name="parent"/>
        <xsl:param name="phone"/>
        <xsl:param name="products-feed"/>

        <!-- Get phone content -->
        <xsl:variable name="phone-path" select="concat('/../../../../../WEB-INF/classes/config/www/',$parent/@path,'.xml')" />
        <xsl:variable name="phone-content" select="document($phone-path)/page/product" /> 
       
        <xsl:variable name="sale-price" select="$products-feed/product[@id = $id]/@sale-price"/>
        <xsl:variable name="original-price" select="$products-feed/product[@id = $id]/@original-price"/>
        <tr>
            <xsl:attribute name="class">
                <xsl:text>entry </xsl:text>
                <xsl:value-of select="$phone-content/attributes/@brand"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$phone-content/attributes/@type"/>
                <!-- We may need to modify this is plans stop being associated with phone type -->
                <xsl:if test="$phone-content/attributes/@type = 'iphone'"> amu adu</xsl:if>
                <xsl:if test="$phone-content/attributes/@type = 'android'"> amu adu</xsl:if>
                <xsl:if test="$phone-content/attributes/@type = 'blackberry'"> bmu bbm bdu adu</xsl:if>
                <xsl:if test="$phone-content/attributes/@type = 'feature'"> mu du pg</xsl:if>  				
                <xsl:if test="$sale-price != $original-price"> promo-sale</xsl:if>                
                <xsl:if test="$phone-content/options/@featured != ''"> promo_featured</xsl:if>  
                <xsl:choose>
                    <xsl:when test="$phone-content/options/@cpo = 'true'"> cpo </xsl:when>
                    <xsl:otherwise> new </xsl:otherwise>
                </xsl:choose>   
                <xsl:if test="count($phone-content/variations/options/option[@id = 'color']/value) > 1 and $phone/variations/@separate-listings != 'true'"> variations</xsl:if>
            </xsl:attribute>
                                            
          
            <!-- Phone Name/Image -->
            <td class="pFirst">
                <h2>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:text>/shop/phones/</xsl:text>
                            <xsl:value-of select="$phone/attributes/@slug" />
                            <xsl:text>/</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$phone-content/names/brand" disable-output-escaping="yes" />&#160;
                        <xsl:value-of select="$phone-content/names/name" disable-output-escaping="yes" />
                    </a>
                </h2>
                <div style="float:left;">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:text>/shop/phones/</xsl:text>
                            <xsl:value-of select="$phone-content/attributes/@slug" />
                            <xsl:text>/</xsl:text>
                        </xsl:attribute>
                        <img>
                            <xsl:attribute name="src">/shop/phones/_images/cart/<xsl:value-of select="$id"/>.png</xsl:attribute>
                        </img>
                    </a>
                </div>
                <div style="float:left;padding-top:5px;">
                    <xsl:if test="$phone-content/variations">
                        <span class="vSKU">
                            <xsl:if test="$phone-content/variations/products/product[@id = $id]/@color">
                                Color: <xsl:value-of select="$phone-content/variations/products/product[@id = $id]/@color" disable-output-escaping="no" />
                            </xsl:if>
                            <xsl:if test="$phone-content/variations/products/product[@id = $id]/@memory">
                                <br/>Memory: <xsl:value-of select="$phone-content/variations/products/product[@id = $id]/@memory" disable-output-escaping="no" />
                                <br/>
                            </xsl:if>
                        </span>        
                    </xsl:if>  
                    <span class="vSKU">
                        SKU: <xsl:value-of select="$id" /> 
                    </span>
                </div>
            </td>
			
            <!-- Add to cart button -->
            <td class="pSecond">
                <!-- check to see if phone is available -->
                <xsl:choose>
                    <xsl:when test="$phone-content/options/@preorder != ''">
                        <a class="add_to_cart rounded-3 gradient-orange inline">
                            <xsl:attribute name="href">
                                <xsl:text>https://checkout.boostmobile.com/bpdirect/boost/AddItemDirect.do?action=view&amp;qty=1&amp;sku=</xsl:text>
                                <xsl:value-of select="$id" />
                            </xsl:attribute>
                            <xsl:attribute name="data-sku">
                                <xsl:value-of select="$id" disable-output-escaping="yes" />
                            </xsl:attribute>
                            <xsl:text>Pre-order</xsl:text>
                        </a>
                        <br/>
                        <div class="pStock">(In Stock via pre-order)</div>
                    </xsl:when>
                 
                    <xsl:when test="$products-feed/product[@id = $id]/@available = 'true'">
                        <a class="add_to_cart rounded-3 gradient-orange inline">
                            <xsl:attribute name="href">
                                <xsl:text>https://checkout.boostmobile.com/bpdirect/boost/AddItemDirect.do?action=view&amp;qty=1&amp;sku=</xsl:text>
                                <xsl:value-of select="$id" />
                            </xsl:attribute>
                            <xsl:attribute name="data-sku">
                                <xsl:value-of select="$id" disable-output-escaping="yes" />
                            </xsl:attribute>
                            <xsl:text>Add to cart</xsl:text>
                        </a>
                        <br/>
                        <div class="pStock">(In Stock)</div>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <a class="add_to_cart rounded-3 gradient-grey-dk">Out Of Stock</a>
                        <div class="pStock pStockOOS">(Out Of Stock)</div>
                    </xsl:otherwise>
                </xsl:choose>
            </td>

            <!-- Inventory Count -->
            <td class="pThird">
                <xsl:variable name="inventory" select="$products-feed/product[@id = $id]/@inventory" />
                <!-- Check if the inventory conut is under 1000, if not add a comma for easy reading-->
                <xsl:choose>
                    <xsl:when test="$inventory &lt; 1000">
                        <xsl:value-of select="$inventory"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(
			                      substring($inventory,1,1),
			                      ',',
			                      substring($inventory,2)
			                      )"
                        />
                    </xsl:otherwise>
                </xsl:choose>                    
                <div class="vSKU">Threshold: <xsl:value-of select="$products-feed/product[@id = $id]/@oos-threshold"/></div>                       
            </td>

            <!-- Current Pricing -->
            <td class="pFourth">
                <xsl:choose>
                    <!-- on sale -->
                    <xsl:when test="$sale-price != $original-price">
                        <span class="phoneRegPrice">
                            <xsl:value-of select="$original-price" disable-output-escaping="yes" />
                        </span>
                        <br/>
                        <xsl:choose>
                            <!-- on sale price - hide -->
                            <xsl:when test="$products-feed/product[@id = $id]/@map != '' and $sale-price &lt; $products-feed/product[@id = $id]/@map">
                                <br/>
                                <span class="phonePrice" itemprop="price">
                                    <xsl:value-of select="$sale-price" disable-output-escaping="yes" />
                                </span>
                                <br/>
                                <span class="phoneHiddenPrice font-boostneo-bold" itemprop="price" style="font-size:10px;width:auto!important;">See price in cart</span>
                            </xsl:when>
                            <!-- on sale price - show -->
                            <xsl:otherwise>
                                <span class="phonePrice" itemprop="price">
                                    <xsl:value-of select="$sale-price" disable-output-escaping="yes" />
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- NOT on sale -->
                    <xsl:otherwise>
                        <span class="phonePrice" itemprop="price">
                            <xsl:value-of select="$original-price" disable-output-escaping="yes" />
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$products-feed/product[@id = $id]/@map != ''">
                    <div class="map">MAP: <xsl:value-of select="$products-feed/product[@id = $id]/@map" disable-output-escaping="yes" /></div>
                </xsl:if>
            </td>
            
            <!-- Queued Pricing -->
            <td class="pFifth">	
                <xsl:variable name="queued-phones-pricing" select="$available-phones-pricing/product[@id = $id]" />
                <!-- Loop thru each price node-->
                <xsl:for-each select="$queued-phones-pricing/prices/price">
                    <xsl:variable name="drop-off" select="(@end-date)[last()]" />
                    <xsl:call-template name="pricing-block">  
                        <xsl:with-param name="drop-off" select="$drop-off"/>
                        <xsl:with-param name="slug" select="$phone-content/attributes/@slug"/>
                    </xsl:call-template>  
                    <xsl:if test="$drop-off != '' and position() = last()">
                        <div class="pDropOff">Drop Off Warning!</div>
                    </xsl:if>
                </xsl:for-each>	
            </td>
        </tr>
    </xsl:template>


    <!-- Template for pricing block data -->
    <xsl:template name="pricing-block">
        <xsl:param name="drop-off" />
        <xsl:param name="slug" />

        <!-- Output Pricing -->
        <div class="pPriceBlock">
            <xsl:variable name="start-date" select="@start-date" />
            <xsl:variable name="end-date" select="@end-date" />
                <!-- Output the start date in a easily readable format -->
                <xsl:call-template name="dateFormatter">
                    <xsl:with-param name="date" select="$start-date"/>
                </xsl:call-template>
                - 
                <!-- Check if the queued price has an end date -->
                <xsl:choose>
                    <xsl:when test="not(@end-date)">
                        <span class="date">No End Date</span>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Output the end date in a easily readable format -->
                        <!-- Output the start date in a easily readable format -->
                        <xsl:call-template name="dateFormatter">
                            <xsl:with-param name="date" select="$end-date"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
           <br/>
            <xsl:choose>
                <!-- on sale -->
                <xsl:when test="sale-price != original-price">
                    <span class="original_price">
                        <xsl:value-of select="substring(original-price,0,string-length(original-price) - 1)" disable-output-escaping="yes" />
                    </span> /
                    <xsl:choose>
                        <!-- on sale price - show -->
                        <xsl:otherwise>
                            <span class="sale_price">
                                <xsl:value-of select="substring(sale-price,0,string-length(original-price) - 1)" disable-output-escaping="yes" />
                            </span> 
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- NOT on sale -->
                <xsl:otherwise>
                    <span class="sale_price">
                        <xsl:value-of select="substring(original-price,0,string-length(original-price) - 1)" disable-output-escaping="yes" />
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <div style="clear:both;"></div>
    </xsl:template>


    <!-- 
    Output the filtering options for the sidebar
    -->
    <xsl:template name="filters">
        <div class="sidenav">
            <form id="filter"> 
                <fieldset style="padding-bottom:0px;" class="viewall"> 
                    <div data-value="viewall" class="filter-option checked"> 
                        <span class="checkbox"></span>
                        <label>Viewing all results</label> 
                    </div> 
                </fieldset> 
                <fieldset class="individual promo_sale"> 
                    <div data-value="promo-sale" class="filter-option"> 
                        <span class="checkbox"></span>
                        <label>On Sale</label> 
                    </div> 
                </fieldset> 
                <h3 class="gradient-black"> 
                    <span>Condition</span> 
                </h3> 
                <fieldset class="individual" id="condition"> 
                    <div data-value="new" class="filter-option new"> 
                        <span class="checkbox"></span>
                        <label>New</label> 
                    </div> 
                    <div data-value="cpo" class="filter-option cpo"> 
                        <span class="checkbox"></span>
                        <label>Pre-owned</label> 
                    </div> 
                </fieldset> 
                <h3 class="gradient-black"> 
                    <span>Phone Types</span> 
                </h3> 
                <fieldset class="individual" id="phone-types"> 
                    <div data-value="iphone" class="filter-option iphone"> 
                        <span class="checkbox"></span>
                        <label>iPhone</label> 
                    </div> 
                    <div data-value="android" class="filter-option android"> 
                        <span class="checkbox"></span>
                        <label>Android</label> 
                    </div> 
                    <div data-value="blackberry" class="filter-option blackberry"> 
                        <span class="checkbox"></span>
                        <label>BlackBerry</label> 
                    </div> 
                    <div data-value="feature" class="filter-option feature"> 
                        <span class="checkbox"></span>
                        <label>Feature </label> 
                    </div> 
                </fieldset> 
               
            </form>
        </div>
    </xsl:template>
    
    
    <!--
    Format the supplied data in a user friendly format
    -->
    <xsl:template name="dateFormatter">
        <xsl:param name="date" />

        <!-- Input Date: 2013-01-09T000000.000Z -->
        <span class="date">
            <xsl:value-of select="concat(
	                      substring($date,1,4),
	                      '/',
	                      substring($date,6,2),
	                      '/',
	                      substring($date,9,2)
	                      )"
            />
        </span>
        <xsl:text> </xsl:text>
        <span class="time">
            <xsl:value-of select="substring($date,12,2)" />:<xsl:value-of select="substring($date,14,2)"/>
        </span>
    </xsl:template>


</xsl:stylesheet>