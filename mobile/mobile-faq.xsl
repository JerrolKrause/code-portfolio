<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
    Document   : mobile-faq.xsl
    Author     : Jerrol 
    Description: 
        Template for mobile faqs section
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:output method="html"/>

    <!--
    Template for mobile faqs
    -->
    <xsl:template name="mobile-faq">
        
        
       <!-- Variables-->
        <xsl:variable name="faq-nav-path" select="document(##REMOVED##)/page/content/faqs-nav/nav" />
        <xsl:variable name="pageID">
            <xsl:call-template name="makeSlug">
                <xsl:with-param name="string" select="/page/content/faqs/title" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pageName">
            <xsl:value-of select="/page/content/faqs/title" disable-output-escaping="yes"/>
        </xsl:variable>
        <xsl:variable name="catPage" select="$faq-nav-path//../*[@label = $pageName]"/>
        
        <!-- Figure out where the faqs content lives on WWW -->
        <xsl:variable name="pagePath">
            <xsl:text>##REMOVED##</xsl:text>
            <xsl:if test="$catPage/../../@label">
                <xsl:call-template name="makeSlug">
                    <xsl:with-param name="string" select="$catPage/../../@label" />
                </xsl:call-template>
                <xsl:text>/</xsl:text>
            </xsl:if>
            <xsl:if test="$catPage/../@label">
                <xsl:call-template name="makeSlug">
                    <xsl:with-param name="string" select="$catPage/../@label" />
                </xsl:call-template>
                <xsl:text>/</xsl:text>
            </xsl:if>
            <xsl:if test="$catPage/@label">
                <xsl:call-template name="makeSlug">
                    <xsl:with-param name="string" select="$catPage/@label" />
                </xsl:call-template>
                <xsl:text>.xml</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="pageContent"  select="document($pagePath)/page/content"/>
         
        
        <!-- Start content area -->
        <div class="content">
            <div id="faqs-content">
                <div id="faqs-content-main">
                    
                    <h1><xsl:value-of select="/page/content/faqs/title" disable-output-escaping="yes"/></h1>
                    <p><xsl:value-of select="$pageContent/faqs/description" disable-output-escaping="yes"/></p>
                    
                    <a id="faqs-nav" href="/m/support/faq/">FAQs Home</a>
                    
                    <div><xsl:value-of select="/page/content/main" disable-output-escaping="yes"/></div>
                    
                    <!-- Check if this is a category page, output category list -->
                    <xsl:if test="count($catPage/nav) &gt; 0">
                        <!-- This could be better, XSL limitation -->
                        <!-- Make sure this the URL/slug has all of the ancestor nodes to maintain the full path -->
                        <xsl:variable name="catSlug">
                            <xsl:if test="$catPage/../../@label">
                                <xsl:call-template name="makeSlug">
                                    <xsl:with-param name="string" select="$catPage/../../@label" />
                                </xsl:call-template>
                                <xsl:text>/</xsl:text>
                            </xsl:if>
                            <xsl:if test="$catPage/../@label">
                                <xsl:call-template name="makeSlug">
                                    <xsl:with-param name="string" select="$catPage/../@label" />
                                </xsl:call-template>
                                <xsl:text>/</xsl:text>
                            </xsl:if>
                            <xsl:if test="$catPage/@label">
                                <xsl:call-template name="makeSlug">
                                    <xsl:with-param name="string" select="$catPage/@label" />
                                </xsl:call-template>
                                <xsl:text>/</xsl:text>
                            </xsl:if>
                        </xsl:variable>
                    
                        <!-- Pass data to faq output template -->
                        <div id="faq-output" class="faq-categories">
                            <xsl:call-template name="faqs-nav">
                                <xsl:with-param name="nav" select="$catPage/nav"/>  
                                <xsl:with-param name="pageID" select="$pageID"/>  
                                <xsl:with-param name="slug" select="concat('/m/support/faq/' , $catSlug)"/>  
                            </xsl:call-template>
                        </div>
                        
                    </xsl:if>
                  
                    
                    <!-- Output FAQ Q/A's -->
                    <xsl:if test="count($pageContent/faqs/faq) &gt; 0">
                        <div id="faq-output" class="accordion">
                            <xsl:for-each select="$pageContent/faqs/faq">
                                <div class="faq-answer">
                                    <h2>
                                        <a class="gradient-orange rounded-5 faq-btn" href="#">
                                            <xsl:attribute name="name">
                                                <xsl:call-template name="makeSlug">
                                                    <xsl:with-param name="string" select="question" />
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:value-of select="question" disable-output-escaping="yes"/>
                                        </a>
                                    </h2>
                                    
                                    <div class="faq-answer-content">
                                        <xsl:value-of select="answer" disable-output-escaping="yes"/>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:if>
                    
                </div>
            </div>
        </div>
       
    </xsl:template>
</xsl:stylesheet>