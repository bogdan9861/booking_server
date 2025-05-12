const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

async function removeUserFromPlaceAfterExpiration() {
  try {
    const now = new Date();

    // Находим все бронирования, срок которых истек
    const expiredBookings = await prisma.placeToUser.findMany({
      where: {
        endDate: {
          lte: now,
        },
      },
    });

    for (const booking of expiredBookings) {
      if (booking) {
        await prisma.placeToUser.delete({
          where: {
            id: booking.id,
          },
        });

        console.log(
          `Removed user ${booking.userId} from place related to booking ${booking.id}`
        );
      }
    }

    console.log("Finished removing users from places after expiration.");
  } catch (error) {
    console.error("Error removing users from places after expiration:", error);
  } finally {
    await prisma.$disconnect();
  }
}

module.exports = {
  removeBook: removeUserFromPlaceAfterExpiration,
};
