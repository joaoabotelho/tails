FROM elixir:1.15-otp-25-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python3

RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# Copy the Elixir project files
COPY . .

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# webapp build
RUN npm install --quiet --prefix ./frontend
RUN npm run build --prefix ./frontend

# Define the path for frontend static assets in Phoenix
ENV PUBLIC_PATH ./priv/static/webapp

# Clean up any stale files and copy the frontend build artifacts
RUN rm -rf $PUBLIC_PATH
RUN cp -R ./frontend/dist $PUBLIC_PATH

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.18 AS app

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client libgcc libstdc++

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/tails .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["bash", "/app/entrypoint.sh"]