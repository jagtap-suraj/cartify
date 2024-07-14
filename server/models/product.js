import { Schema, model } from "mongoose";
import ratingSchema from "./rating.js";

const productSchema = Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  images: [
    {
      type: String,
      required: true,
    },
  ],
  quantity: {
    type: Number,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  ratings: [ratingSchema],
  // userId of the user who added the product
  sellerId: {
    type: String,
    ref: "User",
    required: true,
  },
});

const Product = model("Product", productSchema);
export { productSchema };
export default Product;
