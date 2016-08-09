# Webhook Response Server

These scripts will enable you to quickly get a simple HTTP server up and running so that you can register a URL with a webhook service and capture the response and potentially respond to it (if desired)

## Pre-requisites

* A server reachable from the external web service
    * See `./xinet.d/webhook` for ways to whitelist the service's IP address
    * If you want to run your service locally, you'll need to be able forward a port from a remote, publically addressable server.
        * Use ssh remote port forwarding. Example: `ssh -R 0.0.0.0:50000:127.0.0.1:10000 ec2-54-173-251-97.compute-1.amazonaws.com`
            * `50000` is the port on the server
            * `10000` is the port on your local machine (configured in your xinitd service)
            * Provide this hostname and server port to the external webhook service
            * The forwarding will be active as long as the ssh connection is intact
        * You must have added the line `GatewayPorts yes` to `/etc/ssh/sshd_config`

* The following programs must be installed on the server
    * xinetd
    * netcat (the `nc` command), for testing

## Setup
* Run the install script and provide your override values
    * `./install -n <hook name> -p <port - default:10000> -u <user - default:webhook> -e <handler - optional>`
    * Bounce your xinetd service to pick up the changes
        * It may be helpful to enable the `/etc/xinetd.d/services` service
        * Then you can run `nc 127.0.0.1 9098` to see the list of active xinetd services
* Ensure the user has permission to execute the ./server script and the handler program (if provided)

## Developing/Testing

These scripts log to /var/log/syslog under the `xinetd.webhook-<hook name>` tag.

### Local Testing (no server xinetd service required)
Run `./test/test-local -n <hook name>` to simulate a request without involving the xinetd service. This will directly invoke the ./server script with ./test/sample-http-post (or you can pipe your own request to the script instead)

### Server Testing
Run `./test/test-remote <host> <port>` to run the request through the xinetd service. It's probably best to test against `127.0.0.1` before running through the external hostname/IP.
