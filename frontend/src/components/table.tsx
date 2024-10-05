import type { HTMLAttributes, ReactNode, TdHTMLAttributes } from "react";
import { Children } from "react";
import { twMerge } from "tailwind-merge";

type TableHeaderProps = {
  children: ReactNode;
  className?: string;
};

export const TableHeader = ({ children, className = "" }: TableHeaderProps) => (
  <th className={`whitespace-nowrap p-3 font-medium ${className}`}>
    {children}
  </th>
);

type TableProps = {
  headers: ReactNode[];
  children: ReactNode;
  className?: string;
  footer?: ReactNode;
  emptyAction?: ReactNode;
  emptyState?: ReactNode;
  isLoading?: boolean;
};

export const Table = ({
  headers,
  children,
  footer,
  emptyAction,
  emptyState,
  className,
  isLoading,
}: TableProps) => {
  const isEmpty = Children.count(children) === 0;

  return (
    <>
      <div
        className={twMerge(
          `overflow-x-auto rounded-lg border border-gray-200 text-left text-sm text-gray-700 shadow-sm`,
          isLoading && "opacity-50",
          className
        )}
      >
        <table className="relative z-0 w-full table-auto">
          <thead className="sticky top-0 z-10">
            <tr className="bg-gray-50">
              {headers.map((header, idx) => {
                return <TableHeader key={idx}>{header}</TableHeader>;
              })}
            </tr>
          </thead>
          <tbody className="bg-white">{children}</tbody>
        </table>
        {!isEmpty && footer && (
          <div className="border-t border-gray-200 p-3">{footer}</div>
        )}
      </div>
      {isEmpty && !isLoading && (
        <div className="-mt-2 py-12 border-b border-x rounded-b-lg shadow-sm">
          {emptyState ?? <TableEmptyState action={emptyAction} />}
        </div>
      )}
    </>
  );
};

export const TableRow = ({
  className = "",
  ...props
}: HTMLAttributes<HTMLTableRowElement>) => (
  <tr className={`border-t border-gray-200 ${className}`} {...props} />
);

export const TableCell = ({
  className = "",
  ...props
}: TdHTMLAttributes<HTMLTableCellElement>) => (
  <td className={`whitespace-nowrap px-3 py-4 ${className}`} {...props} />
);

export const TableEmptyState = ({
  action,
  icon,
  title,
}: {
  action?: ReactNode;
  icon?: ReactNode;
  title?: ReactNode;
}) => (
  <div className="flex flex-col items-center">
    {icon}
    <div className="max-w-md pt-4 text-center">
      <h3 className="font-medium text-gray-900">
        {title ?? "Nothing to show for now"}
      </h3>
    </div>
    <div className="pt-6">{action}</div>
  </div>
);

export const TableTextWrappedInner = ({
  children,
}: {
  children: ReactNode;
}) => <div className="min-w-[250px] whitespace-pre-wrap">{children}</div>;
