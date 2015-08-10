# PagerDuty Relay

This is a small Sinatra app that can be used to relay requests from anywhere to PagerDuty.

We use this to bridge the gap between what Zendesk offers for accessing remote APIs and what PagerDuty accepts.  The need for this simple app has come about due to the increasingly common problem of delayed emails from Zendesk.

## Generate a random token

As we're not using any form of authentication, you'll need to generate a long random unguessable token and use this in your requests.  Something like `date | md5sum` does a fine job.

## Running on Heroku

- Clone this repository.
- In the clone run:

    ```
    heroku create --stack cedar yourname-pagerduty-incident-webhooks --addons memcache heroku
    ```

- Set the following config at heroku:

    ```
    heroku config:add PAGERDUTY_RELAY_TOKEN=[a_nice_long_random_unguessable_string]
    heroku config:add PAGERDUTY_SERVICE_KEY=[service_key_from_pagerduty]
    ```

    If you wish to debug without posting to PagerDuty:

    ```
    heroku config:add DEBUG=[http://requestb.in/blah]
    ```

- Ship it:

    ```
    git push heroku master
    ```

- Fire up a web process:

  ```
  heroku ps:scale web=1
  ```

## Running locally

- Clone this repository.
- In the clone run:

    ```
    bundle install
    ```

- Run it:

    ```
    PAGERDUTY_RELAY_TOKEN="[a_nice_long_random_unguessable_string]" PAGERDUTY_SERVICE_KEY="[service_key_from_pagerduty]" DEBUG="[http://requestb.in/blah]" bundle exec ./pagerduty-relay.rb
    ```

    Or, if you have the Heroku toolkit installed:

    ```
    PAGERDUTY_RELAY_TOKEN="[a_nice_long_random_unguessable_string]" PAGERDUTY_SERVICE_KEY="[service_key_from_pagerduty]" DEBUG="[http://requestb.in/blah]" foreman start
    ```

    Set the `DEBUG` environment variable to a Requestb.in URL to test without sending to PagerDuty.  You can optionally leave off the `PAGERDUTY_SERVICE_KEY` environment variable if you're not going to test PagerDuty integration.


## Test it:

    On Heroku:

    ```
    curl -X POST "http://[something].herokuapp.com/pagerduty?token=${PAGERDUTY_RELAY_TOKEN}" -d id=123456' -d 'org=My org.com' -d 'title=My GHE is broken'
    ```

    Locally:

    ```
    curl -X POST "http://127.0.0.1:4567/pagerduty?token=${PAGERDUTY_RELAY_TOKEN}" -d id=123456' -d 'org=My org.com' -d 'title=My GHE is broken'
    ```
