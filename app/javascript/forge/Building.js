import React from 'react'
import {connect} from "react-redux";

class Building extends React.PureComponent {
    render() {
        if (this.props.attributes) {
            const building = this.props.attributes
            return (
                <div id="building-details">
                    <h3>Building Details</h3>
                    <h5>
                        <a href={`/buildings/${ building.id }`} target="_blank"
                           title="Open building record in new tab">
                            <u>{building.street_address}</u>
                            <i className="fa fa-external-link" />
                        </a>
                    </h5>
                    {building.photo && (
                        <div>
                            <picture>
                                <source srcSet={`/photos/${building.photo}/15/phone.jpg`}
                                        media="(max-width:480px)"/>
                                <source srcSet={`/photos/${building.photo}/15/tablet.jpg`}
                                        media="(min-width:481px) and (max-width:1024px)"/>
                                <source srcSet={`/photos/${building.photo}/15/desktop.jpg`}
                                        media="(min-width:1025px)"/>
                                <img className="img-responsive img-thumbnail" alt="Building photo" />
                            </picture>
                        </div>
                    )}
                    <div>
                        <table className="table table-condensed">
                            <thead>
                            <tr>
                                <th>Year</th>
                                <th>Name</th>
                                <th>Age</th>
                                <th>Race</th>
                                <th>Sex</th>
                            </tr>
                            </thead>
                            {[1900, 1910, 1920, 1930, 1940].map(year => (
                                <tbody key={year}>
                                {building.census_records[year].map(person => (
                                    <tr key={person.id}>
                                        <td>{year}</td>
                                        <td><a href={`/census/${year}/${person.id}`} target="_blank">{person.name}</a></td>
                                        <td>{person.age}</td>
                                        <td>{person.race}</td>
                                        <td>{person.sex}</td>
                                    </tr>
                                ))}
                                </tbody>
                            ))}
                        </table>
                    </div>
                </div>
        )
        } else {
            return <p className="alert alert-info">Click on a dot to see who lived there.</p>
        }
    }
}

const mapStateToProps = state => {
    if (state.buildings.building) {
        return {...state.buildings.building}
    } else {
        return {}
    }
}

const actions = {
}

const Component = connect(mapStateToProps, actions)(Building)

export default Component
