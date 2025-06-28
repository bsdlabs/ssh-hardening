# FreeBSD OpenSSH Hardening — Server

## Backup ssh config, install ssh-audit

    sudo -s # we need root for most of this
    cp -a /etc/ssh /etc/ssh.bak # backup ssh config just in case
    pkg install -y security/py-ssh-audit # install ssh-audit (you can make install if you like)

## Enable and start sshd, then run ssh-audit, saving the output

    service sshd enable
    service sshd start
    uname -a > ssh-audit.out
    echo "# before hardening" >> ssh-audit.out
    ssh-audit --no-colors localhost >> ssh-audit.out || true

## Remove existing key-pairs, disable DSA & ECDSA

    rm -f /etc/ssh/ssh_host_*
    sysrc sshd_dsa_enable="no"
    sysrc sshd_ecdsa_enable="no"
    sysrc sshd_ed25519_enable="yes"
    sysrc sshd_rsa_enable="yes"

## Regenerate RSA and Ed25519 keys

    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

## Remove Diffie-Hellman moduli smaller than 3071

    awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

## Restrict supported key exchange, cipher, and MAC algorithms

    printf "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms sntrup761x25519-sha512,sntrup761x25519-sha512@openssh.com,mlkem768x25519-sha256,curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512\n\nCiphers aes256-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-gcm@openssh.com,aes128-ctr\n\nMACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com\n\nHostKeyAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nCASignatureAlgorithms sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nHostbasedAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nPubkeyAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n" >> /etc/ssh/sshd_config

## Restart sshd and run ssh-audit again, appending output

    service sshd restart
    echo "# after hardening" >> ssh-audit.out
    ssh-audit --no-colors localhost >> ssh-audit.out

<details>
  <summary>Send (pastebin) the contents of <code>ssh-audit.out</code></summary>

```
FreeBSD cirrus-task-0000000000000000 15.0-CURRENT FreeBSD 15.0-CURRENT #0 main-n278235-dca2ab32e831: Thu Jun 26 04:58:09 UTC 2025     root@releng3.nyi.freebsd.org:/usr/obj/usr/src/amd64.amd64/sys/GENERIC amd64
# before hardening
# general
(gen) banner: SSH-2.0-OpenSSH_9.9 FreeBSD-20250219
(gen) software: OpenSSH 9.9 running on FreeBSD (2025-02-19)
(gen) compatibility: OpenSSH 9.9+, Dropbear SSH 2020.79+
(gen) compression: enabled (zlib@openssh.com)

# key exchange algorithms
(kex) sntrup761x25519-sha512                -- [info] available since OpenSSH 9.9
                                            `- [info] default key exchange since OpenSSH 9.9
                                            `- [info] hybrid key exchange based on post-quantum resistant algorithm and proven conventional X25519 algorithm
(kex) sntrup761x25519-sha512@openssh.com    -- [info] available since OpenSSH 8.5
                                            `- [info] default key exchange from OpenSSH 9.0 to 9.8
                                            `- [info] hybrid key exchange based on post-quantum resistant algorithm and proven conventional X25519 algorithm
(kex) mlkem768x25519-sha256                 -- [info] available since OpenSSH 9.9
                                            `- [info] hybrid key exchange based on post-quantum resistant algorithm and proven conventional X25519 algorithm
(kex) curve25519-sha256                     -- [info] available since OpenSSH 7.4, Dropbear SSH 2018.76
                                            `- [info] default key exchange from OpenSSH 7.4 to 8.9
(kex) curve25519-sha256@libssh.org          -- [info] available since OpenSSH 6.4, Dropbear SSH 2013.62
                                            `- [info] default key exchange from OpenSSH 6.5 to 7.3
(kex) ecdh-sha2-nistp256                    -- [fail] using elliptic curves that are suspected as being backdoored by the U.S. National Security Agency
                                            `- [info] available since OpenSSH 5.7, Dropbear SSH 2013.62
(kex) ecdh-sha2-nistp384                    -- [fail] using elliptic curves that are suspected as being backdoored by the U.S. National Security Agency
                                            `- [info] available since OpenSSH 5.7, Dropbear SSH 2013.62
(kex) ecdh-sha2-nistp521                    -- [fail] using elliptic curves that are suspected as being backdoored by the U.S. National Security Agency
                                            `- [info] available since OpenSSH 5.7, Dropbear SSH 2013.62
(kex) diffie-hellman-group-exchange-sha256 (3072-bit) -- [info] available since OpenSSH 4.4
                                                      `- [info] OpenSSH's GEX fallback mechanism was triggered during testing. Very old SSH clients will still be able to create connections using a 2048-bit modulus, though modern clients will use 3072. This can only be disabled by recompiling the code (see https://github.com/openssh/openssh-portable/blob/V_9_4/dh.c#L477).
