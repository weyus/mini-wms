import type { InputHTMLAttributes, LabelHTMLAttributes } from "react";
import { forwardRef } from "react";
import { twMerge } from "tailwind-merge";
import DollarIcon from "../assets/dollar-icon.svg?react";

export const Label = ({
  className = "",
  children,
  ...props
}: LabelHTMLAttributes<HTMLLabelElement>) => (
  <label
    className={twMerge(
      `flex flex-col gap-1.5 text-sm font-medium text-gray-700`,
      className
    )}
    {...props}
  >
    {children}
  </label>
);

export const Input = forwardRef<
  HTMLInputElement,
  InputHTMLAttributes<HTMLInputElement>
>(function Input({ className = "", ...props }, ref) {
  return (
    <input
      className={twMerge(
        "shadow-xs text-md font-regular block w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 placeholder-gray-500 focus:ring-inset disabled:bg-gray-50 disabled:text-gray-500",
        className
      )}
      ref={ref}
      type="text"
      {...props}
    />
  );
});

export const CurrencyInput = forwardRef<
  HTMLInputElement,
  InputHTMLAttributes<HTMLInputElement>
>(function CurrencyInput({ className = "", ...props }, ref) {
  return (
    <span className="relative">
      <input
        type="number"
        step="any"
        className={twMerge(
          "shadow-xs text-md font-regular block w-full rounded-lg border border-gray-300 py-2 pl-9 pr-3 text-gray-900 placeholder-gray-500 focus:ring-inset",
          " disabled:bg-gray-50 disabled:text-gray-500",
          className
        )}
        ref={ref}
        {...props}
      />
      <span className="absolute top-0 ml-2 pt-2.5 text-gray-500">
        <DollarIcon className="h-5 w-5" />
      </span>
    </span>
  );
});
