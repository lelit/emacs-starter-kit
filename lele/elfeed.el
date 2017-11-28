;;; lele/elfeed.el --- Lele's elfeed customization
;;

(require 'elfeed)
(require 'elfeed-goodies)

(csetq elfeed-feeds
       '("http://planetpython.org/rss20.xml"
         "http://planet.emacsen.org/atom.xml"
         "https://planet.postgresql.org/rss20.xml"))

(csetq elfeed-goodies/entry-pane-position 'bottom)

(elfeed-goodies/setup)
