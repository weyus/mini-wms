import { Table, TableCell, TableRow } from "../components/table";
import { WMSLayout } from "../components/wms-layout";

export const Locations = () => {
  return (
    <WMSLayout title="Locations">
      <Table headers={["Name"]}>
        <TableRow>
          <TableCell>Location 1</TableCell>
        </TableRow>
        <TableRow>
          <TableCell>Location 2</TableCell>
        </TableRow>
      </Table>
    </WMSLayout>
  );
};
