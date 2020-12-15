import React from 'react'
import Layers from "./Layers"
import Map from './Map'
import Building from './Building'

import { createLogger } from 'redux-logger'
import { createStore, applyMiddleware, combineReducers } from 'redux'
import { Provider } from 'react-redux'
import { layers, buildings, buildingTypes, search } from "./reducers"
import { forgeMiddleware } from "./middlewares";

const loggerMiddleware = createLogger({collapsed: true})
const reducers = combineReducers({ layers, buildings, buildingTypes, search })
const store = createStore(reducers, window.initialState, applyMiddleware(loggerMiddleware, forgeMiddleware))

export default class App extends React.PureComponent {
    mapRef = React.createRef()
    render() {
        return (
            <Provider store={store}>
                <div className={'map-wrap'}>
                    <Map />
                    <div id={'forge-right-col'}>
                        <Layers />
                        <Building />
                    </div>
                </div>
            </Provider>
        )
    }

    get map() {
        return this.mapRef.current.state.map
    }
}
