 ( function _ConsoleService_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../../BackWithConfig.ss' );

  var _ = _global_.wTools;

  _.include( 'wLogger' );
  _.include( 'wPathFundamentals'/*ttt*/ );
  _.include( 'wCopyable' );

  // require( 'include/dwtools/abase/mixin/Copyable.s' );
  // require( 'include/dwtools/abase/layer3/Path.s' );
  // require( 'include/dwtools/amid/files/UseTop.s' );

  require( 'include/dwtools/amid/bclass/Vocabulary.s' );

  if( !_global_.GhiVocabulary )
  require( '../ghi/Vocabulary.s' );

}

/** example :

  function handleLine( err,code )
  {
    eval( code );
  }

  var con = new _.Consequence().persist( handleLine );
  var consoleService = new wConsoleService();
  consoleService.listen( con );

*/


//

var _ = _global_.wTools;
var Parent = null;
var Self = function wConsoleService( o )
{
  if( !( this instanceof Self ) )
  if( _.typeOf( o ) === Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'ConsoleService';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( !self.vocabulary )
  self.vocabulary = new wGhiVocabulary({

    context : self,
    headEnabled : false,
    usingClausing : true,
    usingClausingAtActionGet : false,
    usingGui : false,

  });

  /*self.vocabulary.phrasesAdd( [] );*/
  self.vocabulary.registerActions( self.DefaultPhrases,{ context : self } );

}

// --
// listen
// --

function listen( consequence )
{
  var self = this;

  return self._listen
  ({
    consequence : consequence,
    once : 0,
  });

}

//

function listenLine( consequence )
{
  var self = this;

  return self._listen
  ({
    consequence : consequence,
    once : 1,
  });

}

//

function _listen( o )
{
  var self = this;
  var consequence = o.consequence || new _.Consequence();

  if( !self._terimnal )
  self._launch();

  if( o.once )
  self.eclipse( 'line',consequence );
  else
  self.on( 'line',consequence );

  return consequence;
}

_listen.defaults =
{
  consequence : null,
  once : 1,
}

//

function _launch()
{
  var self = this;
  var initing = !self._terimnal;

  _.assert( arguments.length === 0 );

  if( initing )
  {

    if( !_global_.wTerminal )
    require( './TerminalShell.ss' );
    self._terimnal = new wTerminal
    ({
      name : self.name,
      //isTerminal : false,
    });

/*
    var Readline = require( 'repl' );
    self._terimnal = Readline.start
    ({
      input : process.stdin,
      output : process.stdout,
      ignoreUndefined : true,
      eval : function( cmd, context, filename, callback ){ if( 0 ) callback( null, undefined ); },
    });
*/

/*
    var Readline = require( 'readline' );
    self._terimnal = Readline.createInterface
    ({
      input : process.stdin,
      output : process.stdout,
    });
*/

  }

  var q = '';

  if( self.usingSayHello )
  {
    if( self.firstLine )
    q = self.hello;
    self.firstLine = false;
    self.usingSayHello = false;
  }

  if( !initing )
  self._terimnal.resume();

  _.assert( _.consequenceIs( self._con ) );

  if( initing )
  self._terimnal.on( 'line', _.routineJoin( self,self._handleLine ) );

  self._terimnal.question( q );

}

// _listen.defaults =
// {
//   consequence : null,
//   once : 1,
// }

//

function _handleLine( str )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  var result = null;

  if( self.singleLine )
  self._terimnal.pause();

  /* adjust line */

  if( _.mapIs( str ) )
  str = str.line;
  str = _.strStrip( str );
  var line = str;

  /* sync */

  // logger.log( '_handleLine( before self._con )', line, self._con.resourcesGet().length );

  self._con.doThen( function()
  {

    // logger.log( '_handleLine( after self._con )', _.color.strFormatBackground( line,'red' ), self._con.resourcesGet().length );

    /* try to exit */

    if( /\bexit\b/.test( str ) && str.indexOf( '.exit' ) === -1 )
    {
      self._terimnal.pause();
      console.log( '!' );
      commandExit.call( self );
      return;
    }

    /* execute builtin command */

  /*
    if( str )
    {
      result = self.consoleCommandExecute( str )
      if( result )
      str = '';
    }
  */

    if( str )
    {
      result = self.vocabularyPhraseExecute( str );
      if( result )
      str = '';
    }

    if( str[ 0 ] === '.' )
    {
      logger.error( 'command not known :',str );
      return;
    }

    /* execute in the original environment */

    result = wConsequence.from( result );

    // logger.log( '_handleLine( result ) :' , result.resourcesGet().length );

    result.doThen( function( err,data )
    {

      try
      {

        if( err )
        throw _.errLogOnce( err );

        // if( line.indexOf( 'convert' ) !== -1 )
        // debugger;

        var c = self._handleLineAct( str );

        // logger.log( '_handleLine( done )',line );
        // logger.log( c );

        if( c === false )
        return;
        else
        return data;

      }
      catch( err )
      {
        _.errLogOnce( err );
      }


    });

    // logger.log( '_handleLine( result ) :' , result.resourcesGet().length );
    // logger.log( '_handleLine( self._con ) :' , self._con.resourcesGet().length );

    return result;
  });

  return self._con.split();
}

