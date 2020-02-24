import React from "react";
import "./App.css";
import "bootstrap/dist/css/bootstrap.min.css";
import Navigation from "./components/layouts/Navigation";
import Footer from "./components/layouts/Footer";
import Sidebar from "./components/layouts/Sidebar";
import Mainbar from "./components/layouts/Mainbar";

function App() {
  return (
    <div className="App">
      <Navigation />
      <Sidebar />
      <Mainbar />
      <Footer />
    </div>
  );
}
export default App;
