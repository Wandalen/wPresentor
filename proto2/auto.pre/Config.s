(function _Config_s_() {

  //

  var _global = undefined;
  if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
  if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
  if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
  if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
  if( _global._global_ )
  _global = _global._global_;

  // console.log( '_Config_s_' ); debugger;
  // console.log( new Error().stack );

  //

  var c =
  //>-->//
    return _.stringify( _.fields( this.build.config.public ) );
  //<--<//
  ;

  c.version =
  //>-->//
    return '"' + ( this.build.config.private.package ? this.build.config.private.package.version : '0.0.0' ) + '"';
  //<--<//
  ;

  c.buildDate =
  //>-->//
    return '"' + ( this.build.config.buildDate || new Date().toUTCString() ) + '"';
  //<--<//
  ;

  if( typeof Config !== 'undefined' )
  Object.assign( Config,c );

  _global.Config = c;
  return c;
})();
