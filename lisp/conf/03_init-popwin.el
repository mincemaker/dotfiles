(require 'popwin)

(setq display-buffer-function 'popwin:display-buffer)
(push '(" *auto-async-byte-compile *" :height 14 :position bottom :noselect t) popwin:special-display-config)
(push '("*VC-log*" :height 10 :position bottom) popwin:special-display-config)
