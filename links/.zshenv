# some global env vars
export DEFAULT_USER=augustin
export GREP_COLOR='1;37'
export EDITOR="vim"
export PATH="$HOME/.bin:$PATH"

# add all env files from env.d
for env_file in $(find ~/.env.d/ -name "*.env"); do
	source $env_file
done

# add global aliases
source ~/.aliases

# reload the shell
alias reload="exec ${SHELL} -l"
