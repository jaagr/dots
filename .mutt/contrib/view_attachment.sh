#!/bin/bash
#
# Original: Eric Gebhart, 2013.02.17
#           https://github.com/EricGebhart/view_attachment
#
# Modifications: Brandon Amos
#                https://github.com/bamos/dotfiles
#   [2014.04.03] Support Linux and OSX.
#
# Purpose: To be called by mutt as indicated by .mailcap to handle
#   mail attachments.

tmpdir="/tmp/mutt_attach"

type=$2
open_with=$3

mkdir -p $tmpdir

# Mutt puts everything in /tmp by default.
# This gets the basic filename from the full pathname.
filename=`basename $1`

# get rid of the extenson and save the name for later.
file=`echo $filename | cut -d"." -f1`

# if the type is empty then try to figure it out.
if [ -z $type ]; then
    type=`file -bi $1 | cut -d"/" -f2`
fi

# if the type is '-' then we don't want to mess with type.
# Otherwise we are rebuilding the name.  Either from the
# type that was passed in or from the type we discerned.
if [ $type = "-" ]; then
    newfile=$filename
else
    newfile=$file.$type
fi

newfile=$tmpdir/$newfile

# Copy the file to our new spot so mutt can't delete it
# before the app has a chance to view it.
cp $1 $newfile

case $(uname) in
  "Linux")
    if [ -z $open_with ]; then
      xdg-open $newfile
    else
      # TODO - handle this case
      $open_width $newfile
    fi
  ;;
  "Darwin")
    if [ -z $open_with ]; then
      open $newfile
    else
      open -a "$open_with" $newfile
    fi
  ;;
esac
