#
# Directories and files
#
set tmpdir           = ~/.mutt/cache/tmp
set header_cache     = ~/.mutt/cache/headers
set message_cachedir = ~/.mutt/cache/bodies
set certificate_file = ~/.mutt/certificates
set alias_file       = ~/.mutt/aliases
set mailcap_path     = ~/.mutt/mailcap
set signature        = ~/.mutt/signature

source ~/.mutt/aliases
#source ~/.mutt/gpgrc
source ~/.mutt/themes/base16-eighties

#
# Account details
#
set realname = "Michael Carlberg"
set imap_user = "michael.carlberg@live.se"
set imap_pass = "PASSWORD"
set spoolfile = "imaps://imap-mail.outlook.com:993/Inbox"
set smtp_url = "smtp://yourname@smtp.gmail.com:587"
set folder = "imaps://imap-mail.outlook.com:993"
set postponed = "outlook/Drafts"
unset record
unset imap_passive
set imap_check_subscribed = yes

#
# General parameters
#
set sendmail_wait = 1
set mail_check = 300
set timeout = 3
set beep_new = yes
set check_new = yes
set send_charset = "us-ascii:utf-8"
set mail_check_stats = yes
set crypt_autosign = yes

set date_format = "[%d/%m/%y] [%I:%M%P]"
set index_format = "%3C [%Z] %D %-20.18F //   %s"
set alias_format = "%4n %t %-20a %r"

set editor = vim
set envelope_from
set smart_wrap = yes
set allow_ansi = yes
set sig_on_top = no
set sig_dashes = no
set edit_headers
set fast_reply
set askcc
set fcc_attach
unset mime_forward
set forward_format  = "Fwd: %s"
set forward_decode
set attribution = "%n, %d:"
set reverse_name
set include
set forward_quote
set reply_to
set abort_nosubject = yes
set pipe_decode
set thorough_search
set tilde

set move
set delete
set quit
unset confirmappend
unset mark_old

#set pager_context = 3
#set pager_index_lines = 10
#set pager_context = 35
#set pager_stop = yes

set sort = threads
#set sort = reverse-last-date-received
set sort_re
set sort_aux = last-date-received
set sort_alias = alias
set reverse_alias
set uncollapse_jump
set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
set menu_scroll
set markers = no
set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
auto_view text/html
alternative_order text/html text/enriched text/plain

set status_chars = " *%A"
set status_format = "───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───"
set sidebar_visible = yes
set sidebar_width = 30
#color sidebar_new magenta default
#color status red default
#color progress white magenta

#
# Headers
#
ignore *
unignore from: to: cc: date: subject:
unhdr_order *
hdr_order date: from: to: cc: subject:
set hdrs=yes

#
# Keybindings
#
bind pager q         exit
bind pager /         search
bind pager <up>      previous-line
bind pager <down>    next-line
bind pager k         previous-line
bind pager j         next-line
bind pager gg        top
bind pager G         bottom
bind index gg        first-entry
bind index G         last-entry
bind pager K         previous-undeleted
bind pager J         next-undeleted
bind index K         previous-unread
bind index J         next-unread
bind index,pager R   group-reply
bind index,pager \CP sidebar-prev
bind index,pager \CN sidebar-next
bind index,pager \CO sidebar-open

#
# Macros
#
macro index S "<save-message>outlook/spam<enter>"  "mark message as spam"
macro index D "<save-message>outlook/trash<enter>" "move message to the trash"
macro index \Cr "<tag-prefix><clear-flag>N" "mark tagged messages as read"
macro index <esc>m "T~N<enter>;WNT~O<enter>;WO\CT~T<enter>" "mark all messages read"
macro index B "<limit>~b " "search message bodies"
macro index I "<change-folder>!<enter>" "open inbox"
macro index P "<pipe-message>cat > ~/" "save message as"
macro attach "V" "<pipe-entry>cat >~/.cache/mutt/mail.html && qutebrowser --target tab ~/.cache/mutt/mail.html &>/dev/null && rm ~/.cache/mutt/mail.html<enter>"

# vim:ft=muttrc
