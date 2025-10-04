#!/bin/sh

weatherFormat="%l+%c|+%C+%t"
city="billings"

if ! curl -s "https://wttr.in/${city}?format=${weatherFormat}\n"; then
	exit 1
fi
