/*
  Warnings:

  - Added the required column `description` to the `Place` table without a default value. This is not possible if the table is not empty.
  - Added the required column `location` to the `Place` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `Place` table without a default value. This is not possible if the table is not empty.
  - Added the required column `price` to the `Place` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "PlaceToUser" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "userId" INTEGER NOT NULL,
    "placeId" INTEGER NOT NULL,
    CONSTRAINT "PlaceToUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PlaceToUser_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES "Place" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Place" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "location" TEXT NOT NULL
);
INSERT INTO "new_Place" ("id") SELECT "id" FROM "Place";
DROP TABLE "Place";
ALTER TABLE "new_Place" RENAME TO "Place";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
