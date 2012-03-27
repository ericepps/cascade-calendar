<xsl:comment>
Since this is generating essentially a text file, spacing is important. Here's the full 'event' xsl:template, reformatted and commented to be easier to read.

** start date and time (if applicable)
DTSTART
<xsl:choose>
	** if there is hour/minute data, output a full timestamp
    <xsl:when test="starttime/hour">;TZID=CST6CDT:
    	** date portion
        <xsl:value-of select="date-converter:formatDate(number(../../value),number(../value),number(../../../value))"/>
        ** time portion
        T
        ** add 12 hours if PM, output and format times
        ** (it would be better to just store the data in 24-hour format in the XML source)
        <xsl:choose>
            <xsl:when test="starttime[am = 'true']">
                <xsl:if test="number(starttime/hour) &lt; 10">0</xsl:if>
                    <xsl:value-of select="starttime/hour"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="number(starttime/hour) &lt; 12">
                        <xsl:value-of select="(starttime/hour)+12"/>
                    </xsl:when>
                    <xsl:otherwise>
                    	<xsl:value-of select="starttime/hour"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="starttime/minute"/>00
    </xsl:when>
	** if there is not hour/minute data, output an "all day" event
    <xsl:otherwise>;VALUE=DATE:
    	<xsl:value-of select="date-converter:formatDate(number(../../value),number(../value),number(../../../value),1)"/>
	</xsl:otherwise>
</xsl:choose>
** end date and time (if applicable)
DTEND
<xsl:choose>
** snip - exactly the same format as DTSTART
</xsl:choose>
<xsl:choose>
	** same test as above: if there is hour/minute data, output "transparent" or "all-day" tag
    ** must have a line break after opening xsl:otherise so TRANSP: starts on next line
	<xsl:when test="starttime/hour"/><xsl:otherwise>
	TRANSP:TRANSPARENT</xsl:otherwise>
</xsl:choose>

** do some find/replace to clean up troublesome characters, output description as 'SUMMARY' and 'LOCATION'
SUMMARY:<xsl:value-of select="translate(description,',;','--')"/>
LOCATION:<xsl:value-of select="translate(location,',;','--')"/>
END:VEVENT

** I would recommend removing this xsl:comment block before importing to Cascade; in fact, you'll have to, because 
** it's invalid at this position in the stylesheet.
</xsl:comment>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
<xsl:output encoding="utf-8" omit-xml-declaration="yes"/>
<xsl:template match="/">
<xsl:apply-templates select="calendar/year/month/day/event"/>
</xsl:template>
<xsl:template match="event">BEGIN:VEVENT
DTSTART<xsl:choose><xsl:when test="starttime/hour">;TZID=CST6CDT:<xsl:value-of select="date-converter:formatDate(number(../../value),number(../value),number(../../../value))"/>T<xsl:choose><xsl:when test="starttime[am = 'true']"><xsl:if test="number(starttime/hour) &lt; 10">0</xsl:if><xsl:value-of select="starttime/hour"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="number(starttime/hour) &lt; 12"><xsl:value-of select="(starttime/hour)+12"/></xsl:when><xsl:otherwise><xsl:value-of select="starttime/hour"/></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose><xsl:value-of select="starttime/minute"/>00</xsl:when><xsl:otherwise>;VALUE=DATE:<xsl:value-of select="date-converter:formatDate(number(../../value),number(../value),number(../../../value),1)"/></xsl:otherwise></xsl:choose>
DTEND<xsl:choose><xsl:when test="endtime/hour">;TZID=CST6CDT:<xsl:value-of select="date-converter:formatDate(number(../../value),number(../value),number(../../../value))"/>T<xsl:choose><xsl:when test="endtime[am = 'true']"><xsl:if test="number(endtime/hour) &lt; 10">0</xsl:if><xsl:value-of select="endtime/hour"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="number(endtime/hour) &lt; 12"><xsl:value-of select="(endtime/hour)+12"/></xsl:when><xsl:otherwise><xsl:value-of select="endtime/hour"/></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose><xsl:value-of select="endtime/minute"/>00</xsl:when><xsl:otherwise>;VALUE=DATE:<xsl:value-of select="date-converter:formatDatePlus(number(../../value),number(../value),number(../../../value),1)"/></xsl:otherwise></xsl:choose>
<xsl:choose><xsl:when test="starttime/hour"/><xsl:otherwise>
TRANSP:TRANSPARENT</xsl:otherwise></xsl:choose>
SUMMARY:<xsl:value-of select="translate(description,',;','--')"/>
LOCATION:<xsl:value-of select="translate(location,',;','--')"/>
END:VEVENT
</xsl:template>
<xalan:component functions="formatDate formatDatePlus" prefix="date-converter">
      <xalan:script lang="javascript">
              // return the date in YYYYMMDD format
               function formatDate(mo,dy,yr)
               {                                               
                     var d = new Date(yr, mo - 1, dy);
                    // Splits date into components
                    var curr_date = d.getDate();
                    curr_date = '0' + curr_date.toString();
                    var curr_month = d.getMonth();
                    curr_month++;
                    curr_month = '0' + curr_month.toString();
                    var curr_year = d.getFullYear();
                    var retString = curr_year + curr_month.substring(curr_month.length-2) + curr_date.substring(curr_date.length-2);
                    return retString;
              }
              // return the date in YYYYMMDD format and add X days
              function formatDatePlus(mo,dy,yr,addDate)
              {                                               
                     var d = new Date(yr, mo - 1, dy + addDate);
                    // Splits date into components
                    var curr_date = d.getDate();
                    curr_date = '0' + curr_date.toString();
                    var curr_month = d.getMonth();
                    curr_month++;
                    curr_month = '0' + curr_month.toString();
                    var curr_year = d.getFullYear();
                    var retString = curr_year + curr_month.substring(curr_month.length-2) + curr_date.substring(curr_date.length-2);
                    return retString;
              }
         </xalan:script>
</xalan:component>
</xsl:stylesheet>