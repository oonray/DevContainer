FROM debian:latest
RUN apt-get update && apt-get install -y curl git zsh

WORKDIR /tmp

ARG GO_VERSION
RUN curl -LO https://go.dev/dl/$GO_VERSION.linux-amd64.tar.gz
RUN rm -rf /usr/local/go
RUN tar -C /usr/local -xvzf "$GO_VERSION.linux-amd64.tar.gz"

ARG EMACS_VERSION
RUN curl -LO "http://ftp.gnu.org/gnu/emacs/emacs-$EMACS_VERSION.tar.gz"
RUN tar -xvzf "emacs-$EMACS_VERSION.tar.gz"

WORKDIR emacs-$EMACS_VERSION
RUN ./configure
RUN make && make install

RUN RUN useradd -ms /bin/zsh oonray
USER oonray

WORKDIR /home/oonray

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY .zshrc .zshrc

RUN nvm install node npm
RUN npm install --global yarn

RUN git clone --depth 1 https://github.com/doomemacs/doomemacs /home/oonray/.emacs.d
RUN .emacs.d/bin/doom install

COPY config.el .doom.d
COPY init.el .doom.d
COPY packages.el .doom.d
RUN .emacs.d/bin/doom sync
