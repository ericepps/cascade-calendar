This project will hold XSL and Velocity stylesheets for creating a Cascade Server calendaring solution. Originally authored by Eric L. Epps 
for Sauk Valley Community College.


Directory Structure:
XML-Source (XML source files for reference)
    DISCLAIMER: I do not recommend laying out your files in this way, but this was the structure I inherited, so I built around it.
  * calendar.xml - listing of campus events
  * schedule.xml - class schedule data

room-calendar (listing of events by room, by week)
  * room-schedule-current-week.vm - Velocity script to display events for a specific room based on current week
  * room-schedule-current-week.vm - virtually identical to above, difference is that it pulls the weekly start date from the file 
                                    name instead of current date

daily-calendar (coming soon)

student-orgs (coming soon)