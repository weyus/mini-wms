import type { ButtonHTMLAttributes } from "react";
import { forwardRef } from "react";
import { twMerge } from "tailwind-merge";

export type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement>;

type AdditionalButtonProps = ButtonProps & {
  display?: "block" | "inline";
  size?: "sm" | "md";
};

export const PrimaryButton = forwardRef<
  HTMLButtonElement,
  AdditionalButtonProps
>(function PrimaryButton(
  { display = "inline", size = "md", className = "", ...props },
  ref
) {
  return (
    <button
      className={`shadow-xs items-center justify-center gap-2 rounded-lg text-sm font-medium text-white ${
        display === "block" ? "flex w-full" : "inline-flex"
      } ${size === "sm" ? "py-2 px-3.5" : "py-2.5 px-4"} ${
        props.disabled ? "bg-blue-200" : "bg-blue-500"
      } ${className}`}
      ref={ref}
      type="button"
      {...props}
    />
  );
});

export const SecondaryGrayButton = forwardRef<
  HTMLButtonElement,
  AdditionalButtonProps
>(function SecondaryGrayButton(
  { display = "inline", size = "md", className = "", ...props },
  ref
) {
  return (
    <button
      className={twMerge(
        `shadow-xs items-center justify-center gap-2 rounded-lg border text-sm font-medium`,
        display === "block" ? "flex w-full" : "inline-flex",
        size === "sm" ? "py-2 px-3.5" : "py-2.5 px-4",
        props.disabled
          ? "border-gray-200 text-gray-300"
          : "border-gray-300 text-gray-700",
        className
      )}
      ref={ref}
      type="button"
      {...props}
    />
  );
});
