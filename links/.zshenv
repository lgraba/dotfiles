# some global env vars
export DEFAULT_USER=logan
export GREP_COLOR='1;33'
export EDITOR="vim"
export TERM=xterm-256color-italic

# add all env files from env.d
for env_file in $(find ~/.env.d/ -name "*.env"); do
	source $env_file
done

# add global aliases
source ~/.aliases

# reload the shell
alias reload="exec ${SHELL} -l"
