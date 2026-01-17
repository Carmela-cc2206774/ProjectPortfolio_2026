import mealRepo from "@/app/repo/MealRepo";

// returns all meals
export async function GET(request) {
  try {
    const meals = await mealRepo.getMeals();
    return Response.json(meals, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.log("Error" + e);
  }
}

// adds a new meal
export async function POST(request) {
  try {
    const meal = await request.json();
    const newMeal = await mealRepo.addMeal(meal);
    return Response.json(newMeal, { status: 201 });
  } catch (e) {
    return Response.json({ error: e.message }, { status: 400 });
  }
}
