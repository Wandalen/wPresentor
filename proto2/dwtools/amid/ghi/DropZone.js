( function(){

'use strict';

var $ = typeof jQuery !== 'undefined' ? jQuery : null;
var _ = _global_.wTools;
var Parent = null;
var Self = function wHiDropzone( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'HiDropzone';

// var Self = function wHiDropzone( options )
// {
//   if( !( this instanceof Self ) )
//   return new( _.routineJoin( Self, Self, arguments ) );
//   return Self.prototype.init.apply( this,arguments );
// }

//

function init( options )
{
  var self = this;

  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Composes );
  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Associates );

  if( options )
  self.copy( options );

  //

  if( self.bodyDom === null )
  self.bodyDom = $( document.body );
  self.bodyDom.addClass( self.classEmpty );

  if( self.surfaceDom === undefined ) self.surfaceDom = $( '<div>' );
  self.surfaceDom = $( self.surfaceDom );
  if( !self.surfaceDom.length )
  throw _.err( 'DropZone :','expects surfaceDom' );

  //

  self.surfaceDom.bind( 'dragover', _.routineJoin( self,self.handleDragOver ) );
  self.surfaceDom.bind( 'drop', _.routineJoin( self,self.handleFileSelect ) );

  if( self.usingDoubleClick )
  self.surfaceDom
  .bind( _.eventName( 'dblclick' ), _.routineJoin( self,self.handleLoadDialog ) );

  self.surfaceDom
  .bind( _.eventName( 'click' ), _.routineJoin( self,self.handleLoadDialog ) );

  return self.surfaceDom;
}

//

function state( state )
{

  var self = this;

  if( state === 'empty' )
  {

    self.bodyDom
    .removeClass( self.classLoaded )
    .removeClass( self.classLoading )
    .addClass( self.classEmpty );

  }
  else if( state === 'loading' )
  {

    self.bodyDom
    .removeClass( self.classLoaded )
    .removeClass( self.classEmpty )
    .addClass( self.classLoading );

  }
  else if( state === 'loaded' )
  {

    self.bodyDom
    .removeClass( self.classEmpty )
    .removeClass( self.classLoading )
    .addClass( self.classLoaded );

  }
  else
  {

    throw _.err( 'DropZone.state :','unknown state',state );

  }

}

//

function handleFiles( files )
{
  var self = this;

  if( self.urlToUpload )
  _.uploadFiles
  ({
    files : files,
    url : self.urlToUpload,
  });

  for ( var f = 0, file; file = files[f]; f++ )
  {

  }

}

//

function handleFileSelect( event )
{
  var self = this;
  event = event.originalEvent;

  event.stopPropagation();
  event.preventDefault();

  var files = event.dataTransfer.files;

  self.handleFiles( files );

}

//

function handleDragOver( event )
{
  var self = this;
  event = event.originalEvent;

  event.stopPropagation();
  event.preventDefault();
  event.dataTransfer.dropEffect = 'copy';

}

//

function handleLoadDialog( event )
{
  var self = this;

  var picked = _.loadDialog( self.textSelectFiles );

  picked.got( function( err,picked )
  {

    self.handleFiles( picked.files );

  });

}

// --
// relations
// --

var Composes =
{

  usingDoubleClick : 1,

  urlToUpload : '',

  classEmpty : 'state-drop-zone-empty',
  classLoaded :'state-drop-zone-loaded',
  classLoading : 'state-drop-zone-loading',

  textSelectFiles : 'Selects files to upload',

}

var Associates =
{
  bodyDom : null,
  surfaceDom : null,
}

var Restricts =
{
}

// --
// proto
// --

var Proto =
{

  init : init,
  state : state,

  handleFiles : handleFiles,
  handleFileSelect : handleFileSelect,
  handleDragOver : handleDragOver,
  handleLoadDialog : handleLoadDialog,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.EventHandler.mixin( Self );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
