import { Schema, model } from "mongoose";

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
  // userId of the user who added the product
  sellerId: {
    type: String,
    ref: "User",
    required: true,
  },
});

const Product = model("Product", productSchema);
export default Product;
