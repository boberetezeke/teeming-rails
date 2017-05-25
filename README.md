# README

**Warning: This is pre-alpha software. It is under development and in no way
ready for production use just yet. Please help contribute with code or feedback
or feature requests.**

## Ruby version

I build and run this using Ruby 2.4.0. I expect it to work on any ruby >
2.0.

## System dependencies

You'll need PostgreSQL running, either locally or via Docker.
Bundler should take care of everything else:

`bundle install`

## Configuration

Create a .env file from the example:

`cp .env-example .env`

Consider replacing the secret key with a new one with `rails secret`.

Sendgrid credentials are only required to send actual emails.
We could set this up for development previews and such, but currently we're just
hitting the Sendgrid API and using templates created on their site, so a local
preview would be pretty useless.

## Database creation

For local postgreSQL setup, consult the documentation for your operating
system.

Alternatively just use docker-compose. To do this you need to
have docker and docker-compose installed, and have docker running. Then
do:

`docker-compose up`

from the root directory of this project.

With postgreSQL running and the proper permissions configured:

`rails db:create`

## Database initialization

`rails db:migrate`

`rails db:seed`

If these fail, it's probably because of some sloppy non-deterministic
data migrations I created. Contact me and we'll get it sorted out.

## How to run the test suite

`rails test`

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

Deployment involves just a few quick steps:
1. build a docker image
`docker build -t aliencyborg/teeming-api .1
2. push that image to docker hub
`docker push aliencyborg/teeming-api`
3. log into the remote server (AlienCyb.org)
`ssh aliencyborg`
4. run the ansible task
`ansible-playbook ~/ansible/thebeast.yml -t teeming-api`

This will swap the old docker container with the new one without
touching the running database container or its data volume. To run any
data migrations or other ad hoc commands, use `docker exec -it teeming
api <command>`.
