( function _Book_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../Abstract.js' );
  require( '../atree/aTree.s' );

  var _ = _global_.wTools;

  _.include( 'wDomBaseLayer1' );
  _.include( 'wDomBaseLayer3' );
  _.include( 'wDomBaseLayer5' );

}

//

var $ = jQuery;
var _ = _global_.wTools;
var Parent = wGhiAbstractModule;
var Self = function wHiBook( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Book';

_.assert( _.routineIs( _.domTotalPanelMake ) );

// --
//
// --

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );

  self._resolveDoms();

  self.tree = new _.ghi.HiTree({ targetDom : self.treeDomSelector });

}

//

function exec()
{
  var self = new this.Self();
  _.assert( !this.instanceIs() );
  _.assert( arguments.length === 0 );
  _.timeReady( () => self._exec() );
  return self;
}

//

function _exec()
{
  var self = this;

  _.assert( arguments.length === 0 );

  self.targetDom = _.domTotalPanelMake().targetDom;
  self._execDefaults();
  self.form();

  return self;
}

//

function _execDefaults()
{
  var self = this;

  _.assert( arguments.length === 0 );

  if( self.tree )
  self.tree._execDefaults();

  return self;
}

//

function _formAct()
{
  var self = this;

  Parent.prototype._formAct.call( self );

  _.assert( self.targetDom.length === 1 );

  /* form doms */

  self._formContentDom();
  self.contentDom[ 0 ].setAttribute( 'tabindex', '0' );

  self.headDom = self._formConentElementDom( self.headDomSelector );
  self._formContent2Dom();

  var treeDom = self._formConent2ElementDom( self.treeDomSelector );
  self.pageDom = self._formConent2ElementDom( self.pageDomSelector );

  /* form tree */

  // self.tree.targetDom = treeDom;

  self.tree.form();
  self.tree.on( 'nodeActivate', ( e ) => self.nodeActivateHandle( e ) );

  // if( self.focusingOnTree )
  // self.contentDom.on( 'focus', function()
  // {
  //   // self.tree.contentDom.focus();
  //   // console.log( 'focus',document.activeElement );
  //   // _.timeOut( 10,function()
  //   // {
  //   //   console.log( 'focus',document.activeElement );
  //   // });
  //   // debugger;
  // });

}

//

function nodeActivateHandle( e )
{
  var self = this;

  var page = self.onPageGet( e.node,self );
  if( _.routineIs( page ) )
  page = page.call( self,e.node,self );

  _.assert( page === null || _.strIs( page ) );

  if( page === null )
  self.pageDom.html( '' );
  else
  self.pageDom.html( page );

}

//

function onPageGet( node )
{
  debugger;
  return node.page;
}

// --
// relationship
// --

var Composes =
{

  dynamic : 0,
  targetIdentity : '.wbook',
  onPageGet : onPageGet,

}

var Aggregates =
{

}

var Associates =
{

  targetDom : '.wbook',
  pageDom : null,
  headDom : null,
  content2Dom : null,

  contentDomSelector : '{{targetDom}} > .content',
  content2DomSelector : '{{targetDom}} > .content > .content',

  headDomSelector : '{{targetDom}} > .content > .head',
  treeDomSelector : '{{targetDom}} > .content > .content > .wtree',
  pageDomSelector : '{{targetDom}} > .content > .content > .page',

  tree : null,
  source : null,

}

var Restricts =
{
}

var Statics =
{
  exec : exec,
}

var Forbids =
{
  focusingOnTree : 'focusingOnTree',
}

// --
// proto
// --

var Proto =
{

  init : init,

  exec : exec,
  _exec : _exec,
  _execDefaults : _execDefaults,

  _formAct : _formAct,
  nodeActivateHandle : nodeActivateHandle,

  //

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,

}

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

_.Instancing.mixin( Self );
_.EventHandler.mixin( Self );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

//

if( 0 )
Self.exec();

})( );
