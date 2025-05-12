/*
  Warnings:

  - Added the required column `days` to the `PlaceToUser` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_PlaceToUser" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "userId" INTEGER NOT NULL,
    "placeId" INTEGER NOT NULL,
    "days" INTEGER NOT NULL,
    CONSTRAINT "PlaceToUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PlaceToUser_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES "Place" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_PlaceToUser" ("id", "placeId", "userId") SELECT "id", "placeId", "userId" FROM "PlaceToUser";
DROP TABLE "PlaceToUser";
ALTER TABLE "new_PlaceToUser" RENAME TO "PlaceToUser";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
