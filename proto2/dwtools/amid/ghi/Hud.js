( function _Hud_js_() {

'use strict';

var $ = jQuery;
var _ = _global_.wTools;
var Parent = null;
var Self = function wHud( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Hud';

//

function init( o )
{
  var self = this;

  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Composes );
  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Associates );
  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Restricts );

  if( o )
  self.copy( o );

  if( self.onViewHud === null )
  self.onViewHud = function( o )
  {
    return [
      '<div class="ui top attached segment hud layout-hud hidden">',
      '  <div class="ui top attached label">',
      ( _.objectIs( o ) && o.name ? o.name : 'View' ),
      '<i data-content="Pin" class="pin link icon"> </i> <i data-content="Maximize" class="maximize link icon"> </i> </div>',
      '<div class="hud-content">',
      '</div>',
    ].join( '\n' );
  }

  _.assert( _.routineIs( self.onViewHud ) );

  self.containerDom = _.domFirst( self.containerDom,'.panel.mid',document.body );
  self.containerDom = $( self.containerDom );

  if( self.data && !self.targetDom )
  self.form( self.data )

}

//

function finit()
{
  var self = this;

  self.hide();

  _.Copyable.prototype.finit.call( self );
  debugger;

}

//

function form( data )
{
  var self = this;
  var data = self.data = data || self.data;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.objectIs( data ) );

  /**/

  if( self.targetDom )
  self.targetDom.remove();

  var targetDom = self.targetDom = $( self.onViewHud( data ) );

  targetDom.css
  ({
    'display' : 'none',
  });

  if( self.usingFixedHeight )
  targetDom.css
  ({
    'height' : '30em',
  });

  targetDom.addClass( 'layout-hud','hud' );

  targetDom.appendTo( self.containerDom );

  self.contentDom = targetDom.find( '.hud-content' );

  if( !self.contentDom.length )
  self.contentDom = $( '<div>' ).addClass( 'hud-content' ).appendTo( targetDom );
  _.assert( self.contentDom.length );

  /* popup */

  targetDom
  .find( '[ title ],[ data-html ],[ data-content ]' )
  .popup
  ({
    'position' : 'top center',
    'exclusive' : true,
    'inline' : false,
    'delay' :
    {
      show : 1000,
      hide : 250,
    }
  });

  /*_.uiInitGeneric( targetDom );*/

  /* ability */

  _.domSubjective
  ({

    target : targetDom,
    onFocus : function( value )
    {
      if( this.attr( 'wdragging' ) )
      return;
      if( this.attr( 'wpinned' ) )
      return;
      if( !value )
      self.hide();
    }

  });

  if( self.resizable )
  _.domResizable
  ({
    targetDom : targetDom,
  });

  _.domDraggable
  ({

    target : targetDom,

  });

  _.domCopyable
  ({
    containerDom : targetDom,
    targetDom : 'input',
  });

  _.domCopyableHtmlText
  ({
    containerDom : targetDom,
    targetDom : '.copy.icon',
  });

  if( !self._pinnable )
  self._pinnable = _.domPinnable
  ({
    containerDom : targetDom,
    targetDom : '.pin.icon',
    onPin : function( value )
    {
      return self.onPin.call( self,value );
    }
  });

  self._pinnable.pin( self._initiallyPinned );

  return targetDom;
}

//

function show()
{
  var self = this;

  if( !self.targetDom )
  self.form( data );

  var targetDom = self.targetDom;

  /**/

  if( self.onShow() === false )
  return false;

  if( targetDom.hasClass( 'hidden' ) )
  {

    var x = self.position[ 0 ] - targetDom.width() / 2 - 10;
    var y = self.position[ 1 ] - 20;
    /*console.log( 'xy :',x,y );*/

    targetDom
    .css
    ({
      'left' : x,
      'top' : y,
    })
    ;

    targetDom.transition
    ({
      animation : self.transition,
      duration : self.duration,
    });

  }

  return true;
}

//

function hide()
{
  var self = this;
  var targetDom = self.targetDom;

  if( !targetDom )
  return true;

  if( self.onHide() === false )
  return false;

  self.targetDom = null;

  /*console.log( 'Hud.hide' );*/

  self.inside = 0;

  if( targetDom.hasClass( 'hidden' ) )
  {
    targetDom.remove();
    return true;
  }

  targetDom.find( '[ title ],[ data-html ],[ data-content ]' ).popup( 'hide' );

  targetDom.transition
  ({
    animation : self.transition,
    duration : self.duration,
    onComplete : _.routineJoin( targetDom, targetDom.remove ),
  });

  return true;
}

//

function centrate()
{
  var self = this;
  var targetDom = self.targetDom;
  var containerDom = self.containerDom;

  var size = _.domSizeGet( containerDom );
  self.position = [ size[ 0 ] / 2, size[ 1 ] / 2 ];

  return self;
}

// --
// accessor
// --

function _pinnedSet( src )
{
  var self = this;
  if( !self._pinnable )
  {
    self._initiallyPinned = src;
    return self._initiallyPinned;
  }
  return self._pinnable.pin( src );
}

//

function _pinnedGet()
{
  var self = this;
  if( !self._pinnable )
  {
    return self._initiallyPinned;
  }
  return self._pinnable.pin();
}

// --
// relations
// --

var Composes =
{

  onViewHud : null,
  onPin : function( value ){ return value },
  onShow : function(){ return true; },
  onHide : function(){ return true; },
  position : [ 0,0 ],
  pinned : 0,

  transition : 'horizontal flip',
  duration : 200,

  resizable : 0,

  usingFixedHeight : 1,

}

var Associates =
{
  containerDom : null,
  targetDom : null,
  contentDom : null,
  data : null,
  _pinnedSet : null,
}

var Restricts =
{
  _initiallyPinned : 0,
}

var Accessors =
{
  pinned : 'pinned',
}

// --
// proto
// --

var Proto =
{

  init : init,
  form : form,

  show : show,
  hide : hide,
  centrate : centrate,

  // accessor

  '_pinnedSet' : _pinnedSet,
  '_pinnedGet' : _pinnedGet,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
  //supplement : { Statics : Proto },
});

console.debug( 'REMINDER : ceck supplement : { Statics : Proto }' ); // '

//

_.Copyable.mixin( Self );
_.EventHandler.mixin( Self );

_.accessor( Self.prototype,Accessors );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
