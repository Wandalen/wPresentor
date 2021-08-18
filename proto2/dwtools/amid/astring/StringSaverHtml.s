( function _StringSaverHtml_js_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './StringSaver.s' );

}

var $ = jQuery;
var _ = _global_.wTools;
var Parent = _.StringSaver;
var Self = function wStringSaverHtml( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'StringSaverHtml';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
}

//

function tag_functor( t )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  return function tag( text )
  {
    var self = this;
    _.assert( arguments.length === 1, 'expects single argument' );
    self.out += '<' + t + '>' + text + '</' + t + '>';
    return self;
  }
}

//

function init_class()
{
  var proto = this.Self.prototype;
  for( var t = 0 ; t < proto.KnownTags.length ; t++ )
  {
    var tag = proto.KnownTags[ t ];
    _.assert( !proto[ tag ] );
    proto[ tag ] = tag_functor( tag );
    _.assert( _.routineIs( proto[ tag ] ) );
  }
}

//

function paragraph( content,wrap )
{
  var self = this;
  _.assert( arguments.length === 1 || arguments.length === 2 );

  content = _.strStripRight( content );

  if( wrap )
  self.out += '<' + wrap + '>' + content + '</' + wrap + '>';
  else
  self.out += content;

  return self;
}

// --
// relationship
// --

var Composes =
{
}

var Associates =
{
}

var Restricts =
{
}

var Statics =
{
  KnownTags : [ 'a','b','span','p','h1','h2','h3','h4','h5' ],
}

// --
// declare
// --

var Proto =
{

  init : init,
  tag_functor : tag_functor,
  init_class : init_class,

  paragraph : paragraph,

  //

  
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

Self.prototype.init_class();

//

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})( );
