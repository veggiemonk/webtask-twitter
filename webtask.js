"use latest";

var _    = require( 'lodash' )
var Twit = require( 'twit' )

// Avoid ciruclar references in JSON
function censor( censor ) {
  var i = 0;

  return function ( key, value ) {
    if ( i !== 0 && typeof(censor) === 'object' && typeof(value) == 'object' && censor == value )
      return '[Circular]'

    if ( i >= 29 ) // seems to be a harded maximum of 30 serialized objects?
      return '[Unknown]'

    ++i; // so we know we aren't using the original object anymore

    return value;
  }
}

/**
 *
 * @param text
 * @param urls
 * @returns {*}
 */
function replace( text, ...urls ) {
  let newText = text
  _.each( _.flattenDeep( urls ), ( {url, final} ) => {
    newText = newText.replace( url, final )
  } )
  return newText
}

/**
 * @param pics Array of pictures urls
 * @returns [{ final, url }] Array of object containing the twitter urls and the final, redirected urls
 */
function extractPictures( ...pics ) {
  return _( pics )
    .filter( ( x ) => ( x.type == 'photo' ) )
    .map( ( {media_url, url} ) => ({ final: media_url, url }) )
    .value()
}

/**
 * @param urls Array of links
 * @returns [{ final, url }] Array of object containing the twitter urls and the final, redirected urls
 */
function tweetWithURLs( ...urls ) {
  return (urls.length > 0)
    ? _.map( urls, ( {expanded_url, url} ) => ({ final: expanded_url, url }) )
    : null
}

/**
 * Pick only the interesting twitter data and replace the urls with original ones
 * @param data
 * @returns {Array}
 */
function parseData( ...data ) {
  return _.map( data, ( { entities, text: tweet, user } ) => {
    if ( !entities ) return tweet

    const { media, urls } = entities
    const twu = urls && tweetWithURLs( ...urls )
    const twp = media && extractPictures( ...media )
    let tw    = twu ? replace( tweet, twu ) : tweet
    tw        = twp ? replace( tw, twp ) : tw

    return ( user && user.name) ? `${user.name}(@${user.screen_name}): ${tw}` : tw
  } )
}

module.exports = function ( ctx, req, res ) {

  //retrieve secure parameter
  const { token, secret, consumerKey, consumerSecret } = ctx.data
  //connect to twitter
  const twitter = new Twit( {
    consumer_key:          consumerKey
    , consumer_secret:     consumerSecret
    , access_token:        token
    , access_token_secret: secret
  } )

  twitter.get( 'statuses/home_timeline', function ( err, data, response ) {
    if ( err ) return res.end( err );
    res.writeHead( 200, { 'Content-Type': 'application/json' } )
    if ( data ) {
      //res.end( JSON.stringify( _.pluck(data, 'text') ) )
      return res.end( JSON.stringify( parseData( ...data ) ) )

    } else if ( response ) {
      return res.end( JSON.stringify( response, censor( response ) ) )
    }
  } )
}

