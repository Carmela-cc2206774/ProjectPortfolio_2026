"use client";

import { useEffect, useState } from "react";
import MealCard from "./MealCard";
import {
  loadFilteredMeals,
  loadMealsAction,
  loadMealsByTagsAction,  
  loadTagsAction,
  deleteMealAction,
} from "../actions/server-actions";

export default function HomeGrid() {
  const [meals, setMeals] = useState([]);
  const [tags, setTags] = useState([]); // these are the tags that fill the dropbox
  const [filterTag, setFilterTag] = useState("All"); //is the selected value in dropbox
  const [searchQuery, setSearchQuery] = useState("");
  const [date, setDate] = useState("");

  useEffect(() => {
    async function fetchTags() {
      const loadedTags = await loadTagsAction();
      setTags(loadedTags);
    }
    fetchTags();
  }, []);

  useEffect(() => {
    fetchMeals();
  }, [filterTag, date, searchQuery]); // if filtertag changes it should re-fetch meals

  async function fetchMeals() {
    const meals = await loadFilteredMeals(filterTag, date, searchQuery);
    setMeals(meals);
  }

  async function handleDeleteMeal(id) {
    if (!confirm("Are you sure you want to delete this meal?")) return;
    await deleteMealAction(id);
    fetchMeals();
  }

  return (
    <>
      <h1>Your Smart Meal Tracker</h1>

      <div className="filters">
        <div>
         
          <label htmlFor="tags-select">Filter by tag:</label>
           {/* dropbox filtering */}
          <select
            className="tag-select"
            value={filterTag}
            onChange={(e) => setFilterTag(e.target.value)}
          >
            <option value="All">All</option>
            {/* this is the way we load the tags */}
            {tags.map((tag, i) => (
              <option key={i} value={tag}>
                {tag}
              </option>
            ))}
          </select>
        </div>

        <div>
          {" "}
          <label htmlFor="date-input">Filter by date:</label>
          <input
            className="date-input"
            type="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
          />
        </div>
      </div>

      <div className="search">
        <i className="bi bi-search"></i>
        <input
          type="text"
          className="searchBar"
          placeholder="Search your meals..."
          onChange={(e) => setSearchQuery(e.target.value)}
        />
      </div>

      <section className="meal-cards">
        {meals.map((m, i) => (
          <MealCard meal={m} key={i} handleDeleteMeal={handleDeleteMeal} />
        ))}
      </section>
    </>
  );
}
