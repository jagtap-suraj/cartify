import { Router } from "express";
import Joi from "joi";
import Product from "../models/product.js";
import authMiddleware from "../middlewares/authMiddleware.js";
import User from "../models/user.js";

const userRouter = Router();

// Define a schema to validate the request body and the request parameters for the add to cart and remove from cart routes.
// const cartSchema = Joi.object({
//   productId: Joi.string().required(),
//   quantity: Joi.number().optional(),
// });

// If the cart is not empty, it checks whether the product is already in the cart.
// It iterates through the cart items, checking if any item's product ID matches the ID of the product to be added.
// If found (isProductFound becomes true), it means the product is already in the cart.
// If the product is found in the cart, it finds that specific cart item and increments its quantity by 1.
// If the product is not found in the cart, it adds the product to the cart with a quantity of 1.
userRouter.post(
  "/api/products/addtocart/:productId",
  authMiddleware,
  async (req, res) => {
    // const { error } = cartSchema.validate(req.params);
    // if (error) {
    //   return res.status(422).json({ error: error.details[0].message });
    // }
    try {
      const { productId } = req.params;
      const product = await Product.findById(productId);
      if (!product) {
        return res.status(404).json({ error: "Product not found" });
      }
      let user = await User.findById(req.user);

      if (user.cart.length == 0) {
        user.cart.push({ product, quantity: 1 });
      } else {
        let isProductFound = false;
        // Check if the product is already in the cart, if yes, increment the quantity by 1
        for (let i = 0; i < user.cart.length; i++) {
          if (user.cart[i].product._id.equals(product._id)) {
            isProductFound = true;
          }
        }

        if (isProductFound) {
          let producttt = user.cart.find((productt) =>
            productt.product._id.equals(product._id)
          );
          producttt.quantity += 1;
        } else {
          user.cart.push({ product, quantity: 1 });
        }
      }
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

// It reduces the quantity of the product in the cart by 1.
userRouter.delete(
  "/api/products/reducefromcart/:productId",
  authMiddleware,
  async (req, res) => {
    // const { error } = cartSchema.validate(req.params);
    // if (error) {
    //   return res.status(422).json({ error: error.details[0].message });
    // }
    try {
      const { productId } = req.params;
      const product = await Product.findById(productId);
      if (!product) {
        return res.status(404).json({ error: "Product not found" });
      }
      let user = await User.findById(req.user);
      let isProductFound = false;
      // Check if the product is already in the cart, if yes, decrement the quantity by 1
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        // if the quantity of the product is greater than 1. If so, it decrements the quantity by 1.
        // If the quantity of the product is exactly 1, it removes the product from the cart.
        if (producttt.quantity > 1) {
          producttt.quantity -= 1;
        } else {
          user.cart = user.cart.filter(
            (productt) => !productt.product._id.equals(product._id)
          );
        }
      }
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

// Delete the given product from the cart.
userRouter.delete(
  "/api/products/removefromcart/:productId",
  authMiddleware,
  async (req, res) => {
    // const { error } = cartSchema.validate(req.params);
    // if (error) {
    //   return res.status(422).json({ error: error.details[0].message });
    // }
    try {
      const { productId } = req.params;
      const product = await Product.findById(productId);
      if (!product) {
        return res.status(404).json({ error: "Product not found" });
      }
      let user = await User.findById(req.user);
      let isProductFound = false;
      // Check if the product is already in the cart, if yes, remove the product from the cart
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        user.cart = user.cart.filter(
          (productt) => !productt.product._id.equals(product._id)
        );
      }
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

// Empty the cart.
userRouter.delete(
  "/api/products/emptycart",
  authMiddleware,
  async (req, res) => {
    try {
      let user = await User.findById(req.user);
      user.cart = [];
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

export default userRouter;
