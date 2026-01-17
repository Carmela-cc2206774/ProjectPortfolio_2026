-- CreateTable
CREATE TABLE "meal" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "tags" TEXT NOT NULL,
    "calories" TEXT NOT NULL,
    "satisfaction" INTEGER NOT NULL,
    "date" TEXT NOT NULL,
    "image" TEXT NOT NULL
);
