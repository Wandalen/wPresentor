less =
{
  env: "development",           // or "production"
  logLevel: 1,                  // The amount of logging in the javascript console
  async: true,                  // load imports async
  fileAsync: true,              // load imports async when in a page under a file protocol
  poll: 1000,                   // when in watch mode, time in ms between polls
  functions: {},                // user functions, keyed by name
  dumpLineNumbers: "comments",  // or "mediaQuery" or "all"
  relativeUrls: false,          // whether to adjust url's to be relative, if false, url's are already relative to the entry less file
  strictMath: true,             // eval calc only in redundant parentheses
  //rootpath: ":/a.com/"// a path to add on to the start of every url resource
};
