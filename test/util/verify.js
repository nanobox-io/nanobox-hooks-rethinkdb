var args = process.argv.slice(2);
r = require('rethinkdb');
var connection = null;
r.connect( {host: args[0], port: args[1]}, function(err, conn) {
    if (err) throw err;
    connection = conn;

    r.db('gonano').table('keys').filter(r.row('key').eq( args[2] )).
    run(connection, function(err, cursor) {
        if (err) throw err;
        cursor.toArray(function(err, result) {
            if (err) throw err;
            console.log(JSON.stringify(result, null, 2));
            process.exit();
        });
    });
})

