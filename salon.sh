#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~ Salon Place ~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

echo "What service are you looking for today?"
echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) exit"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) SALON_MENU ;;
  2) SALON_MENU ;;
  3) SALON_MENU ;;
  4) SALON_MENU ;;
  5) SALON_MENU ;;
  6) EXIT ;;
  *) MAIN_MENU "Please enter a valid option." ;;
esac
}

SALON_MENU() {
  #get customer phone number and check if they exist
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  #if customer doesn't exist, ask for name
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    #insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")  
  fi

  #ask for service_time
  echo -e "\nWhat's your preferred appointment time?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_SERVICE_TIME=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_SELECTED_FORMATTED=$(echo $SERVICE_SELECTED | sed 's/ //')

  #update customer on their appointment and send back to main menu
  echo -e "\nI have put you down for a $SERVICE_SELECTED_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."

}

EXIT() {
  echo -e "\nThank you for your visit.\n"
}

MAIN_MENU