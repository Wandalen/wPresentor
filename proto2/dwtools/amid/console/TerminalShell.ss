( function _TerminalShell_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( 'babel-regenerator-runtime' );
  }
  catch( err )
  {
  }

  try
  {
    require( 'babel-runtime' );
  }
  catch( err )
  {
  }

  require( '../../BackWithConfig.ss' );
  require( './TerminalAbstract.s' );

  //

  var _ = _global_.wTools;
  var File = null;
  var Buffer = require( 'buffer' ).Buffer;
  var ReadLine = require( 'readline' );

  try
  {
    var InternalReadline = require( 'internal/readline' );
  }
  catch( err )
  {
    var InternalReadline = ReadLine;
  }

  /* var _unicodeLength = require( 'string-width' ); */
  // /*var getStringWidth = InternalReadline.getStringWidth;*/

  var _isFullWidthCodePoint = require( 'is-fullwidth-code-point' );
  var _stripAnsi = require('strip-ansi');

  //var _isFullWidthCodePoint = InternalReadline.isFullWidthCodePoint;
  //var _stripAnsi = InternalReadline.stripVTControlCharacters;

  /**/

  //var _terminalEmitKeypressEvents = ReadLine.emitKeypressEvents;
  //var terminalEmitKeys = InternalReadline.emitKeys;
  //_.assert( terminalEmitKeys );

  /* move inputCursor with absolute position */
  var terminalCursorAbsolute = ReadLine.cursorTo;

  /* move inputCursor with relative position */
  var terminalCursorRelative = ReadLine.moveCursor;

  /**/
  var terminalClearLine = ReadLine.clearLine;

  /* clear lines on terminal after current line */
  var terminalClearScreenDown = ReadLine.clearScreenDown;

}

//

var _ = _global_.wTools;
var Parent = wTerminalAbstract;
var Self = function wTerminalShell( o )
{
  if( !( this instanceof Self ) )
  if( _.typeOf( o ) === Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

  /* */

  _.assert( self.historyLimit >= 0 );

  if( self.input === null )
  self.input = process.stdin;

  if( self.output === null )
  self.output = process.stdout;

  if( o.isTerminal === undefined )
  self.isTerminal = self.input.isTTY;

/*
  console.log( 'self.input.isTTY :',self.input.isTTY );
  console.log( 'self.isTerminal :',self.isTerminal );
*/

  self.isTerminal = !!self.isTerminal;

  // console.log( 'isTerminal : ' + self.isTerminal );

  if( self.isTerminal )
  {

    _terminalEmitKeypressEvents( self.input );

    self.handleTerminalKeypress = _.routineJoin( self,handleTerminalKeypress );
    self.handleTerminalEnd = _.routineJoin( self,handleTerminalEnd );
    self.handleTerminalOutputResize = _.routineJoin( self,handleTerminalOutputResize );

    self.input.on( 'keypress', self.handleTerminalKeypress );
    self.input.on( 'end', self.handleTerminalEnd );

    this.rawMode = true;
    this.isTerminal = true;

    if( self.output )
    self.output.on( 'resize', self.handleTerminalOutputResize );

    self.once( 'close', function()
    {
      self.input.removeListener( 'keypress', self.handleTerminalKeypress );
      self.input.removeListener( 'end', self.handleTerminalEnd );
      if( self.output )
      {
        self.output.removeListener( 'resize', self.handleTerminalOutputResize );
      }
    });

  }
  else
  {

    self.handleStreamData = _.routineJoin( self,handleStreamData );
    self.handleStreamEnd = _.routineJoin( self,handleStreamEnd );

    self.input.on( 'data', self.handleStreamData );
    self.input.on( 'end', self.handleStreamEnd );
    self.once( 'close', function()
    {
      self.input.removeListener( 'data', self.handleStreamData );
      self.input.removeListener( 'end', self.handleStreamEnd );
    });

    var StringDecoder = require( 'string_decoder' ).StringDecoder;
    self._decoder = new StringDecoder( 'utf8' );

  }

  //input.resume();

  Object.preventExtensions( self );
}

//

function prompt()
{
  var self = this;

  _.assert( arguments.length === 0 );

  Parent.prototype.prompt.call( self );

  if( self.isTerminal )
  {
    // if( !preserveCursor )
    // self.inputCursor = 0;
    self._lineRefresh();
  }
  else
  {
    self._writeOutput( self.textPrompt );
  }

}

//

function question( question )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return Parent.prototype.question.call( self,question );
}

//

function close()
{
  var self = this;
  if( self.isClosed )
  return;

  Parent.prototype.close.call( self,question );

  if( self.isTerminal )
  self.rawMode = false;

  return self;
}

//

function pause()
{
  var self = this;
  if( self.isPaused )
  return;

  Parent.prototype.pause.call( self,question );

  self.input.pause();

  return self;
}

//

function resume()
{
  var self = this;
  if( !self.isPaused )
  return;

  Parent.prototype.resume.call( self,question );

  self.input.resume();

  return self;
}

//

function clear()
{
  var self = this;

  terminalCursorAbsolute( self.output, 0, 0 );
  terminalClearScreenDown( self.output );
  self._lineRefresh();

}

// --
//
// --

function _wordLeftMatch()
{
  var self = this;

  if( this.inputCursor <= 0 )
  return;

  debugger;

  var left = this.line.slice( 0, this.inputCursor );
  var match = left.match( self.regexpWordLeft );

  if( match )
  return match[ 0 ];

}

