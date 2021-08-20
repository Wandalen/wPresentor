( function _Namespace_s_( ) {

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

  let content = self.exportString( src.nodes, o );

  if( _.strIs( src.text ) )
  content += src.text;

  let result = `<${src.kind}>${content}</${src.kind}>`;
  return result;
}

// --
// declare
// --

let Abstract = _.blueprint.define
({
  kind : 'Abstract',
  attrs : _.define.shallow( {} ),
})

let AbstractBranch = _.blueprint.define
({
  extension : _.define.extension( Abstract ),
  kind : 'AbstractBranch',
  nodes : _.define.shallow( [] ),
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

let A = _.blueprint.define
({
  extension : _.define.extension( AbstractBranch ),
  kind : 'a',
})

let Span = _.blueprint.define
({
  extension : _.define.extension( AbstractBranch ),
  kind : 'span',
  text : '',
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
  A,
  Span,

  _ : Restricts,

}

Object.assign( _.html, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