(kex) diffie-hellman-group16-sha512         -- [info] available since OpenSSH 7.3, Dropbear SSH 2016.73
(kex) diffie-hellman-group18-sha512         -- [info] available since OpenSSH 7.3
(kex) diffie-hellman-group14-sha256         -- [warn] 2048-bit modulus only provides 112-bits of symmetric strength
                                            `- [info] available since OpenSSH 7.3, Dropbear SSH 2016.73
(kex) ext-info-s                            -- [info] available since OpenSSH 9.6
                                            `- [info] pseudo-algorithm that denotes the peer supports RFC8308 extensions
(kex) kex-strict-s-v00@openssh.com          -- [info] pseudo-algorithm that denotes the peer supports a stricter key exchange method as a counter-measure to the Terrapin attack (CVE-2023-48795)

# host-key algorithms
(key) rsa-sha2-512 (3072-bit)               -- [info] available since OpenSSH 7.2
(key) rsa-sha2-256 (3072-bit)               -- [info] available since OpenSSH 7.2, Dropbear SSH 2020.79
(key) ecdsa-sha2-nistp256                   -- [fail] using elliptic curves that are suspected as being backdoored by the U.S. National Security Agency
                                            `- [warn] using weak random number generator could reveal the key
                                            `- [info] available since OpenSSH 5.7, Dropbear SSH 2013.62
(key) ssh-ed25519                           -- [info] available since OpenSSH 6.5, Dropbear SSH 2020.79

# encryption algorithms (ciphers)
(enc) chacha20-poly1305@openssh.com         -- [info] available since OpenSSH 6.5, Dropbear SSH 2020.79
                                            `- [info] default cipher since OpenSSH 6.9
(enc) aes128-ctr                            -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52
(enc) aes192-ctr                            -- [info] available since OpenSSH 3.7
(enc) aes256-ctr                            -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52
(enc) aes128-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes256-gcm@openssh.com                -- [info] available since OpenSSH 6.2

# message authentication code algorithms
(mac) umac-64-etm@openssh.com               -- [warn] using small 64-bit tag size
                                            `- [info] available since OpenSSH 6.2
(mac) umac-128-etm@openssh.com              -- [info] available since OpenSSH 6.2
(mac) hmac-sha2-256-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) hmac-sha2-512-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) hmac-sha1-etm@openssh.com             -- [fail] using broken SHA-1 hash algorithm
                                            `- [info] available since OpenSSH 6.2
(mac) umac-64@openssh.com                   -- [warn] using encrypt-and-MAC mode
                                            `- [warn] using small 64-bit tag size
                                            `- [info] available since OpenSSH 4.7
(mac) umac-128@openssh.com                  -- [warn] using encrypt-and-MAC mode
                                            `- [info] available since OpenSSH 6.2
(mac) hmac-sha2-256                         -- [warn] using encrypt-and-MAC mode
                                            `- [info] available since OpenSSH 5.9, Dropbear SSH 2013.56
(mac) hmac-sha2-512                         -- [warn] using encrypt-and-MAC mode
                                            `- [info] available since OpenSSH 5.9, Dropbear SSH 2013.56
(mac) hmac-sha1                             -- [fail] using broken SHA-1 hash algorithm
                                            `- [warn] using encrypt-and-MAC mode
                                            `- [info] available since OpenSSH 2.1.0, Dropbear SSH 0.28

# fingerprints
(fin) ssh-ed25519: SHA256:A5ybfnFjSRotPO7tJfOIAZp0eRGRjE2ik8buWrV6Ims
(fin) ssh-rsa: SHA256:EyiW+ShyCBkcNMHw9x2QNZXbpk54BlZ2ELZYEtMN44I

# algorithm recommendations (for OpenSSH 9.9)
(rec) -diffie-hellman-group14-sha256        -- kex algorithm to remove
(rec) -ecdh-sha2-nistp256                   -- kex algorithm to remove
(rec) -ecdh-sha2-nistp384                   -- kex algorithm to remove
(rec) -ecdh-sha2-nistp521                   -- kex algorithm to remove
(rec) -ecdsa-sha2-nistp256                  -- key algorithm to remove
(rec) -hmac-sha1                            -- mac algorithm to remove
(rec) -hmac-sha1-etm@openssh.com            -- mac algorithm to remove
(rec) -hmac-sha2-256                        -- mac algorithm to remove
(rec) -hmac-sha2-512                        -- mac algorithm to remove
(rec) -umac-128@openssh.com                 -- mac algorithm to remove
(rec) -umac-64-etm@openssh.com              -- mac algorithm to remove
(rec) -umac-64@openssh.com                  -- mac algorithm to remove

