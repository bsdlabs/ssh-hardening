# FreeBSD OpenSSH Hardening — Client

## Run the following in a terminal to harden the OpenSSH client for the local user

    mkdir -p -m 0700 ~/.ssh; printf "\nHost *\n  Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n\n  KexAlgorithms sntrup761x25519-sha512,sntrup761x25519-sha512@openssh.com,mlkem768x25519-sha256,curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\n\n  MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\n\n  HostKeyAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\n  CASignatureAlgorithms sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\n  HostbasedAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256\n\n  PubkeyAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256\n" >> ~/.ssh/config

<details>
  <summary>Results report</summary>

```
# general
(gen) client IP: 127.0.0.1
(gen) banner: SSH-2.0-OpenSSH_9.9
(gen) software: OpenSSH 9.9
(gen) compression: enabled (zlib@openssh.com)

# key exchange algorithms
(kex) sntrup761x25519-sha512@openssh.com    -- [info] available since OpenSSH 8.5
                                            `- [info] default key exchange from OpenSSH 9.0 to 9.8
                                            `- [info] hybrid key exchange based on post-quantum resistant algorithm and proven conventional X25519 algorithm
(kex) curve25519-sha256                     -- [info] available since OpenSSH 7.4, Dropbear SSH 2018.76
                                            `- [info] default key exchange from OpenSSH 7.4 to 8.9
(kex) curve25519-sha256@libssh.org          -- [info] available since OpenSSH 6.4, Dropbear SSH 2013.62
                                            `- [info] default key exchange from OpenSSH 6.5 to 7.3
(kex) diffie-hellman-group16-sha512         -- [info] available since OpenSSH 7.3, Dropbear SSH 2016.73
(kex) diffie-hellman-group18-sha512         -- [info] available since OpenSSH 7.3
(kex) diffie-hellman-group-exchange-sha256  -- [info] available since OpenSSH 4.4
(kex) ext-info-c                            -- [info] available since OpenSSH 7.2
                                            `- [info] pseudo-algorithm that denotes the peer supports RFC8308 extensions
(kex) kex-strict-c-v00@openssh.com          -- [info] pseudo-algorithm that denotes the peer supports a stricter key exchange method as a counter-measure to the Terrapin attack (CVE-2023-48795)

# host-key algorithms
(key) sk-ssh-ed25519-cert-v01@openssh.com   -- [info] available since OpenSSH 8.2
(key) ssh-ed25519-cert-v01@openssh.com      -- [info] available since OpenSSH 6.5
(key) rsa-sha2-512-cert-v01@openssh.com     -- [info] available since OpenSSH 7.8
(key) rsa-sha2-256-cert-v01@openssh.com     -- [info] available since OpenSSH 7.8
(key) sk-ssh-ed25519@openssh.com            -- [info] available since OpenSSH 8.2
(key) ssh-ed25519                           -- [info] available since OpenSSH 6.5, Dropbear SSH 2020.79
(key) rsa-sha2-512                          -- [info] available since OpenSSH 7.2
(key) rsa-sha2-256                          -- [info] available since OpenSSH 7.2, Dropbear SSH 2020.79

# encryption algorithms (ciphers)
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
