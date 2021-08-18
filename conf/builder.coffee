
public :

  name          : 'wPresentor'
  description   : 'Description of the application'


private :

  path :

    app             : '.'
    #electron        : 'electron.tmp'
    proto           : 'proto'
    staging         : 'staging'
    production      : 'production'
    file            : 'file'

    temp            : 'temp.tmp'

    server          : 'server'
    serverConfig   : '{{path.server}}'
    serverInclude   : '{{path.server}}/include'


  mask :

    model                     : /\.((obj)|(stl)|(max)|(w4d)|(awd))$/
    image                     : /\.((jpg)|(png)|(tiff)|(ico)|(svg)|(gif))$/
    sound                     : /\.((ogg)|(mp3))$/
    bin                       : /\.((zip)|(exe))$/
    resource                  : [ '{{mask.model}}','{{mask.image}}','{{mask.sound}}','{{mask.bin}}' ]

    exclude                   : [ /(^|\/)-/,/(^|\/)\.(?!$|\/)/ ]
    external                  : /\.external($|\.|\/)/
    debug                     : [ /\.debug($|\.|\/)/, /\.test($|\.|\/)/ ]
    release                   : [ /\.release($|\.|\/)/ ]
    staging                   : [ /\.staging($|\.|\/)/ ]
    production                : [ /\.production($|\.|\/)/ ]
    manual                    : /\.manual($|\.|\/)/

    document                  : [ '{{mask.hyper_text_to_html}}','{{mask.hyper_text_compiled}}' ]

    script                    : /\.s$/
    client_script             : /\.js$/
    server_script             : /\.ss$/
    any_script                : [ '{{mask.script}}','{{mask.client_script}}','{{mask.server_script}}' ]
