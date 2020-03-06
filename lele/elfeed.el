;;; lele/elfeed.el --- Lele's elfeed customization
;;

(require 'elfeed)
(require 'elfeed-goodies)

(esk/csetq elfeed-feeds
           '("https://planetpython.org/rss20.xml"
             "https://planet.emacslife.com/atom.xml"
             "https://planet.postgresql.org/rss20.xml"
             "https://nixos.org/blogs.xml"))

(esk/csetq elfeed-goodies/entry-pane-position 'bottom)

(elfeed-goodies/setup)
