import React from 'react';
import FavoriteCarts from '../../data/favorite-carts';

const styleSidebar = {
    width: '235px',
    backgroungColor: '#333',
    border: '1px solid #f4aa1b',
    padding: '1rem',
    float: 'left',
    marginRight: '1rem',
    marginBottom: '1rem',
    // borderRadius: '.3rem'
}

function Sidebar () {
    return (
        <div style={ styleSidebar }>
            <h4>Favorite Locations</h4>
            <hr/>
            { FavoriteCarts.map(carts => 
                <div style ={{ fontSize: '14px' }}>
                    <h6 style={{ marginBottom: '.5rem' }}>{ carts.title }</h6>
                    <p style={{ marginBottom: '.5rem' }}>{ carts.address }</p>
                    <a className="btn btn-sm btn-warning" href="/menu">View Menu</a>
                    <hr/>
                </div>
            )}
        </div>
    )
}

export default Sidebar;
