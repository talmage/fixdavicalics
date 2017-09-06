---
#
# Use pandoc to convert this file to PDF:
#   pandoc README.md -o README.pdf
#

#
# Formatting options for PDF and LaTeX
#
colorlinks: true
links-as-notes: true
---

# Migrating From DAViCal to Nextcloud

The *fixdavicalics* project contains instructions, a shell script, and
an AWK script for exporting ics files from DAViCal and correcting them
so that NextCloud can import them.

DAViCal's export facility creates incorrect ics files.  They must be
corrected using an editor, then processed with the AWK script to
create an ics file that NextCloud can import.

## Extract the Address Book and Calendars From DAViCal

As the user *postgres* in the directory */tmp*, do these things.

These instructions are from the
[per user ics/vcard export](http://wiki.davical.org/index.php/Backups#Per_user_ics.2Fvcard_export)
instructions on the
[DAViCal wiki](http://wiki.davical.org/index.php/Main_Page)

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
