( function _RangeSlider_js_( ) {

'use strict';

var $ = jQuery;
var _ = _global_.wTools;
var Parent = wGhiAbstractModule;
var Self = function wGhiRangeSlider( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'RangeSlider';

//

function finit()
{
  var self = this;

  self.off( 'changed' );

  self.targetDom.empty();

  Parent.prototype.finit.call( self );
}

//

function init( o )
{
  var self = this;

  self[ symbolForValues ] = null;
  self[ symbolForDefaultValues ] = null;
  self[ symbolForValueRange ] = null;
  self[ hintSymbol ] = null;

  Parent.prototype.init.call( self,o );

  if( o.values !== undefined && o.values !== null )
  _.assert( 0,'setting values in constructor is not implemented' );

  self._initState();

}

//

function _initState()
{
  var self = this;

  if( self.defaultValues === null )
  {
    var defaultValues = self[ symbolForDefaultValues ] = [];
    if( self.numberOfSliders === 1 )
    defaultValues[ 0 ] = self.valueRange[ 0 ];
    else for( var s = 0 ; s < self.numberOfSliders ; s++ )
    defaultValues[ s ] = self.valueRange[ 0 ] + ( self.valueRange[ 1 ] - self.valueRange[ 0 ] ) * s / ( self.numberOfSliders - 1 );
  }

  self._evalDefaultNormals();

  if( !self._normals && !self.values )
  {
    var defaultValues = self[ symbolForDefaultValues ];
    self[ symbolForValues ] = _.dup( null,self.numberOfSliders );
    self._normals = _.dup( null,self.numberOfSliders );
    self._valuesSet( defaultValues );
  }

  _.assert( self[ symbolForValues ].length === self._normals.length );

}

//

function _formAct()
{
  var self = this;

  Parent.prototype._formAct.call( self );

  _.assert( arguments.length === 0 );
  _.assert( self.valueRange.length === 2 );
  _.assert( self.backDom.length >= 1 );

  /* state */

  // if( self.defaultValues === null )
  // {
  //   var defaultValues = self[ symbolForDefaultValues ] = [];
  //   if( self.numberOfSliders === 1 )
  //   defaultValues[ 0 ] = self.valueRange[ 0 ];
  //   else for( var s = 0 ; s < self.numberOfSliders ; s++ )
  //   defaultValues[ s ] = self.valueRange[ 0 ] + ( self.valueRange[ 1 ] - self.valueRange[ 0 ] ) * s / ( self.numberOfSliders - 1 );
  // }
  //
  // self._evalDefaultNormals();
  // self[ symbolForValues ] = _.dup( null,self.numberOfSliders );
  // self._normals = _.dup( null,self.numberOfSliders );
  // self._valuesSet( defaultValues );

  self._initState();

  _.assert( self[ symbolForValues ].length === self._normals.length );

  /* dom */

  var eventsBindWatcher = _.eventsBindWatcher();

  self._backSize = _.domSizeGet( self.backDom );

  _.uiInitPopups( self.targetDom );

  if( self.backDomCssClass )
  self.backDom.addClass( self.backDomCssClass );

  if( !self.usingCancel )
  self.cancelDom.addClass( self.invisibleCssClass );
  else
  self.cancelDom.removeClass( self.invisibleCssClass );

  if( !self.usingClose )
  self.closeDom.addClass( self.invisibleCssClass );
  else
  self.closeDom.removeClass( self.invisibleCssClass );

  if( !self.usingFidelityButtons )
  {
    self.increaseDom.addClass( self.invisibleCssClass );
    self.decreaseDom.addClass( self.invisibleCssClass );
  }
  else
  {
    self.increaseDom.removeClass( self.invisibleCssClass );
    self.decreaseDom.removeClass( self.invisibleCssClass );
  }

  if( self.numberOfSliders >= 0 )
  for( var i = self.numberOfSliders ; i < self.slidersDom.length ; i++ )
  $( self.slidersDom[ i ] ).addClass( self.invisibleCssClass );

  self._fidelityOpen( !self.usingHideButtons );
  self._cancelOpen( !self.usingHideButtons );
  self._closeOpen( !self.usingHideButtons );

  /* popup text */

  if( _.strIs( self.popupText ) )
  {
    self.targetDom.attr( 'data-content',self.popupText );
  }
  else
  {
    var popupText = self.targetDom.attr( 'data-content' );
    if( _.strIs( popupText ) )
    self.popupText = popupText;
  }

  if( self.numberOfSliders === null )
  self.numberOfSliders = self.slidersDom.length;

  /* */

  self._formStage = 2;
  self._updateDom();

  /* slider */

  self.slidersDom
  .on( _.eventName( 'mousedown' ), function( e )
  {

    console.log( 'mousedown' );
    self._slidingBegin( e );

    return false;
  })
  ;

  /* sliding by clicking on range, only for single sliders */

  if( self.usingRangeClickSliding )
  if( self.numberOfSliders === 1 )
  {
    self.backDom
    .on( _.eventName( 'click' ), function( e )
    {
      self._handleBackDomClick( e );

      return false;
    })
  }


  self.rootDom
  .on( _.eventName( 'mouseup' ), function( e )
  {
    self._slidingEnd( e );
  })
  .on( _.eventName( 'mouseleave' ), function( e )
  {
    self._slidingEnd();
  })
  .on( _.eventName( 'mousemove' ), function( e )
  {
    self._sliding( e );
  })
  ;

  /* drag */

  if( self.usingFrontDrag )
  {

    _.domHabbitDrag
    ({
      targetDom : self.frontDom,
      allowedDirections : [ self.vertical ? 0 : 1,self.vertical ? 1 : 0 ],
      onEvent : _.routineJoin( self,self._handleDrag )
    });

  }

  /* keyboard */

  $( self.contentDom ).focusin( function()
  {
    self.contentDom.addClass( 'active' );
    // console.log( 'focusin' );
  });

  $( self.contentDom ).focusout( function()
  {
    self.contentDom.removeClass( 'active' );
    // console.log( 'focusout' );
  });

  $( self.contentDom ).on( 'keydown',function( e )
  {
    // console.log( 'keydown',e.keyCode );
    if( e.keyCode === 39 || e.keyCode === 40 )
    self.increase();
    else if( e.keyCode === 37 || e.keyCode === 38 )
    self.decrease();
  });

  if( self.usingKeyboardEnter )
  _.domHabbitKeyEnter
  ({
    /* usingDigitsOnly : 1, */
    dom : self.contentDom,
    onEvent : function( e )
    {
      var value = Number( e.value );
      if( !isFinite( value ) )
      return;
      self.valueSet( 0,value );
    },
  });

  /* mouse enter */

  self.contentDom
  .on( _.eventName( 'mouseleave' ), function( e )
  {

    self.closeOpen( 0 );
    self.fidelityOpen( 0 );

  })
  .on( _.eventName( 'mouseenter' ), function( e )
  {

    self.closeOpen( 1 );
    self.fidelityOpen( 1 );

  })
  ;

  /* increase */

  _.domHabbitMouseClick
  ({
    dom : self.increaseDom,
    givingRepeat : 1,
    onEvent : function handleHold( e )
    {

      if( e.kindOfMouseEvent !== 'repeat' )
      return;

      self.increase();

    },
  });

  self.increaseDom
  .on( _.eventName( 'click' ), function( e )
  {

    self.increase();

  });

  /* decrease */

  _.domHabbitMouseClick
  ({
    dom : self.decreaseDom,
    givingRepeat : 1,
    onEvent : function handleHold( e )
    {

      if( e.kindOfMouseEvent !== 'repeat' )
      return;

      self.decrease();

    },
  });

  self.decreaseDom
  .on( _.eventName( 'click' ), function( e )
  {

    self.decrease();

  });

  /* cancel */

  self.cancelDom
  .on( _.eventName( 'click' ), function( e )
  {

    if( self.cancel() )
    self.touchEvent();

  });

  /* close */

  self.closeDom
  .on( _.eventName( 'click' ), function( e )
  {

    self.openSet( 0 );

  });

  /* */

  self._domEventsArray = eventsBindWatcher.close();

}

//

function _changeEvent( sliderIndex )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  self._adjustNormals( sliderIndex );

  self._updateDom( sliderIndex );

  if( self.usingCancel )
  {
    var values = self.values;
    var defaultValues = self.defaultValues;
    var identicalWith = _.avector.identicalAre( values,defaultValues );
    self.cancelOpen( !identicalWith );
    _.assert( values.length === defaultValues.length );
  }

  self.eventGive
  ({
    kind : 'changed',
    slider : self,
    sliderIndex : sliderIndex,
  });

  return Parent.prototype._changeEvent.call( self,sliderIndex );
}

//

function _touchEvent( sliderIndex )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( self.usingNameAssiciation && self.name )
  {
    if( sliderIndex !== undefined )
    for( var n in self.instancesMap[ self.name ] )
    {
      var instance = self.instancesMap[ self.name ][ n ];
      if( instance === self )
      continue;
      instance._normalChangingSet( sliderIndex,self._normals[ sliderIndex ] );
    }
    else for( var n in self.instancesMap[ self.name ] )
    {
      var instance = self.instancesMap[ self.name ][ n ];
      if( instance === self )
      continue;
      instance._normalsChangingSet( self._normals );
    }
  }

  return Parent.prototype._touchEvent.call( self,sliderIndex );
}

// --
//
// --

function _slidingBegin( e )
{
  var self = this;
  var t = $( e.currentTarget );

  t.addClass( 'active' );

  self.contentDom.focus();

  var pos = _.eventClientPosition
  ({
    event : e,
    relative : self.backDom,
  });

  self._mouseDown = 1;
  self._mouseOrigin = pos;
  self._activeSlider = t;
  self._activeSliderIndex = self.slidersDom.index( t );
  self._backSize = _.domSizeGet( self.backDom );

  self._activeSliderOffset = _.eventClientPosition
  ({
    event : e,
    relative : t,
  });

  var size = _.domSizeFastGet( t ).slice();
  _.avector.subVectors( self._activeSliderOffset,_.avector.mulScalar( size,0.5 ) );

  _.assert( self._activeSliderIndex >= 0 );

  pos = _.avector.subVectors( pos.slice(),self._activeSliderOffset );

  self.normalByPositionSet( self._activeSliderIndex,pos );

}

//

function _slidingEnd( e )
{
  var self = this;

  if( !self._mouseDown )
  return;

  if( e )
  self._sliding( e );

  self._mouseDown = 0;
  self._activeSlider.removeClass( 'active' )
  self._activeSlider = null;

}

//

function _sliding( e )
{
  var self = this;

  if( !self._mouseDown )
  return;

  var t = $( e.currentTarget );

  var pos = _.eventClientPosition
  ({
    event : e,
    relative : self.backDom,
  });

  _.avector.subVectors( pos,self._activeSliderOffset );

  self.normalByPositionSet( self._activeSliderIndex,pos );

}

//

function _handleDrag( e )
{
  var self = this;

  if( e.kind === 'dragBegin' )
  {
    self._dragBeginValues = _.arraySlice( self.valuesGet() );
    self.activateAllSliders( 1 );
  }
  else if( e.kind === 'dragEnd' )
  {
    self.activateAllSliders( 0 );
  }

  if( e.kind !== 'drag' )
  return;

  // debugger;

  var changed = false;
  var delta = e.handler.delta;
  delta = self.normalDeltaByPositionDeltaGet( delta );
  delta = self._valueForNormalDelta( delta );

  // console.log( 'delta',delta );

  for( var i = 0 ; i < self.numberOfSliders ; i++ )
  {
    var min = self.valueRange[ 0 ] + self._dragBeginValues[ i ]-self._dragBeginValues[ 0 ];
    var max = self.valueRange[ 1 ] + self._dragBeginValues[ i ]-self._dragBeginValues[ self._dragBeginValues.length-1 ];
    var value = _.numberClamp( self._dragBeginValues[ i ]+delta,min,max );
    // console.log( '_normalSet',i,value,delta,min,max,self.nickName );
    changed = self._valueSet( i,value ) || changed;
  }

  if( changed )
  {
    self.changeEvent();
    self.touchEvent();
  }

  // _.domLeftTopSet( self.frontDom,e.handler.targetNewPosition );

}

//

function _handleBackDomClick( e )
{
  var self = this;

  _.assert( self.numberOfSliders === 1 );

  var singleSlider = self.slidersDom.get( 0 );

  /* ignore clicks on slider's button */
  if( e.target === singleSlider )
  return;

  var pos = _.eventClientPosition
  ({
    event : e,
    relative : self.backDom,
  });

  var val = self.normalByPositionSet( 0, pos );
}

// --
//
// --

function valueRangeSet( range )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( range ) );
  _.assert( range.length === 2 );

  self[ symbolForValueRange ] = range ? range.slice() : null;

}

