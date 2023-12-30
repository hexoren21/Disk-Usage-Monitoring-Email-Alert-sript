#!/bin/bash

# Procent uzycia dysku
LIMIT=50

# Adres e-mail
EMAIL="kapel21@o2.pl"

# Dane logowania SSH
SSH_USER="devops"
SSH_HOST="10.97.190.5"

# Sprawdzenie uzycia dysku dla partycji '/'
SSH_COMMAND="df / | awk '\$NF==\"/\"{print \$5}' | sed 's/%//g'"

# Wykonanie polecenia

CURRENT=$(ssh $SSH_USER@$SSH_HOST "$SSH_COMMAND")
CURRENT=""
# Sprawdzenie zawartosci
if ! [[ "$CURRENT" =~ ^[0-9]+$ ]]; then
    SUBJECT="Blad pobrania zajetosci dysku dla $SSH_HOST"
    MESSAGE="Błąd: Nie udało się uzyskać aktualnego użycia dysku z serwera $SSH_HOST."
    echo -e "Subject: $SUBJECT\n\n$MESSAGE" | msmtp $EMAIL
    exit 1
fi

# Logika warunkowa do sprawdzenia, czy aktualne uzycie przekracza limit
if (($CURRENT > $LIMIT)); then
    # Wysyłanie e-maila
    SUBJECT="Alert: Uzycie dysku na serwerze"
    MESSAGE="Uwaga: Uzycie dysku przekroczylo $LIMIT%. Aktualne uzycie: $CURRENT%."
    echo -e "Subject: $SUBJECT\n\n$MESSAGE" | msmtp $EMAIL
fi

