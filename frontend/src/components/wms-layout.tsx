import type { ReactNode } from "react";
import { useEffect, useRef, useState } from "react";

type Props = {
  title: string;
  afterTitle?: ReactNode;
  crumbs?: string[];
  subTitle?: ReactNode;
  children: ReactNode;
};

export const WMSLayout = ({ title, afterTitle, subTitle, children }: Props) => {
  useEffect(() => {
    document.title = title;
  }, [title]);

  return (
    <div className="pl-72 h-full flex flex-col">
      <header className="flex flex-col gap-2 border-b border-gray-200 px-8 py-4">
        <div className="flex items-center justify-between gap-4">
          <h1 className="text-display-xs font-bold text-gray-900">{title}</h1>
          {afterTitle}
        </div>
        {subTitle}
      </header>
      <main className="px-8 py-4 flex flex-col flex-1">{children}</main>
    </div>
  );
};

type WMSSectionProps = {
  title: ReactNode;
  children: ReactNode;
};

export const WMSSection = ({ title, children }: WMSSectionProps) => {
  return (
    <>
      <h2 className="basis-3/12 text-lg font-medium text-gray-900">{title}</h2>
      <div className="flex basis-1/2 flex-col gap-3">{children}</div>
    </>
  );
};

type StickyBottomProps = {
  children: ReactNode;
};

export const StickyBottom = ({ children }: StickyBottomProps) => {
  const ref = useRef<HTMLDivElement>(null);
  const [height, setHeight] = useState(0);
  useEffect(() => {
    setHeight(ref.current?.offsetHeight ?? 0);
  }, []);

  return (
    <>
      <div style={{ marginTop: height + 8 * 4 }} />
      <div ref={ref} className="fixed bottom-8 left-72 right-0 bg-white">
        <div className="mx-8">
          <div className="-mx-8 my-8 h-px bg-gray-200" />
          {children}
        </div>
        <div className="relative">
          <div className="absolute h-8 w-full bg-white"></div>
        </div>
      </div>
    </>
  );
};
