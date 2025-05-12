/*
  Warnings:

  - You are about to drop the column `endDate` on the `Place` table. All the data in the column will be lost.
  - You are about to drop the column `startDate` on the `Place` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "PlaceToUser" ADD COLUMN "endDate" DATETIME;
ALTER TABLE "PlaceToUser" ADD COLUMN "startDate" DATETIME;

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Place" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "location" TEXT NOT NULL,
    "image" TEXT NOT NULL
);
INSERT INTO "new_Place" ("description", "id", "image", "location", "name", "price") SELECT "description", "id", "image", "location", "name", "price" FROM "Place";
DROP TABLE "Place";
ALTER TABLE "new_Place" RENAME TO "Place";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
