( function _Base_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );

  _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wConsequence' );
  _.include( 'stxt' );

  debugger;
  require( '../ext/mousetrap.min.js' );

  module.exports = _;
}

})();
