This project will hold XSL and Velocity stylesheets for creating a Cascade Server calendaring solution. Originally authored by Eric L. Epps for Sauk Valley Community College.


Directory Structure:
XML-Source (XML source files for reference)
    DISCLAIMER: I do not recommend laying out your files in this way, but this was the structure I inherited, so I built around it.
  * calendar.xml - listing of campus events
  * schedule.xml - class schedule data

room-calendar (listing of events by room, by week)
  * room-schedule-current-week.vm - Velocity script to display events for a specific room based on current week
  * room-schedule-current-week.vm - virtually identical to above, difference is that it pulls the weekly start date from the file name instead of current date
  
monthly-calendar (HTML calendar by month and iCalendar feed)
  * full-calendar-html.xsl - XSL stylesheet to output monthly calendar of events
  * icalendar-template - Cascade Template with iCalendar boilerplate/time zone text
  * full-calendar-ical.xsl - XSL stylesheet to output iCalendar feed of events
  * AcadCalICS.php - PHP script which reads iCal "XML" page and strips XML start/end tag to output as true iCalendar feed (Cascade workaround)
  * add - folder contains index.php, which generates add to web calendar links and images
  

daily-calendar (coming soon)

student-orgs (coming soon)