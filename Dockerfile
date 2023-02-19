FROM debian:latest
RUN apt-get update && apt-get install -y curl git zsh

WORKDIR /tmp

RUN  rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz

RUN EMACS_VERSION=$(curl http://ftp.gnu.org/gnu/emacs/ | tr -dc "[^a-zA-Z0-9 \\n\.]+" | grep -oE "[0-9]{1,3}.[0-9]{1,3}.tar.gz" | uniq |sort |  awk 'END{print}'|$EMACS_VERSION | sed "s/.tar.gz//g")
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
