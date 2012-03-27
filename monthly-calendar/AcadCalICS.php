<?php
ob_start();
// Cascade doesn't allow publishing as ICS, so set the configuration as XML (see screen shot "calendar-ics.png") replace "ical-configuration.xml" with the name of that XML file
include ("ical-configuration.xml");
$iCalContent = ob_get_contents();
ob_end_clean();
// strip <ical> and </ical> from beginning and end and output contents
echo substr($iCalContent,6,strlen($iCalContent)-13);
?>