# Mailtrap Docker Image

Catch all mail and display it in roundcube interface using postfix, dovecot and roundcube webmail interface.

# Usage

## Start Mailtrap

    $ docker run -d --name=mailtrap -p 80:80 yetanotherdockeragain/mailtrap

## Send email

    $ docker run -it --link mailtrap alpine sh
    
      $ telnet mailtrap 25
      ehlo example.com
      mail from: me@example.com
      rcpt to: you@example.com
      data
      Subject: Hello from me
      Hello You,

      This is a test.

      Cheers,
      Me
      .
      quit

## See email via Mailtrap Web UI:

* http://localhost

## Default login:

* **Username:** `mailtrap`
* **Password:** `mailtrap`

## Original authors
This base configuration was copied from [https://github.com/ipunkt/docker-mailtrap](https://github.com/ipunkt/docker-mailtrap). Due to author not maintaining it, we cloned repository and upgrade all versions and add fixes for problems we found using original docker image.