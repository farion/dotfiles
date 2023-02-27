set clipboard+=unnamedplus
lua require('config')

function OpenMarkdownPreview (url)
  execute "silent ! google-chrome --new-window " . a:url
endfunction
let g:mkdp_browserfunc = 'OpenMarkdownPreview'

iab --> ➔
