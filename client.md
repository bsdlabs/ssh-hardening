# FreeBSD OpenSSH Hardening — Client

## Run the following in a terminal to harden the OpenSSH client for the local user

    mkdir -p -m 0700 ~/.ssh; printf "\nHost *\n  Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n  KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\n  MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\n  HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com\n" >> ~/.ssh/config

<details>
  <summary>Results report</summary>

```
# general
(gen) client IP: 127.0.0.1
(gen) banner: SSH-2.0-OpenSSH_9.3
(gen) software: OpenSSH 9.3
(gen) compression: enabled (zlib@openssh.com, zlib)

# key exchange algorithms
(kex) sntrup761x25519-sha512@openssh.com    -- [info] available since OpenSSH 8.5
(kex) curve25519-sha256                     -- [info] available since OpenSSH 7.4, Dropbear SSH 2018.76
                                            `- [info] default key exchange since OpenSSH 6.4
(kex) curve25519-sha256@libssh.org          -- [info] available since OpenSSH 6.4, Dropbear SSH 2013.62
                                            `- [info] default key exchange since OpenSSH 6.4
(kex) diffie-hellman-group16-sha512         -- [info] available since OpenSSH 7.3, Dropbear SSH 2016.73
(kex) diffie-hellman-group18-sha512         -- [info] available since OpenSSH 7.3
(kex) diffie-hellman-group-exchange-sha256  -- [info] available since OpenSSH 4.4
(kex) ext-info-c

# host-key algorithms
(key) ssh-ed25519                           -- [info] available since OpenSSH 6.5
(key) ssh-ed25519-cert-v01@openssh.com      -- [info] available since OpenSSH 6.5
(key) sk-ssh-ed25519@openssh.com            -- [info] available since OpenSSH 8.2
(key) sk-ssh-ed25519-cert-v01@openssh.com   -- [info] available since OpenSSH 8.2
(key) rsa-sha2-256                          -- [info] available since OpenSSH 7.2
(key) rsa-sha2-256-cert-v01@openssh.com     -- [info] available since OpenSSH 7.8
(key) rsa-sha2-512                          -- [info] available since OpenSSH 7.2
(key) rsa-sha2-512-cert-v01@openssh.com     -- [info] available since OpenSSH 7.8

# encryption algorithms (ciphers)
(enc) chacha20-poly1305@openssh.com         -- [info] available since OpenSSH 6.5
                                            `- [info] default cipher since OpenSSH 6.9
(enc) aes256-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes128-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes256-ctr                            -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52
(enc) aes192-ctr                            -- [info] available since OpenSSH 3.7
(enc) aes128-ctr                            -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52

# message authentication code algorithms
(mac) hmac-sha2-256-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) hmac-sha2-512-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) umac-128-etm@openssh.com              -- [info] available since OpenSSH 6.2
```
</details>
