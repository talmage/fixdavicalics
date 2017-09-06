#!/bin/bash
#
# Run this script as user postgres to extract
# talmage's address book and calendars from 
# DAViCal.
#
psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/addresses/%'),'');" > talmage_addressbook.vcf

psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/calendar/%'),'');" > talmage_calendar.ics

psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/workCalendar/%'),'');" > workCalendar.ics

psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/churchCalendar/%'),'');" > churchCalendar.ics

psql davical -Atc "SELECT array_to_string(array(SELECT caldav_data FROM caldav_data WHERE dav_name LIKE '/talmage/datesOfNote/%'),'');" > datesOfNote.ics
datesOfNote
