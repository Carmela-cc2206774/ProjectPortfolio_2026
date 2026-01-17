import { PrismaClient } from "@prisma/client";
import fs from "fs-extra";
import path from "path";

// you run this seed once to load the json files in the database
// run prisma studio to view tables

const prisma = new PrismaClient();
const mealFilePath = path.join(process.cwd(), "app/data/meals.json");

async function seed() {
  console.log("Connecting to Database. Loading Data.");

  const meals = await fs.readJSON(mealFilePath);
  for (const meal of meals) {
    meal.tags = meal.tags.join(",");
    await prisma.meal.create({
      data: meal,
    });
  }
}

seed()
  .catch((err) => {
    console.error(err);
  })
  .finally(async () => {
    await prisma.$disconnect();
    console.log("Seeding Completed. Disconnecting from Database.");
  });
