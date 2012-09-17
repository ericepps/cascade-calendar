<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
<xsl:output encoding="utf-8" omit-xml-declaration="yes"/>
<xsl:template match="/system-index-block">
<xsl:apply-templates select="system-block[substring-before(system-data-structure/studentOrg/path,'/index') = substring-before(/system-index-block/calling-page/system-page/path,'/events')]"/>
</xsl:template>
<xsl:template match="system-block">BEGIN:VEVENT
<xsl:if test="system-data-structure/time/startTime != ''">DTSTART;TZID=CST6CDT:<xsl:value-of select="date-converter:convertDate(number(system-data-structure/time/startTime))"/></xsl:if>
<xsl:if test="system-data-structure/time/endTime != ''"><xsl:text>
</xsl:text>DTEND;TZID=CST6CDT:<xsl:value-of select="date-converter:convertDate(number(system-data-structure/time/endTime))"/></xsl:if>
SUMMARY:<xsl:value-of select="translate(system-data-structure/eventTitle,',;','--')"/>
DESCRIPTION:<xsl:value-of select="translate(system-data-structure/eventDesc,',;','--')"/>
LOCATION:<xsl:value-of select="translate(system-data-structure/location,',;','--')"/>
END:VEVENT
</xsl:template>
<xalan:component functions="convertDate" prefix="date-converter"><xalan:script lang="javascript">
               function convertDate(date)
               {                                               
                     var d = new Date(date);
                    // Splits date into components
                    var curr_date = d.getDate();
                    curr_date = '0' + curr_date.toString();
                    var curr_month = d.getMonth();
                    curr_month++;
                    curr_month = '0' + curr_month.toString();
                    var curr_year = d.getFullYear();
                    
                    var curr_hour = d.getHours();
                    curr_hour = '0' + curr_hour.toString();
                    var curr_minutes = d.getMinutes();
                    curr_minutes = '0' + curr_minutes.toString();
                    var curr_seconds = d.getSeconds();
                    curr_seconds = '0' + curr_seconds.toString();

                    var retString = curr_year + curr_month.substring(curr_month.length-2) + curr_date.substring(curr_date.length-2) + 'T' + curr_hour.substring(curr_hour.length-2) + curr_minutes.substring(curr_minutes.length-2) + curr_seconds.substring(curr_seconds.length-2);
                    return retString;
              }
         </xalan:script></xalan:component>
</xsl:stylesheet>