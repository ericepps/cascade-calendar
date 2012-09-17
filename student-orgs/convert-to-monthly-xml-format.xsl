<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
<xsl:output encoding="utf-8" omit-xml-declaration="yes"/>
<xsl:template match="/system-index-block">
<calendar name="StudentOrgs">
<xsl:apply-templates select="system-block/system-data-structure">
<xsl:sort order="ascending" select="startTime"/>
</xsl:apply-templates>
</calendar>
</xsl:template>
<xsl:template match="system-data-structure">
<year>
<value><xsl:value-of select="date-converter:getYear(number(time/startTime))"/></value>
<month>
<value><xsl:value-of select="date-converter:getMonth(number(time/startTime))"/></value>
<day>
<value><xsl:value-of select="date-converter:getDate(number(time/startTime))"/></value>
<event>
<description><xsl:value-of select="eventTitle"/></description>
</event>
</day>
</month>
</year>
</xsl:template>

<xalan:component functions="convertDate" prefix="date-converter">
    <xalan:script lang="javascript">
        function convertDate(date) {                                               
            var d = new Date(date);
            // Splits date into components
            var curr_date = d.getDate();
            curr_date = '0' + curr_date.toString();
            var curr_month = d.getMonth();
            var monthNames = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
            var curr_year = d.getFullYear();
            var retString = monthNames[curr_month] + ' ' + curr_date.substring(curr_date.length-2) + ', ' + curr_year;
            return retString;
        }
        function getYear(date) {                                               
            var d = new Date(date);
            // Splits date into components
            var curr_year = d.getFullYear();
            var retString = curr_year;
            return retString;
        }
        function getDate(date) {                                               
            var d = new Date(date);
            // Splits date into components
            var curr_date = d.getDate();
            curr_date = '0' + curr_date.toString();
            var retString = curr_date.substring(curr_date.length-2);
            return retString;
        }
        function getMonth(date) {                                               
            var d = new Date(date);
            // Splits date into components
            var curr_month = d.getMonth();
            var monthNames = new Array('01','02','03','04','05','06','07','08','09','10','11','12');
            var retString = monthNames[curr_month];
            return retString;
        }
        function getTime(date) {
            var d = new Date(date);
            
            var curr_hour = ((h = d.getHours() % 12) ? h : 12);
            curr_hour = curr_hour.toString();
            var curr_mins = d.getMinutes();
            curr_mins = '0' + curr_mins.toString();
            var curr_ap = d.getHours() &lt; 12 ? 'a' : 'p';
            
            var retString = curr_hour + ':' + curr_mins.substring(curr_mins.length-2) + curr_ap;
            return retString;
        }
    </xalan:script>
</xalan:component>

</xsl:stylesheet>