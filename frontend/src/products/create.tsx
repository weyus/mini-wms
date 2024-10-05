import { StickyBottom, WMSLayout, WMSSection } from "../components/wms-layout";
import { CurrencyInput, Label, Input } from "../components/input";
import { PrimaryButton, SecondaryGrayButton } from "../components/button";

export const CreateProduct = () => {
  return (
    <WMSLayout title="Create Product">
      <form className="flex flex-wrap gap-8">
        <WMSSection title="Details">
          <Label>
            Name
            <Input />
          </Label>
          <Label>
            SKU
            <Input />
          </Label>
          <Label>
            Price
            <CurrencyInput />
          </Label>
        </WMSSection>
      </form>
      <StickyBottom>
        <div className="flex justify-between">
          <SecondaryGrayButton>Cancel</SecondaryGrayButton>
          <PrimaryButton>Create Product</PrimaryButton>
        </div>
      </StickyBottom>
    </WMSLayout>
  );
};
