(function _Color256_s_() {

'use strict';

/**
  @module Tools/mid/Color256 - Collection of routines to operate colors conveniently. Extends basic implementation Color by additional color names. Color provides functions to convert color from one color space to another color space, from name to color and from color to the closest name of a color. The module does not introduce any specific storage format of color what is a benefit. Color has a short list of the most common colors. Use the module for formatted colorful output or other sophisticated operations with colors.
*/

/**
 * @file Color256.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wColor' )

}

var _ = _global_.wTools;
var Self = _global_.wTools;

// --
// var
// --

var ColorMap =
{
  "aquamarine"                    : [ 0.5,1.0,0.83 ],
  "twilight blue"                 : [ 0.94,1.0,1.0 ],
  "beige"                         : [ 0.96,0.96,0.86 ],
  "bisque"                        : [ 1.0,0.89,0.77 ],
  "chocolate"                     : [ 0.82,0.41,0.12 ],
  "coral"                         : [ 1.0,0.5,0.3 ],
  "cornsilk"                      : [ 1.0,0.97,0.86 ],
  "crimson"                       : [ 0.86,0.08,0.23 ],
  "gainsboro"                     : [ 0.86,0.86,0.86 ],
  "gold"                          : [ 1.0,0.84,0.0 ],
  "honeydew"                      : [ 0.94,1.0,0.94 ],
  "indigo"                        : [ 0.29,0.0,0.51 ],
  "ivory"                         : [ 1.0,1.0,0.94 ],
  "khaki"                         : [ 0.94,0.90,0.55 ],
  "lavender"                      : [ 0.90,0.90,0.98 ],
  "linen"                         : [ 0.98,0.94,0.90 ],
  "moccasin"                      : [ 1.0,0.89,0.71 ],
  "orchid"                        : [ 0.85,0.44,0.84 ],
  "peru"                          : [ 0.80,0.52,0.25 ],
  "plum"                          : [ 0.87,0.63,0.87 ],
  "salmon"                        : [ 0.98,0.50,0.45 ],
  "sienna"                        : [ 0.63,0.32,0.17 ],
  "snow"                          : [ 1.0,0.98,0.98 ],
  "tan"                           : [ 0.82,0.70,0.55 ],
  "thistle"                       : [ 0.85,0.75,0.85 ],
  "tomato"                        : [ 1.0,0.39,0.28 ],
  "turquoise"                     : [ 0.25,0.88,0.81 ],
  "wheat"                         : [ 0.96,0.87,0.70 ],
  /**/
  "moderate pink"                 : [ 0.93,0.56,0.53 ],
  "dark pink"                     : [ 0.78,0.41,0.39 ],
  "pale pink"                     : [ 1.00,0.80,0.73 ],
  "grayish pink"                  : [ 0.81,0.61,0.56 ],
  "pinkish white "                : [ 0.98,0.86,0.78 ],
  "pinkish gray "                 : [ 0.78,0.65,0.59 ],
  "vivid red"                     : [ 0.76,0.00,0.13 ],
  "strong red"                    : [ 0.75,0.13,0.20 ],
  "deep red"                      : [ 0.48,0.00,0.11 ],
  "very deep red"                 : [ 0.31,0.00,0.08 ],
  "moderate red"                  : [ 0.67,0.20,0.23 ],
  "dark red"                      : [ 0.41,0.11,0.14 ],
  "very dark red"                 : [ 0.20,0.04,0.09 ],
  "light grayish red"             : [ 0.69,0.45,0.40 ],
  "grayish red"                   : [ 0.55,0.28,0.26 ],
  "dark grayish red"              : [ 0.28,0.16,0.16 ],
  "blackish red"                  : [ 0.12,0.05,0.07 ],
  "reddish gray"                  : [ 0.55,0.42,0.38 ],
  "dark reddish gray"             : [ 0.32,0.24,0.21 ],
  "reddish black"                 : [ 0.12,0.07,0.07 ],
  "vivid yellowish pink"          : [ 1.00,0.52,0.36 ],
  "deep yellowish pink"           : [ 0.96,0.29,0.27 ],
  "light yellowish pink"          : [ 1.00,0.70,0.55 ],
  "moderate yellowish pink"       : [ 0.93,0.58,0.45 ],
  "dark yellowish pink"           : [ 0.80,0.42,0.36 ],
  "pale yellowish pink"           : [ 1.00,0.78,0.66 ],
  "grayish yellowish pink"        : [ 0.83,0.61,0.52 ],
  "brownish pink"                 : [ 0.80,0.60,0.48 ],
  "strong reddish orange"         : [ 1.00,0.73,0.38 ],
  "deep reddish orange"           : [ 0.66,0.11,0.07 ],
  "moderate reddish orange"       : [ 0.83,0.33,0.22 ],
  "dark reddish orange"           : [ 0.61,0.18,0.12 ],
  "grayish reddish orange"        : [ 0.72,0.36,0.26 ],
  "deep reddish brown"            : [ 0.29,0.00,0.02 ],
  "light reddish brown"           : [ 0.67,0.40,0.32 ],
  "moderate reddish brown"        : [ 0.44,0.18,0.15 ],
  "dark reddish brown"            : [ 0.20,0.06,0.07 ],
  "light grayish reddish brown"   : [ 0.59,0.42,0.34 ],
  "grayish reddish brown"         : [ 0.37,0.22,0.19 ],
  "dark grayish reddish brown"    : [ 0.22,0.12,0.11 ],
  "vivid orange"                  : [ 1.00,0.41,0.00 ],
  "brilliant orange"              : [ 1.00,0.72,0.25 ],
  "strong orange"                 : [ 1.00,0.44,0.10 ],
  "deep orange"                   : [ 0.76,0.30,0.04 ],
  "light orange"                  : [ 1.00,0.63,0.38 ],
  "moderate orange"               : [ 0.91,0.47,0.24 ],
  "brownish orange"               : [ 0.69,0.32,0.14 ],
  "strong brown"                  : [ 0.46,0.20,0.07 ],
  "deep brown"                    : [ 0.30,0.13,0.05 ],
  "light brown"                   : [ 0.66,0.40,0.25 ],
  "moderate brown"                : [ 0.40,0.22,0.14 ],
  "dark brown"                    : [ 0.21,0.09,0.05 ],
  "light grayish brown"           : [ 0.58,0.42,0.33 ],
  "grayish brown"                 : [ 0.35,0.24,0.19 ],
  "dark grayish brown"            : [ 0.20,0.13,0.10 ],
  "light brownish gray"           : [ 0.55,0.43,0.36 ],
  "brownish gray"                 : [ 0.31,0.24,0.20 ],
  "brownish black"                : [ 0.08,0.06,0.04 ],
  "brilliant orange yellow"       : [ 1.00,0.69,0.18 ],
  "strong orange yellow"          : [ 1.00,0.56,0.05 ],
  "deep orange yellow"            : [ 0.84,0.43,0.00 ],
  "light orange yellow"           : [ 1.00,0.73,0.38 ],
  "moderate orange yellow"        : [ 0.97,0.58,0.24 ],
  "dark orange yellow"            : [ 0.76,0.46,0.16 ],
  "pale orange yellow"            : [ 1.00,0.79,0.53 ],
  "strong yellowish brown"        : [ 0.58,0.31,0.05 ],
  "light yellowish brown"         : [ 0.73,0.55,0.33 ],
  "moderate yellowish brown"      : [ 0.49,0.32,0.18 ],
  "dark yellowish brown"          : [ 0.25,0.15,0.07 ],
  "light grayish yellowish brown" : [ 0.71,0.53,0.39 ],
  "grayish yellowish brown"       : [ 0.47,0.35,0.25 ],
  "dark grayish yellowish brown"  : [ 0.24,0.17,0.12 ],
  "vivid yellow"                  : [ 1.00,0.70,0.00 ],
  "brilliant yellow"              : [ 1.00,0.81,0.25 ],
  "strong yellow"                 : [ 0.90,0.62,0.12 ],
  "deep yellow"                   : [ 0.71,0.47,0.00 ],
  "light yellow"                  : [ 1.00,0.83,0.37 ],
  "moderate yellow"               : [ 0.84,0.62,0.25 ],
  "dark yellow"                   : [ 0.69,0.49,0.17 ],
  "pale yellow"                   : [ 1.00,0.86,0.55 ],
  "grayish yellow"                : [ 0.81,0.64,0.38 ],
  "dark grayish yellow"           : [ 0.64,0.49,0.27 ],
  "yellowish white"               : [ 1.00,0.89,0.72 ],
  "yellowish gray"                : [ 0.79,0.66,0.52 ],
  "light olive brown"             : [ 0.58,0.36,0.04 ],
  "moderate olive brown"          : [ 0.39,0.25,0.06 ],
  "dark olive brown"              : [ 0.19,0.13,0.07 ],
  "vivid greenish yellow"         : [ 0.96,0.78,0.00 ],
  "brilliant greenish yellow"     : [ 1.00,0.86,0.20 ],
  "strong greenish yellow"        : [ 0.80,0.66,0.09 ],
  "deep greenish yellow"          : [ 0.62,0.51,0.00 ],
  "light greenish yellow"         : [ 1.00,0.87,0.35 ],
  "moderate greenish yellow"      : [ 0.77,0.64,0.24 ],
  "dark greenish yellow"          : [ 0.61,0.51,0.15 ],
  "pale greenish yellow"          : [ 1.00,0.87,0.52 ],
  "grayish greenish yellow"       : [ 0.77,0.65,0.37 ],
  "light olive"                   : [ 0.52,0.42,0.13 ],
  "moderate olive"                : [ 0.37,0.29,0.06 ],
  "dark olive"                    : [ 0.21,0.17,0.07 ],
  "light grayish olive"           : [ 0.55,0.45,0.29 ],
  "grayish olive"                 : [ 0.32,0.27,0.17 ],
  "dark grayish olive"            : [ 0.17,0.15,0.09 ],
  "light olive gray"              : [ 0.53,0.45,0.35 ],
  "olive gray"                    : [ 0.30,0.26,0.20 ],
  "olive black"                   : [ 0.07,0.10,0.06 ],
  "brilliant yellow green"        : [ 0.81,0.82,0.23 ],
  "strong yellow green"           : [ 0.50,0.56,0.09 ],
  "deep yellow green"             : [ 0.26,0.37,0.09 ],
  "light yellow green"            : [ 0.86,0.83,0.42 ],
  "moderate yellow green"         : [ 0.55,0.54,0.25 ],
  "pale yellow green"             : [ 0.94,0.84,0.60 ],
  "grayish yellow green"          : [ 0.56,0.52,0.36 ],
  "strong olive green"            : [ 0.04,0.27,0.00 ],
  "deep olive green"              : [ 0.08,0.14,0.00 ],
  "moderate olive green"          : [ 0.26,0.29,0.11 ],
  "grayish olive green"           : [ 0.28,0.27,0.18 ],
  "dark grayish olive green"      : [ 0.15,0.15,0.10 ],
  "vivid yellowish green"         : [ 0.22,0.60,0.19 ],
  "brilliant yellowish green"     : [ 0.55,0.80,0.37 ],
  "strong yellowish green"        : [ 0.28,0.52,0.19 ],
  "deep yellowish green"          : [ 0.00,0.33,0.12 ],
  "very deep yellowish green"     : [ 0.00,0.16,0.00 ],
  "very light yellowish green"    : [ 0.78,0.87,0.56 ],
  "light yellowish green"         : [ 0.00,0.48,0.65 ],
  "moderate yellowish green"      : [ 0.40,0.50,0.29 ],
  "dark yellowish green"          : [ 0.19,0.29,0.15 ],
  "very dark yellowish green"     : [ 0.07,0.15,0.07 ],
  "vivid green"                   : [ 0.00,0.49,0.20 ],
  "brilliant green"               : [ 0.28,0.65,0.42 ],
  "strong green"                  : [ 0.00,0.42,0.24 ],
  "deep green"                    : [ 0.00,0.27,0.14 ],
  "very light green"              : [ 0.60,0.78,0.58 ],
  "light green"                   : [ 0.44,0.61,0.43 ],
  "moderate green"                : [ 0.22,0.40,0.27 ],
  "dark green"                    : [ 0.13,0.23,0.15 ],
  "very dark green"               : [ 0.09,0.15,0.11 ],
  "very pale green"               : [ 0.85,0.87,0.73 ],
  "pale green"                    : [ 0.55,0.57,0.48 ],
  "grayish green"                 : [ 0.34,0.37,0.31 ],
  "dark grayish green"            : [ 0.19,0.22,0.19 ],
  "blackish green"                : [ 0.08,0.09,0.07 ],
  "greenish white"                : [ 0.96,0.90,0.80 ],
  "light greenish gray"           : [ 0.73,0.69,0.59 ],
  "greenish gray"                 : [ 0.48,0.46,0.40 ],
  "dark greenish gray"            : [ 0.27,0.26,0.23 ],
  "greenish black"                : [ 0.09,0.08,0.07 ],
  "vivid bluish green"            : [ 0.00,0.51,0.43 ],
  "brilliant bluish green"        : [ 0.00,0.61,0.46 ],
  "strong bluish green"           : [ 0.00,0.43,0.36 ],
  "deep bluish green"             : [ 0.00,0.22,0.17 ],
  "very light bluish green"       : [ 0.63,0.84,0.71 ],
  "light bluish green"            : [ 0.40,0.62,0.52 ],
  "moderate bluish green"         : [ 0.18,0.40,0.34 ],
  "dark bluish green"             : [ 0.00,0.23,0.20 ],
  "very dark bluish green"        : [ 0.00,0.11,0.09 ],
  "vivid greenish blue"           : [ 0.00,0.48,0.65 ],
  "brilliant greenish blue"       : [ 0.16,0.55,0.61 ],
  "strong greenish blue"          : [ 0.00,0.40,0.49 ],
  "deep greenish blue"            : [ 0.00,0.48,0.65 ],
  "very light greenish blue"      : [ 0.64,0.78,0.75 ],
  "light greenish blue"           : [ 0.39,0.60,0.62 ],
  "moderate greenish blue"        : [ 0.19,0.38,0.42 ],
  "dark greenish blue"            : [ 0.00,0.22,0.25 ],
  "very dark greenish blue"       : [ 0.01,0.13,0.15 ],
  "vivid blue,ultramarine"        : [ 0.00,0.49,0.68 ],
  "brilliant blue,celestial blue" : [ 0.26,0.52,0.71 ],
  "strong blue,bright blue"       : [ 0.00,0.33,0.54 ],
  "deep blue,royal blue"          : [ 0.00,0.18,0.33 ],
  "very light blue"               : [ 0.65,0.74,0.84 ],
  "sky blue"                      : [ 0.42,0.57,0.69 ],
  "moderate blue,cerulean blue"   : [ 0.22,0.34,0.47 ],
  "dark blue,navy blue"           : [ 0.00,0.13,0.22 ],
  "very pale blue,cloud blue"     : [ 0.76,0.79,0.79 ],
  "pale blue,alice blue"          : [ 0.57,0.57,0.57 ],
  "grayish blue,slate blue"       : [ 0.29,0.33,0.36 ],
  "dark grayish blue"             : [ 0.17,0.20,0.22 ],
  "blackish blue"                 : [ 0.09,0.10,0.12 ],
  "bluish white"                  : [ 0.98,0.87,0.81 ],
  "light bluish gray"             : [ 0.75,0.68,0.63 ],
  "bluish gray"                   : [ 0.49,0.45,0.43 ],
  "dark bluish gray"              : [ 0.27,0.27,0.27 ],
  "bluish black"                  : [ 0.08,0.09,0.10 ],
  "vivid purplish blue"           : [ 0.13,0.08,0.37 ],
  "brilliant purplish blue"       : [ 0.38,0.39,0.61 ],
  "strong purplish blue"          : [ 0.28,0.26,0.54 ],
  "deep purplish blue"            : [ 0.10,0.08,0.25 ],
  "very light purplish blue"      : [ 0.73,0.67,0.78 ],
  "light purplish blue"           : [ 0.51,0.49,0.64 ],
  "moderate purplish blue"        : [ 0.26,0.24,0.39 ],
  "dark purplish blue"            : [ 0.10,0.09,0.16 ],
  "very pale purplish blue"       : [ 0.80,0.73,0.77 ],
  "pale purplish blue"            : [ 0.54,0.50,0.56 ],
  "grayish purplish blue"         : [ 0.25,0.24,0.32 ],
  "vivid violet"                  : [ 0.53,0.29,0.68 ],
  "brilliant violet"              : [ 0.46,0.36,0.60 ],
  "strong violet"                 : [ 0.33,0.22,0.48 ],
  "deep violet"                   : [ 0.14,0.04,0.21 ],
  "very light violet"             : [ 0.93,0.75,0.95 ],
  "light violet"                  : [ 0.53,0.42,0.60 ],
  "moderate violet"               : [ 0.33,0.22,0.39 ],
  "dark violet"                   : [ 0.13,0.07,0.17 ],
  "very pale violet"              : [ 0.85,0.69,0.75 ],
  "pale violet"                   : [ 0.58,0.48,0.55 ],
  "grayish violet"                : [ 0.27,0.22,0.29 ],
  "vivid purple"                  : [ 0.58,0.20,0.57 ],
  "brilliant purple"              : [ 0.87,0.50,0.80 ],
  "strong purple"                 : [ 0.50,0.24,0.46 ],
  "deep purple"                   : [ 0.33,0.10,0.31 ],
  "very deep purple"              : [ 0.20,0.04,0.21 ],
  "very light purple"             : [ 0.89,0.66,0.75 ],
  "light purple"                  : [ 0.73,0.50,0.64 ],
  "moderate purple"               : [ 0.50,0.28,0.44 ],
  "dark purple"                   : [ 0.28,0.16,0.25 ],
  "very dark purple"              : [ 0.14,0.05,0.13 ],
  "very pale purple"              : [ 0.90,0.73,0.76 ],
  "pale purple"                   : [ 0.68,0.52,0.55 ],
  "grayish purple"                : [ 0.45,0.32,0.36 ],
  "dark grayish purple"           : [ 0.27,0.18,0.21 ],
  "blackish purple"               : [ 0.11,0.06,0.09 ],
  "purplish white"                : [ 0.98,0.86,0.78 ],
  "light purplish gray"           : [ 0.78,0.66,0.62 ],
  "purplish gray"                 : [ 0.53,0.44,0.42 ],
  "dark purplish gray"            : [ 0.34,0.25,0.26 ],
  "purplish black"                : [ 0.11,0.07,0.09 ],
  "vivid reddish purple"          : [ 0.49,0.00,0.35 ],
  "strong reddish purple"         : [ 0.60,0.21,0.42 ],
  "deep reddish purple"           : [ 0.39,0.07,0.29 ],
  "very deep reddish purple"      : [ 0.28,0.03,0.21 ],
  "light reddish purple"          : [ 0.73,0.42,0.54 ],
  "moderate reddish purple"       : [ 0.55,0.27,0.40 ],
  "dark reddish purple"           : [ 0.31,0.15,0.23 ],
  "very dark reddish purple"      : [ 0.15,0.04,0.12 ],
  "pale reddish purple"           : [ 0.67,0.46,0.50 ],
  "grayish reddish purple"        : [ 0.49,0.30,0.36 ],
  "brilliant purplish pink"       : [ 1.00,0.59,0.73 ],
  "deep purplish pink"            : [ 0.92,0.32,0.52 ],
  "light purplish pink"           : [ 1.00,0.66,0.69 ],
  "moderate purplish pink"        : [ 0.89,0.50,0.56 ],
  "dark purplish pink"            : [ 0.78,0.40,0.45 ],
  "pale purplish pink"            : [ 0.99,0.74,0.73 ],
  "grayish purplish pink"         : [ 0.80,0.57,0.58 ],
  "vivid purplish red"            : [ 0.84,0.15,0.36 ],
  "deep purplish red"             : [ 0.44,0.00,0.21 ],
  "very deep purplish red"        : [ 0.28,0.00,0.15 ],
  "moderate purplish red"         : [ 0.65,0.22,0.33 ],
  "dark purplish red"             : [ 0.36,0.12,0.19 ],
  "very dark purplish red"        : [ 0.16,0.03,0.10 ],
  "light grayish purplish red"    : [ 0.70,0.44,0.44 ],
  "grayish purplish red"          : [ 0.55,0.28,0.32 ],
  "light gray"                    : [ 0.76,0.66,0.58 ],
  "medium gray"                   : [ 0.51,0.44,0.40 ],
  "dark gray"                     : [ 0.29,0.26,0.24 ],
}

// --
// declare
// --

var Proto =
{

  ColorMap : ColorMap,

}

//

if( !_.color )
{
  _.color = Proto;
}
else
{
  _.mapSupplement( _.color,Proto );
  _.mapSupplement( _.color.ColorMap,ColorMap );
}

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
