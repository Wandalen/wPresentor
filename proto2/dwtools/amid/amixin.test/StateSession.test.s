( function _StateSession_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = wTools;
  _.include( 'wTesting' );

  require( '../amixin/StateSession.s' );

}

var _ = wTools;

//

function trivial( test )
{

  function SomeClass( o )
  {
    return _.instanceConstructor( SomeClass, this, arguments );
  }

  function init( o )
  {
    let sample = this;
    _.instanceInit( sample );
  }

  function storageLoaded( storage, op )
  {
    let self = this;
    let result = _.StateStorage.prototype.storageLoaded.call( self, storage, op );

    self.random = storage.random;

    return result;
  }

  function storageToSave( op )
  {
    let self = this;

    let storage = { random : self.random };

    return storage;
  }

  let Associates =
  {
    opened : 0,
    storageFileName : '.test.config.json',
    fileProvider : _.define.ownInstanceOf( _.FileProvider.Extract ),
  }

  let Extend =
  {
    init : init,
    storageLoaded : storageLoaded,
    storageToSave : storageToSave,
    Associates : Associates,
  }

  _.classDeclare
  ({
    cls : SomeClass,
    extend : Extend,
  });

  _.StateStorage.mixin( SomeClass );
  _.StateSession.mixin( SomeClass );

  /* */

  let sample = new SomeClass();
  sample.storageLoad();
  if( !sample.random )
  sample.random = Math.random();
  sample.storageSave();
  console.log( 'sample.random', sample.storageFilePathToLoadGet(), sample.random );

  /* */

  test.identical( 1,1 );

}

//

var Self =
{

  name : 'Tools/mid/StateSession',
  silencing : 1,

  tests :
  {
    trivial : trivial,
  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
