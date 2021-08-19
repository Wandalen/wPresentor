( function _Dom_s_( ) {

'use strict';

const _ = _global_.wTools;

_.dom = _.dom || Object.create( null );

let vectorize = _.routineDefaults( null, _.vectorize, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAll = _.routineDefaults( null, _.vectorizeAll, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeAny = _.routineDefaults( null, _.vectorizeAny, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );
let vectorizeNone = _.routineDefaults( null, _.vectorizeNone, { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 } );

// --
// inter
// --

function is( src )
{
  if( !_global_.Node )
  return false;
  if( !src )
  return false;
  return src instanceof _global_.Node;
}

//
/* xxx : qqq : move to DomTools */
/* xxx : qqq : add DomTools as dependeny */

function findSingle( srcDom, selector )
{
  let self = this;

  if( arguments.length === 1 )
  {
    selector = srcDom;
    srcDom = document;
  }

  let result = selector;

  if( _.strIs( selector ) )
  {
    result = srcDom.querySelectorAll( selector );
  }
  if( !_.dom.is( result ) )
  {
    _.assert( result.length === 1, 'DOM node is not found, or found several such' );
    result = result[ 0 ];
  }

  _.assert( _.dom.is( result ) );
  return result;
}

//
/* xxx : qqq : move to DomTools */
/* xxx : qqq : add DomTools as dependeny */

function findAll( srcDom, selector )
{
  let self = this;

  if( arguments.length === 1 )
  {
    selector = srcDom;
    srcDom = document;
  }

  let result = selector;

  if( _.strIs( selector ) )
  {
    result = srcDom.querySelectorAll( selector );
  }

  if( _.dom.is( result ) )
  {
    return [ result ];
  }
  else
  {
    return [ ... result ];
  }
}

//

function ownIdentity( dom, identity )
{

  // dom = $( dom );
  dom = _.dom.findAll( dom );

  _.assert( dom.length === 1 );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( identity === undefined || _.strIs( identity ) );

  if( identity === undefined )
  {

    let cssClasses = dom[ 0 ].className;
    let result = '';

    if( cssClasses.length )
    {
      cssClasses = cssClasses.split( /\s+/ );
      result += '.' + cssClasses.join( '.' );
    }

    // if( dom[ 0 ].id )
    // debugger;

    if( dom[ 0 ].id )
    result = '#' + dom[ 0 ].id + result;

    _.assert( !!result );

    return result;
  }

  identity = _.strIsolateEndOrAll( identity, ' ' )[ 2 ];

  _.assert( identity.indexOf( ' ' ) === -1 );

  identity = _.strSplitFast
  ({
    src : identity,
    delimeter : [ '.', '#', '[', ']' ],
    preservingDelimeters : 1,
    preservingEmpty : 0,
  });

  debugger;

  for( let i = 1 ; i < identity.length ; i+=2 )
  {
    if( identity[ i-1 ] === '.' )
    {
      dom.forEach( ( dom ) => dom.classList.add( identity[ i ] ) );
      // dom.addClass( identity[ i ] );
    }
    else if( identity[ i-1 ] === '#' )
    {
      dom.forEach( ( dom ) => dom.setAttribute( 'id', identity[ i ] ) );
      // dom.attr( 'id', identity[ i ] );
    }
    else if( identity[ i-1 ] === '[' && identity[ i+1 ] === ']' )
    {
      let attrStrSplitted = _.strSplitNonPreserving({ src : identity[ i ], delimeter : '=' });
      _.assert( attrStrSplitted.length === 2, 'ownIdentity expects attribute identity of format: attr=val, got:', identity[ i ] );
      // dom.attr( attrStrSplitted[ 0 ], attrStrSplitted[ 1 ] );
      dom.forEach( ( dom ) => dom.setAttribute( attrStrSplitted[ 0 ], attrStrSplitted[ 1 ] ) );
      i += 1;
    }
    else
    {
      throw _.err( 'unknown prefix', identity[ i-1 ] );
    }
  }

}

// --
// declare
// --

let Restricts =
{
}

let Extension =
{

  is,
  findSingle,
  findAll,
  ownIdentity,

  _ : Restricts,

}

Object.assign( _.dom, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
