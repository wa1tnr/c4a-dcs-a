#!/bin/sh
# Sun 22 Dec 15:42:13 UTC 2024

# process the output of the c4a dump word, captured
# to a disk file on a Linux host PC.

# results more suitable for re-upload back to the
# c4a 'editor'.

# in this way, something of forth source code archive
# is generated, later to be stored on a Linux host.

# tools (in Linux amd64 ref sys Debian Bookworm):
#  * script (outputs 'typescript'),
#  * picocom (like minicom),
#  * the c4a 'dump' word,
#  * vim (to strip unwanted columns in the output of 'dump'
#  * xxd (to recreate a binary image from a hexdump)
#  * sed (to do transforms on the binary image)
#  * tr  (simpler than sed for some uses)

#  block.fth is considered a 'binary' file in that it has
#  embedded control chars; the hexdump (c4a dump word output)
#  also seems to capture nulls and other junk chars
#  (taken to be storage related 'housekeeping' bytes?)

# transform 'easy' to generate database dump of blocks.fth
# to a form that can be ascii-uploaded back to the rp2350
# target running c4a.

# accepts an input file,
# the format of which is a raw dump from inside c4a,
# stripped of the left and right columns, transformed
# by   xxd -r -p infile outfile
# to recreate the binary image (mostly text, some
# control chars and the NULL char) from the dump.

# vim recipe
#    :%s/^..........//g
#    :%s/....................$//g
#    :%s/[]//g

# clean up the database after using xxd, by removing
# obvious junk.  But, let the sed utterances (below)
# clean up the more algorithmic stuff like many spaces
# and the unwanted null (^@ in vim, \x00 in sed) chars.

# these instructions have not been parsed for correctness
# nor sequencing. ;)

# ################################################################
# #############                                      #############
# #############  sed, tr based   scripting follows   #############
# #############                                      #############
# ################################################################

sed -E -f pwrap64.sed ${1} | \
    sed -e 's/\x00//g'     | \
    tr -s ' '              | \
    sed -e 's/ $//g'

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
