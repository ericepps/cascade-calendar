<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output omit-xml-declaration="yes"/>
<xsl:template match="system-index-block">
    <dl>
    <xsl:apply-templates select="system-block[system-data-structure/time/startTime &gt; /system-index-block/@current-time]">
        <xsl:sort data-type="number" order="ascending" select="system-data-structure/time/startTime"/>
        <xsl:sort data-type="number" order="ascending" select="system-data-structure/time/endTime"/>
    </xsl:apply-templates>
    </dl>
</xsl:template>
<xsl:template match="system-block">
<xsl:for-each select="system-data-structure/studentOrg">
<xsl:if test="substring-before(path,'/index') = substring-before(/system-index-block/calling-page/system-page/path,'/events')">
    <xsl:apply-templates select="../../system-data-structure"/>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="system-data-structure">
<dt><xsl:value-of select="eventTitle"/></dt>
<dd><xsl:value-of select="eventDesc"/></dd>
</xsl:template>
</xsl:stylesheet>