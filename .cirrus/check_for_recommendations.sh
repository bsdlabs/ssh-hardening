#!/bin/sh

# Check if there are still recommendations present,
# and consider them as failures.

cp ssh-audit.out ssh-audit-after-hardening.out
sed -i '' '1,/# after hardening/d' ssh-audit-after-hardening.out
recommendations=$(grep -c recommendations ssh-audit-after-hardening.out)

if [ "$recommendations" -ne 0 ]; then
	echo "There are recommendations present!" >&2
	exit 1
fi