//

function _handleLineAct( line )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  var embraced = '';
  if( line )
  embraced = self.codeEmbrace( line );

  var e =
  {
    kind : 'line',
    raw : line,
    embraced : embraced,
  }

  return self.eventGive( e );
}

//

function _listenStdin()
{
  var self = this;

  if( !self.stdin )
  self.stdin = process.openStdin();

  function handleData( buffer )
  {

    var str = buffer.toString().trim();

    console.log( 'you entered : [ ' + str + ' ]' );

  }

  if( self.stdin._handleListen ) self.stdin.removeListener( 'data',self.stdin._handleListen );
  self.stdin._handleListen = handleData;
  self.stdin.addListener( 'data',self.stdin._handleListen );

  console.log();
  console.log( 'Hello. Please enter command. Use help() to get help.' );

}

//

function write( src )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );

  if( self._terimnal )
  self._terimnal.write( src );
  else
  throw _.err( 'write : dont know how to write' );

  return src;
}

//

function writePhrase( src )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );

  if( !src )
  return;

  src = _.strSplitNonPreserving/**1**/({ src : src, delimeter : [ ';' ] });

  self.write( src.join( '\n' ) + '\n' );

  return src;
}

// --
// code
// --

function codeEmbrace( code )
{
  var self = this;

  if( !/;/.test( code ) )
  code = 'console.log( _.toStr( ' + code + ' ) );';

  code =
  [
    'try',
    '{',
    '',
    code,
    '',
    '}',
    'catch( err )',
    '{',
    '  _global_.wTools.errLog( err );',
    //'  console.error( err.toString() + '\n' + err.stack );',
    '}',
  ].join( '\n' );

  return code;
}

//

function codeToInject()
{
  var self = this;
  var context = self.context;
  var result = '\n';

  throw _.err( 'not implemented' );

  for( var c in context )
  {
    console.log( ConsoleService.prototype.instance[ self.id ] );
    result += 'var ' + c + ' = ' + 'ConsoleService.prototype.instance' + '[ ' + self.id + ' ];\n';
  }

  result += '\n';
  return result;
}

// --
// etc
// --

function registerBrowser()
{

  _.timeReady( function()
  {

    var $ = jQuery;
    var html = '<textarea class="console-service"><textarea>';
    var dom = $( html );

    dom.css
    ({

      'display' : 'block',
      'position' : 'fixed',
      'width' : '100%',
      'background-color' : 'rgba( 255,255,255,0.5 )',
      'z-index' : 1000,
      'height' : '40%',
      'bottom' : '0',

    });

    dom.appendTo( document.body );

  });

}

//

