( function _BookJsDoc_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './Book.s' );
  require( '../../../../dwtools/amid/astring/StringSaverHtml.s' );

  var _ = _global_.wTools;

  _.include( 'wPathFundamentals' );

}

var $ = jQuery;
var _ = _global_.wTools;
var Parent = _.ghi.Book;
var Self = function wHiBookJsDoc( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'BookJsDoc';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );
}

//

function _formAct()
{
  var self = this;

  self.targetDom = _.domTotalPanelMake().targetDom;

  Parent.prototype._formAct.call( self );

  _.assert( _.objectIs( self.source ),'expects object { source }' );

  var filesElements = [];
  var tree =
  [
    {
      text : 'Files',
      elements : filesElements,
    }
  ]

  for( var s in self.source )
  {
    var fileSource = self.source[ s ];
    filesElements.push( self._formForFile( fileSource,s ) );
  }

  self.tree.treeApply({ elements : tree });

  self.tree.branchOpen( 'Files' );

}

//

function _formForFile( fileSource,filePath )
{
  var self = this;

  // _.assert( _.objectIs( self.source ),'expects object { source }' );

  /* */

  // var routines =
  // {
  //   'first branch' : [ 'apple','pinnacle','orange' ],
  //   'second branch' : [ 'table','chair' ],
  //   'third branch' : { 'third branch a' : [ 'yellow','green' ], 'third branch b' : [ 'red','blue','orange' ] },
  //   'empty branch' : [],
  // }

  function nodeMake( e )
  {
    var result = Object.create( null );
    result.text = e.name || e.longname;
    result.hint = e.longname;
    result.data = e;
    result.kind = 'terminal';
    return result;
  }

  var knownKinds =
  {
    'function' : 'Routines',
    'typedef' : 'Structures',
    'class' : 'Classes',
    'member' : 'Members',
    'event' : 'Events',
  };

  var specialKinds =
  {
    'other' : 'Others',
    'raw' : 'Raw',
  };


  var text = _.path.split( filePath );
  text.splice( 0,text.length-2 );
  text = text.join( ' / ' );

  var fileElement =
  {
    text : text,
    elements : [],
  }

  var families = Object.create( null );

  for( var kind in knownKinds )
  {
    families[ kind ] = _.entityFilter( fileSource, function( e,k )
    {
      if( e.undocumented )
      return;
      if( e.kind === kind )
      return nodeMake( e );
    });
    if( !_.mapKeys( families[ kind ] ).length )
    delete families[ kind ];
  }

  families.other = _.entityFilter( fileSource, function( e,k )
  {
    if( !knownKinds[ e.kind ] )
    return nodeMake( e );
  });

  families.raw = _.entityFilter( fileSource, function( e,k )
  {
    if( e.undocumented )
    return nodeMake( e );
  });

  for( var kind in families )
  {
    var node = Object.create( null );
    node.text = knownKinds[ kind ] ? knownKinds[ kind ] : specialKinds[ kind ];
    node.elements = families[ kind ];
    fileElement.elements.push( node );
  }

  // var elements =
  // [
  //   {
  //     text : 'Files',
  //     elements : [ file ],
  //   }
  // ]
  //
  // self.tree.treeApply({ elements : elements });

  // self.targetDom = _.domTotalPanelMake().targetDom;
  // self.form();

  // var book = new wHiBook({ targetDom : _.domTotalPanelMake().targetDom, onPageGet : handlePageGet });
  // book.form();
  // book.tree.treeApply({ elements : elements });

  return fileElement;
}

//

function pageParams( node,key,title )
{
  var self = this;

  if( !node.data[ key ] )
  return self;

  var s = wStringSaverHtml();

  for( var e = 0 ; e < node.data[ key ].length ; e++ )
  {
    var element = node.data[ key ][ e ];
    var line = '';
    if( element.name )
    {
      line += element.name;
      line += ' : ';
    }
    if( element.type && element.type.names )
    line += element.type.names.join( ' | ' );
    s.b( line );
    s.out += element.description;
    s.out += '\n';
  }

  self.saver.h2( title );
  self.saver.paragraph( s.out );

  return self;
}

//

function pageClass( node )
{
  var self = this;
  var saver = self.saver;

  // <anonymous>~Medials
  // <anonymous>~Proto.buttonsFor

  var facets = Object.create( null );

  // debugger;

  _.entityMap( self.source, function( e,k )
  {

    for( var f in _.ClassSubfieldsGroups )
    {
      if( e.memberof )
      if( _.strHas( e.memberof,'~' + f ) )
      {
        if( !facets[ f ] )
        facets[ f ] = Object.create( null );
        facets[ f ][ e.name ] = e;
      }
    }

    if( e.memberof )
    if( _.strHas( e.memberof,'~Proto' ) )
    {
      if( !facets.Members )
      facets.Members = Object.create( null );
      facets.Members[ e.name ] = e;
    }

    return null;
  });

  // debugger;

  for( var f in facets )
  {
    saver.h2( f );
    for( var name in facets[ f ] )
    saver.p( name );
  }

}

//

function onPageGet( node )
{
  var self = this;
  var saver = self.saver;
  saver.clean();

  if( !node.data )
  return '-';

  /* */

  saver.h2( node.data.kind + ' ' + ( node.data.longname || node.data.name ) );
  saver.paragraph( node.data.summary || '','p' );
  if( node.data.description )
  if( !_.strHas( node.data.description,node.data.summary ) || node.data.description.length > node.data.summary+8 )
  {
    saver.h2( 'Description' );
    saver.paragraph( node.data.description );
  }

  /* */

  self.pageParams( node,'properties','Fields' );
  self.pageParams( node,'params','Arguments' );
  self.pageParams( node,'returns','Returns' );
  self.pageParams( node,'exceptions','Exceptions' );

  if( node.data.examples )
  {
    saver.h2( 'Examples' );
    for( var e = 0 ; e < node.data.examples.length ; e++ )
    saver.paragraph( node.data.examples[ e ],'code' );
  }

  if( node.data.kind === 'class' )
  self.pageClass();

  // var result = _.entitySelect( node.data.report,'*.text' );
  //
  // if( node.data.check )
  // result = result.join( '\n' ) + '\n' + node.data.text;
  // else if( node.data.routine )
  // result = node.data.text + '\n' + _.entitySelect( node.elements,'*.data.text' ).join( '\n' ) + '\n' + result.join( '\n' );

  return saver.out;
}

// --
// relationship
// --

var Composes =
{
  onPageGet : onPageGet,
}

var Aggregates =
{
}

var Associates =
{
  saver : _.define.ownInstanceOf( wStringSaverHtml ),
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
  _formAct : _formAct,
  _formForFile : _formForFile,

  pageParams : pageParams,
  pageClass : pageClass,
  onPageGet : onPageGet,

  /* */

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

})( );
