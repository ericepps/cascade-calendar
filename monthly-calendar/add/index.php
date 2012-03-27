<?php
/* Pop-up text box with links to add event to Google Calendar, Yahoo Calendar, and Windows Live Calendar.
   Called from montly HTML calendar via AJAX script. */
$calText = $_GET['text'];
$calDates = $_GET['dates'];
list($calStartDate,$calEndDate) = split('/',$calDates);
$calLocation = $_GET['location'];
echo '<p class="dayDetailHeader"><a href="javascript:toggleLayer(\'calPopup\');">close</a></p><p><strong>Add to Calendar:</strong></p>';
echo '<ul class="nopadding nobullet">';
echo '<li><a target="calAddWin" href="http://www.google.com/calendar/event?action=TEMPLATE&amp;text='.$calText.'&amp;dates='.$calDates.'&amp;location='.$calLocation.'&amp;trp=false&amp;sprop=svcc.edu&amp;sprop=name:SVCC"><img alt="add to Google Calendar" height="34" src="/schedule/calendars/add/calGoogle.png" width="114"/></a></li>';
echo '<li><a target="calAddWin" href="http://calendar.yahoo.com/?v=60&ST='.$calStartDate.'&TITLE='.$calText.'&VIEW=d"><img alt="add to Yahoo! Calendar" height="34" src="/schedule/calendars/add/calYahoo.png" width="114"/></a></li>';
echo '<li><a target="calAddWin" href="http://calendar.live.com/calendar/calendar.aspx?dtstart='.$calStartDate.'&location='.$calLocation.'&rru=addevent&src=zv&summary='.$calText.'"><img alt="add to Windows Live Calendar" height="34" src="/schedule/calendars/add/calWinLive.png" width="114"/></a></li>';
echo '</ul>';

?>