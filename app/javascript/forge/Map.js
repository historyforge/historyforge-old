import React from 'react'
import {GoogleMap, withGoogleMap, Marker} from "react-google-maps";
import MarkerClusterer from "react-google-maps/lib/components/addons/MarkerClusterer"
import {connect} from "react-redux";

const MapComponent = withGoogleMap((props) => props.children)

class Map extends React.PureComponent {
    mapRef = React.createRef()
    mapOptions = {
        disableDefaultUI: true,
        gestureHandling: 'cooperative',
        zoomControl: true,
        mapTypeControl: true,
        mapTypeControlOptions: {
            mapTypeIds: [ google.maps.MapTypeId.ROADMAP, google.maps.MapTypeId.SATELLITE ],
            style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
            position: google.maps.ControlPosition.BOTTOM_LEFT,
        },
        streetViewControl: true,
        styles: [{ featureType: 'poi', elementType: 'labels', stylers: [{ visibility: 'off' }]}]
    }

    render() {
        const { buildings } = this.props
        return (
            <MapComponent
                containerElement={<div id={'map-wrapper'} />}
                mapElement={<div id={'map'} />}>
                <GoogleMap
                    ref={this.mapRef}
                    options={this.mapOptions}
                    defaultCenter={{lat: window.mapCenter[0], lng: window.mapCenter[1]}}
                    defaultZoom={14}>
                    { buildings && (
                        <MarkerClusterer
                            averageCenter
                            enableRetinaIcons
                            gridSize={60}>
                            {buildings.map(building => <Marker key={building.id} position={{ lat: building.lat, lng: building.lon }} />)}
                        </MarkerClusterer>
                    )}
                </GoogleMap>
            </MapComponent>
        )
    }

    componentDidMount() {
        this.props.load(this.props.params)
    }


    get map() {
        return this.mapRef.current.state.map
    }
}


const mapStateToProps = state => {
    return {...state.layers, ...state.buildings, ...state.search}
}

const actions = {
    load: (params) => ({ type: 'BUILDING_LOAD', params }),
    select: (id) => ({ type: 'BUILDING_SELECT', id })
}

const Component = connect(mapStateToProps, actions)(Map)

export default Component
