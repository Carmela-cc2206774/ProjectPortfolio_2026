import mealRepo from "@/app/repo/MealRepo";

// returns a meal by id
export async function GET(request, { params }) {
  try {
    const mealId = (await params).id;
    const meal = await mealRepo.getMealById(mealId);
    return Response.json(meal, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.log("Error" + e);
  }
}


// updates/replaces this meal
export async function PUT(request, { params }) {
  // body must have full meal object
  try {
    const mealId = Number((await params).id);
    const meal = await request.json();
    const updatedMeal = await mealRepo.updateMeal(meal, mealId);
    return Response.json(updatedMeal, { status: 201 });
  } catch (e) {
    return Response.json({ error: e.message }, { status: 400 });
  }}

  // deletes meal
export async function DELETE(request, { params }) {
  const mealId = (await params).id;
  const deleteMessage = await mealRepo.deleteMeal(mealId);
  return Response.json(deleteMessage, { status: 200 });
}