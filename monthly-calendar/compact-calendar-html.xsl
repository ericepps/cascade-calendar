<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
<xsl:output encoding="utf-8" omit-xml-declaration="yes"/>
<xsl:template match="/">
<span>
    <xsl:apply-templates select="system-data-structure/blockID[name != 'current page']/content/calendar">
        <xsl:sort order="ascending" select="calendar/year/value"/>
        <xsl:sort order="ascending" select="calendar/year/month/value"/>
        <xsl:sort order="ascending" select="calendar/year/month/day/value"/>
        <xsl:sort order="ascending" select="calendar/year/month/day/event/starttime/hour"/>
        <xsl:sort order="ascending" select="calendar/year/month/day/event/starttime/minute"/>
    </xsl:apply-templates>
    <p class="nopadding"><a href="http://www.svcc.edu/schedule/calendars/index.html">SVCC Calendars</a></p>
</span>
</xsl:template>
<xsl:template match="calendar">
<xsl:if test="position() = 1">
<xsl:call-template name="loopYear">
        <xsl:with-param name="initial-value" select="number(substring-before(/system-data-structure/blockID[name = 'current page']/content/system-index-block/calling-page/system-page/name,'-'))"/>
        <xsl:with-param name="maxcount" select="number(substring-before(/system-data-structure/blockID[name = 'current page']/content/system-index-block/calling-page/system-page/name,'-'))+1"/>
    </xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="month">
    <xsl:param name="counter"/>
    <xsl:if test="position() = 1">
    <table><xsl:attribute name="class">month monthShow</xsl:attribute><xsl:attribute name="id"><xsl:value-of select="substring(date-converter:monthName(number(value),number(../value)),1,3)"/><xsl:value-of select="number(../value)"/></xsl:attribute>
    <caption><span><a class="previous" id="prevMo"><xsl:attribute name="href">javascript:getCalMonthAJAX('<xsl:value-of select="date-converter:prevMonthYear(number(value),number(../value))"/>','<xsl:value-of select="date-converter:prevMonth(number(value),number(../value))"/>');</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="date-converter:prevMonthName(number(value),number(../value))"/>&#160;<xsl:value-of select="date-converter:prevMonthYear(number(value),number(../value))"/></xsl:attribute>&lt;&lt;</a></span><span><a class="next" id="nextMo"><xsl:attribute name="href">javascript:getCalMonthAJAX('<xsl:value-of select="date-converter:nextMonthYear(number(value),number(../value))"/>','<xsl:value-of select="date-converter:nextMonth(number(value),number(../value))"/>');</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="date-converter:nextMonthName(number(value),number(../value))"/>&#160;<xsl:value-of select="date-converter:nextMonthYear(number(value),number(../value))"/></xsl:attribute>&gt;&gt;</a></span><h2><xsl:value-of select="date-converter:monthName(number(value),number(../value))"/>&#160;&#160;<xsl:value-of select="number(../value)"/></h2></caption>
    <thead><tr><th>SU</th><th>MO</th><th>TU</th><th>WE</th><th>TH</th><th>FR</th><th>SA</th></tr></thead>
    <tbody>
    <tr>
    <xsl:call-template name="loopDayPad">
        <xsl:with-param name="maxcount" select="number(date-converter:dayOfWeek(number(value),number(../value),'1'))+1"/>
        <xsl:with-param name="initial-value" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="loopDayOfMonth">
        <xsl:with-param name="xYear" select="../value"/>
        <xsl:with-param name="xMonth" select="value"/>
        <xsl:with-param name="maxcount" select="number(date-converter:daysInMonth(number(value),number(../value)))+1"/>
        <xsl:with-param name="initial-value" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="loopDayPad">
        <xsl:with-param name="maxcount" select="7-number(date-converter:dayOfWeek(number(value),number(../value),date-converter:daysInMonth(number(value),number(../value))))"/>
        <xsl:with-param name="initial-value" select="1"/>
    </xsl:call-template>
    </tr>
    </tbody>
    </table>
    </xsl:if>
