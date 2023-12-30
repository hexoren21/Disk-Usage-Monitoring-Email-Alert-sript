#!/bin/bash

# Procent uzycia dysku
LIMIT=50

# Adres e-mail
EMAIL="kapel21@o2.pl"

# Sprawdzenie uzycia dysku dla partycji '/'
CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')

# Logika warunkowa do sprawdzenia, czy aktualne uzycie przekracza limit
if [ "$CURRENT" -gt "$LIMIT" ]; then
    # Wysyłanie e-maila
    SUBJECT="Alert: Uzycie dysku na serwerze"
    MESSAGE="Uwaga: Uzycie dysku przekroczylo $LIMIT%. Aktualne uzycie: $CURRENT%."

    echo -e "Subject: $SUBJECT\n\n$MESSAGE" | msmtp $EMAIL
    echo "wyslano maila"
fi