//

function _wordRightMatch()
{
  var self = this;

  if( this.inputCursor >= this.line.length )
  return;

  debugger;

  var right = this.line.slice( this.inputCursor );
  var match = right.match( self.regexpWordRight );

  if( match )
  return match[ 0 ];
}

//

function _wordLeft()
{
  var self = this;
  var match = self._wordLeftMatch();
  if( !match )
  return;

  this.lineCursorOffset( -match.length );
  return true;
}

//

function _wordRight()
{
  var self = this;
  var match = self._wordRightMatch();
  if( !match )
  return;

  this.lineCursorOffset( +match.length );
  return true;
}

//

function _deleteLeft()
{
  if( this.inputCursor <= 0 || this.line.length <= 0 )
  return;

  this.line = this.line.slice( 0, this.inputCursor - 1 ) + this.line.slice( this.inputCursor, this.line.length );
  this.inputCursor--;
  this._lineRefresh();

}

//

function _deleteRight()
{
  this.line = this.line.slice( 0, this.inputCursor ) + this.line.slice( this.inputCursor + 1, this.line.length );
  this._lineRefresh();
}

//

function _deleteWordLeft()
{
  var self = this;

  if( self.inputCursor <= 0 )
  return;

  console.log( '_deleteWordLeft' );

  var left = self.line.slice( 0, self.inputCursor );
  var match = left.match( self.regexpWordLeft );

  left = left.slice( 0, left.length - match[ 0 ].length );
  self.line = left + self.line.slice( self.inputCursor, self.line.length );
  self.inputCursor = left.length;
  self._lineRefresh();

}

//

function _deleteWordRight()
{
  var self = this;

  if( self.inputCursor >= self.line.length )
  return;

  var right = self.line.slice( self.inputCursor );
  var match = right.match( self.regexpWordRight );

  self.line = self.line.slice( 0, self.inputCursor ) + right.slice( match[ 0 ].length );
  self._lineRefresh();

}

//

function _deleteLineLeft()
{
  this.line = this.line.slice( this.inputCursor );
  this.inputCursor = 0;
  this._lineRefresh();
}

//

function _deleteLineRight()
{
  this.line = this.line.slice( 0, this.inputCursor );
  this._lineRefresh();
}

// --
// line
// --

function _lineBegin()
{
  var self = this;

  self.lineCursorOffset( +Infinity );
  self._writeOutput( '\r\n' );
  self.line = '';
  self.inputCursor = 0;
  self.posOfPrevious = [ 0,0 ];

}

//

function _lineEnd()
{
  var self = this;
  return Parent.prototype._lineEnd.call( self );
}

//

function _lineEnded( line )
{
  var self = this;
  return Parent.prototype._lineEnded.call( self,line );
}

//

function _lineEntered()
{
  var self = this;
  return Parent.prototype._lineEntered.call( self );
}

//

function _lineRefresh()
{
  var self = this;
  return Parent.prototype._lineRefresh.call( self );
}

//

function lineCursorOffset( dx )
{
  var self = this;
  var cursorWas = self.inputCursor;
  var posWas = self._posAtCursorGet();

  //

  self.inputCursor += dx;
  if( self.inputCursor < 0 ) self.inputCursor = 0;
  else if( self.inputCursor > self.line.length )
  self.inputCursor = self.line.length;
  var pos = self._posAtCursorGet();

  // check if cursors are in the same line

  if( posWas[ 1 ] === pos[ 1 ] )
  {
    var dc = self.inputCursor - cursorWas;
    var dx = 0;
    if( dc < 0 )
    {
      dx = - _lengthOf( self.line.substring( self.inputCursor, cursorWas ) );
    }
    else if( dc > 0 )
    {
      dx = + _lengthOf( self.line.substring( cursorWas,self.inputCursor ) );
    }
    terminalCursorRelative( self.output, dx, 0 );
    self.posOfPrevious[ 1 ] = pos[ 1 ];
  }
  else
  {
    self._lineRefresh();
  }

}

//

function _lineInsertString( str )
{

  _.assert( arguments.length === 1, 'expects single argument' );

  if( this.inputCursor < this.line.length )
  {

    /* insert inside of string */

    var begin = this.line.slice( 0, this.inputCursor );
    var end = this.line.slice( this.inputCursor, this.line.length );
    this.line = begin + str + end;
    this.inputCursor += str.length;
    this._lineRefresh();

  }
  else
  {

    /* append string */

    this.line += str;
    this.inputCursor += str.length;

    if( this._posAtCursorGet()[ 0 ] === 0 )
    {
      this._lineRefresh();
    }
    else
    {
      this._writeOutput( str );
    }

    this.lineCursorOffset( 0 );

  }

}

// --
//
// --

function _lengthOf( src )
{
  var result = 0;

  _.assert( _.strIs( src ) );

  src = _stripAnsi( src );

  for( var i = 0; i < src.length; i++ )
  {

    var code = src.codePointAt( i );
    if( code <= 0x1f )
    continue;
    if( code >= 0x7f && code <= 0x9f )
    continue;

    if( code >= 0x10000 )
    i++;

    result += _isFullWidthCodePoint( code ) ? 2 : 1;
  }

  return result;
}

//

