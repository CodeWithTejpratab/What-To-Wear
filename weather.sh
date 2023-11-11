#!/bin/zsh

source ~/.zshrc

# OpenWeatherMap API endpoint
API_ENDPOINT="http://api.openweathermap.org/data/2.5/weather?q=${CITY},${COUNTRY}&appid=${API_KEY}"

WEATHER_TEMP=$(curl -s "$API_ENDPOINT" | jq -r '.main.temp')

# Convert the temperature from Kelvin to Fahrenheit
WEATHER_TEMP_F=$(echo "scale=2; (${WEATHER_TEMP} * 9/5) - 459.67" | bc)

# Phone number to send the message
PHONE_NUMBER="$1"

if [[ $WEATER_TEMP_F -ge 60 ]]
then 
	MESSAGE="Current temperature in ${CITY}: ${WEATHER_TEMP_F}°F. You should wear something light as it is hot today"
elif [[ $WEATHER_TEMP_F -ge 50 ]] && [[ $WEATHER_TEMP_F -le 60 ]]
then 
	MESSAGE="Current temperature in ${CITY}: ${WEATHER_TEMP_F}°F. You should wear something cozy today, such as a sweater as it is a bit chilly today"
elif [[ $WEATHER_TEMP_F -lt 50 ]]
then	
	MESSAGE="Current temperature in ${CITY}: ${WEATHER_TEMP_F}°F. You should wear a heavy Jacket as it is very cold today, maybe some gloves"
fi

osascript -e "tell application \"Messages\"
  set targetService to 1st service whose service type = iMessage
  set targetBuddy to buddy \"${PHONE_NUMBER}\" of targetService
  send \"${MESSAGE}\" to targetBuddy
end tell"