//

function defaultValuesSet( values )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( values ) || values === null );

  self[ symbolForDefaultValues ] = values ? values.slice() : null;

}

//

function _evalDefaultNormals()
{
  var self = this;
  var defaultValues = self[ symbolForDefaultValues ];
  var defaultNormals = self._defaultNormals;

  if( !defaultValues )
  return;

  if( !defaultNormals )
  defaultNormals = self._defaultNormals = _.dup( 0,defaultValues.length );

  _.assert( _.longIs( defaultValues ) );
  _.assert( defaultNormals.length === defaultValues.length );
  _.assert( defaultNormals.length === self.numberOfSliders );

  for( var v = 0 ; v < defaultValues.length ; v++ )
  defaultNormals[ v ] = self.normalForValue( defaultValues[ v ] );

}

//

function normalForValue( value )
{
  var self = this;

  _.assert( _.numberIs( value ) );

  value = self.onDecrease( self.onIncrease( value ) );

  var normal = ( value - self.valueRange[ 0 ] ) / ( self.valueRange[ 1 ] - self.valueRange[ 0 ] );

  return normal;
}

//

function _valueForNormalDelta( normal )
{
  var self = this;

  var value = normal*( self.valueRange[ 1 ] - self.valueRange[ 0 ] );

  return value;
}

