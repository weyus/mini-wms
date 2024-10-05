import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@radix-ui/react-collapsible";
import type { FC, ReactNode, SVGProps } from "react";
import { useEffect, useState } from "react";
import type { NavLinkProps } from "react-router-dom";
import { NavLink, Outlet, useLocation } from "react-router-dom";
import ChevronDownIcon from "../assets/chevron-down-icon.svg?react";
import TavoroLogo from "../assets/tavoro-logo.svg?react";
import DashboardIcon from "../assets/dashboard-icon.svg?react";
import { twMerge } from "tailwind-merge";
import ItemsIcon from "../assets/items-icon.svg?react";
import WarehouseIcon from "../assets/warehouse-icon.svg?react";

type SidebarMenuNavLinkProps = NavLinkProps & {
  icon: FC<SVGProps<SVGSVGElement>>;
  children: ReactNode;
};

const SidebarMenuNavLink = ({
  icon: Icon,
  children,
  ...props
}: SidebarMenuNavLinkProps) => (
  <NavLink
    className={({ isActive }) =>
      twMerge(
        `flex items-center gap-3 rounded-md py-2 px-3 text-sm font-semibold`,
        isActive && "bg-blue-500 text-white"
      )
    }
    {...props}
  >
    <Icon className="h-6 w-6" />
    {children}
  </NavLink>
);

type SidebarMenuSubNavProps = Pick<SidebarMenuNavLinkProps, "icon"> & {
  heading: string;
  links: {
    to: string;
    text: string;
    props?: Omit<NavLinkProps, "to">;
  }[];
};

const SidebarMenuSubNav = ({
  icon: Icon,
  heading,
  links,
}: SidebarMenuSubNavProps) => {
  const location = useLocation();

  const activeLink = links.find((link) =>
    location.pathname.startsWith(link.to)
  );

  const [isOpen, setIsOpen] = useState(Boolean(activeLink));
  useEffect(() => setIsOpen(Boolean(activeLink)), [activeLink, location]);
  return (
    <Collapsible open={isOpen} onOpenChange={setIsOpen}>
      <CollapsibleTrigger
        className={twMerge(
          `flex w-full items-center gap-3 rounded-md py-2 px-3 font-semibold`,
          activeLink && "bg-blue-500 text-white"
        )}
      >
        <Icon className="h-6 w-6" />
        <span className="flex-1 text-left text-sm">{heading}</span>
        <ChevronDownIcon
          className={`ease-radix h-5 w-5 transition-transform duration-300 ${
            isOpen ? "rotate-180" : ""
          }`}
        />
      </CollapsibleTrigger>
      <CollapsibleContent className="data-[state=open]:animate-slideDown data-[state=closed]:animate-slideUp overflow-hidden">
        <div className="flex ">
          <ul className="mt-1 space-y-1 relative">
            <div className="absolute left-6 border-l border-l-blue-500 h-3/4 top-[15%]"></div>

            {links.map((link) => (
              <li key={link.to} className="flex items-center">
                {activeLink?.to === link.to && (
                  <div className="absolute left-[21.4px] h-1.5 w-1.5 rounded-full bg-blue-900 right-[5.2px]" />
                )}
                <NavLink
                  className={twMerge(
                    `block rounded-md py-2 pr-3 pl-12 text-xs font-regular text-blue-800`,
                    activeLink === link && "text-blue-900 font-semibold"
                  )}
                  to={link.to}
                  {...link.props}
                >
                  {link.text}
                </NavLink>
              </li>
            ))}
          </ul>
        </div>
      </CollapsibleContent>
    </Collapsible>
  );
};

export const SidebarMenu = () => {
  return (
    <>
      <aside className="bg-blue-100 fixed inset-y-0 left-0 z-10 flex w-72 flex-col text-blue-900">
        <div className="py-8 px-7 flex justify-between items-center">
          <TavoroLogo className="h-7 w-auto" />
        </div>
        <nav className="flex-1 overflow-y-auto px-4 py-6">
          <ul className="space-y-1">
            <li>
              <SidebarMenuNavLink end to={"/"} icon={DashboardIcon}>
                Dashboard
              </SidebarMenuNavLink>
            </li>
            <li>
              <SidebarMenuSubNav
                icon={WarehouseIcon}
                heading="Locations"
                links={[
                  {
                    to: "/locations",
                    text: "Manage Locations",
                  },
                ]}
              />
            </li>
            <li>
              <SidebarMenuSubNav
                icon={ItemsIcon}
                heading="Products"
                links={[
                  {
                    to: "/products/create",
                    text: "Create Product",
                  },
                  {
                    to: "/products",
                    text: "Manage Products",
                  },
                ]}
              />
            </li>
          </ul>
        </nav>
      </aside>
      <Outlet />
    </>
  );
};
