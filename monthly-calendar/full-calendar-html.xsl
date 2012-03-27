<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
  <xsl:output encoding="utf-8" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <xsl:apply-templates select="calendar">
      <xsl:sort order="ascending" select="calendar/year/value"/>
      <xsl:sort order="ascending" select="calendar/year/month/value"/>
      <xsl:sort order="ascending" select="calendar/year/month/day/value"/>
      <xsl:sort order="ascending" select="calendar/year/month/day/event/starttime/hour"/>
      <xsl:sort order="ascending" select="calendar/year/month/day/event/starttime/minute"/>
    </xsl:apply-templates>
    <br/>
    &#160;
    <xsl:comment>placeholder div - add to web calendar links will be inserted here</xsl:comment>
    <div id="calPopup"></div>
  </xsl:template>
  
  
  <xsl:template match="calendar">
  	<xsl:comment>store calendar name</xsl:comment>
    <xsl:variable name="currentPageName"><xsl:value-of select="@name"/></xsl:variable>
    <xsl:comment>*** links to subscribe in Google Calendar and direct link to iCal feed ***</xsl:comment>
    <p class="subscriptions">
      <a><xsl:attribute name="href">http://www.google.com/calendar/render?cid=http://www.svcc.edu/schedule/calendars/<xsl:value-of select="$currentPageName"/>ICS.php</xsl:attribute><img alt="Add to Google Calendar" src="http://www.google.com/calendar/images/ext/gc_button6.gif" style="border:none;"/></a>&#160;&#160;
      <a><xsl:attribute name="href">http://www.svcc.edu/schedule/calendars/<xsl:value-of select="$currentPageName"/>ICS.php</xsl:attribute><img alt="iCal Feed" src="/calendars/images/iCalButton.png" style="border:none;"/></a>
    </p>
    
    <xsl:comment>*** generate calendars by starting with year of first event until year of the last event ***</xsl:comment>
    <xsl:call-template name="loopYear">
      <xsl:with-param name="initial-value" select="year/value"/>
      <xsl:with-param name="maxcount" select="number(year[last()]/value)+1"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:comment>*** loop through years, and, for each year, call loopMonth to loop through months of the year ***</xsl:comment>
  <xsl:template name="loopYear">
    <xsl:param name="maxcount"/>
    <xsl:param name="initial-value"/>
    <xsl:param name="counter"/>
    <xsl:if test="$initial-value &lt; $maxcount">
      <xsl:call-template name="loopMonth">
        <xsl:with-param name="xYear" select="$initial-value"/>
        <xsl:with-param name="maxcount" select="13"/>
        <xsl:with-param name="initial-value" select="1"/>
        <xsl:with-param name="counter" select="$counter+1"/>
      </xsl:call-template>
      <xsl:call-template name="loopYear">
        <xsl:with-param name="maxcount" select="$maxcount"/>
        <xsl:with-param name="initial-value" select="$initial-value+1"/>
        <xsl:with-param name="counter" select="1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:comment>*** loop through months, and, for each month, call month to generate the calendar ***</xsl:comment>
  <xsl:template name="loopMonth">
    <xsl:param name="xYear"/>
    <xsl:param name="maxcount"/>
    <xsl:param name="initial-value"/>
    <xsl:param name="counter"/>
    <xsl:if test="$initial-value &lt; $maxcount">
      <xsl:apply-templates select="year[number(value)=number($xYear)]/month[number(value)=number($initial-value)]">
        <xsl:with-param name="counter" select="$counter"/>
      </xsl:apply-templates>
      <xsl:call-template name="loopMonth">
        <xsl:with-param name="xYear" select="$xYear"/>
        <xsl:with-param name="maxcount" select="$maxcount"/>
        <xsl:with-param name="initial-value" select="$initial-value+1"/>
        <xsl:with-param name="counter" select="$counter+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:comment>*** generate the table structure for the month and then loop through any padding days necessary (loopDayPad) and each day of the month (loopDayOfMonth) ***</xsl:comment>
  <xsl:template match="month">
    <xsl:param name="counter"/>
    <xsl:if test="position() = 1">
      <table>
        <xsl:attribute name="class">month<xsl:value-of select="date-converter:currentMonth(number(value),number(../value))"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="substring(date-converter:monthName(number(value),number(../value)),1,3)"/><xsl:value-of select="number(../value)"/></xsl:attribute>
        <caption>
        <span><a class="previous">
        <xsl:attribute name="href">javascript:showMonth('<xsl:value-of select="date-converter:prevMonth(number(value),number(../value))"/><xsl:value-of select="date-converter:prevMonthYear(number(value),number(../value))"/>');</xsl:attribute>
        <xsl:value-of select="date-converter:prevMonth(number(value),number(../value))"/>&#160;<xsl:value-of select="date-converter:prevMonthYear(number(value),number(../value))"/></a></span><span><a class="next">
        <xsl:attribute name="href">javascript:showMonth('<xsl:value-of select="date-converter:nextMonth(number(value),number(../value))"/><xsl:value-of select="date-converter:nextMonthYear(number(value),number(../value))"/>');</xsl:attribute>
        <xsl:value-of select="date-converter:nextMonth(number(value),number(../value))"/>&#160;<xsl:value-of select="date-converter:nextMonthYear(number(value),number(../value))"/></a></span>
        <h2><xsl:value-of select="date-converter:monthName(number(value),number(../value))"/>&#160;&#160;<xsl:value-of select="number(../value)"/></h2>
        </caption>
        <thead>
          <tr>
            <th>Sunday</th>
            <th>Monday</th>
            <th>Tuesday</th>
            <th>Wednesday</th>
            <th>Thursday</th>
            <th>Friday</th>
            <th>Saturday</th>
          </tr>
        </thead>
        <tbody>
          <tr>
          	<xsl:comment>*** Based on the current day of week, add table cells to pad beginning of month ***</xsl:comment>
            <xsl:call-template name="loopDayPad">
              <xsl:with-param name="maxcount" select="number(date-converter:dayOfWeek(number(value),number(../value),'1'))+1"/>
              <xsl:with-param name="initial-value" select="1"/>
            </xsl:call-template>
            <xsl:comment>*** Now loop through days of the month ***</xsl:comment>
            <xsl:call-template name="loopDayOfMonth">
              <xsl:with-param name="xYear" select="../value"/>
              <xsl:with-param name="xMonth" select="value"/>
              <xsl:with-param name="maxcount" select="number(date-converter:daysInMonth(number(value),number(../value)))+1"/>
              <xsl:with-param name="initial-value" select="1"/>
            </xsl:call-template>
          	<xsl:comment>*** Based on the current day of week, add table cells to pad end of month ***</xsl:comment>
            <xsl:call-template name="loopDayPad">
              <xsl:with-param name="maxcount" select="7-number(date-converter:dayOfWeek(number(value),number(../value),date-converter:daysInMonth(number(value),number(../value))))"/>
              <xsl:with-param name="initial-value" select="1"/>
            </xsl:call-template>
          </tr>
        </tbody>
      </table>
    </xsl:if>
  </xsl:template>
  
  <xsl:comment>*** generate a blank spacer cell ***</xsl:comment>
  <xsl:template name="loopDayPad">
    <xsl:param name="maxcount"/>
    <xsl:param name="initial-value"/>
    <xsl:if test="$initial-value &lt; $maxcount">
      <td><xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$initial-value = ($maxcount - 1)">day lastPadDay</xsl:when>
          <xsl:otherwise>day</xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
        &#160;</td>
      <xsl:call-template name="loopDayPad">
        <xsl:with-param name="maxcount" select="$maxcount"/>
        <xsl:with-param name="initial-value" select="$initial-value+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:comment>*** loop through days of the month and call the 'day' template which checks for events ***</xsl:comment>
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
  
  <xsl:comment>*** generate table cell for day, check for events, if events, call event template ***</xsl:comment>
  <xsl:template name="day">
    <xsl:param name="xDay"/>
    <xsl:param name="xMonth"/>
    <xsl:param name="xYear"/>
    <xsl:param name="initial-value"/>
    <xsl:choose>
      <xsl:when test="/calendar/year[value=$xYear]/month[value=$xMonth]//day[value=$initial-value]/event">
        <td><xsl:attribute name="class">day dayGame<xsl:value-of select="date-converter:currentDayYN(number(value),number(../value),$initial-value)"/></xsl:attribute>
          <div><a>
            <xsl:attribute name="href">/schedule/calendars/daily/
            <xsl:if test="$xMonth &lt; 10">0</xsl:if><xsl:value-of select="$xMonth"/>-<xsl:if test="$initial-value &lt; 10">0</xsl:if><xsl:value-of select="$initial-value"/>-<xsl:value-of select="substring($xYear,3,2)"/>.html</xsl:attribute>
            <h3><xsl:value-of select="$initial-value"/></h3>
            </a>
            <ul>
              <xsl:apply-templates select="/calendar/year[value=$xYear]/month[value=$xMonth]//day[value=$initial-value]/event"/>
            </ul>
          </div></td>
      </xsl:when>
      <xsl:otherwise>
        <td><xsl:attribute name="class">day dayNoGame<xsl:value-of select="date-converter:currentDayYN(number(value),number(../value),$initial-value)"/></xsl:attribute>
          <h3><xsl:value-of select="$initial-value"/></h3></td>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="number(date-converter:dayOfWeek(number($xMonth),number($xYear),number($initial-value))) = 6">
      <xsl:comment>
