( function _Editor_s_( ) {

'use strict';

var $ = jQuery;
var _ = _global_.wTools;
var Parent = wGhiAbstractModule;
var Self = function wHiEditor( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Editor';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );
  Object.preventExtensions( self );
}

//

// function exec( data )
// {
//   var proto = this;
//   var result = Object.create( null );
//   var data = data || '';
//
//   _.assert( !this.instanceIs() );
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//
//   result.data = data;
//   result.instance = new Self({});
//   result.consequence = _.timeReady( function()
//   {
//     if( !_.strIs( data ) && data !== undefined )
//     {
//       result.data = wConsequence.from( data );
//       result.data.doThen( function( err,data )
//       {
//         if( err )
//         throw _.errLogOnce( err );
//         result.data = data;
//         return proto._exec( result );
//       });
//       return result.data;
//     }
//     return proto._exec( result );
//   });
//
//   return result;
// }

//

function exec( data )
{
  var self = new this.Self();
  _.assert( !this.instanceIs() );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.timeReady( () => self._exec( data ) );
  return self;
}

//

function _exec( data )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  self.targetDom = _.domTotalPanelMake().targetDom;
  self._execDefaults( data );
  self.form();

  return self;
}

//

function _execDefaults( data )
{
  var self = this;

  if( data === undefined || data === null )
  data = _.fileProvider.fileRead( '/dwtools/amid/ghi/editor/Editor.s' );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  self.data = _.EditorData({ raw : data });

  return self;
}

//

function _formAct()
{
  var self = this;

  _.assert( self.data );

  Parent.prototype._formAct.call( self );
  self._formContentDom();

  _.assert( self.targetDom.length === 1 );

  self.textDom = self._formConentElementDom( self.textDomSelector );
  self.numbersDom = self._formConentElementDom( self.numbersDomSelector );

  self._textChanged();

}

//

function highlight( src )
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self._formedCon.split( () => self._highlight( src ) );
}

//

function _highlight( src )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( _.numberIs( src ) )
  {
    self.highlighted[ src ] = '';
  }
  else if( _.arrayIs( src ) )
  {
    debugger;
    _.mapSetWithKeys( self.highlighted,src,'' );
  }
  else _.mapExtend( self.highlighted,src );

  self._textChanged();
}

//

function focus( src )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( src ) );

  return self._formedCon.split( () => self._focus( src ) );
}

//

function _focus( src )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( src ) );

  var line = self.textDom.find( '[line=' + src + ']' );

  _.domScrollFocus
  ({
    elementDom : line,
    contentDom : self.targetDom,
    mode : 'center',
  });

}

//

function _textChanged()
{
  var self = this;

  _.assert( self.data );

  var numbers = '';
  for( var i = 1 ; i < self.data.lines.length ; i++ )
  numbers += i + ' \n';

  var text = [];
  for( var i = 0 ; i < self.data.lines.length ; i++ )
  if( self.highlighted[ self.data.firstLine + i ] === undefined )
  {
    text.push( self._makeLine
    ({
      text : self.data.lines[ i ],
      line : self.data.firstLine + i,
    }));
    text.push( '\n' );
  }
  else
  {
    text.push( self._makeHighlightedDom
    ({
      text : self.data.lines[ i ],
      line : self.data.firstLine + i,
      hint : self.highlighted[ self.data.firstLine + i ],
    }));
    text.push( '\n' );
  }

  self.textDom.empty();
  self.textDom.append( text );
  self.numbersDom.text( numbers );

}

//

function _makeLine( o )
{
  var self = this;

  var result = $( `<span>${o.text}</span>` );

  result.addClass( self.lineCssClass );
  result.attr( 'line',o.line );

  return result;
}

_makeLine.defaults =
{
  line : null,
  text : null,
}

//

function _makeHighlightedDom( o )
{
  var self = this;

  var result = self._makeLine( o );

  result.addClass( self.highlightedCssClass );

  if( o.hint )
  result.attr( 'title',o.hint );

  return result;
}

_makeHighlightedDom.defaults =
{
  hint : null,
}

_makeHighlightedDom.defaults.__proto__ = _makeLine.defaults;

// --
// relationship
// --

var Composes =
{

  dynamic : 0,
  highlighted : Object.create( null ),

  targetIdentity : '.weditor',
  highlightedCssClass : 'weditor-highligted',
  lineCssClass : 'weditor-line',

}

var Aggregates =
{

  data : null,

}

var Associates =
{

  targetDom : '.weditor',

  contentDomSelector : '{{targetDom}} > .content',
  contentDom : null,

  textDomSelector : '{{contentDomSelector}} > .text',
  textDom : null,

  numbersDomSelector : '{{contentDomSelector}} > .numbers',
  numbersDom : null,

}

var Restricts =
{
}

var Statics =
{
  exec : exec,
}

// --
// proto
// --

var Proto =
{

  init : init,

  _formAct : _formAct,

  exec : exec,
  _exec : _exec,
  _execDefaults : _execDefaults,

  highlight : highlight,
  _highlight : _highlight,

  focus : focus,
  _focus : _focus,

  _textChanged : _textChanged,

  _makeLine : _makeLine,
  _makeHighlightedDom : _makeHighlightedDom,


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

_.Instancing.mixin( Self );
_.EventHandler.mixin( Self );

_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;

//

// if( 0 )
// _global_.editor = Self.exec();

})( );
