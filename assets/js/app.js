// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}

// Only allow A-Z and underscores for custom grids
Hooks.LettersAndUnderscores = {
  mounted() {
    var regex = new RegExp("[^A-Z_]", 'g')
    this.el.addEventListener("input", _e => {
      this.el.value = this.el.value.replace(regex, "")
    })
  }
}

// get the centres of letters in the solution path, in order
Hooks.DrawGridPath = {
  updated() {
    // make the canvas the same size as the div
    const divRect = this.el.getBoundingClientRect()
    const canvas = document.getElementById("grid-overlay")
    canvas.width = divRect.width
    canvas.height = divRect.height

    let style = "red"
    const lineWidth = 24
    const startCircle = 32

    // let's draw a line
    const ctx = canvas.getContext("2d")
    ctx.beginPath()
    ctx.strokeStyle = style
    ctx.lineCap = "round"
    ctx.lineJoin = "round"


    // get all the letters that are on the solution path and sort by their path index
    let path_members = Array.from(this.el.querySelectorAll("[path-index]"))
    path_members.sort((a, b) => Number(a.getAttribute("path-index")) - Number(b.getAttribute("path-index")))

    // now create a path between the centres of each letter on the path, in order
    // TODO could change to `for..in` with a marker for first letter, no index
    for (let i = 0; i < path_members.length; i++) {
      let item = path_members[i]
      let rect = item.getBoundingClientRect()
      let x = rect.x - divRect.x + (rect.width / 2.0)
      let y = rect.y - divRect.y + (rect.height / 2.0)

      if (i == 0) {
        ctx.arc(x, y, startCircle, 0, 2 * Math.PI)
        ctx.fillStyle = style
        ctx.fill()
        ctx.beginPath()
        ctx.lineWidth = lineWidth
        ctx.moveTo(x, y)
      } else {
        ctx.lineTo(x, y)
      }
    }

    // and draw it
    ctx.stroke()
  }
}

let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())


// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

