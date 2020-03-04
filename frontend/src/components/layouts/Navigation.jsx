import React from 'react';
import { Nav, Navbar } from 'react-bootstrap';

function Navigation() {
    return (
        <Navbar collapseOnSelect expand="sm" bg="dark" variant="dark" fixed="top">
        <Navbar.Brand href="/">HotDogCarts</Navbar.Brand>
        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
            <Navbar.Collapse id="responsive-navbar-nav">
                <Nav className="ml-auto">
                    <Nav.Link href="/">Home</Nav.Link>
                    <Nav.Link href="/login">Login</Nav.Link>
                </Nav>
            </Navbar.Collapse>
        </Navbar>
    );
}

export default Navigation;