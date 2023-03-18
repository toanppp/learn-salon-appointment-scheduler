#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

ROWS=( $($PSQL "SELECT * FROM services") )

function GET_SERVICE_ID() {
  if [[ ! $1 ]]
  then
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  else
    echo -e "\nI could not find that service. What would you like today?"
  fi

  for ROW in "${ROWS[@]}"
  do
    COLUMNS=(${ROW//|/ })
    echo "${COLUMNS[0]}) ${COLUMNS[1]}"
  done
  
  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
}


GET_SERVICE_ID

until [[ $SERVICE_NAME != "" ]]
do
  GET_SERVICE_ID again
done

echo -e "\nWhat's your phone number?"

read CUSTOMER_PHONE

CUSTOMER=$($PSQL "SELECT customer_id, name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ $CUSTOMER == "" ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  RESULT=( $($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME') RETURNING customer_id") )
  CUSTOMER_ID=${RESULT[0]}
else
  CUSTOMER_INFO=(${CUSTOMER//|/ })
  CUSTOMER_ID=${CUSTOMER_INFO[0]}
  CUSTOMER_NAME=${CUSTOMER_INFO[1]}
fi

echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
