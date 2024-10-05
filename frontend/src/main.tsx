import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import "./index.css";
import { WMSLayout } from "./components/wms-layout";
import { SidebarMenu } from "./components/sidebar-menu";
import { Products } from "./products";
import { Locations } from "./locations";
import { CreateProduct } from "./products/create";

const Home = () => {
  return <WMSLayout title="Home">Let's build our Mini-WMS!</WMSLayout>;
};

const router = createBrowserRouter([
  {
    path: "/",
    element: <SidebarMenu />,
    children: [
      {
        path: "/",
        element: <Home />,
      },
      {
        path: "/products",
        element: <Products />,
      },
      {
        path: "/products/create",
        element: <CreateProduct />,
      },
      {
        path: "/locations",
        element: <Locations />,
      },
    ],
  },
]);

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);
