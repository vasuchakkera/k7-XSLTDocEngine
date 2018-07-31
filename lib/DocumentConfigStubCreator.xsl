<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="source-name" select="tokenize(document-uri(/), '/')[last()]"/>
	<xsl:template match="/">
		<article version="5.0" xml:lang="en" xmlns="http://docbook.org/ns/docbook"
			xmlns:xl="http://www.w3.org/1999/xlink">
			<info>
				<title>XSLT Documentation for <xsl:value-of select="$source-name"/>
				</title>
				<authorgroup>
					<author>
						<personname>Vasu Chakkera</personname>
						<email>vchakkera@gmail.com</email>
						<contrib>..</contrib>
					</author>
				</authorgroup>
				<pubdate>2017-01-16</pubdate>
			</info>
			<para>This XSLT does the following </para>
			<itemizedlist mark="opencircle">
				<listitem>
					<para>a</para>
				</listitem>
				<listitem>
					<para>b</para>
				</listitem>
				<listitem>
					<para>c</para>
				</listitem>
			</itemizedlist>
			<named-templates>
				<xsl:for-each select="//*:template[@name]">
					<template name="{@name}">
						<section>
							<title>Documentation for <xsl:value-of select="@name"/>
							</title>
							<para>This function does the following <xsl:comment>
									Write the documentation for why you had to write this function. Any background information that can be helpful in understanding more about why this function
									was written will be helpful
									
								</xsl:comment>
								<!-- 
 Big Story here.
 -->
							</para>
							<itemizedlist mark="opencircle">
								<listitem>
									<para>a</para>
								</listitem>
								<listitem>
									<para>b</para>
								</listitem>
								<listitem>
									<para>c</para>
								</listitem>
							</itemizedlist>
						</section>
					</template>
				</xsl:for-each>
			</named-templates>
			<functions>
				<xsl:for-each select="//*:function">
					<function name="{@name}">
						<section>
							<title>Documentation for <xsl:value-of select="@name"/>
							</title>
							<para>This function does the following<!-- 
 Big Story here.
 -->
								<xsl:comment>
									Write the documentation for why you had to write this function. Any background information that can be helpful in understanding more about why this function
									was written will be helpful
									
								</xsl:comment>
							</para>
							<itemizedlist mark="opencircle">
								<listitem>
									<para>a</para>
								</listitem>
								<listitem>
									<para>b</para>
								</listitem>
								<listitem>
									<para>c</para>
								</listitem>
							</itemizedlist>
						</section>
					</function>
				</xsl:for-each>
			</functions>
		</article>
	</xsl:template>
</xsl:stylesheet>
