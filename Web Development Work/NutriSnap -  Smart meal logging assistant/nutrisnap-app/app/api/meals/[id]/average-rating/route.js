import mealRepo from "@/app/repo/MealRepo";

// returns this meal's rating
export async function GET(request,{ params }) {
  try {
    const mealId = (await params).id;
    const meal = await mealRepo.getMealRatingById(mealId);
    return Response.json(meal, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.log("Error" + e);
  }
}