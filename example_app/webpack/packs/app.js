import React, { Component } from 'react'
import ReactDOM from 'react-dom'

class Hello extends Component {
  render () {
    return <div>Hello, World!</div>
  }
}

ReactDOM.render(<Hello/>, document.querySelector('body').appendChild(document.createElement('span')))
