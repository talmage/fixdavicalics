#
# Combine all of the VCALENDARs on the standard input
# into one VCALENDAR.
#
BEGIN {
	eventIndex=0
	inVcalendar = 0
}

function filter(line,inCalendar) {
	if (0 == inCalendar) {
		event[eventIndex] = line
		eventIndex ++
	}
}

#
# Whenever we see the beginning of a VCALENDAR, we store subsequent
# lines in the vcal array.
#
# When we see the beginning of a VEVENT, we store it and all
# subsequent lines, including the end of the VEVENT in the event
# array.
#
# A boolean, inVcalendar, remembers whether we are processing a
# VCALENDAR or a VEVENT. We use its value to choose the array in which
# to store a line of input.  When inVcalendar is non-zero, we're
# processing a VCALENDAR.  When it's zero, we're processing a VEVENT.
#
# We output all lines in one big VCALENDAR: First the start of the
# calendar; then the entries from the vcal array in FIFO order; then
# the entries from the event array in FIFO order; finally, the end of
# the calendar.
#
/^BEGIN:VCALENDAR/ {
	inVcalendar = 1
	next
}

/^END:VCALENDAR/ {
	inVcalendar = 0
	next
}

#
# Filter VEVENTS
#
/^BEGIN:VEVENT/ {
	inVcalendar = 1
	filter($0, inVcalendar)
	next
}

/^END:VEVENT/ {
	filter($0, inVcalendar)
	inVcalendar = 1
	next
}

/^BEGIN:VTODO/ {
	inVcalendar = 0
	filter($0, inVcalendar)
	next
}

/^END:VTODO/ {
	filter($0, inVcalendar)
	inVcalendar = 1
	next
}

/^BEGIN:VJOURNAL/ {
	inVcalendar = 0
	filter($0, inVcalendar)
	next
}

/^END:VJOURNAL/ {
	filter($0, inVcalendar)
	inVcalendar = 1
	next
}

{
	filter($0, inVcalendar)
}

END {
	print "BEGIN:VCALENDAR"

	for (i=0; i < eventIndex; i++) {
		print event[i]
	}
	print "END:VCALENDAR"
}
