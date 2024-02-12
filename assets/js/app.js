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
    var divRect = this.el.getBoundingClientRect()

    var path = document.createElementNS("http://www.w3.org/2000/svg", "path")

    path.setAttribute('id', 'solPath')
    var path_members = this.el.querySelectorAll("[path-index]")
    const centres = Array(path_members.length)
    var pathString = ""
    for (var i = 0; i < path_members.length; i++) {
      let item = path_members[i]
      let path_index = item.getAttribute("path-index")
      let rect = item.getBoundingClientRect()
      let x = rect.x + (rect.width / 2.0)
      let y = rect.y + (rect.height / 2.0)

      centres[path_index] = {
        x: x,
        y: y
      }
      if (i == 0) {
        pathString = `M ${x} ${y}`
      } else {
        pathString += ` L ${x} ${y}`
      }
    }

    path.setAttribute('d', `${pathString} z`)
    path.setAttribute('stroke', 'red')
    path.setAttribute('stroke-linecap', 'round')
    path.setAttribute('stroke-linejoin', 'round')
    path.setAttribute('stroke-width', '20')
    path.setAttribute('fill-opacity', '0')

    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg")
    svg.setAttribute("width", divRect.width)
    svg.setAttribute("height", divRect.height)
    svg.setAttribute("class", "")
    svg.appendChild(path)
    this.el.appendChild(svg)
    console.info(`Final array ${JSON.stringify(centres, undefined, 2)}`)
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

