import { Schema, model } from "mongoose";
import { productSchema } from "./product.js";

// Create a schema for the user.
const userSchema = Schema({
  name: {
    required: true,
    type: String,
    trim: true, // remove the leading and the trailing spaces
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: (value) => {
      const re =
        /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i; // Regular expression for validating email.
      return value.match(re); // match function returns null if the value does not match the regular expression.
    },
    message: "Invalid Email Address",
  },
  password: {
    required: true,
    type: String,
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default: "user",
  },
  cart: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
});

const User = model("User", userSchema); // Create a model named User from the userSchema.
export default User; // Export the User model.
