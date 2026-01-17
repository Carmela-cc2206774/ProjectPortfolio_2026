import mealRepo from "@/app/repo/MealRepo";

// returns all meals
export async function GET(request) {
  try {
    const mealsumarry = await mealRepo.getMealsSummaryPerTag();
    return Response.json(mealsumarry, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.log("Error" + e);
  }
}