function _sizeOf( src )
{
  var offset = 0;
  var width = this.width;
  var row = 0;
  var code;

  src = _stripAnsi( src );

  /* */

  for( var i = 0, li = src.length; i < li; i++ )
  {
    code = src.codePointAt( i );
    if( code >= 0x10000 )
    i++;
    if( code === 0x0a )
    {
      offset = 0;
      row += 1;
      continue;
    }
    /* is two-slot symbol */
    if( _isFullWidthCodePoint( code ) )
    {
      /* one slot is not enough for two-slot symbol */
      if( ( offset + 1 ) % width === 0 )
      offset++;
      offset += 2;
    }
    else
    {
      offset++;
    }
  }

  /* */

  var x = offset % width;
  var y = row + ( offset - x ) / width;

  //console.log( 'width :',width );
  //console.log( '_sizeOf :',[ x,y ] );

  return [ x,y ];
}

//

function _posAtCursorGet()
{
  var width = this.width;
  var line = this.textPrompt /*+ this.textQuestion*/ + this.line.substring( 0, this.inputCursor );
  var posOfLine = this._sizeOf( line );
  return posOfLine;
}

// --
// write
// --

function write( src, key )
{
  if( this.isPaused )
  throw _.err( 'ConsoleTerminal','is paused' );

  if( arguments.length !== 1 )
  throw _.err( 'not tested' );

  _.assert( _.strIs( src ) );

  /* console.log( 'write',d,key ); debugger; */

  this.isTerminal ? this._writtenTerminal( src, key ) : this._writtenStream( src );

}

//

