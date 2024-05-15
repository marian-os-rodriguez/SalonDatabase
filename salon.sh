#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo "Welcome to My Salon, how can I help you?"

SERVICES=$($PSQL "SELECT CONCAT(ROW_NUMBER() OVER (ORDER BY service_id), ') ', name)
FROM services")
true=1
while [[ $true -eq 1 ]] 
do
  echo $SERVICES
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]] 
  then
      echo "I could not find that service, What would you like today?"
  else
      true=0
      echo "What's your phone number?"
      read CUSTOMER_PHONE
      DATABASE_NAME=$($PSQL "SELECT name from customers where phone='$CUSTOMER_PHONE'")
      if [[ -z $DATABASE_NAME ]] 
      then
        echo "I don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
        read SERVICE_TIME
        echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
        ($PSQL "INSERT INTO customers(phone,name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      else
        echo "What time would you like your $SERVICE_NAME, $DATABASE_NAME?"
        read SERVICE_TIME
        echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $DATABASE_NAME."
      fi
  fi
done
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
INSERT=$($PSQL "insert into appointments (customer_id,service_id,time) values ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")     