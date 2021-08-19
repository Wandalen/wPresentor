( function _Namespace_s_( ) {

'use strict';

const _ = _global_.wTools;

_.presentor = _.presentor || Object.create( null );

let vectorize = _.routineDefaults( null, _.vectorize, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAll = _.routineDefaults( null, _.vectorizeAll, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAny = _.routineDefaults( null, _.vectorizeAny, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeNone = _.routineDefaults( null, _.vectorizeNone, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );

// --
// inter
// --

// --
// declare
// --

// let HtmlNode = _.blueprint.define
// ({
//   kind : 'Node',
//   text : null,
//   attrs : _.define.shallow( {} ),
// })
//
//
// let HtmlUl = _.blueprint.define
// ({
//   extension : _.define.extension( HtmlNode ),
//   kind : 'ul',
//   nodes : _.define.shallow( [] ),
// })
//
// let HtmlLi = _.blueprint.define
// ({
//   extension : _.define.extension( HtmlNode ),
//   kind : 'li',
//   nodes : _.define.shallow( [] ),
// })

let Restricts =
{
}

let Extension =
{

  // HtmlNode,
  // HtmlUl,
  // HtmlLi,

  _ : Restricts,

}

Object.assign( _.presentor, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