function _writeOutput( srcString )
{
  var self = this;

  _.assert( _.strIs( srcString ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( self.output )
  self.output.write( srcString );

}

//

function _rewriteInput( srcString )
{

  var posEnd = this._sizeOf( srcString );
  var posCursor = this._posAtCursorGet();

  terminalCursorRelative( this.output, 0, -this.posOfPrevious[ 1 ] );
  terminalCursorAbsolute( this.output, 0 );
  terminalClearScreenDown( this.output );

  this._writeOutput( srcString );

  terminalCursorAbsolute( this.output, posCursor[ 0 ] );
  terminalCursorRelative( this.output, 0, posCursor[ 1 ] - posEnd[ 1 ] );

  this.posOfPrevious = posCursor;
}

//

function _writtenTerminal( srcStr, key )
{
  var key = key || {};
  var self = this;

  if( key.name == 'escape' )
  return;

  //console.log( 'key\n' + _.toStr( key ) );
  //console.log( 'key\n' + JSON.stringify( key ) );

  // if( key.meta )
  // console.log( 'key.meta' );
  //
  // if( key.ctrl )
  // console.log( 'key.ctrl' );
  //
  // if( key.shift )
  // console.log( 'key.shift' );

  if( key.ctrl && key.shift )
  {

    throw _.err( 'not tested' );

    /* Control and shift pressed */
    switch ( key.name )
    {
      case 'backspace':
        this._deleteLineLeft();
        break;

      case 'delete':
        this._deleteLineRight();
        break;
    }

  }
  else if( key.ctrl )
  {
    /* Control key pressed */

    switch ( key.name )
    {

      case 'c':

        if( this._eventHandlerDescriptorsByKind( 'SIGINT' ).length > 0 )
        {
          this.eventGive( 'SIGINT' );
        }
        else
        {
          this.close();
        }
        break;

      case 'h':
        this._deleteLeft();
        break;

      case 'd':
        if( this.inputCursor === 0 && this.line.length === 0 )
        {
          this.close();
        }
        else if( this.inputCursor < this.line.length )
        {
          this._deleteRight();
        }
        break;

      case 'u':
        this.inputCursor = 0;
        this.line = '';
        this._lineRefresh();
        break;

      case 'k':
        this._deleteLineRight();
        break;

      case 'a':
        this.lineCursorOffset( -Infinity );
        break;

      case 'e':
        this.lineCursorOffset( +Infinity );
        break;

      case 'b':
        this.lineCursorOffset( -1 );
        break;

      case 'f':
        this.lineCursorOffset( +1 );
        break;

      case 'l':
        this.clear();
        break;

      case 'n':
        this._historyNext();
        break;

      case 'p':
        this._historyPrev();
        break;

      case 'z':

        if( process.platform == 'win32' )
        break;

        if( this._eventHandlerDescriptorsByKind( 'SIGTSTP' ).length > 0 )
        {
          this.eventGive( 'SIGTSTP' );
        }
        else
        {

          process.once( 'SIGCONT', _.routineJoin( this,this.handleTerminalSigcont ) );

          this.rawMode = false;
          process.kill( process.pid, 'SIGTSTP' );

        }
        break;

      case 'w':
      case 'backspace':
        this._deleteWordLeft();
        break;

      case 'delete':
        this._deleteWordRight();
        break;

      case 'left':
        this._wordLeft();
        break;

      case 'right':
        this._wordRight();
        break;
    }

  }
  else if( key.meta )
  {

    switch ( key.name )
    {
      case 'b':
        this._wordLeft();
        break;

      case 'f':
        this._wordRight();
        break;

      case 'd':
      case 'delete':
        this._deleteWordRight();
        break;

      case 'backspace':
        this._deleteWordLeft();
        break;
    }

  }
  else // no key
  {

    if( this._endsReturn && key.name !== 'enter' )
    this._endsReturn = false;

    switch ( key.name )
    {
      case 'return':
        this._endsReturn = true;
        this._lineEntered();
        break;

      case 'enter':
        if( this._endsReturn )
        this._endsReturn = false;
        else
        this._lineEntered();
        break;

      case 'backspace':
        this._deleteLeft();
        break;

      case 'delete':
        this._deleteRight();
        break;

      case 'left':
        this.lineCursorOffset( -1 );
        break;

      case 'right':
        this.lineCursorOffset( +1 );
        break;

      case 'home':
        this.lineCursorOffset( -Infinity );
        break;

      case 'end':
        this.lineCursorOffset( +Infinity );
        break;

      case 'up':
        this._historyPrev();
        break;

      case 'down':
        this._historyNext();
        break;

      case 'tab':
        debugger;
        if( typeof this.completer === 'function' )
        {
          this._complete();
          break;
        }

      default:

        if( srcStr instanceof Buffer )
        srcStr = srcStr.toString( 'utf-8' );

        if( srcStr )
        {

          _.assert( _.strIs( srcStr ) );
          var lines = srcStr.split( /\r\n|\n|\r/ );

          for( var i = 0, len = lines.length; i < len; i++ ) ( function( i )
          {

            self._conSyn
            .doThen( function()
            {

              if( i > 0 )
              self._writeOutput( self.textPrompt );

              self._lineInsertString( lines[ i ] );

              if( i < lines.length-1 )
              {
                return self._lineEnd();
              }

            });

          })( i );

/*
          .doThen( function( i )
          {

            if( i > 0 )
            {
              this._lineEnd();
              this._writeOutput( this.textPrompt );
            }

            this._lineInsertString( lines[ i ] );

          });
*/

        }

    }
  }

}

//

function _writtenStream( b )
{
  var self = this;

  const lineEnding = /\r?\n/;

  if( b === undefined )
  return;

  var string = self._decoder.write( b );
  if( self._endsReturn )
  {
    string = string.replace( /^\r?\n/, '' );
    self._endsReturn = false;
  }

  var newPartContainsEnding = lineEnding.test( string );

/*
  debugger;
  throw _.err( 'not tested' );
*/

  if( self._strBuffer )
  {
    string = self._strBuffer + string;
    self._strBuffer = null;
  }

  if( newPartContainsEnding )
  {
    self._endsReturn = /\r?\n$/.test( string );

    var lines = string.split( lineEnding );
    string = lines.pop();
    self._strBuffer = string;
    lines.forEach( function( line )
    {
      self._lineEnded( line );
    });
  }
  else if( string )
  {
    self._strBuffer = string;
  }

}

// --
// history
// --

function _historyPrependByCurrent()
{
  var self = this;
  var line = self.line;

  //if( self._textPromptUsed )
  //line = line.substring( self._textPromptUsed.length );

  if( line.length === 0 )
  return '';

  if( self.history.length === 0 || self.history[ 0 ] !== line )
  {

    self.history.unshift( line );
    if( self.history.length > self.historyLimit )
    self.history.pop();

  }

  self.historyIndex = -1;

  self._historyCanged();

  return self.history[ 0 ];
}

//

function _historyNext()
{

  if( this.historyIndex > 0 )
  {
    this.historyIndex--;
    this.line = this.history[ this.historyIndex ];
    this.inputCursor = this.line.length;
    this._lineRefresh();
  }
  else if( this.historyIndex === 0 )
  {
    this.historyIndex = -1;
    this.inputCursor = 0;
    this.line = '';
    this._lineRefresh();
  }

}

//

function _historyPrev()
{
  if( this.historyIndex + 1 < this.history.length )
  {
    this.historyIndex++;
    this.line = this.history[ this.historyIndex ];
    this.inputCursor = this.line.length;
    this._lineRefresh();
  }
}

//

function _historyCanged()
{
  var self = this;

  self.eventGive({ kind : 'historyCange' });

  self._historySave();

}

//

function _historyEvalPath()
{
  var self = this;

  if( self._historyPath )
  return self._historyPath;

  var home = process.env[ ( process.platform == 'win32' ) ? 'USERPROFILE' : 'HOME' ] || __dirname;
  var name = _.path.name( _.path.realMainFile() ) + '.' + _.strFilenameFor( self.name );
  self._historyPath = home + '/.' + name + '.history';

  return self._historyPath;
}

//

// function _historySave()
// {
//   var self = this;
//
//   if( !self.usingHistoryFile )
//   return;
//
//   self._historyEvalPath();
//   _.assert( _.strIs( self._historyPath ) );

  function onHistorySave()
  {
    var self = this;

    File = require( 'fs' );
    File.writeFileSync( self._historyPath,JSON.stringify( self.history ) );

    return true;
  }

//   onHistorySave = self.onHistorySave ? self.onHistorySave : onHistorySave;
//
//   try
//   {
//
//     onHistorySave.call( self );
//
//   }
//   catch( err )
//   {
//     _.errLog( err );
//     self.usingHistoryFile = 0;
//   }
//
// }

//

// function _historyLoad()
// {
//   var self = this;
//
//   if( !self.usingHistoryFile )
//   return;

  function onHistoryLoad()
  {
    var self = this;

    File = require( 'fs' );

    if( !File.existsSync( self._historyPath ) )
    {
      console.warn( '_historyLoad : file does not exist :',self._historyPath );
      self.history = [];
      return false;
    }

    self.history = JSON.parse( File.readFileSync( self._historyPath,'utf8' ) );

    return true;
  }

//   if( self.onHistoryLoad )
//   onHistoryLoad = self.onHistoryLoad;
//
//   try
//   {
//     self._historyEvalPath();
//     onHistoryLoad.call( self );
//
//     if( !_.arrayIs( self.history ) )
//     throw _.err( 'wrong history data' );
//
//   }
//   catch( err )
//   {
//     _.errLog( err );
//     self.history = [];
//     self.usingHistoryFile = 0;
//   }
//
// }

// --
// complete
// --

function _complete()
{
  var self = this;

  self.pause();
  self.completer( self.line.slice( 0, self.inputCursor ), function( err, rv )
  {

    self.resume();

    if( err )
    {
      console.warn( 'tab completion error %j', err );
      return;
    }

    const completions = rv[ 0 ];
    const completeOn = rv[ 1 ];

    if( completions && completions.length )
    {
      if( completions.length === 1 )
      {
        self._lineInsertString( completions[ 0 ].slice( completeOn.length ) );
      }
      else
      {

        self._writeOutput( '\r\n' );
        var width = 2 + completions.reduce( function( a, b )
        {
          return a.length > b.length ? a : b;
        }).length;

        var maxColumns = Math.floor( self.width / width );
        if( !maxColumns || maxColumns === Infinity )
        {
          maxColumns = 1;
        }
        var group = [], c;
        for( var i = 0, compLen = completions.length; i < compLen; i++ )
        {
          c = completions[i];
          if( c === '' )
          {
            _completeHandleGroup( self, group, width, maxColumns );
            group = [];
          }
          else
          {
            group.push( c );
          }
        }

        _completeHandleGroup( self, group, width, maxColumns );

        var f = completions.filter( function( e )
        { if( e ) return e; } );

        var prefix = _completeCommonPrefix( f );
        if( prefix.length > completeOn.length )
        {
          self._lineInsertString( prefix.slice( completeOn.length ) );
        }

      }
      self._lineRefresh();
    }
  });
}

//

function _completeHandleGroup( self, group, width, maxColumns )
{
  if( group.length == 0 )
  {
    return;
  }
  var minRows = Math.ceil( group.length / maxColumns );
  for( var row = 0; row < minRows; row++ )
  {
    for( var col = 0; col < maxColumns; col++ )
    {
      var idx = row * maxColumns + col;
      if( idx >= group.length )
      {
        break;
      }
      var item = group[idx];
      self._writeOutput( item );
      if( col < maxColumns - 1 )
      {
        for( var s = 0, itemLen = item.length; s < width - itemLen; s++ )
        {
          self._writeOutput( ' ' );
        }
      }
    }
    self._writeOutput( '\r\n' );
  }
  self._writeOutput( '\r\n' );
}

//

function _completeCommonPrefix( strings )
{
  if( !strings || strings.length == 0 )
{
    return '';
  }
  var sorted = strings.slice().sort();
  var min = sorted[ 0 ];
  var max = sorted[ sorted.length - 1 ];
  for( var i = 0, len = min.length; i < len; i++ )
  {
    if( min[ i ] != max[ i ] )
    {
      return min.slice( 0, i );
    }
  }
  return min;
}

// --
// handler
// --

function handleStreamData( data )
{
  var self = this;
  self._writtenStream( data );
}

//

function handleStreamEnd()
{
  var self = this;

  if( self._strBuffer.length > 0 )
  this.eventGive
  ({
    kind : 'line',
    line : self._strBuffer,
  });

  console.log( 'not tested : handleStreamEnd' );

  self.close();
}

//

function handleTerminalEnd()
{
  var self = this;
  if( self.line.length > 0 )
  this.eventGive
  ({
    kind : 'line',
    line : self.line,
  });

  console.log( 'not tested : handleTerminalEnd' );

  self.close();
}

//

function handleTerminalKeypress( s, key )
{
  var self = this;
  self._writtenTerminal( s, key );
}

//

function handleTerminalSigcont()
{
  var self = this;

  console.log( 'handleTerminalSigcont' );

  // Don't raise events if stream has already been abandoned.
  if( !self.isPaused )
  {
    // Stream must be isPaused and resumed after SIGCONT to catch
    // SIGINT, SIGTSTP, and EOF.
    self.pause();
    self.eventGive( 'SIGCONT' );
  }

  // explicitly re-enable "raw mode" and move the inputCursor to
  // the correct position.
  // See https://github.com/joyent/node/issues/3295.

  self.rawMode = true;
  self._lineRefresh();

}

//

function handleTerminalOutputResize()
{
  var self = this;
  self._lineRefresh();
}

//

const _terminalEmitKeys = function* _terminalEmitKeys( stream )
{

  while( true )
  {
    let ch = yield;
    let s = ch;
    let escaped = false;
    const key =
    {
      sequence : null,
      name : undefined,
      ctrl : false,
      meta : false,
      shift : false
    }

    if( ch === '\x7f' )
    {
      //s += ( ch = yield );
      //console.log( 's :',JSON.stringify( s ) );
      debugger;
    }

    //console.log( 'ch :',JSON.stringify( ch ) );

    //

    if( ch === '\x1b' )
    {

      escaped = true;
      s += ( ch = yield );

      //console.log( 'ch :',JSON.stringify( ch ) );

      if( ch === '\x1b' )
      {
        s += ( ch = yield );
      }
    }

    //

    if( escaped && ( ch === 'O' || ch === '[' ) )
    {
      // ansi escape sequence
      let code = ch;
      let modifier = 0;

      if( ch === 'O' )
      {
        // ESC O letter
        // ESC O modifier letter
        s += ( ch = yield );

        if( ch >= '0' && ch <= '9' )
        {
          modifier = ( ch >> 0 ) - 1;
          s += ( ch = yield );
        }

        code += ch;
      }
      else if( ch === '[' )
      {
        // ESC [  letter
        // ESC [  modifier letter
        // ESC [  [  modifier letter
        // ESC [  [  num char
        s += ( ch = yield );

        if( ch === '[' )
        {
          // \x1b[ [ A
          //      ^--- escape codes might have a second bracket
          code += ch;
          s += ( ch = yield );
        }

        /*
         * Here and later we try to buffer just enough data to get
         * a complete ascii sequence.
         *
         * We have basically two classes of ascii characters to process :
         *
         *
         * 1. `\x1b[ 24;5~` should be parsed as { code : '[ 24~', modifier : 5 }
         *
         * This particular example is featuring Ctrl+F12 in xterm.
         *
         *  - `;5` part is optional, e.g. it could be `\x1b[ 24~`
         *  - first part can contain one or two digits
         *
         * So the generic regexp is like /^\d\d?( ;\d )?[ ~^$ ]$/
         *
         *
         * 2. `\x1b[ 1;5H` should be parsed as { code : '[ H', modifier : 5 }
         *
         * This particular example is featuring Ctrl+Home in xterm.
         *
         *  - `1;5` part is optional, e.g. it could be `\x1b[ H`
         *  - `1;` part is optional, e.g. it could be `\x1b[ 5H`
         *
         * So the generic regexp is like /^( ( \d; )?\d )?[ A-Za-z ]$/
         *
         */

        const cmdStart = s.length - 1;

        // skip one or two leading digits

        if( ch >= '0' && ch <= '9' )
        {
          s += ( ch = yield );

          if( ch >= '0' && ch <= '9' )
          {
            s += ( ch = yield );
          }
        }

        // skip modifier

        if( ch === ';' )
        {
          s += ( ch = yield );

          if( ch >= '0' && ch <= '9' )
          {
            s += ( ch = yield );
          }
        }

        /*
         * We buffered enough data, now trying to extract code
         * and modifier from it
         */

        const cmd = s.slice( cmdStart );
        let match;

        if( ( match = cmd.match( /^(\d\d?)(;(\d))?([~^$])$/ ) ) )
        {
          code += match[ 1 ] + match[ 4 ];
          modifier = ( match[ 3 ] || 1 ) - 1;
        }
        else if( ( match = cmd.match( /^((\d;)?(\d))?([A-Za-z])$/ ) ) )
        {
          code += match[ 4 ];
          modifier = ( match[ 3 ] || 1 ) - 1;
        }
        else
        {
          code += cmd;
        }
      }

      // Parse the key modifier
      key.code = code;
      key.modifier = modifier;
      key.ctrl = !!( modifier & 4 );
      key.meta = !!( modifier & 10 );
      key.shift = !!( modifier & 1 );

      // Parse the key itself
      switch( code )
      {
        /* xterm/gnome ESC O letter */
        case 'OP' : key.name = 'f1'; break;
        case 'OQ' : key.name = 'f2'; break;
        case 'OR' : key.name = 'f3'; break;
        case 'OS' : key.name = 'f4'; break;

        /* xterm/rxvt ESC [  number ~ */
        case '[11~' : key.name = 'f1'; break;
        case '[12~' : key.name = 'f2'; break;
        case '[13~' : key.name = 'f3'; break;
        case '[14~' : key.name = 'f4'; break;

        /* from Cygwin and used in libuv */
        case '[[A' : key.name = 'f1'; break;
        case '[[B' : key.name = 'f2'; break;
        case '[[C' : key.name = 'f3'; break;
        case '[[D' : key.name = 'f4'; break;
        case '[[E' : key.name = 'f5'; break;

        /* common */
        case '[15~' : key.name = 'f5'; break;
        case '[17~' : key.name = 'f6'; break;
        case '[18~' : key.name = 'f7'; break;
        case '[19~' : key.name = 'f8'; break;
        case '[20~' : key.name = 'f9'; break;
        case '[21~' : key.name = 'f10'; break;
        case '[23~' : key.name = 'f11'; break;
        case '[24~' : key.name = 'f12'; break;

        /* xterm ESC [  letter */
        case '[A' : key.name = 'up'; break;
        case '[B' : key.name = 'down'; break;
        case '[C' : key.name = 'right'; break;
        case '[D' : key.name = 'left'; break;
        case '[E' : key.name = 'clear'; break;
        case '[F' : key.name = 'end'; break;
        case '[H' : key.name = 'home'; break;

        /* xterm/gnome ESC O letter */
        case 'OA' : key.name = 'up'; break;
        case 'OB' : key.name = 'down'; break;
        case 'OC' : key.name = 'right'; break;
        case 'OD' : key.name = 'left'; break;
        case 'OE' : key.name = 'clear'; break;
        case 'OF' : key.name = 'end'; break;
        case 'OH' : key.name = 'home'; break;

        /* xterm/rxvt ESC [  number ~ */
        case '[1~' : key.name = 'home'; break;
        case '[2~' : key.name = 'insert'; break;
        case '[3~' : key.name = 'delete'; break;
        case '[4~' : key.name = 'end'; break;
        case '[5~' : key.name = 'pageup'; break;
        case '[6~' : key.name = 'pagedown'; break;

        /* putty */
        case '[[5~' : key.name = 'pageup'; break;
        case '[[6~' : key.name = 'pagedown'; break;

        /* rxvt */
        case '[7~' : key.name = 'home'; break;
        case '[8~' : key.name = 'end'; break;

        /* rxvt keys with modifiers */
        case '[a' : key.name = 'up'; key.shift = true; break;
        case '[b' : key.name = 'down'; key.shift = true; break;
        case '[c' : key.name = 'right'; key.shift = true; break;
        case '[d' : key.name = 'left'; key.shift = true; break;
        case '[e' : key.name = 'clear'; key.shift = true; break;

        case '[2$' : key.name = 'insert'; key.shift = true; break;
        case '[3$' : key.name = 'delete'; key.shift = true; break;
        case '[5$' : key.name = 'pageup'; key.shift = true; break;
        case '[6$' : key.name = 'pagedown'; key.shift = true; break;
        case '[7$' : key.name = 'home'; key.shift = true; break;
        case '[8$' : key.name = 'end'; key.shift = true; break;

        case 'Oa' : key.name = 'up'; key.ctrl = true; break;
        case 'Ob' : key.name = 'down'; key.ctrl = true; break;
        case 'Oc' : key.name = 'right'; key.ctrl = true; break;
        case 'Od' : key.name = 'left'; key.ctrl = true; break;
        case 'Oe' : key.name = 'clear'; key.ctrl = true; break;

        case '[2^' : key.name = 'insert'; key.ctrl = true; break;
        case '[3^' : key.name = 'delete'; key.ctrl = true; break;
        case '[5^' : key.name = 'pageup'; key.ctrl = true; break;
        case '[6^' : key.name = 'pagedown'; key.ctrl = true; break;
        case '[7^' : key.name = 'home'; key.ctrl = true; break;
        case '[8^' : key.name = 'end'; key.ctrl = true; break;

        /* misc. */
        case '[Z' : key.name = 'tab'; key.shift = true; break;
        default : key.name = 'undefined'; break;
      }

    }
    else if( ch === '\r' )
    {
      key.name = 'return';
    }
    else if( ch === '\n' )
    {
      key.name = 'enter';
    }
    else if( ch === '\t' )
    {
      key.name = 'tab';
    }
    else if( ch === '\b' || ch === '\x7f' )
    {
      key.name = 'backspace';
      key.meta = escaped;
      //key._ch = ch;
      //key._chLength = ch.length;
    }
    else if( ch === '\x1b' )
    {
      key.name = 'escape';
      key.meta = escaped;
    }
    else if( ch === ' ' )
    {
      key.name = 'space';
      key.meta = escaped;
    }
    else if( !escaped && ch <= '\x1a' )
    {
      // ctrl+letter
      key.name = String.fromCharCode( ch.charCodeAt( 0 ) + 'a'.charCodeAt( 0 ) - 1 );
      key.ctrl = true;
    }
    else if( /^[ 0-9A-Za-z ]$/.test( ch ) )
    {
      // letter, number, shift+letter
      key.name = ch.toLowerCase(  );
      key.shift = /^[ A-Z ]$/.test( ch );
      key.meta = escaped;
    }
    else if( escaped )
    {
      // Escape sequence timeout
      key.name = ch.length ? undefined : 'escape';
      key.meta = true;
    }
    // else
    // {
    //   key.name = 'UNKNOWN';
    // }

    key.sequence = s;
    key.sequenceLength = s.length;
    key.ch = ch;

    if( s.length !== 0 && ( key.name !== undefined || escaped ) )
    {
      /* Named character or sequence */
      stream.emit( 'keypress', escaped ? undefined : s, key );
    }
    else if( s.length === 1 )
    {
      /* Single unnamed character, e.g. "." */
      stream.emit( 'keypress', s, key );
    }
    // else
    // {
    //   stream.emit( 'keypress', s, { name : 'unknown' } );
    // }
    /* Unrecognized or broken escape sequence, don't emit anything */
  }

}

//

const keyDecoderSymbol = Symbol( 'keypress-decoder' );
const escapeDecoderSymbol = Symbol( 'escape-decoder' );
const escapeTimeout = 500;

const _terminalEmitKeypressEvents = function _terminalEmitKeypressEvents( stream, iface )
{

  if( stream[ keyDecoderSymbol ] )
  return;

  var StringDecoder = require( 'string_decoder' ).StringDecoder;

  stream[ keyDecoderSymbol ] = new StringDecoder( 'utf8' );
  stream[ escapeDecoderSymbol ] = _terminalEmitKeys( stream );
  stream[ escapeDecoderSymbol ].next();

  function escapeCodeTimeout()
  {
    stream[ escapeDecoderSymbol ].next( '' );
  }

  let timeoutId;

  function onData( b )
  {

    if( stream.listenerCount( 'keypress' ) > 0 )
    {
      var r = stream[ keyDecoderSymbol ].write( b );
      if( r )
      {
        clearTimeout( timeoutId );

        if( iface )
        {
          iface._sawKeyPress = r.length === 1;
        }

        for( var i = 0; i < r.length; i++ )
        {
          if( r[ i ] === '\t' && typeof r[ i + 1 ] === 'string' && iface )
          {
            iface.isCompletionEnabled = false;
          }

          try
          {
            stream[ escapeDecoderSymbol ].next( r[ i ] );
            // Escape letter at the tail position
            if( r[ i ] === '\x1b' && i + 1 === r.length )
            {
              timeoutId = setTimeout( escapeCodeTimeout, escapeTimeout );
            }
          }
          catch( err )
          {
            stream[ escapeDecoderSymbol ] = _terminalEmitKeys( stream );
            stream[ escapeDecoderSymbol ].next();
            throw err;
          }
          finally
          {
            if( iface )
            iface.isCompletionEnabled = true;
          }
        }
      }
    }
    else
    {
      stream.removeListener( 'data', onData );
      stream.on( 'newListener', onNewListener );
    }
  }

  function onNewListener( event )
  {
    if( event == 'keypress' )
    {
      stream.on( 'data', onData );
      stream.removeListener( 'newListener', onNewListener );
    }
  }

  if( stream.listenerCount( 'keypress' ) > 0 )
  {
    stream.on( 'data', onData );
  }
  else
  {
    stream.on( 'newListener', onNewListener );
  }

}

// --
// accessor
// --

function _widthGet()
{
  var width = Infinity;
  if( this.output && this.output.columns )
  width = this.output.columns;
  return width;
}

//

function _rawModeSet( mode )
{
  if( !this.input )
  return;
  if( _.routineIs( this.input.setRawMode ) )
  return this.input.setRawMode( mode );
}

//

function _rawModeGet()
{
  if( !this.input )
  return;
  return this.input.isRaw;
}

// --
// relations
// --

var Composes =
{

  name : 'wTerminalShell',

  posOfPrevious : [ 0,0 ],

  onHistorySave : onHistorySave,
  onHistoryLoad : onHistoryLoad,

}

var Associates =
{

  input : null,
  output : null,
  completer : null,
  isTerminal : true,

  regexpWordLeft : /([^\s\w]+|\w+|)\s*$/,
  regexpWordRight : /^(\s+|\w+|\W+)\s*/,

}

var Restricts =
{

  _strBuffer : null,

  _endsReturn : false,
  _decoder : null,

  handleTerminalKeypress : null,
  handleTerminalEnd : null,
  handleTerminalOutputResize : null,

  handleStreamData : null,
  handleStreamEnd : null,

}

// --
// declare
// --

var Proto =
{


  init : init,

  //

  prompt : prompt,
  question : question,

  close : close,
  pause : pause,
  resume : resume,
  clear : clear,


  //

  _wordLeftMatch : _wordLeftMatch,
  _wordRightMatch : _wordRightMatch,

  _wordLeft : _wordLeft,
  _wordRight : _wordRight,

  _deleteLeft : _deleteLeft,
  _deleteRight : _deleteRight,

  _deleteWordLeft : _deleteWordLeft,
  _deleteWordRight : _deleteWordRight,

  _deleteLineLeft : _deleteLineLeft,
  _deleteLineRight : _deleteLineRight,


  // line

  _lineBegin : _lineBegin,
  _lineEnd : _lineEnd,
  _lineEnded : _lineEnded,
  _lineEntered : _lineEntered,
  _lineRefresh : _lineRefresh,

  lineCursorOffset : lineCursorOffset,
  _lineInsertString : _lineInsertString,


  //

  _lengthOf : _lengthOf,
  _sizeOf : _sizeOf,
  _posAtCursorGet : _posAtCursorGet,


  //write

  write : write,

  _writeOutput : _writeOutput,
  _rewriteInput : _rewriteInput,

  _writtenTerminal : _writtenTerminal,
  _writtenStream : _writtenStream,


  // history

  _historyPrependByCurrent : _historyPrependByCurrent,
  _historyNext : _historyNext,
  _historyPrev : _historyPrev,

  _historyCanged : _historyCanged,
  _historyEvalPath : _historyEvalPath,

  //_historySave : _historySave,
  //_historyLoad : _historyLoad,

  onHistorySave : onHistorySave,
  onHistoryLoad : onHistoryLoad,


  // complete

  _complete : _complete,
  _completeHandleGroup : _completeHandleGroup,
  _completeCommonPrefix : _completeCommonPrefix,


  // handler

  handleStreamData : handleStreamData,
  handleStreamEnd : handleStreamEnd,

  handleTerminalEnd : handleTerminalEnd,
  handleTerminalKeypress : handleTerminalKeypress,
  handleTerminalSigcont: handleTerminalSigcont,

  handleTerminalOutputResize : handleTerminalOutputResize,

  _terminalEmitKeys : _terminalEmitKeys,
  _terminalEmitKeypressEvents : _terminalEmitKeypressEvents,


  // accessor

  '_widthGet' : _widthGet,
  '_rawModeSet' : _rawModeSet,
  '_rawModeGet' : _rawModeGet,


  // relations

  
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

_.accessor( Self.prototype,
{
  width : 'width',
  rawMode : 'rawMode',
});

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = Self;
_.TerminalShell = Self;

if( !_global_.wTools.Terminal )
_.Terminal = Self;
if( !_global_.wTerminal )
_global_.wTerminal = Self;

return Self;

} )();
