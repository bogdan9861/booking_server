/*
  Warnings:

  - The primary key for the `PlaceToUser` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - Added the required column `id` to the `PlaceToUser` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_PlaceToUser" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "userId" INTEGER NOT NULL,
    "placeId" INTEGER NOT NULL,
    "days" INTEGER NOT NULL,
    "startDate" DATETIME,
    "endDate" DATETIME,
    CONSTRAINT "PlaceToUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PlaceToUser_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES "Place" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_PlaceToUser" ("days", "endDate", "placeId", "startDate", "userId") SELECT "days", "endDate", "placeId", "startDate", "userId" FROM "PlaceToUser";
DROP TABLE "PlaceToUser";
ALTER TABLE "new_PlaceToUser" RENAME TO "PlaceToUser";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
