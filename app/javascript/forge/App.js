import React from 'react'
import Layers from "./Layers"
import Map from './Map'
import Search from './Search'
import Building from './Building'
import ErrorBoundary from "./ErrorBoundary";

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
            <ErrorBoundary>
                <Provider store={store}>
                    <div className={'map-wrap'}>
                        <Map />
                        <div id={'forge-right-col'}>
                            <Layers />
                            <Search />
                            <Building />
                        </div>
                    </div>
                </Provider>
            </ErrorBoundary>
        )
    }

    get map() {
        return this.mapRef.current.state.map
    }
}
