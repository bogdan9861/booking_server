const { prisma } = require("../prisma/prisma.client");
const { removeBook } = require("../utils/removeUserFromPlaceAfterExpiration");

const sec = 1000;
const min = sec * 60;
const hour = min * 60;

setInterval(() => {
  removeBook();
}, hour * 12);

const create = async (req, res) => {
  try {
    const { name, description, price, location } = req.body;
    const file = req.file;

    if (!name || !description || !price || !location || !file) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const place = await prisma.place.create({
      data: {
        name,
        description,
        location,
        price: +price,
        image: file?.path || "",
      },
    });

    res.status(201).json(place);
  } catch (error) {
    res.status(500).json({ message: "Unknown server error" });
  }
};

const getAll = async (req, res) => {
  try {
    const places = await prisma.place.findMany({
      where: {
        PlaceToUser: {
          none: {
            endDate: {
              gt: new Date(),
            },
          },
        },
      },
      include: {
        PlaceToUser: {
          include: {
            user: {
              include: {
                PlaceToUser: false,
              },
            },
          },
        },
      },
    });

    res.status(200).json(places);
  } catch (error) {
    console.log(error);

    res.status(500).json({ message: "Unknown server error" });
  }
};

const remove = async (req, res) => {
  try {
    const { id } = req.params;

    const place = await prisma.place.delete({
      where: {
        id: +id,
      },
    });

    res.status(204).json({ status: "success" });
  } catch (error) {
    res.status(500).json({ message: "Unknown server error" });
  }
};

const book = async (req, res) => {
  try {
    const { placeId, days } = req.body;

    if (!placeId || !days) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const now = new Date();
    const endDate = new Date(now);
    endDate.setDate(now.getDate() + days);

    const alreadyBooked = await prisma.placeToUser.findFirst({
      where: {
        placeId: +placeId,
        endDate: {
          gt: now,
        },
      },
    });

    if (alreadyBooked) {
      return res.status(400).json({ message: "This place is already booked." });
    }

    const booking = await prisma.placeToUser.create({
      data: {
        days: +days,
        placeId: +placeId,
        userId: req.user.id,
        startDate: now,
        endDate,
      },
    });

    res.status(201).json(booking);
  } catch (error) {
    console.log(error);

    res.status(500).json({ message: "Unknown server error" });
  }
};

const getMy = async (req, res) => {
  try {
    const places = await prisma.place.findMany({
      where: {
        PlaceToUser: {
          some: {
            userId: req.user.id,
            endDate: {
              gt: new Date(),
            },
          },
        },
      },
      include: {
        PlaceToUser: {
          include: {
            place: false,
            user: false,
          },
        },
      },
    });

    res.status(200).json(places);
  } catch (error) {
    res.status(500).json({ message: "Unknown server error" });
  }
};

module.exports = {
  create,
  remove,
  getAll,
  book,
  getMy,
};
