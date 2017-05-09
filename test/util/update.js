var args = process.argv.slice(2);
r = require('rethinkdb');
var connection = null;
r.connect( {host: args[0], port: args[1]}, function(err, conn) {
    if (err) throw err;
    connection = conn;

    r.db('gonano').table('keys').filter(r.row('key').eq( args[2] )).update({value: args[3]}).
    run(connection, function(err, result) {
        if (err) throw err;
        console.log(JSON.stringify(result, null, 2));
        process.exit();
    });
})