//

function valueForNormal( normal )
{
  var self = this;

  var value = self._valueForNormalDelta( normal ) + self.valueRange[ 0 ];
  value = self.onDecrease( self.onIncrease( value ) );

  return value;
}

//

function _adjustNormals( sliderIndex )
{
  var self = this;

  function adjust( sliderIndex )
  {

    if( sliderIndex > 0 )
    {
      if( self._normalGet( sliderIndex ) < self._normalGet( sliderIndex-1 ) )
      {
        // console.log( 'adjusting',sliderIndex );
        self._normalSet( sliderIndex,self._normalGet( sliderIndex-1 ) );
      }
    }

    if( sliderIndex < self.numberOfSliders-1 )
    {
      if( self._normalGet( sliderIndex ) > self._normalGet( sliderIndex+1 ) )
      {
        // console.log( 'adjusting',sliderIndex );
        self._normalSet( sliderIndex,self._normalGet( sliderIndex+1 ) );
      }
    }

  }

  if( sliderIndex !== undefined )
  adjust( sliderIndex );
  else for( var sliderIndex = 0 ; sliderIndex < self.numberOfSliders ; sliderIndex++ )
  adjust( sliderIndex );

}

//

function normalDeltaByPositionDeltaGet( positionDelta )
{
  var self = this;

  _.assert( positionDelta.length === 2 );

  var result = positionDelta[ self.vertical ? 1 : 0 ] / self._backSize[ self.vertical ? 1 : 0 ];

  return result;
}

