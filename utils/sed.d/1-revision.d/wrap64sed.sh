#!/bin/sh

export FPARM=$1

plusFn() {
    # echo -n "first parm is: "
    # echo $FPARM
    sed -E -f iwrap64.sed $FPARM | \
        xxd -r -p       | \
        fold -b1024     | \
        fold -b64       | \
        sed 's/\x00$//' | \
        tr -s '  / /'   | \
        sed 's/^ $//'   | \
        sed 's/ $//'
}

origFn() {
    sed -E -f iwrap64.sed ${1} | \
        xxd -r -p | \
        fold -b1024 | \
        fold -b64 | \
        tr -d '\000$' | \
        tr -s '  / /' | \
        sed 's/^ $//' | \
        sed 's/ $//'
}

plusFn

exit 0

cat << _EOF__
# outer loop
:x

# Append a newline followed by the next input line to the pattern buffer
N

# Remove all newlines from the pattern buffer
s/\n/ /g

# Inner loop
:y

# Add a newline after the first 64 characters
s/(.{64,64})/\1\n/

# If there is a newline in the pattern buffer
# (i.e. the previous substitution added a newline)
/\n/ {
    # There are newlines in the pattern buffer -
    # print the content until the first newline.
    P

    # Remove the printed characters and the first newline
    s/.*\n//

    # branch to label 'y' - repeat inner loop
    by
}

# No newlines in the pattern buffer - Branch to label 'x' (outer loop)
# and read the next input line
bx

# The wrapped output:
#   $ sed -E -f wrap40.sed two-cities-

_EOF__
# end.