# additional info
(nfo) For hardening guides on common OSes, please see: <https://www.ssh-audit.com/hardening_guides.html>
(nfo) Be aware that, while this target properly supports the strict key exchange method (via the kex-strict-?-v00@openssh.com marker) needed to protect against the Terrapin vulnerability (CVE-2023-48795), all peers must also support this feature as well, otherwise the vulnerability will still be present.  The following algorithms would allow an unpatched peer to create vulnerable SSH channels with this target: chacha20-poly1305@openssh.com.  If any CBC ciphers are in this list, you may remove them while leaving the *-etm@openssh.com MACs in place; these MACs are fine while paired with non-CBC cipher types.

# after hardening
# general
(gen) banner: SSH-2.0-OpenSSH_9.9 FreeBSD-20250219
(gen) software: OpenSSH 9.9 running on FreeBSD (2025-02-19)
(gen) compatibility: OpenSSH 9.6+, Dropbear SSH 2020.79+
(gen) compression: enabled (zlib@openssh.com)

# key exchange algorithms
(kex) sntrup761x25519-sha512@openssh.com    -- [info] available since OpenSSH 8.5
                                            `- [info] default key exchange from OpenSSH 9.0 to 9.8
                                            `- [info] hybrid key exchange based on post-quantum resistant algorithm and proven conventional X25519 algorithm
(kex) curve25519-sha256                     -- [info] available since OpenSSH 7.4, Dropbear SSH 2018.76
                                            `- [info] default key exchange from OpenSSH 7.4 to 8.9
(kex) curve25519-sha256@libssh.org          -- [info] available since OpenSSH 6.4, Dropbear SSH 2013.62
                                            `- [info] default key exchange from OpenSSH 6.5 to 7.3
(kex) diffie-hellman-group18-sha512         -- [info] available since OpenSSH 7.3
(kex) diffie-hellman-group-exchange-sha256 (3072-bit) -- [info] available since OpenSSH 4.4
                                                      `- [info] OpenSSH's GEX fallback mechanism was triggered during testing. Very old SSH clients will still be able to create connections using a 2048-bit modulus, though modern clients will use 3072. This can only be disabled by recompiling the code (see https://github.com/openssh/openssh-portable/blob/V_9_4/dh.c#L477).
(kex) diffie-hellman-group16-sha512         -- [info] available since OpenSSH 7.3, Dropbear SSH 2016.73
(kex) ext-info-s                            -- [info] available since OpenSSH 9.6
                                            `- [info] pseudo-algorithm that denotes the peer supports RFC8308 extensions
(kex) kex-strict-s-v00@openssh.com          -- [info] pseudo-algorithm that denotes the peer supports a stricter key exchange method as a counter-measure to the Terrapin attack (CVE-2023-48795)

# host-key algorithms
(key) rsa-sha2-512 (4096-bit)               -- [info] available since OpenSSH 7.2
(key) rsa-sha2-256 (4096-bit)               -- [info] available since OpenSSH 7.2, Dropbear SSH 2020.79
(key) ssh-ed25519                           -- [info] available since OpenSSH 6.5, Dropbear SSH 2020.79

# encryption algorithms (ciphers)
(enc) aes256-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes256-ctr                            -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52
(enc) aes192-ctr                            -- [info] available since OpenSSH 3.7
(enc) aes128-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes128-ctr                            -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52

# message authentication code algorithms
(mac) hmac-sha2-512-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) hmac-sha2-256-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) umac-128-etm@openssh.com              -- [info] available since OpenSSH 6.2

