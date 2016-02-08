export PATH="/usr/local/texlive/2015/bin/universal-darwin/:$PATH"
tlmgr update --self
tlmgr update --list
tlmgr update --all

port selfupdate
port outdated
port upgrade outdated

