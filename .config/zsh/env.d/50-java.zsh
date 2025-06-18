# Java Home (only if java_home exists) and LESS charset
[[ -x /usr/libexec/java_home ]] && export JAVA_HOME=$(/usr/libexec/java_home --version 1.8)
export LESSCHARSET=utf-8