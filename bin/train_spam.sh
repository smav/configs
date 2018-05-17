#!/bin/bash
#
# Script to train SpamAssasin from my spam and ham folders

SPAM_DIR="~/Maildir/.Spam-missed"
HAM_DIR="~/Maildir/.Spam-not_spam"

# Train spam
for file in $(ls ${SPAM_DIR}); do
	/usr/bin/sa-learn --spam  ${file}
done

# Train ham
for file in $(ls ${HAM_DIR}); do
	/usr/bin/sa-learn --ham  ${file}
done
