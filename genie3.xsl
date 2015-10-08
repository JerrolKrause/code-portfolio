<?xml version="1.0" encoding="ISO-8859-1" ?> 
<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ex="http://exslt.org/dates-and-times" xmlns:my-ext="java" extension-element-prefixes="ex my-ext" xmlns:bv="http://www.bazaarvoice.com/xs/DataApiQuery/5.4">
  
    <!-- 
    Output list of phones in the genie
    -->
    <xsl:template name="genie3">
        
        <xsl:variable name="products-feed" select="##REMOVED##"/>
        <xsl:variable name="bvRatingsFeed" select="##REMOVED##" /> 
     
        
        <div id="genie3">
            
            <!-- Filtering dropdown menu-->
            <div id="genie3-controller">
                <div class="select"> 
                    <select name="phone-order" id="phone-order">
                        <option data-sort="asc" value="data-position" id="position">Featured Phones</option>
                        <option data-sort="desc" value="data-date-launch" id="date-launch">New Arrivals</option>
                        <option data-sort="desc" value="data-rating" id="rating">Top Rated</option>
                        <option data-sort="desc" value="data-cpo" id="cpo">Certified Pre-owned</option>
                        <option data-sort="asc" value="data-best-seller" id="best-seller">Best Sellers</option>
                    </select> 
                </div>
                
                <p>
                    <span>Phones from flip to 4G LTE</span>
                    <br/>
                    We have the phones to fit<br/> your needs and budget.</p>
            </div>
            
            <!-- Carousel controls-->
            <div class="jcarousel-prev jcarousel-control-prev" style="display: block;"></div>
            <div class="jcarousel-next jcarousel-control-next" style="display: block;"></div>
            <div id="genie3-phones" class="jcarousel" data-datetime="{$currentDateTime}">
                
                
                <ul id="genie3-ul">

                    <!-- Look through the list of phones in the catalogue file -->
                    <xsl:for-each select="$catalogue/products/phones/phone">
                        <!-- Sort by genie order -->
                        <xsl:sort select="@genie-order" order="descending" data-type="number"/>
                        <xsl:variable name="id" select="@id" />
                        <xsl:variable name="products-feed-listing" select="$products-feed/product[@id = $id]"/>
                        <xsl:variable name="phone-path" select="##REMOVED##" />
                        <xsl:variable name="phone" select="document($phone-path)/page/product" />
                        <xsl:variable name="ratings" select="$bvRatingsFeed/bv:Statistics/bv:ProductStatistics/bv:ProductId[contains(., $id)]/../" />
                        <xsl:variable name="sale-price" select="$products-feed/product[@id = $id]/@sale-price"/>
                        <xsl:variable name="original-price" select="$products-feed/product[@id = $id]/@original-price"/>

                        <li>
                            <!-- Add phone attributes to the main content area for filtering/sorting -->
                            <xsl:attribute name="id">sku-<xsl:value-of select="$phone/@id"/></xsl:attribute> 
                            <xsl:attribute name="class">
                                <xsl:text>tile </xsl:text>
                                <xsl:text>sku-</xsl:text>
                                <xsl:value-of select="$phone/@id"/>
                                <xsl:text> brand-</xsl:text>
                                <xsl:value-of select="$phone/attributes/@brand"/>
                                <xsl:text> type-</xsl:text>
                                <xsl:value-of select="$phone/attributes/@type"/>
                                <xsl:choose>
                                    <xsl:when test="$phone/options/@cpo = 'true'"> condition-cpo</xsl:when>
                                    <xsl:otherwise> condition-new</xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="$phone/filters/@threeG = 'true'"> speed-3g</xsl:if>
                                <xsl:if test="$phone/filters/@fourGlte = 'true'"> speed-4glte</xsl:if>
                            </xsl:attribute> 
                            <xsl:attribute name="data-position">
                                <xsl:value-of select="position()"/>
                            </xsl:attribute>
                            <xsl:if test="@best-seller">
                                <xsl:attribute name="data-best-seller">
                                    <xsl:value-of select="@best-seller"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="data-date-launch">
                                <xsl:value-of select="$phone/attributes/@date-launch"/>
                            </xsl:attribute>
                            <xsl:attribute name="data-rating">
                                <xsl:value-of select="$ratings/bv:ReviewStatistics/bv:AverageOverallRating"/>
                            </xsl:attribute>	
                            <xsl:attribute name="data-name">
                                <xsl:value-of select="$phone/names/name"/>
                            </xsl:attribute> 
                            <xsl:attribute name="data-slug">
                                <xsl:value-of select="$phone/attributes/@slug"/>
                            </xsl:attribute>  
                            <xsl:attribute name="data-map">
                                <xsl:value-of select="$products-feed/product[@id = $id]/@map"/>
                            </xsl:attribute>  
                            
                            <!-- Main image -->
                            <div class="genie3-image">
                                <img>
                                    <xsl:attribute name="src">/_themes/h5bp/images/genie3/front/<xsl:value-of select="$id"/>.png</xsl:attribute>
                                    <xsl:attribute name="alt"><xsl:value-of select="concat($phone/names/brand,' ',$phone/names/name)"/> Mobile Phone</xsl:attribute>  
                                </img>
                            </div>

                            <!-- Main conetnt area -->
                            <div class="genie3-content">
                                <p>
                                    <strong class="genie3-brand">
                                        <xsl:value-of select="$phone/names/brand" disable-output-escaping="yes"/>
                                    </strong>
                                    <br/>
                                    <span class="genie3-phone">
                                        <xsl:value-of select="$phone/names/name" disable-output-escaping="yes"/>
                                    </span>
                                    <br/>
                                    <span class="genie3-cpo">
                                        <xsl:if test="$phone/options/@cpo = 'true'">Certified Pre-owned</xsl:if>&#160;
                                    </span>
                                </p>
                            </div>

                            <!-- Ratings -->
                            <div class="genie3-rating reviews_row">
                                <span>
                                    <xsl:variable name="rating" select="$ratings/bv:ReviewStatistics/bv:AverageOverallRating" />
                                    <xsl:attribute name='class'>
                                        <xsl:call-template name="get-ratings-class">
                                            <xsl:with-param name="rating" select="$rating" />
                                        </xsl:call-template> phoneRating</xsl:attribute>&#160;
                                </span>
                            </div>

                            <!-- Price Block -->
                            <div class="genie3-priceblock">
                                <p>
                                    <xsl:if test="$sale-price != $original-price">
                                        <span class="genie3-discount">
                                            <sup>$</sup>
                                            <xsl:value-of select="format-number($original-price - $sale-price, '0')" disable-output-escaping="yes" /> OFF</span>
                                    </xsl:if>&#160;
                                    <br/>

                                    <!-- Get the SKUs of the first and last variation (if any). Needs to be in a variable outside the choose to support the variation price check -->
                                    <xsl:variable name="priceLow">
                                        <xsl:value-of select="variation[1]/@id"/>
                                    </xsl:variable>
                                    <xsl:variable name="priceHigh">
                                        <xsl:value-of select="variation[last()]/@id"/>
                                    </xsl:variable>
                                    
                                    <xsl:choose>
                                        <!-- If sale price is below map -->
                                        <xsl:when test="$products-feed-listing/@sale-price &lt; $products-feed/product[@id = $id]/@map">See price in cart</xsl:when>
                                        
                                        <!-- If sale price does not match original price -->
                                        <xsl:when test="$sale-price != $original-price">
                                            <strong class="genie3-price-crossout">
                                                <sup>$</sup>
                                                <xsl:value-of select="$products-feed-listing/@original-price" disable-output-escaping="yes" />
                                            </strong>
                                            <strong class="genie3-price">
                                                <sup>$</sup>
                                                <xsl:value-of select="$products-feed-listing/@sale-price" disable-output-escaping="yes" />
                                            </strong>
                                        </xsl:when>
                                        
                                        <!-- If a phone has variations and the variations do NOT have the same price -->
                                        <xsl:when test="count(variation) &gt; 2 and $products-feed/product[@id = $priceLow]/@sale-price != $products-feed/product[@id = $priceHigh]/@sale-price">
                                            <strong class="genie3-variations">
                                                <sup>$</sup>
                                                <xsl:value-of select="$products-feed/product[@id = $priceLow]/@sale-price"/> - <sup>$</sup>
                                                <xsl:value-of select="$products-feed/product[@id = $priceHigh]/@sale-price"/>
                                            </strong>
                                        </xsl:when>
                                      
                                        <!-- Default price display-->
                                        <xsl:otherwise>
                                            <strong>
                                                <sup>$</sup>
                                                <xsl:value-of select="$products-feed-listing/@sale-price" disable-output-escaping="yes" />
                                            </strong>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </p>
                            </div>

                            <!-- Create a modal window for each phone -->
                            <div style="display:none;">
                                <div class="genie3-modal">
                                    <xsl:attribute name="id">modal-<xsl:value-of select="$phone/@id"/></xsl:attribute> 
                                    <div class="genie3-modal-top">
                                        <div class="genie3-modal-image">
                                            
                                            <img>
                                                <xsl:attribute name="src">/_themes/h5bp/images/genie3/modal/<xsl:value-of select="$id"/>.png</xsl:attribute>
                                                <xsl:attribute name="alt">
                                                    <xsl:value-of select="concat($phone/names/brand,' ',$phone/names/name)"/> Mobile Phone</xsl:attribute>  
                                            </img>
                                        </div>
                                        
                                        <div class="genie3-modal-content">
                                            <h2>
                                                <span class="bn-bk">
                                                    <xsl:value-of select="$phone/names/brand" disable-output-escaping="yes"/>
                                                </span>&#160;
                                                <xsl:value-of select="$phone/names/name" disable-output-escaping="yes"/>
                                            </h2>

                                            <xsl:if test="$phone/options/@cpo = 'true'">
                                                <p class="genie3-modal-cpo">Certified Pre-owned</p>
                                            </xsl:if>

                                            <ul>
                                                <li class="genie3-modal-icon1">
                                                    <xsl:attribute name="class">genie3-modal-icon1 genie3-modal-<xsl:value-of select="$phone/attributes/@type"/></xsl:attribute>
                                                    <xsl:value-of select="$phone/compare/item[@id = 'os']" disable-output-escaping="yes"/>
                                                </li>
                                                <li class="genie3-modal-icon2">
                                                    <xsl:if test="$phone/compare/item[@id = 'display'] = 'Not Available' ">
                                                        <xsl:attribute name="style">display:none;</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="$phone/compare/item[@id = 'display']" disable-output-escaping="yes"/>
                                                </li>
                                                <li class="genie3-modal-icon3">
                                                    <xsl:if test="$phone/compare/item[@id = 'camera'] = 'Not Available' ">
                                                        <xsl:attribute name="style">display:none;</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="$phone/compare/item[@id = 'camera']" disable-output-escaping="yes"/>
                                                </li>
                                                <li class="genie3-modal-icon4">
                                                    <xsl:if test="$phone/compare/item[@id = '4g'] = 'Not Available' ">
                                                        <xsl:attribute name="style">display:none;</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="$phone/compare/item[@id = '4g']" disable-output-escaping="yes"/>
                                                </li>
                                            </ul>

                                            <a class="learnmore bn-b">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="$phone/attributes/@url"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="data-phone">
                                                    <xsl:value-of select="$phone/attributes/@slug"/>
                                                </xsl:attribute>Learn More</a>
                                        </div>
                                        <div style="clear:both;"></div>
                                    </div>
                                
                                    <!-- Promo Banner, comes from promos.xml -->   
                                    <xsl:for-each select="$promos/promo[@active = 'true']">
                                        <xsl:for-each select="phones/payload">
                                            <xsl:if test="genie/@imageName != '' and (@skus = 'all' or contains(@skus, $id) or (@skus = 'cpo' and $phone/options/@cpo = 'true') or (@skus = 'new' and $phone/options/@cpo != 'true'))">
                                                <div class="genie3-modal-bottom">
                                                    <a class="genie3-promo" href="">
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="genie/@url"/>
                                                        </xsl:attribute>
                                                        <img>
                                                            <xsl:attribute name="src">
                                                                <xsl:value-of select="concat(../../@imgFolder,genie/@imageName)"/>
                                                            </xsl:attribute>
                                                        </img>
                                                    </a>
                                                </div>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                    
                                    <div style="clear:both;"></div>
                                </div>
                            </div>
                        </li>    
                    </xsl:for-each>
                </ul>
            </div>
            <div style="clear:both;"></div>
        </div>
        
    </xsl:template>
    
</xsl:stylesheet>