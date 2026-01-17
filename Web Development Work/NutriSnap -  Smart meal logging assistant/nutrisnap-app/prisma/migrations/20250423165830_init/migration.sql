/*
  Warnings:

  - You are about to alter the column `calories` on the `meal` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_meal" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "userId" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "tags" TEXT NOT NULL,
    "calories" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "satisfaction" INTEGER NOT NULL,
    "date" TEXT NOT NULL,
    "image" TEXT NOT NULL
);
INSERT INTO "new_meal" ("calories", "date", "description", "id", "image", "satisfaction", "tags", "title", "userId") SELECT "calories", "date", "description", "id", "image", "satisfaction", "tags", "title", "userId" FROM "meal";
DROP TABLE "meal";
ALTER TABLE "new_meal" RENAME TO "meal";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
