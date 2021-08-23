( function _Html_s_()
{

'use strict';

const _ = _global_.wTools;

_.html = _.html || Object.create( null );

let vectorize = _.routineDefaults( null, _.vectorize, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAll = _.routineDefaults( null, _.vectorizeAll, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAny = _.routineDefaults( null, _.vectorizeAny, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeNone = _.routineDefaults( null, _.vectorizeNone, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );

// --
// inter
// --

function is( src )
{
  if( !_.map.is( src ) )
  return false;
  return true;
}

//

function exportString( src, o )
{
  let self = this;

  if( _.array.like( src ) )
  {
    src = src.map( ( e ) => self.exportString( e, o ) );
    return src.join( '\n' );
  }

  if( _.strIs( src ) )
  return src;

  _.assert( _.html.is( src ) );

  let content = '';
  if( src.nodes )
  content = self.exportString( src.nodes, o );

  const attrs = attrsConvert( src.attrs );
  let result = '';
  if( src.kind === 'img' )
  result = `<${src.kind}${attrs}>`;
  else
  result = `<${src.kind}${attrs}>${src.text||''}${content}</${src.kind}>`;
  return result;

  /* */

  function attrsConvert( attrs )
  {
    let result = '';
    if( attrs )
    for( let key in attrs )
    result += ` ${key}="${attrs[key]}"`;
    return result;
  }
}

// --
// declare
// --

let Abstract = _.blueprint.define
({
  kind : 'Abstract',
  attrs : _.define.shallow( {} ),
  nodes : _.define.shallow( [] ),
  text : '',
})

let AbstractBranch = _.blueprint.define
({
  kind : 'AbstractBranch',
  nodes : _.define.shallow( [] ),
  text : '',
})

let Ul = _.blueprint.define
({
  extension : _.define.extension( AbstractBranch ),
  kind : 'ul',
})

let Li = _.blueprint.define
({
  extension : _.define.extension( AbstractBranch ),
  kind : 'li',
})

let P = _.blueprint.define
({
  extension : _.define.extension( AbstractBranch ),
  kind : 'p',
})

let Span = _.blueprint.define
({
  extension : _.define.extension( AbstractBranch ),
  kind : 'span',
})

let A = _.blueprint.define
({
  extension : _.define.extension( Abstract ),
  kind : 'a',
})

let Img = _.blueprint.define
({
  extension : _.define.extension( Abstract ),
  kind : 'img',
})

let Restricts =
{
}

let Extension =
{

  is,
  exportString,

  Abstract,
  AbstractBranch,
  Ul,
  Li,
  P,
  Span,
  A,
  Img,

  _ : Restricts,

}

Object.assign( _.html, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();

