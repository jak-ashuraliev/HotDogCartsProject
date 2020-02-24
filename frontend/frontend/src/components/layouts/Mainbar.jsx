import React from "react";
import vendordata from "../data/vendor";
const styleMainbar = {
  width: "75vw",
  backgroungColor: "#333",
  border: "1px solid black",
  padding: "5rem",
  float: "right",
  marginRight: "0rem",
  marginBottom: "0rem",
  borderRadius: ".7rem"
};
const styleLinks = {
  fontSize: "20px"
};
function Mainbar() {
  return (
    <div style={styleMainbar}>
      <h4>VENDOR</h4>
      <hr />
      {vendordata.map(vendor => (
        <div style={{ fontSize: "14px" }}>
          <p style={{ marginBottom: ".5rem" }}>
            {vendor.Name}
            {vendor.firstName}
            {vendor.lastName}
            {vendor.phone}
            {vendor.email}
            {vendor.data}
          </p>
          <hr />
        </div>
      ))}
    </div>
  );
}
export default Mainbar;
