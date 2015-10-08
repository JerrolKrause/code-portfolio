<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xalan="http://xml.apache.org/xalan" xmlns:my-ext="java" extension-element-prefixes="my-ext" xmlns:Math="http://www.math.org/">
    <xsl:output method="html"/>

    <!-- 
    Output the dynamic web banner to the page
    USAGE: 
        <xsl:call-template name="webbanner">
            <xsl:with-param name="banners" select="$promos/promo[@active = 'true']/banner[@grid = 'true']"/> 
        </xsl:call-template>
    -->
    <xsl:template name="webbanner">
        <xsl:param name="banners"/>
        <xsl:param name="tracking"/>
        
        <div class="webPromo">
            
            <!-- If banners exist, show the banner div -->
            <xsl:if test="count($banners) &gt; 0">
                <xsl:attribute name="class">webPromo show</xsl:attribute>
            </xsl:if>
            
            <!-- Loop through banners sent by the parameter OR are present on this pages XML -->
            <xsl:for-each select=" $banners ">
               
                <a class="banner">
                    <xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
                    <xsl:attribute name="style">z-index:<xsl:value-of select="20 - position()"/></xsl:attribute>
                    <!-- Add filtering/sorting attributes -->
                    <xsl:attribute name="class">
                        <xsl:text>banner </xsl:text>
                        <xsl:if test="@type = 'visitor' "><xsl:text>visitor </xsl:text></xsl:if>
                        <xsl:if test="@type = 'customer' "><xsl:text>customer </xsl:text></xsl:if>
                        <xsl:if test="@lang = 'eng' "><xsl:text>english </xsl:text></xsl:if>
                        <xsl:if test="@lang = 'esp' "><xsl:text>espanol </xsl:text></xsl:if>
                    </xsl:attribute>
                                 
                    <xsl:if test="@url != ''">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@url"/>
                            <xsl:if test="$tracking != '' ">?icamp=INTC_<xsl:value-of select="../@id"/>_<xsl:value-of select="$tracking"/></xsl:if>
                        </xsl:attribute>
                    </xsl:if>
                    <img>
                        <xsl:attribute name="src">
                            <xsl:value-of select="../@imgFolder"/>
                            <xsl:value-of select="@imageName"/>
                        </xsl:attribute>
                    </img>
                </a>
         
            </xsl:for-each>
        </div>
    </xsl:template>


    <!-- 
    Adds promo messaging to location. Loops through the active promos and outputs content from the message node
    USAGE: 
        <xsl:call-template name="promoMessage">
            <xsl:with-param name="id" select="$id"/> 
            <xsl:with-param name="phone" select="$phone"/> 
            <xsl:with-param name="products-feed" select="$products-feed"/>
        </xsl:call-template>
    -->
    <xsl:template name="promoMessage">
        <xsl:param name="id"/>
        <xsl:param name="phone"/>
        <xsl:param name="products-feed"/>
        
        <xsl:variable name="sale-price" select="$products-feed/product[@id = $id]/@sale-price"/>
        <xsl:variable name="original-price" select="$products-feed/product[@id = $id]/@original-price"/>
        
        <div class="promo-messages">
            <!-- Output content into a variable, this lets us have an empty variable to check against if nothing is found -->
            <xsl:variable name="promoMessage">
                <xsl:for-each select="$promos/promo[@active = 'true']">
                    <xsl:variable name="promo-id"><xsl:value-of select="@id"/></xsl:variable>
                    <!-- Now loop through the phone detail payloads -->
                    <xsl:for-each select="phones/payload">
                        <!-- Check if the SKU is present and message isn't empty OR SKU is set to all and message isn't empty -->
                        <xsl:if test="(message/title != '' or message/body != '') and (@skus = 'all' or contains(@skus, $id) or (@skus = 'cpo' and $phone/options/@cpo = 'true') or (@skus = 'new' and $phone/options/@cpo != 'true'))">
                            <div class="promo-message">
                                <xsl:if test="message/title != ''">
                                    <strong>
                                        <xsl:value-of select="message/title" disable-output-escaping="yes"/>
                                    </strong>
                                    <br/>
                                </xsl:if>
                                <xsl:if test="message/body != ''">
                                    <xsl:value-of select="message/body" disable-output-escaping="yes"/>
                                </xsl:if>
                                <xsl:if test="message/tooltip != ''">
                                    <div class="tooltip">
                                        <xsl:value-of select="message/tooltip" disable-output-escaping="yes"/>
                                    </div>
                                </xsl:if>
                            </div>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            
            <!-- Now output the messaging -->        
            <xsl:choose>
                <!-- If a promo message/s is set, show that -->
                <xsl:when test="$promoMessage != ''">
                    <xsl:attribute name="class">
                        <xsl:text>promo-messages show-promo</xsl:text>
                        <xsl:if test="$sale-price != $original-price or count($phone/variations/options/option/value) > 1"> nudge</xsl:if>
                    </xsl:attribute>
                    <xsl:copy-of select="$promoMessage"/>
                </xsl:when>
                <!-- Otherwise if a default message is set, show that-->
                <xsl:when test="$promos/defaults/message != ''">
                    <xsl:attribute name="class">
                        <xsl:text>promo-messages show-promo</xsl:text>
                        <xsl:if test="$sale-price != $original-price or count($phone/variations/options/option/value) > 1"> nudge</xsl:if>
                    </xsl:attribute>
                    <div class="promo-message">
                        <xsl:if test="$promos/defaults/message/title != ''">
                            <strong>
                                <xsl:value-of select="$promos/defaults/message/title" disable-output-escaping="yes"/>
                            </strong>
                            <br/>
                        </xsl:if>
                        <xsl:if test="$promos/defaults/message/body != ''">
                            <xsl:value-of select="$promos/defaults/message/body" disable-output-escaping="yes"/>
                        </xsl:if>
                        <xsl:if test="$promos/defaults/message/tooltip != ''">
                            <div class="tooltip">
                                <xsl:value-of select="$promos/defaults/message/tooltip" disable-output-escaping="yes"/>
                            </div>
                        </xsl:if>
                    </div>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>


    <!-- 
    Adds promo messaging to location. Loops through the active promos and outputs content from the message node
    USAGE: 
        <xsl:call-template name="promoMessage">
            <xsl:with-param name="id" select="$id"/> 
            <xsl:with-param name="phone" select="$phone"/> 
            <xsl:with-param name="products-feed" select="$products-feed"/>
        </xsl:call-template>
    -->
     <xsl:template name="promoTag">
         <xsl:param name="id"/>
         <xsl:param name="phone"/>
         <xsl:param name="products-feed"/>
         
         <!-- Get pricing -->
         <xsl:variable name="sale-price" select="$products-feed/product[@id = $id]/@sale-price"/>
         <xsl:variable name="original-price" select="$products-feed/product[@id = $id]/@original-price"/>
         
         <div>
             <xsl:attribute name="class">
                 <xsl:text>phonePromo</xsl:text>
                 <xsl:if test="$sale-price != $original-price"> show promo_<xsl:value-of select="round($original-price - $sale-price)"/>dol_off promo_<xsl:value-of select="round($original-price div 100 * $sale-price)"/>percent_off</xsl:if>
                 <!-- Loop through the active promos-->
                 <xsl:for-each select="$promos/promo[@active = 'true']">
                     <!-- Now loop through the phone detail payloads -->
                     <xsl:for-each select="phones/payload">
                         <!-- If SKU is present and the onsale or webonly tag is set to true, display tag-->
                         <xsl:if test="(@onSale = 'true' or @webOnly = 'true') and (@skus = 'all' or contains(@skus, $id) or (@skus = 'cpo' and $phone/options/@cpo = 'true') or (@skus = 'new' and $phone/options/@cpo != 'true'))"> show</xsl:if>
                         <!-- If webonly is set, add webonly class -->
                         <xsl:if test="@webOnly = 'true' and (@skus = 'all' or contains(@skus, $id) or (@skus = 'cpo' and $phone/options/@cpo = 'true') or (@skus = 'new' and $phone/options/@cpo != 'true'))"> promo_webonly</xsl:if>
                     </xsl:for-each>
                 </xsl:for-each>
             </xsl:attribute>
             
             <!-- Loop through the active promos-->
             <xsl:for-each select="$promos/promo[@active = 'true']">
                 
                 <!-- Check if there is a master sales tag-->
                 <xsl:if test="salesTag/@imageName != '' ">
                     <xsl:attribute name="style">
                         background-image: url('<xsl:value-of select="concat(@imgFolder , salesTag/@imageName)"/>')!important;
                         <xsl:if test="salesTag/@isSingle = 'true' "> background-position: 0px 0px!important;</xsl:if>
                     </xsl:attribute>
                 </xsl:if>
                  
                 <!-- Check if there is a phone specific tag and override the master tag -->       
                 <xsl:for-each select="phones/payload">
                     <xsl:if test="salesTag/@imageName != '' and (@skus = 'all' or contains(@skus, $id) or (@skus = 'cpo' and $phone/options/@cpo = 'true') or (@skus = 'new' and $phone/options/@cpo != 'true'))">
                         <xsl:attribute name="style">
                             background-image: url('<xsl:value-of select="concat(../../@imgFolder , salesTag/@imageName)"/>')!important;
                             <xsl:if test="salesTag/@isSingle = 'true' "> background-position: 0px 0px!important;</xsl:if>
                         </xsl:attribute>
                     </xsl:if>
                 </xsl:for-each>
                 
             </xsl:for-each>
             
             <!-- Add this crap for usablenet -->
             <xsl:attribute name="data-usablenet-promoImg">/_themes/libs/images/tags-phone-pages2.png</xsl:attribute>
         </div>
     </xsl:template>
</xsl:stylesheet>