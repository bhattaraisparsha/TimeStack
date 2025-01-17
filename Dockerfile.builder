FROM ruby:2.4.1

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive 

RUN apt-get install -yq --no-install-recommends build-essential 

RUN apt-key update
RUN apt-get update
RUN apt-get upgrade

RUN apt-get install nodejs --force-yes 

RUN apt-get install yarn --force-yes 


RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Create a user and a directory for the app code
RUN mkdir -p /app
WORKDIR /app

# Adding gems
ADD Gemfile yarn.lock package.json /app/

RUN bundle install && yarn install