function vocabularyPhraseExecute( code )
{
  var self = this;
  var result = false;

  _.assert( _.strIs( code ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  var vocabulary = self.vocabulary;
  if( !vocabulary )
  return false;

  if( code[ 0 ] !== '.' )
  return false;

  // debugger;
  code = code.substr( 1 );
  var parts = _.strIsolateBeginOrNone({ src : code, delimeter : [ ' ','(',')' ] });
  // debugger;

  // console.log( '\nparts',parts );

  if( parts[ 0 ] )
  code = parts[ 0 ];

  var splitted = _.strSplitNonPreserving/**1**/({ src : code, delimeter : [ '.' ] });

  var args = '';

  if( parts[ 2 ] !== code )
  {
    args = parts[ 2 ] || args;
    args = _.strStrip({ src : args, stripper : [ ' ','(',')' ] });
  }

  var argv = [];
  argv[ 3 ] = args;
  var argsParsed = _.appArgs({ argv : argv });

  for( var k in argsParsed.map )
  {
    var elem = argsParsed.map[ k ];
    if( _.strIs( elem ) )
    {
      if( _.strStrip( elem ) === 'null' )
      {
        argsParsed.map[ k ] = null;
      }
      else
      {
        var str =  _.strStrip({ src : elem, stripper : [ '[',']' ]});
        var strSplitted = _.strSplitNonPreserving/**1**/({ src : str, delimeter : ',' });
        if( strSplitted.length > 1 )
        argsParsed.map[ k ] = strSplitted.map( ( e ) => _.numberFrom( e ) );
      }
    }
  }

  //logger.log( 'args :',args );

  /**/

  var a = vocabulary.actionGet( splitted );

  if( a.action )
  {

    /* logger.log( 'action found :\n' + _.toStr( a ) ); */

    if( a.action.onActivate )
    {
      var loggerLevel = logger.level;

      result = vocabulary.handleActivate( a.action,args, argsParsed.map );

      if( !_.consequenceIs( result ) )
      {
        result = true;
        logger.level = loggerLevel;
      }
      else result.tap( function( err,data )
      {
        logger.level = loggerLevel;
      });


      /* logger.log( 'vocabularyPhraseExecute.result :',result. ); */

    }
    else
    {
      logger.log( 'action without onActivate :\n' + _.toStr( a.action ) );
      result = true;
    }

    return result;
  }

  /* give a hint */

  if( !a.action )
  {

    self.helpFor( splitted.join( ' ' ) );

/*
    a = vocabulary.actionsForSubject( splitted );

    if( !a.length )
    return false;

    logger.log( 'Phrases :' );
    logger.log( '' );
    self.log( _.entitySelect( a,'*.descriptor.phrase' ) );
*/

  }

  return true;
}

//

function log( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );

  logger.log( _.toStr( src,{ wrap : 0, levels : 2, multiline : 1 } ) );

}

//

function helpFor( src )
{
  var self = this;

  logger.log( 'Do you mean?' );
  logger.log( '' );

  if( self.vocabulary )
  {
    var help = self.vocabulary.vocabulary.helpForSubject( src );
    self.log( help );
  }

  logger.log( '' );

}

// --
// default commands
// --

function commandExit()
{
  var self = this;
  var context = self.context;

  logger.log( 'exiting..' );

  /* no forcefully exit should be here or timeout */

  // _.timeOut( 5000, function()
  // {
  //
  //   // process.exit();
  //
  // });

}

commandExit.action =
{
  phrase : 'exit',
  hint : 'Terminates application.',
  onActivate : commandExit,
}

//

function commandHelp()
{
  var self = this;
  var context = self.context;

/*
  logger.logUp( 'Commands :\n' );

  for( var c in self.commands )
  {
    var command = self.commands[ c ];
    var h = command.help ? command.help : '';
    var str = '.' + c + ' - ' + h;
    logger.log( str )
  }

  logger.logDown( '' );
*/

  /**/

  var vocabulary = self.vocabulary;
  if( vocabulary )
  {
/*
    logger.logUp( 'Phrases :' );
    logger.log( '' );

    //logger.log( 'vocabulary :\n' + _.toStr( vocabulary.vocabulary,{ levels : 2 } ) );

    var phrases1 = vocabulary.phrasesGet({ wordDelimeter : '.' });
    var phrases2 = vocabulary.phrasesGet();
    var hint = _.entitySelect( vocabulary.vocabulary.descriptorArray,'*.hint' );

    for( var i = 0 ; i < hint.length ; i++ )
    if( !hint[ i ] )
    hint[ i ] = phrases2[ i ];

    var phrases = _.strJoin( '.',phrases1,' - ',hint );
    self.log( phrases );
    logger.logDown( '' );

    logger.log( 'clauseForSubjectMap :' );
    logger.log( '' );
    self.log( Object.keys( vocabulary.vocabulary.clauseForSubjectMap ) );
    logger.log( '' );
*/

    self.helpFor( '' );

/*
    debugger;
    var a = vocabulary.actionsForSubject( '' );
    logger.log( 'Phrases :' );
    logger.log( '' );
    self.log( _.entitySelect( a,'*.descriptor.phrase' ) );
    logger.log( '' );
*/

  }

}

commandHelp.action =
{
  phrase : 'help',
  hint : 'Prints help.',
  onActivate : commandHelp,
}

//

function commandClear()
{
  var self = this;

  self._terimnal.clear();

}

commandClear.action =
{
  phrase : 'clear',
  hint : 'Clear screen.',
  onActivate : commandClear,
}

//

function commandLs()
{
  var self = this;

  var files = _.filesList( _.path.current() );

  logger.log( _.toStr( files,{ wrap : 0, multiline : 1 } ) );

}

commandLs.action =
{
  phrase : 'ls',
  hint : 'List files in the current working directory.',
  onActivate : commandLs,
}

//

function commandWords()
{
  var self = this;
  var vocabulary = self.vocabulary;

  logger.log( 'Words :' );
  logger.log( '' );
  if( vocabulary )
  self.log( Object.keys( vocabulary.vocabulary.wordMap ) );
  logger.log( '' );

}

commandWords.action =
{
  phrase : 'words',
  hint : 'List known words.',
  onActivate : commandWords,
}

//

function commandPath()
{
  var self = this;
  var result = '';

  /*console.log( 'commandPath.arguments :',_.toStr( arguments ) );*/

  try
  {
    result = _.path.current( arguments[ 1 ] )
  }
  catch( err )
  {
    logger.log( err.originalMessage || e.message );
  }

  logger.log( result );

}

commandPath.action =
{
  phrase : 'path',
  hint : 'Print / change current working directory',
  onActivate : commandPath,
}

// --
// var
// --

var DefaultCommands =
{

  'exit' : commandExit,
  'x' : commandExit,

  'help' : commandHelp,
  '?' : commandHelp,

  'clear' : commandClear,
  'cls' : commandClear,

  'ls' : commandLs,
  'dir' : commandLs,

  'words' : commandWords,

  'path' : commandPath,
  'cwd' : commandPath,
  'cd' : commandPath,

}

var DefaultPhrases =
[

  commandExit,
  commandHelp,
  commandClear,
  commandLs,
  commandWords,
  commandPath,

]

// --
// relations
// --

var Composes =
{

  name : 'ConsoleService',

  hello : 'Hello. Please enter a command. Use .help to get help.\n',

  verbosity : 1,
  usingSayHello : 1,

  singleLine : 0,
  firstLine : 1,

}

var Aggregates =
{
}

var Associates =
{

  /*commands : DefaultCommands,*/

  _terimnal : null,
  vocabulary : null,

}

var Restricts =
{
  _con : _.Consequence().give(),
}

var Events =
{
  line : 'line',
}

// --
// declare
// --

var Proto =
{

  init : init,


  // listen

  listen : listen,
  listenLine : listenLine,

  _listen : _listen,
  _listenStdin : _listenStdin,

  _launch : _launch,

  _handleLine : _handleLine,
  _handleLineAct : _handleLineAct,

  write : write,
  writePhrase : writePhrase,


  // code

  codeEmbrace : codeEmbrace,
  codeToInject : codeToInject,


  // etc

  registerBrowser : registerBrowser,
  /*consoleCommandExecute : consoleCommandExecute,*/
  vocabularyPhraseExecute : vocabularyPhraseExecute,
  log : log,
  helpFor : helpFor,


  // relations

  DefaultCommands : DefaultCommands,
  DefaultPhrases : DefaultPhrases,

  
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Events : Events,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

_.Copyable.mixin( Self );
_.Instancing.mixin( Self );
_.EventHandler.mixin( Self );

if( typeof module === 'undefined' && 0 )
{
  Self.prototype.registerBrowser();
  _global_.consoleService = Self({});
}

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