//

function positionByNormalGet( normal )
{
  var self = this;
  var result = [ 0,0 ];

  result[ self.vertical ? 1 : 0 ] = normal * self._backSize[ self.vertical ? 1 : 0 ];

  return result;
}

//

function normalByPositionGet( position )
{
  var self = this;

  _.assert( position.length === 2 );

  var result = position[ self.vertical ? 1 : 0 ] / self._backSize[ self.vertical ? 1 : 0 ];

  return result;
}

//

function normalByPositionSet( sliderIndex,position )
{
  var self = this;

  _.assert( arguments.length === 2 );

  var result = self.normalByPositionGet( position );

  return self.normalSet( sliderIndex,result );
}

//

function _normalGet( sliderIndex )
{
  var self = this;

  _.assert( arguments.length === 1 );

  return self._normals[ sliderIndex ];
}

//

function _normalSet( sliderIndex,src )
{
  var self = this;

  if( src < 0 )
  src = 0;
  else if( src > 1 )
  src = 1;

  /* */

  src = self.normalForValue( self.valueForNormal( src ) );

  /* */

  _.assert( arguments.length === 2 );
  _.assert( 0 <= src && src <= 1 );

  var changed = self._normalGet( sliderIndex ) !== src;

  self[ symbolForValues ][ sliderIndex ] = null;
  self._normals[ sliderIndex ] = src;

  if( !self.slidersDom || _.strIs( self.slidersDom ) )
  return false;

  // self._updateFront();
  // self._updateSlider( sliderIndex );
  // self._updateHint();

  return changed;
}

