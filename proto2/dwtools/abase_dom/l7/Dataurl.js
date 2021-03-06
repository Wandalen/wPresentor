(function _Dataurl_js_() {

'use strict';

var _ = _global_.wTools;

// --
// dataurl
// --

function dataurlIs( url )
{
  if( !_.strIs( url ) ) return false;
  return url.substring( 0,5 ) == 'data:';
}

//

function dataurlType( url )
{
  throw _.err( 'not tested' );
  result = url.substring( 5,url.indexOf( ';' ) );
  return result;
}

//

function dataurlFrom( picture )
{
  var result;

  debugger;

  if( _.strIs( picture ) )
  {
    _.assert( 0, 'not tested' );
    _.assert( _.dataurlIs( picture ) );
    result = picture;
  }
  else
  {
    var canvas = _.canvasFrom( picture );
    result = canvas.toDataURL( 'image/png' );
  }

  // else if( picture instanceof HTMLCanvasElement )
  // {
  //   result = picture.toDataURL( 'image/png' );
  // }
  // else if( picture instanceof HTMLImageElement )
  // {
  //   var canvas = _.canvasFromImage( picture );
  //   result = canvas.toDataURL( 'image/png' );
  // }
  // else _.assert( 0,'unknown format of picture',picture );

  return result;
}

//

function dataurlFrom2( src,o )
{

  var o = o || Object.create( null );
  if( o.type === undefined ) o.type = 'image/png';
  _.assert( o.onReady,'dataurlFrom2 :','expects o.onReady' );

  if( _.dataurlIs( src ) )
  {
    if( _.dataurlType( src ) === o.type )
    {
      _.timeOut( 1,o,o.onReady,[ src ] );
      return src;
    }
    src = src;
  }
  else if( _.strIs( src ) )
  {
    src = _.dataurlFromSvgString( src );
    if( o.type.indexOf( 'svg' ) !== -1 )
    {
      _.timeOut( 1,o,o.onReady,[ src ] );
      return src;
    }
  }

  function onReady( canvas )
  {
    var result = canvas.toDataURL( o.type );
    o.onReady( result );
  }

  _.canvasFrom( src,{ type : o.type, onReady : onReady } );

}

//

function dataurlFromSvgDom( svg )
{
  debugger;
  var data = _.dataurlFromSvgString( svgStringWithDom( svg ) );
  return data;
}

//

function dataurlFromSvgString( svgString )
{
  debugger;
  return _.dataurlFromString( svgString,'image/svg+xml' );
}

// --
// url data
// --

function dataurlParse( dataurl,type )
{

  var result = {};
  var parsed = /^data:image\/([^;]+);base64,(.*)$/.exec( dataurl );

  if( !parsed ) return;

  result.type = parsed[ 1 ];
  result.data = parsed[ 2 ];
  return result;
}

//

function dataurlFromString( str,type )
{

  var base64 = _.base64FromUtf8( str );
  return dataurlFromBase64( base64,type );
}

//

function dataurlFromBase64( base64,type )
{

  if( !type ) type = 'image/png';

  _.assert( type.indexOf( '/' ) !== -1,'dataurlFromBase64 :','wrong type, must has "/"' );

  return 'data:' + type + ';base64,' + base64;
}

//

function dataurlFromDom( dom,mimetype,show )
{
  var mimetype = mimetype || "image/png";
  var result = dom.toDataURL( mimetype );
  if( show ) dataurlShow( result );
  return result;
}

//

function dataurlFromRenderer( renderer,mimetype,show )
{
  return dataurlFromDom( renderer.domElement,mimetype,show );
}

//

var dataurlShowed = 0;
function dataurlShow( data,dimension )
{

  var dimension = dimension || [512,512];
  window.open( data,'name-' + Math.random(),
    'toolbar=no,location=no,message=no,menubar=no,scrollbars=yes,resizable=yes,'
    + 'width=' + dimension[0] * 1.05  + ',height=' + dimension[1] * 1.05 );
  dataurlShowed++;

}

//

function dataurlTransform( onReady,dataUrl,dimension,scale,format )
{
  var format = format || 'image/png';
  var isDataUrl = _.dataurlIs( dataUrl );

  if( isDataUrl && !dimension && !scale && !format )
  return dataUrl;

  debugger;

  _.canvasFrom( undefined,dataUrl,dimension,scale,function( canvas )
  {

    var result = canvas.toDataURL( format );
    if( onReady ) onReady( result );
    _.canvasDelete( canvas );

  });

}

//

function dataurlToBuffer( urlData )
{

  var urlData = _.dataurlParse( urlData );

  if( !urlData ) return;

  urlData.buffer = _.base64ToBuffer( urlData.data );

  return urlData;
}

//

function dataurlToBlob( urlData )
{

  var data = _.dataurlToBuffer( urlData );
  var blob = _.blobFromBuffer( data.buffer,data.type );

  return blob;
}

// -- blob

function blobUrl( blob )
{

  return URL.createObjectURL( blob );

}

//

function blobFromBuffer( buffer,mime )
{

  var mime = mime || 'application/octet-stream';
  var blob = new Blob( [ buffer ], { type : mime } );

  return blob;
}

// --
// prototype
// --

var Proto =
{


  // dataurl

  dataurlIs : dataurlIs,
  dataurlType : dataurlType,

  dataurlFrom2 : dataurlFrom2,
  dataurlFromSvgDom : dataurlFromSvgDom,
  dataurlFromSvgString : dataurlFromSvgString,

  dataurlParse : dataurlParse,

  dataurlFromString : dataurlFromString,
  dataurlFromBase64 : dataurlFromBase64,
  dataurlFromDom : dataurlFromDom,
  dataurlFromRenderer : dataurlFromRenderer,

  dataurlShow : dataurlShow,

  dataurlTransform : dataurlTransform,

  dataurlToBuffer : dataurlToBuffer,
  dataurlToBlob : dataurlToBlob,


  // blob

  blobUrl : blobUrl,
  blobFromBuffer : blobFromBuffer,


};

_.mapExtend( _,Proto );

})();
