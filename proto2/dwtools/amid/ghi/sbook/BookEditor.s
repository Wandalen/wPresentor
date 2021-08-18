( function _BookEditor_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './Book.s' );
  require( '../editor/Editor.s' );

}

var $ = jQuery;
var _ = _global_.wTools;
var Parent = _.ghi.Book;
var Self = function wHiBookEditor( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'BookEditor';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );

  self.editor = new _.ghi.Editor({ targetDom : self.pageDomSelector });

}

//

function _execDefaults()
{
  var self = this;

  _.assert( arguments.length === 0 );

  Parent.prototype._execDefaults.call( self );

  if( self.editor )
  self.editor._execDefaults();

  return self;
}

//

function _formAct()
{
  var self = this;

  Parent.prototype._formAct.call( self );

  _.assert( self.targetDom.length > 0 );
  _.assert( self.pageDom.length > 0 );

  if( self.editor )
  self.editor.form();

}

//

function onPageGet( node )
{
  // debugger;
  return node.page;
}

// --
// relationship
// --

var Composes =
{

  targetIdentity : '.wbook.wbook-editor',
  onPageGet : onPageGet,

}

var Aggregates =
{

}

var Associates =
{

  targetDom : '.wbook-editor',
  editor : null,

}

var Restricts =
{
}

var Statics =
{
}

// --
// proto
// --

var Proto =
{

  init : init,

  _execDefaults : _execDefaults,
  _formAct : _formAct,

  //

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
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

_.assert( !!Parent );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

//

if( 0 )
Self.exec();

})( );