//

function _normalChangingSet( sliderIndex,src )
{
  var self = this;
  var changed = self._normalSet( sliderIndex,src );

  if( changed )
  self.changeEvent( sliderIndex );

  return changed;
}

//

function _normalTouchingSet( sliderIndex,src )
{
  var self = this;
  var changed = self._normalChangingSet( sliderIndex,src );

  if( changed )
  self.touchEvent( sliderIndex );

  return changed;
}

//

function normalSet( sliderIndex,src )
{
  var self = this;
  return self._normalTouchingSet( sliderIndex,src );
}

//

function _normalsGet()
{
  var self = this;
  return self._normals;
}

//

function _normalsSet( src )
{
  var self = this;
  var changed = false;

  _.assert( self._normals.length === src.length );

  for( var s = 0 ; s < src.length ; s++ )
  {
    changed = changed || self._normals[ s ] !== src[ s ];
    self._normals[ s ] = src[ s ];
    self[ symbolForValues ][ s ] = null;
  }

  //self._updateDom();

  return changed;
}

//

function _normalsChangingSet( src )
{
  var self = this;
  var changed = self._normalsSet( src );

  if( changed )
  self.changeEvent();

  //self._updateDom();

  return changed;
}

//

function _normalsTouchingSet( src )
{
  var self = this;
  var changed = self._normalsChangingSet( src );

  if( changed )
  self.touchEvent();

  //self._updateDom();

  return changed;
}

//

function normalsSet( src )
{
  var self = this;
  _.assert( arguments.length === 1 );
  return self._normalsTouchingSet( src );
}

//

function valueGet( sliderIndex )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( sliderIndex === undefined )
  sliderIndex = 0;

  if( self[ symbolForValues ][ sliderIndex ] !== null )
  return self[ symbolForValues ][ sliderIndex ];

  var normal = self._normalGet( sliderIndex );
  var value = self.valueForNormal( normal );

  self[ symbolForValues ][ sliderIndex ] = value;

  return value;
}

//

function _valueSet( sliderIndex,value )
{
  var self = this;
  var valueWas = self.valueGet( sliderIndex );

  _.assert( arguments.length === 2 );

  if( sliderIndex === undefined )
  sliderIndex = 0;

  if( valueWas === value )
  return false;

  var normal = self.normalForValue( value  );
  self._normalSet( sliderIndex,normal );

  return true;
}

//

function _valueChangingSet( sliderIndex,value )
{
  var self = this;

  _.assert( arguments.length === 2 );

  var changed = self._valueSet( sliderIndex,value );

  if( changed )
  self.changeEvent( sliderIndex );

  return changed;
}

//

function _valueTouchingSet( sliderIndex,value )
{
  var self = this;

  _.assert( arguments.length === 2 );

  var changed = self._valueChangingSet( sliderIndex,value );

  debugger; xxx
  if( changed )
  self.touching( sliderIndex );

  return changed;
}

//

function valueSet( sliderIndex,value )
{
  var self = this;
  _.assert( arguments.length === 2 );
  return self._valueTouchingSet( sliderIndex,value );
}

//

function valuesGet()
{
  var self = this;
  var values = self[ symbolForValues ];

  if( !values )
  return;

  // console.log( 'valuesGet',values );

  _.assert( arguments.length === 0 );
  _.assert( values.length === self.defaultValues.length );

  for( var v = 0 ; v < values.length ; v++ )
  if( values[ v ] === null )
  self.valueGet( v );

  return values;
}

//

function _valuesSet( values )
{
  var self = this;
  var valuesWas = self.valuesGet();

  // if( !self._inited )
  // debugger;
  // if( !self._inited )
  // return false;

  _.assert( arguments.length === 1 );
  _.assert( _.longIs( values ) || values === null );

  if( values )
  {
    _.assert( self.defaultValues !== null && self.defaultValues !== undefined );
    _.assert( values.length === self.defaultValues.length );
    if( _.arrayIdentical( values,valuesWas ) )
    return false;
  }

  // self[ symbolForValues ] = [];

  if( values )
  for( var v = 0 ; v < values.length ; v++ )
  self._valueSet( v,values[ v ] );

  //self[ symbolForValues ] = values ? _.arraySlice( values ) : values;

  return true;
}

//

