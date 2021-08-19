( function _Base_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );

  _.include( 'wProto' );
  _.include( 'wCopyable' );

  module.exports = _;
}

})();
