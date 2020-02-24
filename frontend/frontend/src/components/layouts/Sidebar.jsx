import React from "react";
import vendordata from "../data/vendor";
const styleSidebar = {
  width: "25vw",
  backgroungColor: "#333",
  //border: "1px solid black",
  padding: "5rem",
  float: "left",
  marginRight: "0rem",
  marginBottom: "0rem",
  borderRadius: "0rem"
};
const styleLinks = {
  fontSize: "20px",
  color: "gray"
};
function Sidebar() {
  return (
    <div style={styleSidebar}>
      <h4>VENDOR</h4>
      <hr />
      {/* {vendordata.map(vendor => (
        <div style={{ fontSize: "14px" }}>
          <p style={{ marginBottom: ".5rem" }}>VENDOR LIST</p>
          <hr />
        </div>
      ))} */}
      <div style={styleLinks}>
        <a href="/VendorList">Vendor List</a>
        <br></br>
        <a href="/AddCart">Add Cart</a>
        <br></br>
        <a href="/RemoveCart">Remove Cart</a>
        <br></br>
        <a href="/vendorlist">Incoming Order</a>
        <br></br>
        <a href="/vendorlist">Menu Item</a>
        <br></br>
        <a href="/vendorlist">Cart Location</a>
      </div>
    </div>
  );
}
export default Sidebar;
