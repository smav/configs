# .bash_logout:  execute on shell logout

# Clear the screen on logout to prevent information leaks, if not already
# set as an exit trap elsewhere
[ "$PS1" ] && clear
