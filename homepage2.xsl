<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet []>

<!--
    Document   : homepage2.xsl 
    Created on : September 15, 2014
    Author     : Jerrol  
    Description:
        This is the XSL file that powers the homepage
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:my-ext="java" extension-element-prefixes="my-ext" xmlns:Math="http://www.math.org/">
    <xsl:output method="html"/>

    <!-- Main Template for Homepage-->
    <xsl:template name="homepage2">
        
        <div id="home">
            
            <!-- Top Row (1) -->
            <xsl:call-template name="homepage2-panel" >
                <xsl:with-param name="row" select="'1'" />
            </xsl:call-template>
            
            <!-- Call phone genie template-->
            <xsl:call-template name="genie3" />

            <!-- Red Ventures Content-->
            <div class="visitor bn-b">
                <xsl:comment> mp_trans_remove_start </xsl:comment>
                <div class="red-ventures">New Customers! Call our live experts to pick your perfect phone &amp; plan <span class="bn-bk">Call Now! 1-855-364-9032</span></div>
                <div class="red-ventures rv-wwwbm">New Customers! Call our live experts to pick your perfect phone &amp; plan <span class="bn-bk">Call Now! 1-855-388-6771</span></div>
                <div class="red-ventures rv-buybm ">New Customers! Call our live experts to pick your perfect phone &amp; plan <span class="bn-bk">Call Now! 1-855-388-7889</span></div>
                <xsl:comment> mp_trans_remove_end </xsl:comment>
                <xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_add]]></xsl:text> 
                <div class="red-ventures">New Customers! Call our live experts to pick your perfect phone &amp; plan <span>Call Now! 1-855-386-4828</span></div>
                <xsl:text disable-output-escaping="yes"><![CDATA[-->]]></xsl:text>
            </div>
            
            <!-- Middle Row (2) -->
            <xsl:call-template name="homepage2-panel" >
                 <xsl:with-param name="row" select="'2'" />
            </xsl:call-template>
            
             <!-- Web banners from promotion engine-->
            <xsl:call-template name="webbanner">
                <xsl:with-param name="tracking" select="'HP_Banner'"/>
                <xsl:with-param name="banners" select="$promos/promo[@active = 'true']/banner[@home = 'true']"/> 
            </xsl:call-template>

            <!-- Bottom Row (3) -->
            <xsl:call-template name="homepage2-panel" >
                 <xsl:with-param name="row" select="'3'" />
            </xsl:call-template>
            
            <!-- Web banners bottom from promotion engine-->
            <xsl:call-template name="webbanner">
                <xsl:with-param name="tracking" select="'HP_Banner2'"/>
                <xsl:with-param name="banners" select="$promos/promo[@active = 'true']/banner[@home2 = 'true']"/> 
            </xsl:call-template>
        
        
         <!-- Subtitles -->
        <div id="subtiles">
            
            <!-- 1st Position -->
            <xsl:call-template name="homepage2-tile" >
                 <xsl:with-param name="position" select="'1'" />
            </xsl:call-template>
            
            <!-- 2nd Position -->
            <xsl:call-template name="homepage2-tile" >
                 <xsl:with-param name="position" select="'2'" />
            </xsl:call-template>
            
            <!-- 3rd Position -->
            <xsl:call-template name="homepage2-tile" >
                 <xsl:with-param name="position" select="'3'" />
            </xsl:call-template>
            
            <!-- 4th Position -->
            <xsl:call-template name="homepage2-tile" >
                 <xsl:with-param name="position" select="'4'" />
            </xsl:call-template>
            
             <div style="clear:both;"></div>
        </div>


        <!-- This code block is used by google to identify our custom search engine -->
        <div itemscope="itemscope" itemtype="http://schema.org/WebSite" style="display:none;">
            <meta itemprop="url" content="http://www.boostmobile.com/"/>
            <form itemprop="potentialAction" itemscope="itemscope" itemtype="http://schema.org/SearchAction" action="http://www.boostmobile.com/search/" method="get">
              <meta itemprop="target" content="http://www.boostmobile.com/search/?q={q}"/>
              <input itemprop="query-input" type="text" name="q" required="required"/>
              <input type="submit"/>
            </form>
        </div>
        <div style="clear:both;"></div>
       
        </div>
    </xsl:template> 
    
    
    <!-- #####################
    Template for the main homepage panels
    While complex, this code is intended to fully automate panel creation and add all the required code for the 4 homepage permutation
    There are also addition to support the preview mode which is managed by the queryParam node
    ######################### -->
    <xsl:template name="homepage2-panel">
        <xsl:param name="row" />
        
            <!-- Visitor Panels -->
            <div class="visitor row">
                
                <!-- English Panels.  -->
                <!-- Preview Mode: check if language parameter is set -->
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)">
                    <!-- Add motionpoint directive tags -->
                    <xsl:comment> mp_trans_remove_start </xsl:comment>
                        <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/english/visitor/panel[@row = $row][@column = '1']/@id]" disable-output-escaping="yes"/>
                        <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/english/visitor/panel[@row = $row][@column = '2']/@id]" disable-output-escaping="yes"/>
                    <xsl:comment> mp_trans_remove_end </xsl:comment>
                </xsl:if>
                
                <!-- Spanish Panels -->
                <!-- Preview Mode: Check if language parameter is set AND the notranslate node is set. If not add in motionpoint directive tags -->
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/visitor/panel[@row = $row][@column = '1']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text></xsl:if>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_add]]></xsl:text></xsl:if>
                    <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/visitor/panel[@row = $row][@column = '1']/@id]" disable-output-escaping="yes"/>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[-->]]></xsl:text></xsl:if>
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/visitor/panel[@row = $row][@column = '1']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text></xsl:if>
                
                <!-- Preview Mode: Check if language parameter is set AND the notranslate node is set. If not add in motionpoint directive tags -->
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/visitor/panel[@row = $row][@column = '2']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text></xsl:if>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_add]]></xsl:text></xsl:if>
                    <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/visitor/panel[@row = $row][@column = '2']/@id]" disable-output-escaping="yes"/>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[-->]]></xsl:text></xsl:if>
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/visitor/panel[@row = $row][@column = '2']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text></xsl:if>
            </div>
            
            
            <!-- Customer Panels-->
            <div class="customer row">
                
                <!-- English Panels -->
                <!-- Preview Mode: check if language parameter is set -->
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)">
                    <xsl:comment> mp_trans_remove_start </xsl:comment>
                        <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/english/customer/panel[@row = $row][@column = '1']/@id]" disable-output-escaping="yes"/>
                        <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/english/customer/panel[@row = $row][@column = '2']/@id]" disable-output-escaping="yes"/>
                    <xsl:comment> mp_trans_remove_end </xsl:comment>
                </xsl:if>
                
                <!-- Spanish Panels -->
                <!-- Preview Mode: Check if language parameter is set AND the notranslate node is set. If not add in motionpoint directive tags -->
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/customer/panel[@row = $row][@column = '1']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text></xsl:if>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_add]]></xsl:text></xsl:if>
                    <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/customer/panel[@row = $row][@column = '1']/@id]" disable-output-escaping="yes"/>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[-->]]></xsl:text></xsl:if>
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/customer/panel[@row = $row][@column = '1']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text></xsl:if>
                
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/customer/panel[@row = $row][@column = '2']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text></xsl:if>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_add]]></xsl:text></xsl:if>
                    <xsl:value-of select="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/customer/panel[@row = $row][@column = '2']/@id]" disable-output-escaping="yes"/>
                <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[-->]]></xsl:text></xsl:if>
                <xsl:if test="/page/content/panels/panel[@id = /page/content/panelOrder/spanish/customer/panel[@row = $row][@column = '2']/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text></xsl:if>
            </div>
       
        <div style="clear:both;"></div>
    </xsl:template>
  
  
  <!-- ##################### 
    Template for the homepage tiles
    ######################### -->
    <xsl:template name="homepage2-tile">
        <xsl:param name="position" />
        
        <!-- Visitor English Tile -->
        <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)">
            <xsl:comment> mp_trans_remove_start </xsl:comment>
            <div class="subtile visitor">
                <xsl:attribute name="id"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/visitor/tile[position() = $position]/@id]/@id"/></xsl:attribute>
                <xsl:if test="$position = 4"><xsl:attribute name="class">subtile visitor last</xsl:attribute></xsl:if>
                <h2 class="bn-b"><a><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/visitor/tile[position() = $position]/@id]/@url"/></xsl:attribute>
                <xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/visitor/tile[position() = $position]/@id]/title" disable-output-escaping="yes"/></a></h2>
                <p><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/visitor/tile[position() = $position]/@id]/description" disable-output-escaping="yes"/></p>
                <a class="arrow"><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/visitor/tile[position() = $position]/@id]/@url"/></xsl:attribute>Learn More</a>
            </div>
            <xsl:comment> mp_trans_remove_end </xsl:comment>
        </xsl:if>
        
        <!-- Visitor Spanish Tile -->
        <xsl:if test="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/visitor/tile[position() = $position]/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text></xsl:if>
             <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_add]]></xsl:text></xsl:if>
                <div class="subtile visitor">
                    <xsl:attribute name="id"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/visitor/tile[position() = $position]/@id]/@id"/></xsl:attribute>
                    <xsl:if test="$position = 4"><xsl:attribute name="class">subtile visitor last</xsl:attribute></xsl:if>
                    <h2 class="bn-b"><a><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/visitor/tile[position() = $position]/@id]/@url"/></xsl:attribute>
                    <xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/visitor/tile[position() = $position]/@id]/title" disable-output-escaping="yes"/></a></h2>
                    <p><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/visitor/tile[position() = $position]/@id]/description" disable-output-escaping="yes"/></p>
                    <a class="arrow"><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/visitor/tile[position() = $position]/@id]/@url"/></xsl:attribute>Learn More</a>
                </div>
            <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[-->]]></xsl:text></xsl:if>
        <xsl:if test="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/visitor/tile[position() = $position]/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text></xsl:if>
        
        <!-- Customer English Tile -->
        <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)">
            <xsl:comment> mp_trans_remove_start </xsl:comment>
            <div class="subtile customer">
                <xsl:attribute name="id"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/customer/tile[position() = $position]/@id]/@id"/></xsl:attribute>
                <xsl:if test="$position = 4"><xsl:attribute name="class">subtile customer last</xsl:attribute></xsl:if>
                <h2 class="bn-b"><a><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/customer/tile[position() = $position]/@id]/@url"/></xsl:attribute>
                <xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/customer/tile[position() = $position]/@id]/title" disable-output-escaping="yes"/></a></h2>
                <p><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/customer/tile[position() = $position]/@id]/description" disable-output-escaping="yes"/></p>
                <a class="arrow"><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/english/customer/tile[position() = $position]/@id]/@url"/></xsl:attribute>Learn More</a>
            </div>
            <xsl:comment> mp_trans_remove_end </xsl:comment>
        </xsl:if>
        
        <!-- Customer Spanish Tile -->
        <xsl:if test="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/customer/tile[position() = $position]/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_start -->]]></xsl:text></xsl:if>
             <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_add]]></xsl:text></xsl:if>
                <div class="subtile customer">
                    <xsl:attribute name="id"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/customer/tile[position() = $position]/@id]/@id"/></xsl:attribute>
                    <xsl:if test="$position = 4"><xsl:attribute name="class">subtile customer last</xsl:attribute></xsl:if>
                    <h2 class="bn-b"><a><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/customer/tile[position() = $position]/@id]/@url"/></xsl:attribute>
                    <xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/customer/tile[position() = $position]/@id]/title" disable-output-escaping="yes"/></a></h2>
                    <p><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/customer/tile[position() = $position]/@id]/description" disable-output-escaping="yes"/></p>
                    <a class="arrow"><xsl:attribute name="href"><xsl:value-of select="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/customer/tile[position() = $position]/@id]/@url"/></xsl:attribute>Learn More</a>
                </div>
            <xsl:if test="/page/server/queryParams/param[@key = 'lang']/@value != 'esp' or not(/page/server/queryParams/param[@key = 'lang']/@value)"><xsl:text disable-output-escaping="yes"><![CDATA[-->]]></xsl:text></xsl:if>
        <xsl:if test="/page/content/subtiles/tile[@id = /page/content/tileOrder/spanish/customer/tile[position() = $position]/@id]/@no-translate = 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<!-- mp_trans_disable_end -->]]></xsl:text></xsl:if>
        
    </xsl:template>
</xsl:stylesheet>

