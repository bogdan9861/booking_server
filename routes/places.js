const express = require("express");
const router = express.Router();

const fileMiddleware = require("../middleware/file");
const { auth } = require("../middleware/auth");
const { create, book, getAll, remove } = require("../controllers/places");

router.post("/", auth, fileMiddleware.single("image"), create);
router.post("/book", auth, book);
router.get("/", auth, getAll);
router.delete("/", auth, remove);

module.exports = router;
