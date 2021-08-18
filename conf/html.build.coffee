
scenario      : 'html.scenario' # name of scenario
enabled       : 1

fastest       : 1 # is optimization, fastest possible
pretty        : 0 # is output pretty

usingClosureCompiler  : 0 # using closure compiler
usingMinifier         : 1 # using js minifier
compressCss           : 1 # using css compress

absolute      : 1 # absolute / relative URLs

path :

  'staging' : './staging',
  'production' : './production',
  'deck' : './file/model',
  'file' : './file',

mask :

  style                     : [ '.less', '.css' ]
  style_compiled            : [ '.css' ]
  any_style                 : [ '.less', '.css' ]

  chunk                     : /\.chunk$/
  exclude_script            : [ /private\//,'nodeserver' ]

  # script                    : /\.s$/
  # client_script             : /\.js$/
  # server_script             : /\.ss$/
  # any_script                : [ '{{mask.script}}','{{mask.client_script}}','{{mask.server_script}}' ]

  hyper_text_compiled       : /\.((html)|(htm))$/
  hyper_text_source         : /\.jade$/
  hyper_text_to_jscript     : /\.jht$/
  hyper_text_to_html        : /\.hht$/
  hyper_text_to_chunk       : /\.cht$/
  hyper_text_to_server      : /\.sht$/

  hyper_text_any            : [
    '{{mask.hyper_text_compiled}}'
    '{{mask.hyper_text_source}}'
    '{{mask.hyper_text_to_jscript}}'
    '{{mask.hyper_text_to_html}}'
    '{{mask.hyper_text_to_chunk}}'
    '{{mask.hyper_text_to_server}}'
  ]

  hyper_text_compile        : [
    '{{mask.hyper_text_to_jscript}}'
    '{{mask.hyper_text_to_html}}'
    '{{mask.hyper_text_to_chunk}}'
  ]

  server_file               : [
    '{{mask.script}}'
    '{{mask.server_script}}'
    '{{mask.hyper_text_source}}'
    '{{mask.hyper_text_to_server}}'
    /\.md$/i
  ]

  document                  : [ '{{mask.hyper_text_to_html}}','{{mask.hyper_text_compiled}}' ]
