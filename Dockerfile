FROM debian:latest
RUN apt-get update
RUN apt-get install -y curl \
    git zsh build-essential pkg-config
RUN apt-get install -y build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev libncurses-dev
RUN apt-get install -y libgnutls28-dev
WORKDIR /tmp

ARG GO_VERSION
ARG EMACS_VERSION
RUN echo "go version: $GO_VERSION"
RUN echo "emacs version: $EMACS_VERSION"

RUN curl -LO https://go.dev/dl/$GO_VERSION.linux-amd64.tar.gz
RUN rm -rf /usr/local/go
RUN tar -C /usr/local -xvzf $GO_VERSION.linux-amd64.tar.gz

RUN curl -LO http://ftp.gnu.org/gnu/emacs/emacs-$EMACS_VERSION.tar.gz
RUN tar -xvzf emacs-$EMACS_VERSION.tar.gz

WORKDIR emacs-$EMACS_VERSION
RUN ./autogen.sh
RUN ./configure
RUN make && make install

RUN useradd -ms /bin/zsh oonray
USER oonray
WORKDIR /home/oonray

RUN /usr/local/go/bin/go install golang.org/x/tools/gopls@latest

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY .zshrc .zshrc

RUN /bin/bash -c 'source $HOME/.nvm/nvm.sh && nvm install node npm && npm install --gloabl yarn'

RUN git clone --depth 1 https://github.com/doomemacs/doomemacs /home/oonray/.emacs.d
RUN .emacs.d/bin/doom -y install

COPY config.el .doom.d
COPY init.el .doom.d
COPY packages.el .doom.d
RUN .emacs.d/bin/doom -y sync
