import path from "path";
import fs from "fs-extra";
import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient(); // remember to make the tags back into an array since you have them in db as string

class MealRepo {
  constructor() {
    this.filePath = path.join(process.cwd(), "app/data/meals.json");
  }
  // ========= GET METHODS ===============================================================

  async getMeals() {
    // returns a list of all meals
    const meals = (await prisma.meal.findMany()).map((m) => ({
      ...m,
      tags: m.tags.split(","),
    }));

    return meals;
  }

  async getMealById(id) {
    // returns a specific meal
    const m = await prisma.meal.findUnique({ where: { id: Number(id) } });
    if (!m) return "Meal Does Not Exist.";
    return {
      ...m,
      tags: m.tags.split(","),
    };
  }

  async getMealsByTag(tag) {
    // returns meals with this tag
    const meals = await this.getMeals();
    return meals.filter((meal) => meal.tags.includes(tag));
  }

  async getMealsByDate(date) {
    // returns meals logged on specific date YYYY-MM-DD

    return (await this.getMeals()).filter(
      (meal) => new Date(meal.date).toISOString().split("T")[0] === date
    );
  }

  async getMealRatingById(id) {
    // returns this specific meal's rating
    return (await this.getMealById(id)).satisfaction;
  }

  async getTags() {
    const meals = await this.getMeals();
    return Array.from(new Set(meals.flatMap((meal) => meal.tags)));
  }

  async getMealsSummaryPerTag() {
    // returns total and avgRating per tag
    const tags = await this.getTags();

    return await Promise.all(
      tags.map(async (tag) => {
        const mealsByTag = await this.getMealsByTag(tag);
        const total = mealsByTag.length;
        return {
          tag,
          totalMeals: total,
          averageSatisfaction:
            mealsByTag.reduce((sum, meal) => sum + meal.satisfaction, 0) /
            total,
        };
      })
    );
  }

  // ========= POST METHODS =============================================================

  async addMeal(meal) {
    const valid = this.isMealValid(meal);
    if (valid !== null) {
      throw new Error(valid);
    }
    meal.tags = meal.tags.join(",");
    return await prisma.meal.create({ data: meal });
  }

  async addSatisfactionRating({ rating }, mealId) {
    const id = Number(mealId);
    if (!(await prisma.meal.findUnique({ where: { id } }))) {
      throw new Error("Meal ID does not exist.");
    }
    if (isNaN(rating)) {
      throw new Error("Cannot Add Meal Rating. No Rating in the Body.");
    }
    if (typeof rating !== "number" || rating > 5 || rating < 1) {
      throw new Error("Cannot Add Meal Rating. Invalid Rating [1-5].");
    }

    return await prisma.meal.update({
      where: { id },
      data: { satisfaction: rating },
    });
  }

  // ========= PUT METHODS ==============================================================

  async updateMeal(meal, id) {
    if (!id) throw new Error("Missing Meal ID");

    if (
      !(await prisma.meal.findUnique({
        where: { id: id },
      }))
    ) {
      throw new Error("Cannot Add Meal. Meal Does Not Exist.");
      // return "Cannot Add Meal. Invalid Meal ID.";
    }

    if (this.isMealValid(meal)) {
      throw new Error(
        "Cannot Add Meal. Invalid Meal Format or Missing Fields."
      );
    }

    meal.tags = meal.tags.join(",");
    const { id:_, ...mealNoId } = meal;
    console.log(`this is ${id}`);

    const newMeal = await prisma.meal.update({ data: mealNoId, where: { id } });
    if (newMeal)
      return newMeal
  else
      return { errorMessage: 'Unable to update meal. Does not exist.' }
  }

  // ========= DELETE METHODS --=========================================================

  async deleteMeal(id) {
    return await prisma.meal.delete({ where: { id: Number(id) } });
  }

  // ========= HELPER FUNCTIONS =========================================================

  // change comment errors !

  isMealValid(m) {
    if (typeof m.userId !== "number") return "Invalid or missing 'userId'.";
    if (typeof m.title !== "string" || m.title.trim() === "")
      return "Invalid or empty 'title'.";
    if (typeof m.calories !== "number" || m.calories <= 0)
      return "Invalid or non-positive 'calories'.";
    if (typeof m.description !== "string" || m.description.trim() === "")
      return "Invalid or empty 'description'.";
    if (typeof m.image !== "string" || m.image.trim() === "")
      return "Invalid or empty 'image'.";
    if (typeof m.satisfaction !== "number")
      return "'satisfaction' must be a number.";
    if (m.satisfaction < 1 || m.satisfaction > 5)
      return "'satisfaction' must be between 1 and 5.";
    if (!Array.isArray(m.tags)) return "'tags' must be an array.";

    return null;
  }
  isExistingMeal(id, meals) {
    return meals.some((m) => m.id === Number(id));
  }

  getNewMealId(meals) {
    const m = Math.max(...meals.map((m) => m.id)) + 1;
    return m;
  }
}

export default new MealRepo();

