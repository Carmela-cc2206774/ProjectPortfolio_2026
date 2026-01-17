"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import mealRepo from "@/app/repo/MealRepo";

function removeServerActionProperty(data) {
  // this is a helper function to remove the $ACTION_ID_ prefix from the keys
  for (const key in data) {
    if (key.startsWith("$ACTION_ID_")) {
      delete data[key];
      break;
    }
  }

  return data;
}

export async function loadMealsAction() {
  const meals = await mealRepo.getMeals();
  return meals;
}

export async function loadMealsByTagsAction(tag) {
  const meals = await mealRepo.getMealsByTag(tag);
  return meals;
}

export async function loadMealsByDateAction(date) {
  const meals = await mealRepo.getMealsByDate(date);
  return meals;
}
export async function loadTagsAction() {
  const tags = await mealRepo.getTags();
  return tags;
}
export async function getMealsSummaryAction() {
    const tagSummary = await mealRepo.getMealsSummaryPerTag();
    return tagSummary;
  }
  


export async function deleteMealAction(id) {
  await mealRepo.deleteMeal(id);
}

export async function loadFilteredMeals(tag, date, query) {
  let meals = [];

  if (tag && tag !== "All" && date) {
    const mealsByTag = await mealRepo.getMealsByTag(tag);
    const mealsByDate = await mealRepo.getMealsByDate(date);
    const mealIdSet = new Set(mealsByDate.map((meal) => meal.id));
    meals = mealsByTag.filter((meal) => mealIdSet.has(meal.id));
  } else if (tag && tag !== "All") {
    meals = await mealRepo.getMealsByTag(tag);
  } else if (date && tag == "All") {
    meals = await mealRepo.getMealsByDate(date);
  } else {
    meals = await mealRepo.getMeals();
  }
  if (query && query.trim() !== "") {
    meals = meals.filter((meal) =>
      meal.title.toLowerCase().includes(query.toLowerCase())
    );
  }

  return meals;
}

export async function addUpdateMealAction(formData) {
  let meal = Object.fromEntries(formData);
  meal = removeServerActionProperty(meal);

  meal.calories = Number(meal.calories);
  meal.satisfaction = Number(meal.satisfaction);
  meal.tags = meal.tags.split(",");
  meal.userId = 1;

  if (meal.id) {
    meal.id = Number(meal.id);
    meal.userId = Number(meal.userId);
    await mealRepo.updateMeal(meal, meal.id);
    console.log("updating meal", meal.id);
  } else {
    delete meal.id;
    meal.date = new Date().toISOString();
    console.log(meal);

    await mealRepo.addMeal(meal);
    console.log("adding meal");
  }

  redirect("/");
}

export async function addSatisfactionAction(starCount, id) {
  await mealRepo.addSatisfactionRating({ rating: starCount }, id);
}
