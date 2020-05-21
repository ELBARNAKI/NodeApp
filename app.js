 let http =require('http');
 let port = 8080;

 let server = http.createServer(function(request,response){
     console.log('Got request');
     response.end('heloo this is a test ');
 });
 server.listen(port, function(error){
     if (error){
         return console.log(' error ',error);
     }
     console.log('Server is listening on port: ', port);
 });


