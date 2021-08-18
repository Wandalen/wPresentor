(function _Sound_js_() {

'use strict';

var _ = _global_.wTools;
var $ = jQuery;

// --
// routines
// --

function play( o )
{
  if( _.strIs( o ) )
  o = { url : o }

  _.assert( _.strIs( o.url ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.SoundsByUrl[ o.url ] )
  _.SoundsByUrl[ o.url ] = new buzz.sound( o.url );

  var sound = _.SoundsByUrl[ o.url ];
  var result = sound.play();

}

play.defaults =
{
  url : null,
}

//

function playTry( o )
{
  if( _.strIs( o ) )
  o = { url : o }

  _.assert( arguments.length === 1, 'expects single argument' );

  try
  {
    return play( o );
  }
  catch( err )
  {
    console.warn( 'cant paly',o.url );
  }

}

playTry.defaults =
{
}

playTry.defaults.__proto__ = play.defaults;

// --
// prototype
// --

var Proto =
{

  play : play,
  playTry : playTry,

  SoundsByUrl : {},

}

if( _.sound )
{
  _.mapExtend( _.sound,Proto );
}
else
{
  _.sound = Proto;
  _.sound.__proto__ = _;
}

var _ = _global_.wTools.sound;

})();
