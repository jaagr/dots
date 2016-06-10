### Alias
~~~ sh
alias dots='git --git-dir=$HOME/.dots.git/ --work-tree=$HOME'
~~~

### Setup
~~~ sh
git init --bare $HOME/.dots.git
dots remote add origin https://github.com/jaagr/dots.git
~~~

### Configuration
~~~ sh
# Use "dots untracked" to list files not added to the repository
dots config alias.untracked "status -u ."
dots config status.showUntrackedFiles no
~~~

### Usage
~~~ sh
# Use the dots alias as you'd use the git command
dots status
dots add ...
dots commit -m "..."
dots pull --rebase
dots push
~~~

### Replication
~~~ sh
git clone --separate-git-dir=$HOME/.dots.git https://github.com/jaagr/dots.git /tmp/dots
rsync -rv --exclude ".git" /tmp/dots $HOME/
rm -r /tmp/dots
~~~