#START-CODE
        <![CDATA[</tr><tr>]]>
        #END-CODE
      </xsl:comment>
    </xsl:if>
  </xsl:template>
  
  <xsl:comment>*** generate list of events for a given day with links to add to web calenars ***</xsl:comment>
  <xsl:template match="event">
    <li><strong>
      <xsl:choose>
        <xsl:when test="starttime/freeform != ''">
          <xsl:copy-of select="starttime/freeform"/>
        </xsl:when>
        <xsl:when test="starttime">
          <xsl:value-of select="starttime/hour"/>:<xsl:value-of select="starttime/minute"/>
          <xsl:choose>
            <xsl:when test="starttime[am='true']">a</xsl:when>
            <xsl:otherwise>p</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
      &#160;</strong>&#160;<xsl:value-of select="description"/>
      <xsl:if test="location != ''">
        <br/>
        LOCATION:<xsl:value-of select="location"/>
      </xsl:if>
      <br/>
      <xsl:comment>*** call add/index.php via AJAX to generate links to add this event to popular web calendars</xsl:comment>
      <a class="calendarAdd" rel="nofollow" target="new" title="copy to my calendar">
      <xsl:attribute name="href">add/?text=<xsl:value-of select="description"/>&amp;dates=<xsl:value-of select="../../../value"/><xsl:value-of select="substring(concat('0',../../value),string-length(concat('0',../../value))-1,2)"/><xsl:value-of select="substring(concat('0',../value),string-length(concat('0',../value))-1,2)"/>
      <xsl:if test="starttime[hour!='']">T
        <xsl:choose>
          <xsl:when test="starttime[am='true']">
            <xsl:value-of select="substring(concat('0',starttime/hour),string-length(concat('0',starttime/hour))-1,2)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="(starttime/hour)+12"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="starttime/minute"/>00Z
      </xsl:if>
      /<xsl:value-of select="../../../value"/><xsl:value-of select="substring(concat('0',../../value),string-length(concat('0',../../value))-1,2)"/><xsl:value-of select="substring(concat('0',../value),string-length(concat('0',../value))-1,2)"/>
      <xsl:if test="endtime[hour!='']">T
        <xsl:choose>
          <xsl:when test="endtime[am='true']">
            <xsl:value-of select="substring(concat('0',endtime/hour),string-length(concat('0',endtime/hour))-1,2)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="(endtime/hour)+12"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="endtime/minute"/>00Z
      </xsl:if>
      &amp;location=<xsl:value-of select="location"/></xsl:attribute>
      copy to my calendar</a></li>
  </xsl:template>
  
<xalan:component functions="convertDate" prefix="date-converter">
    <xalan:script lang="javascript">
        function convertDate(date) {                                               
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
            var moNameArray = new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
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
            var moNameArray = new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
            var d = new Date();
            d.setFullYear(yNo,mNo-1,1);
            d.setDate(d.getDate()+35);
            return moNameArray[d.getMonth()];
        }
        function nextMonthYear(mNo,yNo) {
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