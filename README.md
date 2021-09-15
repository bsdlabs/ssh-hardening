[![Build Status](https://api.cirrus-ci.com/github/bsdlabs/ssh-hardening.svg)](https://cirrus-ci.com/github/bsdlabs/ssh-hardening)

# FreeBSD SSH Hardening

## Backup ssh config, install ssh-audit

    sudo -s # we need root for most of this
    cp -a /etc/ssh /etc/ssh.bak # backup ssh config just in case
    pkg install -y security/py-ssh-audit # install ssh-audit (you can make intall if you like)
    rehash

## Enable and start sshd, then run ssh-audit, saving the output

    service sshd enable
    service sshd start
    ssh-audit --no-colors localhost > ssh-audit.out

## Remove existing key-pairs, disable DSA & ECDSA, regenerate RSA and ED25519 keys

    rm /etc/ssh/ssh_host_*
    sysrc sshd_dsa_enable="no"
    sysrc sshd_ecdsa_enable="no"
    sysrc sshd_ed25519_enable="yes"
    sysrc sshd_rsa_enable="yes"
    service sshd keygen

## Remove Diffie-Hellman moduli smaller than 3071

    awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

## Disable DSA and ECDSA host keys, enable RSA ed25519 host keys

    sed -i .bak 's/^HostKey \/etc\/ssh\/ssh_host_\(dsa\|ecdsa\)_key$/\#HostKey \/etc\/ssh\/ssh_host_\1_key/g; s/^#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/\HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

## Restrict supported key exchange, cipher, and MAC algorithms

    printf "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com" >> /etc/ssh/sshd_config

## Restart sshd and run ssh-audit again, appending output

    service sshd restart
    ssh-audit --no-colors localhost >> ssh-audit.out
    uname -a >> ssh-audit.out

Send (pastebin) the contents of `ssh-audit.out`

## If you want to revert the SSH configuration

    rm -rf /etc/ssh
    mv /etc/ssh.bak /etc/ssh
