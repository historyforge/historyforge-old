import React from 'react'
import { connect } from 'react-redux'

class Layers extends React.PureComponent {
    state = { layer: null }
    render() {
        const { layers } = this.props
        if (!layers || !layers.length) return null

        return (
            <div>
                <select className="form-control" value={this.state.layer || layers[0].id} onChange={this.handleChange.bind(this)}>
                    {layers.map(layer => <option key={layer.id} value={layer.id}>{layer.name}</option>)}
                </select>
            </div>
        )
    }

    handleChange(event) {
        const value = parseInt(event.currentTarget.value)
        const layer = this.props.layers.find(l => l.id === value)
        this.setState({ layer }, () => {
            this.props.toggle(layer.id)
        })
    }
}

const mapStateToProps = state => {
    return {...state.layers}
}

const actions = {
    toggle: (id) => ({ type: 'LAYER_TOGGLE', id }),
}

const Component = connect(mapStateToProps, actions)(Layers)

export default Component
