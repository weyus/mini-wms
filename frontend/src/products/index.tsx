import { WMSLayout } from "../components/wms-layout";
import { Table, TableCell, TableRow } from "../components/table";

export const Products = () => {
  return (
    <WMSLayout title="Products">
      <Table headers={["Name", "SKU", "Price"]}>
        <TableRow>
          <TableCell>Product 1</TableCell>
          <TableCell>PROD-1</TableCell>
          <TableCell>$1.23</TableCell>
        </TableRow>
        <TableRow>
          <TableCell>Product 2</TableCell>
          <TableCell>PROD-2</TableCell>
          <TableCell>$2.34</TableCell>
        </TableRow>
      </Table>
    </WMSLayout>
  );
};
