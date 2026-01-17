"use client";
import Link from "next/link";
import { useState } from "react";
import { addSatisfactionAction } from "../actions/server-actions";

export default function MealCard({ meal, key, handleDeleteMeal }) {
  const [showDesc, setShowDesc] = useState(true);
  const [starSatisfaction, setSatisfaction] = useState(meal.satisfaction);

  async function handleStarClick(index) {
    index++;
    await addSatisfactionAction(index, meal.id);
    setSatisfaction(index);
  }

  return (
    <article className="meal-card" key={key}>
      <figure>
        <img src={meal.image} alt="" />
      </figure>

      <div className="meal-info">
        <div className="text">
          <h5>{meal.title}</h5>
          <p>
            <span className="meal-subtitle">Date:</span>
            {meal.date.replace("T", " - ").replace("Z", "")}
          </p>
          <p>
            <span className="meal-subtitle">Tags:</span>
            {meal.tags.map((t, i) => (
              <span key={i} className="meal-tags">
                {t.trim()}
              </span>
            ))}
          </p>
          <p>
            <span className="meal-subtitle">Calories:</span> {meal.calories}
            kcal
          </p>
          <p>
            <span className="meal-subtitle">Satisfaction:</span>
            {[...Array(5)].map((n, i) => (
              <i
                key={i}
                onClick={() => handleStarClick(i)}
                className={`stars bi ${
                  i < starSatisfaction ? "bi-star-fill" : "bi-star"
                }`}
              ></i>
            ))}
            {/* {"★".repeat(meal.satisfaction)}
          {"☆".repeat(5 - meal.satisfaction)} */}
          </p>

          <p className="meal-desc" hidden={showDesc}>
            {meal.description}
          </p>
        </div>

        <div className="buttons">
          <button
            className="card-button desc"
            onClick={() => setShowDesc(!showDesc)}
          >
            <p>Show Description</p>
          </button>
          <div className="buttons-row">
            <Link
              className="upd-link"
              href={{
                pathname: "/addUpdate",
                query: { ...meal, tags: meal.tags.join(",") },
              }}
            >
              <button className="card-button edit upd">
                <i className="bi bi-pen"></i> <p>Update</p>
              </button>
            </Link>
            <button
              className="card-button edit del"
              onClick={() => {
                console.log("Deleting meal:", meal); // Log full meal object
                handleDeleteMeal(Number(meal.id));
              }}
            >
              <i className="bi bi-trash3"></i> <p>Delete</p>
            </button>
          </div>
        </div>
      </div>
    </article>
  );
}