# fingerprints
(fin) ssh-ed25519: SHA256:UoCYwlo7+pOqWt6Ir1NRWSEmuzctC1GQkbHaMk0BkTQ
(fin) ssh-rsa: SHA256:RpLDROCOMjdeZHNPTMm9GqVFXAY7/OIdRP8qAnfalO4
```
</details>

## If you want to revert the SSH configuration

    rm -rf /etc/ssh
    mv /etc/ssh.bak /etc/ssh

<details>
  <summary>Comparative table: Default vs. Hardened</summary>

<table>
<tr>
<th></th>
<th>Default (OpenSSH 9.9)</th>
<th>Hardened</th>
</tr>
<tr>
<th>HostKey</th>
<td>
<ul>
<li>Ed25519</li>
<li>RSA (3072-bit)</li>
<li>ECDSA</li>
</ul>
</td>
<td>
<ul>
<li>Ed25519</li>
<li>RSA (4096-bit)</li>
</ul>
</td>
</tr>
<tr>
<th>Ciphers</th>
<td>
<ul>
<!-- KEX_SERVER_ENCRYPT -->
<li>chacha20-poly1305@openssh.com</li>
<li>aes128-ctr</li>
<li>aes192-ctr</li>
<li>aes256-ctr</li>
<li>aes128-gcm@openssh.com</li>
<li>aes256-gcm@openssh.com</li>
</ul>
</td>
<td>
<ul>
<li>aes256-gcm@openssh.com</li>
<li>aes128-gcm@openssh.com</li>
<li>aes256-ctr</li>
<li>aes192-ctr</li>
<li>aes128-ctr</li>
</ul>
</td>
</tr>
<tr>
<th>KexAlgorithms</th>
<td>
<ul>
<!-- KEX_SERVER_KEX -->
<li>sntrup761x25519-sha512</li>
<li>sntrup761x25519-sha512@openssh.com</li>
<li>mlkem768x25519-sha256</li>
<li>curve25519-sha256</li>
<li>curve25519-sha256@libssh.org</li>
<li>ecdh-sha2-nistp256</li>
<li>ecdh-sha2-nistp384</li>
<li>ecdh-sha2-nistp521</li>
<li>diffie-hellman-group-exchange-sha256</li>
<li>diffie-hellman-group16-sha512</li>
<li>diffie-hellman-group18-sha512</li>
<li>diffie-hellman-group14-sha256</li>
</ul>
</td>
<td>
<ul>
<li>sntrup761x25519-sha512</li>
<li>sntrup761x25519-sha512@openssh.com</li>
<li>mlkem768x25519-sha256</li>
<li>curve25519-sha256</li>
<li>curve25519-sha256@libssh.org</li>
<li>diffie-hellman-group16-sha512</li>
<li>diffie-hellman-group18-sha512</li>
<li>diffie-hellman-group-exchange-sha256</li>
</ul>
</td>
</tr>
<tr>
<th>MACs</th>
<td>
<ul>
<!-- KEX_SERVER_MAC -->
<li>umac-64-etm@openssh.com</li>
<li>umac-128-etm@openssh.com</li>
<li>hmac-sha2-256-etm@openssh.com</li>
<li>hmac-sha2-512-etm@openssh.com</li>
<li>hmac-sha1-etm@openssh.com</li>
<li>umac-64@openssh.com</li>
<li>umac-128@openssh.com</li>
<li>hmac-sha2-256</li>
<li>hmac-sha2-512</li>
<li>hmac-sha1</li>
</ul>
</td>
<td>
<ul>
<li>hmac-sha2-256-etm@openssh.com</li>
<li>hmac-sha2-512-etm@openssh.com</li>
<li>umac-128-etm@openssh.com</li>
</ul>
</td>
</tr>
<tr>
<th>HostKeyAlgorithms</th>
<td>
<ul>
<!-- KEX_DEFAULT_PK_ALG -->
<li>ssh-ed25519-cert-v01@openssh.com</li>
<li>ecdsa-sha2-nistp256-cert-v01@openssh.com</li>
<li>ecdsa-sha2-nistp384-cert-v01@openssh.com</li>
<li>ecdsa-sha2-nistp521-cert-v01@openssh.com</li>
<li>sk-ssh-ed25519-cert-v01@openssh.com</li>
<li>sk-ecdsa-sha2-nistp256-cert-v01@openssh.com</li>
<li>rsa-sha2-512-cert-v01@openssh.com</li>
<li>rsa-sha2-256-cert-v01@openssh.com</li>
<li>ssh-ed25519</li>
<li>ecdsa-sha2-nistp256</li>
<li>ecdsa-sha2-nistp384</li>
<li>ecdsa-sha2-nistp521</li>
<li>sk-ssh-ed25519@openssh.com</li>
<li>sk-ecdsa-sha2-nistp256@openssh.com</li>
<li>rsa-sha2-512</li>
<li>rsa-sha2-256</li>
</ul>
</td>
<td>
<ul>
<li>ssh-ed25519</li>
<li>ssh-ed25519-cert-v01@openssh.com</li>
<li>sk-ssh-ed25519@openssh.com</li>
<li>sk-ssh-ed25519-cert-v01@openssh.com</li>
<li>rsa-sha2-512</li>
<li>rsa-sha2-512-cert-v01@openssh.com</li>
<li>rsa-sha2-256</li>
<li>rsa-sha2-256-cert-v01@openssh.com</li>
</ul>
</td>
</tr>
</table>
</details>
