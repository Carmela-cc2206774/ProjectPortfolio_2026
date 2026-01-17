/*
  Warnings:

  - Added the required column `userId` to the `meal` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_meal" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "userId" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "tags" TEXT NOT NULL,
    "calories" TEXT NOT NULL,
    "satisfaction" INTEGER NOT NULL,
    "date" TEXT NOT NULL,
    "image" TEXT NOT NULL
);
INSERT INTO "new_meal" ("calories", "date", "id", "image", "satisfaction", "tags", "title") SELECT "calories", "date", "id", "image", "satisfaction", "tags", "title" FROM "meal";
DROP TABLE "meal";
ALTER TABLE "new_meal" RENAME TO "meal";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