/*

JSON replaced w/ Prisma

class MealRepo {
  constructor() {
    this.filePath = path.join(process.cwd(), "app/data/meals.json");
  }
  // ========= GET METHODS ===============================================================

  async getMeals() {
    // returns a list of all meals
    const meals = (await prisma.meal.findMany()).map((m) => ({
      ...m,
      tags: m.tags.split(","),
    }));
    // remember to make the tags back into an array since you have them in db as string
    return meals;
    // const meals = await fs.readJSON(this.filePath);
    // return meals.map((meal) => {
    //   return {
    //     id: meal.id,
    //     userId: meal.userId,
    //     title: meal.title,
    //     tags: meal.tags,
    //     calories: meal.calories,
    //     description: meal.description,
    //     satisfaction: meal.satisfaction,
    //     date: meal.date,
    //     image: meal.image,
    //   };
    // });
  }

  async getMealById(id) {
    // returns a specific meal
    const m = await prisma.meal.findUnique({ where: { id: Number(id) } });
    if (!m) return "Meal Does Not Exist.";
    return {
      ...m,
      tags: m.tags.split(","),
    };
    // const meals = await this.getMeals();
    // // console.log(meals);
    // return meals.find((meal) => meal.id === Number(id));
  }

  async getMealsByTag(tag) {
    // returns meals with this tag
    const meals = await this.getMeals();
    return meals.filter((meal) => meal.tags.includes(tag));
  }

  async getMealsByDate(date) {
    // returns meals logged on specific date YYYY-MM-DD

    return (await this.getMeals()).filter(
      (meal) => new Date(meal.date).toISOString().split("T")[0] === date
    );
  }

  async getMealRatingById(id) {
    // returns this specific meal's rating
    return (await this.getMealById(id)).satisfaction;
  }

  async getMealsSummaryPerTag() {
    // returns total and avgRating per tag
    const meals = await this.getMeals();
    const tags = Array.from(new Set(meals.flatMap((meal) => meal.tags)));

    return await Promise.all(
      tags.map(async (tag) => {
        const mealsByTag = await this.getMealsByTag(tag);
        const total = mealsByTag.length;
        return {
          tag,
          totalMeals: total,
          averageSatisfaction:
            mealsByTag.reduce((sum, meal) => sum + meal.satisfaction, 0) /
            total,
        };
      })
    );
  }

  // ========= POST METHODS =============================================================

  async addMeal(meal) {
    if (this.isMealValid(meal)) {
      throw new Error("Cannot Add Meal. Invalid Meal Format or Missing Fields");
    }
    meal.tags = meal.tags.join(",");
    return await prisma.meal.create({ data: meal });

    // const meals = await this.getMeals();
    // const newMeal = {
    //   id: this.getNewMealId(meals),
    //   userId: meal.userId,
    //   title: meal.title.trim(),
    //   satisfaction: meal.satisfaction,
    //   tags: meal.tags,
    //   calories: meal.calories,
    //   description: meal.description.trim(),
    //   date: meal.date,
    //   image: meal.image.trim(),
    // };
    // meals.push(newMeal);
    // await fs.writeJSON(this.filePath, meals);

    // return "Created Meal Successfully!";
  }
  s;
  async addSatisfactionRating({ rating }, mealId) {
    const id = Number(mealId);
    if (!(await prisma.meal.findUnique({ where: { id } }))) {
      throw new Error("Meal ID does not exist.");
    }
    if (isNaN(rating)) {
      throw new Error("Cannot Add Meal Rating. No Rating in the Body.");
    }
    if (typeof rating !== "number" || rating > 5 || rating < 1) {
      throw new Error("Cannot Add Meal Rating. Invalid Rating [1-5].");
    }

    return await prisma.meal.update({
      where: { id },
      data: { satisfaction: rating },
    });
  }

  // ========= PUT METHODS ==============================================================

  async updateMeal(meal, id) {
    if (!(await prisma.meal.findUnique({ where: { id } }))) {
      throw new Error("Cannot Add Meal. Meal Does Not Exist.");
      // return "Cannot Add Meal. Invalid Meal ID.";
    }
    if (this.isMealValid(meal)) {
      throw new Error(
        "Cannot Add Meal. Invalid Meal Format or Missing Fields."
      );
      // return "Cannot Add Meal. Invalid Meal Format or Missing Fields.";
    }
    meal.tags = meal.tags.join(",");
    console.log(meal);

    return await prisma.meal.update({ data: meal, where: { id } });

    // const meals = await this.getMeals();
    // const index = meals.findIndex((m) => m.id == mealId);
    // if (index >= 0) {
    //   meal.id = mealId;
    //   meals[index] = meal;
    //   await fs.writeJSON(this.filePath, meals);
    //   return "Updated Meal Successfully!";
    // }
    // return "Unable to Update Meal. Meal Does not exist";
  }

  // ========= DELETE METHODS --=========================================================

  async deleteMeal(id) {
    return  await prisma.meal.delete({ where: { id: Number(id) } });
    // "Deleted Meal Successfully!";
    // const meals = await this.getMeals();
    // const index = meals.findIndex((m) => m.id == id);
    // if (index >= 0) {
    //   meals.splice(index, 1);
    //   await fs.writeJSON(this.filePath, meals);
    //   return "Deleted Meal Successfully!";
    // }
    // return "Delete Unsuccessful. Meal Does not exist";
  }

  // ========= HELPER FUNCTIONS =========================================================

  isMealValid(m) {
    return (
      typeof m.userId !== "number" ||
      typeof m.title !== "string" ||
      typeof m.calories !== "number" ||
      typeof m.description !== "string" ||
      typeof m.image !== "string" ||
      typeof m.satisfaction !== "number" ||
      m.satisfaction < 1 ||
      m.satisfaction > 5 ||
      m.calories <= 0 ||
      m.title.trim() === "" ||
      m.description.trim() === "" ||
      m.image.trim() === "" ||
      !m.image.startsWith("http") ||
      !Array.isArray(m.tags) ||
      isNaN(Date.parse(m.date))
    );
  }

  isExistingMeal(id, meals) {
    // console.log(meals.map((m) => m.id).includes(id));
    return meals.some((m) => m.id === Number(id));
  }

  getNewMealId(meals) {
    // console.log(meals);
    const m = Math.max(...meals.map((m) => m.id)) + 1;
    // console.log(m);
    return m;
  }
}

export default new MealRepo();

*/
