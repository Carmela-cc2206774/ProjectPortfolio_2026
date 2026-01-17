import mealRepo from "@/app/repo/MealRepo";

// adds a satisfaction rating 1-5 (must have it in body)
export async function POST(request, { params }) {
  try {
    const mealId = (await params).id;
    const rating = await request.json();
    const newMeal = await mealRepo.addSatisfactionRating(rating, mealId);
    return Response.json(newMeal, { status: 201 });
  } catch (e) {
    return Response.json({ error: e.message }, { status: 400 });
  }
}

/* 
{
"id":1,
"userId":1",
title":"Grilled Chicken Salad",
"tags":["high-protein","lunch"],
"calories":450,
"description":"Grilled chicken breast with lettuce, cherry tomatoes, and light dressing.",
"satisfaction":4,
"date":"2025-04-15T12:00:00Z",
"image":"https://www.maebells.com/wp-content/uploads/2024/06/Grilled-Chicken-Caesar-Salad-14.jpg"
}
*/
