set clipboard+=unnamedplus
lua require('config')
lua require('null-ls')

function OpenMarkdownPreview (url)
  execute "silent ! google-chrome --new-window " . a:url
endfunction
let g:mkdp_browserfunc = 'OpenMarkdownPreview'

iab --> ➔
