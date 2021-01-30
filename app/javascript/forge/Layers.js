import React from 'react'
import { connect } from 'react-redux'

class Layer extends React.PureComponent {
    render() {
        const selected = this.props.selected || false
        const opacity = this.props.opacity || 100
        const { id, name, toggle, setOpacity } = this.props

        return (
            <div className="layer">
                <div className="form-check" >
                    <input type="checkbox" className="form-check-input" checked={selected} onChange={() => toggle(id)} />
                    <span className="form-check-label">{name}</span>
                </div>
                {selected && <input type="range"
                                    min={0}
                                    max={100}
                                    value={opacity}
                                    onChange={(e) => setOpacity(id, e.target.value)} />}
            </div>
        )
    }
}

class Layers extends React.PureComponent {
    render() {
        console.log(this.props)
        const { layers } = this.props
        if (!layers || !layers.length) return null

        const { toggle, setOpacity } = this.props
        return (
            <div>
                <h3>Map Layers</h3>
                {layers.map(layer => <Layer key={layer.id} {...layer} toggle={() => toggle(layer.id)} setOpacity={setOpacity} />)}
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {...state.layers}
}

const actions = {
    toggle: (id) => ({ type: 'LAYER_TOGGLE', id }),
    setOpacity: (id, opacity) => ({ type: 'LAYER_OPACITY', id, opacity })
}

const Component = connect(mapStateToProps, actions)(Layers)

export default Component