( function _BookShader_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './BookEditor.s' );

}

var $ = jQuery;
var _ = _global_.wTools;
var Terminal = _.ghi.HiTree.Node.Terminal;
var Parent = _.ghi.Book;
var Self = function wHiBookShader( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'BookShader';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );
}

//

function _execDefaults()
{
  var self = this;

  _.assert( arguments.length === 0 );

  Parent.prototype._execDefaults.call( self );

  debugger;

  return self;
}

//

function _formAct()
{
  var self = this;
  var shaderProgram = self.shaderProgram;

  var map = { shader : {}, ties : {} };
  for( var g in shaderProgram.shader.parameters.live )
  {
    var ties = shaderProgram.shader.parameters.live[ g ]
    map.ties[ g ] = []
    for( var t in ties )
    {
      var node = Object.create( null );
      node.kind = 'terminal';
      node.text = t;
      node.data = ties[ t ];
      node.page = function onPage( node )
      {
        return node.data.toStr({ levels : 2 });
      }
      map.ties[ g ].push( node );
    }
  }

  map.shader.fragment = Terminal.constructor();
  map.shader.fragment.text = 'fragment';
  map.shader.fragment.data = shaderProgram.shader.fragment.text;
  map.shader.vertex = Terminal.constructor();
  map.shader.vertex.text = 'vertex';
  map.shader.vertex.data = shaderProgram.shader.vertex.text;

  debugger;
  self.tree.treeApply({ elements : map });

  Parent.prototype._formAct.call( self );

}

//

function onPageGet( node )
{
  return node.page;
}

// --
// relationship
// --

var Composes =
{

  targetIdentity : '.wbook.wbook-director',
  onPageGet : onPageGet,

}

var Aggregates =
{

}

var Associates =
{
  shaderProgram : null,
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
