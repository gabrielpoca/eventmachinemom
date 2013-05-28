console.log("Loaded");
// in fallback mode: connect returns a dummy object implementing the WebSocket interface
var ws = $.gracefulWebSocket("ws://0.0.0.0:8080"); // the ws-protocol will automatically be changed to http
  // in fallback mode: sends message to server using HTTP POST
//ws.send("same message to server, this time send using a POST request");
  // in fallback mode: listens for messages by polling the server using HTTP GET
ws.onopen = function (event) {
  console.log(event);
}
ws.onmessage = function (event) {
  console.log(event);
};
