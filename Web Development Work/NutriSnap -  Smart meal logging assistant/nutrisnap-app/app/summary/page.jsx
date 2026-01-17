

import SummaryTable from "../components/SummaryTable";


export default async function Summary() {
  return (
    <>
      <h1>Meal Summary</h1>
      <p>Summary of meals grouped by tags.</p>
      <SummaryTable></SummaryTable>

    </>
  );
}
