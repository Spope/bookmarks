var oauth2orize = require('oauth2orize');
var passport = require('passport');
var bootstrap = require('./bootstrap');


// create OAuth 2.0 server
var server = oauth2orize.createServer();

// Register serialialization and deserialization functions.
//
// When a client redirects a user to user authorization endpoint, an
// authorization transaction is initiated. To complete the transaction, the
// user must authenticate and approve the authorization request. Because this
// may involve multiple HTTP request/response exchanges, the transaction is
// stored in the session.
//
// An application must supply serialization functions, which determine how the
// client object is serialized into the session. Typically this will be a
// simple matter of serializing the client's ID, and deserializing by finding
// the client by ID from the database.

server.serializeClient(function(client, done) {
    return done(null, client.id);
});

server.deserializeClient(function(id, done) {
    var sql = "SELECT * FROM oauth_client WHERE id = "+bootstrap.getConnection().escape(id)+" LIMIT 1";
    bootstrap.getConnection().query(sql, function(err, rows) {
        if (err) { return done(err); }
        return done(null, rows[0]);
    });
});



// Register supported grant types.
//
// OAuth 2.0 specifies a framework that allows users to grant client
// applications limited access to their protected resources. It does this
// through a process of the user granting access, and the client exchanging
// the grant for an access token.

// Grant authorization codes. The callback takes the `client` requesting
// authorization, the `redirectURI` (which is used as a verifier in the
// subsequent exchange), the authenticated `user` granting access, and
// their response, which contains approved scope, duration, etc. as parsed by
// the application. The application issues a code, which is bound to these
// values, and will be exchanged for an access token.
server.grant(oauth2orize.grant.code(function(client, redirect_uri, user, ares, done) {
    var code = utils.uid(16)

    var sql = "INSERT INTO oauth_authorization_code (code, client_id, redirect_uri, user_id) VALUES "
    +"("+bootstrap.getConnection().escape(code)+", "+bootstrap.getConnection().escape(client.client_id)+", "+bootstrap.getConnection().escape(redirect_uri)+", "+bootstrap.getConnection().escape(user.id)+")";

    bootstrap.getConnection().query(sql, function(err, rows) {
        if (err) { return done(err); }
        done(null, code);
    });
}));







// Exchange authorization codes for access tokens. The callback accepts the
// `client`, which is exchanging `code` and any `redirectURI` from the
// authorization request for verification. If these values are validated, the
// application issues an access token on behalf of the user who authorized the
// code.

server.exchange(oauth2orize.exchange.code(function(client, code, redirectURI, done) {

    var sql = "SELECT * FROM oauth_authorization_code WHERE code = "+bootstrap.getConnection().escape(code)+" "+
    "AND client_id = "+bootstrap.getConnection().escape(client.client_id)+" LIMIT 1";
    bootstrap.getConnection().query(sql, function(err, rows) {
        if (err) { return done(err); }
        if (rows[0] === undefined) { return done(null, false); }
        if (redirectURI !== rows[0].redirect_uri) { return done(null, false); }

        var sql = "DELETE FROM oauth_authorization_code WHERE code = "+bootstrap.getConnection().escape(code)+" LIMIT 1";
        bootstrap.getConnection().query(sql, function(err, delRows) {
            if(err) { return done(err); }
            var token = utils.uid(256);

            var sql = "INSERT INTO oauth_access_token (token, user_id, client_id) VALUES "
            +"("+bootstrap.getConnection().escape(token)+", "+bootstrap.getConnection().escape(rows[0].user_id)+", "+bootstrap.getConnection().escape(rows[0].client_id)+")";
            bootstrap.getConnection().query(sql, function(err, rows) {
                if (err) { return done(err); }
                done(null, token);
            });
        });
    });
}));








// user authorization endpoint
//
// `authorization` middleware accepts a `validate` callback which is
// responsible for validating the client making the authorization request. In
// doing so, is recommended that the `redirectURI` be checked against a
// registered value, although security requirements may vary accross
// implementations. Once validated, the `done` callback must be invoked with
// a `client` instance, as well as the `redirectURI` to which the user will be
// redirected after an authorization decision is obtained.
//
// This middleware simply initializes a new authorization transaction. It is
// the application's responsibility to authenticate the user and render a dialog
// to obtain their approval (displaying details about the client requesting
// authorization). We accomplish that here by routing through `ensureLoggedIn()`
// first, and rendering the `dialog` view.

exports.authorization = [
    //login.ensureLoggedIn(),
    server.authorization(function(client_id, redirectURI, done) {
        var sql = "SELECT * FROM oauth_client WHERE client_id = "+bootstrap.getConnection().escape(client_id)+" LIMIT 1";
        bootstrap.getConnection().query(sql, function(err, rows) {
            if (err) { return done(err); }
            // WARNING: For security purposes, it is highly advisable to check that
            // redirectURI provided by the client matches one registered with
            // the server. For simplicity, this example does not. You have
            // been warned.
            return done(null, rows[0], redirectURI);
        });
    }),
    function(req, res){
        res.render('dialog', {
            transactionID: req.oauth2.transactionID,
            user: req.user,
            client: req.oauth2.client,
            layout: false
        });
    }
]

exports.callback = [
    //login.ensureLoggedIn(),
    function(req, res){
        res.render('callback', {
            layout: false
        });
    }
]




// user decision endpoint
//
// `decision` middleware processes a user's decision to allow or deny access
// requested by a client application. Based on the grant type requested by the
// client, the above grant middleware configured above will be invoked to send
// a response.

exports.decision = [
    //login.ensureLoggedIn(),
    server.decision()
]





// token endpoint
//
// `token` middleware handles client requests to exchange authorization grants
// for access tokens. Based on the grant type being exchanged, the above
// exchange middleware will be invoked to handle the request. Clients must
// authenticate when making requests to this endpoint.

exports.token = [
    passport.authenticate(['basic', 'oauth2-client-password'], { session: false }),
    server.token(),
    server.errorHandler()
]



var utils = {

    uid: function(len) {
        var buf = []
          , chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
          , charlen = chars.length;

        for (var i = 0; i < len; ++i) {
            buf.push(chars[this.getRandomInt(0, charlen - 1)]);
        }

        return buf.join('');
    },

    getRandomInt: function(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

}
