"use client";

import { getMealsSummaryAction } from "../actions/server-actions";
import { useEffect, useState } from "react";

export default function SummaryTable() {
  const [tagSummary, setTagSummary] = useState([]);

  useEffect(() => {
    async function fetchTagSummary() {
      const loadedTagSummary = await getMealsSummaryAction();
      setTagSummary(loadedTagSummary);
    }
    fetchTagSummary();
  }, []);

  return (
    <>
      <table class="summary-table">
        <thead>
          <tr>
            <th>Tag</th>
            <th>Total Meals</th>
            <th>Avg Satisfaction</th>
          </tr>
        </thead>
        <tbody id="summary-body">
          {tagSummary.map((t, i) => {
            return (
              <tr key={i}>
                <td>#{t.tag}</td>
                <td>{t.totalMeals}</td>
                <td>
                  <i class="star bi bi-star-fill"></i>
                  {t.averageSatisfaction.toFixed(1)}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </>
  );
}
