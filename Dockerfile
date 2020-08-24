FROM elixir:1.10.3

RUN apt-get update -qq && apt-get install -y libpq-dev && apt-get install -y build-essential inotify-tools erlang-dev erlang-parsetools apt-transport-https ca-certificates && apt-get update

#node js
RUN apt-get install -y curl bash ca-certificates openssl coreutils python2 make gcc g++ grep util-linux binutils findutils && apt-get update
ENV NVM_DIR  /root/.nvm
ENV NODE_VERSION 12.18.3
ENV npm_config_user=root

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm -g install chrome-headless-render-pdf puppeteer

# for chrome renderer puppeteer. doesnt work without it
RUN apt-get install -y chromium

#for System.find_executable
ENV PATH /root/.nvm/versions/node/v12.18.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN mix local.hex --force && mix local.rebar --force
RUN mix archive.install hex phx_new 1.5.1 --force

RUN mkdir /home/app && cd /home/app

ARG MIX_ENV
ENV MIX_ENV $MIX_ENV

ADD entrypoint.sh /entrypoint.sh

WORKDIR /home/app

CMD [ "/entrypoint.sh" ]