"use client";
import { addUpdateMealAction } from "@/app/actions/server-actions";
import { useSearchParams } from "next/navigation";
import React from "react";

export default function AddUpdateMeal() {
  const searchParams = useSearchParams();
  const meal = Object.fromEntries(searchParams);

  return (
    <>
      <h1 id="page-title">{!meal.id ? "Add Meal" : "Edit Meal"} </h1>
      <form className="meal-form" action={addUpdateMealAction}>
        <input type="hidden" name="id" id="meal-id" defaultValue={meal.id} />
        <input
          type="text"
          name="title"
          id="title"
          placeholder="Meal Title"
          required
          defaultValue={meal.title}
        />
        <input
          type="text"
          id="tags"
          name="tags"
          placeholder="Tags (comma-separated)"
          defaultValue={meal.tags}
          required
        />
        <input
          type="number"
          id="calories"
          name="calories"
          placeholder="Calories"
          defaultValue={meal.calories}
          required
        />
        <textarea
          id="description"
          name="description"
          placeholder="Meal Description"
          defaultValue={meal.description}
          required
        ></textarea>
        <input
          type="number"
          id="satisfaction"
          name="satisfaction"
          placeholder="Satisfaction (1-5)"
          min="1"
          max="5"
          defaultValue={meal.satisfaction}
          required
        />
        <input
          type="url"
          id="image"
          name="image"
          placeholder="Image URL"
          defaultValue={meal.image}
          required
        />
        <button className={"card-button add"} type="submit">
          Save Meal
        </button>
      </form>
    </>
  );
}
