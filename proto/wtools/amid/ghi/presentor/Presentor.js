viewPresentor = function viewPresentor(locals) {
var jade_debug = [{ lineno: 1, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" }];
try {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function (undefined) {
var jade_indent = [];
jade_debug.unshift({ lineno: 0, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
jade_debug.unshift({ lineno: 2, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
buf.push("\n<div class=\"ui vertical menu\">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 3, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
buf.push("<a class=\"item action-theme-dark\">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 4, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
buf.push("Change Theme");
jade_debug.shift();
jade_debug.shift();
buf.push("</a>");
jade_debug.shift();
jade_debug.unshift({ lineno: 5, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
buf.push("<a class=\"item action-about\">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 6, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
buf.push("About");
jade_debug.shift();
jade_debug.shift();
buf.push("</a>");
jade_debug.shift();
jade_debug.unshift({ lineno: 7, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
buf.push("<a class=\"item action-back\">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 8, filename: "/pro/web/Port/package/wPresentor/staging/wtools/amid/ghi/presentor/Presentor.jht" });
buf.push("Back");
jade_debug.shift();
jade_debug.shift();
buf.push("</a>");
jade_debug.shift();
jade_debug.shift();
buf.push("</div>");
jade_debug.shift();
jade_debug.shift();}.call(this,"undefined" in locals_for_with?locals_for_with.undefined:typeof undefined!=="undefined"?undefined:undefined));;return buf.join("");
} catch (err) {
  jade.rethrow(err, jade_debug[0].filename, jade_debug[0].lineno, "\n.ui.vertical.menu\n  a.item.action-theme-dark\n    | Change Theme\n  a.item.action-about\n    | About\n  a.item.action-back\n    | Back\n");
}
}