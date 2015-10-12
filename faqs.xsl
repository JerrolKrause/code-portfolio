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
<!--     
    Document   : faqs.xsl
    Created on : Aug 13, 2015
    Author     : Jerrol
    Description: The XSL transform file for the FAQs section
        
--> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:output method="html" /> 

    
    <!--  
    Template for FAQs Page 
    --> 
    <xsl:template name="support-faqs">
        <!-- Load the faq nav into a variable from faqs.xml -->
        <xsl:variable name="faq-nav-path" select="document('##REMOVED##'" />
        <xsl:variable name="pageID">
            <xsl:call-template name="makeSlug">
                <xsl:with-param name="string" select="/page/content/faqs/title" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pageName">
            <xsl:value-of select="/page/content/faqs/title" disable-output-escaping="yes"/>
        </xsl:variable>
        <xsl:variable name="catPage" select="$faq-nav-path//../*[@label = $pageName]"/>
       
        <!-- Output breacrumbs -->
        <div class="breadcrumbs">
            <div itemscope="itemscope" itemtype="http://data-vocabulary.org/Breadcrumb">
                <a href="/" itemprop="url">
                    <span itemprop="title">Home</span>
                </a> &#160;&gt;&#160;
            </div>  
            <div itemscope="itemscope" itemtype="http://data-vocabulary.org/Breadcrumb">
                <a href="/support/" itemprop="url">
                    <span itemprop="title">Support</span>
                </a> &#160;&gt;&#160;
            </div>  
            <!-- Adjust the breadcrumbs if we are on the root FAQ page. At somepoint we need to add in the full tree not just the current page -->
            <xsl:choose>
                <xsl:when test="/page/content/faqs-nav">
                    <div itemscope="itemscope" itemtype="http://data-vocabulary.org/Breadcrumb">
                        <span itemprop="title">
                            <xsl:value-of select="/page/content/faqs/title"/> FAQs</span>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div itemscope="itemscope" itemtype="http://data-vocabulary.org/Breadcrumb">
                        <a href="/support/faq/" itemprop="url">
                            <span itemprop="title">FAQs</span>
                        </a> &#160;&gt;&#160;
                    </div>  
                    <div itemscope="itemscope" itemtype="http://data-vocabulary.org/Breadcrumb">
                        <span itemprop="title">
                            <xsl:value-of select="/page/content/faqs/title"/> FAQs</span>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        
        {{social}}
        <div class="h1">Frequently Asked Questions</div>

        <div id="faqs">
            
            <!-- Sidebar + Navigation -->
            <div id="faqs-sidebar">
                <div id="faqs-nav">
                    <div class="title gradient-black">
                        <h3><a href="/support/faq/">FAQs</a></h3>
                    </div>
                  
                    <!-- Create sidebar nav -->
                    <xsl:call-template name="faqs-nav">
                        <xsl:with-param name="nav" select="$faq-nav-path"/>  
                        <xsl:with-param name="pageID" select="$pageID"/>  
                        <xsl:with-param name="slug" select="'/support/faq/'"/> 
                    </xsl:call-template>
                   
                    <div class="title gradient-black"> 
                        <h3><a href="http://devicehelp.boostmobile.com/">Device Support</a></h3> 
                    </div>
                    <div class="title gradient-black"> 
                        <h3><a href="/about/legal/">Legal &amp; Service Policies</a></h3> 
                    </div>
                    <div class="title gradient-black"> 
                        <h3><a href="/support/contact-customer-service/">Contact Us</a></h3> 
                    </div>
                    
                    <div id="faqs-sidebar-sub">
                        <p>
                            <strong>General Support</strong>
                            <br/>
                            1-866-402-7366 </p>
                        <p>
                            <strong>Business Hours</strong>
                            <br/>
                            Mon-Fri: 4am - 8pm PST<br/>
                            Sat/Sun: 4am - 7pm PST</p>
                        <p><a href="http://newsroom.sprint.com/article_display.cfm?article_id=1473">Important 9-1-1 Info</a></p>
                    </div>
                </div>
            </div>
            
            <!-- Main content area  -->
            <div id="faqs-content">
                <div id="faqs-content-main">
                    
                    <a name="top" id="top"></a>
                    <xsl:value-of select="/page/content/main" disable-output-escaping="yes"/>
                    
                    <div id="faqs-header">
                        <h1><xsl:value-of select="/page/content/faqs/title" disable-output-escaping="yes"/></h1>
                        <p><xsl:value-of select="/page/content/faqs/description" disable-output-escaping="yes"/></p>
                        <hr/>
                    </div>
                    
                    <!-- Check if this is a category page -->
                    <xsl:if test="count($catPage) &gt; 0">
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
                        
                        <!-- Output this page's children onto the page as clickable links in the main content area -->
                        <div id="faq-output" class="faq-categories">
                            <xsl:call-template name="faqs-nav">
                                <xsl:with-param name="nav" select="$catPage/nav"/>  
                                <xsl:with-param name="pageID" select="$pageID"/>  
                                <xsl:with-param name="slug" select="concat('/support/faq/' , $catSlug )"/>  
                            </xsl:call-template>
                        </div>
                    </xsl:if>
                    
                    
                    <!-- If this page has FAQ Q&As, output them onto the page -->
                    <xsl:if test="count(/page/content/faqs/faq) &gt; 0">
                        <div id="faq-output">
                            
                            <!-- Output a list of clickable questions at the top of the page -->
                            <div id="faq-questions">
                                <xsl:for-each select="/page/content/faqs/faq">
                                    <div class="faq-question">
                                        <p>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:text>#</xsl:text>
                                                    <xsl:call-template name="makeSlug">
                                                        <xsl:with-param name="string" select="question" />
                                                    </xsl:call-template>
                                                </xsl:attribute>
                                                <xsl:value-of select="question" disable-output-escaping="yes"/>
                                            </a>
                                        </p>
                                    </div>
                                </xsl:for-each>
                                <hr/> 
                            </div>
                            
                            <!-- Output the question and answers in the main content area -->
                            <div id="faq-answers">
                                <xsl:for-each select="/page/content/faqs/faq">
                                    <div class="faq-answer">
                                        <a href="#top" class="top">(top)</a>
                                        <h2>
                                            <a>
                                                <xsl:attribute name="name">
                                                    <xsl:call-template name="makeSlug">
                                                        <xsl:with-param name="string" select="question" />
                                                    </xsl:call-template>
                                                </xsl:attribute>
                                                <xsl:value-of select="question" disable-output-escaping="yes"/>
                                            </a>
                                        </h2>
                                        <xsl:value-of select="answer" disable-output-escaping="yes"/>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:if>
                    
                </div>
            </div>
            <div style="clear:both;"></div>
        </div>
    
        <xsl:value-of select="/page/content/footer" disable-output-escaping="yes" /> 
    </xsl:template>


    <!--
    Create FAQ navigation
        $nav    - A block of XML nodes from FAQs.xml
        $pageID - The current page label converted to a slug
        $slug  - The URL/path of all the ancestor nodes
    -->
    <xsl:template name="faqs-nav">
        <xsl:param name="nav" />
        <xsl:param name="pageID" />
        <xsl:param name="slug" />
        
        <ul>
            <xsl:attribute name="id">  
                <xsl:call-template name="makeSlug">
                    <xsl:with-param name="string" select="@label" />
                </xsl:call-template>
            </xsl:attribute> 
            
            <!-- Output all nav items -->
            <xsl:for-each select="$nav">
                
                <xsl:variable name="id">
                    <xsl:call-template name="makeSlug">
                        <xsl:with-param name="string" select="@label" />
                    </xsl:call-template>
                </xsl:variable>
                   
                <li>
                    <!-- If this is a category node and has children nodes -->
                    <xsl:if test="count(nav)">
                        <xsl:attribute name="class">dropdown</xsl:attribute>
                    </xsl:if>
                    
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="@link">
                                    <xsl:value-of select="@link"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$slug"/>
                                    <xsl:value-of select="$id"/>/</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <!-- If the page ID found in faq.xml matches the description in the page xml file -->
                        <xsl:if test="$pageID = $id">
                            <xsl:attribute name="class">active</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@label"/>
                    </a>
            
                    <!-- Recursively call this function to output any child nodes -->
                    <xsl:if test="count(nav)">
                        <xsl:call-template name="faqs-nav">
                            <xsl:with-param name="nav" select="./nav"/>  
                            <xsl:with-param name="pageID" select="$pageID"/>  
                            <xsl:with-param name="slug" select="concat( $slug , $id , '/'  )"/>  
                        </xsl:call-template>
                    </xsl:if>
            
                </li>
            
            </xsl:for-each>
        </ul>
    </xsl:template>
    
</xsl:stylesheet>