# Config

This is my personal dotfiles repository, you shouldn't run these commands.

### Setup Script

    (if type -f curl&>/dev/null; then
       curl -sL https://raw.github.com/silas/config/master/setup
     elif type -f wget&>/dev/null; then
       wget -qO- https://raw.github.com/silas/config/master/setup
     else
       echo 'print "no curl or wget"'
     fi) | python
