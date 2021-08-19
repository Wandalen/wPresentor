(async function()
{
  const _ = _global_.wTools;

  const presentor = _.presentor.Presentor({ dataPath : _.path.resolve( 'Courses.stxt' ) });
  await presentor.form();

  // const response = await fetch( _.path.join( _.path.current(), 'Courses.stxt' ) );
  // const dataStr = await response.text();
  // const renderer = _.presentor.Renderer({ structure : dataStr });
  //
  // const page0 = renderer.pageRender( 0 );
  // for( let i = 0 ; i < page0.length ; i++ )
  // page0[ i ] = _.html.exportToString( page0[ i ] );
  //
  // const data = page0.join( '\n' );
  //
  // document.body.innerHTML = data;
  // console.log( data );

})()