function _valuesChangingSet( values )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var changed = self._valuesSet( values );

  if( changed )
  self.changeEvent();

  return changed;
}

//

function _valuesTouchingSet( values )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var changed = self._valuesChangingSet( values );

  if( changed )
  self.touchEvent();

  return changed;
}

//

function valuesSet( values )
{
  var self = this;
  _.assert( arguments.length === 1 );
  return self._valuesTouchingSet( values );
}

// --
//
// --

function _updateDom( sliderIndex )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self.numberOfSliders >= 1 );

  // if( self._formStage < 2 )
  // debugger;
  if( self._formStage < 2 )
  return;

  self._updateFront();
  self._updateHint();

  if( sliderIndex !== undefined )
  self._updateSlider( sliderIndex );
  else for( var s = 0 ; s < self.numberOfSliders ; s++ )
  {
    self._updateSlider( s );
  }

}

//

function _updateSlider( sliderIndex )
{
  var self = this;
  var slider = self.slidersDom[ sliderIndex ];
  var normal = self._normals[ sliderIndex ];
  var pos;

  _.assert( !!slider );
  _.assert( 0 <= normal && normal <= 1 );

  pos = [ 0,0 ];
  pos[ self.vertical ? 1 : 0 ] = normal * 100 + '%';

  _.domLeftTopSet( slider,pos );

}

//

function _updateFront( range )
{
  var self = this;

  if( range === undefined )
  {
    if( self.numberOfSliders === 1 )
    range = [ 0,self._normals[ 0 ] ]
    else
    range = [ self._normals[ 0 ],self._normals[ 1 ] ]
  }

  // console.log( 'range',range );

  _.assert( _.arrayIs( range ) );
  _.assert( range.length === 2 );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self.numberOfSliders >= 1 );

  var allowResize = self.usingFrontResize || self._formStage !== 9;

  if( allowResize )
  {
    if( self.vertical )
    self.frontDom.css
    ({
      top : range[ 0 ] * 100 + '%',
      height : ( range[ 1 ] - range[ 0 ] ) * 100 + '%',
    });
    else
    self.frontDom.css
    ({
      left : range[ 0 ] * 100 + '%',
      width : ( range[ 1 ] - range[ 0 ] ) * 100 + '%',
    });
  }

  if( self.frontDomCssClass )
  self.frontDom.addClass( self.frontDomCssClass )

}

//

function _updateHint()
{
  var self = this;

  _.assert( arguments.length === 0 );

  if( !_.strIs( self.popupText ) )
  return;

  var values = self.valuesGet();

  var s = _.toStr( values,{ comma : self.hintJoinDelimeter , wrap : 0 , precision : self.numberPrecission } );
  s = self.popupText + s;

  self.hintSet( s );
}

//

function hintSet( src )
{
  var self = this;

  self[ hintSymbol ] = src;

  _.assert( arguments.length === 1 );

  if( !_.strIs( self.popupText ) )
  return;

  var popup = $( '.ui.popup.visible .content' );

  popup.text( src );
  if( self.targetDom.attr( 'data-content' ) )
  self.targetDom.attr( 'data-content',src );

}

//

function activateAllSliders( src )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( src === undefined )
  src = 1;

  _.domClasses( self.slidersDom,'active',src );
  _.domClasses( self.frontDom,'active',src );

}

// --
// buttons
// --

function __step( onChangeValue )
{
  var self = this;

  if( self.numberOfSliders === 1 )
  {

    var value = self.valueGet( 0 );
    return self._valueSet( 0,onChangeValue.call( self,value ) );

  }
  else
  {
    var valuesOld = self.valuesGet();
    var vlauesNew = _.arraySlice( valuesOld );

    for( var v = 0 ; v < vlauesNew.length ; v++ )
    {

      var min = self.valueRange[ 0 ]+valuesOld[ v ]-valuesOld[ 0 ];
      var max = self.valueRange[ 1 ]+valuesOld[ v ]-valuesOld[ valuesOld.length-1 ];

      // console.log( '__step',v,vlauesNew[ v ],min,max );

      vlauesNew[ v ] = onChangeValue.call( self,vlauesNew[ v ] );
      vlauesNew[ v ] = _.numberClamp( vlauesNew[ v ],min,max );

      // console.log( '__step',vlauesNew[ v ] );

    }

    // console.log( ' ' );

    return self._valuesSet( vlauesNew );
  }

}

