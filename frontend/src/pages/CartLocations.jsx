import React, { useState } from 'react';
import { Container } from 'react-bootstrap';
import { GoogleMap, withScriptjs, withGoogleMap, Marker, InfoWindow } from 'react-google-maps';
import cartInfo from '../data/cartInfo';
import Sidebar from '../components/layouts/Sidebar';

const styleMapDiv = {
    height: '80vh',
    marginBottom: '2rem',
    marginTop: '4.6875rem',
    textAlign: 'center',
    justifyContent: 'center',
    
}
const styleContainer = {
    height: 'calc(98vh - 56px - 56px)',
    
}

const styleInfoWinTitle = {
    color: '#555',
    fontWeight: 'bold',
    

}

const styleInfoWinAddress = {
    fontFamily: 'Arial',
    fontWeight: 'bold',
    
}

const styleInfoWinHours = {
    fontFamily: 'Arial',
    fontWeight: 'bold',
    
}

const styleInfoWinPhone = {
    fontFamily: 'Arial',
    fontWeight: 'bold',
    
}

const styleInfoWinButton = {
    fontWeight: 'bold',
    
}

function Map() {
    const [ selectedCart, setSelectedCart ] = useState(null)
    return (
        <GoogleMap 
            defaultZoom = {16}
            defaultCenter = {{ lat: 47.609388, lng: -122.335319 }}
        >
        {cartInfo.map(cart => (
            <Marker 
                key={cart.id}
                position={{ 
                    lat: cart.coordinates[0],
                    lng: cart.coordinates[1] 
                }}
                onClick={() => {
                    setSelectedCart(cart);
                }}
            />
        ))}

        { selectedCart && (
            <InfoWindow
                position={{
                    lat: selectedCart.coordinates[0],
                    lng: selectedCart.coordinates[1] 
                }}
                onCloseClick={() => {
                    setSelectedCart(null);
                }}
            >
                <div>
                    <h3 style={ styleInfoWinTitle }>{selectedCart.title}</h3>
                    <p style={ styleInfoWinAddress }>{selectedCart.address}</p>
                    <p style={ styleInfoWinHours }>{selectedCart.hours}</p>
                    <p style={ styleInfoWinPhone }>{selectedCart.phone}</p>
                    <a href="/menu" className='btn btn-sm btn-outline-warning' style={ styleInfoWinButton }>View Menu</a>
                </div>
            </InfoWindow>
        )}
        </ GoogleMap>
    )
}

const WrappedMap = withScriptjs(withGoogleMap(Map));

const CartLocations = () => (
    <Container fluid style={ styleContainer }>
        <Sidebar />
        <div style={ styleMapDiv }>
            <WrappedMap 
                googleMapURL = {`https://maps.googleapis.com/maps/api/js?key=AIzaSyDEsKpLXZJY-Ch3s_UN152D7btqc7HOocQ`} 
                loadingElement = {<div style={{ height: "100%" }} />}
                containerElement = {<div style={{ height: '100%' }} />}
                mapElement = {<div style={{ height: '100%' }} />}
            />
        </div>
    </Container>
)

export default CartLocations;