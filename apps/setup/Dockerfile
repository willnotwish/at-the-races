# Stage 1: dev
FROM ruby:2.5.8 AS dev

RUN apt-get update -qq && apt-get install -y \
  lsb-release \
  build-essential \
  git \
  less \
  tzdata \
  curl

RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

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