//

function _increase()
{
  var self = this;
  return self.__step( self.onIncrease );
}

//

function _increaseTouching()
{
  var self = this;

  var changed = self._increase();
  if( changed )
  {
    self.changeEvent();
    self.touchEvent();
  }

  return self;
}

//

function increase()
{
  var self = this;
  return self._increaseTouching();
}

//

function _decrease()
{
  var self = this;
  return self.__step( self.onDecrease );
}

//

function _decreaseTouching()
{
  var self = this;

  var changed = self._decrease();
  if( changed )
  {
    self.changeEvent();
    self.touchEvent();
  }

  return self;
}

//

function decrease()
{
  var self = this;
  return self._decreaseTouching();
}

//

function _cancelAct()
{
  var self = this;

  _.assert( arguments.length === 0 );

  return self.valuesSet( self.defaultValues.slice() );
}

//

function fidelityOpen( src )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !self.usingHideButtons )
  return self;

  if( src === undefined )
  src = !self._fidelityOpened;

  self._fidelityOpen( src );

  return self;
}

//

function _fidelityOpen( src )
{
  var self = this;

  _.assert( arguments.length === 1 );

  self._fidelityOpened = !!src;

  if( src )
  {
    self.increaseDom.removeClass( self.hiddenCssClass );
    self.decreaseDom.removeClass( self.hiddenCssClass );
  }
  else
  {
    self.increaseDom.addClass( self.hiddenCssClass );
    self.decreaseDom.addClass( self.hiddenCssClass );
  }

}

//

function cancelOpen( src )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !self.usingHideButtons )
  return self;

  if( src === undefined )
  src = !self._cancelOpened;

  self._cancelOpen( src );

  return self;
}

//

function _cancelOpen( src )
{
  var self = this;

  _.assert( arguments.length === 1 );

  self._cancelOpened = !!src;

  if( !_.jqueryIs( self.cancelDom ) )
  return;

  if( src )
  {
    self.cancelDom.removeClass( self.hiddenCssClass );
  }
  else
  {
    self.cancelDom.addClass( self.hiddenCssClass );
  }

}

//

function closeOpen( src )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !self.usingHideButtons )
  return self;

  if( src === undefined )
  src = !self._closeOpened;

  self._closeOpen( src );

  return self;
}

//

function _closeOpen( src )
{
  var self = this;

  _.assert( arguments.length === 1 );

  self._closeOpened = !!src;

  if( !_.jqueryIs( self.closeDom ) )
  return;

  if( src )
  {
    self.closeDom.removeClass( self.hiddenCssClass );
  }
  else
  {
    self.closeDom.addClass( self.hiddenCssClass );
  }

}

//

function _openSetAnimation( value )
{
  var self = this;

  if( !value )
  {
    self.fidelityOpen( value );
    self.cancelOpen( value );
    self.closeOpen( value );
  }

  return Parent.prototype._openSetAnimation.call( self,value );
}

//

function _openSetAct( value )
{
  var self = this;

  if( value )
  {
    self._backSize = _.domSizeGet( self.backDom );
  }
  else
  {
    self.fidelityOpen( value );
    self.cancelOpen( value );
    self.closeOpen( value );
  }

  return Parent.prototype._openSetAct.call( self,value );
}

//

function onIncrease( value )
{
  var self = this;
  return Math.round( ( value + self.step ) / self.step ) * self.step;
}

//

function onDecrease( value )
{
  var self = this;
  return Math.round( ( value - self.step ) / self.step ) * self.step;
}

// --
// symbols
// --

var symbolForValues = Symbol.for( 'values' );
var symbolForDefaultValues = Symbol.for( 'defaultValues' );
var symbolForValueRange = Symbol.for( 'valueRange' );
var hintSymbol = Symbol.for( 'hint' );

// --
// relationship
// --

var Composes =
{

  usingHideButtons : 1,
  usingFidelityButtons : 1,
  usingCancel : 1,
  usingAccept : 0,
  usingClose : 0,
  usingNameAssiciation : 1,
  usingKeyboardEnter : 1,
  usingFrontDrag : 1,
  usingFrontResize : 1,
  usingRangeClickSliding : 1,

  vertical : 0,
  numberOfSliders : 1,

  numberPrecission : 2,
  valueRange : _.define.own([ 0,100 ]),
  defaultValues : null,
  values : null,
  step : 1,

  hintJoinDelimeter : ' .. ',
  animation : 'scale',
  popupText : null,

  onIncrease : onIncrease,
  onDecrease : onDecrease,

  settings : null,

  frontDomCssClass : null,
  backDomCssClass : null

}

