<?php
$calURL = $_GET['url'];
echo '<ul class="nopadding nobullet">';
echo '<li><a href="http://www.google.com/calendar/hosted/students.svcc.edu/render?cid='.urlencode($calURL).'"><img alt="subscribe in students.svcc.edu calendar" height="48" src="/calendar/add/calStudent.png" width="140"/></a></li>';
echo '<li><a href="http://www.google.com/calendar/render?cid='.urlencode($calURL).'"><img alt="subscribe in Google Calendar" height="34" src="/calendar/add/calGoogle.png" width="114"/></a></li>';
echo '</ul>';
echo '<p>iCalendar address <span style="font-size:80%; font-style:italic;">(copy-and-paste into your favorite calendar application)</span><br/><input type="text" style="width:200px; height:20px;" value="'.$calURL.'"/></p>';
?>