import { Schema } from "mongoose";

const ratingSchema = Schema({
  userId: {
    type: String,
    ref: "User",
    required: true,
  },
  rating: {
    type: Number,
    required: true,
  },
});

export default ratingSchema;
