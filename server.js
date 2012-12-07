//setup Dependencies
var connect = require('connect')
    , port = (process.env.PORT || 8081);

connect()
    .use(connect.static(__dirname))
    .listen(port);
