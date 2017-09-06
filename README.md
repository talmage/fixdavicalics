# Migrating From DAViCal to Nextcloud

## Extract the Address Book and Calendars From DAViCal

As the user *postgres* in the directory */tmp*, do these things.

### Extract the Address Book

psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/addresses/%'),'');" > talmage_addressbook.vcf

### Extract the Calendars

> psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/calendar/%'),'');" > talmage_calendar.ics

> psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/workCalendar/%'),'');" > workCalendar.ics

> psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/churchCalendar/%'),'');" > churchCalendar.ics

> psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/datesOfNote/%'),'');" > datesOfNote.ics

## Process the Calendars So That Nextcloud Can Import Them
### Remove strings that begin ";=nvalid Calendar User".
### Filter the Junk From Each Calendar With the icsfiltercalendars.awk Script

> awk -f icsfiltercalendars.awk < talmage_calendar.ics > talmage_calendar_filtered.ics

> awk -f icsfiltercalendars.awk < workCalendar.ics > workCalendar_filtered.ics

> awk -f icsfiltercalendars.awk < churchCalendar.ics > churchCalendar_filtered.ics

> awk -f icsfiltercalendars.awk < daysOfNote.ics > daysOfNote_filtered.ics

## Import the Address Book Into the Nextcloud Address Book
## Import Each Filtered Calendar Into a Separate Nextcloud Calendar
