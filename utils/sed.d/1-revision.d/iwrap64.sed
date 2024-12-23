s/[]//g
# s///g
# s///g
# s///g
# s///g
# s///g
s/-fopen:fh=1,md=r-//g

# remove empty lines:
/^$/d
# strip BOL columns for hex addresses:
s/^..........//g
# strip Eol columns for ascii chars:
s/....................$//g
