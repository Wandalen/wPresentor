(function _aCommon_js_() {

'use strict';

var _global = _global_;
var _ = _global.wTools;
var $ = jQuery;

// --
// checkers
// --

function eventIs( src )
{
  if( src instanceof Event )
  return true;
  if( typeof jQuery === 'undefined' )
  return false;
  if( src instanceof jQuery.Event )
  return true;
  return false;
}

//

function htmlIs( src )
{
  return _ObjectToString.call( src ).indexOf( '[object HTML' ) !== -1;
}

//

function jqueryIs( src )
{
  if( typeof jQuery === 'undefined' )
  return;
  return src instanceof jQuery;
}

//

function canvasIs( src )
{
  if( _.jqueryIs( src ) )
  src = src[ 0 ];
  if( src instanceof HTMLCanvasElement )
  return true;
  return false;
}

//

function imageIs( src )
{
  if( _.jqueryIs( src ) )
  src = src[ 0 ];
  if( src instanceof HTMLImageElement )
  return true;
  return false;
}

//

function imageLike( src )
{
  if( _.jqueryIs( src ) )
  src = src[ 0 ];
  if( src instanceof HTMLCanvasElement )
  return true;
  if( src instanceof HTMLImageElement )
  return true;
  return false;
}

//

function domIs( src )
{
  if( !_global.Node )
  return false;
  return src instanceof Node;
}

//

function domLike( src )
{
  if( !_global.Node )
  return false;
  if( src instanceof Node )
  return true;
  return jqueryIs( src );
}

//

function domableIs( src )
{
  return _.strIs( src ) || _.domIs( src ) || _.jqueryIs( src );
}

//
// dom
//

function domInclude( filePath )
{

  var ext = _.uri.ext( filePath );

  if( _.arrayHas( [ 'css', 'less' ], ext ) )
  {
    var link = document.createElement( 'link' );
    link.href = filePath;
    link.type = 'text/' + ext;
    link.rel = 'stylesheet';
    link.media = 'screen,print';
    document.head.appendChild( link );
  }
  else
  {
    var script = document.createElement( 'script' );
    script.src = filePath;
    document.head.appendChild( script );
  }

}

//

function headIs( src )
{
  return _.strTypeOf( src ) === 'HTMLHeadElement';
}

// --
// prototype
// --

var Proto =
{

  // checkers

  eventIs : eventIs,
  htmlIs : htmlIs,
  jqueryIs : jqueryIs,
  canvasIs : canvasIs,
  imageIs : imageIs,
  imageLike : imageLike,
  domIs : domIs,
  domLike : domLike,
  domableIs : domableIs,
  headIs : headIs,

  // dom

  domInclude : domInclude,

  _domBaselayer1Loaded : true,

}

_.mapExtend( _,Proto );

})();
