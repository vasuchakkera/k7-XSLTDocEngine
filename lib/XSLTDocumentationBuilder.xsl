<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:k7="http://www.k7-Xsuites.com">
	<xsl:output method="html"/>
	<xsl:variable name="global-vars" select="/*:stylesheet/*:variable/@name"/>
	<xsl:variable name="local-template-params"
		select="//*:template/*:param/concat(parent::*/@name, '_', @name)"/>
	<xsl:variable name="local-function-params"
		select="//*:function/*:param/concat(parent::*/@name, '_', @name)"/>
	<xsl:variable name="global-keys" select="//*:key/@name"/>
	<xsl:variable name="functions" select="//*:function/@name"/>
	<xsl:variable name="named-templates" select="//*:template/@name"/>
	<xsl:variable name="operators"
		select="
			('(',
			')',
			'+',
			'-',
			'=',
			'*',
			'$',
			'/',
			':',
			',')"/>
	<xsl:variable name="source-name" select="tokenize(document-uri(/), '/')[last()]"/>
	<xsl:variable name="version-control" select="document('../doc.config/versioncontrol.xml')"/>
	<xsl:variable name="config-file-name"
		select="concat('../doc.config/', substring-before($source-name, '.xsl'), '.doc.xml')"/>
	<xsl:variable name="doc-config-file" select="document($config-file-name)"/>
	<xsl:variable name="css-styles" select="document('cssfile.xml')"/>
	<xsl:template match="*:stylesheet | *:transform">
		<!-- Template by html.am -->
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<title>
					<xsl:value-of select="$source-name"/>
				</title>
				<style type="text/css">
					<xsl:copy-of select="$css-styles/css/text()"/>
				</style>
				<script type="text/javascript">
				</script>
			</head>
			<body>
				<header id="header">
					<div class="innertube" align="center" style="margin-bottom:5px">
						<h2>
							<xsl:text>Stylesheet Documentation for the XSL : </xsl:text>
							<xsl:value-of select="$source-name"/>
							<br/>
							<br/>
						</h2>
					</div>
				</header>
				<main>
					<div class="innertube">
						<div>
							<h3>
								<a name="version-control"/>Version Control</h3>
							<xsl:for-each select="$version-control/descendant::*:version-control/*">
								<li>
									<xsl:value-of select="name()"/>: <xsl:value-of select="."/>
								</li>
							</xsl:for-each>
						</div>
						<div>
							<a name="xslt-version"/>
							<h3>XSLT Version </h3>
							<xsl:text>The current XSLT is written in XSLT version </xsl:text>
							<b>
								<xsl:value-of select="/*[1]/@version"/>
							</b>
						</div>
						<div>
							<a name="intro"/>
							<xsl:apply-templates select="$doc-config-file/descendant::*:article"
								mode="doc-config"/>
							<br/>
						</div>
						<xsl:for-each select="*:include | *:import">
							<xsl:apply-templates select="."/>
						</xsl:for-each>
						<xsl:if test="*:key">
							<a name="key"/>
							<h3>Key Definitions</h3>
							<table style="table-layout: fixed; width: 100%" border="1">
								<tbody>
									<tr>
										<th>Key Name</th>
										<th>Matches</th>
										<th>Uses</th>
									</tr>
									<xsl:for-each select="*:key">
										<xsl:sort order="ascending" select="@name"/>
										<xsl:apply-templates select="."/>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:if>
						<xsl:if test="*:variable">
							<a name="vars"/>
							<h3>Global Variable Definitions</h3>
							<table style="table-layout: fixed; width: 100%" border="1">
								<tbody>
									<tr>
										<th colspan="40%">Variabe Name</th>
										<th colspan="60%">Selects</th>
									</tr>
									<xsl:for-each select="*:variable[not(*)]">
										<xsl:sort order="ascending" select="@name"/>
										<xsl:apply-templates select="." mode="loop"/>
									</xsl:for-each>
									<xsl:for-each select="*:variable[(*)]">
										<xsl:sort order="ascending" select="@name"/>
										<xsl:apply-templates select="." mode="loop"/>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:if>
						<xsl:if test="*:template[@name]">
							<a name="n-template"/>
							<h3>Named Templates</h3>
							<table style="table-layout: fixed; width: 100%" border="1">
								<xsl:for-each-group select="*:template[@name]"
									group-adjacent="(position() - 1) idiv 4">
									<xsl:sort order="ascending" select="@name"/>
									<tr>
										<xsl:for-each select="current-group()">
											<td>
												<a href="#Template{@name}">
												<xsl:value-of select="@name"/>
												</a>
											</td>
										</xsl:for-each>
									</tr>
								</xsl:for-each-group>
							</table>
						</xsl:if>
						<xsl:if test="*:template[@match]">
							<a name="m-template"/>
							<h3>Matched Templates</h3>
							<table style="table-layout: fixed; width: 100%" border="1">
								<xsl:for-each-group select="*:template[@match]"
									group-adjacent="(position() - 1) idiv 4">
									<xsl:sort order="ascending" select="@match"/>
									<tr>
										<xsl:for-each select="current-group()">
											<td>
												<a href="#Template{@match}">
												<xsl:value-of select="@match"/>
												</a>
											</td>
										</xsl:for-each>
									</tr>
								</xsl:for-each-group>
							</table>
						</xsl:if>
						<xsl:if test="*:function">
							<a name="function"/>
							<h3>Functions List</h3>
							<table style="table-layout: fixed; width: 100%" border="1">
								<xsl:for-each-group select="*:function"
									group-adjacent="(position() - 1) idiv 4">
									<xsl:sort order="ascending" select="@name"/>
									<tr>
										<xsl:for-each select="current-group()">
											<td>
												<a href="#Template{@name}">
												<xsl:value-of select="@name"/>
												</a>
											</td>
										</xsl:for-each>
									</tr>
								</xsl:for-each-group>
							</table>
						</xsl:if>
						<xsl:if test="*:template[@match]">
							<a name="m-template"/>
							<h3>Match Template Definitions</h3>
							<xsl:for-each select="*:template[@match]">
								<xsl:sort order="ascending" select="@match"/>
								<xsl:apply-templates select="."/>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="*:function">
							<h3>Function Definitions</h3>
							<xsl:for-each select="*:function">
								<xsl:sort order="ascending" select="@name"/>
								<xsl:apply-templates select="."/>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="*:template[@name]">
							<h3>Named Template Definitions</h3>
							<xsl:for-each select="*:template[@name]">
								<xsl:sort order="ascending" select="@name"/>
								<xsl:apply-templates select="."/>
							</xsl:for-each>
						</xsl:if>
					</div>
				</main>
				<nav id="nav">
					<div class="innertube">
						<h2>Table of contents</h2>
						<ul>
							<li>
								<a href="#version-control">Version Control</a>
							</li>
							<li>
								<a href="#xslt-version">XSLT Version</a>
							</li>
							<li>
								<a href="#intro">Introduction</a>
							</li>
							<xsl:if test="*:import">
								<li>
									<a href="#import">Imported Stylesheets </a>
								</li>
							</xsl:if>
							<xsl:if test="*:include">
								<li>
									<a href="#include">Include Stylesheets </a>
								</li>
							</xsl:if>
							<xsl:if test="*:key">
								<li>
									<a href="#key">Key definitions</a>
								</li>
							</xsl:if>
							<xsl:if test="*:variable">
								<li>
									<a href="#vars">Global Variables</a>
								</li>
							</xsl:if>
							<xsl:if test="*:template[@match]">
								<li>
									<a href="#m-template">Match Templates</a>
								</li>
							</xsl:if>
							<xsl:if test="*:template[@name]">
								<li>
									<a href="#n-template">Named Templates</a>
								</li>
							</xsl:if>
							<xsl:if test="*:function">
								<li>
									<a href="#function">Functions</a>
								</li>
							</xsl:if>
							<li>
								<a href="../index.html">XSLT Documentation Index</a>
							</li>
						</ul>
					</div>
				</nav>
				<footer id="footer">
					<div class="innertube" align="center" style="margin:5px">
						<p>Stylesheet Documentation Created by K7-Labs by Vasu Chakkera</p>
					</div>
				</footer>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="xsl:apply-imports">Invokes an overridden template rule.</xsl:template>
	<xsl:template match="xsl:apply-templates">
		<div> Directs the XSLT processor to find the appropriate template to apply,based on the
			select xpath : <xsl:value-of select="@select"/>
		</div>
	</xsl:template>
	<xsl:template match="xsl:attribute">
		<div> Create an attribute with the name <xsl:value-of select="@name"/> and value of
				<xsl:call-template name="print-text-with-hyperlinked-variables">
				<xsl:with-param name="text" select="@select"/>
			</xsl:call-template>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="xsl:attribute-set">Defines a named set of attributes.</xsl:template>
	<xsl:template match="xsl:call-template">
		<xsl:text>calls the  template "</xsl:text>
		<xsl:call-template name="print-text-with-hyperlinked-variables">
			<xsl:with-param name="text" select="@name"/>
		</xsl:call-template>
		<xsl:text>"</xsl:text>
		<div>
			<i style="color:grey">
				<xsl:text disable-output-escaping="yes">&amp;lt;!--</xsl:text>
				<xsl:text>The template that is being called can either be in the current XSLT or in the XSLT import/ include heirarchy.</xsl:text>
				<xsl:text disable-output-escaping="yes">--&amp;gt;</xsl:text>
			</i>
		</div>
	</xsl:template>
	<xsl:template match="xsl:choose">
		<div>
			<b> Value based one of the following conditions.</b>
		</div>
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="xsl:comment">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="xsl:sequence">
		<div>Produce a sequence of nodes or atomic values, specified by Xpath :</div>
		<xsl:call-template name="print-text-with-hyperlinked-variables">
			<xsl:with-param name="text" select="@select"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="comment()">
		<div>
			<i style="color:grey">
				<xsl:text disable-output-escaping="yes">&amp;lt;!--</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text disable-output-escaping="yes">--&amp;gt;</xsl:text>
			</i>
		</div>
	</xsl:template>
	<xsl:template match="xsl:copy">
		<div> Copies the current node from the source to the output. </div>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="xsl:copy-of">
		<div> Deep copy the elements defined by the Xpath : <xsl:call-template
				name="print-text-with-hyperlinked-variables">
				<xsl:with-param name="text" select="@select"/>
			</xsl:call-template> and all its children </div>
	</xsl:template>
	<xsl:template match="xsl:decimal-format">Declares a decimal-format, which controls the
		interpretation of a format pattern used by the format-number function.</xsl:template>
	<xsl:template match="xsl:element">Creates an element with the specified name in the output.
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="xsl:fallback">Calls template content that can provide a reasonable
		substitute to the behavior of the new element when encountered.</xsl:template>
	<xsl:template match="xsl:for-each">
		<div>
			<b>For each node in nodeset </b>
			<xsl:call-template name="print-text-with-hyperlinked-variables">
				<xsl:with-param name="text" select="@select"/>
			</xsl:call-template>
			<div style="padding:5">
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="print-variables">
		<xsl:variable name="global-or-local"
			select="
				if (ancestor::*:template) then
					'Local'
				else
					'Global'"/>
		<xsl:if test="*:variable">
			<h3>
				<xsl:value-of select="$global-or-local"/> Variable Definitions</h3>
			<table style="table-layout: fixed; width: 100%" border="1">
				<tbody>
					<tr>
						<th>Variabe Name</th>
						<th>Selects</th>
					</tr>
					<xsl:for-each select="*:variable[not(*)]">
						<xsl:sort order="ascending" select="@name"/>
						<xsl:apply-templates select="." mode="loop"/>
					</xsl:for-each>
					<xsl:for-each select="*:variable[(*)]">
						<xsl:sort order="ascending" select="@name"/>
						<xsl:apply-templates select="." mode="loop"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template match="xsl:if">
		<div>
			<xsl:text> If  the condition  </xsl:text>
			<xsl:call-template name="print-text-with-hyperlinked-variables">
				<xsl:with-param name="text" select="@test"/>
			</xsl:call-template>
			<xsl:text> is satisfied , then do : </xsl:text>
			<div style="margin:0.5cm">
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="xsl:include | xsl:import">
		<div>
			<xsl:if test="local-name() = 'include' and not(preceding-sibling::*:include)">
				<a name="include"/>
				<h3>Included Stylesheets</h3>
			</xsl:if>
			<xsl:if test="local-name() = 'import' and not(preceding-sibling::*:import)">
				<a name="import"/>
				<h3>Imported Stylesheets</h3>
			</xsl:if>
			<li>
				<a href="{substring-before(tokenize(@href,'/')[last()] , '.xsl')}.html">
					<xsl:value-of select="@href"/>
				</a>
			</li>
		</div>
	</xsl:template>
	<xsl:template match="xsl:key">
		<tr>
			<td>
				<a name="key{@name}"/>
				<xsl:value-of select="@name"/>
			</td>
			<td>
				<xsl:value-of select="@match"/>
			</td>
			<td>
				<xsl:value-of select="@use"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="xsl:message">
		<div style="border:1px solid grey; color:blue"> Sends a text message to message buffer ,
			generally used as a debug message in the console output.. <xsl:apply-templates/>
		</div> .</xsl:template>
	<xsl:template match="xsl:namespace-alias">Replaces the prefix associated with a given namespace
		with another prefix.</xsl:template>
	<xsl:template match="xsl:number">Inserts a formatted number into the result tree.</xsl:template>
	<xsl:template match="xsl:output">Specifies options for use in serializing the result
		tree.</xsl:template>
	<xsl:template match="xsl:preserve-space">Preserves white space in a document.</xsl:template>
	<xsl:template match="xsl:processing-instruction">Generates a processing instruction in the
		output.</xsl:template>
	<xsl:template match="xsl:sort">Specifies sort criteria for node lists selected by
		[xsl:for-each&gt; or [xsl:apply-templates&gt;.</xsl:template>
	<xsl:template match="xsl:strip-space">Strips white space from a document.</xsl:template>
	<xsl:template match="*:function | *:template">
		<xsl:variable name="name" select="lower-case(local-name())"/>
		<xsl:variable name="fn-name" select="@name"/>
		<xsl:variable name="local-name" select="local-name()"/>
		<div>
			<h4>
				<a name="Template{(@name,@match)[1]}">
					<xsl:value-of
						select="concat(upper-case(substring($name, 1, 1)), substring($name, 2, string-length($name)))"
					/> : <xsl:value-of select="
							(@name,
							@match)[1]"/>
				</a>
			</h4>
			<xsl:apply-templates
				select="
					($doc-config-file/descendant::*:function[@name = $fn-name],
					$doc-config-file/descendant::*:template[@name = $fn-name])[1]"
				mode="doc-config"/>
			<div>
				<xsl:if test="*:param">
					<xsl:text>This </xsl:text>
					<xsl:value-of select="$name"/>
					<xsl:text> is called with the following parameter.</xsl:text>
					<div>
						<xsl:for-each select="*:param">
							<li>
								<xsl:text> Name :</xsl:text>
								<a
									name="{(ancestor::*:template/@name , ancestor::*:function/@name)[1]}_{@name}"/>
								<xsl:value-of select="@name"/>
							</li>
						</xsl:for-each>
						<br/>
					</div>
				</xsl:if>
				<xsl:value-of
					select="
						if (not(fn:normalize-space(.)) and not(*)) then
							'No implementation for this template '
						else
							()"/>
				<xsl:apply-templates select="node()"/>
			</div>
		</div>
		<div>
			<hr style="margin-top:0.5cm; border-top:1px solid maroon;"/>
		</div>
	</xsl:template>
	<xsl:template match="xsl:text">
		<div>
			<xsl:text>Generate the text  " </xsl:text>
			<xsl:value-of select="."/>
			<xsl:text> " </xsl:text>
		</div>
	</xsl:template>
	<xsl:template match="xsl:variable" mode="loop">
		<xsl:choose>
			<xsl:when test="ancestor::*:variable">
				<xsl:apply-templates select="."/>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td colspan="40%" style="padding-left:0.5cm">
						<a name="{@name}"/>
						<xsl:value-of select="@name"/>
					</td>
					<td style="word-wrap: break-word" colspan="60%">
						<div style="word-wrap: break-word; padding-left:0.5cm">
							<xsl:choose>
								<xsl:when test="@select">
									<a name="{.}"/>
									<xsl:call-template name="print-text-with-hyperlinked-variables">
										<xsl:with-param name="text" select="@select"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="print-text-with-hyperlinked-variables">
		<xsl:param name="text"/>
		<xsl:variable name="variable-text" select="$text"/>
		<xsl:variable name="local-params"
			select="
				(ancestor::*:template,
				ancestor::*:function)[1]/*:param/@name"/>
		<xsl:variable name="local-variables"
			select="
				(ancestor::*:template,
				ancestor::*:function)[1]/descendant::*:variable/@name"/>
		<xsl:variable name="template-function-name"
			select="
				(ancestor::*:template,
				ancestor::*:function)[1]/@name"/>
		<xsl:variable name="hyperlink-variables-in-text">
			<xsl:copy-of
				select="k7:hyperlink-variables-in-text($variable-text, $local-params, $local-variables, $template-function-name)"
			/>
		</xsl:variable>
		<xsl:apply-templates select="$hyperlink-variables-in-text/node()" mode="hyperlink"/>
	</xsl:template>
	<xsl:template match="xsl:variable">
		<div style="color:maroon;margin:0.5cm">
			<li>
				<xsl:text>Variable </xsl:text>
				<u>
					<xsl:value-of select="@name"/>
				</u>
				<xsl:text> has the following definition </xsl:text>
				<xsl:if test="string-length(@select) > 10">
					<br/>
				</xsl:if>
				<span style="margin:0.5cm">
					<xsl:call-template name="print-text-with-hyperlinked-variables">
						<xsl:with-param name="text" select="@select"/>
					</xsl:call-template>
				</span>
			</li>
		</div>
	</xsl:template>
	<xsl:template match="xsl:variable[*]" priority="122">
		<tr>
			<td>
				<xsl:value-of select="@name"/>
			</td>
			<td>
				<xsl:apply-templates select="*"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="xsl:variable[*][ancestor::*:variable]" priority="122">
		<div style="color:maroon;margin:0.5cm">
			<li>
				<xsl:text>Variable </xsl:text>
				<u>
					<xsl:value-of select="@name"/>
				</u>
				<xsl:text> has the following definition </xsl:text>
				<xsl:if test="string-length(@select) > 10">
					<br/>
				</xsl:if>
				<span style="margin:0.5cm">
					<xsl:call-template name="print-text-with-hyperlinked-variables">
						<xsl:with-param name="text" select="@select"/>
					</xsl:call-template>
				</span>
			</li>
		</div>
	</xsl:template>
	<xsl:template match="xsl:when">
		<div>
			<xsl:text>when the condition :</xsl:text>
			<xsl:call-template name="print-text-with-hyperlinked-variables">
				<xsl:with-param name="text" select="@test"/>
			</xsl:call-template>
			<xsl:text> is satisfied , then do :</xsl:text>
			<div style="margin:0.5cm">
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="xsl:otherwise">
		<div>
			<xsl:text>If none of the above conditions are satisfied, then do : </xsl:text>
			<div style="padding-left:0.5cm">
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="xsl:value-of">
		<div>
			<xsl:text>Output the value of the node selected by XPATH : </xsl:text>
			<xsl:call-template name="print-text-with-hyperlinked-variables">
				<xsl:with-param name="text" select="@select"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template match="*[not(starts-with(name(), 'xsl')) and not(starts-with(name(), 'func'))]">
		<div style="padding-left:0.5cm">
			<span style="color:maroon">
				<xsl:text disable-output-escaping="yes"><![CDATA[&lt;]]></xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:for-each select="@*">
					<xsl:text> </xsl:text>
					<xsl:value-of select="name()"/>
					<xsl:text> = '</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>' </xsl:text>
				</xsl:for-each>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</span>
			<div style="padding-left:0.5cm">
				<xsl:apply-templates/>
			</div>
			<span style="color:maroon">
				<xsl:text disable-output-escaping="yes"><![CDATA[&lt;/]]></xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="xsl:with-param">Passes a parameter to a template.</xsl:template>
	<xsl:function name="k7:surround-special-chars-with-at-sign">
		<xsl:param name="string-with-var-name"/>
		<!--examples : 
$xxx,
,$xxx
($xxx
$xxx)
=$xxx
$xxx=
$xxx*
*$xxx
$xxx-
-$xxx
+$xxx
$xxx+

$xx+$yy-$zz

returns 
#xx
or xx# 
or #x#yy# etc.. replaces the operators after/before the variables to '#'

-->
		<xsl:variable name="new" select="replace($string-with-var-name, '\+', '@+@')"/>
		<xsl:variable name="new" select="replace($new, '=', '@=@')"/>
		<xsl:variable name="new" select="replace($new, ':', '@:@')"/>
		<xsl:variable name="new" select="replace($new, ',', '@,@')"/>
		<xsl:variable name="new" select="replace($new, '/', '@/@')"/>
		<xsl:variable name="new" select="replace($new, '\(', '@(@')"/>
		<xsl:variable name="new" select="replace($new, '\)', '@)@')"/>
		<xsl:variable name="new" select="replace($new, '\*', '@*@')"/>
		<xsl:variable name="new" select="replace($new, '\[', '@[@')"/>
		<xsl:variable name="new" select="replace($new, '\]', '@]@')"/>
		<xsl:variable name="new" select="replace($new, '''', '@''@')"/>
		<xsl:variable name="new" select="replace($new, '\$', '@$0@')"/>
		<xsl:variable name="new" select="replace($new, ' ', '@@')"/>
		<xsl:value-of select="$new"/>
	</xsl:function>
	<xsl:function name="k7:hyperlink-variables-in-text">
		<xsl:param name="variable-text"/>
		<xsl:param name="local-params"/>
		<xsl:param name="local-variables"/>
		<xsl:param name="template-function-name"/>
		<xsl:variable name="variable-names"
			select="k7:surround-special-chars-with-at-sign($variable-text)"/>
		<xsl:variable name="tokens">
			<xsl:for-each select="tokenize($variable-names, '@')">
				<token>
					<xsl:value-of select="."/>
				</token>
			</xsl:for-each>
		</xsl:variable>
		<!--[ ******
		<xsl:copy-of select="$tokens"/>
		]-->
		<xsl:for-each select="$tokens/token">
			<xsl:variable name="preceding-token" select="preceding-sibling::*:token[1]/text()"/>
			<xsl:variable name="following-token" select="following-sibling::*:token[1]/text()"/>
			<xsl:choose>
				<xsl:when test="(. = $global-keys)">
					<!--keys-->
					<a href="#key{.}">
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:when test="(. = $local-params) and preceding-sibling::*:token[1]/text() = '$'">
					<a href="#{$template-function-name}_{.}">
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:when
					test="(. = $local-variables) and preceding-sibling::*:token[1]/text() = '$'">
					<a href="#{$template-function-name}_{.}">
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:when test="(. = $global-vars) and preceding-sibling::*:token[1]/text() = '$'">
					<a href="#{.}">
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:when
					test="$preceding-token = ':' and $following-token = '(' and (concat(preceding-sibling::*:token[2]/text(), $preceding-token, .) = $functions)">
					<a
						href="#Template{concat(preceding-sibling::*:token[2]/text() ,$preceding-token, . )}">
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:when test=". = $named-templates">
					<a href="#Template{.}">
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
			<!--
after the text , add space or not?? add a space if the current text is not an operator and the following text is not an operator-->
			<xsl:choose>
				<xsl:when test=". = ($operators)"/>
				<xsl:when test="following-sibling::*[1]/text() = ($operators)"/>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	<xsl:template match="*" mode="hyperlink">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="text()" mode="hyperlink">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template match="*:info | *:article" mode="doc-config" priority="999">
		<div style="color:grey;border:solid 1px grey; margin-bottom:0.5cm; width:30cm;padding:2px">
			<xsl:apply-templates select="*:info" mode="doc-config"/>
			<xsl:apply-templates select="*:para" mode="doc-config"/>
		</div>
	</xsl:template>
	<xsl:template match="*:named-templates | *:functions" mode="doc-config" priority="999">
		<xsl:apply-templates mode="doc-config"/>
	</xsl:template>
	<xsl:template match="*:introduction" mode="doc-config" priority="999">
		<xsl:apply-templates mode="doc-config"/>
	</xsl:template>
	<xsl:template match="*:b" mode="doc-config" priority="999">
		<b>
			<xsl:apply-templates mode="doc-config"/>
		</b>
	</xsl:template>
	<xsl:template match="*:para" mode="doc-config" priority="999">
		<div>
			<xsl:apply-templates mode="doc-config"/>
		</div>
	</xsl:template>
	<xsl:template match="*:section" mode="doc-config" priority="999">
		<!--<xsl:choose>
			<xsl:when test="
					local-name(parent::*) = ('template',
					'functions')">
				<xsl:variable name="template-function-name" select="local-name(parent::*)"/>
				<div
					style="color:grey;border:solid 1px grey; margin-bottom:0.5cm; width:30cm;padding:2px">
					<i> Information about this <xsl:value-of select="$template-function-name"/>
						<br/>
						<xsl:apply-templates mode="doc-config"/>
					</i>
				</div>
			</xsl:when>
			<xsl:otherwise>-->
		<div>
			<xsl:apply-templates mode="doc-config"/>
		</div>
		<!--</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
	<xsl:template match="*:function | *:template" mode="doc-config" priority="999">
		<xsl:variable name="template-function-name" select="local-name(.)"/>
		<div style="color:grey;border:solid 1px grey; margin-bottom:0.5cm; width:30cm;padding:2px">
			<i> Information about this <xsl:value-of select="$template-function-name"/>
				<br/>
				<xsl:apply-templates mode="doc-config"/>
			</i>
		</div>
	</xsl:template>
	<xsl:template match="*:ul" mode="doc-config" priority="999">
		<ul>
			<xsl:apply-templates mode="doc-config"/>
		</ul>
	</xsl:template>
	<xsl:template match="*:li" mode="doc-config" priority="999">
		<li>
			<xsl:apply-templates mode="doc-config"/>
		</li>
	</xsl:template>
	<xsl:template match="*:authorgroup | *:author" mode="doc-config" priority="999">
		<div>
			<ul>
				<xsl:apply-templates mode="doc-config"/>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="*:author/* | *:pubdate" mode="doc-config" priority="999">
		<li>
			<xsl:value-of select="local-name()"/> : <xsl:apply-templates mode="doc-config"/>
		</li>
	</xsl:template>
	<xsl:template match="*:title" mode="doc-config" priority="999">
		<h3>
			<xsl:apply-templates mode="doc-config"/>
		</h3>
	</xsl:template>
	<xsl:template match="*:itemizedlist" mode="doc-config" priority="999">
		<ul>
			<xsl:apply-templates mode="doc-config"/>
		</ul>
	</xsl:template>
	<xsl:template match="*:listitem" mode="doc-config" priority="999">
		<li>
			<xsl:apply-templates mode="doc-config"/>
		</li>
	</xsl:template>
	<xsl:template match="*:emphasis" mode="doc-config" priority="999">
		<xsl:element name="{(@role,'i')[1]}">
			<xsl:apply-templates mode="doc-config"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="*[not(starts-with(name(), 'xsl')) and not(starts-with(name(), 'k7:'))]"
		mode="doc-config">
		<div style="padding-left:0.5cm">
			<span style="color:maroon">
				<xsl:text disable-output-escaping="yes"><![CDATA[&lt;]]></xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:for-each select="@*">
					<xsl:text> </xsl:text>
					<xsl:value-of select="name()"/>
					<xsl:text> = '</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>' </xsl:text>
				</xsl:for-each>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</span>
			<div style="padding-left:0.5cm">
				<xsl:apply-templates select="node() | @*" mode="doc-config"/>
			</div>
			<span style="color:maroon">
				<xsl:text disable-output-escaping="yes"><![CDATA[&lt;/]]></xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:if test="normalize-space(.)"> Output Text : <xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
