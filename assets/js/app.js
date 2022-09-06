import "../css/app.css"

import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"

let liveSocket = new LiveSocket("/live", Socket, {params: {token: window.userToken}})

// Connect if there are any LiveViews on the page
liveSocket.connect()
window.liveSocket = liveSocket