</xsl:template>
<xsl:template name="day">
    <xsl:param name="xDay"/>
    <xsl:param name="xMonth"/>
    <xsl:param name="xYear"/>
    <xsl:param name="initial-value"/>
    <xsl:choose>
        <xsl:when test="/system-data-structure/blockID[name != 'current page']/content/calendar/year[value=$xYear]/month[value=$xMonth]//day[value=$initial-value]/event">
            <td><xsl:attribute name="class">day dayGame<xsl:value-of select="date-converter:currentDayYN(number(value),number(../value),$initial-value)"/></xsl:attribute>
            <h3><a><xsl:attribute name="href">http://www.svcc.edu/schedule/calendars/daily/<xsl:value-of select="$xMonth"/>-<xsl:if test="$initial-value &lt; 10">0</xsl:if><xsl:value-of select="$initial-value"/>-<xsl:value-of select="substring($xYear,3,2)"/>.html</xsl:attribute><xsl:value-of select="$initial-value"/></a></h3>
            <div><p><xsl:value-of select="number($xMonth)"/>-<xsl:value-of select="$initial-value"/>-<xsl:value-of select="$xYear"/></p>
                <ul><xsl:apply-templates select="/system-data-structure/blockID[name != 'current page']/content/calendar/year[value=$xYear]/month[value=$xMonth]//day[value=$initial-value]/event"/></ul>
            </div>
            </td>
        </xsl:when>
        <xsl:otherwise>
            <td><xsl:attribute name="class">day dayNoGame<xsl:value-of select="date-converter:currentDayYN(number(value),number(../value),$initial-value)"/></xsl:attribute>
            <h3><a><xsl:attribute name="href">http://www.svcc.edu/schedule/calendars/daily/<xsl:value-of select="$xMonth"/>-<xsl:if test="$initial-value &lt; 10">0</xsl:if><xsl:value-of select="$initial-value"/>-<xsl:value-of select="substring($xYear,3,2)"/>.html</xsl:attribute><xsl:value-of select="$initial-value"/></a></h3>
            </td>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="number(date-converter:dayOfWeek(number($xMonth),number($xYear),number($initial-value))) = 6">
        <xsl:comment>#START-CODE <![CDATA[ </tr><tr> ]]> #END-CODE</xsl:comment>
    </xsl:if>
</xsl:template>
<xsl:template match="event">
    <li><xsl:if test="starttime">
    <time>
        <xsl:choose>
            <xsl:when test="starttime/freeform != ''"><xsl:copy-of select="substring-before(starttime/freeform,' ')"/><xsl:choose><xsl:when test="substring-after(starttime/freeform,' ') = 'p.m.'">p</xsl:when><xsl:when test="substring-after(starttime/freeform,' ') = 'a.m.'">a</xsl:when></xsl:choose></xsl:when>
            <xsl:when test="starttime"><xsl:value-of select="starttime/hour"/>:<xsl:value-of select="starttime/minute"/>
                <xsl:choose>
                    <xsl:when test="starttime[am='true']">a</xsl:when>
                    <xsl:otherwise>p</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose></time></xsl:if><xsl:text> </xsl:text><xsl:value-of select="description"/>
    <xsl:if test="location != ''"> (<xsl:value-of select="location"/>)</xsl:if>
    </li>
</xsl:template>
<xsl:template name="loopYear">
    <xsl:param name="maxcount"/>
    <xsl:param name="initial-value"/>
    <xsl:param name="counter"/>
    <xsl:if test="$initial-value &lt; $maxcount">
        <xsl:call-template name="loopMonth">
            <xsl:with-param name="xYear" select="$initial-value"/>
            <xsl:with-param name="maxcount" select="number(substring-after(/system-data-structure/blockID[name = 'current page']/content/system-index-block/calling-page/system-page/name,'-'))+1"/>
            <xsl:with-param name="initial-value" select="number(substring-after(/system-data-structure/blockID[name = 'current page']/content/system-index-block/calling-page/system-page/name,'-'))"/>
            <xsl:with-param name="counter" select="$counter+1"/>
        </xsl:call-template>
        <xsl:call-template name="loopYear">
            <xsl:with-param name="maxcount" select="$maxcount"/>
            <xsl:with-param name="initial-value" select="$initial-value+1"/>
            <xsl:with-param name="counter" select="1"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>
<xsl:template name="loopMonth">
    <xsl:param name="xYear"/>
    <xsl:param name="maxcount"/>
    <xsl:param name="initial-value"/>
    <xsl:param name="counter"/>
    <xsl:if test="$initial-value &lt; $maxcount">
        <xsl:choose>
        <xsl:when test="year[number(value)=number($xYear)]/month[number(value)=number($initial-value)]">
            <xsl:apply-templates select="year[number(value)=number($xYear)]/month[number(value)=number($initial-value)]">
                <xsl:with-param name="counter" select="$counter"/>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
                <p class="caption"><span><a class="previous" id="prevMo"><xsl:attribute name="href"><xsl:value-of select="date-converter:prevMonthYear(number($initial-value),number($xYear))"/>-<xsl:value-of select="date-converter:prevMonth(number($initial-value),number($xYear))"/>.php</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="date-converter:prevMonthName(number($initial-value),number($xYear))"/>&#160;<xsl:value-of select="date-converter:prevMonthYear(number($initial-value),number($xYear))"/></xsl:attribute>&lt;&lt;</a></span><span><a class="next" id="nextMo"><xsl:attribute name="href"><xsl:value-of select="date-converter:nextMonthYear(number($initial-value),number($xYear))"/>-<xsl:value-of select="date-converter:nextMonth(number($initial-value),number($xYear))"/>.php</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="date-converter:nextMonthName(number($initial-value),number($xYear))"/>&#160;<xsl:value-of select="date-converter:nextMonthYear(number($initial-value),number($xYear))"/></xsl:attribute>&gt;&gt;</a></span><h2><xsl:value-of select="date-converter:monthName(number($initial-value),number($xYear))"/>&#160;<xsl:value-of select="number($xYear)"/></h2></p>
            <p>Sorry, there are no events listed for <xsl:value-of select="date-converter:monthName(number($initial-value),number($xYear))"/>&#160;<xsl:value-of select="number($xYear)"/>. You can view all calendars and events by clicking the link below.</p>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="loopMonth">
            <xsl:with-param name="xYear" select="$xYear"/>
            <xsl:with-param name="maxcount" select="$maxcount"/>
            <xsl:with-param name="initial-value" select="$initial-value+1"/>
            <xsl:with-param name="counter" select="$counter+1"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>
