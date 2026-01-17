import mealRepo from "@/app/repo/MealRepo";

// returns meals by date logged
export async function GET(request, { params }) {
  try {
    const date = (await params).date;
    // console.log(date);
    
    const meals = await mealRepo.getMealsByDate(date);
    return Response.json(meals, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.log("Error" + e);
  }
}
