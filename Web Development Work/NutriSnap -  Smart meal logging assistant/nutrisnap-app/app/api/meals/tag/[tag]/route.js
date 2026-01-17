import mealRepo from "@/app/repo/MealRepo";

// returns meals by tag
export async function GET(request, { params }) {
  try {
    const tag = (await params).tag;
    const meals = await mealRepo.getMealsByTag(tag);
    return Response.json(meals, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.log("Error" + e);
  }
}