<xsl:template name="loopDayPad">
    <xsl:param name="maxcount"/>
    <xsl:param name="initial-value"/>
    <xsl:if test="$initial-value &lt; $maxcount">
        <td><xsl:attribute name="class"><xsl:choose><xsl:when test="$initial-value = ($maxcount - 1)">day lastPadDay</xsl:when><xsl:otherwise>day</xsl:otherwise></xsl:choose></xsl:attribute>&#160;</td>
        <xsl:call-template name="loopDayPad">
            <xsl:with-param name="maxcount" select="$maxcount"/>
            <xsl:with-param name="initial-value" select="$initial-value+1"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>
<xsl:template name="loopDayOfMonth">
    <xsl:param name="maxcount"/>
    <xsl:param name="initial-value"/>
    <xsl:param name="xMonth"/>
    <xsl:param name="xYear"/>
    <xsl:if test="$initial-value &lt; $maxcount">
        <xsl:call-template name="day">
            <xsl:with-param name="xYear" select="$xYear"/>
            <xsl:with-param name="xMonth" select="$xMonth"/>
            <xsl:with-param name="xDay" select="//day"/>
            <xsl:with-param name="initial-value" select="$initial-value"/>
        </xsl:call-template>
        <xsl:call-template name="loopDayOfMonth">
            <xsl:with-param name="xYear" select="$xYear"/>
            <xsl:with-param name="xMonth" select="$xMonth"/>
            <xsl:with-param name="maxcount" select="$maxcount"/>

            <xsl:with-param name="initial-value" select="$initial-value+1"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>
<xalan:component functions="convertDate" prefix="date-converter">
      <xalan:script lang="javascript">
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
                    var retString = curr_year + '-' + curr_month.substring(curr_month.length-2) + '-' + curr_date.substring(curr_date.length-2);
                    return retString;
              }
              function prevMonth(mNo,yNo) {
                    var moNameArray = new Array("01","02","03","04","05","06","07","08","09","10","11","12")
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    d.setDate(d.getDate()-5);
                    return moNameArray[d.getMonth()];
              }
              function prevMonthName(mNo,yNo) {
                    var moNameArray = new Array("January","February","March","April","May","June","July","August","September","October","November","December")
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    d.setDate(d.getDate()-5);
                    return moNameArray[d.getMonth()];
              }
              function prevMonthYear(mNo,yNo) {
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    d.setDate(d.getDate()-5);
                    return d.getYear()+1900;
              }
              function nextMonth(mNo,yNo) {
                    var moNameArray = new Array("01","02","03","04","05","06","07","08","09","10","11","12")
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    d.setDate(d.getDate()+35);
                    return moNameArray[d.getMonth()];
              }
              function nextMonthName(mNo,yNo) {
                    var moNameArray = new Array("January","February","March","April","May","June","July","August","September","October","November","December")
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    d.setDate(d.getDate()+35);
                    return moNameArray[d.getMonth()];
              }              function nextMonthYear(mNo,yNo) {
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    d.setDate(d.getDate()+35);
                    return d.getYear()+1900;
              }
              function monthName(mNo,yNo) {
                    var moNameArray = new Array("January","February","March","April","May","June","July","August","September","October","November","December")
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    return moNameArray[d.getMonth()];
              }
              function currentMonth(mNo,yNo) {
                    var moNameArray = new Array("January","February","March","April","May","June","July","August","September","October","November","December")
                    var t = new Date();
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,1);
                    if (t.getMonth() == d.getMonth()) if (t.getYear() == d.getYear()) return ' monthShow';
                      return '';
              }
              function daysInMonth(mNo,yNo) {
                    var m = [31,28,31,30,31,30,31,31,30,31,30,31];
                    if (mNo != 2) return m[mNo - 1];
                    if (yNo%4 != 0) return m[1];
                    if (yNo%100 == 0 &amp;&amp; yNo%400 != 0) return m[1];
                      return m[1] + 1;
              }
              function dayOfWeek(mNo,yNo,dNo) {
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,dNo);
                      return d.getDay();
              }
              function currentDayYN(mNo,yNo,dNo) {
                    var t = new Date();
                    var d = new Date();
                    d.setFullYear(yNo,mNo-1,dNo);
                    if (t.getDate() == d.getDate()) if (t.getMonth() == d.getMonth()) if (t.getYear() == d.getYear()) return ' dayToday';
                      return ' ';
              }
         </xalan:script>
</xalan:component>
</xsl:stylesheet>