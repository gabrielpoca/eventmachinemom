console.log("Initializing...");

function MyWebSocket(host, port) {
  var self = this;
  self._host = host;
  self._port = port;
  self._count = 0;
  self._id = 0;
  self._socket = new WebSocket("ws://"+self._host+":"+self._port);
  
  self._socket.onmessage = function(event) {
    self._onmessage(event);
  }

  return true;
}

MyWebSocket.prototype._onmessage = function(event) {
  if(this._id == 0) {
    console.log("assigning id "+event.data);
    this._id = event.data;
  } else  {
    id = event.data.split(":").pop();
    if(this._id != id) {
      message = event.data.replace(/:[0-9]+/, "");
      this._count += 1;
      console.log(message);
    }
  }
}

MyWebSocket.prototype.postCommand = function(command, message) {
  message = JSON.stringify([command, message+":"+this._id]);
  this._socket.send(message);
}

var my_socket = null;

function get_count() {
  console.log("Received "+my_socket._count+" messages!");
}

function spam() {
  var messages = $('#messages').val();

  if(my_socket != null) {
    setTimeout(function() {
      for(var i = 0; i < messages; i++) {
        my_socket.postCommand(["all"], "asd "+i);
      }
    }, 2000);
  } else {
    console.log("No connection found!");
  }
}

function connect() {
  var port = $("#port").val();
  my_socket = new MyWebSocket('0.0.0.0', port);
}

function multi_connect() {
  var connections = $("#connections").val();
  var ports = $("#ports").val();
  var sockets = new Array();
  ports.split(",").forEach(function(port) {
    sockets.push(new MyWebSocket('0.0.0.0', port));
  });

  setTimeout(function() {
    sockets.forEach(function(socket) {
      for(var i = 0; i < connections; i++) {
        socket.postCommand(['all'], "message "+i);
      }
    });
  }, 2000);

}

//websockets = new Array();
//[8080, 8080].forEach(function(port) {
  //var websocket = new WebSocket("ws://0.0.0.0:"+port);
  //var websocket_id = 0;

  //websocket.onmessage = function (message) {
    //message = message.data;
    //console.log("Received: "+message);
    //if(websocket_id == 0) {
      //websocket_id = message;
    //} else {
      //id = message.split(":").pop();
      //message = message.replace(/:[0-9]+/, "");
      //if(id != websocket_id) {
        //console.log(message);
      //} 
    //}
  //}

  //setTimeout(function() {
    //websocket.send(JSON.stringify([["all"], "Message "+websocket_id+":"+websocket_id]));
  //}, 2000);
//});


//function WebSocketBox() {
  //this.connect = function(host, ports) {
    //var self = this;
    //self.sockets = new Array();

    //ports.forEach(function(port) {
      //ws = new MyWebSocket(host, port);
      //ws.bind();
      //self.sockets[port] = ws;
    //});
  //}

  //this.send = function(ports, messages) {
    //ports.forEach(function(port) {
      //for(var i = 0; i < messages; i++) {
        //self.sockets[port].send([["all"], "message"+i]);
      //}
    //});
  //}

  //this.dump = function() {
    //self = this;
    //self.sockets.forEach(function(socket) {
      //console.log(socket.port+" "+socket.count);
    //});
  //}
//}

//box = new WebSocketBox();
//box.connect('0.0.0.0', ["8080", "8081"]);
//console.log("Connected!");
//console.log(box.sockets);

//setTimeout(function() {
  //box.send(["8080"], 49)

//}, 3000);

//setTimeout(function() {
  //console.log(box.dump());
//}, 8000);


