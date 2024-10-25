# Stage 1: dev
FROM ruby:2.5.8 AS dev

# # We need yarn for webpacker
# RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y \
  yarn \
  lsb-release \
  build-essential \
  git \
  less \
  tzdata

  # nodejs

# Include a non-root user (default: nick)
ARG USERNAME=nick
RUN useradd -ms /bin/bash $USERNAME

ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME

# Add add sudo support for the non-root user
RUN apt-get install -y sudo
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /app

CMD ["ruby", "-v"]

# CMD ["rails", "server", "-b", "0.0.0.0"]

# # 
# # Stage 2: build the production Rails image from the current code
# # 
# FROM dev AS prod

# WORKDIR /app

# # Copy any local gems first
# COPY vendor/gems /app/vendor/gems/

# # Now bundle the required gems
# COPY Gemfile /app/
# COPY Gemfile.lock /app/

# # RUN bundle config --global frozen 1
# RUN bundle install --deployment --without development test --jobs 4 --frozen

# # Add the application
# COPY . .
# RUN mkdir /app/tmp && mkdir /app/log

# CMD ["rails", "server", "-b", "0.0.0.0"]

# # 
# # Stage 3: precompile assets
# # 
# FROM prod AS assets

# # Rails needs a database connection to precompile assets
# # See http://www.carlos-roque.com/2020/12/09/assets-precompile-without-a-database-in-rails-4-and-5/
# RUN bundle exec rake RAILS_ENV=production DATABASE_URL=nulldb://user:pass@127.0.0.1/dbname assets:precompile