var Aggregates =
{
}

var Associates =
{

  targetDom : '.range-slider',
  contentDom : '{{targetDom}} > .content',

  backDom : '{{contentDom}} > .back',
  frontDom : '{{backDom}} > .front',
  slidersDom : '{{backDom}} > .slider',

  increaseDom : '{{contentDom}} [data-value=increase]',
  decreaseDom : '{{contentDom}} [data-value=decrease]',
  cancelDom : '{{contentDom}} [data-value=cancel]',
  closeDom : '{{contentDom}} [data-value=close]',

}

var Restricts =
{

  _mouseDown : 0,
  _mouseOrigin : null,
  _activeSlider : null,
  _activeSliderIndex : 0,
  _activeSliderOffset : null,

  _dragBeginValues : null,
  _backSize : null,

  _fidelityOpened : 0,
  _cancelOpened : 0,
  _closeOpened : 0,

  _defaultNormals : null,
  _normals : null,

  _domEventsArray : null,

}

var Statics =
{
}

var Events =
{
  'changed' : 'changed',
}

var Accessors =
{
  values : 'values',
  valueRange : 'valueRange',
  defaultValues : 'defaultValues',
  hint : 'hint',
}

// --
// proto
// --

var Proto =
{

  finit : finit,
  init : init,

  _initState : _initState,
  _formAct : _formAct,
  _changeEvent : _changeEvent,
  _touchEvent : _touchEvent,


  // handler

  _slidingBegin : _slidingBegin,
  _slidingEnd : _slidingEnd,
  _sliding : _sliding,
  _handleDrag : _handleDrag,
  _handleBackDomClick : _handleBackDomClick,


  //

  valueRangeSet : valueRangeSet,
  defaultValuesSet : defaultValuesSet,
  _evalDefaultNormals : _evalDefaultNormals,

  normalForValue : normalForValue,
  _valueForNormalDelta : _valueForNormalDelta,
  valueForNormal : valueForNormal,

  _adjustNormals : _adjustNormals,
  normalDeltaByPositionDeltaGet : normalDeltaByPositionDeltaGet,
  positionByNormalGet : positionByNormalGet,
  normalByPositionGet : normalByPositionGet,
  normalByPositionSet : normalByPositionSet,

  _normalGet : _normalGet,
  _normalSet : _normalSet,
  _normalChangingSet : _normalChangingSet,
  _normalTouchingSet : _normalTouchingSet,
  normalSet : normalSet,

  _normalsGet : _normalsGet,
  _normalsSet : _normalsSet,
  _normalsChangingSet : _normalsChangingSet,
  _normalsTouchingSet : _normalsTouchingSet,
  normalsSet : normalsSet,

  valueGet : valueGet,
  _valueSet : _valueSet,
  _valueChangingSet : _valueChangingSet,
  _valueTouchingSet : _valueTouchingSet,
  valueSet : valueSet,

  valuesGet : valuesGet,
  _valuesSet : _valuesSet,
  _valuesChangingSet : _valuesChangingSet,
  _valuesTouchingSet : _valuesTouchingSet,
  valuesSet : valuesSet,


  // update dom

  _updateDom : _updateDom,
  _updateSlider : _updateSlider,
  _updateFront : _updateFront,
  _updateHint : _updateHint,
  hintSet : hintSet,
  activateAllSliders : activateAllSliders,


  // buttons

  __step : __step,

  _increase : _increase,
  _increaseTouching : _increaseTouching,
  increase : increase,

  _decrease : _decrease,
  _decreaseTouching : _decreaseTouching,
  decrease : decrease,

  _cancelAct : _cancelAct,

  fidelityOpen : fidelityOpen,
  _fidelityOpen : _fidelityOpen,

  cancelOpen : cancelOpen,
  _cancelOpen : _cancelOpen,

  closeOpen : closeOpen,
  _closeOpen : _closeOpen,

  _openSetAnimation : _openSetAnimation,
  _openSetAct : _openSetAct,


  //

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,

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

_.accessor( Self.prototype,Accessors );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})( );
